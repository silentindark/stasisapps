package helpers

import (
	//"encoding/xml"
	//"encoding/json"
	"database/sql"
	"log"
	"strings"

	_ "github.com/go-sql-driver/mysql" //Used for SQL NullSTRING handlers
	"github.com/jmoiron/sqlx"
)

var db *sqlx.DB

//MysqlInfo Struct Object
type MysqlInfo struct {
	Host     string `json:"host"`
	Port     string `json:"port"`
	User     string `json:"user"`
	Password string `json:"password"`
	Database string `json:"database"`
}

//VoicemailConfigs -- Pointing to Sound Files used as default prompts for Voicemail in platform
type VoicemailConfigs struct {
	ID                        sql.NullString `db:"id"`
	ClientID                  sql.NullString `db:"clientid"`
	Domain                    sql.NullString `db:"domain"`
	MaxVoicemailMessages      sql.NullInt32  `db:"maxVoicemailMessages"`      /*9: Maximum Number of new/unread voicemails allowed per user - global voicemail parameter*/
	Unavailable               sql.NullString `db:"unavailableSound"`          /*System_Sounds.file_ID for default greeting 'the user is unavailable leave a message after the beep'*/
	MaxRecordingLength        sql.NullString `db:"maxRecordingLength"`        /*Length in seconds for the message/vm to be recorded, if not specified then its pulled from pbxSettings table*/
	RecordAfterSound          sql.NullString `db:"recordAfterSound"`          /*System_Sounds.file_ID for 'Please record your message after the beep'*/
	VoicemailRecordedPromptID sql.NullString `db:"voicemailRecordedPromptID"` /*System_Sounds.file_ID for 'Message Saved'*/
	RecordingMenuPromptID     sql.NullString `db:"recordingMenuPromptID"`     /*System_Sounds.file_ID for 'Press 1 to listen to your message, 2 to re-record your message and 3 to mark it as urgent'*/
	RecordMsgKey              sql.NullString `db:"recordMsgKey"`              /*2: DTMF key in case use wants to record again*/
	ListenMsgKey              sql.NullString `db:"listenMsgKey"`              /*1: DTMF key in case user wants to Listen to the recorded message*/
	HighPrioKey               sql.NullString `db:"highPrioKey"`               /*3: DTMF key to be matched in case caller wants to mark the recorded VM as High priority*/
	LimitReachedPromptID      sql.NullString `db:"limitReachedPromptID"`      /*System_Sounds.file_ID for 'The voicemail box is full, can not record message at this time'*/

	EnterPINSound         sql.NullString `db:"enterPinSoundID"`       /*System_Sounds.file_ID for 'please Enter your Voicemail PIN'*/
	PinRetries            sql.NullInt32  `db:"pinRetries"`            /*3, if not set then global pbxSettings table is used */
	YouGotPromptID        sql.NullString `db:"youGotPromptID"`        /*System_Sounds.file_ID for 'You've Got'*/
	NewMsgPromptID        sql.NullString `db:"newMsgPromptID"`        /*System_Sounds.file_ID for 'New-Voicemails'*/
	OldMsgPromptID        sql.NullString `db:"oldMsgPromptID"`        /*System_Sounds.file_ID for 'Old Voicemails'*/
	SavedMsgPromptID      sql.NullString `db:"savedMsgPromptID"`      /*System_Sounds.file_ID for 'Saved Voicemails'*/
	RetrieveMsgsMenuID    sql.NullString `db:"retrieveMsgsMenuID"`    /*System_Sounds.file_ID for 'to listen to new msgs press 1, for old msgs 2, and to listen to saved msgs pres 3'*/
	NewMsgKey             sql.NullString `db:"newMsgKey"`             /*DTMF input Key to be used to Start playback of NEW voicemails msgs*/
	OldMsgKey             sql.NullString `db:"oldMsgKey"`             /*DTMF input Key to be used to Start playback of OLD voicemails msgs*/
	SavedMsgKey           sql.NullString `db:"savedMsgKey"`           /*DTMF input Key to be used to Start playback of SAVED voicemails msgs*/
	FirstMsgPromptID      sql.NullString `db:"firstMsgPromptID"`      /*System_Sounds.file_ID for 'Heres your first voicemail message'*/
	NextMsgPromptID       sql.NullString `db:"nextMsgPromptID"`       /*System_Sounds.file_ID for 'next voicemail message'*/
	NoNewMsgsPromptID     sql.NullString `db:"noNewMsgsPromptID"`     /*System_Sounds.file_ID for 'No new messages at this time' */
	EndOfMessagesPromptID sql.NullString `db:"endOfMessagesPromptID"` /*System_Sounds.file_ID for 'You've reached the end of your voicemail messages*/
	SaveOrDeletePromptID  sql.NullString `db:"saveOrDeletePromptID"`  /*System_Sounds.file_ID for 'To Save this Voicemail Press 1, to Delete it press 2'*/
	DeleteMsgKey          sql.NullString `db:"deleteMsgKey"`          /*2; DTMF input key to be matched in case user wants to delete a voicemail*/
	MsgDeletedPromptID    sql.NullString `db:"msgDeletedPromptID"`    /*System_Sounds.file_ID for 'Ok we've deleted this voicemail'*/
	SaveMsgKey            sql.NullString `db:"saveMsgKey"`            /*1; DTMF key to be matched in case user selected to Save a voicemail*/
	MsgSavedPromptID      sql.NullString `db:"msgSavedPromptID"`      /*System_Sounds.file_ID for 'Message marked as saved'*/
	MessagesPromptID      sql.NullString `db:"messagesPromptID"`      /*System_Sounds.file_ID for word 'Messages'*/

	ListenVmailID                     sql.NullString `db:"ListenVmailID"`             /*System_Sounds.file_ID for*/
	VmailSetupPromptID                sql.NullString `db:"vmSetupPromptID"`           /*System_Sounds.file_ID for 'To Change your PIN press1, to setup your Greeting prompt press2'*/
	ChangePinKey                      sql.NullString `db:"changePinKey"`              /*1*/
	SetupGreetingKey                  sql.NullString `db:"setupGreetingKey"`          /*2*/
	EnterNewPINSound                  sql.NullString `db:"enterNewPinPromptID"`       /*System_Sounds.file_ID for 'Please enter New Voicemail PIN'*/
	InvalidPinPromptID                sql.NullString `db:"invalidPinPromptID"`        /*System_Sounds.file_ID for 'Your PIN doesn't match try again' */
	PinUpdatedPromptID                sql.NullString `db:"pinUpdatedPromptID"`        /*System_Sounds.file_ID for 'Your voicemail PIN has been updated'*/
	ListenRecordVmailGreetingPromptID sql.NullString `db:"listenRecordVmailPromptID"` /*System_Sounds.file_ID for 'To record a greeting message press 1, to listen to your greeting press 2, to save your recorded greeting press 3'*/
	RecordGreetingKey                 sql.NullString `db:"recordGreetingKey"`         /*1*/
	SaveGreetingKey                   sql.NullString `db:"saveGreetingKey"`           /*3*/
	ListenRecordedGreetingKey         sql.NullString `db:"listenRecordedGreetingKey"` /*2*/

	SetupGreetingPromptID sql.NullString `db:"setupGreetingPromptID"` /*System_Sounds.file_ID for*/
	ChangePinPromptID     sql.NullString `db:"changePinPromptID"`     /*System_Sounds.file_ID for 'Please enter New Pin'*/
	VoicemailMenuIVR      sql.NullString `db:"voicemailIvrID"`        /*Not used : Potentially to be used when Voicemail is configured as an IVR in next release */

}

