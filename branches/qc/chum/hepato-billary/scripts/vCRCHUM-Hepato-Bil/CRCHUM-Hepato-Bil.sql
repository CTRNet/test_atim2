-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM fro CRCHMU Hepato-Bil Bank
--
-- -------------------------------------------------------------------

-- General

DELETE FROM `i18n` WHERE `id` IN ('core_appname', 'CTRApp');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('core_appname', 'global', 'ATiM.v2 - CHUM Hep-bil', 'ATiM.v2 - CHUM Hep-bil'),
('CTRApp', 'global', 'ATiM.v2 - CHUM Hep-bil', 'ATiM.v2 - CHUM Hep-bil');

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

DELETE FROM `i18n` WHERE `id` IN ('health_insurance_card', 'saint_luc_hospital_nbr', 'hepato_bil_bank_participant_id',
'this identifier has already been created for your participant');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('health_insurance_card', 'global', 'Health Insurance Card', 'Carte d''assurance maladie'),
('saint_luc_hospital_nbr', 'global', 'St Luc Hospital Number', 'No H&ocirc;pital St Luc'),
('hepato_bil_bank_participant_id', 'global', 'H.B. Bank Participant Id', 'Num&eacute;ro participant banque H.B.'),
('this identifier has already been created for your participant', '', 'This identifier has already been created for your participant!', 'Cet identification a d&eacute;j&agrave; &eacute;t&eacute; cr&eacute;&eacute;e pour ce participant!');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('hepato_bil_bank_participant_id', 1);

-- ******** ANNOTATION ******** 

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_clinical_presentation`;
DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_lifestyle`;
DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_medical_past_history`;
DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_med_hist_record_summary`;

DROP TABLE IF EXISTS `qc_hb_hepatobiliary_medical_past_history_ctrls`;

DELETE FROM `event_masters`;
DELETE FROM `event_controls` ;

-- ... SCREENING ...

UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_27' ;

-- ... STUDY ...

UPDATE `menus` SET `active` =  'no' WHERE `menus`.`id` = 'clin_CAN_33' ;

-- ... CLINIC: presentation ...

