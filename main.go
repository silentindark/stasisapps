package main

import (
	"StasisPBX/GoARI/helpers"
	"context"
	"encoding/json"
	"io/ioutil"
	golog "log"
	"runtime/debug"
	"strconv"
	"strings"
	"time"

	"github.com/CyCoreSystems/ari"
	"github.com/CyCoreSystems/ari-proxy/client"
	"github.com/CyCoreSystems/ari/client/native"
	"github.com/CyCoreSystems/ari/ext/play"
	"github.com/CyCoreSystems/ari/ext/record"
	"github.com/inconshreveable/log15"
)

var bridge *ari.BridgeHandle
var log = log15.New()
var execComple = make(chan bool)

//Client - ARI client to be used by Application/functions
var Client *client.Client

//ConfigFile - Holding JSON configs into this object to be used by database connector
var ConfigFile Config

//Config - Slice of multiple FS Boxes that will get connected by the autoDial microservice
type Config struct {
	Databases Database `json:"mysql"`
}

//Database - MySQL Database connection string holder
type Database struct {
	Host     string `json:"host"`
	Port     string `json:"port"`
	User     string `json:"user"`
	Password string `json:"password"`
	DBName   string `json:"database"`
}

//Alphabets - DTMF keys and their corresponding Alphabets
var Alphabets = []string{"", "", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"}

//PbxSettings - holds top level settings and defaults for the application
var PbxSettings helpers.GlobalParams

//ReadConfig -- Reads the ESL configs of all FreeSWITCH Servers, ideally should use DB table for this.
func ReadConfig(conf *Config) error {
	jsonFile, err := ioutil.ReadFile("config.json")
	if err != nil {
		golog.Println("[Main] Error Reading Config File 'config.json' ", err)
		return err
	}
	err = json.Unmarshal(jsonFile, conf)
	if err != nil {
		golog.Println("[MAIN] Error! Un-Marshalling JSON file failed", err)
		return err
	}
	return nil
}

func init() {
	// Read Configuration
	err := ReadConfig(&ConfigFile)
	if err != nil {
		golog.Printf("[MAIN] Error initializing config file reader:%v\n", err)
	}
	golog.Printf("[%s] Connecting to MySQL Instance[%s@%s:%s/%s]", ConfigFile.Databases.User, ConfigFile.Databases.Host, ConfigFile.Databases.Port, ConfigFile.Databases.DBName)
	helpers.ConnectDB(ConfigFile.Databases.Host, ConfigFile.Databases.Port, ConfigFile.Databases.User, ConfigFile.Databases.Password, ConfigFile.Databases.DBName)
	helpers.Ping()
	PbxSettings, err = helpers.LoadGlobalSettings()
}
func main() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	native.Logger = log

	// define ARI client for connecting
	// connect
	var err error
	golog.Printf("[MAIN] Connecting to ARI via NATS")
	Client, err = client.New(ctx, client.WithApplication(PbxSettings.StasisAppName.String), client.WithURI(PbxSettings.NATSURL.String), client.WithLogger(log))
	if err != nil {
		log.Error("[MAIN] Failed to build ARI client", "error", err)
		return
	}
	/* Direct connection to Asterisk ARI w/o NATS in the middle
	golog.Printf("[%s] Connecting to ARI")
	Client, err := native.Connect(&native.Options{
		Application:  PbxSettings.StasisAppName.String,
		Username:     PbxSettings.StasisUserName.String,
		Password:     PbxSettings.StasisPassword.String,
		URL:          PbxSettings.StasisURL.String,
		WebsocketURL: PbxSettings.StasisWebsockURL.String,
	})
	if err != nil {
		log.Error("[%s] Failed to connect ARI client with Asterisk Server", "error", err)
		return
	}
	*/
	golog.Printf("[%s] Starting main processor", PbxSettings.StasisAppName.String)
	sub := Client.Bus().Subscribe(nil, "StasisStart")

	for {
		select {
		case e := <-sub.Events():
			v := e.(*ari.StasisStart)
			golog.Printf("[%s] launching dialplan for new call", PbxSettings.StasisAppName.String)
			go app(ctx, Client.Channel().Get(v.Key(ari.ChannelKey, v.Channel.ID)), v.Args)
		case <-ctx.Done():
			return
		}
	}
}