//FeatureCode -- Loads up Feature code info if dialled extension matches code
type FeatureCode struct {
	ID            sql.NullString `db:"id"`
	ClientID      sql.NullString `db:"clientid"`
	Code          sql.NullString `db:"code"`
	Application   sql.NullString `db:"application"`
	ApplicationID sql.NullString `db:"applicationID"`
	AppAction     sql.NullString `db:"applicationAction"`
	ExtraInfo     sql.NullString `db:"extraInfo"`
}

//VoicemailFile -- Holds info about the voicemail File for saving/retrieving
type VoicemailFile struct {
	ID            sql.NullInt32  `db:"id"`
	Caller        sql.NullString `db:"caller"`
	Extension     sql.NullString `db:"destination"`
	Domain        sql.NullString `db:"domain"`
	ClientID      sql.NullString `db:"clientid"`
	VmailFilePath sql.NullString `db:"voicemailFile"`
	RecordedAt    sql.NullTime   `db:"recordedAt"`
	Status        sql.NullString `db:"status"`
	MessageLength sql.NullString `db:"duration"`
}

//VmailCounts -- holds user's voicemail coutns loaded from DB
type VmailCounts struct {
	ID     sql.NullInt32  `db:"id"`
	File   sql.NullString `db:"voicemailFile"`
	Status sql.NullString `db:"status"`
}

