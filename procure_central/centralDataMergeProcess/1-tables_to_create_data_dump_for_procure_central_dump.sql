-- ------------------------------------------------------
-- PROCURE Script used to ...
--
-- ------------------------------------------------------
-- Server version	5.7.14

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ad_blocks`
--

DROP TABLE IF EXISTS `ad_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ad_blocks` (
  `aliquot_master_id` int(11) NOT NULL,
  `block_type` varchar(30) DEFAULT NULL,
  `procure_freezing_type` varchar(50) DEFAULT NULL,
  `patho_dpt_block_code` varchar(30) DEFAULT NULL,
  `procure_freezing_ending_time` time DEFAULT NULL,
  `procure_origin_of_slice` varchar(50) DEFAULT NULL,
  `procure_dimensions` varchar(50) DEFAULT NULL,
  `time_spent_collection_to_freezing_end_mn` int(6) DEFAULT NULL,
  `procure_classification` varchar(10) DEFAULT NULL,
  KEY `FK_ad_blocks_aliquot_masters` (`aliquot_master_id`),
  CONSTRAINT `FK_ad_blocks_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ad_blocks`
--

LOCK TABLES `ad_blocks` WRITE;
/*!40000 ALTER TABLE `ad_blocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `ad_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ad_tissue_slides`
--