func app(ctx context.Context, channel *ari.ChannelHandle, Args []string) {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[%s] Panic! Recovered", PbxSettings.StasisAppName.String, string(debug.Stack()), r)
		}
	}()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	data, err := channel.Data()
	if err != nil {
		golog.Printf("[%s]failed to Collect Channel's Data stream error:%v", PbxSettings.StasisAppName.String, err)
		return
	}
	dnis, err := channel.GetVariable("EXTEN")
	if err != nil {
		// Can;'t do if we dont have the destination number to process
		golog.Printf("Failure to determine DNIS Number: %v !", err)
		golog.Printf("[%s] Unknown DNIS - FAILURE ON CHANNEL:%s\n", PbxSettings.StasisAppName.String, channel.ID())
		return
	}

	callerid := data.GetCaller()
	domain, _ := channel.GetVariable("CALLERDOMAIN")

	language, lanerr := channel.GetVariable("LANGUAGE")
	if lanerr != nil {
		golog.Printf("[%s] NO Language Profile pre-set using default", PbxSettings.StasisAppName.String)
		language = PbxSettings.DefaultLanguageColumn.String
	} else {
		golog.Printf("[%s] Language Profile set Reusing the Selection as:%s", PbxSettings.StasisAppName.String, language)
	}
	// Subscribe to END event, so if user hangsup the call we can finish this ARI code
	end := channel.Subscribe(ari.Events.StasisEnd)
	defer end.Cancel()
	//Subscribe to users DTMF keys for the whole call
	userInput := channel.Subscribe(ari.Events.ChannelDtmfReceived)
	defer userInput.Cancel()

	// End the app when the channel goes away
	go func() {
		<-end.Events()
		cancel()
	}()

	golog.Printf("[%s] Started PBX App for channel:%s\n", PbxSettings.StasisAppName.String, dnis)
	golog.Printf("[%s] Started PBX App from caller:%s\n", PbxSettings.StasisAppName.String, callerid.Number)
	golog.Printf("[%s] Started PBX App domain:%s\n", PbxSettings.StasisAppName.String, domain)

	//Check if the Caller party is a Known User of a Known Domain/Client
	var localCaller bool
	var ClientSettings helpers.ClientCallSetup
	var AreaCodeSettings helpers.ClientCallSetup
	ClientSettings.LanguageColumn = language
	// Load Callers info from the Database - only if its a PBX user
	callerInfo, err := helpers.GetSubscriberDetailsByNumber(callerid.Number, domain)
	if err != nil {
		golog.Printf("[%s] Unable to locate caller details, probably coming in from PSTN", PbxSettings.StasisAppName.String)
	} else {
		golog.Printf("[%s] local caller: %s dialled: %s ClientID:%s\n", PbxSettings.StasisAppName.String, callerid.Number, dnis, callerInfo.ClientID.String)
		localCaller = true
		ClientSettings.ClientID = callerInfo.ClientID.String
	}

	// Load Inbound Callroute settings based on Dialled DestinationNumber
	DIDClientSettings, err := helpers.GetClientSettings(dnis)
	if err != nil {
		//Check if the Destination Number is a Valid Local user for the Calling Domain !
		if !localCaller {
			//Caller was coming from PSTN and the DNIS is unknown to us so we can't do anything anymore
			golog.Printf("[%s] Failure to Load Client Settings based on DNIS & ANI !", PbxSettings.StasisAppName.String)
			golog.Printf("[%s] Unknown Client/DID - FAILURE on CHANNEL:%s", PbxSettings.StasisAppName.String, channel.ID())
			channel.Hangup()
			return
		}
		golog.Printf("[%s] PBX User trying to Dial to an Extension OR Application OR Outbound channel:%s\n", PbxSettings.StasisAppName.String, channel.ID())
		//Set default to Outbound and then reduce the scope of the call i.e Extension call or Feature Code
		ClientSettings.EntryApp = "Outbound"
		ClientSettings.EntryAppID = dnis
		destinationIno, err := helpers.GetSubscriberDetailsByNumber(dnis, domain)
		if err != nil {
			golog.Printf("[%s] PBX User trying to Dial Application OR Outbound channel:%s\n", PbxSettings.StasisAppName.String, channel.ID())
		} else {
			//Destination is known to be an Extension
			ClientSettings.EntryApp = "Extension"
			ClientSettings.EntryAppID = strconv.Itoa(int(destinationIno.ID.Int32))
		}
	} else {
		if !localCaller {
			//Load up DID's Client-ID here since the caller was coming from PSTN
			ClientSettings.ClientID = DIDClientSettings.ClientID
			ClientSettings.LanguageColumn = DIDClientSettings.LanguageColumn
		}
		ClientSettings.EntryApp = DIDClientSettings.EntryApp
		ClientSettings.EntryAppID = DIDClientSettings.EntryAppID
	}

	golog.Printf("[%s] set ChanVar CLIENTID channel:%s\n", PbxSettings.StasisAppName.String, ClientSettings.ClientID)
	channel.SetVariable("CLIENTID", ClientSettings.ClientID)
	if ClientSettings.EntryApp == "" || ClientSettings.EntryAppID == "" {
		golog.Printf("[%s] No Entry Route defined - FAILURE ON CHANNEL:%s\n", PbxSettings.StasisAppName.String, channel.ID())
		nextPrio := data.Dialplan.Priority + 1
		channel.Continue(data.Dialplan.Context, data.Dialplan.Exten, int(nextPrio))
		return
	}
	//Everything seems to be intact now start processing the business logic
	channel.Answer()
	if len(Args) > 0 {
		application := Args[0]
		extension := Args[1]
		clientid := Args[2]
		action := Args[3]
		golog.Printf("Execute App[%s] Action[%s] for User:%s Clientid:%s", application, action, extension, clientid)
		ClientSettings.EntryApp = application
		ClientSettings.EntryAppID = extension
		ClientSettings.AppAction = action
		ClientSettings.ExtraInfo = callerid.Number
		Nextapp, _ := ExecuteApplication(ctx, channel, ClientSettings)
		golog.Printf("Immediate App Exec[%s] Completed Next Application:[%s]", application, ClientSettings.EntryApp)
		if Nextapp.EntryApp == "HANGUP" {
			goto CallEnd
		}
	}

	//TODO: AreaCode Matching should now be an Application just like IVR, or Announcement
	// Find AreaCode matches STRICTLY take left-most 3 digits of callerID and process them
	AreaCodeSettings, err = helpers.DetectAreaCode(callerid.Number)
	if err != nil {
		golog.Printf("[%s] No AreaCode explicit routing defined, continue !", PbxSettings.StasisAppName.String)
	}
	if AreaCodeSettings.EntryApp != "" && AreaCodeSettings.EntryAppID != "" {

		ClientSettings.EntryApp = AreaCodeSettings.EntryApp
		ClientSettings.EntryAppID = AreaCodeSettings.EntryAppID
		golog.Printf("[%s] AreaCode Overwrite :: Now Execute Application:%s ID:%s !", PbxSettings.StasisAppName.String, ClientSettings.EntryApp, ClientSettings.EntryAppID)
	}

	//Find if Caller Dialled a Feature Code *97, 911, *97 etc
	detectFeatureCodes(&ClientSettings, dnis, callerid.Number)

	//We MUST have Entry APP and EntryAPP ID at this point for call flow to start
	channel.SetVariable("EntryApp", ClientSettings.EntryApp)
	channel.SetVariable("EntryAppID", ClientSettings.EntryAppID)

	golog.Printf("[%s] Execute Application:%s ID:%s !", PbxSettings.StasisAppName.String, ClientSettings.EntryApp, ClientSettings.EntryAppID)

	//Loop over the Applications until there is no Next Application or its explicitly defined as HANGUP
	for i := 0; ClientSettings.EntryApp != "" || ClientSettings.EntryApp != "HANGUP"; i++ {
		NextApp, err := ExecuteApplication(ctx, channel, ClientSettings)
		if err != nil {
			golog.Printf("[%s] Weird stuff happened while trying to execute %s Application id:%s!\n", PbxSettings.StasisAppName.String, ClientSettings.EntryApp, ClientSettings.EntryAppID)
			goto CallEnd
		}
		ClientSettings.EntryApp = NextApp.EntryApp
		ClientSettings.EntryAppID = NextApp.EntryAppID
		ClientSettings.LanguageColumn = NextApp.LanguageColumn
		//We need to get OUT of this ARI application for "outbound", and "extension" application
		if ClientSettings.EntryApp == "" || ClientSettings.EntryApp == "HANGUP" || ClientSettings.EntryApp == "Extension" || ClientSettings.EntryApp == "Outbound" {
			goto CallEnd
		}
	}
CallEnd:
	golog.Printf("[%s] ARI dialplan Processing finished DATA:%v\n", PbxSettings.StasisAppName.String, data)
	nextPrio := data.Dialplan.Priority + 1
	channel.Continue(data.Dialplan.Context, data.Dialplan.Exten, int(nextPrio))
	return
}
func detectFeatureCodes(ClientSettings *helpers.ClientCallSetup, dnis string, callerid string) {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[detectFeatureCodes] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	FeatureCodeApp, err := helpers.GetFeatureCode(ClientSettings, dnis)
	if err != nil {
		golog.Printf("[detectFeatureCodes] No Featurecode defined for DNIS:%s, continue !", dnis)
	} else {
		if FeatureCodeApp.Application.Valid && FeatureCodeApp.Application.String != "" {
			ClientSettings.EntryApp = FeatureCodeApp.Application.String
		}
		if ClientSettings.EntryApp == "Voicemail" {
			ClientSettings.EntryAppID = callerid
		} else {
			if FeatureCodeApp.ApplicationID.Valid && FeatureCodeApp.ApplicationID.String != "" {
				ClientSettings.EntryAppID = FeatureCodeApp.ApplicationID.String
			}
		}
		if FeatureCodeApp.AppAction.Valid && FeatureCodeApp.AppAction.String != "" {
			ClientSettings.AppAction = FeatureCodeApp.AppAction.String
		}
		if FeatureCodeApp.ExtraInfo.Valid && FeatureCodeApp.ExtraInfo.String != "" {
			ClientSettings.ExtraInfo = FeatureCodeApp.ExtraInfo.String
		}
	}
}