//DirectorySettings - Collects Application Settigns from DB table Directory where Client_ID = INPUT
type DirectorySettings struct {
	ID                sql.NullInt32  `db:"id"`
	ClientID          sql.NullString `db:"clientid"`
	Promptfileid      sql.NullString `db:"mainPromptID"`
	Inputlength       sql.NullInt32  `db:"inputLength"`
	Retriesallowed    sql.NullInt32  `db:"retriesAllowed"`
	PleasePressfileid sql.NullString `db:"pleasePressPromptID"`
	ToTalkTofileid    sql.NullString `db:"toTalkToPromptID"`
	NumbersFolder     sql.NullString `db:"numbersFolder"`
	SilenceFolder     sql.NullString `db:"silenceFolder"`
	NumbersFilePrefix sql.NullString `db:"numbersFilePrefix"`
	NotFoundFileid    sql.NullString `db:"notFoundPromptID"`
	InputWaitTimer    sql.NullInt32  `db:"inputWaitTimer"`
	InterDigitTimer   sql.NullInt32  `db:"interDigitTimer"`
	MaxDigitTimeout   sql.NullInt32  `db:"maxDigitTimeout"`
	MinInputLength    sql.NullInt32  `db:"minInputLength"`
}

//Subscriber - Collects Application Settigns from DB table Directory where Client_ID = INPUT
type Subscriber struct {
	ID                  sql.NullInt32  `db:"id"`
	ClientID            sql.NullString `db:"clientid"`
	Username            sql.NullString `db:"username"`
	Domain              sql.NullString `db:"domain"`
	NameFileID          sql.NullString `db:"greeetingfile"`
	RingTimeout         sql.NullString `db:"ringTimeout"`
	VoicemailFlag       sql.NullString `db:"voicemailEnabled"`
	VoicemailGreetingID sql.NullString `db:"voicemailGreetingFileID"`
	VoicemailPin        sql.NullString `db:"voicemailPin"`
}

//GlobalParams - Loads up global parameters for this Stasis Application
type GlobalParams struct {
	ID                      sql.NullInt32  `db:"id"`
	StasisAppName           sql.NullString `db:"stasisAppName"`
	StasisUserName          sql.NullString `db:"stasisUserName"`
	StasisPassword          sql.NullString `db:"stasisPassword"`
	StasisURL               sql.NullString `db:"stasisURL"`
	NATSURL                 sql.NullString `db:"natsURL"`
	StasisWebsockURL        sql.NullString `db:"stasisWebsockURL"`
	RecordingPath           sql.NullString `db:"recordingPath"`
	MaxRetryCount           sql.NullString `db:"maxRetryCount"`
	VoicemailPath           sql.NullString `db:"voicemailPath"`
	DefaultLanguageColumn   sql.NullString `db:"defaultLanguageColumn"`
	MaxVmailRecordingLength sql.NullInt32  `db:"maxVmailRecordingLength"`
}

//Directory holds the Name of a user of a particular client
type Directory struct {
	ID           sql.NullInt32  `db:"id"`
	FirstName    string         `db:"firstname"`
	LastName     string         `db:"lastname"`
	Extension    string         `db:"username"`
	GreetingFile sql.NullString `db:"greeetingfile"`
}

