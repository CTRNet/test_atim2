-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM fro CRCHMU Hepato-Bil Bank
--
-- -------------------------------------------------------------------

-- General

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('core_appname', 'global', 'ATiM.v2 - CHUM Hep-bil', 'ATiM.v2 - CHUM Hep-bil'),
('CTRApp', 'global', 'ATiM.v2 - CHUM Hep-bil', 'ATiM.v2 - CHUM Hep-bil');

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- CLINICAL ANNOTATION
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- *** PROFILE *********************************************************

-- Participant identifer : Read only & Label changed to 'Participant Code'

UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit_readonly` = '1',
`flag_datagrid_readonly` = '1',
`flag_override_label` = '1',
`language_label` = 'participant code'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'participant_identifier'
);

DELETE FROM `i18n` WHERE `id` IN ('participant code');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('participant code', 'global', 'Code', 'Code');

-- Participant title + middle name : Hidden

UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE structure_field_id IN (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field IN ('middle_name', 'title')
);

-- Participant first name / last name : Required & Add tags
UPDATE `structure_formats`
SET 
`flag_override_label` = '1',
`language_label` = 'first name',
`flag_override_tag` = '0',
`language_tag` = ''
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'first_name'
);

INSERT INTO `structure_validations` 
(`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'Participant' AND tablename = 'participants' AND field = 'first_name'), 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
UPDATE `structure_formats`
SET 
`flag_override_label` = '1',
`language_label` = 'last name',
`flag_override_tag` = '0',
`language_tag` = ''
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'last_name'
);
 