DELETE FROM `menus` WHERE `id` IN ('clin_qc_hb_31', 'clin_qc_hb_32', 'clin_qc_hb_33');
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('clin_qc_hb_31', 'clin_CAN_31', 0, 1, 'annotation clinical details', 'annotation clinical details', '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%//', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_qc_hb_33', 'clin_CAN_31', 0, 2, 'annotation clinical reports', 'annotation clinical reports', '/clinicalannotation/event_masters/imageryReport/%%Participant.id%%/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'clinical', 'presentation', 'active', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'qc_hb_ed_hepatobiliary_clinical_presentation', 0);

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_clinical_presentation`;
CREATE TABLE `qc_hb_ed_hepatobiliary_clinical_presentation` (
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

ALTER TABLE `qc_hb_ed_hepatobiliary_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_clinical_presentation_revs`;
CREATE TABLE `qc_hb_ed_hepatobiliary_clinical_presentation_revs` (
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

DELETE FROM `structure_validations` WHERE `old_id` LIKE ('QC-HB-%');	
DELETE FROM `structure_formats` WHERE `old_id` LIKE ('QC-HB-%');	
DELETE FROM `structures` WHERE `old_id` LIKE ('QC-HB-%');
DELETE FROM `structure_fields` WHERE `old_id` LIKE ('QC-HB-%');	

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-HB-000001', 'qc_hb_ed_hepatobiliary_clinical_presentation', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-HB-000001', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'bmi', 'bmi', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000002', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_hospital', 'referral hospital', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000003', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian', 'referral physisian', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000004', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000005', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_2', 'referral physisian 2', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000006', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_2', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000007', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_3', 'referral physisian 3', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000008', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_3', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-000009', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'hbp_surgeon', 'hbp surgeron', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- first_consultation_date
(null, 'QC-HB-000001_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'first consultation date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC-HB-000001_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC-HB-000001_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- hbp_surgeon
(null, 'QC-HB-000001_QC-HB-000009', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000009'), 'QC-HB-000009', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- weight
(null, 'QC-HB-000001_CAN-999-999-000-999-235', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-235'), 'CAN-999-999-000-999-235', 0, 10, '', '1', 'weight (kg)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- height
(null, 'QC-HB-000001_CAN-999-999-000-999-236', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-236'), 'CAN-999-999-000-999-236', 0, 11, '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- bmi
(null, 'QC-HB-000001_QC-HB-000001', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC-HB-000001_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- referral_hospital
(null, 'QC-HB-000001_QC-HB-000002', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000002'), 'QC-HB-000002', 1, 30, 'referral data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 
(null, 'QC-HB-000001_QC-HB-000003', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality
(null, 'QC-HB-000001_QC-HB-000004', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000004'), 'QC-HB-000004', 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 2
(null, 'QC-HB-000001_QC-HB-000005', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000005'), 'QC-HB-000005', 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 2
(null, 'QC-HB-000001_QC-HB-000006', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000006'), 'QC-HB-000006', 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 3 
(null, 'QC-HB-000001_QC-HB-000007', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000007'), 'QC-HB-000007', 1, 35, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 3
(null, 'QC-HB-000001_QC-HB-000008', (SELECT id FROM structures WHERE old_id = 'QC-HB-000001'), 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-000008'), 'QC-HB-000008', 1, 36, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
  
INSERT INTO `structure_validations` (`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC-HB-000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-235'), 'CAN-999-999-000-999-235', 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'weight should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'QC-HB-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-236'), 'CAN-999-999-000-999-236', 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'height should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

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

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'lifestyle', 'summary', 'active', 'qc_hb_ed_hepatobiliary_lifestyle', 'qc_hb_ed_hepatobiliary_lifestyle', 0);

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_lifestyle`;
CREATE TABLE `qc_hb_ed_hepatobiliary_lifestyle` (
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

ALTER TABLE `qc_hb_ed_hepatobiliary_lifestyle`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_lifestyle_revs`;
CREATE TABLE `qc_hb_ed_hepatobiliary_lifestyle_revs` (
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
(null, 'QC-HB-000002', 'qc_hb_ed_hepatobiliary_lifestyle', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-HB-0000010', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lifestyle', 'active_tobacco', 'active_tobacco', '', 'select', '', '', @last_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000011', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lifestyle', 'active_alcohol', 'active_alcohol', '', 'select', '', '', @last_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC-HB-000002_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC-HB-000002'), 'QC-HB-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC-HB-000002_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC-HB-000002'), 'QC-HB-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC-HB-000002_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC-HB-000002'), 'QC-HB-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- active_tobacco
(null, 'QC-HB-000002_QC-HB-0000010', (SELECT id FROM structures WHERE old_id = 'QC-HB-000002'), 'QC-HB-000002', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000010'), 'QC-HB-0000010', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- active_alcohol
(null, 'QC-HB-000002_QC-HB-0000011', (SELECT id FROM structures WHERE old_id = 'QC-HB-000002'), 'QC-HB-000002', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000011'), 'QC-HB-0000011', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_summary
(null, 'QC-HB-000002_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC-HB-000002'), 'QC-HB-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('active_tobacco', 'active_alcohol', 'last update date', 'this type of event has already been created for your participant');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('active_tobacco', 'global', 'Active Tobacco', 'Tabagisme actif'),
('active_alcohol', 'global', 'Active Alcohol', 'Alcolisme chronique'),
('last update date', 'global', 'Last Update date', 'Date de mise &agrave; jour'),

('this type of event has already been created for your participant', '', 
  'This type of annotation has already been created for your participant!', 
  'Ce type d''annotation a d&eacute;j&agrave; eacyte;t&eacute; cr&eacute;&eacute;e pour votre participant!');

-- ... CLINIC: medical_past_history ...

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'asa medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'heart disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'vascular disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'respiratory disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'neural vascular disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'endocrine disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'urinary disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gastro-intestinal disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gynecologic disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'other disease medical past history', 'active', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0);

DROP TABLE IF EXISTS `qc_hb_hepatobiliary_medical_past_history_ctrls`;
CREATE TABLE `qc_hb_hepatobiliary_medical_past_history_ctrls` (
  `id` int(11) NOT NULL AUTO_INCREMENT, 
  `event_control_id` int(11) NOT NULL, 
  `disease_precision` varchar(250) NOT NULL,
  `display_order` int(2)default '0',  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_hepatobiliary_medical_past_history_ctrls`
  ADD FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
-- TODO Section to delete (for example)
INSERT INTO `qc_hb_hepatobiliary_medical_past_history_ctrls` 
(`id`, `event_control_id`, `disease_precision`, `display_order`)
VALUES 
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 1', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 2', '2'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 3', '3'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 4', '4'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'other', '5'),

(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'high blood pressure', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'tachycardia', '2'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'heart attack', '3'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'other', '4'),

(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'respiratory disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'neural vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'endocrine disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'urinary disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gastro-intestinal disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gynecologic disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'other disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1');

-- TODO to delete (for example)
DELETE FROM `i18n` WHERE `id` LIKE 'drug ex %';
DELETE FROM `i18n` WHERE `id`IN ('to define','high blood pressure', 'tachycardia', 'heart attack');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('drug ex 1', '', 'Drug 1', 'Mdt 1'),
('drug ex 2', '', 'Drug 2', 'Mdt 2'),
('drug ex 3', '', 'Drug 3', 'Mdt 3'),
('drug ex 4', '', 'Drug 4', 'Mdt 4'),
('drug ex 5', '', 'Drug 5', 'Mdt 5'),

('to define', '', 'To Define', 'A definir'),
('high blood pressure', '', 'High blood pressure', 'HTA'),
('tachycardia', '', 'Tachycardia', 'Tachycardie'),
('heart attack', '', 'Heart attack', 'Crise cardiaque');

-- TODO End section to delete

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-HB-000004', 'qc_hb_ed_hepatobiliary_medical_past_history', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_medical_past_history`;
CREATE TABLE `qc_hb_ed_hepatobiliary_medical_past_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disease_precision` varchar(250) DEFAULT NULL, 
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

ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_medical_past_history_revs`;
CREATE TABLE `qc_hb_ed_hepatobiliary_medical_past_history_revs` (
  `id` int(11) NOT NULL, 
  `disease_precision` varchar(250) DEFAULT NULL, 
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
(null, '', 'QC-HB-0000022', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_medical_past_history', 'disease_precision', 'medical history precision', '', 'select', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` LIKE 'QC-HB-000004_%';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC-HB-000004_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC-HB-000004'), 'QC-HB-000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'diagnostic date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC-HB-000004_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC-HB-000004'), 'QC-HB-000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC-HB-000004_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC-HB-000004'), 'QC-HB-000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- precision
(null, 'QC-HB-000004_QC-HB-0000022', (SELECT id FROM structures WHERE old_id = 'QC-HB-000004'), 'QC-HB-000004', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000022'), 'QC-HB-0000022', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC-HB-000004_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC-HB-000004'), 'QC-HB-000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id`IN (
'asa medical past history',
'heart disease medical past history',
'vascular disease medical past history',
'respiratory disease medical past history',
'neural vascular disease medical past history',
'endocrine disease medical past history',
'urinary disease medical past history',
'gastro-intestinal disease medical past history',
'gynecologic disease medical past history',
'other disease medical past history',

'diagnostic date', 
'medical history precision',

'detail exists for the deleted medical past history');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('asa medical past history', '', 'ASA', ''),
('heart disease medical past history', '', 'Heart Disease', 'Maladie du coeur'),
('vascular disease medical past history', '', 'Vascular Disease', 'Maladie vasculaire'),
('respiratory disease medical past history', '', 'Respiratory Disease', 'Maladie respiratoire'),
('neural vascular disease medical past history', '', 'Neural Vascular Disease', 'Maladie vasculaire cerebrale'),
('endocrine disease medical past history', '', 'Endocrine Disease', 'Maladie endocrine'),
('urinary disease medical past history', '', 'Urinary Disease', 'Maladie urinaire'),
('gastro-intestinal disease medical past history', '', 'Gastro-Intestinal Disease', 'Maladie gastro-intestinal'),
('gynecologic disease medical past history', '', 'Gynecologic Disease', 'Maladie gynecologique'),
('other disease medical past history', '', 'Other Disease', 'Autre maladie'),

('diagnostic date', '', 'Diagnostic Date', 'Date de diagnostic'),
('medical history precision', '', 'Precision', 'Pr&eacute;cision'),

('detail exists for the deleted medical past history', '', 
'Your data cannot be deleted! <br>Detail exist for the deleted medical past history.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des d&eacute;tails existent pour votre historique clinique.');

DELETE FROM `i18n` WHERE `id`IN ('annotation clinical details', 'add other clinical event', 'add medical history', 'add medical imaging');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('annotation clinical details', '', 'Details', 'D&eacute;tails'),
('add other clinical event', '', 'Add Other Data', 'Ajouter autres données'),
('add medical history', '', 'Add Medical History', 'Ajouter &eacute;venement clinique'),
('add medical imaging', '', 'Add Medical Imaging', 'Ajouter image m&eacute;dicale');

-- ... CLINIC: medical_past_history revision control...

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'medical past history record summary', 'active', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 0);

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-HB-000003', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_med_hist_record_summary`;
CREATE TABLE `qc_hb_ed_hepatobiliary_med_hist_record_summary` (
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

ALTER TABLE `qc_hb_ed_hepatobiliary_med_hist_record_summary`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `qc_hb_ed_hepatobiliary_med_hist_record_summary_revs`;
CREATE TABLE `qc_hb_ed_hepatobiliary_med_hist_record_summary_revs` (
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

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-HB-0000012', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'asa_value', 'asa medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000013', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'heart_disease', 'heart disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000014', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'respiratory_disease', 'respiratory disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000015', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'vascular_disease', 'vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000016', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'neural_vascular_disease', 'neural vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000017', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'endocrine_disease', 'endocrine disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000018', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'urinary_disease', 'urinary disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000019', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'gastro_intestinal_disease', 'gastro-intestinal disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000020', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'gynecologic_disease', 'gynecologic disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-HB-0000021', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'other_disease', 'other disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC-HB-000003_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC-HB-000003_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC-HB-000003_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- 
(null, 'QC-HB-000003_QC-HB-0000012', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000012'), 'QC-HB-0000012', 1, 40, 'reviewed diseases', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000013', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000013'), 'QC-HB-0000013', 1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000014', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000014'), 'QC-HB-0000014', 1, 42, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000015', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000015'), 'QC-HB-0000015', 1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000016', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000016'), 'QC-HB-0000016', 1, 44, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000017', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000017'), 'QC-HB-0000017', 1, 45, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000018', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000018'), 'QC-HB-0000018', 1, 46, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000019', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000019'), 'QC-HB-0000019', 1, 47, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000020', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000020'), 'QC-HB-0000020', 1, 48, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC-HB-000003_QC-HB-0000021', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-0000021'), 'QC-HB-0000021', 1, 49, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC-HB-000003_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC-HB-000003'), 'QC-HB-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id`IN ('reviewed diseases', 'medical past history record summary');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('reviewed diseases', '', 'Reviewed Diseases/Events', 'Pathologies/&Eacute;venements r&eacute;visionn&eacute;s'),
('medical past history record summary', '', 'Medcial Review Summary', 'R&eacute;sum&eacute; des r&eacute;visions m&eacute;dicales');

#lab_report_biology
CREATE TABLE qc_hb_ed_hepatobilary_lab_report_biology(
	id int(11) unsigned not null auto_increment primary key,
	wbc smallint DEFAULT NULL,
	rbc smallint DEFAULT NULL,
	hb smallint DEFAULT NULL,
	ht smallint DEFAULT NULL,
	platelets smallint DEFAULT NULL,
	ptt smallint DEFAULT NULL,
	inr smallint DEFAULT NULL,
	na smallint DEFAULT NULL,
	k smallint DEFAULT NULL,
	cl smallint DEFAULT NULL,
	creatinine smallint DEFAULT NULL,
	urea smallint DEFAULT NULL,
	ca smallint DEFAULT NULL,
	p smallint DEFAULT NULL,
	mg smallint  DEFAULT NULL,
	protein smallint  DEFAULT NULL,
	uric_acid smallint  DEFAULT NULL,
	glycemia smallint  DEFAULT NULL,
	triglycerides smallint  DEFAULT NULL,
	cholesterol smallint  DEFAULT NULL,
	albumin smallint  DEFAULT NULL,
	total_bilirubin smallint  DEFAULT NULL,
	direct_bilirubin smallint  DEFAULT NULL,
	indirect_bilirubin smallint  DEFAULT NULL,
	ast smallint  DEFAULT NULL,
	alt smallint  DEFAULT NULL,
	alkaline_phosphatase smallint  DEFAULT NULL,
	amylase smallint  DEFAULT NULL,
	lipase smallint  DEFAULT NULL,
	a_fp smallint  DEFAULT NULL,
	cea smallint  DEFAULT NULL,
	ca_19_9 smallint  DEFAULT NULL,
	chromogranine smallint  DEFAULT NULL,
	_5_HIAA smallint  DEFAULT NULL,
	ca_125 smallint  DEFAULT NULL,
	ca_15_3 smallint  DEFAULT NULL,
	b_hcg smallint  DEFAULT NULL,
	other_marker_1 smallint  DEFAULT NULL,
	other_marker_2 smallint  DEFAULT NULL,
	summary text DEFAULT NULL,
	`created` date DEFAULT NULL,
	`created_by` varchar(50) DEFAULT NULL,
	`modified` date DEFAULT NULL,
	`modified_by` varchar(50) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
	`deleted_date` datetime DEFAULT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE qc_hb_ed_hepatobilary_lab_report_biology_revs(
	id int(11) unsigned not null,
	wbc smallint DEFAULT NULL,
	rbc smallint DEFAULT NULL,
	hb smallint DEFAULT NULL,
	ht smallint DEFAULT NULL,
	platelets smallint DEFAULT NULL,
	ptt smallint DEFAULT NULL,
	inr smallint DEFAULT NULL,
	na smallint DEFAULT NULL,
	k smallint DEFAULT NULL,
	cl smallint DEFAULT NULL,
	creatinine smallint DEFAULT NULL,
	urea smallint DEFAULT NULL,
	ca smallint DEFAULT NULL,
	p smallint DEFAULT NULL,
	mg smallint  DEFAULT NULL,
	protein smallint  DEFAULT NULL,
	uric_acid smallint  DEFAULT NULL,
	glycemia smallint  DEFAULT NULL,
	triglycerides smallint  DEFAULT NULL,
	cholesterol smallint  DEFAULT NULL,
	albumin smallint  DEFAULT NULL,
	total_bilirubin smallint  DEFAULT NULL,
	direct_bilirubin smallint  DEFAULT NULL,
	indirect_bilirubin smallint  DEFAULT NULL,
	ast smallint  DEFAULT NULL,
	alt smallint  DEFAULT NULL,
	alkaline_phosphatase smallint  DEFAULT NULL,
	amylase smallint  DEFAULT NULL,
	lipase smallint  DEFAULT NULL,
	a_fp smallint  DEFAULT NULL,
	cea smallint  DEFAULT NULL,
	ca_19_9 smallint  DEFAULT NULL,
	chromogranine smallint  DEFAULT NULL,
	_5_HIAA smallint  DEFAULT NULL,
	ca_125 smallint  DEFAULT NULL,
	ca_15_3 smallint  DEFAULT NULL,
	b_hcg smallint  DEFAULT NULL,
	other_marker_1 smallint  DEFAULT NULL,
	other_marker_2 smallint  DEFAULT NULL,
	summary text DEFAULT NULL,
	`created` date DEFAULT NULL,
	`created_by` varchar(50) DEFAULT NULL,
	`modified` date DEFAULT NULL,
	`modified_by` varchar(50) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
	`deleted_date` datetime DEFAULT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT primary key,
  	`version_created` datetime NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`status` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES (NULL , 'hepatobillary', 'lab', 'biology', 'active', 'ed_hepatobiliary_lab_report_biology', 'qc_hb_ed_hepatobilary_lab_report_biology', '0');
INSERT INTO structures(`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('QC-HB-100001', 'ed_hepatobiliary_lab_report_biology', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'QC-HB-100002', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'wbc', 'wbc', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100003', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'rbc', 'rbc', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100004', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'hb', 'hb', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100005', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ht', 'ht', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100006', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'platelets', 'platelets', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100007', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ptt', 'ptt', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100008', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'inr', 'inr', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100009', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'na', 'na', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100010', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'k', 'k', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100011', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cl', 'cl', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100012', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'creatinine', 'creatinine', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100013', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'urea', 'urea', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100014', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca', 'ca', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100015', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'p', 'p', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100016', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'mg', 'mg', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100017', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'protein', 'protein', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100018', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'uric_acid', 'uric acid', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100019', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'glycemia', 'glycemia', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100020', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'triglycerides', 'triglycerides', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100021', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cholesterol', 'cholesterol', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100022', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'albumin', 'albumin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100023', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'total_bilirubin', 'total bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100024', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'direct_bilirubin', 'direct bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100025', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'indirect_bilirubin', 'indirec _bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100026', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ast', 'ast', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100027', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'alt', 'alt', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100028', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'alkaline_phosphatase', 'alkalin _phosphatase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100029', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'amylase', 'amylase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100030', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'lipase', 'lipase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100031', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'a_fp', 'a fp', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100032', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cea', 'cea', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100033', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_19_9', 'ca 19 9', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100034', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'chromogranine', 'chromogranine', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100035', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', '_5_HIAA', '5 HIAA', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100036', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_125', 'ca 125', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100037', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_15_3', 'ca 15 3', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100038', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'b_hcg', 'b hcg', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100039', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_1', 'other marker 1', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100040', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_2', 'other marker 2', '', 'number', '', '', NULL, '', '', '', '');
SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) (SELECT CONCAT('QC-HB-100001_', old_id), (SELECT id FROM structures WHERE old_id='QC-HB-100001'), 'QC-HB-100001', `id`, `old_id`, IF(id - @last_id <= 19, '0', '1'), (id - @last_id) % 20, '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00', '1' FROM structure_fields WHERE id >= @last_id);
UPDATE structure_formats SET language_heading='blood formulae' WHERE old_id='QC-HB-100001_QC-HB-100002';
UPDATE structure_formats SET language_heading='coagulation' WHERE old_id='QC-HB-100001_QC-HB-100007';
UPDATE structure_formats SET language_heading='electrolyte' WHERE old_id='QC-HB-100001_QC-HB-100009';
UPDATE structure_formats SET language_heading='other' WHERE old_id='QC-HB-100001_QC-HB-100018';
UPDATE structure_formats SET language_heading='bilan hepatique' WHERE old_id='QC-HB-100001_QC-HB-100022';
UPDATE structure_formats SET language_heading='bilan pancreatique' WHERE old_id='QC-HB-100001_QC-HB-100029';
UPDATE structure_formats SET language_heading='bilan marqueur' WHERE old_id='QC-HB-100001_QC-HB-100031';

CREATE TABlE qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med(
	id int(11) unsigned not null auto_increment primary key,
	abdominal_ultrasound varchar(5) DEFAULT NULL,
	pelvic_ultrasound varchar(5) DEFAULT NULL,
	abdominal_cs_scan varchar(5) DEFAULT NULL,
	pelvis_ct_scan varchar(5) DEFAULT NULL,
	abdominal_mri varchar(5) DEFAULT NULL,
	pelvis_mri varchar(5) DEFAULT NULL,
	chest_x_ray varchar(5) DEFAULT NULL,
	thorax_ct_scan varchar(5) DEFAULT NULL,
	tepscan varchar(5) DEFAULT NULL,
	octreoscan_scintigraphy varchar(5) DEFAULT NULL,
	contrast_enhanced_ultrasound varchar(5) DEFAULT NULL,
	endoscopic_ultrasound varchar(5) DEFAULT NULL,
	colonoscopy varchar(5) DEFAULT NULL,
	contrast_enema varchar(5) DEFAULT NULL,
	ercp varchar(5) DEFAULT NULL,
	transhepatic_cholangiography varchar(5) DEFAULT NULL,
	`created` date DEFAULT NULL,
	`created_by` varchar(50) DEFAULT NULL,
	`modified` date DEFAULT NULL,
	`modified_by` varchar(50) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
	`deleted_date` datetime DEFAULT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABlE qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med_revs(
	id int(11) unsigned not null,
	abdominal_ultrasound varchar(5) DEFAULT NULL,
	pelvic_ultrasound varchar(5) DEFAULT NULL,
	abdominal_cs_scan varchar(5) DEFAULT NULL,
	pelvis_ct_scan varchar(5) DEFAULT NULL,
	abdominal_mri varchar(5) DEFAULT NULL,
	pelvis_mri varchar(5) DEFAULT NULL,
	chest_x_ray varchar(5) DEFAULT NULL,
	thorax_ct_scan varchar(5) DEFAULT NULL,
	tepscan varchar(5) DEFAULT NULL,
	octreoscan_scintigraphy varchar(5) DEFAULT NULL,
	contrast_enhanced_ultrasound varchar(5) DEFAULT NULL,
	endoscopic_ultrasound varchar(5) DEFAULT NULL,
	colonoscopy varchar(5) DEFAULT NULL,
	contrast_enema varchar(5) DEFAULT NULL,
	ercp varchar(5) DEFAULT NULL,
	transhepatic_cholangiography varchar(5) DEFAULT NULL,
	`created` date DEFAULT NULL,
	`created_by` varchar(50) DEFAULT NULL,
	`modified` date DEFAULT NULL,
	`modified_by` varchar(50) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
	`deleted_date` datetime DEFAULT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT primary key,
	`version_created` datetime NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`status` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES (NULL , 'hepatobillary', 'clinical', 'radio_enco_nuclear_med', 'active', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', '0');
INSERT INTO structures(`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('QC-HB-100041', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', '', '', '1', '1', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'QC-HB-100041', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'abdominal_ultrasound', 'abdominal ultrasound', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100042', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'pelvic_ultrasound', 'pelvic ultrasound', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100043', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'abdominal_cs_scan', 'abdominal cs_scan', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100044', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'pelvis_ct_scan', 'pelvis ct_scan', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100045', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'abdominal_mri', 'abdominal mri', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100046', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'chest_x_ray', 'chest x_ray', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100047', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'thorax_ct_scan', 'thorax ct_scan', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100048', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'tepscan', 'tepscan', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100049', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'octreoscan_scintigraphy', 'octreoscan scintigraphy', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100050', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'contrast_enhanced_ultrasound', 'contrast enhanced_ultrasound', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100051', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'endoscopic_ultrasound', 'endoscopic ultrasound', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100052', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'colonoscopy', 'colonoscopy', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100053', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'contrast_enema', 'contrast enema', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100054', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'ercp', 'ercp', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', ''),
('', 'QC-HB-100055', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lab_radio_enco_nuclear_med', 'transhepatic_cholangiography', 'transhepatic cholangiography', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', '', '', '');

SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) (SELECT CONCAT('QC-HB-100041_', old_id), (SELECT id FROM structures WHERE old_id='QC-HB-100041'), 'QC-HB-100001', `id`, `old_id`, IF(id - @last_id <= 19, '0', '1'), (id - @last_id) % 20, '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00', '1' FROM structure_fields WHERE id >= @last_id);

ALTER TABLE event_controls
	MODIFY event_type VARCHAR(55) NOT NULL DEFAULT '';

#medical imaging
INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`status` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES 
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal ultrasound', 'active', 'qc_hb_imaging_segment_other_pancreas', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging pelvic ultrasound', 'active', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal CT-scan', 'active', 'qc_hb_imaging_segment_other_pancreas_volumetry', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging pelvis CT-scan', 'active', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal MRI', 'active', 'qc_hb_imaging_segment_other_pancreas_volumetry', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging pelvis MRI', 'active', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging chest X-ray', 'active', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging thorax CT-scan', 'active', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging TEP-scan', 'active', 'qc_hb_imaging_segment_other_pancreas', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging octreoscan scintigraphy', 'active', 'qc_hb_imaging_segment_other_pancreas', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging contrast-enhanced ultrasound (CEUS)', 'active', 'qc_hb_imaging_segment', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging doppler ultrasound', 'active', 'qc_hb_imaging_pancreas', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging endoscopic ultrasound (EUS)', 'active', 'qc_hb_imaging_other_pancreas', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging colonoscopy', 'active', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging contrast enema', 'active', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging ERCP', 'active', 'qc_hb_imaging_pancreas', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging transhepatic cholangiography', 'active', 'qc_hb_imaging_pancreas', 'qc_hb_ed_hepatobilary_exams', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging HIDA scan', 'active', 'qc_hb_imaging_', 'qc_hb_ed_hepatobilary_exams', '0');

INSERT INTO structures(`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('QC-HB-100056', 'qc_hb_segment', '', '', '1', '1', '1', '1'),
('QC-HB-100057', 'qc_hb_other_localisations', '', '', '1', '1', '1', '1'),
('QC-HB-100058', 'qc_hb_pancreas', '', '', '1', '1', '1', '1');

CREATE TABLE qc_hb_ed_hepatobilary_exams(
	`id` int unsigned NOT NULL auto_increment PRIMARY KEY,
	`event_master_id` int NOT NULL,
	
	`segment_1_number` smallint unsigned DEFAULT NULL,
	`segment_1_size` smallint unsigned DEFAULT NULL,
	`segment_2_number` smallint unsigned DEFAULT NULL,
	`segment_2_size` smallint unsigned DEFAULT NULL,
	`segment_3_number` smallint unsigned DEFAULT NULL,
	`segment_3_size` smallint unsigned DEFAULT NULL,
	`segment_4a_number` smallint unsigned DEFAULT NULL,
	`segment_4a_size` smallint unsigned DEFAULT NULL,
	`segment_4b_number` smallint unsigned DEFAULT NULL,
	`segment_4b_size` smallint unsigned DEFAULT NULL,
	`segment_5_number` smallint unsigned DEFAULT NULL,
	`segment_5_size` smallint unsigned DEFAULT NULL,
	`segment_6_number` smallint unsigned DEFAULT NULL,
	`segment_6_size` smallint unsigned DEFAULT NULL,
	`segment_7_number` smallint unsigned DEFAULT NULL,
	`segment_7_size` smallint unsigned DEFAULT NULL,
	`segment_8_number` smallint unsigned DEFAULT NULL,
	`segment_8_size` smallint unsigned DEFAULT NULL,
	
	`lungs_number` smallint unsigned DEFAULT NULL,
	`lungs_size` smallint unsigned DEFAULT NULL,
	`lungs_laterality` varchar(20) DEFAULT NULL,
	`lymph_node_number` smallint unsigned DEFAULT NULL,
	`lymph_node_size` smallint unsigned DEFAULT NULL,
	`colon_number` smallint unsigned DEFAULT NULL,
	`colon_size` smallint unsigned DEFAULT NULL,
	`rectum_number` smallint unsigned DEFAULT NULL,
	`rectum_size` smallint unsigned DEFAULT NULL,
	`bones_number` smallint unsigned DEFAULT NULL,
	`bones_size` smallint unsigned DEFAULT NULL,
	
	
	`hepatic_artery` varchar(10) DEFAULT NULL,
	`coeliac_trunk` varchar(10) DEFAULT NULL,
	`splenic_artery` varchar(10) DEFAULT NULL,
	`superior_esenteric_artery` varchar(10) DEFAULT NULL,
	`portal_vein` varchar(10) DEFAULT NULL,
	`superior_mesenteric_vein` varchar(10) DEFAULT NULL,
	`splenic_vein` varchar(10) DEFAULT NULL,
	
	`remnant_liver_percentage` FLOAT DEFAULT NULL,
	`volumetric_type` varchar(10) DEFAULT NULL,
	
	`summary` text DEFAULT NULL,
	
	`created` date DEFAULT NULL,
	`created_by` varchar(50) DEFAULT NULL,
	`modified` date DEFAULT NULL,
	`modified_by` varchar(50) DEFAULT NULL,
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
	`deleted_date` datetime DEFAULT NULL,
	FOREIGN KEY (`event_master_id`) REFERENCES `event_masters`(`id`)
)Engine=InnoDB;
CREATE TABLE qc_hb_ed_hepatobilary_exams_revs(
	`id` int unsigned NOT NULL,
	`event_master_id` int NOT NULL,
	
	`segment_1_number` smallint unsigned DEFAULT NULL,
	`segment_1_size` smallint unsigned DEFAULT NULL,
	`segment_2_number` smallint unsigned DEFAULT NULL,
	`segment_2_size` smallint unsigned DEFAULT NULL,
	`segment_3_number` smallint unsigned DEFAULT NULL,
	`segment_3_size` smallint unsigned DEFAULT NULL,
	`segment_4a_number` smallint unsigned DEFAULT NULL,
	`segment_4a_size` smallint unsigned DEFAULT NULL,
	`segment_4b_number` smallint unsigned DEFAULT NULL,
	`segment_4b_size` smallint unsigned DEFAULT NULL,
	`segment_5_number` smallint unsigned DEFAULT NULL,
	`segment_5_size` smallint unsigned DEFAULT NULL,
	`segment_6_number` smallint unsigned DEFAULT NULL,
	`segment_6_size` smallint unsigned DEFAULT NULL,
	`segment_7_number` smallint unsigned DEFAULT NULL,
	`segment_7_size` smallint unsigned DEFAULT NULL,
	`segment_8_number` smallint unsigned DEFAULT NULL,
	`segment_8_size` smallint unsigned DEFAULT NULL,
	
	`lungs_number` smallint unsigned DEFAULT NULL,
	`lungs_size` smallint unsigned DEFAULT NULL,
	`lungs_laterality` varchar(20) DEFAULT NULL,
	`lymph_node_number` smallint unsigned DEFAULT NULL,
	`lymph_node_size` smallint unsigned DEFAULT NULL,
	`colon_number` smallint unsigned DEFAULT NULL,
	`colon_size` smallint unsigned DEFAULT NULL,
	`rectum_number` smallint unsigned DEFAULT NULL,
	`rectum_size` smallint unsigned DEFAULT NULL,
	`bones_number` smallint unsigned DEFAULT NULL,
	`bones_size` smallint unsigned DEFAULT NULL,
	
	
	`hepatic_artery` varchar(10) DEFAULT NULL,
	`coeliac_trunk` varchar(10) DEFAULT NULL,
	`splenic_artery` varchar(10) DEFAULT NULL,
	`superior_esenteric_artery` varchar(10) DEFAULT NULL,
	`portal_vein` varchar(10) DEFAULT NULL,
	`superior_mesenteric_vein` varchar(10) DEFAULT NULL,
	`splenic_vein` varchar(10) DEFAULT NULL,
	
	`remnant_liver_percentage` FLOAT DEFAULT NULL,
	`volumetric_type` varchar(10) DEFAULT NULL,
	
	`summary` text DEFAULT NULL,
	
	`created` date DEFAULT NULL,
	`created_by` varchar(50) DEFAULT NULL,
	`modified` date DEFAULT NULL,
	`modified_by` varchar(50) DEFAULT NULL,
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
	`deleted_date` datetime DEFAULT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`version_created` datetime NOT NULL
)Engine=InnoDB;

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'QC-HB-100059', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_1_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100060', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_1_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100061', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_2_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100062', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_2_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100063', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_3_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100064', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_3_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100065', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_4a_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100066', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_4a_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100067', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_4b_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100068', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_4b_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100069', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_5_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100070', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_5_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100071', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_6_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100072', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_6_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100073', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_7_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100074', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_7_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100075', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_8_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100076', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'segment_8_size', 'size', '', 'number', '', '', NULL, '', '', '', '');

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('QC-HB-100056_QC-HB-100059', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100059'), 'QC-HB-100059', '0', '0', 'segment I', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100060', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100060'), 'QC-HB-100060', '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100061', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100061'), 'QC-HB-100061', '0', '2', 'segment II', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100062', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100062'), 'QC-HB-100062', '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100063', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100063'), 'QC-HB-100063', '0', '4', 'segment III', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100064', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100064'), 'QC-HB-100064', '0', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100065', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100065'), 'QC-HB-100065', '0', '6', 'segment IVa', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100066', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100066'), 'QC-HB-100066', '0', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100067', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100067'), 'QC-HB-100067', '0', '8', 'segment IVb', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100068', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100068'), 'QC-HB-100068', '0', '9', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100069', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100069'), 'QC-HB-100069', '1', '10', 'segment V', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100070', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100070'), 'QC-HB-100070', '1', '11', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100071', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100071'), 'QC-HB-100071', '1', '12', 'segment VI', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100072', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100072'), 'QC-HB-100072', '1', '13', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100073', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100073'), 'QC-HB-100073', '1', '14', 'segment VII', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100074', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100074'), 'QC-HB-100074', '1', '15', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100075', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100075'), 'QC-HB-100075', '1', '16', 'segment VIII', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100056_QC-HB-100076', (SELECT id FROM structures WHERE old_id = 'QC-HB-100056'), 'QC-HB-100056', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100076'), 'QC-HB-100076', '1', '17', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');


INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'QC-HB-100076b', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'lungs_number', 'lungs number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100077', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'lungs_size', 'lungs size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100078', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'lungs_laterality', 'lungs laterality', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='laterality'), '', '', '', '');

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
('QC-HB-100057_QC-HB-100076b', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100076b'), 'QC-HB-100076b', '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100077', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100077'), 'QC-HB-100077', '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100078', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100078'), 'QC-HB-100078', '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('yes_no_suspicion', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('yes', 'yes');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='yes' AND language_alias='yes'), '1', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('no', 'no');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='no' AND language_alias='no'), '2', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('suspicion', 'suspicion');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='suspicion' AND language_alias='suspicion'), '3', 'yes');
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'QC-HB-100079', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'hepatic_artery', 'hepatic artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'QC-HB-100080', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'coeliac_trunk', 'coeliac trunk', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'QC-HB-100081', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'splenic_artery', 'splenic artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'QC-HB-100082', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'superior_esenteric_artery', 'superior esenteric artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'QC-HB-100083', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'portal_vein', 'portal vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'QC-HB-100084', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'superior_mesenteric_vein', 'superior mesenteric vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'QC-HB-100085', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'splenic_vein', 'splenic vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', '');

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
('QC-HB-100058_QC-HB-100079', (SELECT id FROM structures WHERE old_id = 'QC-HB-100058'), 'QC-HB-100058', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100079'), 'QC-HB-100079', '0', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100058_QC-HB-100080', (SELECT id FROM structures WHERE old_id = 'QC-HB-100058'), 'QC-HB-100058', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100080'), 'QC-HB-100080', '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100058_QC-HB-100081', (SELECT id FROM structures WHERE old_id = 'QC-HB-100058'), 'QC-HB-100058', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100081'), 'QC-HB-100081', '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100058_QC-HB-100082', (SELECT id FROM structures WHERE old_id = 'QC-HB-100058'), 'QC-HB-100058', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100082'), 'QC-HB-100082', '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100058_QC-HB-100083', (SELECT id FROM structures WHERE old_id = 'QC-HB-100058'), 'QC-HB-100058', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100083'), 'QC-HB-100083', '1', '4', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100058_QC-HB-100084', (SELECT id FROM structures WHERE old_id = 'QC-HB-100058'), 'QC-HB-100058', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100084'), 'QC-HB-100084', '1', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
('QC-HB-100058_QC-HB-100085', (SELECT id FROM structures WHERE old_id = 'QC-HB-100058'), 'QC-HB-100058', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100085'), 'QC-HB-100085', '1', '6', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'QC-HB-100086', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'lymph_node_number', 'lymph node number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100087', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'lymph_node_size', 'lymph node size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100088', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'colon_number', 'colon number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100089', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'colon_size', 'colon size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100090', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'rectum_number', 'rectum number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100091', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'rectum_size', 'rectum size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100092', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'bones_number', 'bones number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100093', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'bones_size', 'bones size', '', 'number', '', '', NULL, '', '', '', '');

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
('QC-HB-100057_QC-HB-100086', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100086'), 'QC-HB-100086', '0', '4', 'lymph node', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100087', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100087'), 'QC-HB-100087', '0', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100088', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100088'), 'QC-HB-100088', '0', '6', 'colon', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100089', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100089'), 'QC-HB-100089', '0', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100090', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100090'), 'QC-HB-100090', '1', '8', 'rectum', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100091', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100091'), 'QC-HB-100091', '1', '9', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100092', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100092'), 'QC-HB-100092', '1', '10', 'bones', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100057_QC-HB-100093', (SELECT id FROM structures WHERE old_id = 'QC-HB-100057'), 'QC-HB-100057', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100093'), 'QC-HB-100093', '1', '11', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT INTO structures(`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('QC-HB-100094', 'qc_hb_dateNSummary', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'QC-HB-100095', 'Clinicalannotation', 'EventMaster', '', 'event_date', 'date', '', 'date', '', '', NULL, '', '', '', ''),
('', 'QC-HB-100096', 'Clinicalannotation', 'EventDetail', '', 'summary', 'summary', '', 'textarea', '', '', NULL, '', '', '', '');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
('QC-HB-100094_QC-HB-100095', (SELECT id FROM structures WHERE old_id = 'QC-HB-100094'), 'QC-HB-100094', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100095'), 'QC-HB-100095', '0', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
('QC-HB-100094_QC-HB-100096', (SELECT id FROM structures WHERE old_id = 'QC-HB-100094'), 'QC-HB-100094', (SELECT id FROM structure_fields WHERE old_id = 'QC-HB-100096'), 'QC-HB-100096', '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('volumetric_type', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('initial', 'initial');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='volumetric_type'),  (SELECT id FROM structure_permissible_values WHERE value='initial' AND language_alias='initial'), '0', 'yes');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('post pve', 'post pve');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='volumetric_type'),  (SELECT id FROM structure_permissible_values WHERE value='post pve' AND language_alias='post pve'), '1', 'yes');
INSERT INTO structures(`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('QC-HB-100097', 'qc_hb_volumetry', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'QC-HB-100098', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'remnant_liver_percentage', 'remnant liver percentage', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), ('', 'QC-HB-100099', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_exams', 'volumetric_type', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name ='volumetric_type'), '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('QC-HB-100097_QC-HB-100098', (SELECT id FROM structures WHERE old_id='QC-HB-100097'), 'QC-HB-100097', (SELECT id FROM structure_fields WHERE old_id='QC-HB-100098'), 'QC-HB-100098', '0', '0', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '', '', '1', '', '1', '1') ON DUPLICATE KEY UPDATE display_column='0', display_order='0', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('QC-HB-100097_QC-HB-100099', (SELECT id FROM structures WHERE old_id='QC-HB-100097'), 'QC-HB-100097', (SELECT id FROM structure_fields WHERE old_id='QC-HB-100099'), 'QC-HB-100099', '0', '1', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '', '', '1', '', '1', '1') ON DUPLICATE KEY UPDATE display_column='0', display_order='1', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;




#end medical imaging