DROP TABLE IF EXISTS `ad_tissue_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ad_tissue_slides` (
  `aliquot_master_id` int(11) NOT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL,
  `procure_stain` varchar(60) DEFAULT NULL,
  KEY `FK_ad_tissue_slides_aliquot_masters` (`aliquot_master_id`),
  CONSTRAINT `FK_ad_tissue_slides_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ad_tissue_slides`
--

LOCK TABLES `ad_tissue_slides` WRITE;
/*!40000 ALTER TABLE `ad_tissue_slides` DISABLE KEYS */;
/*!40000 ALTER TABLE `ad_tissue_slides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ad_tubes`
--

DROP TABLE IF EXISTS `ad_tubes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ad_tubes` (
  `aliquot_master_id` int(11) NOT NULL,
  `lot_number` varchar(30) DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `concentration_unit` varchar(20) DEFAULT NULL,
  `cell_count` decimal(10,2) DEFAULT NULL,
  `cell_count_unit` varchar(20) DEFAULT NULL,
  `cell_viability` decimal(6,2) DEFAULT NULL,
  `hemolysis_signs` varchar(10) NOT NULL DEFAULT '',
  `procure_deprecated_field_expiration_date` varchar(50) DEFAULT NULL,
  `procure_tube_weight_gr` decimal(8,2) DEFAULT NULL,
  `procure_total_quantity_ug` decimal(8,2) DEFAULT NULL,
  `procure_concentration_nanodrop` decimal(10,2) DEFAULT NULL,
  `procure_concentration_unit_nanodrop` varchar(20) DEFAULT NULL,
  `procure_total_quantity_ug_nanodrop` decimal(8,2) DEFAULT NULL,
  `procure_time_at_minus_80_days` int(5) DEFAULT NULL,
  `procure_date_at_minus_80` date DEFAULT NULL,
  `procure_date_at_minus_80_accuracy` char(1) NOT NULL DEFAULT '',
  KEY `FK_ad_tubes_aliquot_masters` (`aliquot_master_id`),
  CONSTRAINT `FK_ad_tubes_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ad_tubes`
--

LOCK TABLES `ad_tubes` WRITE;
/*!40000 ALTER TABLE `ad_tubes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ad_tubes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ad_tissue_cores`
--

DROP TABLE IF EXISTS `ad_tissue_cores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ad_tissue_cores` (
  `aliquot_master_id` int(11) NOT NULL,
  KEY `FK_ad_tissue_cores_aliquot_masters` (`aliquot_master_id`),
  CONSTRAINT `FK_ad_tissue_cores_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ad_tissue_cores`
--

LOCK TABLES `ad_tissue_cores` WRITE;
/*!40000 ALTER TABLE `ad_tissue_cores` DISABLE KEYS */;
/*!40000 ALTER TABLE `ad_tissue_cores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ad_whatman_papers`
--

DROP TABLE IF EXISTS `ad_whatman_papers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ad_whatman_papers` (
  `aliquot_master_id` int(11) NOT NULL,
  `used_blood_volume` decimal(10,5) DEFAULT NULL,
  `used_blood_volume_unit` varchar(20) DEFAULT NULL,
  `procure_card_sealed_date` datetime DEFAULT NULL,
  `procure_card_sealed_date_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_card_completed_datetime` datetime DEFAULT NULL,
  `procure_card_completed_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  KEY `FK_ad_whatman_papers_aliquot_masters` (`aliquot_master_id`),
  CONSTRAINT `FK_ad_whatman_papers_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ad_whatman_papers`
--

LOCK TABLES `ad_whatman_papers` WRITE;
/*!40000 ALTER TABLE `ad_whatman_papers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ad_whatman_papers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aliquot_controls`
--

DROP TABLE IF EXISTS `aliquot_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliquot_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_control_id` int(11) DEFAULT NULL,
  `aliquot_type` enum('cup','block','cell gel matrix','core','slide','tube','whatman paper','envelope') NOT NULL COMMENT 'Generic name.',
  `aliquot_type_precision` varchar(30) DEFAULT NULL COMMENT 'Use to differentiate two aliquot controls having the same aliquot_type in case they can be used for the same sample type. (Ex: tissue tube (5ml) and tissue tube (cryogenic)).',
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `volume_unit` varchar(20) DEFAULT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `comment` varchar(255) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_aliquot_controls_sample_controls` (`sample_control_id`),
  CONSTRAINT `FK_aliquot_controls_sample_controls` FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aliquot_internal_uses`
--

DROP TABLE IF EXISTS `aliquot_internal_uses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliquot_internal_uses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `use_code` varchar(50) DEFAULT NULL,
  `use_details` varchar(250) DEFAULT NULL,
  `used_volume` decimal(10,5) DEFAULT NULL,
  `use_datetime` datetime DEFAULT NULL,
  `use_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `duration` int(6) DEFAULT NULL,
  `duration_unit` varchar(25) DEFAULT NULL,
  `used_by` varchar(50) DEFAULT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_aliquot_uses_study_summaries` (`study_summary_id`),
  KEY `FK_aliquot_uses_aliquot_masters` (`aliquot_master_id`),
  CONSTRAINT `FK_aliquot_uses_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`),
  CONSTRAINT `FK_aliquot_uses_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aliquot_internal_uses`
--

LOCK TABLES `aliquot_internal_uses` WRITE;
/*!40000 ALTER TABLE `aliquot_internal_uses` DISABLE KEYS */;
/*!40000 ALTER TABLE `aliquot_internal_uses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aliquot_masters`
--

DROP TABLE IF EXISTS `aliquot_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliquot_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `barcode` varchar(60) NOT NULL DEFAULT '',
  `aliquot_label` varchar(60) NOT NULL DEFAULT '',
  `aliquot_control_id` int(11) NOT NULL DEFAULT '0',
  `collection_id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `initial_volume` decimal(10,5) DEFAULT NULL,
  `current_volume` decimal(10,5) DEFAULT NULL,
  `in_stock` varchar(30) DEFAULT NULL,
  `in_stock_detail` varchar(30) DEFAULT NULL,
  `use_counter` int(6) NOT NULL DEFAULT '0',
  `study_summary_id` int(11) DEFAULT NULL,
  `storage_datetime` datetime DEFAULT NULL,
  `storage_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `storage_master_id` int(11) DEFAULT NULL,
  `storage_coord_x` varchar(11) DEFAULT NULL,
  `storage_coord_y` varchar(11) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `notes` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `barcode` (`barcode`),
  KEY `FK_aliquot_masters_aliquot_controls` (`aliquot_control_id`),
  KEY `FK_aliquot_masters_collections` (`collection_id`),
  KEY `FK_aliquot_masters_sample_masters` (`sample_master_id`),
  KEY `FK_aliquot_masters_sops` (`sop_master_id`),
  KEY `FK_aliquot_masters_study_summaries` (`study_summary_id`),
  KEY `FK_aliquot_masters_storage_masters` (`storage_master_id`),
  KEY `barcode_2` (`barcode`),
  CONSTRAINT `FK_aliquot_masters_aliquot_controls` FOREIGN KEY (`aliquot_control_id`) REFERENCES `aliquot_controls` (`id`),
  CONSTRAINT `FK_aliquot_masters_collections` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`),
  CONSTRAINT `FK_aliquot_masters_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`),
  CONSTRAINT `FK_aliquot_masters_sops` FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`),
  CONSTRAINT `FK_aliquot_masters_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`),
  CONSTRAINT `FK_aliquot_masters_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aliquot_masters`
--

LOCK TABLES `aliquot_masters` WRITE;
/*!40000 ALTER TABLE `aliquot_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `aliquot_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aliquot_masters_revs`
--

DROP TABLE IF EXISTS `aliquot_masters_revs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliquot_masters_revs` (
  `id` int(11) NOT NULL,
  `barcode` varchar(60) NOT NULL DEFAULT '',
  `aliquot_label` varchar(60) NOT NULL DEFAULT '',
  `aliquot_control_id` int(11) NOT NULL DEFAULT '0',
  `collection_id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `initial_volume` decimal(10,5) DEFAULT NULL,
  `current_volume` decimal(10,5) DEFAULT NULL,
  `in_stock` varchar(30) DEFAULT NULL,
  `in_stock_detail` varchar(30) DEFAULT NULL,
  `use_counter` int(6) NOT NULL DEFAULT '0',
  `study_summary_id` int(11) DEFAULT NULL,
  `storage_datetime` datetime DEFAULT NULL,
  `storage_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `storage_master_id` int(11) DEFAULT NULL,
  `storage_coord_x` varchar(11) DEFAULT NULL,
  `storage_coord_y` varchar(11) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `notes` text,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aliquot_masters_revs`
--

LOCK TABLES `aliquot_masters_revs` WRITE;
/*!40000 ALTER TABLE `aliquot_masters_revs` DISABLE KEYS */;
/*!40000 ALTER TABLE `aliquot_masters_revs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aliquot_review_controls`
--

DROP TABLE IF EXISTS `aliquot_review_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliquot_review_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `review_type` varchar(100) NOT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `aliquot_type_restriction` varchar(50) NOT NULL DEFAULT 'all',
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `review_type` (`review_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aliquot_review_masters`
--

DROP TABLE IF EXISTS `aliquot_review_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliquot_review_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_review_control_id` int(11) NOT NULL DEFAULT '0',
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `review_code` varchar(100) DEFAULT NULL,
  `basis_of_specimen_review` char(1) DEFAULT '',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_aliquot_review_masters_specimen_review_masters` (`specimen_review_master_id`),
  KEY `FK_aliquot_review_masters_aliquot_review_controls` (`aliquot_review_control_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  CONSTRAINT `FK_aliquot_review_masters_aliquot_review_controls` FOREIGN KEY (`aliquot_review_control_id`) REFERENCES `aliquot_review_controls` (`id`),
  CONSTRAINT `FK_aliquot_review_masters_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`),
  CONSTRAINT `aliquot_review_masters_ibfk_1` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aliquot_review_masters`
--

LOCK TABLES `aliquot_review_masters` WRITE;
/*!40000 ALTER TABLE `aliquot_review_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `aliquot_review_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections`
--

DROP TABLE IF EXISTS `collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acquisition_label` varchar(50) NOT NULL DEFAULT '',
  `bank_id` int(11) DEFAULT NULL,
  `collection_site` varchar(30) DEFAULT NULL,
  `collection_datetime` datetime DEFAULT NULL,
  `collection_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `sop_master_id` int(11) DEFAULT NULL,
  `collection_property` varchar(50) DEFAULT NULL,
  `collection_notes` text,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `consent_master_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_deprecated_field_procure_patient_identity_verified` tinyint(1) DEFAULT '0',
  `procure_visit` varchar(10) DEFAULT NULL,
  `procure_collected_by_bank` char(1) DEFAULT '',
  `collection_protocol_id` int(11) unsigned DEFAULT NULL,
  `template_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `acquisition_label` (`acquisition_label`),
  KEY `FK_collections_banks` (`bank_id`),
  KEY `FK_collections_sops` (`sop_master_id`),
  KEY `participant_id` (`participant_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`),
  KEY `consent_master_id` (`consent_master_id`),
  KEY `treatment_master_id` (`treatment_master_id`),
  KEY `event_master_id` (`event_master_id`),
  KEY `FK_collection_protocols_collections` (`collection_protocol_id`),
  KEY `FK_collection_templates` (`template_id`),
  CONSTRAINT `FK_collection_protocols_collections` FOREIGN KEY (`collection_protocol_id`) REFERENCES `collection_protocols` (`id`),
  CONSTRAINT `FK_collection_templates` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`),
  CONSTRAINT `FK_collections_banks` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`),
  CONSTRAINT `FK_collections_sops` FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`),
  CONSTRAINT `collections_ibfk_1` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`),
  CONSTRAINT `collections_ibfk_2` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`),
  CONSTRAINT `collections_ibfk_3` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`),
  CONSTRAINT `collections_ibfk_4` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`),
  CONSTRAINT `collections_ibfk_5` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consent_controls`
--

DROP TABLE IF EXISTS `consent_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consent_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controls_type` varchar(50) NOT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consent_masters`
--

DROP TABLE IF EXISTS `consent_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consent_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_of_referral` date DEFAULT NULL,
  `date_of_referral_accuracy` char(1) NOT NULL DEFAULT '',
  `route_of_referral` varchar(50) DEFAULT NULL,
  `date_first_contact` date DEFAULT NULL,
  `date_first_contact_accuracy` char(1) NOT NULL DEFAULT '',
  `consent_signed_date` datetime DEFAULT NULL,
  `consent_signed_date_accuracy` char(1) NOT NULL DEFAULT '',
  `form_version` varchar(50) DEFAULT NULL,
  `reason_denied` varchar(200) DEFAULT NULL,
  `consent_status` varchar(50) DEFAULT NULL,
  `process_status` varchar(50) DEFAULT NULL,
  `status_date` date DEFAULT NULL,
  `status_date_accuracy` char(1) NOT NULL DEFAULT '',
  `surgeon` varchar(50) DEFAULT NULL,
  `operation_date` datetime DEFAULT NULL,
  `operation_date_accuracy` char(1) NOT NULL DEFAULT '',
  `facility` varchar(50) DEFAULT NULL,
  `notes` text,
  `consent_method` varchar(50) DEFAULT NULL,
  `translator_indicator` varchar(50) DEFAULT NULL,
  `translator_signature` varchar(50) DEFAULT NULL,
  `consent_person` varchar(50) DEFAULT NULL,
  `facility_other` varchar(50) DEFAULT NULL,
  `acquisition_id` varchar(10) DEFAULT NULL,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `consent_control_id` int(11) NOT NULL DEFAULT '0',
  `type` varchar(10) NOT NULL DEFAULT '',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_deprecated_field_procure_form_identification` varchar(50) DEFAULT NULL,
  `procure_language` varchar(40) DEFAULT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `participant_id` (`participant_id`),
  KEY `consent_control_id` (`consent_control_id`),
  KEY `FK_consent_masters_study_summaries` (`study_summary_id`),
  CONSTRAINT `FK_consent_masters_consent_controls` FOREIGN KEY (`consent_control_id`) REFERENCES `consent_controls` (`id`),
  CONSTRAINT `FK_consent_masters_participant` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`),
  CONSTRAINT `FK_consent_masters_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consent_masters`
--

LOCK TABLES `consent_masters` WRITE;
/*!40000 ALTER TABLE `consent_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `consent_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `derivative_details`
--

DROP TABLE IF EXISTS `derivative_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `derivative_details` (
  `sample_master_id` int(11) NOT NULL,
  `creation_site` varchar(30) DEFAULT NULL,
  `creation_by` varchar(50) DEFAULT NULL,
  `creation_datetime` datetime DEFAULT NULL,
  `lab_book_master_id` int(11) DEFAULT NULL,
  `sync_with_lab_book` tinyint(1) DEFAULT '0',
  `creation_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  KEY `FK_detivative_details_sample_masters` (`sample_master_id`),
  KEY `FK_derivative_details_lab_book_masters` (`lab_book_master_id`),
  CONSTRAINT `FK_derivative_details_lab_book_masters` FOREIGN KEY (`lab_book_master_id`) REFERENCES `lab_book_masters` (`id`),
  CONSTRAINT `FK_detivative_details_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `derivative_details`
--

LOCK TABLES `derivative_details` WRITE;
/*!40000 ALTER TABLE `derivative_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `derivative_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnosis_controls`
--

DROP TABLE IF EXISTS `diagnosis_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `diagnosis_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` enum('primary','secondary - distant','progression - locoregional','remission','recurrence - locoregional') NOT NULL DEFAULT 'primary',
  `controls_type` varchar(50) NOT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `databrowser_label` varchar(200) DEFAULT '',
  `flag_compare_with_cap` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drugs`
--

DROP TABLE IF EXISTS `drugs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `generic_name` varchar(50) NOT NULL DEFAULT '',
  `trade_name` varchar(50) NOT NULL DEFAULT '',
  `type` varchar(50) DEFAULT NULL,
  `description` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_study` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_controls`
--

DROP TABLE IF EXISTS `event_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disease_site` varchar(50) NOT NULL DEFAULT '',
  `event_group` varchar(50) NOT NULL DEFAULT '',
  `event_type` varchar(50) NOT NULL DEFAULT '',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  `flag_use_for_ccl` tinyint(1) NOT NULL DEFAULT '0',
  `use_addgrid` tinyint(1) NOT NULL DEFAULT '0',
  `use_detail_form_for_index` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_masters`
--

DROP TABLE IF EXISTS `event_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_control_id` int(11) NOT NULL DEFAULT '0',
  `event_status` varchar(50) DEFAULT NULL,
  `event_summary` text,
  `event_date` date DEFAULT NULL,
  `event_date_accuracy` char(1) NOT NULL DEFAULT '',
  `information_source` varchar(255) DEFAULT NULL,
  `urgency` varchar(50) DEFAULT NULL,
  `date_required` date DEFAULT NULL,
  `date_required_accuracy` char(1) NOT NULL DEFAULT '',
  `date_requested` date DEFAULT NULL,
  `date_requested_accuracy` char(1) NOT NULL DEFAULT '',
  `reference_number` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_deprecated_field_procure_form_identification` varchar(50) DEFAULT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `participant_id` (`participant_id`),
  KEY `diagnosis_id` (`diagnosis_master_id`),
  KEY `event_control_id` (`event_control_id`),
  CONSTRAINT `FK_event_masters_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`),
  CONSTRAINT `FK_event_masters_event_controls` FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`),
  CONSTRAINT `FK_event_masters_participant` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_masters`
--

LOCK TABLES `event_masters` WRITE;
/*!40000 ALTER TABLE `event_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `misc_identifier_controls`
--

DROP TABLE IF EXISTS `misc_identifier_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `misc_identifier_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `misc_identifier_name` varchar(50) NOT NULL DEFAULT '',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `autoincrement_name` varchar(50) NOT NULL DEFAULT '',
  `misc_identifier_format` varchar(50) DEFAULT NULL,
  `flag_once_per_participant` tinyint(1) NOT NULL DEFAULT '0',
  `flag_confidential` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `flag_unique` tinyint(1) NOT NULL DEFAULT '1',
  `pad_to_length` tinyint(4) NOT NULL DEFAULT '0',
  `reg_exp_validation` varchar(50) NOT NULL DEFAULT '',
  `user_readable_format` varchar(50) NOT NULL DEFAULT '',
  `flag_link_to_study` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_misc_identifier_name` (`misc_identifier_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `misc_identifiers`
--

DROP TABLE IF EXISTS `misc_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `misc_identifiers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier_value` varchar(40) DEFAULT NULL,
  `misc_identifier_control_id` int(11) NOT NULL DEFAULT '0',
  `effective_date` date DEFAULT NULL,
  `effective_date_accuracy` char(1) NOT NULL DEFAULT '',
  `expiry_date` date DEFAULT NULL,
  `expiry_date_accuracy` char(1) NOT NULL DEFAULT '',
  `notes` varchar(100) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tmp_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `flag_unique` tinyint(4) DEFAULT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `misc_identifier_control_id` (`misc_identifier_control_id`,`identifier_value`,`flag_unique`),
  KEY `participant_id` (`participant_id`),
  KEY `FK_misc_identifiers_misc_identifier_controls` (`misc_identifier_control_id`),
  KEY `FK_misc_identifiers_study_summaries` (`study_summary_id`),
  CONSTRAINT `FK_misc_identifiers_misc_identifier_controls` FOREIGN KEY (`misc_identifier_control_id`) REFERENCES `misc_identifier_controls` (`id`),
  CONSTRAINT `FK_misc_identifiers_participant` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`),
  CONSTRAINT `FK_misc_identifiers_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `misc_identifiers`
--

LOCK TABLES `misc_identifiers` WRITE;
/*!40000 ALTER TABLE `misc_identifiers` DISABLE KEYS */;
/*!40000 ALTER TABLE `misc_identifiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_number` varchar(255) NOT NULL,
  `short_title` varchar(45) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date_order_placed` date DEFAULT NULL,
  `date_order_placed_accuracy` char(1) NOT NULL DEFAULT '',
  `date_order_completed` date DEFAULT NULL,
  `date_order_completed_accuracy` char(1) NOT NULL DEFAULT '',
  `processing_status` varchar(45) NOT NULL DEFAULT '',
  `comments` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `default_study_summary_id` int(11) DEFAULT NULL,
  `institution` varchar(50) NOT NULL DEFAULT '',
  `contact` varchar(50) NOT NULL DEFAULT '',
  `default_required_date` date DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `default_required_date_accuracy` char(1) DEFAULT 'c',
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `order_number` (`order_number`),
  KEY `FK_orders_study_summaries` (`default_study_summary_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`default_study_summary_id`) REFERENCES `study_summaries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_added` date DEFAULT NULL,
  `date_added_accuracy` char(1) NOT NULL DEFAULT '',
  `added_by` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `order_line_id` int(11) DEFAULT NULL,
  `shipment_id` int(11) DEFAULT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `order_id` int(11) NOT NULL,
  `procure_shipping_aliquot_label` varchar(60) DEFAULT NULL,
  `date_returned` date DEFAULT NULL,
  `date_returned_accuracy` char(1) NOT NULL DEFAULT '',
  `reason_returned` varchar(250) DEFAULT NULL,
  `reception_by` varchar(255) DEFAULT NULL,
  `tma_slide_id` int(11) DEFAULT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  `order_item_shipping_label` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_order_items_order_lines` (`order_line_id`),
  KEY `FK_order_items_shipments` (`shipment_id`),
  KEY `FK_order_items_aliquot_masters` (`aliquot_master_id`),
  KEY `FK_order_items_orders` (`order_id`),
  KEY `FK_order_items_tma_slides` (`tma_slide_id`),
  CONSTRAINT `FK_order_items_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`),
  CONSTRAINT `FK_order_items_order_lines` FOREIGN KEY (`order_line_id`) REFERENCES `order_lines` (`id`),
  CONSTRAINT `FK_order_items_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FK_order_items_shipments` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`),
  CONSTRAINT `FK_order_items_tma_slides` FOREIGN KEY (`tma_slide_id`) REFERENCES `tma_slides` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_lines`
--

DROP TABLE IF EXISTS `order_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_lines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity_ordered` varchar(30) DEFAULT NULL,
  `min_quantity_ordered` varchar(30) DEFAULT NULL,
  `quantity_unit` varchar(10) DEFAULT NULL,
  `date_required` date DEFAULT NULL,
  `date_required_accuracy` char(1) NOT NULL DEFAULT '',
  `status` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `sample_control_id` int(11) DEFAULT NULL,
  `aliquot_control_id` int(11) DEFAULT NULL,
  `product_type_precision` varchar(30) DEFAULT NULL,
  `order_id` int(11) NOT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_tma_slide` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_order_lines_orders` (`order_id`),
  KEY `FK_order_lines_sample_controls` (`sample_control_id`),
  KEY `FK_order_lines_aliquot_controls` (`aliquot_control_id`),
  KEY `study_summary_id` (`study_summary_id`),
  CONSTRAINT `FK_order_lines_aliquot_controls` FOREIGN KEY (`aliquot_control_id`) REFERENCES `aliquot_controls` (`id`),
  CONSTRAINT `FK_order_lines_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `FK_order_lines_sample_controls` FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`),
  CONSTRAINT `order_lines_ibfk_1` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_lines`
--

LOCK TABLES `order_lines` WRITE;
/*!40000 ALTER TABLE `order_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participants`
--

DROP TABLE IF EXISTS `participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(10) DEFAULT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `date_of_birth_accuracy` char(1) NOT NULL DEFAULT '',
  `marital_status` varchar(50) DEFAULT NULL,
  `language_preferred` varchar(30) DEFAULT NULL,
  `sex` varchar(20) DEFAULT NULL,
  `race` varchar(50) DEFAULT NULL,
  `vital_status` varchar(50) DEFAULT NULL,
  `notes` text,
  `date_of_death` date DEFAULT NULL,
  `date_of_death_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_cause_of_death` varchar(50) DEFAULT NULL,
  `cod_icd10_code` varchar(50) DEFAULT NULL,
  `secondary_cod_icd10_code` varchar(50) DEFAULT NULL,
  `cod_confirmation_source` varchar(50) DEFAULT NULL,
  `participant_identifier` varchar(50) DEFAULT NULL,
  `last_chart_checked_date` date DEFAULT NULL,
  `last_chart_checked_date_accuracy` char(1) NOT NULL DEFAULT '',
  `last_modification` datetime NOT NULL,
  `last_modification_ds_id` int(10) unsigned NOT NULL DEFAULT '1',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_patient_withdrawn` tinyint(1) DEFAULT '0',
  `procure_patient_refusal_withdrawal_date` date DEFAULT NULL,
  `procure_patient_refusal_withdrawal_date_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_patient_refusal_withdrawal_reason` text,
  `procure_transferred_participant` char(1) DEFAULT 'n',
  `procure_participant_attribution_number` int(10) DEFAULT NULL,
  `procure_last_modification_by_bank` char(1) DEFAULT '',
  `procure_last_contact` date DEFAULT NULL,
  `procure_last_contact_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_last_contact_details` text,
  `procure_next_collections_refusal` tinyint(1) DEFAULT '0',
  `procure_next_visits_refusal` tinyint(1) DEFAULT '0',
  `procure_refusal_to_be_contacted` tinyint(1) DEFAULT '0',
  `procure_clinical_file_update_refusal` tinyint(1) DEFAULT '0',
  `procure_contact_lost` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `participant_identifier` (`participant_identifier`),
  KEY `FK_participants_icd10_code` (`cod_icd10_code`),
  KEY `FK_participants_icd10_code_2` (`secondary_cod_icd10_code`),
  KEY `last_modification_ds_id` (`last_modification_ds_id`),
  CONSTRAINT `participants_ibfk_1` FOREIGN KEY (`last_modification_ds_id`) REFERENCES `datamart_structures` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participants`
--

LOCK TABLES `participants` WRITE;
/*!40000 ALTER TABLE `participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parent_to_derivative_sample_controls`
--

DROP TABLE IF EXISTS `parent_to_derivative_sample_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parent_to_derivative_sample_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_sample_control_id` int(11) DEFAULT NULL,
  `derivative_sample_control_id` int(11) DEFAULT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `lab_book_control_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parent_to_derivative_sample` (`parent_sample_control_id`,`derivative_sample_control_id`),
  KEY `FK_parent_to_derivative_sample_controls_derivative` (`derivative_sample_control_id`),
  KEY `FK_parent_to_derivative_sample_controls_lab_book_controls` (`lab_book_control_id`),
  CONSTRAINT `FK_parent_to_derivative_sample_controls_derivative` FOREIGN KEY (`derivative_sample_control_id`) REFERENCES `sample_controls` (`id`),
  CONSTRAINT `FK_parent_to_derivative_sample_controls_lab_book_controls` FOREIGN KEY (`lab_book_control_id`) REFERENCES `lab_book_controls` (`id`),
  CONSTRAINT `FK_parent_to_derivative_sample_controls_parent` FOREIGN KEY (`parent_sample_control_id`) REFERENCES `sample_controls` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=238 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `procure_cd_sigantures`
--

DROP TABLE IF EXISTS `procure_cd_sigantures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_cd_sigantures` (
  `consent_master_id` int(11) NOT NULL,
  `revised_date` date DEFAULT NULL,
  `revised_date_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_deprecated_field_patient_identity_verified` tinyint(1) DEFAULT '0',
  `ps1_biological_material_use` varchar(50) DEFAULT NULL,
  `ps1_use_of_urine` varchar(50) DEFAULT NULL,
  `ps1_use_of_blood` varchar(50) DEFAULT NULL,
  `ps1_research_other_disease` varchar(50) DEFAULT NULL,
  `ps1_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  `ps1_stop_followup` varchar(10) DEFAULT NULL,
  `ps1_stop_followup_date` date DEFAULT NULL,
  `ps1_allow_questionnaire` varchar(10) DEFAULT NULL,
  `ps1_stop_questionnaire` varchar(10) DEFAULT NULL,
  `ps1_stop_questionnaire_date` date DEFAULT NULL,
  `ps1_contact_for_additional_data` varchar(10) DEFAULT NULL,
  `ps1_inform_significant_discovery` varchar(50) DEFAULT NULL,
  `ps1_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL,
  `ps2_tissue` char(1) DEFAULT '',
  `ps2_blood` char(1) DEFAULT '',
  `ps2_urine` char(1) DEFAULT '',
  `ps2_followup` char(1) DEFAULT '',
  `ps2_questionnaire` char(1) DEFAULT '',
  `ps2_contact_for_additional_data` char(1) DEFAULT '',
  `ps2_inform_significant_discovery` char(1) DEFAULT '',
  `ps2_contact_in_case_of_death` char(1) DEFAULT '',
  `ps2_witness` char(1) DEFAULT '',
  `ps2_complete` char(1) DEFAULT '',
  `ps4_contact_for_more_info` char(1) DEFAULT '',
  `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
  `ps4_study_on_other_diseases` char(1) DEFAULT '',
  `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
  `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '',
  KEY `consent_master_id` (`consent_master_id`),
  CONSTRAINT `procure_cd_sigantures_ibfk_2` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_cd_sigantures`
--

LOCK TABLES `procure_cd_sigantures` WRITE;
/*!40000 ALTER TABLE `procure_cd_sigantures` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_cd_sigantures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ar_tissue_slides`
--

DROP TABLE IF EXISTS `procure_ar_tissue_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ar_tissue_slides` (
  `aliquot_review_master_id` int(11) NOT NULL,
  `gleason_grade` varchar(5) DEFAULT NULL,
  `gleason_sum` int(3) DEFAULT NULL,
  `tissue_type` varchar(20) DEFAULT NULL,
  `tumor_pct` decimal(6,1) DEFAULT NULL,
  `tumor_size_length_mm` decimal(6,1) DEFAULT NULL,
  `tumor_size_width_mm` decimal(6,1) DEFAULT NULL,
  KEY `FK_procure_ar_tissue_slides_aliquot_review_masters` (`aliquot_review_master_id`),
  CONSTRAINT `FK_procure_ar_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ar_tissue_slides`
--

LOCK TABLES `procure_ar_tissue_slides` WRITE;
/*!40000 ALTER TABLE `procure_ar_tissue_slides` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ar_tissue_slides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_clinical_exams`
--

DROP TABLE IF EXISTS `procure_ed_clinical_exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_clinical_exams` (
  `type` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `results` varchar(50) DEFAULT NULL,
  `site_precision` varchar(100) DEFAULT NULL,
  `progression_comorbidity` varchar(100) DEFAULT NULL,
  `clinical_relapse` char(1) DEFAULT '',
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_clinical_exams`
--

LOCK TABLES `procure_ed_clinical_exams` WRITE;
/*!40000 ALTER TABLE `procure_ed_clinical_exams` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_clinical_exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_clinical_notes`
--

DROP TABLE IF EXISTS `procure_ed_clinical_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_clinical_notes` (
  `event_master_id` int(11) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `procure_ed_clinical_notes_ibfk_2` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_clinical_notes`
--

LOCK TABLES `procure_ed_clinical_notes` WRITE;
/*!40000 ALTER TABLE `procure_ed_clinical_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_clinical_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_laboratories`
--

DROP TABLE IF EXISTS `procure_ed_laboratories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_laboratories` (
  `psa_total_ngml` decimal(10,2) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `biochemical_relapse` char(1) DEFAULT '',
  `testosterone_nmoll` decimal(10,2) DEFAULT NULL,
  `procure_deprecated_field_psa_free_ngml` decimal(10,2) DEFAULT NULL,
  `bcr_definition_precision` text,
  `system_biochemical_relapse` char(1) DEFAULT '',
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_laboratories`
--

LOCK TABLES `procure_ed_laboratories` WRITE;
/*!40000 ALTER TABLE `procure_ed_laboratories` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_laboratories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_lab_pathologies`
--

DROP TABLE IF EXISTS `procure_ed_lab_pathologies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_lab_pathologies` (
  `path_number` varchar(50) DEFAULT NULL,
  `pathologist_name` varchar(250) DEFAULT NULL,
  `prostate_weight_gr` decimal(10,2) DEFAULT NULL,
  `prostate_length_cm` decimal(10,2) DEFAULT NULL,
  `prostate_width_cm` decimal(10,2) DEFAULT NULL,
  `prostate_thickness_cm` decimal(10,2) DEFAULT NULL,
  `right_seminal_vesicle_length_cm` decimal(10,2) DEFAULT NULL,
  `right_seminal_vesicle_width_cm` decimal(10,2) DEFAULT NULL,
  `right_seminal_vesicle_thickness_cm` decimal(10,2) DEFAULT NULL,
  `left_seminal_vesicle_length_cm` decimal(10,2) DEFAULT NULL,
  `left_seminal_vesicle_width_cm` decimal(10,2) DEFAULT NULL,
  `left_seminal_vesicle_thickness_cm` decimal(10,2) DEFAULT NULL,
  `histology` varchar(50) DEFAULT NULL,
  `histology_other_precision` varchar(250) DEFAULT NULL,
  `tumour_location_right_anterior` tinyint(1) DEFAULT '0',
  `tumour_location_left_anterior` tinyint(1) DEFAULT '0',
  `tumour_location_right_posterior` tinyint(1) DEFAULT '0',
  `tumour_location_left_posterior` tinyint(1) DEFAULT '0',
  `tumour_location_apex` tinyint(1) DEFAULT '0',
  `tumour_location_base` tinyint(1) DEFAULT '0',
  `tumour_location_bladder_neck` tinyint(1) DEFAULT '0',
  `tumour_volume` varchar(50) DEFAULT NULL,
  `histologic_grade_primary_pattern` varchar(50) DEFAULT NULL,
  `histologic_grade_secondary_pattern` varchar(50) DEFAULT NULL,
  `histologic_grade_tertiary_pattern` varchar(50) DEFAULT NULL,
  `histologic_grade_gleason_score` varchar(50) DEFAULT NULL,
  `margins` varchar(50) DEFAULT NULL,
  `margins_focal_or_extensive` varchar(50) DEFAULT NULL,
  `margins_extensive_anterior_left` tinyint(1) DEFAULT '0',
  `margins_extensive_anterior_right` tinyint(1) DEFAULT '0',
  `margins_extensive_posterior_left` tinyint(1) DEFAULT '0',
  `margins_extensive_posterior_right` tinyint(1) DEFAULT '0',
  `margins_extensive_apical_anterior_left` tinyint(1) DEFAULT '0',
  `margins_extensive_apical_anterior_right` tinyint(1) DEFAULT '0',
  `margins_extensive_apical_posterior_left` tinyint(1) DEFAULT '0',
  `margins_extensive_apical_posterior_right` tinyint(1) DEFAULT '0',
  `margins_extensive_bladder_neck` tinyint(1) DEFAULT '0',
  `margins_extensive_base` tinyint(1) DEFAULT '0',
  `margins_gleason_score` varchar(50) DEFAULT NULL,
  `extra_prostatic_extension` varchar(50) DEFAULT NULL,
  `extra_prostatic_extension_precision` varchar(50) DEFAULT NULL,
  `extra_prostatic_extension_right_anterior` tinyint(1) DEFAULT '0',
  `extra_prostatic_extension_left_anterior` tinyint(1) DEFAULT '0',
  `extra_prostatic_extension_right_posterior` tinyint(1) DEFAULT '0',
  `extra_prostatic_extension_left_posterior` tinyint(1) DEFAULT '0',
  `extra_prostatic_extension_apex` tinyint(1) DEFAULT '0',
  `extra_prostatic_extension_base` tinyint(1) DEFAULT '0',
  `extra_prostatic_extension_bladder_neck` tinyint(1) DEFAULT '0',
  `extra_prostatic_extension_seminal_vesicles` varchar(50) DEFAULT NULL,
  `pathologic_staging_version` varchar(50) DEFAULT NULL,
  `pathologic_staging_pt` varchar(50) DEFAULT NULL,
  `pathologic_staging_pn_collected` char(1) DEFAULT '',
  `pathologic_staging_pn` varchar(50) DEFAULT NULL,
  `pathologic_staging_pn_lymph_node_examined` int(6) DEFAULT NULL,
  `pathologic_staging_pn_lymph_node_involved` int(6) DEFAULT NULL,
  `pathologic_staging_pm` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `procure_ed_lab_pathologies_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_lab_pathologies`
--

LOCK TABLES `procure_ed_lab_pathologies` WRITE;
/*!40000 ALTER TABLE `procure_ed_lab_pathologies` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_lab_pathologies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_other_tumor_diagnosis`
--

DROP TABLE IF EXISTS `procure_ed_other_tumor_diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_other_tumor_diagnosis` (
  `event_master_id` int(11) NOT NULL,
  `tumor_site` varchar(100) DEFAULT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `procure_ed_other_tumor_diagnosis_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_other_tumor_diagnosis`
--

LOCK TABLES `procure_ed_other_tumor_diagnosis` WRITE;
/*!40000 ALTER TABLE `procure_ed_other_tumor_diagnosis` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_other_tumor_diagnosis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_prostate_cancer_diagnosis`
--

DROP TABLE IF EXISTS `procure_ed_prostate_cancer_diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_prostate_cancer_diagnosis` (
  `procure_deprecated_field_data_collection_date` date DEFAULT NULL,
  `procure_deprecated_field_data_collection_date_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_deprecated_field_patient_identity_verified` tinyint(1) DEFAULT '0',
  `biopsy_pre_surgery_date` date DEFAULT NULL,
  `biopsy_pre_surgery_date_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_deprecated_aps_pre_surgery_total_ng_ml` decimal(10,2) DEFAULT NULL,
  `procure_deprecated_aps_pre_surgery_free_ng_ml` decimal(10,2) DEFAULT NULL,
  `procure_deprecated_field_aps_pre_surgery_date` date DEFAULT NULL,
  `procure_deprecated_field_aps_pre_surgery_date_accuracy` char(1) NOT NULL DEFAULT '',
  `collected_cores_nbr` int(4) DEFAULT NULL,
  `nbr_of_cores_with_cancer` int(4) DEFAULT NULL,
  `histologic_grade_primary_pattern` varchar(50) DEFAULT NULL,
  `histologic_grade_secondary_pattern` varchar(50) DEFAULT NULL,
  `histologic_grade_gleason_total` varchar(50) DEFAULT NULL,
  `procure_deprecated_field_biopsies_before` char(1) NOT NULL DEFAULT '',
  `procure_deprecated_field_biopsy_date` date DEFAULT NULL,
  `procure_deprecated_field_biopsy_date_accuracy` char(1) NOT NULL DEFAULT '',
  `event_master_id` int(11) NOT NULL,
  `affected_core_localisation` varchar(250) DEFAULT NULL,
  `affected_core_total_percentage` decimal(10,2) DEFAULT NULL,
  `highest_gleason_score_observed` varchar(50) DEFAULT NULL,
  `highest_gleason_score_percentage` decimal(10,2) DEFAULT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `procure_ed_prostate_cancer_diagnosis_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_prostate_cancer_diagnosis`
--

LOCK TABLES `procure_ed_prostate_cancer_diagnosis` WRITE;
/*!40000 ALTER TABLE `procure_ed_prostate_cancer_diagnosis` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_prostate_cancer_diagnosis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_questionnaires`
--

DROP TABLE IF EXISTS `procure_ed_questionnaires`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_questionnaires` (
  `procure_deprecated_field_patient_identity_verified` tinyint(1) DEFAULT '0',
  `delivery_date` date DEFAULT NULL,
  `delivery_date_accuracy` char(1) NOT NULL DEFAULT '',
  `delivery_site_method` varchar(50) DEFAULT NULL,
  `method_to_complete` varchar(50) DEFAULT NULL,
  `recovery_date` date DEFAULT NULL,
  `recovery_date_accuracy` char(1) NOT NULL DEFAULT '',
  `recovery_method` varchar(50) DEFAULT NULL,
  `verification_date` date DEFAULT NULL,
  `verification_date_accuracy` char(1) NOT NULL DEFAULT '',
  `revision_date` date DEFAULT NULL,
  `revision_date_accuracy` char(1) NOT NULL DEFAULT '',
  `revision_method` varchar(50) DEFAULT NULL,
  `version` varchar(50) DEFAULT NULL,
  `version_date` varchar(50) DEFAULT NULL,
  `spent_time_delivery_to_recovery` int(6) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `complete` char(1) DEFAULT '',
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `procure_ed_questionnaires_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_questionnaires`
--

LOCK TABLES `procure_ed_questionnaires` WRITE;
/*!40000 ALTER TABLE `procure_ed_questionnaires` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_questionnaires` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_ed_visits`
--

DROP TABLE IF EXISTS `procure_ed_visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_ed_visits` (
  `procure_deprecated_field_patient_identity_verified` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_biochemical_recurrence` char(1) DEFAULT '',
  `procure_deprecated_field_clinical_recurrence` char(1) DEFAULT '',
  `procure_deprecated_field_clinical_recurrence_type` varchar(50) DEFAULT NULL,
  `procure_deprecated_field_surgery_for_metastases` char(1) DEFAULT '',
  `procure_deprecated_field_surgery_site` varchar(250) DEFAULT NULL,
  `procure_deprecated_field_surgery_date` date DEFAULT NULL,
  `surgery_date_accuracy` char(1) NOT NULL DEFAULT '',
  `event_master_id` int(11) NOT NULL,
  `procure_deprecated_field_clinical_recurrence_site_bones` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_clinical_recurrence_site_liver` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_clinical_recurrence_site_lungs` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_clinical_recurrence_site_others` tinyint(1) DEFAULT '0',
  `refusing_treatments` char(1) DEFAULT '',
  `method` varchar(50) DEFAULT NULL,
  `medication_for_prostate_cancer` char(1) DEFAULT '',
  `medication_for_benign_prostatic_hyperplasia` char(1) DEFAULT '',
  `medication_for_prostatitis` char(1) DEFAULT '',
  `prescribed_drugs_for_other_diseases` char(1) DEFAULT '',
  `list_of_drugs_for_other_diseases` char(1) DEFAULT '',
  `photocopy_of_drugs_for_other_diseases` char(1) DEFAULT '',
  `dosages_of_drugs_for_other_diseases` char(1) DEFAULT '',
  `open_sale_drugs` char(1) DEFAULT '',
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `procure_ed_visits_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_ed_visits`
--

LOCK TABLES `procure_ed_visits` WRITE;
/*!40000 ALTER TABLE `procure_ed_visits` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_ed_visits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_spr_prostate`
--

DROP TABLE IF EXISTS `procure_spr_prostate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_spr_prostate` (
  `specimen_review_master_id` int(11) NOT NULL,
  KEY `FK_procure_spr_prostate_specimen_review_masters` (`specimen_review_master_id`),
  CONSTRAINT `FK_procure_spr_prostate_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_spr_prostate`
--

LOCK TABLES `procure_spr_prostate` WRITE;
/*!40000 ALTER TABLE `procure_spr_prostate` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_spr_prostate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procure_txd_treatments`
--

DROP TABLE IF EXISTS `procure_txd_treatments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procure_txd_treatments` (
  `treatment_type` varchar(50) DEFAULT NULL,
  `dosage` varchar(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `procure_deprecated_field_drug_id` int(11) DEFAULT NULL,
  `treatment_site` varchar(100) DEFAULT NULL,
  `treatment_precision` varchar(50) DEFAULT NULL,
  `treatment_combination` char(1) DEFAULT '',
  `procure_deprecated_field_treatment_line` varchar(3) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `surgery_type` varchar(100) DEFAULT NULL,
  KEY `tx_master_id` (`treatment_master_id`),
  KEY `FK_procure_txd_followup_worksheet_treatments_drugs` (`procure_deprecated_field_drug_id`),
  CONSTRAINT `procure_txd_treatments_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procure_txd_treatments`
--

LOCK TABLES `procure_txd_treatments` WRITE;
/*!40000 ALTER TABLE `procure_txd_treatments` DISABLE KEYS */;
/*!40000 ALTER TABLE `procure_txd_treatments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quality_ctrls`
--

DROP TABLE IF EXISTS `quality_ctrls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quality_ctrls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `qc_code` varchar(20) DEFAULT NULL,
  `sample_master_id` int(11) NOT NULL,
  `type` varchar(30) DEFAULT NULL,
  `qc_type_precision` varchar(250) DEFAULT NULL,
  `tool` varchar(30) DEFAULT NULL,
  `run_id` varchar(30) DEFAULT NULL,
  `run_by` varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `date_accuracy` char(1) NOT NULL DEFAULT '',
  `score` varchar(30) DEFAULT NULL,
  `unit` varchar(30) DEFAULT NULL,
  `conclusion` varchar(30) DEFAULT NULL,
  `notes` text,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `used_volume` decimal(10,5) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_appended_spectras` varchar(250) DEFAULT NULL,
  `procure_analysis_by` varchar(50) DEFAULT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  `procure_concentration` decimal(10,2) DEFAULT NULL,
  `procure_concentration_unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_qc_code` (`qc_code`),
  KEY `run_id` (`run_id`),
  KEY `FK_quality_ctrls_sample_masters` (`sample_master_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  CONSTRAINT `FK_quality_ctrls_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`),
  CONSTRAINT `quality_ctrls_ibfk_1` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quality_ctrls`
--

LOCK TABLES `quality_ctrls` WRITE;
/*!40000 ALTER TABLE `quality_ctrls` DISABLE KEYS */;
/*!40000 ALTER TABLE `quality_ctrls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realiquotings`
--

DROP TABLE IF EXISTS `realiquotings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realiquotings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_aliquot_master_id` int(11) NOT NULL,
  `child_aliquot_master_id` int(11) NOT NULL,
  `parent_used_volume` decimal(10,5) DEFAULT NULL,
  `realiquoting_datetime` datetime DEFAULT NULL,
  `realiquoting_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `realiquoted_by` varchar(50) DEFAULT NULL,
  `lab_book_master_id` int(11) DEFAULT NULL,
  `sync_with_lab_book` tinyint(1) DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_central_is_transfer` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_realiquotings_parent_aliquot_masters` (`parent_aliquot_master_id`),
  KEY `FK_realiquotings_child_aliquot_masters` (`child_aliquot_master_id`),
  KEY `FK_realiquotings_lab_book_masters` (`lab_book_master_id`),
  CONSTRAINT `FK_realiquotings_child_aliquot_masters` FOREIGN KEY (`child_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`),
  CONSTRAINT `FK_realiquotings_lab_book_masters` FOREIGN KEY (`lab_book_master_id`) REFERENCES `lab_book_masters` (`id`),
  CONSTRAINT `FK_realiquotings_parent_aliquot_masters` FOREIGN KEY (`parent_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realiquotings`
--

LOCK TABLES `realiquotings` WRITE;
/*!40000 ALTER TABLE `realiquotings` DISABLE KEYS */;
/*!40000 ALTER TABLE `realiquotings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_controls`
--

DROP TABLE IF EXISTS `sample_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_type` varchar(30) NOT NULL DEFAULT '',
  `sample_category` enum('specimen','derivative') NOT NULL,
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sample_type` (`sample_type`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_masters`
--

DROP TABLE IF EXISTS `sample_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_code` varchar(30) NOT NULL DEFAULT '',
  `sample_control_id` int(11) NOT NULL DEFAULT '0',
  `initial_specimen_sample_id` int(11) DEFAULT NULL,
  `initial_specimen_sample_type` varchar(30) NOT NULL DEFAULT '',
  `collection_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `parent_sample_type` varchar(30) DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `is_problematic` char(1) DEFAULT '',
  `notes` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_sample_code` (`sample_code`),
  KEY `sample_code` (`sample_code`),
  KEY `FK_sample_masters_collections` (`collection_id`),
  KEY `FK_sample_masters_sample_controls` (`sample_control_id`),
  KEY `FK_sample_masters_sample_specimens` (`initial_specimen_sample_id`),
  KEY `FK_sample_masters_parent` (`parent_id`),
  KEY `FK_sample_masters_sops` (`sop_master_id`),
  CONSTRAINT `FK_sample_masters_collections` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`),
  CONSTRAINT `FK_sample_masters_parent` FOREIGN KEY (`parent_id`) REFERENCES `sample_masters` (`id`),
  CONSTRAINT `FK_sample_masters_sample_controls` FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`),
  CONSTRAINT `FK_sample_masters_sample_specimens` FOREIGN KEY (`initial_specimen_sample_id`) REFERENCES `sample_masters` (`id`),
  CONSTRAINT `FK_sample_masters_sops` FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_masters`
--

LOCK TABLES `sample_masters` WRITE;
/*!40000 ALTER TABLE `sample_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_amp_rnas`
--

DROP TABLE IF EXISTS `sd_der_amp_rnas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_amp_rnas` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_amp_rnas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_amp_rnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_amp_rnas`
--

LOCK TABLES `sd_der_amp_rnas` WRITE;
/*!40000 ALTER TABLE `sd_der_amp_rnas` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_amp_rnas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_buffy_coats`
--

DROP TABLE IF EXISTS `sd_der_buffy_coats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_buffy_coats` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_buffy_coats_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_buffy_coats_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_buffy_coats`
--

LOCK TABLES `sd_der_buffy_coats` WRITE;
/*!40000 ALTER TABLE `sd_der_buffy_coats` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_buffy_coats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_cdnas`
--

DROP TABLE IF EXISTS `sd_der_cdnas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_cdnas` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_cdnas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_cdnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_cdnas`
--

LOCK TABLES `sd_der_cdnas` WRITE;
/*!40000 ALTER TABLE `sd_der_cdnas` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_cdnas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_dnas`
--

DROP TABLE IF EXISTS `sd_der_dnas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_dnas` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_dnas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_dnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_dnas`
--

LOCK TABLES `sd_der_dnas` WRITE;
/*!40000 ALTER TABLE `sd_der_dnas` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_dnas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_pbmcs`
--

DROP TABLE IF EXISTS `sd_der_pbmcs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_pbmcs` (
  `sample_master_id` int(11) NOT NULL,
  `procure_blood_volume_used_ml` decimal(10,5) DEFAULT NULL,
  KEY `FK_sd_der_pbmcs_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_pbmcs_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_pbmcs`
--

LOCK TABLES `sd_der_pbmcs` WRITE;
/*!40000 ALTER TABLE `sd_der_pbmcs` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_pbmcs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_plasmas`
--

DROP TABLE IF EXISTS `sd_der_plasmas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_plasmas` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_plasmas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_plasmas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_plasmas`
--

LOCK TABLES `sd_der_plasmas` WRITE;
/*!40000 ALTER TABLE `sd_der_plasmas` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_plasmas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_rnas`
--

DROP TABLE IF EXISTS `sd_der_rnas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_rnas` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_rnas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_rnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_rnas`
--

LOCK TABLES `sd_der_rnas` WRITE;
/*!40000 ALTER TABLE `sd_der_rnas` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_rnas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_serums`
--

DROP TABLE IF EXISTS `sd_der_serums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_serums` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_serums_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_serums_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_serums`
--

LOCK TABLES `sd_der_serums` WRITE;
/*!40000 ALTER TABLE `sd_der_serums` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_serums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_der_urine_cents`
--

DROP TABLE IF EXISTS `sd_der_urine_cents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_der_urine_cents` (
  `sample_master_id` int(11) NOT NULL,
  `procure_deprecated_field_processed_at_reception` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_conserved_at_4` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_time_at_4` int(6) DEFAULT NULL,
  `procure_deprecated_field_aspect_after_refrigeration` varchar(50) DEFAULT NULL,
  `procure_deprecated_field_other_aspect_after_refrigeration` varchar(250) DEFAULT NULL,
  `procure_deprecated_field_aspect_after_centrifugation` varchar(50) DEFAULT NULL,
  `procure_deprecated_field_other_aspect_after_centrifugation` varchar(250) DEFAULT NULL,
  `procure_pellet_aspect_after_centrifugation` varchar(50) DEFAULT NULL,
  `procure_other_pellet_aspect_after_centrifugation` varchar(250) DEFAULT NULL,
  `procure_approximatif_pellet_volume_ml` decimal(10,5) DEFAULT NULL,
  `procure_deprecated_field_procure_pellet_volume_ml` decimal(10,5) DEFAULT NULL,
  `procure_concentrated` char(1) NOT NULL DEFAULT 'n',
  KEY `FK_sd_der_urine_cents_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_urine_cents_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_der_urine_cents`
--

LOCK TABLES `sd_der_urine_cents` WRITE;
/*!40000 ALTER TABLE `sd_der_urine_cents` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_der_urine_cents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_spe_bloods`
--

DROP TABLE IF EXISTS `sd_spe_bloods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_spe_bloods` (
  `sample_master_id` int(11) NOT NULL,
  `blood_type` varchar(30) DEFAULT NULL,
  `collected_tube_nbr` int(4) DEFAULT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `procure_collection_site` varchar(250) DEFAULT NULL,
  `procure_deprecated_field_collection_without_incident` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_tubes_inverted_8_10_times` tinyint(1) DEFAULT '0',
  `procure_deprecated_field_tubes_correclty_stored` tinyint(1) DEFAULT '0',
  KEY `FK_sd_spe_bloods_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_bloods_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_spe_bloods`
--

LOCK TABLES `sd_spe_bloods` WRITE;
/*!40000 ALTER TABLE `sd_spe_bloods` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_spe_bloods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_spe_tissues`
--

DROP TABLE IF EXISTS `sd_spe_tissues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_spe_tissues` (
  `sample_master_id` int(11) NOT NULL,
  `tissue_source` varchar(50) DEFAULT NULL,
  `tissue_nature` varchar(15) DEFAULT NULL,
  `tissue_laterality` varchar(30) DEFAULT NULL,
  `pathology_reception_datetime` datetime DEFAULT NULL,
  `pathology_reception_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `tissue_size` varchar(20) DEFAULT NULL,
  `tissue_size_unit` varchar(10) DEFAULT NULL,
  `tissue_weight` varchar(10) DEFAULT NULL,
  `tissue_weight_unit` varchar(10) DEFAULT NULL,
  `procure_tissue_identification` varchar(50) DEFAULT NULL,
  `procure_prostatectomy_type` varchar(50) DEFAULT NULL,
  `procure_prostatectomy_beginning_time` time DEFAULT NULL,
  `procure_prostatectomy_resection_time` time DEFAULT NULL,
  `procure_surgeon_name` varchar(100) DEFAULT NULL,
  `procure_sample_number` varchar(50) DEFAULT NULL,
  `procure_transfer_to_pathology_on_ice` char(1) DEFAULT '',
  `procure_transfer_to_pathology_time` time DEFAULT NULL,
  `procure_arrival_in_pathology_time` time DEFAULT NULL,
  `procure_pathologist_name` varchar(100) DEFAULT NULL,
  `procure_report_number` varchar(50) DEFAULT NULL,
  `procure_reference_to_biopsy_report` char(1) DEFAULT '',
  `procure_ink_external_color` varchar(50) DEFAULT NULL,
  `procure_prostate_slicing_beginning_time` time DEFAULT NULL,
  `procure_number_of_slides_collected` int(6) DEFAULT NULL,
  `procure_number_of_slides_collected_for_procure` int(6) DEFAULT NULL,
  `procure_prostate_slicing_ending_time` time DEFAULT NULL,
  `prostate_fixation_time` time DEFAULT NULL,
  `procure_lymph_nodes_fixation_time` time DEFAULT NULL,
  `procure_fixation_process_duration_hr` int(6) DEFAULT NULL,
  KEY `FK_sd_spe_tissues_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_tissues_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_spe_tissues`
--

LOCK TABLES `sd_spe_tissues` WRITE;
/*!40000 ALTER TABLE `sd_spe_tissues` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_spe_tissues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sd_spe_urines`
--

DROP TABLE IF EXISTS `sd_spe_urines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sd_spe_urines` (
  `sample_master_id` int(11) NOT NULL,
  `urine_aspect` varchar(30) DEFAULT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `pellet_signs` varchar(10) DEFAULT NULL,
  `pellet_volume` decimal(10,5) DEFAULT NULL,
  `pellet_volume_unit` varchar(20) DEFAULT NULL,
  `procure_other_urine_aspect` varchar(250) DEFAULT NULL,
  `procure_hematuria` char(1) DEFAULT '',
  `procure_collected_via_catheter` char(1) DEFAULT '',
  KEY `FK_sd_spe_urines_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_urines_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sd_spe_urines`
--

LOCK TABLES `sd_spe_urines` WRITE;
/*!40000 ALTER TABLE `sd_spe_urines` DISABLE KEYS */;
/*!40000 ALTER TABLE `sd_spe_urines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipments`
--

DROP TABLE IF EXISTS `shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shipment_code` varchar(255) NOT NULL DEFAULT 'No Code',
  `recipient` varchar(60) DEFAULT NULL,
  `facility` varchar(60) DEFAULT NULL,
  `delivery_street_address` varchar(255) DEFAULT NULL,
  `delivery_city` varchar(255) DEFAULT NULL,
  `delivery_province` varchar(255) DEFAULT NULL,
  `delivery_postal_code` varchar(255) DEFAULT NULL,
  `delivery_country` varchar(255) DEFAULT NULL,
  `delivery_phone_number` varchar(50) NOT NULL DEFAULT '',
  `delivery_department_or_door` varchar(50) NOT NULL DEFAULT '',
  `delivery_notes` text,
  `shipping_company` varchar(255) DEFAULT NULL,
  `shipping_account_nbr` varchar(255) DEFAULT NULL,
  `tracking` varchar(50) NOT NULL DEFAULT '',
  `datetime_shipped` datetime DEFAULT NULL,
  `datetime_shipped_accuracy` char(1) NOT NULL DEFAULT '',
  `datetime_received` datetime DEFAULT NULL,
  `datetime_received_accuracy` char(1) NOT NULL DEFAULT '',
  `shipped_by` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_shipping_conditions` varchar(50) DEFAULT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `shipment_code` (`shipment_code`),
  KEY `recipient` (`recipient`),
  KEY `facility` (`facility`),
  KEY `FK_shipments_orders` (`order_id`),
  CONSTRAINT `FK_shipments_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipments`
--

LOCK TABLES `shipments` WRITE;
/*!40000 ALTER TABLE `shipments` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source_aliquots`
--

DROP TABLE IF EXISTS `source_aliquots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `source_aliquots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL,
  `used_volume` decimal(10,5) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_source_aliquots_aliquot_masters` (`aliquot_master_id`),
  KEY `FK_source_aliquots_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_source_aliquots_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`),
  CONSTRAINT `FK_source_aliquots_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source_aliquots`
--

LOCK TABLES `source_aliquots` WRITE;
/*!40000 ALTER TABLE `source_aliquots` DISABLE KEYS */;
/*!40000 ALTER TABLE `source_aliquots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specimen_details`
--

DROP TABLE IF EXISTS `specimen_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specimen_details` (
  `sample_master_id` int(11) NOT NULL,
  `supplier_dept` varchar(40) DEFAULT NULL,
  `time_at_room_temp_mn` int(11) DEFAULT NULL,
  `reception_by` varchar(50) DEFAULT NULL,
  `reception_datetime` datetime DEFAULT NULL,
  `reception_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `procure_refrigeration_time` time DEFAULT NULL,
  KEY `FK_specimen_details_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_specimen_details_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specimen_details`
--

LOCK TABLES `specimen_details` WRITE;
/*!40000 ALTER TABLE `specimen_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `specimen_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specimen_review_controls`
--

DROP TABLE IF EXISTS `specimen_review_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specimen_review_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_control_id` int(11) NOT NULL,
  `aliquot_review_control_id` int(11) DEFAULT NULL,
  `review_type` varchar(100) NOT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `review_type` (`sample_control_id`,`review_type`),
  KEY `FK_specimen_review_controls_specimen_review_controls` (`aliquot_review_control_id`),
  CONSTRAINT `FK_specimen_review_controls_aliquot_review_controls` FOREIGN KEY (`aliquot_review_control_id`) REFERENCES `aliquot_review_controls` (`id`),
  CONSTRAINT `FK_specimen_review_controls_sample_controls` FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `specimen_review_masters`
--

DROP TABLE IF EXISTS `specimen_review_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specimen_review_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_control_id` int(11) NOT NULL DEFAULT '0',
  `collection_id` int(11) DEFAULT NULL,
  `sample_master_id` int(11) NOT NULL,
  `review_code` varchar(100) DEFAULT NULL,
  `review_date` date DEFAULT NULL,
  `review_date_accuracy` char(1) NOT NULL DEFAULT '',
  `review_status` varchar(20) DEFAULT NULL,
  `pathologist` varchar(50) DEFAULT NULL,
  `notes` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_specimen_review_masters_specimen_review_controls` (`specimen_review_control_id`),
  KEY `FK_specimen_review_masters_collections` (`collection_id`),
  KEY `FK_specimen_review_masters_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_specimen_review_masters_collections` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`),
  CONSTRAINT `FK_specimen_review_masters_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`),
  CONSTRAINT `FK_specimen_review_masters_specimen_review_controls` FOREIGN KEY (`specimen_review_control_id`) REFERENCES `specimen_review_controls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specimen_review_masters`
--

LOCK TABLES `specimen_review_masters` WRITE;
/*!40000 ALTER TABLE `specimen_review_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `specimen_review_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_boxs`
--

DROP TABLE IF EXISTS `std_boxs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_boxs` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_boxs_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_boxs_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_boxs`
--

LOCK TABLES `std_boxs` WRITE;
/*!40000 ALTER TABLE `std_boxs` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_boxs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_cupboards`
--

DROP TABLE IF EXISTS `std_cupboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_cupboards` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_cupboards_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_cupboards_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_cupboards`
--

LOCK TABLES `std_cupboards` WRITE;
/*!40000 ALTER TABLE `std_cupboards` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_cupboards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_customs`
--

DROP TABLE IF EXISTS `std_customs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_customs` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_boxs_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_customs_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_customs`
--

LOCK TABLES `std_customs` WRITE;
/*!40000 ALTER TABLE `std_customs` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_customs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_freezers`
--

DROP TABLE IF EXISTS `std_freezers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_freezers` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_freezers_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_freezers_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_freezers`
--

LOCK TABLES `std_freezers` WRITE;
/*!40000 ALTER TABLE `std_freezers` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_freezers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_fridges`
--

DROP TABLE IF EXISTS `std_fridges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_fridges` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_fridges_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_fridges_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_fridges`
--

LOCK TABLES `std_fridges` WRITE;
/*!40000 ALTER TABLE `std_fridges` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_fridges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_incubators`
--

DROP TABLE IF EXISTS `std_incubators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_incubators` (
  `storage_master_id` int(11) NOT NULL,
  `oxygen_perc` varchar(10) DEFAULT NULL,
  `carbonic_gaz_perc` varchar(10) DEFAULT NULL,
  KEY `FK_std_incubators_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_incubators_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_incubators`
--

LOCK TABLES `std_incubators` WRITE;
/*!40000 ALTER TABLE `std_incubators` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_incubators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_nitro_locates`
--

DROP TABLE IF EXISTS `std_nitro_locates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_nitro_locates` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_nitro_locates_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_nitro_locates_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_nitro_locates`
--

LOCK TABLES `std_nitro_locates` WRITE;
/*!40000 ALTER TABLE `std_nitro_locates` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_nitro_locates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_racks`
--

DROP TABLE IF EXISTS `std_racks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_racks` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_racks_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_racks_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_racks`
--

LOCK TABLES `std_racks` WRITE;
/*!40000 ALTER TABLE `std_racks` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_racks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_rooms`
--

DROP TABLE IF EXISTS `std_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_rooms` (
  `storage_master_id` int(11) NOT NULL,
  `laboratory` varchar(50) DEFAULT NULL,
  `floor` varchar(20) DEFAULT NULL,
  KEY `FK_std_rooms_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_rooms_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_rooms`
--

LOCK TABLES `std_rooms` WRITE;
/*!40000 ALTER TABLE `std_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_shelfs`
--

DROP TABLE IF EXISTS `std_shelfs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_shelfs` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_shelfs_storage_masters` (`storage_master_id`),
  CONSTRAINT `FK_std_shelfs_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_shelfs`
--

LOCK TABLES `std_shelfs` WRITE;
/*!40000 ALTER TABLE `std_shelfs` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_shelfs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `std_tma_blocks`
--

DROP TABLE IF EXISTS `std_tma_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `std_tma_blocks` (
  `storage_master_id` int(11) NOT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `creation_datetime` datetime DEFAULT NULL,
  `creation_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  KEY `FK_std_tma_blocks_storage_masters` (`storage_master_id`),
  KEY `FK_std_tma_blocks_sop_masters` (`sop_master_id`),
  CONSTRAINT `FK_std_tma_blocks_sop_masters` FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`),
  CONSTRAINT `FK_std_tma_blocks_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_tma_blocks`
--

LOCK TABLES `std_tma_blocks` WRITE;
/*!40000 ALTER TABLE `std_tma_blocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_tma_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage_controls`
--

DROP TABLE IF EXISTS `storage_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storage_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storage_type` varchar(30) NOT NULL DEFAULT '',
  `horizontal_increment` char(1) DEFAULT NULL,
  `permute_x_y` tinyint(1) DEFAULT '0' COMMENT '1: In view change x and y (ex: 4-1 means 4th row, first column)',
  `number_of_positions` int(6) DEFAULT NULL,
  `coord_x_title` varchar(30) DEFAULT NULL,
  `coord_x_type` enum('alphabetical','integer','list') DEFAULT NULL,
  `coord_x_size` int(4) DEFAULT NULL,
  `display_x_size` tinyint(3) unsigned DEFAULT NULL,
  `reverse_x_numbering` char(1) DEFAULT NULL,
  `coord_y_title` varchar(30) DEFAULT NULL,
  `coord_y_type` enum('alphabetical','integer','list') DEFAULT NULL,
  `coord_y_size` int(4) DEFAULT NULL,
  `display_y_size` tinyint(3) unsigned DEFAULT NULL,
  `reverse_y_numbering` char(1) DEFAULT NULL,
  `set_temperature` tinyint(1) NOT NULL DEFAULT '0',
  `is_tma_block` tinyint(1) NOT NULL DEFAULT '0',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `detail_tablename` varchar(255) NOT NULL,
  `databrowser_label` varchar(150) NOT NULL DEFAULT '',
  `check_conflicts` tinyint(3) unsigned DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `storage_type_en` varchar(255) DEFAULT NULL,
  `storage_type_fr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `storage_masters`
--

DROP TABLE IF EXISTS `storage_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storage_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL DEFAULT '',
  `storage_control_id` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(10) DEFAULT NULL,
  `rght` int(10) DEFAULT NULL,
  `barcode` varchar(60) DEFAULT NULL,
  `short_label` varchar(30) DEFAULT NULL,
  `selection_label` varchar(120) DEFAULT '',
  `storage_status` varchar(20) DEFAULT '',
  `parent_storage_coord_x` varchar(50) NOT NULL DEFAULT '',
  `parent_storage_coord_y` varchar(50) NOT NULL DEFAULT '',
  `temperature` decimal(5,2) DEFAULT NULL,
  `temp_unit` varchar(20) DEFAULT NULL,
  `notes` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_code` (`code`),
  KEY `code` (`code`),
  KEY `barcode` (`barcode`),
  KEY `short_label` (`short_label`),
  KEY `selection_label` (`selection_label`),
  KEY `FK_storage_masters_storage_controls` (`storage_control_id`),
  KEY `FK_storage_masters_parent` (`parent_id`),
  CONSTRAINT `FK_storage_masters_parent` FOREIGN KEY (`parent_id`) REFERENCES `storage_masters` (`id`),
  CONSTRAINT `FK_storage_masters_storage_controls` FOREIGN KEY (`storage_control_id`) REFERENCES `storage_controls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage_masters`
--

LOCK TABLES `storage_masters` WRITE;
/*!40000 ALTER TABLE `storage_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `storage_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage_masters_revs`
--

DROP TABLE IF EXISTS `storage_masters_revs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storage_masters_revs` (
  `id` int(11) NOT NULL,
  `code` varchar(30) NOT NULL DEFAULT '',
  `storage_control_id` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(10) DEFAULT NULL,
  `rght` int(10) DEFAULT NULL,
  `barcode` varchar(60) DEFAULT NULL,
  `short_label` varchar(30) DEFAULT NULL,
  `selection_label` varchar(120) DEFAULT '',
  `storage_status` varchar(20) DEFAULT '',
  `parent_storage_coord_x` varchar(50) NOT NULL DEFAULT '',
  `parent_storage_coord_y` varchar(50) NOT NULL DEFAULT '',
  `temperature` decimal(5,2) DEFAULT NULL,
  `temp_unit` varchar(20) DEFAULT NULL,
  `notes` text,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage_masters_revs`
--

LOCK TABLES `storage_masters_revs` WRITE;
/*!40000 ALTER TABLE `storage_masters_revs` DISABLE KEYS */;
/*!40000 ALTER TABLE `storage_masters_revs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `structure_permissible_values`
--

DROP TABLE IF EXISTS `structure_permissible_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structure_permissible_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL,
  `language_alias` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`,`language_alias`)
) ENGINE=InnoDB AUTO_INCREMENT=1750 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `structure_permissible_values_custom_controls`
--

DROP TABLE IF EXISTS `structure_permissible_values_custom_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structure_permissible_values_custom_controls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `values_max_length` int(4) DEFAULT '5',
  `category` varchar(50) NOT NULL DEFAULT 'undefined',
  `values_used_as_input_counter` int(7) DEFAULT '0',
  `values_counter` int(7) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `structure_permissible_values_customs`
--

DROP TABLE IF EXISTS `structure_permissible_values_customs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structure_permissible_values_customs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `control_id` int(10) unsigned NOT NULL,
  `value` varchar(250) NOT NULL,
  `en` varchar(255) DEFAULT '',
  `fr` varchar(255) DEFAULT '',
  `display_order` tinyint(3) unsigned DEFAULT '0',
  `use_as_input` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `control_id` (`control_id`,`value`),
  CONSTRAINT `structure_permissible_values_customs_ibfk_1` FOREIGN KEY (`control_id`) REFERENCES `structure_permissible_values_custom_controls` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=464 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `structure_value_domains`
--

DROP TABLE IF EXISTS `structure_value_domains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structure_value_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_name` varchar(255) NOT NULL,
  `override` set('extend','locked','open') NOT NULL DEFAULT 'open',
  `category` varchar(255) NOT NULL DEFAULT '',
  `source` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_name` (`domain_name`)
) ENGINE=InnoDB AUTO_INCREMENT=479 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `structure_value_domains_permissible_values`
--

DROP TABLE IF EXISTS `structure_value_domains_permissible_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structure_value_domains_permissible_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structure_value_domain_id` int(11) DEFAULT NULL,
  `structure_permissible_value_id` int(11) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `use_as_input` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `structure_permissible_value_id` (`structure_permissible_value_id`),
  KEY `structure_value_domain_id` (`structure_value_domain_id`),
  CONSTRAINT `structure_value_domains_permissible_values_ibfk_1` FOREIGN KEY (`structure_permissible_value_id`) REFERENCES `structure_permissible_values` (`id`),
  CONSTRAINT `structure_value_domains_permissible_values_ibfk_2` FOREIGN KEY (`structure_value_domain_id`) REFERENCES `structure_value_domains` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2270 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `study_summaries`
--

DROP TABLE IF EXISTS `study_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `study_summaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disease_site` varchar(255) NOT NULL DEFAULT '',
  `study_type` varchar(50) DEFAULT NULL,
  `study_science` varchar(50) DEFAULT NULL,
  `study_use` varchar(50) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `start_date_accuracy` char(1) NOT NULL DEFAULT '',
  `end_date` date DEFAULT NULL,
  `end_date_accuracy` char(1) NOT NULL DEFAULT '',
  `summary` text,
  `abstract` text,
  `hypothesis` text,
  `approach` text,
  `analysis` text,
  `significance` text,
  `additional_clinical` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `path_to_file` varchar(255) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_principal_investigator` varchar(255) DEFAULT NULL,
  `procure_organization` varchar(255) DEFAULT NULL,
  `procure_address_street` varchar(255) DEFAULT NULL,
  `procure_address_city` varchar(255) DEFAULT NULL,
  `procure_address_province` varchar(255) DEFAULT NULL,
  `procure_address_country` varchar(255) DEFAULT NULL,
  `procure_address_postal` varchar(255) DEFAULT NULL,
  `procure_phone_number` varchar(255) DEFAULT NULL,
  `procure_fax_number` varchar(255) DEFAULT NULL,
  `procure_email` varchar(255) DEFAULT NULL,
  `procure_award_committee_approval` char(1) DEFAULT '',
  `procure_reference_ethics_committee_approval` char(1) DEFAULT '',
  `procure_site_ethics_committee_convenience_ps1` char(1) DEFAULT '',
  `procure_site_ethics_committee_convenience_ps4` char(1) DEFAULT '',
  `procure_site_ethics_committee_convenience_ps2` char(1) DEFAULT '',
  `procure_site_ethics_committee_convenience_ps3` char(1) DEFAULT '',
  `procure_created_by_bank` char(1) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_summaries`
--

LOCK TABLES `study_summaries` WRITE;
/*!40000 ALTER TABLE `study_summaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_summaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tma_slides`
--

DROP TABLE IF EXISTS `tma_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tma_slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tma_block_storage_master_id` int(11) DEFAULT NULL,
  `barcode` varchar(30) NOT NULL DEFAULT '',
  `product_code` varchar(20) DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL,
  `picture_path` varchar(200) DEFAULT NULL,
  `storage_datetime` datetime DEFAULT NULL,
  `storage_datetime_accuracy` char(1) NOT NULL DEFAULT '',
  `storage_master_id` int(11) DEFAULT NULL,
  `storage_coord_x` varchar(11) NOT NULL DEFAULT '',
  `storage_coord_y` varchar(11) NOT NULL DEFAULT '',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `study_summary_id` int(11) DEFAULT NULL,
  `in_stock` varchar(30) DEFAULT NULL,
  `in_stock_detail` varchar(30) DEFAULT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  `procure_stain` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_barcode` (`barcode`),
  KEY `barcode` (`barcode`),
  KEY `product_code` (`product_code`),
  KEY `FK_tma_slides_storage_masters` (`storage_master_id`),
  KEY `FK_tma_slides_sop_masters` (`sop_master_id`),
  KEY `FK_tma_slides_tma_blocks` (`tma_block_storage_master_id`),
  KEY `FK_tma_slides_study_summaries` (`study_summary_id`),
  CONSTRAINT `FK_tma_slides_sop_masters` FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`),
  CONSTRAINT `FK_tma_slides_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`),
  CONSTRAINT `FK_tma_slides_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`),
  CONSTRAINT `FK_tma_slides_tma_blocks` FOREIGN KEY (`tma_block_storage_master_id`) REFERENCES `storage_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tma_slides`
--

LOCK TABLES `tma_slides` WRITE;
/*!40000 ALTER TABLE `tma_slides` DISABLE KEYS */;
/*!40000 ALTER TABLE `tma_slides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treatment_controls`
--

DROP TABLE IF EXISTS `treatment_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treatment_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tx_method` varchar(50) DEFAULT NULL,
  `disease_site` varchar(50) DEFAULT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `detail_tablename` varchar(255) NOT NULL,
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `applied_protocol_control_id` int(11) DEFAULT NULL,
  `extended_data_import_process` varchar(50) DEFAULT NULL,
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  `flag_use_for_ccl` tinyint(1) NOT NULL DEFAULT '0',
  `treatment_extend_control_id` int(11) DEFAULT NULL,
  `use_addgrid` tinyint(1) NOT NULL DEFAULT '0',
  `use_detail_form_for_index` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_tx_controls_protocol_controls` (`applied_protocol_control_id`),
  KEY `treatment_controls_treatment_extend_controls` (`treatment_extend_control_id`),
  CONSTRAINT `FK_tx_controls_protocol_controls` FOREIGN KEY (`applied_protocol_control_id`) REFERENCES `protocol_controls` (`id`),
  CONSTRAINT `treatment_controls_treatment_extend_controls` FOREIGN KEY (`treatment_extend_control_id`) REFERENCES `treatment_extend_controls` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `treatment_extend_controls`
--

DROP TABLE IF EXISTS `treatment_extend_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treatment_extend_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `detail_tablename` varchar(255) NOT NULL,
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `type` varchar(255) NOT NULL DEFAULT '',
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `treatment_masters`
--

DROP TABLE IF EXISTS `treatment_masters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treatment_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `treatment_control_id` int(11) NOT NULL DEFAULT '0',
  `tx_intent` varchar(50) DEFAULT NULL,
  `target_site_icdo` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `start_date_accuracy` char(1) NOT NULL DEFAULT '',
  `finish_date` date DEFAULT NULL,
  `finish_date_accuracy` char(1) NOT NULL DEFAULT '',
  `information_source` varchar(50) DEFAULT NULL,
  `facility` varchar(50) DEFAULT NULL,
  `notes` text,
  `protocol_master_id` int(11) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `procure_deprecated_field_procure_form_identification` varchar(50) DEFAULT NULL,
  `procure_created_by_bank` char(1) DEFAULT '',
  `procure_drug_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `participant_id` (`participant_id`),
  KEY `diagnosis_id` (`diagnosis_master_id`),
  KEY `treatment_control_id` (`treatment_control_id`),
  KEY `FK_tx_masters_protocol_masters` (`protocol_master_id`),
  KEY `FK_procure_tx_drugs` (`procure_drug_id`),
  CONSTRAINT `FK_procure_tx_drugs` FOREIGN KEY (`procure_drug_id`) REFERENCES `drugs` (`id`),
  CONSTRAINT `FK_tx_masters_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`),
  CONSTRAINT `FK_tx_masters_participant` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`),
  CONSTRAINT `FK_tx_masters_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`),
  CONSTRAINT `treatment_masters_ibfk_1` FOREIGN KEY (`treatment_control_id`) REFERENCES `treatment_controls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatment_masters`
--

LOCK TABLES `treatment_masters` WRITE;
/*!40000 ALTER TABLE `treatment_masters` DISABLE KEYS */;
/*!40000 ALTER TABLE `treatment_masters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_number` varchar(255) NOT NULL,
  `date_installed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `trunk_build_number` varchar(45) NOT NULL,
  `permissions_regenerated` tinyint(1) DEFAULT '0',
  `branch_build_number` varchar(45) DEFAULT '',
  `site_branch_build_number` varchar(45) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `atim_procure_dump_information`
--

DROP TABLE IF EXISTS `atim_procure_dump_information`;
CREATE TABLE atim_procure_dump_information (created datetime NOT NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