//IVR holds the Name of a user of a particular client
type IVR struct {
	ID               sql.NullInt32  `db:"id"`
	ClientID         sql.NullInt32  `db:"ClientID"`
	Name             sql.NullString `db:"Name"`
	DTMFLength       sql.NullInt32  `db:"DTMFLength"`
	TerminatorChar   sql.NullString `db:"TerminatorChar"`
	IVRSoundID       sql.NullString `db:"IVRSoundID"`
	TimeoutSoundID   sql.NullString `db:"TimeoutSoundID"`
	InvalidSoundID   sql.NullString `db:"InvalidSoundID"`
	Status           sql.NullString `db:"Status"`
	LookupExtensions sql.NullString `db:"LookupExtensions"`
	IVRcounter       sql.NullString `db:"ivr_counter"`
	TimeoutApp       sql.NullString `db:"TimeoutApp"`
	TimeoutAppID     sql.NullString `db:"TimeoutAppID"`
	InputTimer       sql.NullInt32  `db:"InputTimer"`
	TimeoutRetries   sql.NullInt32  `db:"TimeoutRetries"`
	InvalidRetries   sql.NullInt32  `db:"InvalidRetries"`
	InvalidApp       sql.NullString `db:"InvalidApp"`
	InvalidAppID     sql.NullString `db:"InvalidAppID"`
}

//ClientCallSetup - Pulls Client settings from DB for DID
type ClientCallSetup struct {
	ClientID       string `db:"ClientID"`
	EntryApp       string `db:"EntryApp"`
	EntryAppID     string `db:"EntryAppID"`
	AppAction      string
	ExtraInfo      string
	LanguageColumn string
}

//DbInfo - MysqlInfo Struct holding the connection details of MySQL
var DbInfo MysqlInfo

//ConnectDB - Connects to the Provided MySQL DB Host using the info provided
func ConnectDB(host, port, user, pass, name string) error {

	DbInfo.Host = host
	DbInfo.Port = port
	DbInfo.User = user
	DbInfo.Password = pass
	DbInfo.Database = name
	return connectDB()
}

//connectDB is a local function that makes a connection to the db,
func connectDB() error {

	info := DbInfo.User + ":" + DbInfo.Password + "@tcp(" + DbInfo.Host + ":" + DbInfo.Port + ")/" + DbInfo.Database

	var err error
	db = sqlx.MustConnect("mysql", info)

	return err
}

//Ping - test function to validate connectivity to the MYSQL Server
func Ping() error {
	var err error
	err = db.Ping()
	if err != nil {
		log.Printf("MySQl Connection Ping Failed Err:%s\n", err)
	}
	// if no error. Ping is successful
	log.Println("[MAIN] Ping to database successful, connection is still alive")
	return err
}

//CloseDB - used when we're shutting down the application to properly dispose Off the pointer
func CloseDB() {
	db.Close()
}

//GetDirectory - pulls Names belonging to a certina clientid from subcriber table
func GetDirectory(clientid string) ([]Directory, error) {
	list := []Directory{}
	log.Printf("[GetDirectory] Loading Directory for ClientID:%s\n", clientid)
	err := db.Select(&list, "SELECT id,firstname,lastname,username,greeetingfile from subscriber where clientid = ?", clientid)
	if err != nil {
		log.Printf("[GetDirectory] Unable to prepare Query Error:%s\n", err)
		return nil, err
	}
	return list, nil
}

//GetDirectorySettings -- finds out all settings for cloud directory application of a given ClientID
func GetDirectorySettings(clientid string) (DirectorySettings, error) {
	var clientSettings DirectorySettings
	err := db.QueryRowx("SELECT * from Directory WHERE clientid = ?", clientid).StructScan(&clientSettings)

	if err != nil {
		log.Printf("[GetDirectorySettings] Unable to Scan/Query:%s\n", err)
		return clientSettings, err
	}
	if !clientSettings.Inputlength.Valid {
		clientSettings.Inputlength.Int32 = 3
	}
	if !clientSettings.Retriesallowed.Valid {
		clientSettings.Retriesallowed.Int32 = 3
	}
	return clientSettings, err
}

