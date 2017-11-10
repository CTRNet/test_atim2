-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6890' WHERE version_number = '2.7.0';

-- -------------------------------------------------------------------------------------
-- Searching the RAMQ errors  2017-10-16
-- -------------------------------------------------------------------------------------

INSERT INTO datamart_reports(
	`name`, 
	`description`, 
	`form_alias_for_search`, 
	`form_alias_for_results`, 
	`form_type_for_results`, 
	`function`, 
	`flag_active`, 
	`associated_datamart_structure_id`, 
	`limit_access_from_datamart_structrue_function`
	)
VALUES
	('Report the RAMQ problems',
	'Make a report by checking RAMQ',
	'qc_nd_ramq_search',
	'qc_nd_ramq_reports',
	'index',
	'participantIdentifiersRamqError',
	'1',
	(SELECT id FROM datamart_structures WHERE model = 'Participant'),
	0);


INSERT INTO structures(`alias`) VALUES ('qc_nd_ramq_search');

INSERT INTO structure_formats
	(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_search'), 
	(SELECT id FROM structure_fields WHERE `model`='Group' AND `tablename`='groups' AND `field`='bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), 
	'1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_ramq_reports');

INSERT INTO structure_fields
	(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
	('Datamart', '0', 'Paricipants', 'qc_nd_notes', 'input',  NULL , '0', 'size=30', '', '', 'notes', ''), 
	('Datamart', '0', '', 'qc_nd_ramq_generated', 'input',  NULL , '1', 'size=30', '', '', 'RAMQ generated', ''),
	('Datamart', '0', '', 'qc_nd_ramq', 'input',  NULL , '1', 'size=30', '', '', 'RAMQ', '');

INSERT INTO structure_formats
	(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '1', '1', '', '0', '1', 'first name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex')  AND `flag_confidential`='0'), '1', '7', '', '0', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '1', '3', '', '0', '1', 'last name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='help_date of birth' AND `language_label`='date of birth' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='Paricipants' AND `field`='qc_nd_notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_nd_ramq_generated' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='RAMQ generated' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
	((SELECT id FROM structures WHERE alias='qc_nd_ramq_reports'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_nd_ramq' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='RAMQ' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES 	
	('Approximate date of birth', 'Approximate date of birth', 'Date de naissance approximative'),
	('RAMQ', 'RAMQ', 'RAMQ'),
	('RAMQ generated', 'Generated RAMQ', 'RAMQ générée'),
	('Problem in ramq', 'Problem in ramq', 'problème de ramq'),
	('Unknown date of birth', 'Unknown date of birth', 'Date de naissance inconnue'),
	('Undefined Sex', 'Undefined Sex', 'Sex non défini'),
	('Firstname missing', 'Firstname missing', 'Prénom manquant'),
	('Lastname missing', 'Lastname missing', 'Nom de famille manquant'),
	('Report the RAMQ problems', 'Report the RAMQ problems', 'Signalez les problèmes de la RAMQ'),
	('Make a report by checking RAMQ', 'Make a report by checking RAMQ', 'Faire un rapport en vérifiant la RAMQ');


-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6894' WHERE version_number = '2.7.0';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 2017-11-02
-- -----------------------------------------------------------------------------------------------------------------------------------

-- colorectal bank

INSERT INTO key_increments (key_name ,key_value) VALUES ('colorectal bank no lab', '700000');
INSERT INTO misc_identifier_controls (misc_identifier_name , flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential, flag_unique, pad_to_length, reg_exp_validation, user_readable_format, flag_link_to_study)
VALUES
('colorectal bank no lab','1','1','colorectal bank no lab','%%key_increment%%','1','0','1','0','','','0');
INSERT INTO i18n (id,en,fr)
VALUES 
('colorectal no lab', "'No Labo' of Colorectal Bank","'No Labo' de la banque Colorectal"),
('colorectal bank no lab', "'No Labo' of Colorectal Bank","'No Labo' de la banque Colorectal");

-- pulmonary bank

INSERT INTO key_increments (key_name ,key_value) VALUES ('pulmonary bank no lab', '600000');
INSERT INTO misc_identifier_controls (misc_identifier_name , flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential, flag_unique, pad_to_length, reg_exp_validation, user_readable_format, flag_link_to_study)
VALUES
('pulmonary bank no lab','1','1','pulmonary bank no lab','%%key_increment%%','1','0','1','0','','','0');
INSERT INTO i18n (id,en,fr)
VALUES 
('pulmonary no lab', "'No Labo' of Pulmonary Bank","'No Labo' de la banque Pulmonaire"),
('pulmonary bank no lab', "'No Labo' of Pulmonary Bank","'No Labo' de la banque Pulmonaire");

-- Identifiers Report

UPDATE structure_formats SET `flag_override_tag`='1', `language_tag`='other' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='old_bank_no_lab' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='code_barre' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'old_breast_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', '', 'breast');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='old_breast_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='breast'), '0', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'old_ovary_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', '', 'ovary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='old_ovary_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ovary'), '0', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'colorectal_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', 'colorectal bank no lab', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='colorectal_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='colorectal bank no lab' AND `language_tag`=''), '0', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_fields SET sortable = 1 WHERE id IN (SELECT structure_field_id FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='report_participant_identifiers_result'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'pulmonary_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', 'pulmonary bank no lab', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='pulmonary_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='pulmonary bank no lab' AND `language_tag`=''), '0', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- New consent

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'chum - colorectal', 1, 'qc_nd_cd_chum_colorectals', 'qc_nd_cd_chum_colorectals', 0, 'chum - colorectal'),
(null, 'chum - pulmonary', 1, 'qc_nd_cd_chum_pulmonarys', 'qc_nd_cd_chum_pulmonarys', 0, 'chum - pulmonary');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('chum - colorectal', 'CHUM -  Colorectal', 'CHUM - Colorectal'),
('chum - pulmonary', 'CHUM -  Pulmonary', 'CHUM - Pulmonaire');

