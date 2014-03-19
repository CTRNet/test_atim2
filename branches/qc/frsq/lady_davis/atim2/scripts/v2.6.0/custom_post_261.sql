-- --------------------------------------------------------------------------------------------------------
-- Create Custom ICD-O-3 Morpho
-- --------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `coding_icd_o_3_morphology_custom` (
  `id` int(11) unsigned NOT NULL,
  `en_description` varchar(255) NOT NULL,
  `fr_description` varchar(255) NOT NULL,
  `translated` tinyint(1) NOT NULL,
  `source` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `en_description` (`en_description`),
  FULLTEXT KEY `fr_description` (`fr_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO coding_icd_o_3_morphology_custom (id,en_description,fr_description,translated,source) (SELECT id,en_description,fr_description,translated,source FROM coding_icd_o_3_morphology);

UPDATE coding_icd_o_3_morphology_custom SET en_description = 'Mucinous (colloid) adenocarcinoma', fr_description = 'Adénocarcinome mucineux (colloïde)', source = 'CUSTOMIZED' WHERE id = 84803;
UPDATE coding_icd_o_3_morphology_custom SET en_description = 'Intraductal papillary adenocarcinoma with invasion (infiltrante)', fr_description = 'Adénocarcinome intracanalaire, papillaire, invasif (infiltrant)', source = 'CUSTOMIZED' WHERE id = 85033;
INSERT INTO coding_icd_o_3_morphology_custom (id,en_description,fr_description,translated,source) VALUES (85073,'Invasive micropapillary ductal carcinoma','Carcinome canalaire micropapillaire infitrant',1,'CUSTOMIZED');		
UPDATE coding_icd_o_3_morphology_custom SET fr_description = 'Carcinome intracanalaire avec autres types de carcinomes in situ', translated = 1, source = 'CUSTOMIZED' WHERE id = 85232;
UPDATE coding_icd_o_3_morphology_custom SET fr_description = 'Maladie de Paget et carcinome canalaire infiltrant du sein', translated = 1, source = 'CUSTOMIZED' WHERE id = 85413;
UPDATE coding_icd_o_3_morphology_custom SET fr_description = 'Maladie de Paget et carcinome intracanalaire du sein', translated = 1, source = 'CUSTOMIZED' WHERE id = 85433;
INSERT INTO coding_icd_o_3_morphology_custom (id,en_description,fr_description,translated,source) VALUES (85432,'Paget disease and intraductal carcinoma of breast','Maladie de Paget et carcinome intracanalaire du sein in situ',1,'CUSTOMIZED');		

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='topography', `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='staging' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='morphology' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_morphology') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='topography' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_topography') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='morphology_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_morphology_2') AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- Surgery
-- --------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_surgeries') WHERE tx_method = 'surgery' AND flag_Active = 1;							
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_surgical_procedures", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Surgical Procedure\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Surgical Procedure', 1, 100, 'clinical - treatment');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_surgical_procedures')  WHERE model='TreatmentExtendDetail' AND tablename='txe_surgeries' AND field='surgical_procedure' AND `type`='input' AND structure_value_domain  IS NULL ;
ALTER TABLE txe_surgeries MODIFY surgical_procedure varchar(100) default NULL;
ALTER TABLE txe_surgeries_Revs MODIFY surgical_procedure varchar(100) default NULL;