//LoadGlobalSettings -- Loads Global parameters from the Database
func LoadGlobalSettings() (GlobalParams, error) {
	var PbxSettings GlobalParams
	err := db.QueryRowx("SELECT * from pbxSettings").StructScan(&PbxSettings)

	if err != nil {
		log.Printf("[GetDirectorySettings] Unable to Scan/Query:%s\n", err)
		return PbxSettings, err
	}
	return PbxSettings, nil
}

//GetClientSettings -- finds out EntryApp related settigns for an incoming DID
func GetClientSettings(dnis string) (ClientCallSetup, error) {
	var EntryRoute ClientCallSetup
	err := db.QueryRowx("SELECT ClientID,EntryApp,EntryAppID from InboundRoutes WHERE DidNumber = ?", dnis).StructScan(&EntryRoute)
	if err != nil {
		log.Printf("[GetClientSettings] Unable to Scan/Query:%s\n", err)
		return EntryRoute, err
	}
	return EntryRoute, err
}

//GetSubscriberDetails -- finds out EntryApp related settigns for an incoming DID
func GetSubscriberDetails(extenid string) (Subscriber, error) {
	var UserInfo Subscriber
	err := db.QueryRowx("SELECT clientid,username,domain,greeetingfile,ringTimeout,voicemailEnabled,voicemailGreetingFileID from subscriber WHERE id = ?", extenid).StructScan(&UserInfo)
	if err != nil {
		log.Printf("[GetSubscriberDetails] Unable to Scan/Query:%s\n", err)
		return UserInfo, err
	}
	return UserInfo, err
}

//GetLanguage -- finds out EntryApp related settigns for an incoming DID
func GetLanguage(clientid, langid string) (ClientCallSetup, string, error) {
	var langColumn string
	var NextApplication ClientCallSetup
	row := db.QueryRow("SELECT languageSet,NextApp, NextAppID from Languages where clientid = ? AND languageID = ?", clientid, langid)
	err := row.Scan(&langColumn, &NextApplication.EntryApp, &NextApplication.EntryAppID)
	if err != nil {
		log.Printf("[GetLanguage] Unable to Scan/Query:%s\n", err)
		return NextApplication, langColumn, err
	}

	return NextApplication, langColumn, err
}

//GetSubscriberDetailsByNumber -- finds out EntryApp related settigns for an incoming DID
func GetSubscriberDetailsByNumber(extension string, domain string) (Subscriber, error) {
	var UserInfo Subscriber
	err := db.QueryRowx("SELECT id,clientid,username,domain,greeetingfile,ringTimeout,voicemailEnabled,voicemailGreetingFileID,voicemailPin from subscriber WHERE username = ? AND domain = ?", extension, domain).StructScan(&UserInfo)
	if err != nil {
		log.Printf("[GetSubscriberDetails] Unable to Scan/Query:%s\n", err)
		return UserInfo, err
	}
	return UserInfo, err
}

//GetIVRSettings -- finds out EntryApp related settigns for an incoming DID
func GetIVRSettings(data *ClientCallSetup) (IVR, error) {
	var IVRData IVR
	err := db.QueryRowx("SELECT * from IVRs WHERE ClientID = ? AND id = ?", data.ClientID, data.EntryAppID).StructScan(&IVRData)
	if err != nil {
		log.Printf("[GetIVRSettings] Unable to Scan/Query:%s\n", err)
		return IVRData, err
	}
	return IVRData, err
}

//GetFeatureCode -- finds out Feature related settings for an incoming call
func GetFeatureCode(data *ClientCallSetup, dnis string) (FeatureCode, error) {
	var Fcode FeatureCode
	err := db.QueryRowx("SELECT * from featureCodes WHERE clientid = ? AND code = ?", data.ClientID, dnis).StructScan(&Fcode)
	if err != nil {
		log.Printf("[GetFeatureCode] Unable to Scan/Query:%s\n", err)
		return Fcode, err
	}
	return Fcode, err
}