CREATE TABLE IF NOT EXISTS `qc_nd_cd_chum_pulmonarys` (
  `consent_master_id` int(11) NOT NULL,
  tissue_from_clinical_act char(1) NOT NULL DEFAULT '',
  tissue_for_banking_only char(1) NOT NULL DEFAULT '',
  blood char(1) NOT NULL DEFAULT '',
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_cd_chum_pulmonarys_revs` (
  `consent_master_id` int(11) NOT NULL,
  tissue_from_clinical_act char(1) NOT NULL DEFAULT '',
  tissue_for_banking_only char(1) NOT NULL DEFAULT '',
  blood char(1) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;
ALTER TABLE `qc_nd_cd_chum_pulmonarys`
  ADD CONSTRAINT `qc_nd_cd_chum_pulmonarys_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_chum_pulmonarys');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_pulmonarys', 'blood', 'yes_no',  NULL , '0', '', '', '', 'blood', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_pulmonarys', 'tissue_from_clinical_act', 'yes_no',  NULL , '0', '', '', '', 'tissue', 'from clinical act'), 
('ClinicalAnnotation', 'ConsentDetail', '', 'tissue_for_banking_only', 'yes_no',  NULL , '0', '', '', '', '', 'for banking only');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='blood' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blood' AND `language_tag`=''), '2', '1', 'agreements', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='tissue_from_clinical_act' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue' AND `language_tag`='from clinical act'), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='' AND `field`='tissue_for_banking_only' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='for banking only'), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_detail`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('from clinical act', 'From Clinical Act', 'D''un acte clinique'),
('for banking only', 'For Banking Only', 'Pour la banque seulement');
  
INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_chum_colorectals');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_colorectals', 'medical_data_access', 'yes_no',  NULL , '0', '', '', '', 'allow medical data access', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_colorectals', 'blood_collection', 'yes_no',  NULL , '0', '', '', '', 'allow blood collection', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_colorectals', 'biological_material_collection', 'yes_no',  NULL , '0', '', '', '', 'allow biological material collection', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_colorectals', 'contact_for_additional_info', 'yes_no',  NULL , '0', '', '', '', 'allow to be contacted for additional information', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_colorectals'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_colorectals' AND `field`='medical_data_access' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow medical data access' AND `language_tag`=''), '0', '10', 'hepato-bilary and pancreatic tumor', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_colorectals'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_colorectals' AND `field`='blood_collection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow blood collection' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_colorectals'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_colorectals' AND `field`='biological_material_collection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow biological material collection' AND `language_tag`=''), '0', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_colorectals'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_colorectals' AND `field`='contact_for_additional_info' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow to be contacted for additional information' AND `language_tag`=''), '0', '20', 'contact data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_chum_colorectals');
CREATE TABLE IF NOT EXISTS `qc_nd_cd_chum_colorectals` (
  `consent_master_id` int(11) NOT NULL,
  medical_data_access char(1) NOT NULL DEFAULT '',
  biological_material_collection char(1) NOT NULL DEFAULT '',
  blood_collection char(1) NOT NULL DEFAULT '',
  contact_for_additional_info char(1) NOT NULL DEFAULT '',
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_cd_chum_colorectals_revs` (
  `consent_master_id` int(11) NOT NULL,
  medical_data_access char(1) NOT NULL DEFAULT '',
  biological_material_collection char(1) NOT NULL DEFAULT '',
  blood_collection char(1) NOT NULL DEFAULT '',
  contact_for_additional_info char(1) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;
ALTER TABLE `qc_nd_cd_chum_colorectals`
  ADD CONSTRAINT `qc_nd_cd_chum_colorectals_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('allow biological material collection', "Allow Biological Material Collection","Autorise la collecte du matériel biologique"),
('allow blood collection', "Allow Blood Collection","Autorise la collecte de sang"),
('allow medical data access', "Allow Medical Data Access","Autorise l'accès au dossier médical"),
('allow to be contacted for additional information', "Allow To Be Contacted For Additional Information","Peut être contacté pour des renseignements supplémentaires"),
('contact data', "Contact data","Données du contact"),
('hepato-bilary and pancreatic tumor', "Hepato-Bilary And Pancreatic Tumor","Tumeur hépato-biliaire et pancréatique");
  
-- Add email to contact

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'qc_nd_email', 'input',  NULL , '1', 'size=15', '', '', 'email', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='qc_nd_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='email' AND `language_tag`=''), '2', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE participant_contacts ADD COLUMN qc_nd_email VARCHAR(100) DEFAULT NULL;
ALTER TABLE participant_contacts_revs ADD COLUMN qc_nd_email VARCHAR(100) DEFAULT NULL;

REPLACE INTO i18n (id,en,fr)
VALUES
('frsq - gyneco', 'FRSQ - Gyneco/Ovary/Breast', 'FRSQ - Gyneco/Ovaire/Sein');

UPDATE versions SET branch_build_number = '6909' WHERE version_number = '2.7.0';

-- Lung Consent

UPDATE structure_fields SET  `language_label`='tissue' WHERE model='ConsentDetail' AND tablename='' AND field='tissue_for_banking_only' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='3', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='blood' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1', `language_heading`='agreements' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='tissue_from_clinical_act' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='' AND `field`='tissue_for_banking_only' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


UPDATE structure_fields SET  `language_label`='tissue from clinical act',  `language_tag`='' WHERE model='ConsentDetail' AND tablename='qc_nd_cd_chum_pulmonarys' AND field='tissue_from_clinical_act' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='tissue for banking only',  `language_tag`='' WHERE model='ConsentDetail' AND tablename='' AND field='tissue_for_banking_only' AND `type`='yes_no' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('tissue from clinical act', 'Tissue - From Clinical Act', 'Tissu - D''un acte clinique'),
('tissue for banking only', 'Tissue - For Banking Only', 'Tissu - Pour la banque seulement');
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_pulmonarys', 'contact_for_other_research', 'yes_no',  NULL , '0', '', '', '', 'communicate to participate in other research', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='contact_for_other_research' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='communicate to participate in other research' AND `language_tag`=''), '2', '10', 'contact', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `tablename`='qc_nd_cd_chum_pulmonarys' WHERE model='ConsentDetail' AND tablename='' AND field='tissue_for_banking_only' AND `type`='yes_no' AND structure_value_domain  IS NULL ;

ALTER TABLE `qc_nd_cd_chum_pulmonarys` ADD COLUMN contact_for_other_research char(1) NOT NULL DEFAULT '';
ALTER TABLE `qc_nd_cd_chum_pulmonarys_revs` ADD COLUMN contact_for_other_research char(1) NOT NULL DEFAULT '';
 
UPDATE versions SET branch_build_number = '6913' WHERE version_number = '2.7.0';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 2017-11-10
-- -----------------------------------------------------------------------------------------------------------------------------------

-- create til

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'tumor infiltrating lymphocyte', 'derivative', 'sd_der_tils,sd_undetailed_derivatives,derivatives', 'sd_der_tils', 0, 'tumor infiltrating lymphocyte');
CREATE TABLE IF NOT EXISTS `sd_der_tils` (
  `sample_master_id` int(11) NOT NULL,
  `generation_method` varchar(250) NULL,
  `additive` varchar(250) NULL,
  KEY `FK_sd_der_tils_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `sd_der_tils_revs` (
  `sample_master_id` int(11) NOT NULL,
  `generation_method` varchar(250) NULL,
  `additive` varchar(250) NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `sd_der_tils`
  ADD CONSTRAINT `FK_sd_der_tils_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('til_generation_methods', "StructurePermissibleValuesCustom::getCustomDropdown('TIL Generation Methods')"),
('til_generation_additives', "StructurePermissibleValuesCustom::getCustomDropdown('TIL Generation Additives')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('TIL Generation Methods', 0, 250, 'inventory'),
('TIL Generation Additives', 0, 250, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TIL Generation Methods');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("cell culture", "Cell Culture", "Culture cellulaire", '1', @control_id, NOW(), NOW(), 1, 1), 
("digestion", "Digestion", "Digestion", '1', @control_id, NOW(), NOW(), 1, 1), 
("digestion & cell culture", "Digestion & Cell Culture", "Digestion & Culture cellulaire", '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TIL Generation Additives');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("IL-2", "IL-2", "IL-2", '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structures(`alias`) VALUES ('sd_der_tils');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_tils', 'generation_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='til_generation_methods') , '0', '', '', '', 'generation method', ''), 
('InventoryManagement', 'SampleDetail', 'sd_der_tils', 'additive', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='til_generation_additives') , '0', '', '', '', 'additive', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_tils'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_tils' AND `field`='generation_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='til_generation_methods')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='generation method' AND `language_tag`=''), '1', '445', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_tils'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_tils' AND `field`='additive' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='til_generation_additives')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additive' AND `language_tag`=''), '1', '446', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('tumor infiltrating lymphocyte', 'TIL (Tumor Infiltrating Lymphocyte)', 'TIL (lymphocyte infiltrant les tumeurs)'),
('generation method', 'Generation Method', 'Méthode de génération'),
('additive', 'Additive', 'Additif');
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), 0, NULL);
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'cell culture'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate'), 0, NULL);
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), 'tube', '', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml specific for cells', 0, 'tumor infiltrating lymphocyte|tube');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(null, (SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'tumor infiltrating lymphocyte'), 
(SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'tumor infiltrating lymphocyte'), 0, NULL);

UPDATE structure_permissible_values_custom_controls SET flag_active = 1 WHERE name LIKE 'TIL Generation %';
UPDATE `parent_to_derivative_sample_controls` 
SET flag_active = '1'
WHERE parent_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('tissue')) 
AND derivative_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('tumor infiltrating lymphocyte'));
UPDATE `parent_to_derivative_sample_controls` 
SET flag_active = '1'
WHERE parent_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('tumor infiltrating lymphocyte')) 
AND derivative_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('rna', 'dna', 'cell culture'));
UPDATE aliquot_controls SET flag_active = 1 WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('tumor infiltrating lymphocyte'));
UPDATE realiquoting_controls SET flag_active = 1 
WHERE parent_aliquot_control_id IN (SELECT id FROM aliquot_controls WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('tumor infiltrating lymphocyte')));

UPDATE sample_controls SET qc_nd_sample_type_code = 'TIL' WHERE sample_type = 'tumor infiltrating lymphocyte';

UPDATE structure_fields SET  `language_label`='additive' WHERE model='SampleDetail' AND tablename='sd_der_cell_cultures' AND field='tmp_hormon' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_culture_hormone');

UPDATE versions SET branch_build_number = '6920' WHERE version_number = '2.7.0';