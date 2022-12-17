-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 10.11.0.8    Database: opensips
-- ------------------------------------------------------
-- Server version	5.5.62-0+deb8u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Dial_list`
--

DROP TABLE IF EXISTS `Dial_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Dial_list` (
  `List_ID` int(3) NOT NULL AUTO_INCREMENT,
  `Client_ID` int(11) NOT NULL DEFAULT '0',
  `List_Name` varchar(25) DEFAULT NULL,
  `List_Lenght` int(1) DEFAULT NULL,
  `Num_1` varchar(15) DEFAULT NULL,
  `Num_2` varchar(15) DEFAULT NULL,
  `Num_3` varchar(15) DEFAULT NULL,
  `Num_4` varchar(15) DEFAULT NULL,
  `Num_5` varchar(15) DEFAULT NULL,
  `No_Ans_App` varchar(25) DEFAULT NULL,
  `No_Ans_App_ID` int(2) DEFAULT NULL,
  `status` int(1) DEFAULT '0',
  `ext_code` varchar(5) DEFAULT '0',
  `rec_flag` varchar(1) DEFAULT '1',
  `outgoing_call` varchar(1) DEFAULT '0',
  `cb_detection` varchar(1) DEFAULT '0',
  `outgoing_recording` varchar(1) DEFAULT '0',
  PRIMARY KEY (`List_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3064 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Dial_list`
--

LOCK TABLES `Dial_list` WRITE;
/*!40000 ALTER TABLE `Dial_list` DISABLE KEYS */;
INSERT INTO `Dial_list` VALUES (1,1,'Receptionist',1,'10025',NULL,NULL,NULL,NULL,'voicemail',1,1,'1','0','0','0','0');
/*!40000 ALTER TABLE `Dial_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Directory`
--

DROP TABLE IF EXISTS `Directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Directory` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `clientid` int(11) NOT NULL DEFAULT '0',
  `mainPromptID` varchar(25) DEFAULT NULL,
  `inputLength` int(1) NOT NULL DEFAULT '4',
  `retriesAllowed` int(1) NOT NULL DEFAULT '3',
  `pleasePressPromptID` varchar(25) DEFAULT NULL,
  `toTalkToPromptID` varchar(25) DEFAULT NULL,
  `notFoundPromptID` varchar(5) DEFAULT NULL,
  `maxRetryCount` varchar(45) NOT NULL DEFAULT '3',
  `minInputLength` int(1) NOT NULL DEFAULT '2',
  `inputWaitTimer` int(1) NOT NULL DEFAULT '3',
  `interDigitTimer` int(1) NOT NULL DEFAULT '3',
  `maxDigitTimeout` int(1) NOT NULL DEFAULT '5',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Directory`
--