//ExecuteApplication - Executed the desired Application(s)
func ExecuteApplication(ctx context.Context, channel *ari.ChannelHandle, CallRouting helpers.ClientCallSetup) (helpers.ClientCallSetup, error) {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[ExecuteApplication] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	var NextApp helpers.ClientCallSetup
	NextApp.ClientID = CallRouting.ClientID
	NextApp.LanguageColumn = CallRouting.LanguageColumn

	if CallRouting.EntryAppID == "" {
		//Can;t do anything about this anymore, probably go Hangup next in extensions.conf
		NextApp.EntryApp = "HANGUP"
		return NextApp, nil
	}

	if CallRouting.EntryApp == "Voicemail" {
		err := ExecuteVoicemail(ctx, channel, &CallRouting)
		if err != nil {
			log.Error("[ExecuteApplication]failed to Execute IVR Application", "error", err)
			return NextApp, err
		}
		golog.Printf("Voicemail Execution completed", "channel", channel.ID())
		golog.Printf("[ExecuteApplication] NextApplication:%s NextAppID:%s\n", CallRouting.EntryApp, CallRouting.EntryAppID)
		NextApp.EntryApp = CallRouting.EntryApp
		NextApp.EntryAppID = CallRouting.EntryAppID
	}

	if CallRouting.EntryApp == "IVR" {
		err := ExecuteIVR(ctx, channel, &CallRouting)
		if err != nil {
			log.Error("[ExecuteApplication]failed to Execute IVR Application", "error", err)
			return NextApp, err
		}
		golog.Printf("IVR Execution completed", "channel", channel.ID())
		golog.Printf("[ExecuteApplication] NextApplication:%s NextAppID:%s\n", CallRouting.EntryApp, CallRouting.EntryAppID)
		NextApp.EntryApp = CallRouting.EntryApp
		NextApp.EntryAppID = CallRouting.EntryAppID
	}
	//Language Selection and move on
	if CallRouting.EntryApp == "Language" {
		err := SelectLanguage(ctx, channel, &CallRouting)
		if err != nil {
			log.Error("[ExecuteApplication]failed to Execute IVR Application", "error", err)
			return NextApp, err
		}
		golog.Printf("Language selection Execution completed", "channel", channel.ID())
		golog.Printf("[ExecuteApplication] NextApplication:%s NextAppID:%s Language-set to use:%s \n", CallRouting.EntryApp, CallRouting.EntryAppID, CallRouting.LanguageColumn)
		NextApp.EntryApp = CallRouting.EntryApp
		NextApp.EntryAppID = CallRouting.EntryAppID
		NextApp.LanguageColumn = CallRouting.LanguageColumn
	}
	if CallRouting.EntryApp == "Announcement" {
		err := PlayAnnouncement(ctx, channel, &CallRouting)
		if err != nil {
			log.Error("[%s]failed to Execute IVR Application", "error", err)
			return NextApp, err
		}
		golog.Printf("Announcement Execution completed", "channel", channel.ID())
		golog.Printf("[ExecuteApplication] NextApplication:%s NextAppID:%s\n", CallRouting.EntryApp, CallRouting.EntryAppID)
		NextApp.EntryApp = CallRouting.EntryApp
		NextApp.EntryAppID = CallRouting.EntryAppID
	}

	if CallRouting.EntryApp == "Directory" {
		err := CloudDirectory(ctx, channel, &CallRouting)
		if err != nil {
			log.Error("[ExecuteApplication]failed to Execute Cloud Directory Application", "error", err)
			return NextApp, err
		}
		golog.Printf("CloudDirectory Execution completed", "channel", channel.ID())
		golog.Printf("[ExecuteApplication] NextApplication:%s NextAppID:%s\n", CallRouting.EntryApp, CallRouting.EntryAppID)
		NextApp.EntryApp = CallRouting.EntryApp
		NextApp.EntryAppID = CallRouting.EntryAppID
	}

	if CallRouting.EntryApp == "Extension" {
		err := DialExtension(ctx, channel, &CallRouting)
		if err != nil {
			log.Error("[ExecuteApplication]failed to Dial an extension", "error", err)
			return NextApp, err
		}
		golog.Printf("Extension Execution completed", "channel", channel.ID())
		golog.Printf("[ExecuteApplication] NextApplication:%s NextAppID:%s\n", CallRouting.EntryApp, CallRouting.EntryAppID)
		NextApp.EntryApp = CallRouting.EntryApp
		NextApp.EntryAppID = CallRouting.EntryAppID
	}
	if CallRouting.EntryApp == "Outbound" {
		err := DialOutbound(ctx, channel, &CallRouting)
		if err != nil {
			log.Error("[ExecuteApplication]failed to Dial a PSTN Destination", "error", err)
			return NextApp, err
		}
		golog.Printf("[ExecuteApplication] Next Application:%s NextAppID:%s\n", CallRouting.EntryApp, CallRouting.EntryAppID)
		NextApp.EntryApp = CallRouting.EntryApp
		NextApp.EntryAppID = CallRouting.EntryAppID
	}
	return NextApp, nil
}

//DialExtension -- Dials a SIP extension out via OpenSIPS/SIP Proxy trunk.
func DialExtension(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[DialExtension] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	var err error
	var NextApp helpers.ClientCallSetup
	NextApp.ClientID = CallRouting.ClientID
	//Find the destination preferences from the subscriber table
	UserDetails, err := helpers.GetSubscriberDetails(CallRouting.EntryAppID)
	if err != nil {
		golog.Printf("[DialExtension] Unable to Query/Find provided User id:%s", CallRouting.EntryAppID)
	}
	userExten := UserDetails.Username.String
	channel.SetVariable("EntryApp", "Extension")
	channel.SetVariable("EntryAppID", userExten)
	channel.SetVariable("EXTENSION", userExten)
	channel.SetVariable("RINGTIMER", UserDetails.RingTimeout.String)
	channel.SetVariable("VOICEMAIL_ENABLED", UserDetails.VoicemailFlag.String)
	channel.SetVariable("NAMEFILEID", UserDetails.NameFileID.String)
	channel.SetVariable("VMAILGREETINGFILEID", UserDetails.VoicemailGreetingID.String)
	golog.Printf("[DialExtension] Dialing User:%#v:\n", UserDetails)
	CallRouting.EntryApp = "Extension"
	CallRouting.EntryAppID = userExten
	//channel.Continue("Extensions", "s", 1)
	return nil
}

//SelectLanguage -- Sets a language for the channel
func SelectLanguage(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[SelectLanguage] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	//var err error
	NextApp, langColumn, err := helpers.GetLanguage(CallRouting.ClientID, CallRouting.EntryAppID)
	if err != nil {
		golog.Println("[SelectLanguage] Failed to load IVR settings from DB\n", err)
		return err
	}
	CallRouting.EntryApp = NextApp.EntryApp
	CallRouting.EntryAppID = NextApp.EntryAppID
	golog.Printf("[SelectLanguage] We will be using Language Columns:%s", langColumn)
	CallRouting.LanguageColumn = langColumn
	channel.SetVariable("LANGUAGE", langColumn)
	//channel.Continue("Extensions", "s", 1)
	return nil
}

//DialOutbound -- Dials a PSTN extension out via OpenSIPS/SIP Proxy trunk.
func DialOutbound(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[DialOutbound] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	//var err error
	var NextApp helpers.ClientCallSetup
	NextApp.ClientID = CallRouting.ClientID
	dnis, _ := channel.GetVariable("EXTEN")
	CallRouting.EntryApp = "Outbound"
	CallRouting.EntryAppID = dnis
	//Find the Caller's or Client's OUTBOUND preferences from the subscriber table

	golog.Printf("[DialOutbound] We will be dialling OUTBOUND#:%s Application:%s", dnis, CallRouting.EntryApp)

	//SET CHANNEL VARIABLES FOR OUTBOUND CALL
	channel.SetVariable("EntryApp", "Outbound")
	channel.SetVariable("EntryAppID", dnis)
	channel.SetVariable("EXTENSION", dnis)
	golog.Printf("[DialOutbound] Dialing PSTN Destination:%s:\n", dnis)
	//channel.Continue("Extensions", "s", 1)
	return nil
}

