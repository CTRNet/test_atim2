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













Probleme encodeage utf8 de 'prevision' et des description fr des code ICD10 et ICDo3, etc. A verifier lors de la migration.


