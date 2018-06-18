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

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 20180126
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- SARDO data migration
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS qc_nd_sardo_drop_down_list_properties;
DROP TABLE IF EXISTS qc_nd_sardo_drop_down_lists;

UPDATE structure_fields 
SET type = 'input', setting = 'size=10', structure_value_domain = null 
WHERE structure_value_domain IN (
	SELECT id FROM structure_value_domains WHERE source LIKE '%ClinicalAnnotation.Participant::getSardoValues%'
);
DELETE FROM structure_value_domains WHERE source LIKE '%ClinicalAnnotation.Participant::getSardoValues%';

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field LIKE '%sardo%_key_words');
DELETE FROM structure_fields WHERE field LIKE '%sardo%_key_words';

DROP TABLE IF EXISTS `cd_icm_sardo_data_import_tries`;
CREATE TABLE `cd_icm_sardo_data_import_tries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime_try` datetime DEFAULT NULL,
  `global_result` varchar(15) DEFAULT NULL,
  `sardo_data_load_result` varchar(15) DEFAULT NULL,
  `atim_data_management_result` varchar(15) DEFAULT NULL,
  `details` varchar(1000) DEFAULT NULL,
  `sardo_participant_counter` int(7) DEFAULT NULL,
  `update_participant_counter` int(7) DEFAULT NULL,
  `last_sardo_treatment_event_dx_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- qc_nd_sardo_migrations_summary
 
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_last_sardo_update' AND `language_label`='last update' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_update_completed' AND `language_label`='completed' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_updated_participants_nbr' AND `language_label`='number of updated participants' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_update_error' AND `language_label`='error' AND `language_tag`='' AND `type`='textarea' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_last_sardo_update' AND `language_label`='last update' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0') OR (
`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_update_completed' AND `language_label`='completed' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0') OR (
`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_updated_participants_nbr' AND `language_label`='number of updated participants' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0'));
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_update_error' AND `language_label`='error' AND `language_tag`='' AND `type`='textarea' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_last_sardo_update' AND `language_label`='last update' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0') OR (
`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_update_completed' AND `language_label`='completed' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0') OR (
`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_updated_participants_nbr' AND `language_label`='number of updated participants' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='qc_nd_sardo_update_error' AND `language_label`='error' AND `language_tag`='' AND `type`='textarea' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'datetime_try', 'datetime',  NULL , '0', '', '', '', 'date', ''), 
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'global_result', 'input',  NULL , '0', '', '', '', 'global', ''), 
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'sardo_data_load_result', 'input',  NULL , '0', '', '', '', 'sardo XML file reading', ''), 
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'atim_data_management_result', 'input',  NULL , '0', '', '', '', 'merging data into atim', ''), 
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'details', 'textarea',  NULL , '0', '', '', '', 'details', ''), 
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'sardo_participant_counter', 'input',  NULL , '0', '', '', '', 'sardo participants number', ''), 
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'update_participant_counter', 'input',  NULL , '0', '', '', '', 'atim participants number updated', ''), 
('Administrate', 'Generated', 'cd_icm_sardo_data_import_tries', 'last_sardo_treatment_event_dx_date', 'date',  NULL , '0', '', '', '', 'last sardo clinical data imported', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='datetime_try' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='global_result' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='global' AND `language_tag`=''), '1', '2', 'results', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='sardo_data_load_result' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sardo XML file reading' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='atim_data_management_result' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='merging data into atim' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='details' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='sardo_participant_counter' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sardo participants number' AND `language_tag`=''), '1', '6', 'data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='update_participant_counter' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='atim participants number updated' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_sardo_migrations_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='cd_icm_sardo_data_import_tries' AND `field`='last_sardo_treatment_event_dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last sardo clinical data imported' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `model`='SardoDataImportTry' WHERE model='Generated' AND tablename='cd_icm_sardo_data_import_tries';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('tries', 'Tries', 'Essais'),
('global', "Global", "Global"),
('sardo XML file reading', "SARDO File Reading", "Lecture du fichier SARDO"),
('merging data into atim', "Data Merging", "Fusion des données"),
('sardo participants number', "SARDO Participants Number", "Nombre participants SARDO"),
('atim participants number updated', "Update ATiM Participants", "Participants ATiM mis à jour"),
('last sardo clinical data imported', "Laste SARDO Clinical Date Imported", "Dernière date clinique SARDO importée");

-- Pulmonary consent

ALTER TABLE `qc_nd_cd_chum_pulmonarys` ADD COLUMN stool char(1) NOT NULL DEFAULT '';
ALTER TABLE `qc_nd_cd_chum_pulmonarys_revs` ADD COLUMN stool char(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_pulmonarys', 'stool', 'yes_no',  NULL , '0', '', '', '', 'stool', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonarys'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='stool' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stool' AND `language_tag`=''), '2', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- i18n clean up

REPLACE INTO i18n (id,en,fr) 
VALUES 
('mycoplasma test', 'Mycoplasma/Method', 'Mycoplasme/Méthode'),
('lesions number', 'Number of Lesions', 'Nombre de lésions');

-- Remove collection datetime = '0000-00-00'

UPDATE collections SET collection_datetime = null WHERE CAST(collection_datetime AS CHAR(20)) = '0000-00-00 00:00:00';
UPDATE collections_revs SET collection_datetime = null WHERE CAST(collection_datetime AS CHAR(20)) = '0000-00-00 00:00:00';

-- breastfeeding

ALTER TABLE reproductive_histories
   ADD COLUMN qc_nd_breastfeeding char(1) DEFAULT '';
ALTER TABLE reproductive_histories_revs
   ADD COLUMN qc_nd_breastfeeding char(1) DEFAULT ''; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'qc_nd_breastfeeding', 'yes_no',  NULL , '0', '', '', '', 'breast feeding', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_breastfeeding' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='breast feeding' AND `language_tag`=''), '2', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='lnmp_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_year_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr)
VALUES
('breast feeding', 'Breast Feeding', 'Allaitement');
UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_breastfeeding' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Genetic test  :

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ('variant', 'variant');
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_genetic_test_results"), (SELECT id FROM structure_permissible_values WHERE value="variant" AND language_alias="variant"), "1", "1");
INSERT INTO i18n (id,en,fr)
VALUES
('variant', 'Variant', 'Variant');

-- Bank PROVAQ

INSERT INTO key_increments (key_name ,key_value) VALUES ('provaq bank no lab', '50000');
INSERT INTO misc_identifier_controls (misc_identifier_name , flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential, flag_unique, pad_to_length, reg_exp_validation, user_readable_format, flag_link_to_study)
VALUES
('provaq bank no lab','1','1','provaq bank no lab','%%key_increment%%','1','0','1','0','','','0');
INSERT INTO i18n (id,en,fr)
VALUES 
('provaq no lab', "'No Labo' of PROVAQ Bank","'No Labo' de la banque PROVAQ"),
('provaq bank no lab', "'No Labo' of PROVAQ Bank","'No Labo' de la banque PROVAQ");

-- Genetic Test Site

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_genetic_test_sites', "StructurePermissibleValuesCustom::getCustomDropdown('Genetic Test Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Genetic Test Sites', 0, 150, 'clinical - annotation');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_genetic_test_sites') ,  `setting`='' WHERE model='EventDetail' AND tablename='qc_nd_ed_genetic_tests' AND field='site' AND `type`='input' AND structure_value_domain  IS NULL ;

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Genetic Test Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `fr`, `en`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("Mount Sinai Hospital", "Hôpital du Mont Sinai", "Mount Sinai Hospital", '1', @control_id, NOW(), NOW(), 1, 1), 
("McGill - Dr Tonin", "McGill - Dr Tonin", "McGill - Dr Tonin", '1', @control_id, NOW(), NOW(), 1, 1), 
("Gyneco-onco list", "Liste gynéco-onco", "Gyneco-onco list", '1', @control_id, NOW(), NOW(), 1, 1), 
("CHUM - Medical file", "CHUM - Dossier médical", "CHUM - Medical file", '1', @control_id, NOW(), NOW(), 1, 1), 
("CHUM - Genetic medecine", "CHUM - Médecine génique", "CHUM - Genetic medecine", '1', @control_id, NOW(), NOW(), 1, 1), 
("Invitae", "Invitae", "Invitae", '1', @control_id, NOW(), NOW(), 1, 1), 
("Toronto - Dr Narod", "Toronto - Dr Narod", "Toronto - Dr Narod", '1', @control_id, NOW(), NOW(), 1, 1), 
("Myriad", "Myriad", "Myriad", '1', @control_id, NOW(), NOW(), 1, 1), 
("Jewish General Hospital", "Hôpital Général Juif ", "Jewish General Hospital", '1', @control_id, NOW(), NOW(), 1, 1), 
("testmyrisk", "TestMyRisk", "TestMyRisk", '1', @control_id, NOW(), NOW(), 1, 1),
("other", "Autre", "Other", '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_permissible_values_customs SET value = LOWER(value) WHERE control_id = @control_id;

SET @modified = (SELECT NOW());
SET @modified_by = (SELECT 1);
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'jewish general hospital' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Hôpital Général Juif';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'toronto - dr narod' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Toronto - Dr Narod';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'gyneco-onco list' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Liste informatique gynéco-onco';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'chum - medical file' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'CHUM';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'chum - genetic medecine' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'CHUM - clinique génique';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'chum - medical file' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'CHUM - Dossier médical';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'invitae' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'INVITAE';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'mcgill - dr tonin' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'McGill - Tonin';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'chum - medical file' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'CHUM - Dossier médicial';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'chum - genetic medecin' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'CHUM - Médecine génique';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'chum - genetic medecin' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'clinique génique';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'myriad' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Myriad';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'other' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Inconnu';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'chum - medical file' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Dossier médical';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'mount sinai hospital' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Mount Sinai Hospital';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'mcgill - dr tonin' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site = 'Mc-Gill - Tonin';
UPDATE event_masters EventMaster, qc_nd_ed_genetic_tests EventDetail SET EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, EventDetail.site = 'testmyrisk' 
WHERE EventDetail.event_master_id = EventMaster.id AND EventMaster.deleted <> 1 AND EventDetail.site LIKE '%Test MyRisk%';
INSERT INTO event_masters_revs (id,event_control_id,event_status,event_summary,event_date,event_date_accuracy,information_source,
urgency,date_required,date_required_accuracy,date_requested,date_requested_accuracy,reference_number,participant_id,diagnosis_master_id,version_created,modified_by)
(SELECT id,event_control_id,event_status,event_summary,event_date,event_date_accuracy,information_source,
urgency,date_required,date_required_accuracy,date_requested,date_requested_accuracy,reference_number,participant_id,diagnosis_master_id,modified,modified_by
FROM event_masters WHERE modified_by = @modified_by AND modified = @modified);
INSERT INTO qc_nd_ed_genetic_tests_revs (event_master_id,test,result,detail,site,simplified_result,version_created)
(SELECT id,test,result,detail,site,simplified_result,modified
FROM event_masters INNER JOIN qc_nd_ed_genetic_tests ON id = event_master_id WHERE modified_by = @modified_by AND modified = @modified);
	
-- Toronto Hereditary Cancer Number
	
INSERT INTO misc_identifier_controls (misc_identifier_name , flag_active, display_order, autoincrement_name, misc_identifier_format, 
flag_once_per_participant, flag_confidential, flag_unique, pad_to_length, reg_exp_validation, user_readable_format, flag_link_to_study)
VALUES
('toronto hereditary cancer number','1','1','','','0','0','1','0','','','0');
INSERT INTO i18n (id,en,fr)
VALUES 
('toronto hereditary cancer number', "Toronto Hereditary Cancer Number","No Cancer Héréditaire de Toronto");
	
-- -----------------------------

UPDATE versions SET branch_build_number = '7025' WHERE version_number = '2.7.0';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 20180424
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Study Contact Email

ALTER TABLE study_summaries ADD COLUMN qc_nd_contact_email varchar(150) DEFAULT NULL;
ALTER TABLE study_summaries_revs ADD COLUMN qc_nd_contact_email varchar(150) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_contact_email', 'input',  NULL , '0', '', '', '', '', 'email');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_contact_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='email'), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Consent - New Field

ALTER TABLE cd_icm_generics ADD COLUMN qc_nd_additional_collection char(1) DEFAULT '';
ALTER TABLE cd_icm_generics_revs ADD COLUMN qc_nd_additional_collection char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_icm_generics', 'qc_nd_additional_collection', 'yes_no',  NULL , '0', '', '', '', 'additional collection', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_icm_frsq_gyneco'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='qc_nd_additional_collection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional collection' AND `language_tag`=''), '2', '6', 'agreements (2)', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('additional collection', 'Additional Collection', 'Prélèvement supplémentaire'),
('agreements (2)', 'Agreements (2nd version)', 'Authorisation (2ème version)');
REPLACE INTO i18n (id,en,fr)
VALUES
('additional tumor collection', 'Additional tumor collection', 'Collection supplémentaire (de tumeur)'),
('use of faeces', 'Use of Faeces', 'Utilisation matières fécales');

-- PSA et CA125 `Float

UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_nd_ed_ca125s' AND field='value' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
ALTER TABLE qc_nd_ed_ca125s MODIFY value decimal(12,3) DEFAULT NULL;
ALTER TABLE qc_nd_ed_ca125s_revs MODIFY value decimal(12,3) DEFAULT NULL;

UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_nd_ed_psas' AND field='value' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
ALTER TABLE qc_nd_ed_psas MODIFY value decimal(12,3) DEFAULT NULL;
ALTER TABLE qc_nd_ed_psas_revs MODIFY value decimal(12,3) DEFAULT NULL;

-- -----------------------------

UPDATE versions SET branch_build_number = '7097' WHERE version_number = '2.7.0';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 20180425
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE qc_nd_ed_ca125s MODIFY value int(8) DEFAULT NULL;
ALTER TABLE qc_nd_ed_ca125s_revs MODIFY value int(8) DEFAULT NULL;
UPDATE structure_fields SET  `type`='integer_positive' WHERE model='EventDetail' AND tablename='qc_nd_ed_ca125s' AND field='value' AND `type`='float_positive' AND structure_value_domain  IS NULL ;

UPDATE versions SET branch_build_number = '7098' WHERE version_number = '2.7.0';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 20180426
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE realiquotings SET realiquoting_datetime = null WHERE CAST(realiquoting_datetime AS CHAR(20)) = '0000-00-00 00:00:00';
UPDATE realiquotings_revs SET realiquoting_datetime = null WHERE CAST(realiquoting_datetime AS CHAR(20)) = '0000-00-00 00:00:00';

UPDATE shipments SET datetime_shipped = null WHERE CAST(datetime_shipped AS CHAR(20)) = '0000-00-00 00:00:00';
UPDATE shipments_revs SET datetime_shipped = null WHERE CAST(datetime_shipped AS CHAR(20)) = '0000-00-00 00:00:00';

UPDATE versions SET branch_build_number = '7125' WHERE version_number = '2.7.0';

-- -------------------------------------------------------------------------------------
--	Create Stool Derivative
-- -------------------------------------------------------------------------------------

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'stool supernatant', 'derivative', 'derivative', 'qc_nd_sd_der_stools_derivatives', 0, 'stool supernatant'),
(null, 'stool dna extr. super.', 'derivative', 'derivative', 'qc_nd_sd_der_stools_derivatives', 0, 'stool dna extr. super.'),
(null, 'stool pellet', 'derivative', 'derivative', 'qc_nd_sd_der_stools_derivatives', 0, 'stool pellet');
CREATE TABLE IF NOT EXISTS `qc_nd_sd_der_stools_derivatives` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_qc_nd_sd_der_stools_derivatives_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_sd_der_stools_derivatives_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_sd_der_stools_derivatives`
  ADD CONSTRAINT `FK_qc_nd_sd_der_stools_derivatives_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool'), (SELECT id FROM sample_controls WHERE sample_type = 'stool supernatant'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool'), (SELECT id FROM sample_controls WHERE sample_type = 'stool dna extr. super.'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool'), (SELECT id FROM sample_controls WHERE sample_type = 'stool pellet'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool supernatant'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool supernatant'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool pellet'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool pellet'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool dna extr. super.'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool dna extr. super.'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 1, NULL);
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool supernatant'), 'tube', '', 'qc_nd_ad_der_stool_supernatant', 'ad_tubes', 'ml', 1, '', 0, 'stool supernatant|tube'),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool dna extr. super.'), 'tube', '', 'qc_nd_ad_der_stool_dna_ext_sup', 'ad_tubes', 'ml', 1, '', 0, 'stool dna extr. super.|tube'),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'stool pellet'), 'tube', '', 'qc_nd_ad_der_stool_pellet', 'ad_tubes', 'ml', 1, '', 0, 'stool pellet|tube');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(null, (SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'stool supernatant'), 
(SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'stool supernatant'), 1, NULL),
(null, (SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'stool pellet'), 
(SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'stool pellet'), 1, NULL),
(null, (SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'stool dna extr. super.'), 
(SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'stool dna extr. super.'), 1, NULL);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_stool_supernatant_storage_solution', "StructurePermissibleValuesCustom::getCustomDropdown('Stool Supernatant Storage Solutions')"),
('qc_nd_stool_supernatant_storage_method', "StructurePermissibleValuesCustom::getCustomDropdown('Stool Supernatant Storage Methods')"),
('qc_nd_stool_pellet_storage_solution', "StructurePermissibleValuesCustom::getCustomDropdown('Stool Pellet Storage Solutions')"),
('qc_nd_stool_pellet_storage_method', "StructurePermissibleValuesCustom::getCustomDropdown('Stool Pellet Storage Methods')"),
('qc_nd_stool_dna_ext_sup_storage_solution', "StructurePermissibleValuesCustom::getCustomDropdown('Stool DNA Extraction Supernatant Storage Solutions')"),
('qc_nd_stool_dna_ext_sup_storage_method', "StructurePermissibleValuesCustom::getCustomDropdown('Stool DNA Extraction Supernatant Storage Methods')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Stool Supernatant Storage Solutions', 1, 30, 'inventory'),
('Stool Supernatant Storage Methods', 1, 30, 'inventory'),
('Stool Pellet Storage Solutions', 1, 30, 'inventory'),
('Stool Pellet Storage Methods', 1, 30, 'inventory'),
('Stool DNA Extraction Supernatant Storage Solutions', 1, 30, 'inventory'),
('Stool DNA Extraction Supernatant Storage Methods', 1, 30, 'inventory');

INSERT INTO structures(`alias`) VALUES ('qc_nd_ad_der_stool_supernatant');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'tmp_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_supernatant_storage_solution') , '0', '', '', '', 'tmp storage solution', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'tmp_storage_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_supernatant_storage_method') , '0', '', '', '', 'tmp storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tmp_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_supernatant_storage_solution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tmp storage solution' AND `language_tag`=''), '1', '80', ' ', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_supernatant'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tmp_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_supernatant_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tmp storage method' AND `language_tag`=''), '1', '81', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '1');