//ExecuteIVR - Application to playback IVR functionality. Collects DTMF from user and returns Next Application,IDs
func ExecuteIVR(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[ExecuteIVR] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	var err error
	var res *play.Result
	var playSequence play.OptionFunc
	var NextApp helpers.ClientCallSetup
	NextApp.ClientID = CallRouting.ClientID

	IVRSettings, err := helpers.GetIVRSettings(CallRouting)
	if err != nil {
		golog.Println("[ExecuteIVR] Failed to load IVR settings from DB\n", err)
		return err
	}
	//Clear previous routing Data
	//myApp := CallRouting.EntryApp
	myAppID := CallRouting.EntryAppID
	CallRouting.EntryApp = ""
	CallRouting.EntryAppID = ""
	//
	//golog.Printf("[ExecuteIVR] Loaded IVR Setup from DB %#v:\n", IVRSettings)
	var fileid string
	fileid = IVRSettings.IVRSoundID.String

	golog.Printf("[ExecuteIVR] Collect DTMF length: %d Playing Main Prompt file:%s Language-set:%s\n", IVRSettings.DTMFLength.Int32, IVRSettings.IVRSoundID.String, CallRouting.LanguageColumn)
	SoundPromptLink, err := helpers.GetFilePath(fileid, CallRouting.LanguageColumn)
	if err != nil || SoundPromptLink == "" {
		golog.Printf("[ExecuteIVR] Unable to find Main Prompt file\n")
	} else {
		SoundPromptLink = "sound:" + SoundPromptLink
	}

	golog.Printf("[ExecuteIVR] Playing Main Prompt file: %s\n", SoundPromptLink)
	//Sequence of Sound Files to be played
	playSequence = play.URI(SoundPromptLink)

	//IVR Timer settings.
	maxInputWaitTimer := time.Duration(int(IVRSettings.InputTimer.Int32)) * time.Second
	InputTimerOptions := play.DigitTimeouts(maxInputWaitTimer, 5*time.Second, maxInputWaitTimer)
	NoInputReplays := play.Replays(int(IVRSettings.TimeoutRetries.Int32))
	InvalidRetries := int(IVRSettings.InvalidRetries.Int32)
	dtmfLength := play.MatchLen(int(IVRSettings.DTMFLength.Int32))

retake:
	golog.Printf("[ExecuteIVR] IVR Settings: {NoInputReplays:%v, DTMF Length:%d, MaxInput Wait Timer:%d}\n", NoInputReplays, IVRSettings.DTMFLength.Int32, maxInputWaitTimer)

	res, err = play.Prompt(context.TODO(), channel, playSequence, dtmfLength, InputTimerOptions).Result()
	if err != nil {
		golog.Println("[ExecuteIVR] Failed to play prompt", err)
		return err
	}
	if res.MatchResult == play.Complete || res.DTMF != "" {
		golog.Println("[ExecuteIVR] User Entered Input DTMF as:", res.DTMF)
		// If LookupExtensions is Enabled see if User tried to Dial a SIP Extension.
		if IVRSettings.LookupExtensions.String == "true" {
			domain, _ := channel.GetVariable("CALLERDOMAIN")
			extensionInfo, err := helpers.GetSubscriberDetailsByNumber(res.DTMF, domain)
			if err != nil {
				golog.Printf("[ExecuteIVR] Unable to locate caller details Continue finding DTMF Key destination")
			} else {
				CallRouting.EntryApp = "Extension"
				CallRouting.EntryAppID = strconv.Itoa(int(extensionInfo.ID.Int32))
				return nil
			}
		}
		//Find the Next Application this INPUT key points to
		NextApp, err = helpers.IVRGetNextApp(res.DTMF, myAppID, CallRouting.ClientID)
		if err != nil {
			golog.Println("[ExecuteIVR] Failed to Find next application from DTMF", err)
			//Play Invalid Sound Prompt if any
			InvalidRetries--
			if IVRSettings.InvalidSoundID.Valid && IVRSettings.InvalidSoundID.String != "" {
				PlaySoundFile(IVRSettings.InvalidSoundID.String, CallRouting.LanguageColumn, channel)
			}
			golog.Printf("[ExecuteIVR] Try again please, Attempt#:%d", InvalidRetries)
			if InvalidRetries > 0 {
				goto retake
			}
			golog.Printf("[ExecuteIVR] Invalid Attempts Exceeded !")
			//Return Invalid Input Application if any
			if IVRSettings.InvalidApp.String != "" && IVRSettings.InvalidAppID.Valid {
				CallRouting.EntryApp = IVRSettings.InvalidApp.String
				CallRouting.EntryAppID = IVRSettings.InvalidAppID.String
				golog.Printf("[ExecuteIVR] IVR Input Timeout, Set Invalid App:%s Id: %s\n! ", IVRSettings.TimeoutApp.String, IVRSettings.TimeoutAppID.String)
			}
		} else {
			golog.Printf("[ExecuteIVR] DTMF Input:%s Points to App:%s Id:%s:", res.DTMF, NextApp.EntryApp, NextApp.EntryAppID)
			CallRouting.EntryApp = NextApp.EntryApp
			CallRouting.EntryAppID = NextApp.EntryAppID
		}
		return nil
	}
	//user Entered Nothing, Send back TimeoutApp and TimeoutAppID
	golog.Printf("[ExecuteIVR] TIMEOUT User Entered Input DTMF:%s Res.MatchResult:%v", res.DTMF, res.MatchResult)
	if IVRSettings.TimeoutApp.String != "" && IVRSettings.TimeoutApp.Valid {
		CallRouting.EntryApp = IVRSettings.TimeoutApp.String
		CallRouting.EntryAppID = IVRSettings.TimeoutAppID.String
		golog.Printf("[ExecuteIVR] IVR Input Timeout, Set Timeout App:%s Id: %s\n! ", IVRSettings.TimeoutApp.String, IVRSettings.TimeoutAppID.String)
	}
	return err
}

//PlaySoundFile - Plays Sound file and returns back to the calling function
func PlaySoundFile(fileid string, language string, channel *ari.ChannelHandle) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[PlaySoundFile] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	SoundPromptLink, err := helpers.GetFilePath(fileid, language)
	if err != nil || SoundPromptLink == "" {
		golog.Printf("[PlaySoundFile] Unable to find Main Prompt file\n")
	} else {
		SoundPromptLink = "sound:" + SoundPromptLink
	}

	golog.Printf("[PlaySoundFile] Playing announcement Prompt file: %s\n", SoundPromptLink)
	//Sequence of Sound Files to be played
	playSequence := play.URI(SoundPromptLink)
	InputTimerOptions := play.DigitTimeouts(0, 0, 0)
	_, err = play.Prompt(context.TODO(), channel, playSequence, play.MatchNone(), InputTimerOptions, play.NoExitOnDTMF()).Result()
	if err != nil {
		golog.Println("[PlaySoundFile] Failed to play announcement prompt", err)
		return err
	}
	return nil
}

//PlaySound - Plays Sound file and returns back to the calling function, no DB operation performed
func PlaySound(fileid string, channel *ari.ChannelHandle) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[PlaySound] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	SoundPromptLink := "sound:" + fileid

	golog.Printf("[PlaySound] Playing Sound Prompt file: %s\n", SoundPromptLink)
	//Sequence of Sound Files to be played
	playSequence := play.URI(SoundPromptLink)
	InputTimerOptions := play.DigitTimeouts(0, 0, 0)
	_, err := play.Prompt(context.TODO(), channel, playSequence, InputTimerOptions, play.MatchNone(), play.NoExitOnDTMF()).Result()
	if err != nil {
		golog.Println("[PlaySound] Failed to play announcement prompt", err)
		return err
	}
	return nil
}

//PlayVoicemailFile - Plays Sound file and returns back to the calling function
func PlayVoicemailFile(vmfile string, channel *ari.ChannelHandle) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[PlayVoicemailFile] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	//Sequence of Sound Files to be played
	playSequence := play.URI("sound:" + vmfile)
	_, err := play.Prompt(context.TODO(), channel, playSequence, play.MatchAny()).Result()
	if err != nil {
		golog.Println("[PlayVoicemailFile] Failed to play voicemail message", err)
		return err
	}
	return nil
}

//PlayAnnouncement - Plays Sound file and returns back to the calling function along with new Destination set
func PlayAnnouncement(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[PlayAnnouncement] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	SoundPromptLink, NextApp, err := helpers.GetAnnouncement(CallRouting.EntryAppID, CallRouting.ClientID, CallRouting.LanguageColumn)
	if err != nil || SoundPromptLink == "" {
		golog.Printf("[ExecuteIVR] Unable to find Sound Prompt file\n")
	} else {
		SoundPromptLink = "sound:" + SoundPromptLink
	}

	CallRouting.EntryApp = NextApp.EntryApp
	CallRouting.EntryAppID = NextApp.EntryAppID

	golog.Printf("[PlayAnnouncement] Playing Sound Prompt file: %s\n", SoundPromptLink)
	//Sequence of Sound Files to be played
	playSequence := play.URI(SoundPromptLink)
	//Disable any Timers for DTMF; No need to wait for any expecting DTMF key presses
	InputTimerOptions := play.DigitTimeouts(0, 0, 0)

	_, err = play.Prompt(context.TODO(), channel, playSequence, play.MatchNone(), InputTimerOptions, play.NoExitOnDTMF()).Result()
	if err != nil {
		golog.Println("[PlayAnnouncement] Failed to play prompt", err)
		return err
	}

	return nil
}

