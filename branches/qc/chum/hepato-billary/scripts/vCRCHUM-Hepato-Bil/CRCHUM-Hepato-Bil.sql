-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM fro CRCHMU Hepato-Bil Bank
--
-- -------------------------------------------------------------------

-- General

DELETE FROM `i18n` WHERE `id` IN ('core_appname', 'CTRApp');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('core_appname', 'global', 'ATiM - CRCHUM Hepatobiliary', 'ATiM - CRCHUM H&eacute;pato-biliaire'),
('CTRApp', 'global', 'ATiM - CRCHUM Hepatobiliary', 'ATiM - CRCHUM H&eacute;pato-biliaire');

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- CLINICAL ANNOTATION
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- ******** PROFILE ********

-- ... IDENTIFIER ...

DELETE FROM `misc_identifier_controls`;
INSERT INTO `misc_identifier_controls` 
(`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `display_order`, `autoincrement_name`, `misc_identifier_format`) 
VALUES
(null, 'health_insurance_card', 'RAMQ', 'active', 0, '', ''),
(null, 'saint_luc_hospital_nbr', 'ID HSL', 'active', 1, '', ''),
(null, 'hepato_bil_bank_participant_id', 'HB-PartID', 'active', 3, 'hepato_bil_bank_participant_id', 'HB-P%%key_increment%%');

DELETE FROM `i18n` WHERE `id` IN ('health_insurance_card', 'saint_luc_hospital_nbr', 'hepato_bil_bank_participant_id');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('health_insurance_card', 'global', 'Health Insurance Card', 'Carte d''assurance maladie'),
('saint_luc_hospital_nbr', 'global', 'St Luc Hospital Number', 'No H&ocirc;pital St Luc'),
('hepato_bil_bank_participant_id', 'global', 'H.B. Bank Participant Id', 'Num&eacute;ro participant banque H.B.');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('hepato_bil_bank_participant_id', 1);

-- ******** ANNOTATION ******** 

DELETE FROM `event_controls` ;

-- ... SCREENING ...

UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_27' ;

-- ... STUDY ...

UPDATE `menus` SET `active` =  'no' WHERE `menus`.`id` = 'clin_CAN_33' ;

-- ... CLINIC: presentation ...

DELETE FROM `event_controls` WHERE `id` = '1';
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(1, 'hepatobiliary', 'clinical', 'presentation', 'active', 'ed_hepatobiliary_clinical_presentation', 'ed_hepatobiliary_clinical_presentation', 0);

DROP TABLE IF EXISTS `ed_hepatobiliary_clinical_presentation`;
CREATE TABLE `ed_hepatobiliary_clinical_presentation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `weight` decimal(7,3) DEFAULT NULL,
  `height` decimal(7,3) DEFAULT NULL,
  `bmi` decimal(10,3) DEFAULT NULL,
  `referral_hospital` varchar(50) DEFAULT NULL, 
  `referral_physisian` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality` varchar(50) DEFAULT NULL,
  `referral_physisian_2` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_2` varchar(50) DEFAULT NULL,
  `referral_physisian_3` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_3` varchar(50) DEFAULT NULL,
  `hbp_surgeon` varchar(50) DEFAULT NULL,
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ed_hepatobiliary_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `ed_hepatobiliary_clinical_presentation_revs`;
CREATE TABLE `ed_hepatobiliary_clinical_presentation_revs` (
  `id` int(11) NOT NULL,
  `weight` decimal(7,3) DEFAULT NULL,
  `height` decimal(7,3) DEFAULT NULL,
  `bmi` decimal(10,3) DEFAULT NULL,
  `referral_hospital` varchar(50) DEFAULT NULL, 
  `referral_physisian` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality` varchar(50) DEFAULT NULL,
  `referral_physisian_2` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_2` varchar(50) DEFAULT NULL,
  `referral_physisian_3` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_3` varchar(50) DEFAULT NULL,
  `hbp_surgeon` varchar(50) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DELETE FROM `structure_validations` WHERE `old_id` LIKE ('QC_CRCHUM_HB_%');	
DELETE FROM `structure_formats` WHERE `old_id` LIKE ('QC_CRCHUM_HB_%');	
DELETE FROM `structures` WHERE `old_id` LIKE ('QC_CRCHUM_HB%');
DELETE FROM `structure_fields` WHERE `old_id` LIKE ('QC_CRCHUM_HB_%');	

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CRCHUM_HB_000001', 'ed_hepatobiliary_clinical_presentation', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CRCHUM_HB_000001', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'bmi', 'bmi', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000002', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'referral_hospital', 'referral hospital', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000003', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'referral_physisian', 'referral physisian', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000004', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000005', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'referral_physisian_2', 'referral physisian 2', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000006', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_2', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000007', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'referral_physisian_3', 'referral physisian 3', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000008', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_3', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_000009', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_clinical_presentation', 'hbp_surgeon', 'hbp surgeron', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- first_consultation_date
(null, 'QC_CRCHUM_HB_000001_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'first consultation date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC_CRCHUM_HB_000001_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC_CRCHUM_HB_000001_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- hbp_surgeon
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000009', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000009'), 'QC_CRCHUM_HB_000009', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- weight
(null, 'QC_CRCHUM_HB_000001_CAN-999-999-000-999-235', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-235'), 'CAN-999-999-000-999-235', 0, 10, '', '1', 'weight (kg)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- height
(null, 'QC_CRCHUM_HB_000001_CAN-999-999-000-999-236', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-236'), 'CAN-999-999-000-999-236', 0, 11, '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- bmi
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000001', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC_CRCHUM_HB_000001_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- referral_hospital
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000002', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000002'), 'QC_CRCHUM_HB_000002', 1, 30, 'referral data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000003', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000004', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000004'), 'QC_CRCHUM_HB_000004', 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 2
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000005', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000005'), 'QC_CRCHUM_HB_000005', 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 2
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000006', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000006'), 'QC_CRCHUM_HB_000006', 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 3 
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000007', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000007'), 'QC_CRCHUM_HB_000007', 1, 35, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 3
(null, 'QC_CRCHUM_HB_000001_QC_CRCHUM_HB_000008', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000001'), 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_000008'), 'QC_CRCHUM_HB_000008', 1, 36, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
  
