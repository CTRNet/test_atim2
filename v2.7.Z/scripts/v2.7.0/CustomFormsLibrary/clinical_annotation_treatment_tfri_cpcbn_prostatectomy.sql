-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user_id (To Define)

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- TFRI CPCBN Radical Prostatectomy
-- ................................................................................
-- Prostatectomy forms developped to capture data of prostate cancer 
-- for the central ATiM of the Canadian Prostate Cancer Biomarker Network (CPCBN).
-- Project of the Terry Fox Research Institute (TFRI).
-- --------------------------------------------------------------------------------

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) 
VALUES
(null, 'tfri cpcbn - radical prostatectomy', 'prostate', 1, 'tfri_cpcbn_txd_rps', 'tfri_cpcbn_txd_rps', 0, NULL, NULL, 'prostate|tfri cpcbn - radical prostatectomy', 0, NULL, 0, 1);

DROP TABLE IF EXISTS `tfri_cpcbn_txd_rps`;
CREATE TABLE IF NOT EXISTS `tfri_cpcbn_txd_rps` (
  `path_num` varchar(50) DEFAULT NULL,
  `primary` varchar(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `gleason_score` varchar(10) DEFAULT '',
  `lymph_node_invasion` char(1) DEFAULT '',
  `capsular_penetration` char(1) DEFAULT '',
  `seminal_vesicle_invasion` char(1) DEFAULT '',
  `margin` varchar(1) DEFAULT '',
  `gleason_grade` varchar(10) DEFAULT NULL,
  `perineural_invasion` char(1) DEFAULT '',
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `tfri_cpcbn_txd_rps_revs`;
CREATE TABLE IF NOT EXISTS `tfri_cpcbn_txd_rps_revs` (
  `path_num` varchar(50) DEFAULT NULL,
  `primary` varchar(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `gleason_score` varchar(10) DEFAULT '',
  `lymph_node_invasion` char(1) DEFAULT '',
  `capsular_penetration` char(1) DEFAULT '',
  `seminal_vesicle_invasion` char(1) DEFAULT '',
  `margin` varchar(1) DEFAULT '',
  `gleason_grade` varchar(10) DEFAULT NULL,
  `perineural_invasion` char(1) DEFAULT '',
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4737 DEFAULT CHARSET=latin1;
ALTER TABLE `tfri_cpcbn_txd_rps`
  ADD CONSTRAINT `tfri_cpcbn_txd_rps_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('tfri_cpcbn_rp_gleason_grades', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: RP Gleason Grades\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('TFRI CPCBN: RP Gleason Grades', 1, 10, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: RP Gleason Grades');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("3+3", "3+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+4", "3+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+3", "4+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+4", "4+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+5", "4+5", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5+4", "5+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5+5", "5+5", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+2", "2+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+3", "2+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1+2", "1+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+2", "3+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+5", "3+5", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+1", "3+1", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+2", "4+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5+3", "5+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+1", "2+1", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+4", "2+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1+1", "1+1", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('tfri_cpcbn_rp_gleason_values', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: RP Gleason Values\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('TFRI CPCBN: RP Gleason Values', 1, 10, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: RP Gleason Values');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "1", "1", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2", "", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("6", "", "", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("7", "", "", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("8", "", "", "8", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("9", "", "", "9", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("10", "", "", "10", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "11", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
 
INSERT INTO structures(`alias`) VALUES ('tfri_cpcbn_txd_rps');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_rps', 'lymph_node_invasion', 'yes_no',  NULL , '0', '', '', '', 'lymph node invasion', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_rps', 'capsular_penetration', 'yes_no',  NULL , '0', '', '', '', 'capsular penetration', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_rps', 'seminal_vesicle_invasion', 'yes_no',  NULL , '0', '', '', '', 'seminal vesicle invasion', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_rps', 'margin', 'yes_no',  NULL , '0', '', '', '', 'margin', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_rps', 'perineural_invasion', 'yes_no',  NULL , '0', '', '', '', 'perineural invasion', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_rps', 'gleason_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_rp_gleason_grades') , '0', '', '', '', 'gleason grade', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_rps', 'gleason_score', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_rp_gleason_values') , '0', '', '', '', 'gleason sum', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_rps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_rps' AND `field`='lymph_node_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node invasion' AND `language_tag`=''), 
'2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_rps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_rps' AND `field`='capsular_penetration' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='capsular penetration' AND `language_tag`=''), 
'2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_rps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_rps' AND `field`='seminal_vesicle_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='seminal vesicle invasion' AND `language_tag`=''), 
'2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_rps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_rps' AND `field`='margin' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin' AND `language_tag`=''), 
'2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_rps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_rps' AND `field`='perineural_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='perineural invasion' AND `language_tag`=''), 
'2', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_rps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_rps' AND `field`='gleason_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_rp_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade' AND `language_tag`=''), 
'1', '80', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_rps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_rps' AND `field`='gleason_score' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_rp_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason sum' AND `language_tag`=''), 
'1', '81', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("tfri cpcbn - radical prostatectomy", "Radical Prostatectomy (TFRI CPCBN)", "Prostatectomie radicale (TFRI CPCBN)"),
("capsular penetration", "Capsular Penetration", "Pénétration capsulaire"),
("gleason grade", "Gleason Grade", "Grade de Gleason"),
("gleason sum", "Gleason Sum", "Score de Gleason"),
("lymph node invasion", "Lymph Node Invasion", "Invasion des ganglions lymphatiques"),
("seminal vesicle invasion", "Seminal Vesicle Invasion", "Invasion de la vésicule séminale");
 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;