INSERT INTO structures(`alias`) VALUES ('qc_nd_ad_der_stool_pellet');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'tmp_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_pellet_storage_solution') , '0', '', '', '', 'tmp storage solution', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'tmp_storage_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_pellet_storage_method') , '0', '', '', '', 'tmp storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tmp_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_pellet_storage_solution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tmp storage solution' AND `language_tag`=''), '1', '80', ' ', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_pellet'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tmp_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_pellet_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tmp storage method' AND `language_tag`=''), '1', '81', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '1');

INSERT INTO structures(`alias`) VALUES ('qc_nd_ad_der_stool_dna_ext_sup');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'tmp_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_dna_ext_sup_storage_solution') , '0', '', '', '', 'tmp storage solution', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'tmp_storage_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_dna_ext_sup_storage_method') , '0', '', '', '', 'tmp storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tmp_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_dna_ext_sup_storage_solution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tmp storage solution' AND `language_tag`=''), '1', '80', ' ', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ad_der_stool_dna_ext_sup'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tmp_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stool_dna_ext_sup_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tmp storage method' AND `language_tag`=''), '1', '81', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '1');

INSERT INTO i18n (id,en,fr)
VALUES
('stool supernatant', 'Stool Supernatant', 'Surnageant de selles'),
('stool dna extraction supernatant', 'Stool DNA Extraction Supernatant', "Surnageant extraction ADN de selles"),
('stool dna extr. super.', 'Stool DNA Extraction Supernatant', "Surnageant extraction ADN de selles"),
('stool pellet', 'Stool Pellet', 'Culot de selles');

UPDATE sample_controls SET detail_form_alias = 'sd_undetailed_derivatives,derivatives' WHERE detail_tablename = 'qc_nd_sd_der_stools_derivatives';

UPDATE versions SET branch_build_number = '7130' WHERE version_number = '2.7.0';

-- 2018-06-18
-- -----------------------------------------------------------------------------------------------

-- Kidney consent

ALTER TABLE `cd_icm_generics` ADD COLUMN stool char(1) NOT NULL DEFAULT '';
ALTER TABLE `cd_icm_generics_revs` ADD COLUMN stool char(1) NOT NULL DEFAULT '';

INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_chum_kidneys');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_icm_generics', 'stool', 'yes_no',  NULL , '0', '', '', '', 'stool', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_kidneys'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stool' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stool' AND `language_tag`=''), '2', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE consent_controls SET detail_form_alias = CONCAT(detail_form_alias, ',qc_nd_cd_chum_kidneys') WHERE controls_type = 'chum - kidney';

UPDATE versions SET branch_build_number = '7170' WHERE version_number = '2.7.0';