INSERT INTO `structure_validations` 
(`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'Participant' AND tablename = 'participants' AND field = 'last_name'), 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
DELETE FROM `i18n` WHERE `id` IN ('first name and last name are required');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('first name and last name are required', 'global', 'First name and last name are required!', 'Le nom et prénom sont requis!');

-- Participant race : Hidden
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field = 'race'
);

-- secondary_cod_icd10_code + cod_confirmation_source : Hidden
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id IN (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'Participant' 
	AND tablename = 'participants' 
	AND field IN ('secondary_cod_icd10_code', 'cod_confirmation_source')
);

-- *** IDENTIFIER ******************************************************

DELETE FROM `misc_identifier_controls`;
INSERT INTO `misc_identifier_controls` 
(`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`) 
VALUES
(null, 'health_insurance_card', 'RAMQ', '1', 0, '', ''),
(null, 'saint_luc_hospital_nbr', 'ID HSL', '1', 1, '', ''),
(null, 'hepato_bil_bank_participant_id', 'HB-PartID', '1', 3, 'hepato_bil_bank_participant_id', 'HB-P%%key_increment%%');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('hepato_bil_bank_participant_id', 1);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('health_insurance_card', 'global', 'Health Insurance Card', 'Carte d''assurance maladie'),
('saint_luc_hospital_nbr', 'global', 'St Luc Hospital Number', 'No Hôpital St Luc'),
('hepato_bil_bank_participant_id', 'global', 'H.B. Bank Participant Id', 'Numéro participant banque H.B.'),
('this identifier has already been created for your participant', '', 'This identifier has already been created for your participant!', 'Cet identification a déjà été créée pour ce participant!');

-- *** CONTACT *********************************************************

-- Other Contact Type : Hidden
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE 
structure_id = (SELECT id FROM structures WHERE alias = 'participantcontacts')
AND structure_field_id IN (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'ParticipantContact' 
	AND tablename = 'participant_contacts' 
	AND field IN ('other_contact_type')
);
 	 	 	
-- Other Contact Type : text box
UPDATE `structure_fields` SET `type` = 'input', `setting` = 'size=30' 
WHERE plugin = 'Clinicalannotation' 
AND model = 'ParticipantContact' 
AND tablename = 'participant_contacts' 
AND field IN ('contact_type');

-- *** ANNOTATION ******************************************************

DELETE FROM `event_masters`;
DELETE FROM `event_controls` ;

-- ... SCREENING .......................................................

UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_27' ;

-- ... STUDY ...........................................................

UPDATE `menus` SET `flag_active` =  '0' WHERE `menus`.`id` = 'clin_CAN_33' ;

-- ... CLINIC: presentation ............................................

DELETE FROM `menus` WHERE `id` IN ('clin_qc_hb_31', 'clin_qc_hb_32', 'clin_qc_hb_33');
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('clin_qc_hb_31', 'clin_CAN_31', 0, 1, 'annotation clinical details', 'annotation clinical details', '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%//', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_qc_hb_33', 'clin_CAN_31', 0, 2, 'annotation clinical reports', 'annotation clinical reports', '/clinicalannotation/event_masters/imageryReport/%%Participant.id%%/', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('add other clinical event', '', 'Add Other Data', 'Ajouter autres données'),
('add medical history', '', 'Add Medical History', 'Ajouter évenement clinique'),
('add medical imaging', '', 'Add Medical Imaging', 'Ajouter image médicale'),

('this type of event has already been created for your participant', '', 
  'This type of annotation has already been created for your participant!', 
  'Ce type d''annotation a déjà eacyte;té créée pour votre participant!'),

('annotation clinical details', '', 'Details', 'Détails'),
('annotation clinical reports', '', 'Reports', 'Rapports');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'clinical', 'presentation', '1', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'qc_hb_ed_hepatobiliary_clinical_presentation', 0);

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_clinical_presentation` (
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
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_clinical_presentation_revs` (
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
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_clinical_presentation', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_specialty', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('general physician', 'general physician');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='general physician' AND language_alias='general physician'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('gastroenterologist', 'gastroenterologist');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='gastroenterologist' AND language_alias='gastroenterologist'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('surgeon', 'surgeon');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='surgeon' AND language_alias='surgeon'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('oncologist', 'oncologist');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='oncologist' AND language_alias='oncologist'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('other', 'other');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'),  (SELECT id FROM structure_permissible_values WHERE value='other' AND language_alias='other'), '', '1');
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_hbp_surgeon_list', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('dagenais', 'dagenais');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='dagenais' AND language_alias='dagenais'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('lapointe', 'lapointe');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='lapointe' AND language_alias='lapointe'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('letourneau', 'letourneau');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='letourneau' AND language_alias='letourneau'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('plasse', 'plasse');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='plasse' AND language_alias='plasse'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('roy', 'roy');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='roy' AND language_alias='roy'), '', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('vanderbroucke-menu', 'vanderbroucke-menu');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'),  (SELECT id FROM structure_permissible_values WHERE value='vanderbroucke-menu' AND language_alias='vanderbroucke-menu'), '', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('bmi', '', 'BMI', 'IMC'),

('general physician', '', 'General Physician', 'Médecin généraliste'),
('gastroenterologist', '', 'Gastro-Enterologist', 'Gastro-entérologue'),
('surgeon', '', 'Surgeon', 'Chirurgien'),
('oncologist', '', 'Oncologist', 'Oncologue'),

('dagenais', '', 'Dr. Dagenais', 'Dr. Dagenais'),
('letourneau', '', 'Dr. Létourneau', 'Dr. Létourneau'),
('lapointe', '', 'Dr. Lapointe', 'Dr. Lapointe'),
('plasse', '', 'Dr. Plasse', 'Dr. Plasse'),
('roy', '', 'Dr. Roy', 'Dr. Roy'),
('vanderbroucke-menu', '', 'Dr. Vanderbroucke-Menu', 'Dr. Vanderbroucke-Menu');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'weight', 'weight', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'height', 'height', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'bmi', 'bmi', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_hospital', 'referral hospital', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian', 'referral physisian', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality', '', 'referral physisian speciality', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_2', 'referral physisian 2', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_2', '', 'referral physisian speciality', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_3', 'referral physisian 3', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_3', '', 'referral physisian speciality', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_specialty'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_clinical_presentation', 'hbp_surgeon', 'hbp surgeron', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_hbp_surgeon_list'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('hbp surgeron', '', 'HBP Surgeron', 'Chirurgien HBP'),
('first consultation date', 'global', 'First Consultation Date', 'Date première consultation'),
('referral data', 'global', 'Referral', 'Référent'),
('referral hospital', 'global', 'Referral Hospital', 'Hôpital référent'),
('referral physisian', 'global', 'Referral Physisian', 'Medecin référent'),
('referral physisian 2', 'global', '2nd Referral Physisian', '2nd Medecin référent'),
('referral physisian 3', 'global', '3rd Referral Physisian', '3eme Medecin référent'),
('referral physisian speciality', 'global', 'Speciality', 'Spécialité');

SET @QC_HB_000001_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_clinical_presentation');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- first_consultation_date
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'first consultation date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- hbp_surgeon
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('hbp_surgeon')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- weight
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('weight')), 0, 10, '', '1', 'weight (kg)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- height
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('height')), 0, 11, '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- bmi
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('bmi')), 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, @QC_HB_000001_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- referral_hospital
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_hospital')), 1, 30, 'referral data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian')), 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_speciality')), 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 2
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_2')), 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 2
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_speciality_2')), 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 3 
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_3')), 1, 35, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 3
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('referral_physisian_speciality_3')), 1, 36, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
  
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('weight')), 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'weight should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_clinical_presentation' AND field IN ('height')), 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'height should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES

('weight (kg)', 'global', 'Weight (kg)', 'Poids (kg)'),
('height (cm)', 'global', 'Height (cm)', 'Taille (cm)'),

('weight should be a positif decimal', 'global', 'Weight should be a positive decimal!', 'Le poids doit être un décimal positif!'),
('height should be a positif decimal', 'global', 'Height should be a positive decimal!', 'Le taille doit être un décimal positif!'),
('hepatobiliary', 'global', 'Hepatobiliary', 'Hépato-biliaire'),
('presentation', 'global', 'Presentation', 'Présentation');

-- ... CLINIC: medical_past_history ....................................

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'asa medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'heart disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'vascular disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'respiratory disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'neural vascular disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'endocrine disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'urinary disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gastro-intestinal disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gynecologic disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'other disease medical past history', '1', 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0);

CREATE TABLE IF NOT EXISTS `qc_hb_hepatobiliary_medical_past_history_ctrls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_control_id` int(11) NOT NULL,
  `disease_precision` varchar(250) NOT NULL,
  `display_order` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_control_id` (`event_control_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_hepatobiliary_medical_past_history_ctrls`
  ADD FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
-- TODO Section to delete: Has been set for example, waiting for real values.
INSERT INTO `qc_hb_hepatobiliary_medical_past_history_ctrls` 
(`id`, `event_control_id`, `disease_precision`, `display_order`)
VALUES 
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '1', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '2', '2'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '3', '3'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '4', '4'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), '5', '5'),

(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (heart)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (vascular)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'respiratory disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (respiratory)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'neural vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (neural)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'endocrine disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (endocrine)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'urinary disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (urinary)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gastro-intestinal disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (gastro-intestinal)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gynecologic disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (gynecologic)', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'other disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define (other)', '1');
-- TODO End todo

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_medical_past_history', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `disease_precision` varchar(250) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history_revs` (
  `id` int(11) NOT NULL,
  
  `disease_precision` varchar(250) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_medical_past_history', 'disease_precision', 'medical history precision', '', 'select', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @last_structure_field_id = LAST_INSERT_ID();

SET @QC_HB_000004_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_medical_past_history');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'diagnostic date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- precision
(null, @QC_HB_000004_structure_id, 
@last_structure_field_id, 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, @QC_HB_000004_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
-- TODO tranlsation
('asa medical past history', '', 'ASA', ''),
-- TODO end todo
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
('medical history precision', '', 'Precision', 'Précision'),

('detail exists for the deleted medical past history', '', 
'Your data cannot be deleted! <br>Detail exist for the deleted medical past history.', 
'Vos données ne peuvent être supprimées! Des détails existent pour votre historique clinique.');

-- ... LIFESTYLE : summary .............................................

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'lifestyle', 'summary', '1', 'qc_hb_ed_hepatobiliary_lifestyle', 'qc_hb_ed_hepatobiliary_lifestyle', 0);

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_lifestyle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `active_tobacco` varchar(10) DEFAULT NULL,
  `active_alcohol` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_lifestyle`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_lifestyle_revs` (
  `id` int(11) NOT NULL,
  
  `active_tobacco` varchar(10) DEFAULT NULL,
  `active_alcohol` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_lifestyle', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @yesno_domains_id = (SELECT id  FROM `structure_value_domains` WHERE `domain_name` LIKE 'yesno');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lifestyle', 'active_tobacco', 'active_tobacco', '', 'select', '', '', @yesno_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @QC_HB_0000010_structure_field_id = LAST_INSERT_ID();

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lifestyle', 'active_alcohol', 'active_alcohol', '', 'select', '', '', @yesno_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @QC_HB_0000011_structure_field_id = LAST_INSERT_ID();

SET @QC_HB_000002_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_lifestyle');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- active_tobacco
(null, @QC_HB_000002_structure_id, @QC_HB_0000010_structure_field_id, 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- active_alcohol
(null, @QC_HB_000002_structure_id, @QC_HB_0000011_structure_field_id, 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_summary
(null, @QC_HB_000002_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('active_tobacco', 'global', 'Active Tobacco', 'Tabagisme actif'),
('active_alcohol', 'global', 'Active Alcohol', 'Alcolisme chronique'),
('last update date', 'global', 'Last Update date', 'Date de mise à jour');

-- ... CLINIC: medical_past_history revision control ...................

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'medical past history record summary', '1', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 0);

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hepatobiliary_med_hist_record_summary', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_med_hist_record_summary` (
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
  `event_master_id` int(11) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_med_hist_record_summary`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_med_hist_record_summary_revs` (
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
  `event_master_id` int(11) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'asa_value', 'asa medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'heart_disease', 'heart disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'respiratory_disease', 'respiratory disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'vascular_disease', 'vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'neural_vascular_disease', 'neural vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'endocrine_disease', 'endocrine disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'urinary_disease', 'urinary disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'gastro_intestinal_disease', 'gastro-intestinal disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'gynecologic_disease', 'gynecologic disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_med_hist_record_summary', 'other_disease', 'other disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
SET @QC_HB_000003_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hepatobiliary_med_hist_record_summary');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('asa_value')), 1, 40, 'reviewed events', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('heart_disease')), 1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null,  @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('respiratory_disease')), 1, 42, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('vascular_disease')), 1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('neural_vascular_disease')), 1, 44, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('endocrine_disease')), 1, 45, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('urinary_disease')), 1, 46, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('gastro_intestinal_disease')), 1, 47, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('gynecologic_disease')), 1, 48, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, @QC_HB_000003_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobiliary_med_hist_record_summary' AND field IN ('other_disease')), 1, 49, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, @QC_HB_000003_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('reviewed events', '', 'Reviewed Events', 'Évenements révisionnés'),
('medical past history record summary', '', 'Medcial Review Summary', 'Résumé des révisions médicales');

-- ... LAB: biology ....................................................

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobilary_lab_report_biology` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, 
  `wbc` smallint(6) DEFAULT NULL,
  `rbc` smallint(6) DEFAULT NULL,
  `hb` smallint(6) DEFAULT NULL,
  `ht` smallint(6) DEFAULT NULL,
  `platelets` smallint(6) DEFAULT NULL,
  `ptt` smallint(6) DEFAULT NULL,
  `inr` smallint(6) DEFAULT NULL,
  `na` smallint(6) DEFAULT NULL,
  `k` smallint(6) DEFAULT NULL,
  `cl` smallint(6) DEFAULT NULL,
  `creatinine` smallint(6) DEFAULT NULL,
  `urea` smallint(6) DEFAULT NULL,
  `ca` smallint(6) DEFAULT NULL,
  `p` smallint(6) DEFAULT NULL,
  `mg` smallint(6) DEFAULT NULL,
  `protein` smallint(6) DEFAULT NULL,
  `uric_acid` smallint(6) DEFAULT NULL,
  `glycemia` smallint(6) DEFAULT NULL,
  `triglycerides` smallint(6) DEFAULT NULL,
  `cholesterol` smallint(6) DEFAULT NULL,
  `albumin` smallint(6) DEFAULT NULL,
  `total_bilirubin` smallint(6) DEFAULT NULL,
  `direct_bilirubin` smallint(6) DEFAULT NULL,
  `indirect_bilirubin` smallint(6) DEFAULT NULL,
  `ast` smallint(6) DEFAULT NULL,
  `alt` smallint(6) DEFAULT NULL,
  `alkaline_phosphatase` smallint(6) DEFAULT NULL,
  `amylase` smallint(6) DEFAULT NULL,
  `lipase` smallint(6) DEFAULT NULL,
  `a_fp` smallint(6) DEFAULT NULL,
  `cea` smallint(6) DEFAULT NULL,
  `ca_19_9` smallint(6) DEFAULT NULL,
  `chromogranine` smallint(6) DEFAULT NULL,
  `_5_HIAA` smallint(6) DEFAULT NULL,
  `ca_125` smallint(6) DEFAULT NULL,
  `ca_15_3` smallint(6) DEFAULT NULL,
  `b_hcg` smallint(6) DEFAULT NULL,
  `other_marker_1` smallint(6) DEFAULT NULL,
  `other_marker_2` smallint(6) DEFAULT NULL,
  `summary` text,
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobilary_lab_report_biology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE qc_hb_ed_hepatobilary_lab_report_biology_revs(
  `id` int(11) NOT NULL,
  `wbc` smallint(6) DEFAULT NULL,
  `rbc` smallint(6) DEFAULT NULL,
  `hb` smallint(6) DEFAULT NULL,
  `ht` smallint(6) DEFAULT NULL,
  `platelets` smallint(6) DEFAULT NULL,
  `ptt` smallint(6) DEFAULT NULL,
  `inr` smallint(6) DEFAULT NULL,
  `na` smallint(6) DEFAULT NULL,
  `k` smallint(6) DEFAULT NULL,
  `cl` smallint(6) DEFAULT NULL,
  `creatinine` smallint(6) DEFAULT NULL,
  `urea` smallint(6) DEFAULT NULL,
  `ca` smallint(6) DEFAULT NULL,
  `p` smallint(6) DEFAULT NULL,
  `mg` smallint(6) DEFAULT NULL,
  `protein` smallint(6) DEFAULT NULL,
  `uric_acid` smallint(6) DEFAULT NULL,
  `glycemia` smallint(6) DEFAULT NULL,
  `triglycerides` smallint(6) DEFAULT NULL,
  `cholesterol` smallint(6) DEFAULT NULL,
  `albumin` smallint(6) DEFAULT NULL,
  `total_bilirubin` smallint(6) DEFAULT NULL,
  `direct_bilirubin` smallint(6) DEFAULT NULL,
  `indirect_bilirubin` smallint(6) DEFAULT NULL,
  `ast` smallint(6) DEFAULT NULL,
  `alt` smallint(6) DEFAULT NULL,
  `alkaline_phosphatase` smallint(6) DEFAULT NULL,
  `amylase` smallint(6) DEFAULT NULL,
  `lipase` smallint(6) DEFAULT NULL,
  `a_fp` smallint(6) DEFAULT NULL,
  `cea` smallint(6) DEFAULT NULL,
  `ca_19_9` smallint(6) DEFAULT NULL,
  `chromogranine` smallint(6) DEFAULT NULL,
  `_5_HIAA` smallint(6) DEFAULT NULL,
  `ca_125` smallint(6) DEFAULT NULL,
  `ca_15_3` smallint(6) DEFAULT NULL,
  `b_hcg` smallint(6) DEFAULT NULL,
  `other_marker_1` smallint(6) DEFAULT NULL,
  `other_marker_2` smallint(6) DEFAULT NULL,
  `summary` text,
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`flag_active` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES (NULL , 'hepatobillary', 'lab', 'biology', '1', 'ed_hepatobiliary_lab_report_biology', 'qc_hb_ed_hepatobilary_lab_report_biology', '0');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('ed_hepatobiliary_lab_report_biology', '', '', '1', '1', '0', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'wbc', 'wbc', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'rbc', 'rbc', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'hb', 'hb', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ht', 'ht', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'platelets', 'platelets', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ptt', 'ptt', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'inr', 'inr', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'na', 'na', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'k', 'k', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cl', 'cl', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'creatinine', 'creatinine', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'urea', 'urea', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca', 'ca', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'p', 'p', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'mg', 'mg', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'uric_acid', 'uric acid', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'glycemia', 'glycemia', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'triglycerides', 'triglycerides', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cholesterol', 'cholesterol', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'protein', 'protein', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'albumin', 'albumin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'total_bilirubin', 'total bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'direct_bilirubin', 'direct bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'indirect_bilirubin', 'indirec _bilirubin', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ast', 'ast', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'alt', 'alt', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'alkaline_phosphatase', 'alkalin _phosphatase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'amylase', 'amylase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'lipase', 'lipase', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'a_fp', 'a fp', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'cea', 'cea', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_19_9', 'ca 19 9', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'chromogranine', 'chromogranine', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', '_5_HIAA', '5 HIAA', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_125', 'ca 125', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'ca_15_3', 'ca 15 3', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'b_hcg', 'b hcg', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_1', 'other marker 1', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_2', 'other marker 2', '', 'number', '', '', NULL, '', '', '', '');

SET @last_id = LAST_INSERT_ID();

SET @QC_HB_100001_structure_id = (SELECT id FROM structures WHERE alias = 'ed_hepatobiliary_lab_report_biology');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) (SELECT @QC_HB_100001_structure_id, `id`, IF(id - @last_id <= 19, '0', '1'), (id - @last_id + 3), '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00', '1' FROM structure_fields WHERE id >= @last_id);

UPDATE structure_formats SET language_heading='blood formulae' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'wbc'
);
UPDATE structure_formats SET language_heading='coagulation' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'ptt'
);
UPDATE structure_formats SET language_heading='electrolyte' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'na'
);
UPDATE structure_formats SET language_heading='other' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'uric_acid'
);
UPDATE structure_formats SET language_heading='bilan hepatique' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'albumin'
);
UPDATE structure_formats SET language_heading='bilan pancreatique' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'amylase'
);
UPDATE structure_formats SET language_heading='bilan marqueur' WHERE structure_id = @QC_HB_100001_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biology' 
	AND field = 'a_fp'
);

INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_summary
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 1, 100, 'summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- disease_site
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_100001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('hepatobillary', '', 'Hepatobillary', 'Hépato-Biliaire')
('blood formulae', '', 'Blood Formulae', 'Formule sanguine'),
('coagulation', '', 'Coagulation', 'Coagulation'),
('electrolyte', '', 'Electrolyte', 'Électrolyte'),
('bilan hepatique', '', 'Hepatic Check-Up', 'Bilan hépatique'),
('bilan pancreatique', '', 'Pancreatic Check-Up', 'Bilan pancréatique'),
('bilan marqueur', '', 'Marker Check-Up', 'Bilan marqueur'),

-- TODO A confirmer
('wbc', '', 'WBC', 'NGB'),
('rbc', '', 'RBC', 'NGR'),
('hb', '', 'Hb', 'Hb'),
('ht', '', 'Ht', 'Ht'),
('platelets', '', 'Platelets', 'Plaquettes'),

('ptt', '', 'PTT', 'TCA'),
('inr', '', 'INR', 'INR'),

('na', '', 'Na', 'Na'),
('k', '', 'K', 'K'),
('cl', '', 'Cl', 'Cl'),
('creatinine', '', 'Creatinine', 'Créatinine'),
('urea', '', 'Urea', 'Urée'),
('ca', '', 'Ca', 'Ca'),
('p', '', 'P', 'P'),
('mg', '', 'Mg', 'Mg'),

('uric acid', '', 'Uric Acid', 'Acide urique'),
('glycemia', '', 'Glycemia', 'Glycémie'),
('triglycerides', '', 'Triglycerides', 'Triglycéride'),
('cholesterol', '', 'Cholesterol', 'Cholestérol'),

('albumin', '', 'Albumin', 'Albumine'),
('total bilirubin', '', 'Total Bilirubin', 'Bilirubine totale'),
('direct bilirubin', '', 'Firect Bilirubin', 'Bilirubine directe'),
('indirec _bilirubin', '', 'Indirect Bilirubin', 'Bilirubine indirecte'),

('ast', '', 'AST', 'AST'),
('alt', '', 'ALT', 'ALT'),
('alkalin _phosphatase', '', 'Alkalin Phosphatase', 'Phosphatase alcaline'),

('amylase', '', 'Amylase', 'Amylase'),
('lipase', '', 'Lipase', 'Lipase'),

('a fp', '', '&#945;-FP', '&#945;-FP'),
('cea', '', 'CEA', 'CEA'),
('ca 19 9', '', 'Ca 19-9', 'Ca 19-9'),
('chromogranine', '', 'Chromogranine', ''),
('5 HIAA', '', '5 HIAA', '5 HIAA'),
('ca 125', '', 'Ca 125', 'Ca 125'),
('ca 15 3', '', 'Ca 15-3', 'Ca 15-3'),
('b hcg', '', '&#223; HCG', '&#223; HCG'),
('other marker 1', '', 'Other marker 1', 'Autre marqueur 1'),
('other marker 2', '', 'Other marker 2', 'Autre marqueur 2');

-- TODO End todo A confirmer

-- ... CLINIC: medical_past_history revision control ...................

CREATE TABLE IF NOT EXISTS `qc_hb_ed_medical_imaging_record_summary` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `abdominal_ultrasound` varchar(5) DEFAULT NULL,
  `abdominal_ct_scan` varchar(5) DEFAULT NULL,
  `pelvic_ct_scan` varchar(5) DEFAULT NULL,
  `abdominal_mri` varchar(5) DEFAULT NULL,
  `pelvic_mri` varchar(5) DEFAULT NULL,
  `chest_x_ray` varchar(5) DEFAULT NULL,
  `chest_ct_scan` varchar(5) DEFAULT NULL,
  `tep_scan` varchar(5) DEFAULT NULL,
  `octreoscan` varchar(5) DEFAULT NULL,
  `contrast_enhanced_ultrasound` varchar(5) DEFAULT NULL,
  `doppler_ultrasound` varchar(5) DEFAULT NULL,
  `endoscopic_ultrasound` varchar(5) DEFAULT NULL,
  `colonoscopy` varchar(5) DEFAULT NULL,
  `contrast_enema` varchar(5) DEFAULT NULL,
  `ercp` varchar(5) DEFAULT NULL,
  `transhepatic_cholangiography` varchar(5) DEFAULT NULL,
  `hida_scan` varchar(5) DEFAULT NULL,  
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_medical_imaging_record_summary`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
CREATE TABLE IF NOT EXISTS `qc_hb_ed_medical_imaging_record_summary_revs` (
  `id` int(11) unsigned NOT NULL,
  `abdominal_ultrasound` varchar(5) DEFAULT NULL,
  `abdominal_ct_scan` varchar(5) DEFAULT NULL,
  `pelvic_ct_scan` varchar(5) DEFAULT NULL,
  `abdominal_mri` varchar(5) DEFAULT NULL,
  `pelvic_mri` varchar(5) DEFAULT NULL,
  `chest_x_ray` varchar(5) DEFAULT NULL,
  `chest_ct_scan` varchar(5) DEFAULT NULL,
  `tep_scan` varchar(5) DEFAULT NULL,
  `octreoscan` varchar(5) DEFAULT NULL,
  `contrast_enhanced_ultrasound` varchar(5) DEFAULT NULL,
  `doppler_ultrasound` varchar(5) DEFAULT NULL,
  `endoscopic_ultrasound` varchar(5) DEFAULT NULL,
  `colonoscopy` varchar(5) DEFAULT NULL,
  `contrast_enema` varchar(5) DEFAULT NULL,
  `ercp` varchar(5) DEFAULT NULL,
  `transhepatic_cholangiography` varchar(5) DEFAULT NULL,
  `hida_scan` varchar(5) DEFAULT NULL,  
  `event_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`flag_active` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES 
(null, 'hepatobillary', 'clinical', 'medical imaging record summary', '1', 'qc_hb_ed_medical_imaging_record_summary', 'qc_hb_ed_medical_imaging_record_summary', '0');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('qc_hb_ed_medical_imaging_record_summary', '', '', '1', '1', '0', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, 
`language_label`, `language_tag`, 
`type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'abdominal_ultrasound', 'abdominal ultrasound', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'abdominal_ct_scan', 'abdominal CT-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'pelvic_ct_scan', 'pelvic CT-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'abdominal_mri', 'abdominal MRI', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'pelvic_mri', 'pelvic MRI', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'chest_x_ray', 'chest X-ray', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'chest_ct_scan', 'chest CT-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'tep_scan', 'TEP-scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'octreoscan', 'octreoscan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'contrast_enhanced_ultrasound', 'contrast-enhanced ultrasound (CEUS)', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'doppler_ultrasound', 'doppler ultrasound', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'endoscopic_ultrasound', 'endoscopic ultrasound (EUS)', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'colonoscopy', 'colonoscopy', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'contrast_enema', 'contrast enema', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'ercp', 'ERCP', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'transhepatic_cholangiography', 'transhepatic cholangiography', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_medical_imaging_record_summary', 'hida_scan', 'HIDA scan', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open');

SET @last_id = LAST_INSERT_ID();
SET @QC_HB_100041_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_medical_imaging_record_summary');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) (SELECT @QC_HB_100041_structure_id, `id`, '1', (id - @last_id + 3), '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '1', '0000-00-00 00:00:00', '1' FROM structure_fields WHERE id >= @last_id);

INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- event_summary
(null, @QC_HB_100041_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 100, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE structure_formats SET language_heading='reviewed events' WHERE structure_id = @QC_HB_100041_structure_id
AND structure_field_id = (
	SELECT id FROM structure_fields 
	WHERE plugin = 'Clinicalannotation' 
	AND model = 'EventDetail' 
	AND tablename = 'qc_hb_ed_medical_imaging_record_summary' 
	AND field = 'abdominal_ultrasound'
);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
-- TODO translation in french
('abdominal ultrasound', '', 'Abdominal Ultrasound', 'Ultrason abdominal'),
('abdominal CT-scan', '', 'Abdominal CT-Scan', 'CT-scan abdominal'),
('pelvic CT-scan', '', 'Pelvic CT-Scan', 'CT-scan pelvien'),
('abdominal MRI', '', 'Abdominal MRI', 'IRM abdominal'),
('pelvic MRI', '', 'Pelvic MRI', 'IRM pelvien'),
('chest X-ray', '', 'Chest X-Ray', 'Radiographie de la poitrine'),
('chest CT-scan', '', 'Chest CT-Scan', 'CT-scan de la poitrine'),
('TEP-scan', '', 'TEP-Scan', 'TEP-Scan'),
('octreoscan', '', 'Octreoscan', 'Scintigraphie à l''Octreoscan'),
('contrast-enhanced ultrasound (CEUS)', '', 'Contrast-Enhanced Ultrasound (CEUS)', 'Échographie de contraste (CEUS)'),
('doppler ultrasound', '', 'Doppler Ultrasound', ''),
('endoscopic ultrasound (EUS)', '', 'Endoscopic Ultrasound (EUS)', ''),
('colonoscopy', '', 'Colonoscopy', 'Colonoscopie'),
('contrast enema', '', 'Contrast Enema', 'Lavement baryté'),
('ERCP', '', 'ERCP', 'ERCP'),
('transhepatic cholangiography', '', 'Transhepatic Cholangiography', 'Cholangiographie transhépatique'),
('HIDA scan', '', 'HIDA-Scan', 'HIDA-scan'),
('mmedical imaging record summary', '', 'Imaging Review Summary', 'Résumé des révisions médicales');

-- ... CLINIC: medical imaging ...................

-- Add structure to set event date and summary
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_dateNSummary', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), '0', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Add event_controls
INSERT INTO `event_controls` (`id` ,`disease_site` ,`event_group` ,`event_type` ,`flag_active` ,`form_alias` ,`detail_tablename` ,`display_order`) VALUES 
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal ultrasound', '1', 'qc_hb_imaging_segment_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal CT-scan', '1', 'qc_hb_imaging_segment_other_pancreas_volumetry', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging pelvic CT-scan', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging abdominal MRI', '1', 'qc_hb_imaging_segment_other_pancreas_volumetry', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging pelvic MRI', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging chest X-ray', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging chest CT-scan', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging TEP-scan', '1', 'qc_hb_imaging_segment_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging octreoscan', '1', 'qc_hb_imaging_segment_other_pancreas', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging contrast-enhanced ultrasound', '1', 'qc_hb_imaging_segment', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging doppler ultrasound', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging endoscopic ultrasound', '1', 'qc_hb_imaging_other_pancreas', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging colonoscopy', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging contrast enema', '1', 'qc_hb_imaging_other', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging ERCP', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging transhepatic cholangiography', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_medical_imagings', '0'),
(NULL , 'hepatobillary', 'clinical', 'medical imaging HIDA scan', '1', 'qc_hb_imaging', 'qc_hb_ed_hepatobilary_exams', '0');

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobilary_medical_imagings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
  
  `segment_1_number` smallint(5) unsigned DEFAULT NULL,
  `segment_1_size` smallint(5) unsigned DEFAULT NULL,
  `segment_2_number` smallint(5) unsigned DEFAULT NULL,
  `segment_2_size` smallint(5) unsigned DEFAULT NULL,
  `segment_3_number` smallint(5) unsigned DEFAULT NULL,
  `segment_3_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_size` smallint(5) unsigned DEFAULT NULL,
  `segment_5_number` smallint(5) unsigned DEFAULT NULL,
  `segment_5_size` smallint(5) unsigned DEFAULT NULL,
  `segment_6_number` smallint(5) unsigned DEFAULT NULL,
  `segment_6_size` smallint(5) unsigned DEFAULT NULL,
  `segment_7_number` smallint(5) unsigned DEFAULT NULL,
  `segment_7_size` smallint(5) unsigned DEFAULT NULL,
  `segment_8_number` smallint(5) unsigned DEFAULT NULL,
  `segment_8_size` smallint(5) unsigned DEFAULT NULL,

  `lungs_number` smallint(5) unsigned DEFAULT NULL,
  `lungs_size` smallint(5) unsigned DEFAULT NULL,
  `lungs_laterality` varchar(20) DEFAULT NULL,
  `lymph_node_number` smallint(5) unsigned DEFAULT NULL,
  `lymph_node_size` smallint(5) unsigned DEFAULT NULL,
  `colon_number` smallint(5) unsigned DEFAULT NULL,
  `colon_size` smallint(5) unsigned DEFAULT NULL,
  `rectum_number` smallint(5) unsigned DEFAULT NULL,
  `rectum_size` smallint(5) unsigned DEFAULT NULL,
  `bones_number` smallint(5) unsigned DEFAULT NULL,
  `bones_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1` varchar(50) DEFAULT NULL,
  `other_localisation_1_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2` varchar(50) DEFAULT NULL,
  `other_localisation_2_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3` varchar(50) DEFAULT NULL,
  `other_localisation_3_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3_size` smallint(5) unsigned DEFAULT NULL,
   
  `hepatic_artery` varchar(10) DEFAULT NULL,
  `coeliac_trunk` varchar(10) DEFAULT NULL,
  `splenic_artery` varchar(10) DEFAULT NULL,
  `superior_mesenteric_artery` varchar(10) DEFAULT NULL,
  `portal_vein` varchar(10) DEFAULT NULL,
  `superior_mesenteric_vein` varchar(10) DEFAULT NULL,
  `splenic_vein` varchar(10) DEFAULT NULL,
  `metastatic_lymph_nodes` varchar(10) DEFAULT NULL,

  `is_volumetry_post_pve` varchar(10) DEFAULT NULL,
  `total_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `resected_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `tumoral_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_percentage` float DEFAULT NULL,

  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobilary_medical_imagings`
  ADD CONSTRAINT `qc_hb_ed_hepatobilary_medical_imagings_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE qc_hb_ed_hepatobilary_medical_imagings_revs(
  `id` int(11) unsigned NOT NULL,
  `event_master_id` int(11) NOT NULL,

  `segment_1_number` smallint(5) unsigned DEFAULT NULL,
  `segment_1_size` smallint(5) unsigned DEFAULT NULL,
  `segment_2_number` smallint(5) unsigned DEFAULT NULL,
  `segment_2_size` smallint(5) unsigned DEFAULT NULL,
  `segment_3_number` smallint(5) unsigned DEFAULT NULL,
  `segment_3_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4a_size` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_number` smallint(5) unsigned DEFAULT NULL,
  `segment_4b_size` smallint(5) unsigned DEFAULT NULL,
  `segment_5_number` smallint(5) unsigned DEFAULT NULL,
  `segment_5_size` smallint(5) unsigned DEFAULT NULL,
  `segment_6_number` smallint(5) unsigned DEFAULT NULL,
  `segment_6_size` smallint(5) unsigned DEFAULT NULL,
  `segment_7_number` smallint(5) unsigned DEFAULT NULL,
  `segment_7_size` smallint(5) unsigned DEFAULT NULL,
  `segment_8_number` smallint(5) unsigned DEFAULT NULL,
  `segment_8_size` smallint(5) unsigned DEFAULT NULL,

  `lungs_number` smallint(5) unsigned DEFAULT NULL,
  `lungs_size` smallint(5) unsigned DEFAULT NULL,
  `lungs_laterality` varchar(20) DEFAULT NULL,
  `lymph_node_number` smallint(5) unsigned DEFAULT NULL,
  `lymph_node_size` smallint(5) unsigned DEFAULT NULL,
  `colon_number` smallint(5) unsigned DEFAULT NULL,
  `colon_size` smallint(5) unsigned DEFAULT NULL,
  `rectum_number` smallint(5) unsigned DEFAULT NULL,
  `rectum_size` smallint(5) unsigned DEFAULT NULL,
  `bones_number` smallint(5) unsigned DEFAULT NULL,
  `bones_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1` varchar(50) DEFAULT NULL,
  `other_localisation_1_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_1_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2` varchar(50) DEFAULT NULL,
  `other_localisation_2_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_2_size` smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3` varchar(50) DEFAULT NULL,
  `other_localisation_3_number`  smallint(5) unsigned DEFAULT NULL,
  `other_localisation_3_size` smallint(5) unsigned DEFAULT NULL,
   
  `hepatic_artery` varchar(10) DEFAULT NULL,
  `coeliac_trunk` varchar(10) DEFAULT NULL,
  `splenic_artery` varchar(10) DEFAULT NULL,
  `superior_mesenteric_artery` varchar(10) DEFAULT NULL,
  `portal_vein` varchar(10) DEFAULT NULL,
  `superior_mesenteric_vein` varchar(10) DEFAULT NULL,
  `splenic_vein` varchar(10) DEFAULT NULL,
  `metastatic_lymph_nodes` varchar(10) DEFAULT NULL,

  `is_volumetry_post_pve` varchar(10) DEFAULT NULL,
  `total_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `resected_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_volume` smallint(5) unsigned DEFAULT NULL,
  `tumoral_volume` smallint(5) unsigned DEFAULT NULL,
  `remnant_liver_percentage` float DEFAULT NULL,

  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 	qc_hb_segment
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_segment', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_1_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_1_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_2_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_2_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_3_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_3_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4a_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4a_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4b_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4b_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_5_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_5_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_6_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_6_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_7_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_7_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_8_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_8_size', 'size', '', 'number', '', '', NULL, '', '', '', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_1_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '0', 'segment I', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_1_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_2_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', 'segment II', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_2_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_3_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '4', 'segment III', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_3_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4a_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '6', 'segment IVa', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4a_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4b_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '8', 'segment IVb', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_4b_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '9', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_5_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '10', 'segment V', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_5_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '11', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_6_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '12', 'segment VI', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_6_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '13', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_7_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '14', 'segment VII', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_7_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '15', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_8_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '16', 'segment VIII', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'segment_8_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '17', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('liver segments', '', 'Segments', 'Segments'),
('segment I', '', 'Segment I', 'Segment I'),
('segment II', '', 'Segment II', 'Segment II'),
('segment III', '', 'Segment III', 'Segment III'),
('segment IVa', '', 'Segment IVa', 'Segment IVa'),
('segment IVb', '', 'Segment IVb', 'Segment IVb'),
('segment V', '', 'Segment V', 'Segment V'),
('segment VI', '', 'Segment VI', 'Segment VI'),
('segment VII', '', 'Segment VII', 'Segment VII'),
('segment VIII', '', 'Segment VIII', 'Segment VIII'),

('size', '', 'Size', 'Taille');

-- 	qc_hb_other_localisations
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_other_localisations', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lungs_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lungs_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lungs_laterality', 'laterality', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='laterality'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lymph_node_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'lymph_node_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'colon_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'colon_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'rectum_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'rectum_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'bones_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'bones_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),

('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_1', 'other localisation precision', '', 'input', 'size=30', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_1_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_1_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),

('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_2', 'other localisation precision', '', 'input', 'size=30', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_2_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_2_size', 'size', '', 'number', '', '', NULL, '', '', '', ''),

('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_3', 'other localisation precision', '', 'input', 'size=30', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_3_number', 'number', '', 'number', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'other_localisation_3_size', 'size', '', 'number', '', '', NULL, '', '', '', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lungs_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', 'lungs', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lungs_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lungs_laterality' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lymph_node_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '4', 'lymph node', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'lymph_node_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'colon_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '6', 'colon', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'colon_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'rectum_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '8', 'rectum', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'rectum_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '9', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'bones_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '10', 'bones', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'bones_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '11', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_1' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '12', 'other localisation 1', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_1_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '13', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_1_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '14', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_2' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '15', 'other localisation 2', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_2_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '16', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_2_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '17', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),

(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_3' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '18', 'other localisation 3', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_3_number' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '19', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'other_localisation_3_size' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '20', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('other localisations', '', 'Other Localisations', 'Autre Localisations'),
('lungs', '', 'Lungs', 'Poumons'),
('bones', '', 'Bones', 'Os'),
('lymph node', '', 'Lymph Nodes', 'Ganglions lymphatique'),
('colon', '', 'Colon', 'Colon'),
('rectum', '', 'Rectum', 'Rectum'),
('other localisation 1', '', 'Other (1)', 'Autre (1)'),
('other localisation 2', '', 'Other (2)', 'Autre (2)'),
('other localisation 3', '', 'Other (3)', 'Autre (3)'),
('other localisation precision', '', 'Precision', 'Précision');

-- 	qc_hb_pancreas
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES 
('qc_hb_pancreas', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('yes_no_suspicion', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('yes', 'yes');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='yes' AND language_alias='yes'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('no', 'no');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='no' AND language_alias='no'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('suspicion', 'suspicion');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'),  (SELECT id FROM structure_permissible_values WHERE value='suspicion' AND language_alias='suspicion'), '3', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'hepatic_artery', 'hepatic artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'coeliac_trunk', 'coeliac trunk', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'splenic_artery', 'splenic artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'superior_mesenteric_artery', 'superior mesenteric artery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'portal_vein', 'portal vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'superior_mesenteric_vein', 'superior mesenteric vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'splenic_vein', 'splenic vein', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'metastatic_lymph_nodes', 'metastatic lymph nodes', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_suspicion'), '', '', '', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'hepatic_artery' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'coeliac_trunk' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'splenic_artery' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'superior_mesenteric_artery' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'portal_vein' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '4', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'superior_mesenteric_vein' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'splenic_vein' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '6', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'metastatic_lymph_nodes' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '7', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('pancreas', '', 'Pancreas', 'Pancréas'),
('hepatic artery', '', 'Hepatic Artery', 'Artère hépatique'),
('coeliac trunk', '', 'Coeliac Trunk', 'Tronc coeliaque'),
('splenic artery', '', 'Splenic artery', 'Artère splénique'),
('superior mesenteric artery', '', 'superior esenteric artery', 'Artère mésentérique superieur'),
('portal vein', '', 'Portal Vein', 'Veine porte'),
('superior mesenteric vein', '', 'superior mesenteric vein', 'Veine mésentérique superieur'),
('splenic vein', '', 'Splenic vein', 'Veine splénique'),
('metastatic lymph nodes', '', 'Metastatic Lymph Modes', 'Ganglions Lymphatiques Métastatiques'),
('suspicion', '', 'Suspicion', 'Soupçon');

-- qc_hb_volumetry
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('qc_hb_volumetry', '', '', '1', '1', '0', '1');
SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_hb_yes_no_unknwon', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('yes', 'yes');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'),  (SELECT id FROM structure_permissible_values WHERE value='yes' AND language_alias='yes'), '1', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('no', 'no');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'),  (SELECT id FROM structure_permissible_values WHERE value='no' AND language_alias='no'), '2', '1');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('unknwon', 'unknwon');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'),  (SELECT id FROM structure_permissible_values WHERE value='unknown' AND language_alias='unknown'), '3', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'is_volumetry_post_pve', 'post pve', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon'), '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'total_liver_volume', 'total liver volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'resected_liver_volume', 'resected liver volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'remnant_liver_volume', 'remnant liver volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'tumoral_volume', 'tumoral volume', '', 'number', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'remnant_liver_percentage', 'remnant liver percentage', '', 'number', '', '', NULL, '', 'open', 'open', 'open'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'is_volumetry_post_pve' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '1', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'total_liver_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '2', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'resected_liver_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '3', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'remnant_liver_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '4', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'tumoral_volume' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '5', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'),
(@last_structure_id, (SELECT id FROM structure_fields WHERE field = 'remnant_liver_percentage' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '0', '6', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('volumetry', '', 'Volumetry', 'Volumétrie'),
('post pve', '', 'Post PVE (Portal Vein Embolization)', 'Post PVE (Embolisation portale)'),
('remnant liver percentage', '', 'Remnant liver percentage', 'Pourcentage du foie restant'),
('remnant liver volume', '', 'Remnant Liver Volume', 'Volume du foie restant'),
('total liver volume', '', 'Total Liver Volume', 'Volume du foie total'),
('resected liver volume', '', 'Resected Liver Volume', 'Volume du foie réséqué'),
('tumoral volume', '', 'Tumoral Volume', 'Volume tumoral');





-- TODO should all field be smallint????? In case we keep smallinf, add validation.