//LoadVoicemails -- finds out EntryApp related settigns for an incoming DID
func LoadVoicemails(user string, clientid string) ([]VmailCounts, error) {
	var Vmails []VmailCounts
	err := db.Select(&Vmails, "SELECT id,voicemailFile,status from voicemails WHERE clientid = ? AND destination = ?", clientid, user)
	if err != nil {
		log.Printf("[GetIVRSettings] Unable to Scan/Query:%s\n", err)
		return Vmails, err
	}
	return Vmails, err
}

//UpdateVoicemailPin - Updates Voicemail Pin of a user.
func UpdateVoicemailPin(userid int, field string, value string) error {
	log.Printf("[Update-Voicemail-Pin] Updating UserID: %d Voicemail Field:%s value:%s\n", userid, field, value)
	_, err := db.NamedExec("UPDATE subscriber SET voicemailPin=:Pin WHERE id=:ID",
		map[string]interface{}{
			"ID":  userid,
			"Pin": value,
		})
	return err
}

//UpdateVoiceMessageStatus - changes the state of a given voicemail id
func UpdateVoiceMessageStatus(id int, newState string) error {
	log.Printf("[Update-Voicemail-Status] Updating State to:%s For vmail ID:%d\n", newState, id)
	_, err := db.NamedExec("UPDATE voicemail SET status=:Status WHERE id=:ID",
		map[string]interface{}{
			"ID":     id,
			"Status": newState,
		})
	return err
}

//GetVoicemailSettings -- finds out EntryApp related settigns for an incoming DID
func GetVoicemailSettings(data *ClientCallSetup, domain string) (VoicemailConfigs, error) {
	var VMData VoicemailConfigs
	err := db.QueryRowx("SELECT * from voicemailSettings WHERE clientid = ? AND domain = ?", data.ClientID, domain).StructScan(&VMData)
	if err != nil {
		log.Printf("[GetIVRSettings] Unable to Scan/Query:%s\n", err)
		return VMData, err
	}
	return VMData, err
}

//IVRGetNextApp -- Ginds out the Application where this given INPUT
func IVRGetNextApp(dtmf string, ivrid string, clientid string) (ClientCallSetup, error) {
	var IVRData ClientCallSetup
	var app, appid string
	row := db.QueryRow("SELECT Application, ApplicationID from IVRsData WHERE ClientID = ? AND DTMF = ? AND IVR_ID = ?", clientid, dtmf, ivrid)
	err := row.Scan(&app, &appid)
	if err != nil {
		log.Printf("[IVRGetNextApp] Unable to Scan/Query:%s\n", err)
		return IVRData, err
	}
	IVRData.EntryApp = app
	IVRData.EntryAppID = appid
	return IVRData, err
}

//DetectAreaCode -- finds out if an Area Code needs special routing
func DetectAreaCode(calleridNum string) (ClientCallSetup, error) {
	var EntryRoute ClientCallSetup
	err := db.QueryRowx("SELECT OnMatchApp,OnMatchAppID from matchAreaCodes WHERE AreaCode = ?", calleridNum[0:3]).StructScan(&EntryRoute)
	if err != nil {
		log.Printf("[GetClientSettings] Unable to Scan/Query:%s\n", err)
		return EntryRoute, err
	}
	return EntryRoute, err
}

//GetFilePath -- pulls out the exact recordinf file location for the given greeting file ID
func GetFilePath(FileID string, languageColumn string) (string, error) {
	var filePath string
	log.Printf("[GetFilePath] FileID: %s LANGUAGE:%s\n", FileID, languageColumn)
	query := "SELECT " + languageColumn + " from System_Sounds where file_ID = ?"
	row := db.QueryRow(query, FileID)
	err := row.Scan(&filePath)
	if err != nil {
		log.Printf("[GetFilePath] Unable to Scan/Query:%s\n", err)
		return filePath, err
	}

	return strings.TrimSuffix(filePath, ".wav"), err
}