-- --------------------------------------------------------------------------------------------------------
-- Biopsy
-- --------------------------------------------------------------------------------------------------------

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label)
VALUES
('qc_lady_txe_biopsies','qc_lady_txe_biopsies','1','biopsy procedure','biopsy procedure');
UPDATE treatment_controls SET treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'qc_lady_txe_biopsies') WHERE tx_method = 'biopsy' AND flag_Active = 1;			
CREATE TABLE IF NOT EXISTS `qc_lady_txe_biopsies` (
  `biopsy_procedure` varchar(100) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_qc_lady_txe_biopsies_treatment_extend_masters` (`treatment_extend_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_txe_biopsies_revs` (
  `biopsy_procedure` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_txe_biopsies`
  ADD CONSTRAINT `FK_qc_lady_txe_biopsies_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_biopsy_procedures", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy Procedure\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Biopsy Procedure', 1, 100, 'clinical - treatment');
INSERT INTO structures(`alias`) VALUES ('qc_lady_txe_biopsies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qc_lady_txe_biopsies', 'biopsy_procedure', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_biopsy_procedures') , '0', '', '', '', 'biopsy procedure', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txe_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_lady_txe_biopsies' AND `field`='biopsy_procedure' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_biopsy_procedures')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy procedure' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('biopsy procedure','Biopsy Procedure', 'Procédure');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '100', 'staging', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '102', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1, maxlength=3' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '103', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_tstage' AND `language_label`='pathological stage' AND `language_tag`='t stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_nstage' AND `language_label`='' AND `language_tag`='n stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_mstage' AND `language_label`='' AND `language_tag`='m stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_stage_summary' AND `language_label`='' AND `language_tag`='summary' AND `type`='input' AND `setting`='size=1, maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_path_stage_summary' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- RADIO
-- --------------------------------------------------------------------------------------------------------

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label)
VALUES
('qc_lady_txe_radiations','qc_lady_txe_radiations','1','radiation procedure','radiation procedure');
UPDATE treatment_controls SET treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'qc_lady_txe_radiations') WHERE tx_method = 'radiation' AND flag_Active = 1;			
CREATE TABLE IF NOT EXISTS `qc_lady_txe_radiations` (
  `radiation_procedure` varchar(100) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_qc_lady_txe_radiations_treatment_extend_masters` (`treatment_extend_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_txe_radiations_revs` (
  `radiation_procedure` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_txe_radiations`
  ADD CONSTRAINT `FK_qc_lady_txe_radiations_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_radiation_procedures", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Radiation Procedure\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Radiation Procedure', 1, 100, 'clinical - treatment');
INSERT INTO structures(`alias`) VALUES ('qc_lady_txe_radiations');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qc_lady_txe_radiations', 'radiation_procedure', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_radiation_procedures') , '0', '', '', '', 'radiation procedure', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_lady_txe_radiations' AND `field`='radiation_procedure' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_radiation_procedures')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiation procedure' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('radiation procedure','Radiation Procedure', 'Procédure');

-- --------------------------------------------------------------------------------------------------------
-- IMMUNO
-- --------------------------------------------------------------------------------------------------------

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label)
VALUES
('qc_lady_txe_immunos','qc_lady_txe_immunos','1','immunotherapy drug','immunotherapy drug');
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'immunotherapy', '', 1, 'qc_lady_txd_immunos', 'qc_lady_txd_immunos', 0, 1, 'importDrugFromChemoProtocol', 'immunotherapy', 0);
UPDATE treatment_controls SET treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'qc_lady_txe_immunos') WHERE tx_method = 'immunotherapy' AND flag_Active = 1;			
CREATE TABLE IF NOT EXISTS `qc_lady_txd_immunos` (
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `qc_lady_txd_immunos_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_txd_immunos`
  ADD CONSTRAINT `qc_lady_txd_immunos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_lady_txd_immunos');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('qc_lady_txe_immunos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qc_lady_txe_immunos', 'dose', 'input',  NULL , '0', 'size=10', '', 'help_dose', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qc_lady_txe_immunos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_lady_txe_immunos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_lady_txe_immunos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '1', '0', '1', '0');

UPDATE treatment_controls SET applied_protocol_control_id = NULL, extended_data_import_process  = NULL WHERE detail_tablename IN ('qc_lady_txd_hormonos', 'qc_lady_txd_immunos');
DELETE FROM protocol_controls WHERE detail_tablename = 'qc_lady_pd_hormonos';
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_lady_pd_hormonos');
DELETE FROM structures WHERE alias='qc_lady_pd_hormonos';
DROP TABLE qc_lady_pd_hormonos;
DROP TABLE qc_lady_pd_hormonos_revs;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("immunotherapy", "immunotherapy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="type"), (SELECT id FROM structure_permissible_values WHERE value="immunotherapy" AND language_alias="immunotherapy"), "", "1");
INSERT INTO i18n (id,en,fr) VALUES ("immunotherapy", "Immunotherapy", "Immunothérapie");
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_surgical_procedures') ,  `setting`='' WHERE model='TreatmentExtendDetail' AND tablename='txe_surgeries' AND field='surgical_procedure' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_surgical_procedures');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_immunos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-49' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `language_help`='help_protocol_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

CREATE TABLE IF NOT EXISTS `qc_lady_txe_immunos` (
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_qc_lady_txe_immunos_drugs` (`drug_id`),
  KEY `FK_qc_lady_txe_immunos_treatment_extend_masters` (`treatment_extend_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_txe_immunos_revs` (
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;
ALTER TABLE `qc_lady_txe_immunos`
  ADD CONSTRAINT `FK_qc_lady_txe_immunos_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`),
  ADD CONSTRAINT `FK_qc_lady_txe_immunos_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);

INSERT INTO i18n (id,en,fr) VALUES ('immunotherapy drug','Immunotherapy Drug','Molécule d''immunothérapie');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-49' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `language_help`='help_protocol_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

DROP TABLE IF EXISTS qc_lady_txe_hormonos;
DROP TABLE IF EXISTS qc_lady_txe_hormonos_revs;
CREATE TABLE IF NOT EXISTS `qc_lady_txe_hormonos` (
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_qc_lady_txe_hormonos_drugs` (`drug_id`),
  KEY `FK_qc_lady_txe_hormonos_treatment_extend_masters` (`treatment_extend_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_txe_hormonos_revs` (
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;
ALTER TABLE `qc_lady_txe_hormonos`
  ADD CONSTRAINT `FK_qc_lady_txe_hormonos_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`),
  ADD CONSTRAINT `FK_qc_lady_txe_hormonos_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);

UPDATE treatment_extend_controls SET type = 'hormonotherapy drug', databrowser_label = 'hormonotherapy drug' WHERE detail_tablename = 'qc_lady_txe_hormonos';

INSERT INTO i18n (id,en,fr) VALUES ('hormonotherapy drug','Hormonotherapy Drug','Molécule d''hormonothérapie');

UPDATE i18n SET fr  = 'Procédure de biopsie' WHERE id = 'biopsy procedure';
UPDATE i18n SET fr  = 'Procédure de radiation' WHERE id = 'radiation procedure';
UPDATE i18n SET fr  = 'Effectué' WHERE id = 'performed';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_hormonos' AND `field`='completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

UPDATE structure_permissible_values_custom_controls SET category = 'clinical' WHERE name = 'Participant Races';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis' WHERE name = 'Tumor Sites';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment' WHERE name = 'Morphology';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment' WHERE name = 'Morphology Precision';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment' WHERE name = 'Topography';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', values_max_length = '100' WHERE name = 'Imaging Types';

DELETE FROM structure_permissible_values_customs WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Imaging Types');
DELETE FROM structure_permissible_values_customs_revs WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Imaging Types');

ALTER TABLE qc_lady_imagings MODIFY `type` varchar(100) DEFAULT NULL;
ALTER TABLE qc_lady_imagings_revs MODIFY `type` varchar(100) DEFAULT NULL;

UPDATE event_controls SET use_detail_form_for_index = 1 WHERE id = 53;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_histological_grade') , '0', '', '', '', 'grade CIM-O', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_histological_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade CIM-O' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('grade CIM-O','Grade CIM-O','Grade CIM-O');

UPDATE event_controls SET use_detail_form_for_index = 1 WHERE id = 52;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_her2_receptor_antibody", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'HER Receptor Antibody\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('HER Receptor Antibody', 1, 50, 'clinical - treatment');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'her2_receptor_antibody', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_her2_receptor_antibody') , '0', '', '', '', '', 'antibody');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='her2_receptor_antibody' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_her2_receptor_antibody')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='antibody'), '2', '138', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN her2_receptor_antibody varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN her2_receptor_antibody varchar(50) DEFAULT NULL;
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'HER Receptor Antibody');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('4B5','','', '1', @control_id, NOW(), NOW(), 1, 1),
('CB11','','', '1', @control_id, NOW(), NOW(), 1, 1),
('TAB 250','','', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO i18n (id,en,fr) VALUES ('antibody','Antibody','Anticorps');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_equivocal_result')  WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='er_receptor_ccl' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_equivocal_result')  WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='pr_receptor_ccl' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_equivocal_result')  WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='fish_ccl' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result');

ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN residual_disease char(1) DEFAULT '';
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN residual_disease char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'residual_disease', 'yes_no',  NULL , '0', '', '', '', 'residual disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='residual_disease' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='residual disease' AND `language_tag`=''), '2', '124', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='116' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='residual_disease' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('residual disease','residual disease','Maladie résiduelle');

ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN oncotype_dx int(8) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN oncotype_dx int(8) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'oncotype_dx', 'integer_positive',  NULL , '0', '', '', '', 'oncotype dx', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='oncotype_dx' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oncotype dx' AND `language_tag`=''), '2', '150', 'genetic testing', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('genetic testing','Genetic Testing','Tests Génétiques'),('oncotype dx','Oncotype DX','Oncotype DX');

UPDATE protocol_controls SET tumour_group = '';

ALTER TABLE participants ADD COLUMN qc_lady_last_contact_date date DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN qc_lady_last_contact_date date DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_lady_last_contact_date', 'date',  NULL , '0', '', '', '', 'last contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_last_contact_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '3', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('last contact','Last Contact Date','Date dernier contact');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');









Probleme encodeage utf8 de 'prevision' et des description fr des code ICD10 et ICDo3, etc. A verifier lors de la migration.
Protocol : Ajouter les drugs si possible
Survival ajouter code pour le calculer