LOCK TABLES `Directory` WRITE;
/*!40000 ALTER TABLE `Directory` DISABLE KEYS */;
INSERT INTO `Directory` VALUES (1,1,'14',4,2,'','','9','3',2,7,3,5);
/*!40000 ALTER TABLE `Directory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IVRs`
--

DROP TABLE IF EXISTS `IVRs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IVRs` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `ClientID` int(11) NOT NULL DEFAULT '0',
  `Name` varchar(25) DEFAULT NULL,
  `DTMFLength` int(3) DEFAULT NULL,
  `IVRSoundID` int(3) DEFAULT NULL,
  `TimeoutSoundID` varchar(255) DEFAULT NULL,
  `InvalidSoundID` varchar(255) DEFAULT NULL,
  `Status` int(1) DEFAULT '0',
  `LookupExtensions` enum('true','false') DEFAULT 'false',
  `ivr_counter` varchar(255) DEFAULT '1',
  `TimeoutApp` varchar(30) DEFAULT NULL,
  `TimeoutAppID` varchar(15) DEFAULT NULL,
  `InputTimer` int(3) DEFAULT '6',
  `TimeoutRetries` int(11) DEFAULT '0',
  `InvalidRetries` int(11) DEFAULT '0',
  `InvalidApp` varchar(45) DEFAULT NULL,
  `InvalidAppID` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=213 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IVRs`
--

LOCK TABLES `IVRs` WRITE;
/*!40000 ALTER TABLE `IVRs` DISABLE KEYS */;
INSERT INTO `IVRs` VALUES (1,1,'Welcome SYMACK',1,2,'','2',1,'','2','IVR','1',7,1,0,NULL,NULL),(210,1,'LanguageSelection',1,1,NULL,NULL,0,'','1','IVR','1',7,0,0,NULL,NULL),(211,1,'ExtensionInput',5,3,NULL,NULL,1,'true','1','IVR','1',8,1,0,'IVR','212'),(212,1,'DoesNotExist',4,4,NULL,NULL,1,'','1',NULL,NULL,4,0,0,NULL,NULL);
/*!40000 ALTER TABLE `IVRs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IVRsData`
--

DROP TABLE IF EXISTS `IVRsData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IVRsData` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `IVR_ID` int(3) NOT NULL DEFAULT '0',
  `DTMF` varchar(4) DEFAULT NULL,
  `Application` varchar(25) DEFAULT NULL,
  `ApplicationID` varchar(132) DEFAULT NULL,
  `ClientID` int(11) DEFAULT NULL,
  `previousIVRID` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4166 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IVRsData`
--

LOCK TABLES `IVRsData` WRITE;
/*!40000 ALTER TABLE `IVRsData` DISABLE KEYS */;
INSERT INTO `IVRsData` VALUES (1,1,'0','Extension','4',1,1),(4156,1,'*','IVR','1',1,1),(4157,210,'0','IVR','1',1,210),(4158,1,'2','Announcement','6',1,1),(4159,1,'1','IVR','211',1,1),(4160,211,'100','Extension','4',1,NULL),(4161,211,'123','Extension','4',1,NULL),(4162,211,'1234','Extension','4',1,NULL),(4163,211,'1111','Extension','4',1,NULL),(4164,211,'2','Directory','1',1,NULL),(4165,210,'9','Language','2',1,NULL);
/*!40000 ALTER TABLE `IVRsData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `InboundRoutes`
--

DROP TABLE IF EXISTS `InboundRoutes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `InboundRoutes` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `ClientID` int(11) NOT NULL DEFAULT '0',
  `DidNumber` varchar(25) DEFAULT NULL,
  `EntryApp` varchar(125) DEFAULT NULL,
  `EntryAppID` varchar(132) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=113 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InboundRoutes`
--

LOCK TABLES `InboundRoutes` WRITE;
/*!40000 ALTER TABLE `InboundRoutes` DISABLE KEYS */;
INSERT INTO `InboundRoutes` VALUES (112,1,'5198072240','IVR','210');
/*!40000 ALTER TABLE `InboundRoutes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Languages`
--

DROP TABLE IF EXISTS `Languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `clientid` varchar(45) NOT NULL,
  `language` varchar(45) DEFAULT NULL,
  `languageID` varchar(45) DEFAULT NULL,
  `languageSet` varchar(45) DEFAULT NULL,
  `NextApp` varchar(45) DEFAULT NULL,
  `NextAppID` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Languages`
--

LOCK TABLES `Languages` WRITE;
/*!40000 ALTER TABLE `Languages` DISABLE KEYS */;
INSERT INTO `Languages` VALUES (1,'1','English','1','file_Path','IVR','1'),(2,'1','French','2','file_PathL2','IVR','1');
/*!40000 ALTER TABLE `Languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PAGD`
--

DROP TABLE IF EXISTS `PAGD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PAGD` (
  `PAGD_ID` int(3) NOT NULL AUTO_INCREMENT,
  `Client_ID` int(11) NOT NULL DEFAULT '0',
  `file_Name` varchar(25) DEFAULT NULL,
  `file_Path` varchar(255) DEFAULT NULL,
  `min_digits` varchar(1) DEFAULT '1',
  `max_digits` varchar(14) DEFAULT '1',
  `terminators` varchar(3) DEFAULT '#',
  `inputerroraudiofile` varchar(255) DEFAULT NULL,
  `digit_regex` varchar(10) DEFAULT NULL,
  `transfer_on_failure` varchar(14) DEFAULT '1',
  `max_tries` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`PAGD_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PAGD`
--

LOCK TABLES `PAGD` WRITE;
/*!40000 ALTER TABLE `PAGD` DISABLE KEYS */;
/*!40000 ALTER TABLE `PAGD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `System_Sounds`
--

DROP TABLE IF EXISTS `System_Sounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `System_Sounds` (
  `file_ID` int(3) NOT NULL AUTO_INCREMENT,
  `Client_ID` int(11) NOT NULL DEFAULT '0',
  `file_Name` varchar(25) DEFAULT NULL,
  `upload_file_name` varchar(255) DEFAULT NULL,
  `file_Path` varchar(255) DEFAULT NULL,
  `Dest_After_Play` varchar(25) DEFAULT NULL,
  `Dest_After_Play_ID` varchar(25) DEFAULT NULL,
  `status` int(1) DEFAULT '0',
  `file_size` varchar(255) DEFAULT NULL,
  `catid` int(11) DEFAULT NULL,
  `detail` text,
  `file_PathL2` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`file_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `System_Sounds`
--

LOCK TABLES `System_Sounds` WRITE;
/*!40000 ALTER TABLE `System_Sounds` DISABLE KEYS */;
INSERT INTO `System_Sounds` VALUES (1,1,'LanguageSelection','SYMACK_1.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1.wav',NULL,NULL,1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1.wav'),(2,1,'MainMenuIVR','SYMACK_1_1.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_1.wav',NULL,NULL,1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_1.wav'),(3,1,'EnterExtension','SYMACK_1_2.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_2.wav',NULL,NULL,1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_2.wav'),(4,1,'ExtDoesNotExist','SYMACK_1_2_1_1.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_1_1.wav',NULL,NULL,1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_1_1.wav'),(5,1,'DirectorySearch','SYMACK_1_2_2b.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_2b.wav',NULL,NULL,1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_2b.wav'),(6,1,'Address1','SYMACK_1_3a.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_3a.wav','Announcement','7',1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_3a.wav'),(7,1,'Address2','SYMACK_1_3b.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_3b.wav','Announcement','8',1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_3b.wav'),(8,1,'Address3','SYMACK_1_3c.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_3c.wav','IVR','1',1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_3c.wav'),(9,1,'NameNotFound','SYMACK_1_2_2_2.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_2_2.wav',NULL,NULL,1,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_2_2.wav'),(10,1,'Ali Kia','SYMACK_AliKia.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_AliKia.wav',NULL,NULL,0,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_AliKia.wav'),(11,1,'Nick Khamis','SYMACK_NickKhamis.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_NickKhamis.wav',NULL,NULL,0,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_NickKhamis.wav'),(12,1,'Mohammed Baig','SYMACK_MohamedBaig.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_MohamedBaig.wav',NULL,NULL,0,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_MohamedBaig.wav'),(13,1,'Elango Sivalingam','SYMACK_ElangoSivalingam.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_ElangoSivalingam.wav',NULL,NULL,0,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_ElangoSivalingam.wav'),(14,1,'EnterNameofPerson','SYMACK_1_2_2b.wav','/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_2b.wav',NULL,NULL,0,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/SYMACK_1_2_2b.wav'),(15,1,'VMGreeting','vm-play_greeting.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-play_greeting.wav',NULL,NULL,0,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/vm-play_greeting.wav'),(16,1,'VMEnterPin','vm-enter_pass.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-enter_pass.wav',NULL,NULL,0,NULL,NULL,NULL,'/home/symack/Voice-Prompts/symack/en/vm-enter_pass.wav'),(17,1,'PinINvalid','vm-password_not_valid.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-password_not_valid.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(18,1,'VM-Menu','vm-main_menu.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-main_menu.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(19,1,'YouHave','vm-you_have.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-you_have.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(20,1,'New','vm-new.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-new.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(21,1,'Messages','vm-messages.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-messages.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(22,1,'Saved','vm-saved.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-saved.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(23,1,'unDeletedMsgs','vm-undeleted.wav','/home/symack/Voice-Prompts/symack/en/voicemail/vm-undeleted.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(24,1,'1','1.wav','/home/symack/Voice-Prompts/symack/en/digits/1.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(25,1,'2','2','/home/symack/Voice-Prompts/symack/en/digits/2.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(26,1,'3','3','/home/symack/Voice-Prompts/symack/en/digits/3.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(27,1,'4','4','/home/symack/Voice-Prompts/symack/en/digits/4.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(28,1,'5','5','/home/symack/Voice-Prompts/symack/en/digits/5.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(29,1,'6','6','/home/symack/Voice-Prompts/symack/en/digits/6.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(30,1,'7','7','/home/symack/Voice-Prompts/symack/en/digits/7.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(31,1,'8','8','/home/symack/Voice-Prompts/symack/en/digits/8.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(32,1,'9','9','/home/symack/Voice-Prompts/symack/en/digits/9.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(33,1,'10','10','/home/symack/Voice-Prompts/symack/en/digits/10.wav',NULL,NULL,0,NULL,NULL,NULL,NULL),(34,1,'0','0','/home/symack/Voice-Prompts/symack/en/digits/0.wav',NULL,NULL,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `System_Sounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Time_Conditions`
--

DROP TABLE IF EXISTS `Time_Conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Time_Conditions` (
  `TC_ID` int(3) NOT NULL AUTO_INCREMENT,
  `Client_ID` int(11) NOT NULL DEFAULT '0',
  `TC_Name` varchar(25) DEFAULT NULL,
  `Time_Range` varchar(80) DEFAULT NULL,
  `Day_Range` varchar(80) DEFAULT NULL,
  `Date_Ranges` varchar(80) DEFAULT NULL,
  `Month_Range` varchar(80) DEFAULT NULL,
  `DEST_true_App` varchar(50) DEFAULT NULL,
  `DEST_true_ID` int(3) DEFAULT NULL,
  `DEST_false_App` varchar(50) DEFAULT NULL,
  `DEST_false_ID` int(3) DEFAULT NULL,
  `status` int(1) DEFAULT '0',
  PRIMARY KEY (`TC_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Time_Conditions`
--

LOCK TABLES `Time_Conditions` WRITE;
/*!40000 ALTER TABLE `Time_Conditions` DISABLE KEYS */;
/*!40000 ALTER TABLE `Time_Conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `acc`
--

DROP TABLE IF EXISTS `acc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` char(16) NOT NULL DEFAULT '',
  `from_tag` char(64) NOT NULL DEFAULT '',
  `to_tag` char(64) NOT NULL DEFAULT '',
  `callid` char(64) NOT NULL DEFAULT '',
  `sip_code` char(3) NOT NULL DEFAULT '',
  `sip_reason` char(32) NOT NULL DEFAULT '',
  `time` datetime NOT NULL,
  `duration` int(11) unsigned NOT NULL DEFAULT '0',
  `ms_duration` int(11) unsigned NOT NULL DEFAULT '0',
  `setuptime` int(11) unsigned NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acc`
--

LOCK TABLES `acc` WRITE;
/*!40000 ALTER TABLE `acc` DISABLE KEYS */;
/*!40000 ALTER TABLE `acc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_watchers`
--

DROP TABLE IF EXISTS `active_watchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_watchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `presentity_uri` char(255) NOT NULL,
  `watcher_username` char(64) NOT NULL,
  `watcher_domain` char(64) NOT NULL,
  `to_user` char(64) NOT NULL,
  `to_domain` char(64) NOT NULL,
  `event` char(64) NOT NULL DEFAULT 'presence',
  `event_id` char(64) DEFAULT NULL,
  `to_tag` char(64) NOT NULL,
  `from_tag` char(64) NOT NULL,
  `callid` char(64) NOT NULL,
  `local_cseq` int(11) NOT NULL,
  `remote_cseq` int(11) NOT NULL,
  `contact` char(255) NOT NULL,
  `record_route` text,
  `expires` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '2',
  `reason` char(64) DEFAULT NULL,
  `version` int(11) NOT NULL DEFAULT '0',
  `socket_info` char(64) NOT NULL,
  `local_contact` char(255) NOT NULL,
  `sharing_tag` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `active_watchers_idx` (`presentity_uri`,`callid`,`to_tag`,`from_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_watchers`
--

LOCK TABLES `active_watchers` WRITE;
/*!40000 ALTER TABLE `active_watchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_watchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grp` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ip` char(50) NOT NULL,
  `mask` tinyint(4) NOT NULL DEFAULT '32',
  `port` smallint(5) unsigned NOT NULL DEFAULT '0',
  `proto` char(4) NOT NULL DEFAULT 'any',
  `pattern` char(64) DEFAULT NULL,
  `context_info` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b2b_entities`
--

DROP TABLE IF EXISTS `b2b_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b2b_entities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(2) NOT NULL,
  `state` int(2) NOT NULL,
  `ruri` char(255) DEFAULT NULL,
  `from_uri` char(255) NOT NULL,
  `to_uri` char(255) NOT NULL,
  `from_dname` char(64) DEFAULT NULL,
  `to_dname` char(64) DEFAULT NULL,
  `tag0` char(64) NOT NULL,
  `tag1` char(64) DEFAULT NULL,
  `callid` char(64) NOT NULL,
  `cseq0` int(11) NOT NULL,
  `cseq1` int(11) DEFAULT NULL,
  `contact0` char(255) NOT NULL,
  `contact1` char(255) DEFAULT NULL,
  `route0` text,
  `route1` text,
  `sockinfo_srv` char(64) DEFAULT NULL,
  `param` char(255) NOT NULL,
  `lm` int(11) NOT NULL,
  `lrc` int(11) DEFAULT NULL,
  `lic` int(11) DEFAULT NULL,
  `leg_cseq` int(11) DEFAULT NULL,
  `leg_route` text,
  `leg_tag` char(64) DEFAULT NULL,
  `leg_contact` char(255) DEFAULT NULL,
  `leg_sockinfo` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `b2b_entities_idx` (`type`,`tag0`,`tag1`,`callid`),
  KEY `b2b_entities_param` (`param`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b2b_entities`
--

LOCK TABLES `b2b_entities` WRITE;
/*!40000 ALTER TABLE `b2b_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `b2b_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b2b_logic`
--

DROP TABLE IF EXISTS `b2b_logic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b2b_logic` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `si_key` char(64) NOT NULL,
  `scenario` char(64) DEFAULT NULL,
  `sstate` int(2) NOT NULL,
  `next_sstate` int(2) NOT NULL,
  `sparam0` char(64) DEFAULT NULL,
  `sparam1` char(64) DEFAULT NULL,
  `sparam2` char(64) DEFAULT NULL,
  `sparam3` char(64) DEFAULT NULL,
  `sparam4` char(64) DEFAULT NULL,
  `sdp` tinytext,
  `lifetime` int(10) NOT NULL DEFAULT '0',
  `e1_type` int(2) NOT NULL,
  `e1_sid` char(64) DEFAULT NULL,
  `e1_from` char(255) NOT NULL,
  `e1_to` char(255) NOT NULL,
  `e1_key` char(64) NOT NULL,
  `e2_type` int(2) NOT NULL,
  `e2_sid` char(64) DEFAULT NULL,
  `e2_from` char(255) NOT NULL,
  `e2_to` char(255) NOT NULL,
  `e2_key` char(64) NOT NULL,
  `e3_type` int(2) DEFAULT NULL,
  `e3_sid` char(64) DEFAULT NULL,
  `e3_from` char(255) DEFAULT NULL,
  `e3_to` char(255) DEFAULT NULL,
  `e3_key` char(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `b2b_logic_idx` (`si_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b2b_logic`
--

LOCK TABLES `b2b_logic` WRITE;
/*!40000 ALTER TABLE `b2b_logic` DISABLE KEYS */;
/*!40000 ALTER TABLE `b2b_logic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b2b_sca`
--

DROP TABLE IF EXISTS `b2b_sca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b2b_sca` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shared_line` char(64) NOT NULL,
  `watchers` char(255) NOT NULL,
  `app1_shared_entity` int(1) unsigned DEFAULT NULL,
  `app1_call_state` int(1) unsigned DEFAULT NULL,
  `app1_call_info_uri` char(255) DEFAULT NULL,
  `app1_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app1_b2bl_key` char(64) DEFAULT NULL,
  `app2_shared_entity` int(1) unsigned DEFAULT NULL,
  `app2_call_state` int(1) unsigned DEFAULT NULL,
  `app2_call_info_uri` char(255) DEFAULT NULL,
  `app2_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app2_b2bl_key` char(64) DEFAULT NULL,
  `app3_shared_entity` int(1) unsigned DEFAULT NULL,
  `app3_call_state` int(1) unsigned DEFAULT NULL,
  `app3_call_info_uri` char(255) DEFAULT NULL,
  `app3_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app3_b2bl_key` char(64) DEFAULT NULL,
  `app4_shared_entity` int(1) unsigned DEFAULT NULL,
  `app4_call_state` int(1) unsigned DEFAULT NULL,
  `app4_call_info_uri` char(255) DEFAULT NULL,
  `app4_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app4_b2bl_key` char(64) DEFAULT NULL,
  `app5_shared_entity` int(1) unsigned DEFAULT NULL,
  `app5_call_state` int(1) unsigned DEFAULT NULL,
  `app5_call_info_uri` char(255) DEFAULT NULL,
  `app5_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app5_b2bl_key` char(64) DEFAULT NULL,
  `app6_shared_entity` int(1) unsigned DEFAULT NULL,
  `app6_call_state` int(1) unsigned DEFAULT NULL,
  `app6_call_info_uri` char(255) DEFAULT NULL,
  `app6_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app6_b2bl_key` char(64) DEFAULT NULL,
  `app7_shared_entity` int(1) unsigned DEFAULT NULL,
  `app7_call_state` int(1) unsigned DEFAULT NULL,
  `app7_call_info_uri` char(255) DEFAULT NULL,
  `app7_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app7_b2bl_key` char(64) DEFAULT NULL,
  `app8_shared_entity` int(1) unsigned DEFAULT NULL,
  `app8_call_state` int(1) unsigned DEFAULT NULL,
  `app8_call_info_uri` char(255) DEFAULT NULL,
  `app8_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app8_b2bl_key` char(64) DEFAULT NULL,
  `app9_shared_entity` int(1) unsigned DEFAULT NULL,
  `app9_call_state` int(1) unsigned DEFAULT NULL,
  `app9_call_info_uri` char(255) DEFAULT NULL,
  `app9_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app9_b2bl_key` char(64) DEFAULT NULL,
  `app10_shared_entity` int(1) unsigned DEFAULT NULL,
  `app10_call_state` int(1) unsigned DEFAULT NULL,
  `app10_call_info_uri` char(255) DEFAULT NULL,
  `app10_call_info_appearance_uri` char(255) DEFAULT NULL,
  `app10_b2bl_key` char(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sca_idx` (`shared_line`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b2b_sca`
--

LOCK TABLES `b2b_sca` WRITE;
/*!40000 ALTER TABLE `b2b_sca` DISABLE KEYS */;
/*!40000 ALTER TABLE `b2b_sca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cachedb`
--

DROP TABLE IF EXISTS `cachedb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cachedb` (
  `keyname` char(255) NOT NULL,
  `value` text NOT NULL,
  `counter` int(10) NOT NULL DEFAULT '0',
  `expires` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`keyname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cachedb`
--

LOCK TABLES `cachedb` WRITE;
/*!40000 ALTER TABLE `cachedb` DISABLE KEYS */;
/*!40000 ALTER TABLE `cachedb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrierfailureroute`
--

DROP TABLE IF EXISTS `carrierfailureroute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carrierfailureroute` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `carrier` int(10) unsigned NOT NULL DEFAULT '0',
  `domain` char(64) NOT NULL DEFAULT '',
  `scan_prefix` char(64) NOT NULL DEFAULT '',
  `host_name` char(255) NOT NULL DEFAULT '',
  `reply_code` char(3) NOT NULL DEFAULT '',
  `flags` int(11) unsigned NOT NULL DEFAULT '0',
  `mask` int(11) unsigned NOT NULL DEFAULT '0',
  `next_domain` char(64) NOT NULL DEFAULT '',
  `description` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrierfailureroute`
--

LOCK TABLES `carrierfailureroute` WRITE;
/*!40000 ALTER TABLE `carrierfailureroute` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrierfailureroute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrierroute`
--

DROP TABLE IF EXISTS `carrierroute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carrierroute` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `carrier` int(10) unsigned NOT NULL DEFAULT '0',
  `domain` char(64) NOT NULL DEFAULT '',
  `scan_prefix` char(64) NOT NULL DEFAULT '',
  `flags` int(11) unsigned NOT NULL DEFAULT '0',
  `mask` int(11) unsigned NOT NULL DEFAULT '0',
  `prob` float NOT NULL DEFAULT '0',
  `strip` int(11) unsigned NOT NULL DEFAULT '0',
  `rewrite_host` char(255) NOT NULL DEFAULT '',
  `rewrite_prefix` char(64) NOT NULL DEFAULT '',
  `rewrite_suffix` char(64) NOT NULL DEFAULT '',
  `description` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrierroute`
--

LOCK TABLES `carrierroute` WRITE;
/*!40000 ALTER TABLE `carrierroute` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrierroute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cc_agents`
--

DROP TABLE IF EXISTS `cc_agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cc_agents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `agentid` char(128) NOT NULL,
  `location` char(128) NOT NULL,
  `logstate` int(10) unsigned NOT NULL DEFAULT '0',
  `skills` char(255) NOT NULL,
  `last_call_end` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_agentid` (`agentid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cc_agents`
--

LOCK TABLES `cc_agents` WRITE;
/*!40000 ALTER TABLE `cc_agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `cc_agents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cc_calls`
--

DROP TABLE IF EXISTS `cc_calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cc_calls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state` int(11) NOT NULL,
  `ig_cback` int(11) NOT NULL,
  `no_rej` int(11) NOT NULL,
  `setup_time` int(11) NOT NULL,
  `eta` int(11) NOT NULL,
  `last_start` int(11) NOT NULL,
  `recv_time` int(11) NOT NULL,
  `caller_dn` char(128) NOT NULL,
  `caller_un` char(128) NOT NULL,
  `b2buaid` char(128) NOT NULL DEFAULT '',
  `flow` char(128) NOT NULL,
  `agent` char(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_id` (`b2buaid`),
  KEY `b2buaid_idx` (`b2buaid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cc_calls`
--

LOCK TABLES `cc_calls` WRITE;
/*!40000 ALTER TABLE `cc_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `cc_calls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cc_cdrs`
--

DROP TABLE IF EXISTS `cc_cdrs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cc_cdrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `caller` char(64) NOT NULL,
  `received_timestamp` datetime NOT NULL,
  `wait_time` int(11) unsigned NOT NULL DEFAULT '0',
  `pickup_time` int(11) unsigned NOT NULL DEFAULT '0',
  `talk_time` int(11) unsigned NOT NULL DEFAULT '0',
  `flow_id` char(128) NOT NULL,
  `agent_id` char(128) DEFAULT NULL,
  `call_type` int(11) NOT NULL DEFAULT '-1',
  `rejected` int(11) unsigned NOT NULL DEFAULT '0',
  `fstats` int(11) unsigned NOT NULL DEFAULT '0',
  `cid` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cc_cdrs`
--

LOCK TABLES `cc_cdrs` WRITE;
/*!40000 ALTER TABLE `cc_cdrs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cc_cdrs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cc_flows`
--

DROP TABLE IF EXISTS `cc_flows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cc_flows` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `flowid` char(64) NOT NULL,
  `priority` int(11) unsigned NOT NULL DEFAULT '256',
  `skill` char(64) NOT NULL,
  `prependcid` char(32) NOT NULL,
  `message_welcome` char(128) DEFAULT NULL,
  `message_queue` char(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_flowid` (`flowid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cc_flows`
--

LOCK TABLES `cc_flows` WRITE;
/*!40000 ALTER TABLE `cc_flows` DISABLE KEYS */;
/*!40000 ALTER TABLE `cc_flows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
  `Client_ID` int(3) NOT NULL AUTO_INCREMENT,
  `uname` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL,
  `company` varchar(50) NOT NULL DEFAULT '',
  `eaddress` varchar(120) DEFAULT '',
  `ph` int(12) NOT NULL DEFAULT '0',
  `pswd` varchar(50) NOT NULL DEFAULT '',
  `climit` int(12) NOT NULL DEFAULT '0',
  `did` varchar(30) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `user_type` int(11) NOT NULL DEFAULT '1',
  `balance` double(9,1) DEFAULT '0.0',
  `maximum_extensions` varchar(255) DEFAULT '5',
  UNIQUE KEY `uname` (`Client_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=211 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'admin','SYMACK','SYMACK Corp','email@symack.ca',21345678,'pasword',4,'7874543231',1,0,100.0,'100');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `closeddial`
--

DROP TABLE IF EXISTS `closeddial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `closeddial` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) NOT NULL DEFAULT '',
  `cd_username` char(64) NOT NULL DEFAULT '',
  `cd_domain` char(64) NOT NULL DEFAULT '',
  `group_id` char(64) NOT NULL DEFAULT '',
  `new_uri` char(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cd_idx1` (`username`,`domain`,`cd_domain`,`cd_username`,`group_id`),
  KEY `cd_idx2` (`group_id`),
  KEY `cd_idx3` (`cd_username`),
  KEY `cd_idx4` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `closeddial`
--

LOCK TABLES `closeddial` WRITE;
/*!40000 ALTER TABLE `closeddial` DISABLE KEYS */;
/*!40000 ALTER TABLE `closeddial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clusterer`
--

DROP TABLE IF EXISTS `clusterer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clusterer` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `cluster_id` int(10) NOT NULL,
  `node_id` int(10) NOT NULL,
  `url` char(64) NOT NULL,
  `state` int(1) NOT NULL DEFAULT '1',
  `no_ping_retries` int(10) NOT NULL DEFAULT '3',
  `priority` int(10) NOT NULL DEFAULT '50',
  `sip_addr` char(64) DEFAULT NULL,
  `flags` char(64) DEFAULT NULL,
  `description` char(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clusterer_idx` (`cluster_id`,`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clusterer`
--

LOCK TABLES `clusterer` WRITE;
/*!40000 ALTER TABLE `clusterer` DISABLE KEYS */;
/*!40000 ALTER TABLE `clusterer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cpl`
--

DROP TABLE IF EXISTS `cpl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cpl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL,
  `domain` char(64) NOT NULL DEFAULT '',
  `cpl_xml` text,
  `cpl_bin` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_idx` (`username`,`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cpl`
--

LOCK TABLES `cpl` WRITE;
/*!40000 ALTER TABLE `cpl` DISABLE KEYS */;
/*!40000 ALTER TABLE `cpl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dbaliases`
--

DROP TABLE IF EXISTS `dbaliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbaliases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias_username` char(64) NOT NULL DEFAULT '',
  `alias_domain` char(64) NOT NULL DEFAULT '',
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `alias_idx` (`alias_username`,`alias_domain`),
  KEY `target_idx` (`username`,`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dbaliases`
--

LOCK TABLES `dbaliases` WRITE;
/*!40000 ALTER TABLE `dbaliases` DISABLE KEYS */;
/*!40000 ALTER TABLE `dbaliases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dialog`
--

DROP TABLE IF EXISTS `dialog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dialog` (
  `dlg_id` bigint(10) unsigned NOT NULL,
  `callid` char(255) NOT NULL,
  `from_uri` char(255) NOT NULL,
  `from_tag` char(64) NOT NULL,
  `to_uri` char(255) NOT NULL,
  `to_tag` char(64) NOT NULL,
  `mangled_from_uri` char(64) DEFAULT NULL,
  `mangled_to_uri` char(64) DEFAULT NULL,
  `caller_cseq` char(11) NOT NULL,
  `callee_cseq` char(11) NOT NULL,
  `caller_ping_cseq` int(11) unsigned NOT NULL,
  `callee_ping_cseq` int(11) unsigned NOT NULL,
  `caller_route_set` text,
  `callee_route_set` text,
  `caller_contact` char(255) DEFAULT NULL,
  `callee_contact` char(255) DEFAULT NULL,
  `caller_sock` char(64) NOT NULL,
  `callee_sock` char(64) NOT NULL,
  `state` int(10) unsigned NOT NULL,
  `start_time` int(10) unsigned NOT NULL,
  `timeout` int(10) unsigned NOT NULL,
  `vars` blob,
  `profiles` text,
  `script_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `module_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `flags` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`dlg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dialog`
--

LOCK TABLES `dialog` WRITE;
/*!40000 ALTER TABLE `dialog` DISABLE KEYS */;
/*!40000 ALTER TABLE `dialog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dialplan`
--

DROP TABLE IF EXISTS `dialplan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dialplan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dpid` int(11) NOT NULL,
  `pr` int(11) NOT NULL DEFAULT '0',
  `match_op` int(11) NOT NULL,
  `match_exp` char(64) NOT NULL,
  `match_flags` int(11) NOT NULL DEFAULT '0',
  `subst_exp` char(64) DEFAULT NULL,
  `repl_exp` char(32) DEFAULT NULL,
  `timerec` char(255) DEFAULT NULL,
  `disabled` int(11) NOT NULL DEFAULT '0',
  `attrs` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dialplan`
--

LOCK TABLES `dialplan` WRITE;
/*!40000 ALTER TABLE `dialplan` DISABLE KEYS */;
/*!40000 ALTER TABLE `dialplan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `did_client_map`
--

DROP TABLE IF EXISTS `did_client_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `did_client_map` (
  `Map_ID` int(3) NOT NULL AUTO_INCREMENT,
  `did_number` varchar(15) DEFAULT NULL,
  `client_name` varchar(56) NOT NULL,
  `status` int(1) NOT NULL,
  `Max_CC_Allowed` int(2) NOT NULL,
  `ob_enabled` varchar(1) DEFAULT NULL,
  `cb_detect` int(1) DEFAULT NULL,
  UNIQUE KEY `uname` (`Map_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=215 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `did_client_map`
--

LOCK TABLES `did_client_map` WRITE;
/*!40000 ALTER TABLE `did_client_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `did_client_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispatcher`
--

DROP TABLE IF EXISTS `dispatcher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dispatcher` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `setid` int(11) NOT NULL DEFAULT '0',
  `destination` char(192) NOT NULL DEFAULT '',
  `socket` char(128) DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `weight` char(64) NOT NULL DEFAULT '1',
  `priority` int(11) NOT NULL DEFAULT '0',
  `attrs` char(128) NOT NULL DEFAULT '',
  `description` char(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispatcher`
--

LOCK TABLES `dispatcher` WRITE;
/*!40000 ALTER TABLE `dispatcher` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatcher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain` char(64) NOT NULL DEFAULT '',
  `attrs` char(255) DEFAULT NULL,
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_idx` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain`
--

LOCK TABLES `domain` WRITE;
/*!40000 ALTER TABLE `domain` DISABLE KEYS */;
INSERT INTO `domain` VALUES (1,'192.168.2.30',NULL,'1900-01-01 00:00:01');
/*!40000 ALTER TABLE `domain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domainpolicy`
--

DROP TABLE IF EXISTS `domainpolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domainpolicy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule` char(255) NOT NULL,
  `type` char(255) NOT NULL,
  `att` char(255) DEFAULT NULL,
  `val` char(128) DEFAULT NULL,
  `description` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rav_idx` (`rule`,`att`,`val`),
  KEY `rule_idx` (`rule`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domainpolicy`
--

LOCK TABLES `domainpolicy` WRITE;
/*!40000 ALTER TABLE `domainpolicy` DISABLE KEYS */;
/*!40000 ALTER TABLE `domainpolicy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dr_carriers`
--

DROP TABLE IF EXISTS `dr_carriers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dr_carriers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `carrierid` char(64) NOT NULL,
  `gwlist` char(255) NOT NULL,
  `flags` int(11) unsigned NOT NULL DEFAULT '0',
  `state` int(11) unsigned NOT NULL DEFAULT '0',
  `attrs` char(255) DEFAULT NULL,
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dr_carrier_idx` (`carrierid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dr_carriers`
--

LOCK TABLES `dr_carriers` WRITE;
/*!40000 ALTER TABLE `dr_carriers` DISABLE KEYS */;
/*!40000 ALTER TABLE `dr_carriers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dr_gateways`
--

DROP TABLE IF EXISTS `dr_gateways`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dr_gateways` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gwid` char(64) NOT NULL,
  `type` int(11) unsigned NOT NULL DEFAULT '0',
  `address` char(128) NOT NULL,
  `strip` int(11) unsigned NOT NULL DEFAULT '0',
  `pri_prefix` char(16) DEFAULT NULL,
  `attrs` char(255) DEFAULT NULL,
  `probe_mode` int(11) unsigned NOT NULL DEFAULT '0',
  `state` int(11) unsigned NOT NULL DEFAULT '0',
  `socket` char(128) DEFAULT NULL,
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dr_gw_idx` (`gwid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dr_gateways`
--

LOCK TABLES `dr_gateways` WRITE;
/*!40000 ALTER TABLE `dr_gateways` DISABLE KEYS */;
/*!40000 ALTER TABLE `dr_gateways` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dr_groups`
--

DROP TABLE IF EXISTS `dr_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dr_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL,
  `domain` char(128) DEFAULT NULL,
  `groupid` int(11) unsigned NOT NULL DEFAULT '0',
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dr_groups`
--

LOCK TABLES `dr_groups` WRITE;
/*!40000 ALTER TABLE `dr_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `dr_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dr_partitions`
--

DROP TABLE IF EXISTS `dr_partitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dr_partitions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `partition_name` char(255) NOT NULL,
  `db_url` char(255) NOT NULL,
  `drd_table` char(255) DEFAULT NULL,
  `drr_table` char(255) DEFAULT NULL,
  `drg_table` char(255) DEFAULT NULL,
  `drc_table` char(255) DEFAULT NULL,
  `ruri_avp` char(255) DEFAULT NULL,
  `gw_id_avp` char(255) DEFAULT NULL,
  `gw_priprefix_avp` char(255) DEFAULT NULL,
  `gw_sock_avp` char(255) DEFAULT NULL,
  `rule_id_avp` char(255) DEFAULT NULL,
  `rule_prefix_avp` char(255) DEFAULT NULL,
  `carrier_id_avp` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dr_partitions`
--

LOCK TABLES `dr_partitions` WRITE;
/*!40000 ALTER TABLE `dr_partitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `dr_partitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dr_rules`
--

DROP TABLE IF EXISTS `dr_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dr_rules` (
  `ruleid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `groupid` char(255) NOT NULL,
  `prefix` char(64) NOT NULL,
  `timerec` char(255) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT '0',
  `routeid` char(255) DEFAULT NULL,
  `gwlist` char(255) NOT NULL,
  `attrs` char(255) DEFAULT NULL,
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`ruleid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dr_rules`
--

LOCK TABLES `dr_rules` WRITE;
/*!40000 ALTER TABLE `dr_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `dr_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_report`
--

DROP TABLE IF EXISTS `emergency_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emergency_report` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `callid` char(25) NOT NULL,
  `selectiveRoutingID` char(11) NOT NULL,
  `routingESN` int(5) unsigned NOT NULL DEFAULT '0',
  `npa` int(3) unsigned NOT NULL DEFAULT '0',
  `esgwri` char(50) NOT NULL,
  `lro` char(20) NOT NULL,
  `VPC_organizationName` char(50) NOT NULL,
  `VPC_hostname` char(50) NOT NULL,
  `VPC_timestamp` char(30) NOT NULL,
  `result` char(4) NOT NULL,
  `disposition` char(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_report`
--

LOCK TABLES `emergency_report` WRITE;
/*!40000 ALTER TABLE `emergency_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `emergency_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_routing`
--

DROP TABLE IF EXISTS `emergency_routing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emergency_routing` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `selectiveRoutingID` char(11) NOT NULL,
  `routingESN` int(5) unsigned NOT NULL DEFAULT '0',
  `npa` int(3) unsigned NOT NULL DEFAULT '0',
  `esgwri` char(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_routing`
--

LOCK TABLES `emergency_routing` WRITE;
/*!40000 ALTER TABLE `emergency_routing` DISABLE KEYS */;
/*!40000 ALTER TABLE `emergency_routing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_service_provider`
--

DROP TABLE IF EXISTS `emergency_service_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emergency_service_provider` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `organizationName` char(50) NOT NULL,
  `hostId` char(30) NOT NULL,
  `nenaId` char(50) NOT NULL,
  `contact` char(20) NOT NULL,
  `certUri` char(50) NOT NULL,
  `nodeIP` char(20) NOT NULL,
  `attribution` int(2) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_service_provider`
--

LOCK TABLES `emergency_service_provider` WRITE;
/*!40000 ALTER TABLE `emergency_service_provider` DISABLE KEYS */;
/*!40000 ALTER TABLE `emergency_service_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featureCodes`
--

DROP TABLE IF EXISTS `featureCodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `featureCodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientid` varchar(45) NOT NULL,
  `code` varchar(45) NOT NULL,
  `application` varchar(45) DEFAULT NULL,
  `applicationID` varchar(45) DEFAULT NULL,
  `applicationAction` varchar(45) DEFAULT NULL,
  `extraInfo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featureCodes`
--

LOCK TABLES `featureCodes` WRITE;
/*!40000 ALTER TABLE `featureCodes` DISABLE KEYS */;
INSERT INTO `featureCodes` VALUES (1,'1','*98','Voicemail',NULL,'retrieve',NULL);
/*!40000 ALTER TABLE `featureCodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fraud_detection`
--

DROP TABLE IF EXISTS `fraud_detection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fraud_detection` (
  `ruleid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profileid` int(10) unsigned NOT NULL,
  `prefix` char(64) NOT NULL,
  `start_hour` char(5) NOT NULL DEFAULT '00:00',
  `end_hour` char(5) NOT NULL DEFAULT '23:59',
  `daysoftheweek` char(64) NOT NULL DEFAULT 'Mon-Sun',
  `cpm_warning` int(5) unsigned NOT NULL,
  `cpm_critical` int(5) unsigned NOT NULL,
  `call_duration_warning` int(5) unsigned NOT NULL,
  `call_duration_critical` int(5) unsigned NOT NULL,
  `total_calls_warning` int(5) unsigned NOT NULL,
  `total_calls_critical` int(5) unsigned NOT NULL,
  `concurrent_calls_warning` int(5) unsigned NOT NULL,
  `concurrent_calls_critical` int(5) unsigned NOT NULL,
  `sequential_calls_warning` int(5) unsigned NOT NULL,
  `sequential_calls_critical` int(5) unsigned NOT NULL,
  PRIMARY KEY (`ruleid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fraud_detection`
--

LOCK TABLES `fraud_detection` WRITE;
/*!40000 ALTER TABLE `fraud_detection` DISABLE KEYS */;
/*!40000 ALTER TABLE `fraud_detection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `freeswitch`
--

DROP TABLE IF EXISTS `freeswitch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `freeswitch` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) DEFAULT NULL,
  `password` char(64) NOT NULL,
  `ip` char(20) NOT NULL,
  `port` int(11) NOT NULL DEFAULT '8021',
  `events_csv` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `freeswitch`
--

LOCK TABLES `freeswitch` WRITE;
/*!40000 ALTER TABLE `freeswitch` DISABLE KEYS */;
/*!40000 ALTER TABLE `freeswitch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `globalblacklist`
--

DROP TABLE IF EXISTS `globalblacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `globalblacklist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `prefix` char(64) NOT NULL DEFAULT '',
  `whitelist` tinyint(1) NOT NULL DEFAULT '0',
  `description` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `globalblacklist_idx` (`prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `globalblacklist`
--

LOCK TABLES `globalblacklist` WRITE;
/*!40000 ALTER TABLE `globalblacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `globalblacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grp`
--

DROP TABLE IF EXISTS `grp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) NOT NULL DEFAULT '',
  `grp` char(64) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_group_idx` (`username`,`domain`,`grp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grp`
--

LOCK TABLES `grp` WRITE;
/*!40000 ALTER TABLE `grp` DISABLE KEYS */;
/*!40000 ALTER TABLE `grp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imc_members`
--

DROP TABLE IF EXISTS `imc_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imc_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL,
  `domain` char(64) NOT NULL,
  `room` char(64) NOT NULL,
  `flag` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_room_idx` (`username`,`domain`,`room`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imc_members`
--

LOCK TABLES `imc_members` WRITE;
/*!40000 ALTER TABLE `imc_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `imc_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imc_rooms`
--

DROP TABLE IF EXISTS `imc_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imc_rooms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(64) NOT NULL,
  `domain` char(64) NOT NULL,
  `flag` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_domain_idx` (`name`,`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imc_rooms`
--

LOCK TABLES `imc_rooms` WRITE;
/*!40000 ALTER TABLE `imc_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `imc_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `load_balancer`
--

DROP TABLE IF EXISTS `load_balancer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `load_balancer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned NOT NULL DEFAULT '0',
  `dst_uri` char(128) NOT NULL,
  `resources` char(255) NOT NULL,
  `probe_mode` int(11) unsigned NOT NULL DEFAULT '0',
  `description` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dsturi_idx` (`dst_uri`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `load_balancer`
--

LOCK TABLES `load_balancer` WRITE;
/*!40000 ALTER TABLE `load_balancer` DISABLE KEYS */;
INSERT INTO `load_balancer` VALUES (1,1,'sip:10.11.0.2:6060','calls=100',8,'test PBX1'),(2,1,'sip:10.11.0.3:6060','calls=100',8,'test PBX2');
/*!40000 ALTER TABLE `load_balancer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `contact_id` bigint(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) DEFAULT NULL,
  `contact` char(255) NOT NULL DEFAULT '',
  `received` char(255) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `expires` int(10) unsigned NOT NULL,
  `q` float(10,2) NOT NULL DEFAULT '1.00',
  `callid` char(255) NOT NULL DEFAULT 'Default-Call-ID',
  `cseq` int(11) NOT NULL DEFAULT '13',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  `flags` int(11) NOT NULL DEFAULT '0',
  `cflags` char(255) DEFAULT NULL,
  `user_agent` char(255) NOT NULL DEFAULT '',
  `socket` char(64) DEFAULT NULL,
  `methods` int(11) DEFAULT NULL,
  `sip_instance` char(255) DEFAULT NULL,
  `kv_store` text,
  `attr` char(255) DEFAULT NULL,
  PRIMARY KEY (`contact_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1574387238802460173 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (763500874327856475,'10024','192.168.2.30','sip:10024@192.168.2.22:5060',NULL,NULL,1589501476,-1.00,'806258E7-A794-EA11-B578-75378353E614@192.168.2.22',637,'2020-05-14 19:56:16',0,'NAT','SIPPER for PhonerLite','udp:192.168.2.30:5060',7551,'<urn:uuid:0042541B-DCF4-E911-BC4C-8AF0232103F8>',NULL,NULL),(1574387238802460172,'10025','192.168.2.30','sip:10025@192.168.2.250:5060',NULL,NULL,1589503960,-1.00,'2_160826568@192.168.2.250',584,'2020-05-14 19:52:40',0,'NAT','Yealink SIP-T48G 35.83.0.30','udp:192.168.2.30:5060',16383,NULL,NULL,NULL);
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matchAreaCodes`
--

DROP TABLE IF EXISTS `matchAreaCodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matchAreaCodes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ClientID` char(64) NOT NULL DEFAULT '',
  `AreaCode` char(5) DEFAULT NULL,
  `OnMatchApp` char(100) DEFAULT NULL,
  `OnMatchAppID` char(3) DEFAULT NULL,
  `NoMatchApp` varchar(45) DEFAULT NULL,
  `NoMatchAppID` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matchAreaCodes`
--

LOCK TABLES `matchAreaCodes` WRITE;
/*!40000 ALTER TABLE `matchAreaCodes` DISABLE KEYS */;
INSERT INTO `matchAreaCodes` VALUES (1,'1','514','Language','2',NULL,NULL),(2,'1','418','Language','2',NULL,NULL),(3,'1','438','Language','2',NULL,NULL),(4,'1','819','Language','2',NULL,NULL),(5,'1','613','Language','2',NULL,NULL),(6,'1','367','Language','2',NULL,NULL),(7,'1','450','Language','2',NULL,NULL),(8,'1','581','Language','2',NULL,NULL);
/*!40000 ALTER TABLE `matchAreaCodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `missed_calls`
--

DROP TABLE IF EXISTS `missed_calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `missed_calls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` char(16) NOT NULL DEFAULT '',
  `from_tag` char(64) NOT NULL DEFAULT '',
  `to_tag` char(64) NOT NULL DEFAULT '',
  `callid` char(64) NOT NULL DEFAULT '',
  `sip_code` char(3) NOT NULL DEFAULT '',
  `sip_reason` char(32) NOT NULL DEFAULT '',
  `time` datetime NOT NULL,
  `setuptime` int(11) unsigned NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missed_calls`
--

LOCK TABLES `missed_calls` WRITE;
/*!40000 ALTER TABLE `missed_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `missed_calls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pbxSettings`
--

DROP TABLE IF EXISTS `pbxSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pbxSettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stasisAppName` varchar(45) NOT NULL DEFAULT 'SymackPBX',
  `stasisUserName` varchar(45) NOT NULL DEFAULT 'mediabox',
  `stasisPassword` varchar(45) NOT NULL DEFAULT 'mediabox',
  `stasisURL` varchar(45) NOT NULL DEFAULT 'http://localhost:8088/ari',
  `stasisWebsockURL` varchar(100) NOT NULL DEFAULT 'ws://localhost:8088/ari/events',
  `recordingPath` varchar(255) NOT NULL DEFAULT '/var/spool/asterisk/recording',
  `maxRetryCount` varchar(1) NOT NULL DEFAULT '3',
  `voicemailPath` varchar(155) NOT NULL DEFAULT '/var/spool/asterisk/recording',
  `defaultLanguageColumn` varchar(45) NOT NULL DEFAULT 'file_Path',
  `maxVmailRecordingLength` int(3) NOT NULL DEFAULT '60',
  `natsURL` varchar(45) NOT NULL DEFAULT 'nats://10.11.0.3:4222',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pbxSettings`
--

LOCK TABLES `pbxSettings` WRITE;
/*!40000 ALTER TABLE `pbxSettings` DISABLE KEYS */;
INSERT INTO `pbxSettings` VALUES (1,'SymackPBX','mediabox','mediabox','http://localhost:8088/ari','ws://localhost:8088/ari/events','/var/spool/asterisk/recording','3','/var/spool/asterisk/recording','file_Path',60,'nats://10.11.0.3:4222');
/*!40000 ALTER TABLE `pbxSettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presentity`
--

DROP TABLE IF EXISTS `presentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `presentity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL,
  `domain` char(64) NOT NULL,
  `event` char(64) NOT NULL,
  `etag` char(64) NOT NULL,
  `expires` int(11) NOT NULL,
  `received_time` int(11) NOT NULL,
  `body` blob,
  `extra_hdrs` blob,
  `sender` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `presentity_idx` (`username`,`domain`,`event`,`etag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presentity`
--

LOCK TABLES `presentity` WRITE;
/*!40000 ALTER TABLE `presentity` DISABLE KEYS */;
/*!40000 ALTER TABLE `presentity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pua`
--

DROP TABLE IF EXISTS `pua`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pua` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pres_uri` char(255) NOT NULL,
  `pres_id` char(255) NOT NULL,
  `event` int(11) NOT NULL,
  `expires` int(11) NOT NULL,
  `desired_expires` int(11) NOT NULL,
  `flag` int(11) NOT NULL,
  `etag` char(64) DEFAULT NULL,
  `tuple_id` char(64) DEFAULT NULL,
  `watcher_uri` char(255) DEFAULT NULL,
  `to_uri` char(255) DEFAULT NULL,
  `call_id` char(64) DEFAULT NULL,
  `to_tag` char(64) DEFAULT NULL,
  `from_tag` char(64) DEFAULT NULL,
  `cseq` int(11) DEFAULT NULL,
  `record_route` text,
  `contact` char(255) DEFAULT NULL,
  `remote_contact` char(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `extra_headers` text,
  PRIMARY KEY (`id`),
  KEY `del1_idx` (`pres_uri`,`event`),
  KEY `del2_idx` (`expires`),
  KEY `update_idx` (`pres_uri`,`pres_id`,`flag`,`event`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pua`
--

LOCK TABLES `pua` WRITE;
/*!40000 ALTER TABLE `pua` DISABLE KEYS */;
/*!40000 ALTER TABLE `pua` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_grp`
--

DROP TABLE IF EXISTS `re_grp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `re_grp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reg_exp` char(128) NOT NULL DEFAULT '',
  `group_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `group_idx` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_grp`
--

LOCK TABLES `re_grp` WRITE;
/*!40000 ALTER TABLE `re_grp` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_grp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registrant`
--

DROP TABLE IF EXISTS `registrant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registrant` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `registrar` char(255) NOT NULL DEFAULT '',
  `proxy` char(255) DEFAULT NULL,
  `aor` char(255) NOT NULL DEFAULT '',
  `third_party_registrant` char(255) DEFAULT NULL,
  `username` char(64) DEFAULT NULL,
  `password` char(64) DEFAULT NULL,
  `binding_URI` char(255) NOT NULL DEFAULT '',
  `binding_params` char(64) DEFAULT NULL,
  `expiry` int(1) unsigned DEFAULT NULL,
  `forced_socket` char(64) DEFAULT NULL,
  `cluster_shtag` char(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `aor_idx` (`aor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registrant`
--

LOCK TABLES `registrant` WRITE;
/*!40000 ALTER TABLE `registrant` DISABLE KEYS */;
/*!40000 ALTER TABLE `registrant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rls_presentity`
--

DROP TABLE IF EXISTS `rls_presentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rls_presentity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rlsubs_did` char(255) NOT NULL,
  `resource_uri` char(255) NOT NULL,
  `content_type` char(255) NOT NULL,
  `presence_state` blob NOT NULL,
  `expires` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  `auth_state` int(11) NOT NULL,
  `reason` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rls_presentity_idx` (`rlsubs_did`,`resource_uri`),
  KEY `updated_idx` (`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rls_presentity`
--

LOCK TABLES `rls_presentity` WRITE;
/*!40000 ALTER TABLE `rls_presentity` DISABLE KEYS */;
/*!40000 ALTER TABLE `rls_presentity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rls_watchers`
--

DROP TABLE IF EXISTS `rls_watchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rls_watchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `presentity_uri` char(255) NOT NULL,
  `to_user` char(64) NOT NULL,
  `to_domain` char(64) NOT NULL,
  `watcher_username` char(64) NOT NULL,
  `watcher_domain` char(64) NOT NULL,
  `event` char(64) NOT NULL DEFAULT 'presence',
  `event_id` char(64) DEFAULT NULL,
  `to_tag` char(64) NOT NULL,
  `from_tag` char(64) NOT NULL,
  `callid` char(64) NOT NULL,
  `local_cseq` int(11) NOT NULL,
  `remote_cseq` int(11) NOT NULL,
  `contact` char(64) NOT NULL,
  `record_route` text,
  `expires` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '2',
  `reason` char(64) NOT NULL,
  `version` int(11) NOT NULL DEFAULT '0',
  `socket_info` char(64) NOT NULL,
  `local_contact` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rls_watcher_idx` (`presentity_uri`,`callid`,`to_tag`,`from_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rls_watchers`
--

LOCK TABLES `rls_watchers` WRITE;
/*!40000 ALTER TABLE `rls_watchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `rls_watchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_tree`
--

DROP TABLE IF EXISTS `route_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route_tree` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `carrier` char(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_tree`
--

LOCK TABLES `route_tree` WRITE;
/*!40000 ALTER TABLE `route_tree` DISABLE KEYS */;
/*!40000 ALTER TABLE `route_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rtpengine`
--

DROP TABLE IF EXISTS `rtpengine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtpengine` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `socket` text NOT NULL,
  `set_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rtpengine`
--

LOCK TABLES `rtpengine` WRITE;
/*!40000 ALTER TABLE `rtpengine` DISABLE KEYS */;
/*!40000 ALTER TABLE `rtpengine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rtpproxy_sockets`
--

DROP TABLE IF EXISTS `rtpproxy_sockets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtpproxy_sockets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rtpproxy_sock` text NOT NULL,
  `set_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rtpproxy_sockets`
--

LOCK TABLES `rtpproxy_sockets` WRITE;
/*!40000 ALTER TABLE `rtpproxy_sockets` DISABLE KEYS */;
/*!40000 ALTER TABLE `rtpproxy_sockets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `silo`
--

DROP TABLE IF EXISTS `silo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `silo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `src_addr` char(255) NOT NULL DEFAULT '',
  `dst_addr` char(255) NOT NULL DEFAULT '',
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) NOT NULL DEFAULT '',
  `inc_time` int(11) NOT NULL DEFAULT '0',
  `exp_time` int(11) NOT NULL DEFAULT '0',
  `snd_time` int(11) NOT NULL DEFAULT '0',
  `ctype` char(255) DEFAULT NULL,
  `body` blob,
  PRIMARY KEY (`id`),
  KEY `account_idx` (`username`,`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `silo`
--

LOCK TABLES `silo` WRITE;
/*!40000 ALTER TABLE `silo` DISABLE KEYS */;
/*!40000 ALTER TABLE `silo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sip_trace`
--

DROP TABLE IF EXISTS `sip_trace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sip_trace` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `time_stamp` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  `callid` char(255) NOT NULL DEFAULT '',
  `trace_attrs` char(255) DEFAULT NULL,
  `msg` text NOT NULL,
  `method` char(32) NOT NULL DEFAULT '',
  `status` char(255) DEFAULT NULL,
  `from_proto` char(5) NOT NULL,
  `from_ip` char(50) NOT NULL DEFAULT '',
  `from_port` int(5) unsigned NOT NULL,
  `to_proto` char(5) NOT NULL,
  `to_ip` char(50) NOT NULL DEFAULT '',
  `to_port` int(5) unsigned NOT NULL,
  `fromtag` char(64) NOT NULL DEFAULT '',
  `direction` char(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `trace_attrs_idx` (`trace_attrs`),
  KEY `date_idx` (`time_stamp`),
  KEY `fromip_idx` (`from_ip`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sip_trace`
--

LOCK TABLES `sip_trace` WRITE;
/*!40000 ALTER TABLE `sip_trace` DISABLE KEYS */;
/*!40000 ALTER TABLE `sip_trace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smpp`
--

DROP TABLE IF EXISTS `smpp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smpp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(255) NOT NULL,
  `ip` char(50) NOT NULL,
  `port` int(5) unsigned NOT NULL,
  `system_id` char(16) NOT NULL,
  `password` char(9) NOT NULL,
  `system_type` char(13) NOT NULL DEFAULT '',
  `src_ton` int(10) unsigned NOT NULL DEFAULT '0',
  `src_npi` int(10) unsigned NOT NULL DEFAULT '0',
  `dst_ton` int(10) unsigned NOT NULL DEFAULT '0',
  `dst_npi` int(10) unsigned NOT NULL DEFAULT '0',
  `session_type` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smpp`
--

LOCK TABLES `smpp` WRITE;
/*!40000 ALTER TABLE `smpp` DISABLE KEYS */;
/*!40000 ALTER TABLE `smpp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `speed_dial`
--

DROP TABLE IF EXISTS `speed_dial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `speed_dial` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) NOT NULL DEFAULT '',
  `sd_username` char(64) NOT NULL DEFAULT '',
  `sd_domain` char(64) NOT NULL DEFAULT '',
  `new_uri` char(255) NOT NULL DEFAULT '',
  `fname` char(64) NOT NULL DEFAULT '',
  `lname` char(64) NOT NULL DEFAULT '',
  `description` char(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `speed_dial_idx` (`username`,`domain`,`sd_domain`,`sd_username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speed_dial`
--

LOCK TABLES `speed_dial` WRITE;
/*!40000 ALTER TABLE `speed_dial` DISABLE KEYS */;
/*!40000 ALTER TABLE `speed_dial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriber`
--

DROP TABLE IF EXISTS `subscriber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriber` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `clientid` varchar(3) NOT NULL DEFAULT '0',
  `username` varchar(64) NOT NULL DEFAULT '',
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `domain` varchar(255) NOT NULL DEFAULT '',
  `password` char(25) NOT NULL DEFAULT '',
  `emailAddress` char(64) NOT NULL DEFAULT '',
  `greeetingfile` varchar(4) DEFAULT NULL,
  `ha1` char(64) NOT NULL DEFAULT '',
  `ha1b` char(64) NOT NULL DEFAULT '',
  `rpid` char(64) DEFAULT NULL,
  `ringTimeout` int(2) DEFAULT '60',
  `voicemailEnabled` tinyint(4) DEFAULT '0',
  `voicemailGreetingFileID` varchar(45) DEFAULT NULL,
  `voicemailPin` varchar(9) DEFAULT '43210',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_idx` (`username`,`domain`),
  KEY `username_idx` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriber`
--

LOCK TABLES `subscriber` WRITE;
/*!40000 ALTER TABLE `subscriber` DISABLE KEYS */;
INSERT INTO `subscriber` VALUES (1,'1','10024','Your','ahmed2','192.168.2.30','','gahmed@saevolgo.ca','10','c2a7b722954e5d48cd06c1a368686add','5a05bb0d2df8116119798884834e05f6',NULL,5,0,NULL,'43210'),(2,'1','10026','gohar','ahmed','10.11.0.8','','govoiper@gmail.com','11','71d82f70ef35f0bcebf40952e54848dc','a1579bb5ea0857898f75135c9af5be03',NULL,5,0,NULL,'43210'),(4,'1','10025','cyber','ahmed3','192.168.2.30','','','12','11dafa48d90977d6a4da1a0337c4a602','c2cf038829f9a5c54e934e7421af29f6',NULL,5,1,NULL,'43210');
/*!40000 ALTER TABLE `subscriber` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tls_mgm`
--

DROP TABLE IF EXISTS `tls_mgm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tls_mgm` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain` char(64) NOT NULL,
  `match_ip_address` char(255) DEFAULT NULL,
  `match_sip_domain` char(255) DEFAULT NULL,
  `type` int(1) NOT NULL DEFAULT '1',
  `method` char(16) DEFAULT 'SSLv23',
  `verify_cert` int(1) DEFAULT '1',
  `require_cert` int(1) DEFAULT '1',
  `certificate` blob,
  `private_key` blob,
  `crl_check_all` int(1) DEFAULT '0',
  `crl_dir` char(255) DEFAULT NULL,
  `ca_list` mediumblob,
  `ca_dir` char(255) DEFAULT NULL,
  `cipher_list` char(255) DEFAULT NULL,
  `dh_params` blob,
  `ec_curve` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_type_idx` (`domain`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tls_mgm`
--

LOCK TABLES `tls_mgm` WRITE;
/*!40000 ALTER TABLE `tls_mgm` DISABLE KEYS */;
/*!40000 ALTER TABLE `tls_mgm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uri`
--

DROP TABLE IF EXISTS `uri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uri` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) NOT NULL DEFAULT '',
  `uri_user` char(64) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_idx` (`username`,`domain`,`uri_user`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uri`
--

LOCK TABLES `uri` WRITE;
/*!40000 ALTER TABLE `uri` DISABLE KEYS */;
/*!40000 ALTER TABLE `uri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userblacklist`
--

DROP TABLE IF EXISTS `userblacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userblacklist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL DEFAULT '',
  `domain` char(64) NOT NULL DEFAULT '',
  `prefix` char(64) NOT NULL DEFAULT '',
  `whitelist` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userblacklist_idx` (`username`,`domain`,`prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userblacklist`
--

LOCK TABLES `userblacklist` WRITE;
/*!40000 ALTER TABLE `userblacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `userblacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usr_preferences`
--

DROP TABLE IF EXISTS `usr_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_preferences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(64) NOT NULL DEFAULT '',
  `username` char(64) NOT NULL DEFAULT '0',
  `domain` char(64) NOT NULL DEFAULT '',
  `attribute` char(32) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT '0',
  `value` char(128) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `ua_idx` (`uuid`,`attribute`),
  KEY `uda_idx` (`username`,`domain`,`attribute`),
  KEY `value_idx` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_preferences`
--

LOCK TABLES `usr_preferences` WRITE;
/*!40000 ALTER TABLE `usr_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `usr_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `version`
--

DROP TABLE IF EXISTS `version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version` (
  `table_name` char(32) NOT NULL,
  `table_version` int(10) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `t_name_idx` (`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `version`
--

LOCK TABLES `version` WRITE;
/*!40000 ALTER TABLE `version` DISABLE KEYS */;
INSERT INTO `version` VALUES ('acc',7),('active_watchers',12),('address',5),('b2b_entities',1),('b2b_logic',3),('b2b_sca',1),('cachedb',2),('carrierfailureroute',2),('carrierroute',3),('cc_agents',1),('cc_cdrs',1),('cc_flows',1),('closeddial',1),('clusterer',4),('cpl',2),('dbaliases',2),('dialog',10),('dialplan',5),('dispatcher',8),('domain',3),('domainpolicy',3),('dr_carriers',2),('dr_gateways',6),('dr_groups',2),('dr_partitions',1),('dr_rules',3),('emergency_report',1),('emergency_routing',1),('emergency_service_provider',1),('fraud_detection',1),('freeswitch',1),('globalblacklist',2),('grp',3),('imc_members',2),('imc_rooms',2),('load_balancer',2),('location',1013),('missed_calls',5),('presentity',5),('pua',8),('registrant',2),('re_grp',2),('rls_presentity',1),('rls_watchers',2),('route_tree',2),('rtpengine',1),('rtpproxy_sockets',0),('silo',6),('sip_trace',5),('smpp',1),('speed_dial',3),('subscriber',7),('tls_mgm',3),('uri',2),('userblacklist',2),('usr_preferences',3),('watchers',4),('xcap',4);
/*!40000 ALTER TABLE `version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voicemailSettings`
--

DROP TABLE IF EXISTS `voicemailSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voicemailSettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(45) NOT NULL,
  `clientid` varchar(45) NOT NULL,
  `unavailableSound` varchar(45) DEFAULT NULL,
  `recordAfterSound` varchar(45) DEFAULT NULL,
  `maxRecordingLength` varchar(45) DEFAULT NULL,
  `voicemailIvrID` varchar(45) DEFAULT NULL,
  `enterPinSoundID` varchar(45) DEFAULT NULL,
  `pinRetries` int(1) NOT NULL DEFAULT '2',
  `youGotPromptID` varchar(45) DEFAULT NULL,
  `newMsgPromptID` varchar(45) DEFAULT NULL,
  `oldMsgPromptID` varchar(45) DEFAULT NULL,
  `savedMsgPromptID` varchar(45) DEFAULT NULL,
  `newMsgKey` varchar(45) NOT NULL DEFAULT '1',
  `oldMsgKey` varchar(45) NOT NULL DEFAULT '2',
  `savedMsgKey` varchar(45) NOT NULL DEFAULT '3',
  `saveOrDeletePromptID` varchar(45) DEFAULT NULL,
  `deletMsgKey` varchar(45) NOT NULL DEFAULT '2',
  `saveMsgKey` varchar(45) NOT NULL DEFAULT '1',
  `ListenVmailID` varchar(45) DEFAULT NULL,
  `changePinPromptID` varchar(45) DEFAULT NULL,
  `listenRecordVmailPromptID` varchar(45) DEFAULT NULL,
  `recordMsgKey` varchar(45) NOT NULL DEFAULT '2',
  `highPrioKey` varchar(45) NOT NULL DEFAULT '3',
  `listenMsgKey` varchar(45) NOT NULL DEFAULT '1',
  `noNewMsgsPromptID` varchar(45) DEFAULT NULL,
  `retrieveMsgsMenuID` varchar(45) DEFAULT NULL,
  `endOfMessagesPromptID` varchar(45) DEFAULT NULL,
  `invalidPinPromptID` varchar(45) DEFAULT NULL,
  `voicemailRecordedPromptID` varchar(45) DEFAULT NULL,
  `vmSetupPromptID` varchar(45) DEFAULT NULL,
  `changePinKey` varchar(45) NOT NULL DEFAULT '1',
  `recordGreetingKey` varchar(45) NOT NULL DEFAULT '1',
  `msgDeletedPromptID` varchar(45) DEFAULT NULL,
  `firstMsgPromptID` varchar(45) DEFAULT NULL,
  `nextMsgPromptID` varchar(45) DEFAULT NULL,
  `enterNewPinPromptID` varchar(45) DEFAULT NULL,
  `pinUpdatedPromptID` varchar(45) DEFAULT NULL,
  `setupGreetingPromptID` varchar(45) DEFAULT NULL,
  `setupGreetingKey` varchar(45) NOT NULL DEFAULT '2',
  `listenRecordedGreetingKey` varchar(45) NOT NULL DEFAULT '2',
  `saveGreetingKey` varchar(45) NOT NULL DEFAULT '3',
  `msgSavedPromptID` varchar(45) DEFAULT NULL,
  `recordingMenuPromptID` varchar(45) DEFAULT NULL,
  `maxVoicemailMessages` int(2) NOT NULL DEFAULT '9',
  `messagesPromptID` varchar(45) DEFAULT NULL,
  `limitReachedPromptID` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voicemailSettings`
--

LOCK TABLES `voicemailSettings` WRITE;
/*!40000 ALTER TABLE `voicemailSettings` DISABLE KEYS */;
INSERT INTO `voicemailSettings` VALUES (1,'192.168.2.30','1','15','2','60','1','16',2,'19','20','23','22','1','2','3',NULL,'2','1',NULL,NULL,NULL,'2','3','1',NULL,NULL,NULL,NULL,NULL,NULL,'1','2',NULL,NULL,NULL,NULL,NULL,NULL,'2','3','3',NULL,NULL,9,NULL,NULL);
/*!40000 ALTER TABLE `voicemailSettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voicemails`
--

DROP TABLE IF EXISTS `voicemails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voicemails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caller` varchar(45) DEFAULT NULL,
  `destination` varchar(45) DEFAULT NULL,
  `domain` varchar(100) DEFAULT NULL,
  `clientid` varchar(45) DEFAULT NULL,
  `voicemailFile` varchar(255) DEFAULT NULL,
  `recordedAt` datetime DEFAULT NULL,
  `status` enum('old','new','saved','deleted') DEFAULT 'new',
  `duration` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voicemails`
--

LOCK TABLES `voicemails` WRITE;
/*!40000 ALTER TABLE `voicemails` DISABLE KEYS */;
INSERT INTO `voicemails` VALUES (2,'0','10024','192.168.2.30','1','/var/spool/asterisk/recording/Voicemail/1/2020-04-23_23:36:39-Caller:10024-Exten:10025.wav','2020-04-24 03:36:39','new','?'),(3,'0','10024','192.168.2.30','1','/var/spool/asterisk/recording/Voicemail/1/2020-04-23_23:42:38-Caller:10024-Exten:10025.wav','2020-04-24 03:42:38','new','7'),(4,'10024','10024','192.168.2.30','1','/var/spool/asterisk/recording/Voicemail/1/2020-04-24_00:19:15-Caller:10024-Exten:10025.wav','2020-04-24 04:19:15','new','5'),(5,'10024','10025','192.168.2.30','1','/var/spool/asterisk/recording/Voicemail/1/2020-04-24_15:52:59-Caller:10024-Exten:10025.wav','2020-04-24 19:52:59','new','1'),(6,'10024','10025','192.168.2.30','1','/var/spool/asterisk/recording/Voicemail/1/2020-04-24_16:22:25-Caller:10024-Exten:10025.wav','2020-04-24 20:22:25','new','0'),(7,'10024','10025','192.168.2.30','1','/var/spool/asterisk/recording/Voicemail/1/2020-04-24_16:28:47-Caller:10024-Exten:10025.wav','2020-04-24 20:28:47','new','0');
/*!40000 ALTER TABLE `voicemails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `watchers`
--

DROP TABLE IF EXISTS `watchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `presentity_uri` char(255) NOT NULL,
  `watcher_username` char(64) NOT NULL,
  `watcher_domain` char(64) NOT NULL,
  `event` char(64) NOT NULL DEFAULT 'presence',
  `status` int(11) NOT NULL,
  `reason` char(64) DEFAULT NULL,
  `inserted_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `watcher_idx` (`presentity_uri`,`watcher_username`,`watcher_domain`,`event`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watchers`
--

LOCK TABLES `watchers` WRITE;
/*!40000 ALTER TABLE `watchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `watchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xcap`
--

DROP TABLE IF EXISTS `xcap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xcap` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` char(64) NOT NULL,
  `domain` char(64) NOT NULL,
  `doc` longblob NOT NULL,
  `doc_type` int(11) NOT NULL,
  `etag` char(64) NOT NULL,
  `source` int(11) NOT NULL,
  `doc_uri` char(255) NOT NULL,
  `port` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_doc_type_idx` (`username`,`domain`,`doc_type`,`doc_uri`),
  KEY `source_idx` (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xcap`
--

LOCK TABLES `xcap` WRITE;
/*!40000 ALTER TABLE `xcap` DISABLE KEYS */;
/*!40000 ALTER TABLE `xcap` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-14 19:59:17