INSERT INTO `structure_validations` (`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC_CRCHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-235'), 'CAN-999-999-000-999-235', 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'weight should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'QC_CRCHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-236'), 'CAN-999-999-000-999-236', 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'height should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('first consultation date', 'referral data', 'referral hospital', 
'referral physisian', 'referral physisian 2', 'referral physisian 3', 'referral physisian speciality', 
'weight (kg)', 'height (cm)', 'weight should be a positif decimal', 'height should be a positif decimal', 
'hepatobiliary');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('first consultation date', 'global', 'First Consultation Date', 'Date premi&egrave;re consultation'),
('referral data', 'global', 'Referral', 'R&eacute;f&eacute;rent'),
('referral hospital', 'global', 'Referral Hospital', 'H&ocirc;pital r&eacute;f&eacute;rent'),
('referral physisian', 'global', 'Referral Physisian', 'Medecin r&eacute;f&eacute;rent'),
('referral physisian 2', 'global', '2nd Referral Physisian', '2nd Medecin r&eacute;f&eacute;rent'),
('referral physisian 3', 'global', '3rd Referral Physisian', '3eme Medecin r&eacute;f&eacute;rent'),
('referral physisian speciality', 'global', 'Speciality', 'Sp&eacute;cialit&eacute;'),

('weight (kg)', 'global', 'Weight (kg)', 'Poids (kg)'),
('height (cm)', 'global', 'Height (cm)', 'Taille (cm)'),

('weight should be a positif decimal', 'global', 'Weight should be a positive decimal!', 'Le poids doit &ecirc;tre un d&eacute;cimal positif!'),
('height should be a positif decimal', 'global', 'Height should be a positive decimal!', 'Le taille doit &ecirc;tre un d&eacute;cimal positif!'),
('hepatobiliary', 'global', 'Hepatobiliary', 'H&eacute;pato-biliaire');

DELETE FROM `i18n` WHERE `id` = 'presentation';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`)
 VALUES