//CloudDirectory - Dial by Last name application
func CloudDirectory(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[CloudDirectory] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	//Prepare DTMF alphabets
	var keymap map[string]string
	keymap = make(map[string]string)
	for index, value := range Alphabets {
		keymap[strconv.Itoa(index)] = value
	}
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	var inputDTMF string
	//var inputDTMFs int
	var matchedNames []helpers.Directory

	end := channel.Subscribe(ari.Events.StasisEnd)
	defer end.Cancel()

	userInput := channel.Subscribe(ari.Events.ChannelDtmfReceived)
	defer userInput.Cancel()

	// End the app when the channel goes away
	go func() {
		<-end.Events()
		cancel()
	}()
	var res *play.Result
	clientid := CallRouting.ClientID
	DirectoryOptions, err := helpers.GetDirectorySettings(clientid)
	if err != nil {
		golog.Printf("Failed to get Settings for Application - FAILURE")
		golog.Printf("[CloudDirectory] Settings Not Found in DB - FAILURE ", "channel", channel.ID())
		return nil
	}

	golog.Printf("[CloudDirectory] Settings Found in DB: %#v\n", DirectoryOptions)
	var retryCount int
	retryC := DirectoryOptions.Retriesallowed
	if retryC.Valid {
		retryCount = int(retryC.Int32)
	} else {
		retryCount = 3 // TODO: pull from table Directory.maxRetryCount
	}
	inputLength := DirectoryOptions.Inputlength

	allNames, _ := helpers.GetDirectory(clientid)

	//Collect DTMF for the Last Name here

	var MainSoundFileLink, NameNotFoundFileLink string

	if DirectoryOptions.Promptfileid.Valid {
		MainSoundFileLink, err = helpers.GetFilePath(DirectoryOptions.Promptfileid.String, CallRouting.LanguageColumn)
		if err != nil || MainSoundFileLink == "" {
			golog.Printf("[CloudDirectory] Unable to find Main Prompt file !!:\n")
		} else {
			MainSoundFileLink = "sound:" + MainSoundFileLink
		}
	}
	if DirectoryOptions.NotFoundFileid.Valid {
		NameNotFoundFileLink, err = helpers.GetFilePath(DirectoryOptions.NotFoundFileid.String, CallRouting.LanguageColumn)
		if err != nil || NameNotFoundFileLink == "" {
			golog.Printf("[CloudDirectory] Unable to find No Names Found Prompt file\n")
		} else {
			NameNotFoundFileLink = "sound:" + NameNotFoundFileLink
		}
	}
	var playSequence play.OptionFunc
	golog.Printf("[CloudDirectory] Collect DTMF length: %d Playing Main Prompt file:%s\n", inputLength.Int32, MainSoundFileLink)
	playSequence = play.URI(MainSoundFileLink)
getDTMF:
	res, err = play.Prompt(context.TODO(), channel, playSequence, play.MatchLenOrTerminator(int(inputLength.Int32), "#")).Result()
	if err != nil {
		golog.Println("Failed to play prompt", err)
		return err
	}
	if res.MatchResult == play.Complete {
		golog.Println("[CloudDirectory] User Entered Last Name DTMF as:", res.DTMF)
		if res.DTMF == "" || res.DTMF == "*" {
			retryCount--
			if retryCount < 0 {
				goto NotPossible
			}
			goto getDTMF
		} else {
			inputDTMF = res.DTMF
			inputDTMF = strings.TrimSuffix(inputDTMF, "#")
		}
	}
	golog.Printf("[CloudDirectory] Given ClientID:%s LastName Keys:%s\n", clientid, inputDTMF)

	// Cant do anything if the length of DTMF entered is less than 3 !
	if len(inputDTMF) < int(DirectoryOptions.MinInputLength.Int32) {
		channel.SetVariable("DIRECTORYSTATUS", "SHORTINPUT")
		if NameNotFoundFileLink != "" {
			res, err = play.Prompt(context.TODO(), channel, play.URI(NameNotFoundFileLink)).Result()
			if err != nil {
				golog.Println("[CloudDirectory] Failed to play NoName Found prompt", err)
			}
		}
		goto NotPossible
	}

	for _, Name := range allNames {
		thisLName := Name.LastName
		var insertFlag bool
		insertFlag = true

		for c := 0; c < len(inputDTMF); c++ {
			golog.Printf("[CloudDirectory] Testing DTMF Keypress:%s Pointing to AlphabetSeq:%s with Name:%s char:%s\n", string(inputDTMF[c]), keymap[string(inputDTMF[c])], thisLName, string(thisLName[c]))
			if !strings.ContainsAny(keymap[string(inputDTMF[c])], strings.ToUpper(string(thisLName[c]))) {
				insertFlag = false
			}
		}
		if insertFlag {
			//golog.Printf("Name:%s Matched ALL of the DTMF Keymap:%s%s%s\n", thisLName, keymap[string(inputDTMF[0])], keymap[string(inputDTMF[1])], keymap[string(inputDTMF[2])])
			golog.Printf("[CloudDirectory] Name Qualified all tests: %s\n", thisLName)
			matchedNames = append(matchedNames, Name)
		}
	}
	// if No Names Matched then return out of there, possibly play a prompt file in there as well.
	if len(matchedNames) <= 0 {
		golog.Printf("[CloudDirectory] No Name Matched Play Prompt: %s\n", NameNotFoundFileLink)
		channel.SetVariable("DIRECTORYSTATUS", "NO RESULTS")
		res, err = play.Prompt(context.TODO(), channel, play.URI(NameNotFoundFileLink)).Result()
		if err != nil {
			golog.Println("[CloudDirectory] Failed to play NoName Found prompt", err)
		}
		goto NotPossible
	}

retry:
	if retryCount == 0 {
		channel.SetVariable("DIRECTORYSTATUS", "TIMEOUT")
		goto NotPossible
	}
	golog.Printf("[CloudDirectory] List of Matched Names for Client:%s :%#v\n", clientid, matchedNames)
	//Next up Play in an IVR format
	for index, Name := range matchedNames {
		if Name.GreetingFile.Valid {
			nameSoundFileLink, err := helpers.GetFilePath(Name.GreetingFile.String, CallRouting.LanguageColumn)
			if err != nil || nameSoundFileLink == "" {
				golog.Printf("[CloudDirectory] Unable to find users Name File recording Skipping Name:%s %s\n", Name.FirstName, Name.LastName)
			} else {
				//We got a File here -- TODO: use Database to pull these file Paths
				pleasePressFile, _ := helpers.GetFilePath(DirectoryOptions.PleasePressfileid.String, CallRouting.LanguageColumn)
				indexedKeyFile, _ := helpers.GetFilePath(strconv.Itoa(index), CallRouting.LanguageColumn)
				toTalktoFile, _ := helpers.GetFilePath(DirectoryOptions.ToTalkTofileid.String, CallRouting.LanguageColumn)

				pleasePress := "sound:" + pleasePressFile
				keyIndex := "sound:" + indexedKeyFile
				forUser := "sound:" + toTalktoFile
				nameFile := "sound:" + nameSoundFileLink
				//var myOptions play.OptionFunc
				if index == len(matchedNames)-1 {
					//last name played from list, append the extra silence to wait for INPUT
					//endSilence := "sound:" + DirectoryOptions.SilenceFolder.Valid + "3"
					playSequence = play.URI(pleasePress, keyIndex, forUser, nameFile) //, endSilence)
				} else {
					playSequence = play.URI(pleasePress, keyIndex, forUser, nameFile)
				}

				myOptions := play.DigitTimeouts(time.Duration(DirectoryOptions.InputWaitTimer.Int32)*time.Second,
					time.Duration(DirectoryOptions.InterDigitTimer.Int32)*time.Second,
					time.Duration(DirectoryOptions.MaxDigitTimeout.Int32)*time.Second)

				res, err = play.Prompt(context.TODO(), channel,
					playSequence, myOptions,
					play.MatchFunc(func(in string) (string, play.MatchResult) {
						// This is a custom match function which will
						// be run each time a DTMF digit is received
						golog.Printf("[CloudDirectory] User Pressed DTMF Key:%s\n", in)

						//do something with the DTMF pressed during the playback
						//user := db.Lookup(pat)
						return in, play.Complete
					}),
				).Result()
				if err != nil {
					golog.Println("[CloudDirectory] Failed to play prompt", err)
					return err
				}
				if res.MatchResult == play.Complete {
					golog.Println("User DTMF:", res.DTMF)
					if res.DTMF == "" || res.DTMF == "*" {
						retryCount--
						goto retry
					}
					channel.SetVariable("DIRECTORYSTATUS", "SUCCESS")
					if res.DTMF != "*" && res.DTMF != "#" {
						keyExten, _ := strconv.Atoi(res.DTMF)
						if keyExten > len(matchedNames) {
							//User entered Invalid Index do a retry
							golog.Printf("[CloudDirectory] User DTMF[%s] is Invalid Retry COunter decremented and RETRY:", res.DTMF)
							retryCount--
							goto retry

						}
						golog.Printf("[CloudDirectory] User DTMF[%s] Matched Returning with Extension:%s:", res.DTMF, matchedNames[keyExten].Extension)
						channel.SetVariable("DIRECTORYEXTEN", matchedNames[keyExten].Extension)
						CallRouting.EntryApp = "Extension"
						CallRouting.EntryAppID = strconv.Itoa(int(matchedNames[keyExten].ID.Int32))
						goto NotPossible
					}
				}

				if res.DTMF == "#" {
					//User Wants Exit
					goto NotPossible
				}
			}
		}

	}
	golog.Println("User DTMF[2]:", res.DTMF)
	if res.DTMF == "" || res.DTMF == "*" {
		retryCount--
		goto retry
	}
	channel.SetVariable("DIRECTORYSTATUS", "SUCCESS")
	// Lets Create an IVR sort of thing here

NotPossible:
	//resume call to the next index in dialplan
	data, err := channel.Data()
	if err != nil {
		log.Error("[CloudDirectory] failed to Collect Variable", "error", err)
	}
	golog.Printf("[CloudDirectory] completed Directory Call by Name Application", "DATA", data)
	nextPrio := data.Dialplan.Priority + 1
	channel.Continue(data.Dialplan.Context, data.Dialplan.Exten, int(nextPrio))
	return nil

}