//GetFilePathByName -- pulls out the recordind file location for the given greeting file Name
func GetFilePathByName(Name string, languageColumn string) (string, error) {
	var filePath string
	log.Printf("[GetFilePathByName] File Name: %s LANGUAGE:%s\n", Name, languageColumn)
	query := "SELECT " + languageColumn + " from System_Sounds where file_Name = ?"
	row := db.QueryRow(query, Name)
	err := row.Scan(&filePath)
	if err != nil {
		log.Printf("[GetFilePathByName] Unable to Scan/Query:%s\n", err)
		return filePath, err
	}

	return strings.TrimSuffix(filePath, ".wav"), err
}

//GetAnnouncement -- pulls out the exact recording file location for the given greeting file ID
func GetAnnouncement(FileID string, clientid string, languageColumn string) (string, ClientCallSetup, error) {
	var filePath, EntryApp, EntryAppID string
	log.Printf("[GetSoundFile] LANGUAGE:%s\n", languageColumn)
	var EntryRoute ClientCallSetup
	query := "SELECT " + languageColumn + ",Dest_After_Play, Dest_After_Play_ID from System_Sounds where file_ID = ? AND Client_ID = ?"
	row := db.QueryRow(query, FileID, clientid)
	err := row.Scan(&filePath, &EntryApp, &EntryAppID)
	if err != nil {
		log.Printf("[GetAnnouncement] Unable to Scan/Query:%s\n", err)
		return filePath, EntryRoute, err
	}
	EntryRoute.EntryApp = EntryApp
	EntryRoute.EntryAppID = EntryAppID
	return strings.TrimSuffix(filePath, ".wav"), EntryRoute, err
}

//QueryTable - Generic Function to query a given table and return the desired fields
func QueryTable(fieldsNvalues map[string]interface{}, fullQuery string) map[string]interface{} {
	log.Printf("[QueryTable] Query:%s with FieldsMap:%+v\n", fullQuery, fieldsNvalues)
	rows, err := db.NamedQuery(fullQuery, fieldsNvalues)
	if err != nil {
		log.Printf("[QueryTable] Failed to Execute Generic DB Query, Err:%s\n", err)
	}

	defer rows.Close()
	var data = make(map[string]interface{})
	for rows.Next() {
		err := rows.MapScan(data)
		if err != nil {
			log.Printf("[QueryTable] Failed to Scan the Resulted Map Err:%s\n", err)
		}
	}
	return data
}

//SaveVoicemail - Inserts Recording file info into the voicemail table._
func SaveVoicemail(Fileinfo VoicemailFile) error {

	log.Printf("[InsertVoicemail] Inserting Into DB:%#v\n", Fileinfo)
	_, err := db.NamedExec("INSERT INTO voicemails(caller,destination, domain,clientid, voicemailFile,recordedAt, status,duration) VALUES (:Caller, :Destination, :Domain, :Clientid, :VoicemailFile, :RecordedAt, :Status, :Duration)",
		map[string]interface{}{
			"Caller":        Fileinfo.Caller.String,
			"Destination":   Fileinfo.Extension.String,
			"Domain":        Fileinfo.Domain.String,
			"Clientid":      Fileinfo.ClientID.String,
			"VoicemailFile": Fileinfo.VmailFilePath.String,
			"RecordedAt":    Fileinfo.RecordedAt.Time,
			"Status":        Fileinfo.Status.String,
			"Duration":      Fileinfo.MessageLength.String,
		})
	return err
}

//SaveVoicemailGreeting - inserts User's Voicemail greeting into System_Sounds table and returns its FileID
func SaveVoicemailGreeting(userid int, greetingfilePath string) (int, error) {
	var id int
	rows, err := db.NamedQuery("INSERT INTO System_Sounds (file_Path) VALUES (:greetingPath) RETURNING file_ID", greetingfilePath)
	// handle err
	if err != nil {
		log.Printf("[SaveVoicemail-Greeting] Unable to Insert greeting file for user:%d into DB[Err:%v]\n", userid, err)
	}
	if rows.Next() {
		rows.Scan(&id)
	}
	_, err = db.NamedExec("UPDATE subscriber SET voicemailGreetingFileID=:Pin WHERE id=:ID",
		map[string]interface{}{
			"ID":  userid,
			"Pin": id,
		})
	return id, err
}