('presentation', 'global', 'Presentation', 'Pr&eacute;sentation');

-- ... CLINIC: lifestyle ...

DELETE FROM `event_controls` WHERE `id` = '2';
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(2, 'hepatobiliary', 'lifestyle', 'summary', 'active', 'ed_hepatobiliary_lifestyle', 'ed_hepatobiliary_lifestyle', 0);

DROP TABLE IF EXISTS `ed_hepatobiliary_lifestyle`;
CREATE TABLE `ed_hepatobiliary_lifestyle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active_tobacco` varchar(10) DEFAULT NULL, 
  `active_alcohol` varchar(10) DEFAULT NULL, 
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ed_hepatobiliary_lifestyle`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
DROP TABLE IF EXISTS `ed_hepatobiliary_lifestyle_revs`;
CREATE TABLE `ed_hepatobiliary_lifestyle_revs` (
  `id` int(11) NOT NULL, 
  `active_tobacco` varchar(10) DEFAULT NULL, 
  `active_alcohol` varchar(10) DEFAULT NULL, 
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CRCHUM_HB_000002', 'ed_hepatobiliary_lifestyle', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_value_domains` WHERE `domain_name` = 'QC_CRCHUM_HB_yes_no_unknown';	
INSERT INTO `structure_value_domains`  (`id` ,`domain_name` ,`override` ,`category`)
VALUES (NULL , 'QC_CRCHUM_HB_yes_no_unknown', 'open', '');
	
SET @last_domains_id = LAST_INSERT_ID();

DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` IN (SELECT `id` FROM `structure_value_domains` WHERE `id` = 'QC_CRCHUM_HB_yes_no_unknown');	
INSERT INTO structure_value_domains_permissible_values (`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`)
VALUES 
(null, @last_domains_id, (SELECT id FROM `structure_permissible_values` WHERE `value` LIKE 'yes' AND `language_alias` LIKE 'yes' LIMIT 0, 1), 1, 'yes', null),
(null, @last_domains_id, (SELECT id FROM `structure_permissible_values` WHERE `value` LIKE 'no' AND `language_alias` LIKE 'no' LIMIT 0, 1), 1, 'yes', null),
(null, @last_domains_id, (SELECT id FROM `structure_permissible_values` WHERE `value` LIKE 'unknown' AND `language_alias` LIKE 'unknown' LIMIT 0, 1), 1, 'yes', null);

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CRCHUM_HB_0000010', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_lifestyle', 'active_tobacco', 'active_tobacco', '', 'select', '', '', @last_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000011', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_lifestyle', 'active_alcohol', 'active_alcohol', '', 'select', '', '', @last_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC_CRCHUM_HB_000002_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000002'), 'QC_CRCHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC_CRCHUM_HB_000002_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000002'), 'QC_CRCHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC_CRCHUM_HB_000002_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000002'), 'QC_CRCHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- active_tobacco
(null, 'QC_CRCHUM_HB_000002_QC_CRCHUM_HB_0000010', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000002'), 'QC_CRCHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000010'), 'QC_CRCHUM_HB_0000010', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- active_alcohol
(null, 'QC_CRCHUM_HB_000002_QC_CRCHUM_HB_0000011', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000002'), 'QC_CRCHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000011'), 'QC_CRCHUM_HB_0000011', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_summary
(null, 'QC_CRCHUM_HB_000002_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000002'), 'QC_CRCHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('active_tobacco', 'active_alcohol', 'last update date', 'this type of event has already been created for your participant');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('active_tobacco', 'global', 'Active Tobacco', 'Tabagisme actif'),
('active_alcohol', 'global', 'Active Alcohol', 'Alcolisme chronique'),
('last update date', 'global', 'Last Update date', 'Date de mise &agrave; jour'),
('this type of event has already been created for your participant', '', 'This type of annotation has already been created for your participant!', 'Ce type d''annotation a d&eacute;j&agrave; eacyte;t&eacute; cr&eacute;&eacute;e pour votre participant!');

-- ... CLINIC: medical_past_history ...

DELETE FROM event_masters WHERE event_control_id in ('3');

-- => medical_past_history.summary

DELETE FROM `event_controls` WHERE `id` = '3';
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(3, 'hepatobiliary', 'clinical', 'medical_past_history', 'active', 'ed_hepatobiliary_medical_past_history', 'ed_hepatobiliary_medical_past_history', 0);

DROP TABLE IF EXISTS `ed_hepatobiliary_medical_past_history`;
CREATE TABLE `ed_hepatobiliary_medical_past_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asa_value` varchar(10) DEFAULT NULL, 
  `heart_disease` varchar(10) DEFAULT NULL, 
  `respiratory_disease` varchar(10) DEFAULT NULL, 
  `vascular_disease` varchar(10) DEFAULT NULL, 
  `neural_vascular_disease` varchar(10) DEFAULT NULL, 
  `endocrine_disease` varchar(10) DEFAULT NULL, 
  `urinary_disease` varchar(10) DEFAULT NULL, 
  `gastro_intestinal_disease` varchar(10) DEFAULT NULL, 
  `gynecologic_disease` varchar(10) DEFAULT NULL, 
  `other_disease` varchar(10) DEFAULT NULL, 
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ed_hepatobiliary_medical_past_history`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `ed_hepatobiliary_medical_past_history_revs`;
CREATE TABLE `ed_hepatobiliary_medical_past_history_revs` (
  `id` int(11) NOT NULL, 
  `asa_value` varchar(10) DEFAULT NULL, 
  `heart_disease` varchar(10) DEFAULT NULL, 
  `respiratory_disease` varchar(10) DEFAULT NULL, 
  `vascular_disease` varchar(10) DEFAULT NULL, 
  `neural_vascular_disease` varchar(10) DEFAULT NULL, 
  `endocrine_disease` varchar(10) DEFAULT NULL, 
  `urinary_disease` varchar(10) DEFAULT NULL, 
  `gastro_intestinal_disease` varchar(10) DEFAULT NULL, 
  `gynecologic_disease` varchar(10) DEFAULT NULL, 
  `other_disease` varchar(10) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CRCHUM_HB_000003', 'ed_hepatobiliary_medical_past_history', '', '', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CRCHUM_HB_0000012', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'asa_value', 'asa', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000013', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'heart_disease', 'heart disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000014', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'respiratory_disease', 'respiratory disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000015', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'vascular_disease', 'vascular disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000016', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'neural_vascular_disease', 'neural vascular disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000017', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'endocrine_disease', 'endocrine disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000018', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'urinary_disease', 'urinary disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000019', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'gastro_intestinal_disease', 'gastro-intestinal disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000020', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'gynecologic_disease', 'gynecologic disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000021', 'Clinicalannotation', 'EventDetail', 'ed_hepatobiliary_medical_past_history', 'other_disease', 'other disease', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'QC_CRCHUM_HB_yes_no_unknown'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC_CRCHUM_HB_000003_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC_CRCHUM_HB_000003_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC_CRCHUM_HB_000003_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000012', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000012'), 'QC_CRCHUM_HB_0000012', 1, 40, 'medical past history summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000013', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000013'), 'QC_CRCHUM_HB_0000013', 1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000014', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000014'), 'QC_CRCHUM_HB_0000014', 1, 42, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000015', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000015'), 'QC_CRCHUM_HB_0000015', 1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000016', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000016'), 'QC_CRCHUM_HB_0000016', 1, 44, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000017', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000017'), 'QC_CRCHUM_HB_0000017', 1, 45, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000018', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000018'), 'QC_CRCHUM_HB_0000018', 1, 46, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000019', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000019'), 'QC_CRCHUM_HB_0000019', 1, 47, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000020', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000020'), 'QC_CRCHUM_HB_0000020', 1, 48, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CRCHUM_HB_000003_QC_CRCHUM_HB_0000021', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000021'), 'QC_CRCHUM_HB_0000021', 1, 49, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC_CRCHUM_HB_000003_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000003'), 'QC_CRCHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- => medical_past_history.details

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CRCHUM_HB_000004', 'ee_hepatobiliary_medical_past_history', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DROP TABLE IF EXISTS `ee_hepatobiliary_medical_past_history`;
CREATE TABLE `ee_hepatobiliary_medical_past_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `medical_history_date` date DEFAULT NULL,
  `disease_type` varchar(50) NOT NULL, 
  `disease_precision` varchar(250) DEFAULT NULL, 
  `summary` text,
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ee_hepatobiliary_medical_past_history`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `ee_hepatobiliary_medical_past_history_revs`;
CREATE TABLE `ee_hepatobiliary_medical_past_history_revs` (
  `id` int(11) NOT NULL, 
  `medical_history_date` date DEFAULT NULL,
  `disease_type` varchar(50) NOT NULL, 
  `disease_precision` varchar(250) DEFAULT NULL,  
  `summary` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CRCHUM_HB_0000022', 'Clinicalannotation', 'EventExtend', 'ee_hepatobiliary_medical_past_history', 'medical_history_date', 'diagnostic date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000023', 'Clinicalannotation', 'EventExtend', 'ee_hepatobiliary_medical_past_history', 'disease_type', 'medical history type', '', 'select', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000024', 'Clinicalannotation', 'EventExtend', 'ee_hepatobiliary_medical_past_history', 'disease_precision', 'medical history precision', '', 'select', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CRCHUM_HB_0000025', 'Clinicalannotation', 'EventExtend', 'ee_hepatobiliary_medical_past_history', 'summary', 'summary', '', 'textarea', 'cols=40,rows=6', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC_CRCHUM_HB_000004_QC_CRCHUM_HB_0000022', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000004'), 'QC_CRCHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000022'), 'QC_CRCHUM_HB_0000022', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- type
(null, 'QC_CRCHUM_HB_000004_QC_CRCHUM_HB_0000023', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000004'), 'QC_CRCHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000023'), 'QC_CRCHUM_HB_0000023', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '1', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- precision
(null, 'QC_CRCHUM_HB_000004_QC_CRCHUM_HB_0000024', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000004'), 'QC_CRCHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000024'), 'QC_CRCHUM_HB_0000024', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- summary
(null, 'QC_CRCHUM_HB_000004_QC_CRCHUM_HB_0000025', (SELECT id FROM structures WHERE old_id = 'QC_CRCHUM_HB_000004'), 'QC_CRCHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'QC_CRCHUM_HB_0000025'), 'QC_CRCHUM_HB_0000025', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id`IN ('medical past history summary', 'medical past history details', 
'add detail', 'edit summary', 'medical_past_history');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('medical past history summary', '', 'Summary', 'R&eacute;sum&eacute;'),
('medical past history details', '', 'Details', 'D&eacute;tails'),
('add detail', '', 'Add Detail', 'Ajouter d&eacute;tail'),
('edit summary', '', 'Edit Summary', 'Modifier r&eacute;sum&eacute;'),
('medical_past_history', '', 'Medical Past History', 'Historique clinique');

DROP TABLE IF EXISTS `ee_hepatobiliary_medical_past_history_data_ctrls`;
CREATE TABLE `ee_hepatobiliary_medical_past_history_data_ctrls` (
  `id` int(11) NOT NULL AUTO_INCREMENT, 
  `disease_type` varchar(50) NOT NULL, 
  `disease_precision` varchar(250) NOT NULL,
  `display_order` int(2)default '0',  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- TODO to delete (for example)
INSERT INTO `ee_hepatobiliary_medical_past_history_data_ctrls` 
(`id`, `disease_type`, `disease_precision`, `display_order`)
VALUES 
(null, 'asa', 'drug ex 1', '1'),
(null, 'asa', 'drug ex 2', '2'),
(null, 'asa', 'drug ex 3', '3'),
(null, 'asa', 'drug ex 4', '4'),
(null, 'asa', 'other', '5'),

(null, 'heart disease', 'high blood pressure', '1'),
(null, 'heart disease', 'tachycardia', '2'),
(null, 'heart disease', 'heart attack', '3'),
(null, 'heart disease', 'other', '4'),

(null, 'vascular disease', 'to define', '1'),
(null, 'respiratory disease', 'to define', '1'),
(null, 'neural vascular disease', 'to define', '1'),
(null, 'endocrine disease', 'to define', '1'),
(null, 'urinary disease', 'to define', '1'),
(null, 'gastro-intestinal disease', 'to define', '1'),
(null, 'gynecologic disease', 'to define', '1'),
(null, 'other disease', 'to define', '1');

-- TODO to delete (for example)
DELETE FROM `i18n` WHERE `id` LIKE 'drug ex %';
DELETE FROM `i18n` WHERE `id`IN ('to define','high blood pressure', 'tachycardia', 'heart attack',
'asa', 'heart disease', 'vascular disease', 'respiratory disease', 'neural vascular disease', 
'endocrine disease', 'urinary disease', 'gastro-intestinal disease', 'gynecologic disease', 
'other disease', 'medical history type', 'medical history precision', 'diagnostic date', 
'detail exists for the deleted medical past history');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('drug ex 1', '', 'Drug 1', 'Mdt 1'),
('drug ex 2', '', 'Drug 2', 'Mdt 2'),
('drug ex 3', '', 'Drug 3', 'Mdt 3'),
('drug ex 4', '', 'Drug 4', 'Mdt 4'),
('drug ex 5', '', 'Drug 5', 'Mdt 5'),

( 'to define', '', 'To Define', 'A definir'),
('high blood pressure', '', 'High blood pressure', 'HTA'),
('tachycardia', '', 'Tachycardia', 'Tachycardie'),
('heart attack', '', 'Heart attack', 'Crise cardiaque'),

('asa', '', 'Asa', 'Asa'),
('heart disease', '', 'Heart Disease', 'Maladie du coeur'),
('vascular disease', '', 'Vascular Disease', 'Maladie vasculaire'),
('respiratory disease', '', 'Respiratory Disease', 'Maladie respiratoire'),
('neural vascular disease', '', 'Neural Vascular Disease', 'Maladie vasculaire cerebrale'),
('endocrine disease', '', 'Endocrine Disease', 'Maladie endocrine'),
('urinary disease', '', 'Urinary Disease', 'Maladie urinaire'),
('gastro-intestinal disease', '', 'Gastro-Intestinal Disease', 'Maladie gastro-intestinal'),
('gynecologic disease', '', 'Gynecologic Disease', 'Maladie gynecologique'),
('other disease', '', 'Other Disease', 'Autre maladie'),

('medical history type', '', 'Disease Type', 'Type de pathologie'),
('medical history precision', '', 'Precision', 'Pr&eacute;cision'),
('diagnostic date', '', 'Diagnostic Date', 'Date de diagnostic'),
('detail exists for the deleted medical past history', '', 
'Your data cannot be deleted! <br>Detail exist for the deleted medical past history.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des d&eacute;tails existent pour votre historique clinique.');