//ExecuteVoicemail - Voicemail Application
func ExecuteVoicemail(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) error {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[ExecuteVoicemail] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	//collect user/subscribers details from database i.e greeting file etc and other vmail prefs if any
	domain, _ := channel.GetVariable("CALLERDOMAIN")
	golog.Printf("[ExecuteVoicemail] Application Inputs:%#v\n", CallRouting)

	vmailSetup, err := helpers.GetVoicemailSettings(CallRouting, domain)
	if err != nil {
		golog.Printf("[ExecuteVoicemail] Failed to Load Voicemail Setup from DB Err:%v\n", err)
	}
	golog.Printf("[ExecuteVoicemail] VmailSetup Info:%v\n", vmailSetup)
	vmailuser, err := helpers.GetSubscriberDetailsByNumber(CallRouting.EntryAppID, domain)
	if err != nil {
		golog.Printf("[ExecuteVoicemail] Failed to fetch user's preferences from DB:%v\n", err)
	}
	golog.Printf("[ExecuteVoicemail] User Info:%v\n", vmailuser)

	if strings.Contains(CallRouting.AppAction, "record") {
		voicemailRecord(ctx, vmailSetup, vmailuser, channel, CallRouting)
	} else if strings.Contains(CallRouting.AppAction, "retrieve") {
		voicemailRetrieval(ctx, vmailSetup, vmailuser, channel, CallRouting)
	} else if strings.Contains(CallRouting.AppAction, "setup") {
		voicemailBoxSetup(ctx, vmailSetup, vmailuser, channel, CallRouting)

	}
	CallRouting.EntryApp = "HANGUP"
	CallRouting.EntryAppID = ""
	return nil
}
func countVoicemails(vms []helpers.VmailCounts) (string, int, string, int, string, int) {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[countVoicemails] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	var old, new, saved int
	for _, thisVmail := range vms {
		if thisVmail.Status.String == "new" {
			new++
		}
		if thisVmail.Status.String == "old" {
			old++
		}
		if thisVmail.Status.String == "archived" {
			saved++
		}
	}
	newStr := strconv.Itoa(new)
	oldStr := strconv.Itoa(old)
	savdStr := strconv.Itoa(saved)
	return newStr, new, oldStr, old, savdStr, saved
}

//CollectDTMF - plays a given voiceprompt File and returns the User's DTMF key presses
func CollectDTMF(channel *ari.ChannelHandle, SoundFilePath string, DTMFWidth int, retries int) (string, error) {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[CollectDTMF] Panic! Recovered", string(debug.Stack()), r)
		}
	}()

	golog.Printf("[CollectDTMF] Collect DTMF length: %d Playing Main Prompt file:%s\n", DTMFWidth, SoundFilePath)

	SoundPromptLink := "sound:" + SoundFilePath

	golog.Printf("[CollectDTMF] Playing Main Prompt file: %s\n", SoundPromptLink)
	//Sequence of Sound Files to be played
	playSequence := play.URI(SoundPromptLink)

	NoInputReplays := play.Replays(retries)
	//dtmfLength := play.MatchLen(DTMFWidth)

	res, err := play.Prompt(context.TODO(), channel, playSequence, NoInputReplays, play.MatchLenOrTerminator(DTMFWidth, "#")).Result()
	if err != nil {
		golog.Println("[CollectDTMF] Failed to play prompt", err)
		return "", err
	}

	return res.DTMF, nil
}

//Record - Records a file and returns saved file record back to the calling application
func Record(ctx context.Context, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup, RecFile string, maxRecordingDuration time.Duration) (record.Result, error) {
	defer func() {
		if r := recover(); r != nil {
			golog.Println("[Record] Panic! Recovered", string(debug.Stack()), r)
		}
	}()
	res, err := record.Record(ctx, channel, record.Beep(),
		record.TerminateOn("any"),
		record.IfExists("overwrite"), record.MaxDuration(maxRecordingDuration),
	).Result()

	if err != nil {
		log.Error("[Record] failed to record", "error", err)
		return *res, err
	}

	if err = res.Save(RecFile); err != nil {
		golog.Printf("[Record] failed to save recording err:%v", err)
		return *res, err
	}
	return *res, nil
}
func voicemailBoxSetup(ctx context.Context, vmailSetup helpers.VoicemailConfigs, vmailuser helpers.Subscriber, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) {
	//Record&Change user greetings, Change PIN etc - first get a user's PIN Number
	counter := 0
RetryPIN:
	EnterPINFile, err := helpers.GetFilePath(vmailSetup.EnterPINSound.String, CallRouting.LanguageColumn)
	if err != nil {
		golog.Printf("[voicemail-BoxSetup] Failed to fetch 'Enter PIN' Path from DB Err:%v\n", err)
	}
	// Please Enter your Voicemail PIN
	dtmf, err := CollectDTMF(channel, EnterPINFile, len(vmailuser.VoicemailPin.String), int(vmailSetup.PinRetries.Int32))
	if err != nil {
		golog.Printf("[Voicemail-BoxSetup] Failed to get User PIN:%v\n", err)
	}
	golog.Printf("[Voicemail-BoxSetup] Got User PIN:%s\n", dtmf)
	if strings.Contains(dtmf, "#") {
		dtmf = strings.Replace(dtmf, "#", "", -1)
	}
	//PIN Matched
	if dtmf == vmailuser.VoicemailPin.String {

		golog.Println("[Voicemail-BoxSetup] Run Voicemail Menu for user setup here")
		SetupMenuFile, err := helpers.GetFilePath(vmailSetup.VmailSetupPromptID.String, CallRouting.LanguageColumn)
		//Play sub-menu 'Change your PIN by pressing 1, otherwise press 2 to setup your voicemail greeting'.
		dtmf, err := CollectDTMF(channel, SetupMenuFile, 1, 3)
		if err != nil {
			golog.Printf("[Voicemail-BoxSetup] Failed to get User Input for VoicemailSetup menu:%v\n", err)
		}
		golog.Printf("[Voicemail-BoxSetup] Got User Input as:%s\n", dtmf)
		if strings.Contains(dtmf, "#") {
			dtmf = strings.Replace(dtmf, "#", "", -1)
		}
		if dtmf == vmailSetup.ChangePinKey.String {
			//Please Enter New PIN & reenter NEW PIN
			newPinFile, err := helpers.GetFilePath(vmailSetup.EnterNewPINSound.String, CallRouting.LanguageColumn)
			retryCount := 0
		retry:
			newPINdtmf, err := CollectDTMF(channel, newPinFile, 6, 0)
			if err != nil {
				golog.Printf("[Voicemail-BoxSetup] Failed to get User's new PIN:%v\n", err)
			}
			golog.Printf("[Voicemail-BoxSetup] Got User new PIN:%s\n", newPINdtmf)
			if strings.Contains(newPINdtmf, "#") {
				newPINdtmf = strings.Replace(newPINdtmf, "#", "", -1)
			}
			//Ask to Enter PIN again 'Please enter your PIN'
			dtmf, err := CollectDTMF(channel, EnterPINFile, len(newPINdtmf), 0)
			if err != nil {
				golog.Printf("[Voicemail-BoxSetup] Failed to get User PIN:%v\n", err)
			}
			golog.Printf("[Voicemail-BoxSetup] Got User PIN:%s\n", dtmf)
			if strings.Contains(dtmf, "#") {
				dtmf = strings.Replace(dtmf, "#", "", -1)
			}
			if dtmf == newPINdtmf {
				//PIN Changed Successfully, updateDB
				PlaySoundFile(vmailSetup.PinUpdatedPromptID.String, CallRouting.LanguageColumn, channel)
				helpers.UpdateVoicemailPin(int(vmailuser.ID.Int32), "pin", dtmf)
			} else {
				//Ask to retry this again. Failed to Match
				PlaySoundFile(vmailSetup.InvalidPinPromptID.String, CallRouting.LanguageColumn, channel)
				retryCount++
				if retryCount < 3 {
					goto retry
				}
			}

		}
		if dtmf == vmailSetup.SetupGreetingKey.String {
			// Record Message, and give option to listen & re-record, just like Vmail Message recording
			// Press 1 to record your greeting message, press 2 to listen to your greeting message, pres 3 to save the voicemail greeting message
		setupMenu:
			greetingSetupFile, err := helpers.GetFilePath(vmailSetup.ListenRecordVmailGreetingPromptID.String, CallRouting.LanguageColumn)
			if err != nil {
				golog.Printf("[Voicemail-BoxSetup] Failed to fetch 'Enter PIN' Path from DB Err:%v\n", err)
			}
			dtmf, err := CollectDTMF(channel, greetingSetupFile, len(vmailSetup.RecordGreetingKey.String), int(vmailSetup.PinRetries.Int32))
			if err != nil {
				golog.Printf("[Voicemail-BoxSetup] Failed to get User PIN:%v\n", err)
			}
			golog.Printf("[Voicemail-BoxSetup] Got User Input:%s\n", dtmf)
			if strings.Contains(dtmf, "#") {
				dtmf = strings.Replace(dtmf, "#", "", -1)
			}
			var RecordingFile string
			if dtmf == vmailSetup.RecordGreetingKey.String {
				var maxRecLen time.Duration
				if vmailSetup.MaxRecordingLength.Valid && vmailSetup.MaxRecordingLength.String != "" {
					intRecLength, _ := strconv.Atoi(vmailSetup.MaxRecordingLength.String)
					maxRecLen = time.Duration(intRecLength) * time.Second
				} else {
					maxRecLen = time.Duration(PbxSettings.MaxVmailRecordingLength.Int32) * time.Second
				}
				currentTime := time.Now()
				RecordingFile = "/VMGreetings/" + CallRouting.ClientID + "/" +
					currentTime.Format("2006-01-02_15:04:05") +
					"-Caller:" + CallRouting.ExtraInfo +
					"-Exten:" + CallRouting.EntryAppID
				recordingStatus, err := Record(ctx, channel, CallRouting, RecordingFile, maxRecLen)

				RecordingFile = PbxSettings.RecordingPath.String + RecordingFile
				if err != nil {
					golog.Printf("[Voicemail-BoxSetup] Failed to Record greeting message Err:%v\n", err)
				}
				duration := int64(time.Duration(recordingStatus.Data.Duration) / time.Second)
				strDuration := strconv.Itoa(int(duration))
				golog.Printf("[Voicemail-BoxSetup] Recorded greeting message Length:%s\n", strDuration)
			}
			if dtmf == vmailSetup.ListenRecordedGreetingKey.String {
				if RecordingFile != "" {
					//User has recorded a greeting message so lets play that
					PlaySoundFile(RecordingFile, CallRouting.LanguageColumn, channel)
				} else {
					//User hasn't recorded yet so either we play their older greeting
					PlaySoundFile(vmailuser.VoicemailGreetingID.String, CallRouting.LanguageColumn, channel)
				}
				goto setupMenu
			}
			if dtmf == vmailSetup.SaveGreetingKey.String {
				if RecordingFile != "" {
					RecordingFile = RecordingFile + ".wav"
					fileID, err := helpers.SaveVoicemailGreeting(int(vmailuser.ID.Int32), RecordingFile)
					if err != nil {
						golog.Printf("[Voicemail-BoxSetup] Unable to update Database table with this Greeting File [Err:%v]\n", err)
					} else {
						golog.Printf("[Voicemail-BoxSetup] Saved user greeting fileID:%d\n", fileID)
						//Play prompt 'Your voicemail greeting has been saved'
						PlaySoundFile(vmailSetup.SavedMsgPromptID.String, CallRouting.LanguageColumn, channel)
					}
				}
			}

		}
	} else {
		PlaySoundFile(vmailSetup.InvalidPinPromptID.String, CallRouting.LanguageColumn, channel)
		if counter <= int(vmailSetup.PinRetries.Int32) {
			counter++
			goto RetryPIN
		}
	}
}
func voicemailRecord(ctx context.Context, vmailSetup helpers.VoicemailConfigs, vmailuser helpers.Subscriber, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) {
	var GreetingFile string
	var GreetingLanguage string
	domain, _ := channel.GetVariable("CALLERDOMAIN")
	golog.Printf("[Voicemail-Record] User Info:%v\n", vmailuser)

	// Check count of user voicemails and Match them against the voicemailBox Limit, if limit exceeded then play the Not-Enough-Space prompt & Exit message.
	if vmailuser.VoicemailGreetingID.Valid && vmailuser.VoicemailGreetingID.String != "" {
		GreetingFile = vmailuser.VoicemailGreetingID.String
		GreetingLanguage = PbxSettings.DefaultLanguageColumn.String
	} else {
		GreetingFile = vmailSetup.Unavailable.String
		GreetingLanguage = CallRouting.LanguageColumn
		golog.Printf("[Voicemail-Record] Using Default Greeting:%s\n", GreetingFile)
	}
	// Count User's voicemails if Voicemail Box is full then do not go any further.
	Voicemails, err := helpers.LoadVoicemails(vmailuser.Username.String, CallRouting.ClientID)
	if err != nil {
		golog.Printf("[Voicemail-Record] Failed to load user mails:%v\n", err)
	}
	_, new, _, _, _, _ := countVoicemails(Voicemails)
	if new >= int(vmailSetup.MaxVoicemailMessages.Int32) {
		// user has new voicemail messages that are now exceeding maximum allowed unred voicemail messages, can't record anymore new ones.
		PlaySoundFile(vmailSetup.LimitReachedPromptID.String, GreetingLanguage, channel)
		// FUTURE WORK: trigger for email that his voicemail is full and we couldn't record a message from caller@time.
		return
	}

	// Allowed to record voicemail, now we can play Voicemail greeting for the user.
	PlaySoundFile(GreetingFile, GreetingLanguage, channel)
	var maxRecLen time.Duration
	if vmailSetup.MaxRecordingLength.Valid && vmailSetup.MaxRecordingLength.String != "" {
		intRecLength, _ := strconv.Atoi(vmailSetup.MaxRecordingLength.String)
		maxRecLen = time.Duration(intRecLength) * time.Second
	} else {
		maxRecLen = time.Duration(PbxSettings.MaxVmailRecordingLength.Int32) * time.Second
	}
	currentTime := time.Now()
	RecordingFile := "/Voicemail/" + CallRouting.ClientID + "/" +
		currentTime.Format("2006-01-02_15:04:05") +
		"-Caller:" + CallRouting.ExtraInfo +
		"-Exten:" + CallRouting.EntryAppID
	recordingStatus, err := Record(ctx, channel, CallRouting, RecordingFile, maxRecLen)

	RecordingFile = PbxSettings.RecordingPath.String + RecordingFile + ".wav"
	if err != nil {
		golog.Printf("[Voicemail-Record] Failed to Record message Err:%v\n", err)
	}
	duration := int64(time.Duration(recordingStatus.Data.Duration) / time.Second)
	strDuration := strconv.Itoa(int(duration))
	var FileInfo helpers.VoicemailFile
	FileInfo.Caller.String = CallRouting.ExtraInfo
	FileInfo.Extension.String = CallRouting.EntryAppID
	FileInfo.ClientID.String = CallRouting.ClientID
	FileInfo.Domain.String = domain
	FileInfo.MessageLength.String = strDuration
	FileInfo.RecordedAt.Time = currentTime
	FileInfo.Status.String = "new"
	FileInfo.VmailFilePath.String = RecordingFile
	err = helpers.SaveVoicemail(FileInfo)
	if err != nil {
		golog.Printf("[Voicemail-Record] Failed to Insert Voicemail Record to DB Err:%v\n", err)
	}
	if !(vmailSetup.VoicemailRecordedPromptID.Valid) {
		return
	}
	golog.Printf("[Voicemail-Record] Saved Voicemail at Location:%#v, %#v\n", recordingStatus, recordingStatus.Data)
	PlaySoundFile(vmailSetup.VoicemailRecordedPromptID.String, CallRouting.LanguageColumn, channel)
	RecordMenuFile, err := helpers.GetFilePath(vmailSetup.RecordingMenuPromptID.String, CallRouting.LanguageColumn)
	if err != nil {
		//Play sub-menu 'to Listen to your voicemail press 1, re-record messages press 2 and mark as urgent press 3.
		golog.Printf("[Voicemail-Record] Failed to fetch 'Recording menu' Path from DB Err:%v\n", err)
	}

	dtmf, err := CollectDTMF(channel, RecordMenuFile, len(vmailuser.VoicemailPin.String), int(vmailSetup.PinRetries.Int32))
	if err != nil {
		golog.Printf("[Voicemail-Record] Failed to get User Input:%v\n", err)
	}
	golog.Printf("[Voicemail-Record] Got User PIN:%s\n", dtmf)
	if strings.Contains(dtmf, "#") {
		dtmf = strings.Replace(dtmf, "#", "", -1)
	}
	//PIN Matched
	if dtmf == vmailuser.VoicemailPin.String {
	}
}
func voicemailRetrieval(ctx context.Context, vmailSetup helpers.VoicemailConfigs, vmailuser helpers.Subscriber, channel *ari.ChannelHandle, CallRouting *helpers.ClientCallSetup) {
	// TODO: if caller is unknown then ask for User Number as well.
	counter := 0
RetryPIN:
	EnterPINFile, err := helpers.GetFilePath(vmailSetup.EnterPINSound.String, CallRouting.LanguageColumn)
	if err != nil {
		golog.Printf("[Voicemail-Retrieve] Failed to fetch 'Enter PIN' fileID:%s Path from DB Err:%v\n", vmailSetup.EnterPINSound.String, err)
	}
	RetrievalMenuFile, err := helpers.GetFilePath(vmailSetup.RetrieveMsgsMenuID.String, CallRouting.LanguageColumn)
	if err != nil {
		//Play sub-menu 'to Listen to New messages press 1, old messages, 2 and for saved messages press 3.
		golog.Printf("[Voicemail-Retrieve] Failed to fetch 'Retrive Voicemail menu' Path from DB Err:%v\n", err)
	}
	// Please Enter your Voicemail PIN
	dtmf, err := CollectDTMF(channel, EnterPINFile, len(vmailuser.VoicemailPin.String), int(vmailSetup.PinRetries.Int32))
	if err != nil {
		golog.Printf("[Voicemail-Retrieve] Failed to get User PIN:%v\n", err)
	}
	golog.Printf("[Voicemail-Retrieve] Got User PIN:%s\n", dtmf)
	if strings.Contains(dtmf, "#") {
		dtmf = strings.Replace(dtmf, "#", "", -1)
	}
	//PIN Matched
	if dtmf == vmailuser.VoicemailPin.String {
		golog.Printf("[Voicemail-Retrieve] User PIN Matched %s\n", dtmf)
		Voicemails, err := helpers.LoadVoicemails(CallRouting.EntryAppID, CallRouting.ClientID)
		if err != nil {
			golog.Printf("[Voicemail-Retrieve] Failed to load user mails:%v\n", err)
		}

		var newMessagesCount, oldMessagesCount, savedMessagesCount string
		var msgType, newState string

		if len(Voicemails) > 0 {
			PlaySoundFile(vmailSetup.YouGotPromptID.String, CallRouting.LanguageColumn, channel)
			newstr, new, oldstr, old, savedstr, saved := countVoicemails(Voicemails)
			//PlayVmCounts & Menu.
			golog.Printf("[Voicemail-Retrieve] Loaded User Voicemails:[New:%d, Old:%d,Archived:%d]\n", new, old, saved)
			if new >= 0 {
				newMessagesCount, err = helpers.GetFilePathByName(newstr, CallRouting.LanguageColumn)
				if err != nil {
					golog.Printf("[Voicemail-Retrieve] Failed to fetch 'New Messages Count Digit' Path from DB Err:%v\n", err)
				}
				PlaySound(newMessagesCount, channel)
				PlaySoundFile(vmailSetup.NewMsgPromptID.String, CallRouting.LanguageColumn, channel)
			}

			if old > 0 {
				oldMessagesCount, err = helpers.GetFilePathByName(oldstr, CallRouting.LanguageColumn)
				if err != nil {
					golog.Printf("[Voicemail-Retrieve] Failed to fetch 'Old Messages Count Digit' Path from DB Err:%v\n", err)
				}
				PlaySound(oldMessagesCount, channel)
				PlaySoundFile(vmailSetup.OldMsgPromptID.String, CallRouting.LanguageColumn, channel)
			}
			if saved > 0 {
				savedMessagesCount, err = helpers.GetFilePathByName(savedstr, CallRouting.LanguageColumn)
				if err != nil {
					golog.Printf("[Voicemail-Retrieve] Failed to fetch 'Saved Messages Count Digit' Path from DB Err:%v\n", err)
				}
				PlaySound(savedMessagesCount, channel)
				PlaySoundFile(vmailSetup.SavedMsgPromptID.String, CallRouting.LanguageColumn, channel)
			}
			//Play sub-menu 'to Listen to New messages press 1, old messages, 2 and for saved messages press 3.
			dtmf, err := CollectDTMF(channel, RetrievalMenuFile, 1, 3)
			if err != nil {
				golog.Printf("[Voicemail-Retrieve] Failed to get User Input for Retrieval menu:%v\n", err)
			}
			golog.Printf("[Voicemail-Retrieve] Got User Input as:%s\n", dtmf)
			if strings.Contains(dtmf, "#") {
				dtmf = strings.Replace(dtmf, "#", "", -1)
			}
			if dtmf == vmailSetup.NewMsgKey.String {
				//User wants to Listen to new msgs
				msgType = "new"
			}
			if dtmf == vmailSetup.OldMsgKey.String {
				msgType = "old"
			}
			if dtmf == vmailSetup.SavedMsgKey.String {
				//User wants to Listen to saved msgs
				msgType = "saved"
			}
			for i, thisVmail := range Voicemails {
				if i == 0 {
					PlaySoundFile(vmailSetup.FirstMsgPromptID.String, CallRouting.LanguageColumn, channel)
					//Heres you first message Prompt
				} else {
					PlaySoundFile(vmailSetup.NextMsgPromptID.String, CallRouting.LanguageColumn, channel)
					//next Message
				}
				if thisVmail.Status.String == msgType {
					PlayVoicemailFile(thisVmail.File.String, channel)
				}
				//Present Menu to Delete or Save this message
				subdtmf, err := CollectDTMF(channel, vmailSetup.SaveOrDeletePromptID.String, len(vmailSetup.SavedMsgKey.String), 0)
				if err != nil {
					golog.Printf("[Voicemail-Retrieve] Failed to get User Input for Saving/Deleting the msgs:%v\n", err)
					//The default would be to keep the message in current state
				}
				golog.Printf("[Voicemail-Retrieve] Got Entered:%s\n", subdtmf)
				if strings.Contains(subdtmf, "#") {
					subdtmf = strings.Replace(subdtmf, "#", "", -1)
				}
				if subdtmf == vmailSetup.SaveMsgKey.String {
					//Mark this message as saved i.e state='saved'
					newState = "saved"
					PlaySoundFile(vmailSetup.MsgDeletedPromptID.String, CallRouting.LanguageColumn, channel)

				} else if subdtmf == vmailSetup.DeleteMsgKey.String {
					//Mark this message as deleted i.e state='deleted'
					newState = "deleted"
					PlaySoundFile(vmailSetup.SavedMsgPromptID.String, CallRouting.LanguageColumn, channel)

				} else {
					//Mark this message as read i.e state='old'
					newState = "old"
				}
				uperr := helpers.UpdateVoiceMessageStatus(int(thisVmail.ID.Int32), newState)
				if uperr != nil {
					golog.Printf("[Voicemail-Retrieve] Dialed to update Vmail Status Err:%v\n", err)
				}
			}
			//EndOfMessagesFile
			//You've reached the End of your messages Prompt, Hangup of Press * to return to the main menu
			PlaySoundFile(vmailSetup.EndOfMessagesPromptID.String, CallRouting.LanguageColumn, channel)

		} else {
			//Got No voicemails for this user Play "No new Voicemails" & exit
			golog.Printf("[Voicemail-Retrieve] No Voicemails for this user in DB\n")
			PlaySoundFile(vmailSetup.NoNewMsgsPromptID.String, CallRouting.LanguageColumn, channel)
		}

	} else {
		golog.Printf("[Voicemail-Retrieve] User PIN Not Matched:%s\n", dtmf)
		//PlayPrompt 'you've entered Invalid PIN, please try again'
		PlaySoundFile(vmailSetup.InvalidPinPromptID.String, CallRouting.LanguageColumn, channel)
		if counter <= int(vmailSetup.PinRetries.Int32) {
			counter++
			goto RetryPIN
		}
	}
}
