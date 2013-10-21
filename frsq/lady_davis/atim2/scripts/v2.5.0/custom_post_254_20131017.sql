-- Profile


UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Participant Races\')" WHERE domain_name = 'race';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Participant Races', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Races');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
(SELECT val.value, i18n.en, i18n.fr, '1', @control_id
FROM structure_value_domains dom
INNER JOIN structure_value_domains_permissible_values link ON link.structure_value_domain_id = dom.id
INNER JOIN structure_permissible_values val ON link.structure_permissible_value_id = val.id
LEFT JOIN i18n ON i18n.id = val.language_alias
WHERE dom.domain_name = 'race');
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'race');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');


-- Reporductive History


UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field` IN ('date_captured','date_captured_accuracy','menopause_status','age_at_menopause','age_at_menopause_precision','gravida','para'));
ALTER TABLE reproductive_histories ADD COLUMN aborta int(11) DEFAULT NULL;
ALTER TABLE reproductive_histories_revs ADD COLUMN aborta int(11) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'aborta', 'integer_positive',  NULL , '0', '', '', '', 'aborta', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='aborta' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aborta' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('aborta','Aborta','Aborta');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='date_captured' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='aborta' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- Diagnosis


UPDATE diagnosis_controls SET flag_active = 1 WHERE id > 2;
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters%';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_unknown_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'breast', 1, 'qc_lady_dx_breasts', 'qc_lady_dxd_breasts', 0, 'primary|breast', 0);
CREATE TABLE IF NOT EXISTS `qc_lady_dxd_breasts` (
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `laterality` varchar(50) NOT NULL DEFAULT '',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_dxd_breasts_revs` (
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=108 ;
ALTER TABLE `qc_lady_dxd_breasts`
  ADD CONSTRAINT `FK_qc_lady_dxd_breasts_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_lady_dx_breasts');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_lady_dxd_breasts', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_lady_dxd_breasts' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '99', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='help_clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1, maxlength=3' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
ALTER TABLE diagnosis_masters
   ADD COLUMN `qc_lady_clinical_stage_summary_at_dx` varchar(5) DEFAULT NULL,
   ADD COLUMN `qc_lady_path_stage_summary_at_dx` varchar(5) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs
   ADD COLUMN `qc_lady_clinical_stage_summary_at_dx` varchar(5) DEFAULT NULL,
   ADD COLUMN `qc_lady_path_stage_summary_at_dx` varchar(5) DEFAULT NULL;
DELETE FROM dxd_tissues WHERE diagnosis_master_id IN (SELECT id FROM diagnosis_masters WHERE deleted = 1);
UPDATE diagnosis_masters SET primary_id = NULL WHERE deleted = 1; 
DELETE FROM diagnosis_masters WHERE deleted = 1;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_lady_clinical_stage_summary_at_dx', 'input',  NULL , '0', 'size=1,maxlength=3', '', '', '', 'clinical stage at diagnosis'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_lady_path_stage_summary_at_dx', 'input',  NULL , '0', 'size=1,maxlength=3', '', '', '', 'pathological stage at diagnosis');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_clinical_stage_summary_at_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='clinical stage at diagnosis'), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_path_stage_summary_at_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='pathological stage at diagnosis'), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES 
('clinical stage at diagnosis', 'Clinical Stage at Diagnosis', 'Stade clinique au diagnostic'),
('pathological stage at diagnosis','Pathological Stage at Diagnosis','Stade pathologique au diagnostic');
UPDATE structure_fields SET  `language_label`='clinical stage at diagnosis',  `language_tag`='' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='qc_lady_clinical_stage_summary_at_dx' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='pathological stage at diagnosis',  `language_tag`='' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='qc_lady_path_stage_summary_at_dx' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary');
INSERT INTO structure_value_domains (domain_name, source) VALUES ("qc_lady_tumor_site", "StructurePermissibleValuesCustom::getCustomDropdown(\'Tumor Sites\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Tumor Sites', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tumor Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('breast-breast', 'breast-breast', '', '1', @control_id),
('central nervous system-brain', 'central nervous system-brain', '', '1', @control_id),
('central nervous system-other central nervous system', 'central nervous system-other central nervous system', '', '1', @control_id),
('central nervous system-spinal cord', 'central nervous system-spinal cord', '', '1', @control_id),
('digestive-anal', 'digestive-anal', '', '1', @control_id),
('digestive-appendix', 'digestive-appendix', '', '1', @control_id),
('digestive-bile ducts', 'digestive-bile ducts', '', '1', @control_id),
('digestive-colonic', 'digestive-colonic', '', '1', @control_id),
('digestive-esophageal', 'digestive-esophageal', '', '1', @control_id),
('digestive-gallbladder', 'digestive-gallbladder', '', '1', @control_id),
('digestive-liver', 'digestive-liver', '', '1', @control_id),
('digestive-other digestive', 'digestive-other digestive', '', '1', @control_id),
('digestive-pancreas', 'digestive-pancreas', '', '1', @control_id),
('digestive-rectal', 'digestive-rectal', '', '1', @control_id),
('digestive-small intestine', 'digestive-small intestine', '', '1', @control_id),
('digestive-stomach', 'digestive-stomach', '', '1', @control_id),
('female genital-cervical', 'female genital-cervical', '', '1', @control_id),
('female genital-endometrium', 'female genital-endometrium', '', '1', @control_id),
('female genital-fallopian tube', 'female genital-fallopian tube', '', '1', @control_id),
('female genital-gestational trophoblastic neoplasia', 'female genital-gestational trophoblastic neoplasia', '', '1', @control_id),
('female genital-other female genital', 'female genital-other female genital', '', '1', @control_id),
('female genital-ovary', 'female genital-ovary', '', '1', @control_id),
('female genital-peritoneal pelvis abdomen', 'female genital-peritoneal pelvis abdomen', '', '1', @control_id),
('female genital-uterine', 'female genital-uterine', '', '1', @control_id),
('female genital-vagina', 'female genital-vagina', '', '1', @control_id),
('female genital-vulva', 'female genital-vulva', '', '1', @control_id),
('haematological-hodgkin''s disease', 'haematological-hodgkin''s disease', '', '1', @control_id),
('haematological-leukemia', 'haematological-leukemia', '', '1', @control_id),
('haematological-lymphoma', 'haematological-lymphoma', '', '1', @control_id),
('haematological-non-hodgkin''s lymphomas', 'haematological-non-hodgkin''s lymphomas', '', '1', @control_id),
('haematological-other haematological', 'haematological-other haematological', '', '1', @control_id),
('head & neck-larynx', 'head & neck-larynx', '', '1', @control_id),
('head & neck-lip and oral cavity', 'head & neck-lip and oral cavity', '', '1', @control_id),
('head & neck-nasal cavity and sinuses', 'head & neck-nasal cavity and sinuses', '', '1', @control_id),
('head & neck-other head & neck', 'head & neck-other head & neck', '', '1', @control_id),
('head & neck-pharynx', 'head & neck-pharynx', '', '1', @control_id),
('head & neck-salivary glands', 'head & neck-salivary glands', '', '1', @control_id),
('head & neck-thyroid', 'head & neck-thyroid', '', '1', @control_id),
('musculoskeletal sites-bone', 'musculoskeletal sites-bone', '', '1', @control_id),
('musculoskeletal sites-other bone', 'musculoskeletal sites-other bone', '', '1', @control_id),
('musculoskeletal sites-soft tissue sarcoma', 'musculoskeletal sites-soft tissue sarcoma', '', '1', @control_id),
('ophthalmic-eye', 'ophthalmic-eye', '', '1', @control_id),
('ophthalmic-other eye', 'ophthalmic-other eye', '', '1', @control_id),
('other-gross metastatic disease', 'other-gross metastatic disease', '', '1', @control_id),
('other-primary unknown', 'other-primary unknown', '', '1', @control_id),
('skin-melanoma', 'skin-melanoma', '', '1', @control_id),
('skin-non melanomas', 'skin-non melanomas', '', '1', @control_id),
('skin-other skin', 'skin-other skin', '', '1', @control_id),
('thoracic-lung', 'thoracic-lung', '', '1', @control_id),
('thoracic-mesothelioma', 'thoracic-mesothelioma', '', '1', @control_id),
('thoracic-other thoracic', 'thoracic-other thoracic', '', '1', @control_id),
('urinary tract-bladder', 'urinary tract-bladder', '', '1', @control_id),
('urinary tract-kidney', 'urinary tract-kidney', '', '1', @control_id),
('urinary tract-other urinary tract', 'urinary tract-other urinary tract', '', '1', @control_id),
('urinary tract-renal pelvis and ureter', 'urinary tract-renal pelvis and ureter', '', '1', @control_id),
('urinary tract-urethra', 'urinary tract-urethra', '', '1', @control_id),
('unknown', 'unknown', '', '1', @control_id);
ALTER TABLE dxd_secondaries ADD COLUMN qc_lady_tumor_site VARCHAR(100) DEFAULT NULL;
ALTER TABLE dxd_secondaries_revs ADD COLUMN qc_lady_tumor_site VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_secondaries', 'qc_lady_tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='qc_lady_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE diagnosis_controls SET flag_active = 0 WHERE controls_type = 'primary diagnosis unknown';


-- Fam. History


UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
ALTER TABLE family_histories ADD COLUMN qc_lady_tumor_site varchar(100) DEFAULT NULL;
ALTER TABLE family_histories_revs ADD COLUMN qc_lady_tumor_site varchar(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FamilyHistory', 'family_histories', 'qc_lady_tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_lady_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');


-- DATA BROWSER LINK


UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1;
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster');


-- Treatment


UPDATE structure_formats SET `flag_search`='0', `flag_index`='0',`flag_summary`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
-- Drug & Protocol
UPDATE treatment_controls SET flag_active = 1 WHERE tx_method IN ('chemotherapy', 'radiation');
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters%';
UPDATE menus SET flag_active = 1 WHERE use_link like '%Drug%';
UPDATE menus SET flag_active = 1 WHERE use_link like '/Protocol/ProtocolMasters%';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='tumour_group' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group') AND `flag_confidential`='0');
UPDATE protocol_controls SET flag_active=0 WHERE type != 'chemotherapy';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='tumour_group' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolExtend' AND `tablename`='pe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='pe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolExtend' AND `tablename`='pe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolExtend' AND `tablename`='pe_chemos' AND `field`='frequency' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- chemo
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='completed_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_batchedit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_batchedit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND `flag_confidential`='0');
-- radiation
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');
-- hormonotherapy
INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(null, 'all', 'hormonotherapy', 'qc_lady_pd_hormonos', 'qc_lady_pd_hormonos', 'qc_lady_pe_hormonos', 'qc_lady_pe_hormonos', NULL, 0, NULL, 0, 1);
CREATE TABLE IF NOT EXISTS `qc_lady_pd_hormonos` (
  `protocol_master_id` int(11) NOT NULL,
  KEY `FK_qc_lady_pd_hormonos_protocol_masters` (`protocol_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_pd_hormonos_revs` (
  `protocol_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_pd_hormonos`
  ADD CONSTRAINT `FK_qc_lady_pd_hormonos_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qc_lady_pe_hormonos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dose` varchar(50) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `protocol_master_id` int(11) NOT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_qc_lady_pe_hormonos_protocol_masters` (`protocol_master_id`),
  KEY `FK_qc_lady_pe_hormonos_drugs` (`drug_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `qc_lady_pe_hormonos_revs` (
  `id` int(11) NOT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `protocol_master_id` int(11) NOT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_pe_hormonos`
  ADD CONSTRAINT `FK_qc_lady_pe_hormonos_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  ADD CONSTRAINT `FK_qc_lady_pe_hormonos_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
INSERT INTO i18n (id,en,fr) VALUES ('hormonotherapy','Hormonotherapy','Hormonothérapie');
INSERT INTO structures(`alias`) VALUES ('qc_lady_pd_hormonos');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_pd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_pd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_pd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_pd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('qc_lady_pe_hormonos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Protocol', 'ProtocolExtend', 'qc_lady_pe_hormonos', 'dose', 'input',  NULL , '0', 'size=10', '', '', 'dose', ''), 
('Protocol', 'ProtocolExtend', 'qc_lady_pe_hormonos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', '', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_pe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtend' AND `tablename`='qc_lady_pe_hormonos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_pe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtend' AND `tablename`='qc_lady_pe_hormonos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'hormonotherapy', 'general', 1, 'qc_lady_txd_hormonos', 'qc_lady_txd_hormonos', 'qc_lady_txe_hormonos', 'qc_lady_txe_hormonos', 0, 1, 'importDrugFromHormonoProtocol', 'hormonotherapy', 0);
CREATE TABLE IF NOT EXISTS `qc_lady_txd_hormonos` (
  `completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `qc_lady_txd_hormonos_revs` (
  `completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_txd_hormonos`
  ADD CONSTRAINT `qc_lady_txd_hormonos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qc_lady_txe_hormonos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dose` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_qc_lady_txe_hormonos_drugs` (`drug_id`),
  KEY `FK_qc_lady_txe_hormonos_tx_masters` (`treatment_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `qc_lady_txe_hormonos_revs` (
  `id` int(11) NOT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_txe_hormonos`
  ADD CONSTRAINT `FK_qc_lady_txe_hormonos_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  ADD CONSTRAINT `qc_lady_txe_hormonos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_lady_txd_hormonos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_hormonos', 'completed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'completed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_hormonos', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', '', 'response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_hormonos' AND `field`='completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='completed' AND `language_tag`=''), '2', '11', 'hormonotherapy specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_hormonos' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE treatment_controls SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'hormonotherapy') WHERE tx_method = 'hormonotherapy';
INSERT INTO i18n (id,en,fr) VALUES ('hormonotherapy specific','Hormonotherapy Specific','Hormonothérapie spécifique');
INSERT INTO structures(`alias`) VALUES ('qc_lady_txe_hormonos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'qc_lady_txe_hormonos', 'dose', 'input',  NULL , '0', 'size=10', '', 'help_dose', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'qc_lady_txe_hormonos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='qc_lady_txe_hormonos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='qc_lady_txe_hormonos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '1', '0', '1', '0');
UPDATE `treatment_controls` SET extended_data_import_process = 'importDrugFromChemoProtocol' WHERE extended_data_import_process = 'importDrugFromHormonoProtocol';
ALTER TABLE qc_lady_pe_hormonos ADD COLUMN `method` varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_pe_hormonos_revs ADD COLUMN `method` varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_txe_hormonos ADD COLUMN `method` varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_txe_hormonos_revs ADD COLUMN `method` varchar(50) DEFAULT NULL;
-- surgery biopsy
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'surgery', 'general', 1, 'qc_lady_txd_biopsy_surgeries', 'qc_lady_txd_biopsy_surgeries,qc_lady_txd_patho_evaluations', null, null, 0, null, null, 'surgery', 1),
(null, 'biopsy', 'general', 1, 'qc_lady_txd_biopsy_surgeries', 'qc_lady_txd_biopsy_surgeries', null, null, 0, null, null, 'biopsy', 1);
CREATE TABLE IF NOT EXISTS qc_lady_txd_biopsy_surgeries (
 morphology varchar(50) DEFAULT NULL,
 topography varchar(50) DEFAULT NULL,
 laterality varchar(50) DEFAULT NULL,
 histological_grade varchar(10) DEFAULT NULL,
 	tumor_size_mm_x float(8,2) DEFAULT NULL,
 	tumor_size_mm_y float(8,2) DEFAULT NULL,
 	dimension_of_residual_tumor_bed_area_mm_x float(8,2) DEFAULT NULL,
 	dimension_of_residual_tumor_bed_area_mm_y float(8,2) DEFAULT NULL,
 	overal_cancer_cellularity_pct float(8,2) DEFAULT NULL,
 	in_situ_disease_pct float(8,2) DEFAULT NULL,
 	nbr_of_lymph_nodes_positive int(3) DEFAULT NULL,
 	largest_lymph_node_metastasis_diatmeter_mm float(8,2) DEFAULT NULL,
 	rcb_list varchar(10) DEFAULT NULL,
 	rcb_score float(8,2) DEFAULT NULL,
 ki67_pct float(8,2) DEFAULT NULL,
 ki67_ccl varchar(10) DEFAULT NULL,
 er_receptor_pct float(8,2) DEFAULT NULL,
 er_receptor_ccl varchar(10) DEFAULT NULL,
 pr_receptor_pct float(8,2) DEFAULT NULL,
 pr_receptor_ccl varchar(10) DEFAULT NULL,
 her2_receptor_ccl varchar(10) DEFAULT NULL,
 her2_receptor_score float(8,2) DEFAULT NULL,
 fish_ratio float(8,2) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `qc_lady_txd_biopsy_surgeries_revs` (
 morphology varchar(50) DEFAULT NULL,
 topography varchar(50) DEFAULT NULL,
 laterality varchar(50) DEFAULT NULL,
 histological_grade varchar(10) DEFAULT NULL,
 	tumor_size_mm_x float(8,2) DEFAULT NULL,
 	tumor_size_mm_y float(8,2) DEFAULT NULL,
 	dimension_of_residual_tumor_bed_area_mm_x float(8,2) DEFAULT NULL,
 	dimension_of_residual_tumor_bed_area_mm_y float(8,2) DEFAULT NULL,
 	overal_cancer_cellularity_pct float(8,2) DEFAULT NULL,
 	in_situ_disease_pct float(8,2) DEFAULT NULL,
 	nbr_of_lymph_nodes_positive int(3) DEFAULT NULL,
 	largest_lymph_node_metastasis_diatmeter_mm float(8,2) DEFAULT NULL,
 	rcb_list varchar(10) DEFAULT NULL,
 	rcb_score float(8,2) DEFAULT NULL,
 ki67_pct float(8,2) DEFAULT NULL,
 ki67_ccl varchar(10) DEFAULT NULL,
 er_receptor_pct float(8,2) DEFAULT NULL,
 er_receptor_ccl varchar(10) DEFAULT NULL,
 pr_receptor_pct float(8,2) DEFAULT NULL,
 pr_receptor_ccl varchar(10) DEFAULT NULL,
 her2_receptor_ccl varchar(10) DEFAULT NULL,
 her2_receptor_score float(8,2) DEFAULT NULL,
 fish_ratio float(8,2) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_txd_biopsy_surgeries`
  ADD CONSTRAINT `qc_lady_txd_biopsy_surgeries_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_positive_negative_result", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_positive_negative_result"), (SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_positive_negative_result"), (SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "4", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_positive_negative_equivocal_result", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("equivocal", "equivocal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_positive_negative_equivocal_result"), (SELECT id FROM structure_permissible_values WHERE value="equivocal" AND language_alias="equivocal"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_positive_negative_equivocal_result"), (SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_positive_negative_equivocal_result"), (SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "4", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_ki67", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES(">=10%",">=10%"),("<=10%","<=10%"),("not performed","not performed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_ki67"), (SELECT id FROM structure_permissible_values WHERE value=">=10%" AND language_alias=">=10%"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_ki67"), (SELECT id FROM structure_permissible_values WHERE value="<=10%" AND language_alias="<=10%"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_ki67"), (SELECT id FROM structure_permissible_values WHERE value="not performed" AND language_alias="not performed"), "6", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_histological_grade", "open", "", NULL);
INSERT IGNORE INTO  structure_permissible_values (value, language_alias) VALUES("X","X"),("1","1"),("2","2"),("3","3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="X" AND language_alias="X"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "6", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_rcb_list", "open", "", NULL);
INSERT IGNORE INTO  structure_permissible_values (value, language_alias) VALUES("X","X"),("1","1"),("2","2"),("3","3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="X" AND language_alias="X"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "6", "1");
INSERT INTO structure_value_domains (domain_name, source) VALUES ("qc_lady_morphology", "StructurePermissibleValuesCustom::getCustomDropdown(\'Morphology\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Morphology', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Morphology');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('lobular', 'Lobular', 'Lobulaire', '1', @control_id),
('ductal', 'Ductal', 'Canalaire', '1', @control_id);
INSERT INTO structure_value_domains (domain_name, source) VALUES ("qc_lady_topography", "StructurePermissibleValuesCustom::getCustomDropdown(\'Topography\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Topography', 1, 50);
INSERT INTO structures(`alias`) VALUES ('qc_lady_txd_biopsy_surgeries'), ('qc_lady_txd_patho_evaluations');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'morphology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_morphology') , '0', '', '', '', 'morphology', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'topography', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_topography') , '0', '', '', '', 'topography', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', '', 'laterality', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'histological_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_histological_grade') , '0', '', '', '', 'histological grade', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'tumor_size_mm_x', 'float_positive',  NULL , '0', '', '', '', 'tumor size (mm x mm)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'tumor_size_mm_y', 'float_positive',  NULL , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'dimension_of_residual_tumor_bed_area_mm_x', 'float_positive',  NULL , '0', '', '', '', 'dimension of residual tumor bed area (mm x mm)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'dimension_of_residual_tumor_bed_area_mm_y', 'float_positive',  NULL , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'overal_cancer_cellularity_pct', 'float_positive',  NULL , '0', '', '', '', 'overal cancer cellularity pct', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'in_situ_disease_pct', 'float_positive',  NULL , '0', '', '', '', 'in situ disease pct', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'nbr_of_lymph_nodes_positive', 'float_positive',  NULL , '0', '', '', '', 'nbr of lymph nodes positive', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'largest_lymph_node_metastasis_diatmeter_mm', 'float_positive',  NULL , '0', '', '', '', 'largest lymph node metastasis diatmeter mm', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'rcb_list', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_rcb_list') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'rcb_score', 'float_positive',  NULL , '0', '', '', '', 'rcb score', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'ki67_pct', 'float_positive',  NULL , '0', '', '', '', 'ki67 (pct)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'ki67_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_ki67') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'er_receptor_pct', 'float_positive',  NULL , '0', '', '', '', 'er receptor pct', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'er_receptor_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'pr_receptor_pct', 'float_positive',  NULL , '0', '', '', '', 'pr receptor pct', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'pr_receptor_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'her2_receptor_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_equivocal_result') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'her2_receptor_score', 'float_positive',  NULL , '0', '', '', '', 'her2 receptor score', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'fish_ratio', 'float_positive',  NULL , '0', '', '', '', 'fish ratio', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_morphology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='topography' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_topography')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='topography' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='histological_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_histological_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histological grade' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='tumor_size_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm x mm)' AND `language_tag`=''), '2', '110', 'primary tumor bed', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='tumor_size_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='dimension_of_residual_tumor_bed_area_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dimension of residual tumor bed area (mm x mm)' AND `language_tag`=''), '2', '112', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='dimension_of_residual_tumor_bed_area_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '113', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='overal_cancer_cellularity_pct' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='overal cancer cellularity pct' AND `language_tag`=''), '2', '114', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='in_situ_disease_pct' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='in situ disease pct' AND `language_tag`=''), '2', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='nbr_of_lymph_nodes_positive' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nbr of lymph nodes positive' AND `language_tag`=''), '2', '116', 'lymph nodes', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='largest_lymph_node_metastasis_diatmeter_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='largest lymph node metastasis diatmeter mm' AND `language_tag`=''), '2', '117', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='rcb_list'), '2', '119', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='rcb_score'), '2', '118', 'residual cancer burden', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='ki67_pct'), '2', '130', 'other markers', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='ki67_ccl'), '2', '131', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='er_receptor_pct'), '2', '132', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='er_receptor_ccl'), '2', '133', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='pr_receptor_pct'), '2', '134', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='pr_receptor_ccl'), '2', '135', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='her2_receptor_ccl'), '2', '137', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='her2_receptor_score'), '2', '136', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='fish_ratio'), '2', '139', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES
('histological grade','Histological Grade','Grade histologique'),
('X','X','X'),
('tumor size (mm x mm)','Tumor Size (mm*mm)','Taille tumeur (mm*mm)'),
('lymph nodes','Lymph Nodes','Ganglions lymphatiques'),
('nbr of lymph nodes positive', 'Number of positive lymph nodes', 'Nbr de ganglions lymphatiques positif'),
('rcb score','RCB Score','RCB Score'),
('equivocal','Equivocal','Ambigu'),
(">=10%",">=10",">=10"),("<=10%","<=10","<=10"),
('ki67 (pct)','Ki67 (&#37;)','Ki67 (&#37;)'),
('er receptor pct','ER (&#37;)','ER (&#37;)'),
('her2 receptor score','HER2 Score','HER2 Score'),
('pr receptor pct','PR (&#37;)','PR (&#37;)'),
('fish ratio','FISH','FISH'),
('other markers','Other Markers','Autres marqueurs');
INSERT IGNORE INTO i18n (id,en) VALUES
('primary tumor bed','Primary Tumor Bed'),
('dimension of residual tumor bed area (mm x mm)','Dimension of residual tumor bed area (mm*mm)'),
('overal cancer cellularity pct','Overal cancer cellularity (percentage of area)'),
('in situ disease pct','Percentage of cancer that is in situ disease'),
('largest lymph node metastasis diatmeter mm','Diatmeter of largest lymph node metastasis (mm)'),
('residual cancer burden','Residual Cancer Burden');
--
UPDATE treatment_controls SET databrowser_label = tx_method;


-- Event


UPDATE menus SET flag_active = 1 WHERE use_link like '/ClinicalAnnotation/EventMasters%' AND language_title = 'clinical';
SET @link = (SELECT use_link FROM menus WHERE use_link like '/ClinicalAnnotation/EventMasters%' AND language_title = 'clinical');
UPDATE menus SET use_link = @link WHERE use_link like '/ClinicalAnnotation/EventMasters%' AND language_title = 'annotation';
DROP TABLE qc_lady_screening_biopsy;
DROP TABLE qc_lady_screening_biopsy_revs;
DELETE FROM event_masters WHERE event_control_id = (SELECT id FROM event_controls WHERE detail_tablename = 'qc_lady_screening_biopsy');
DELETE FROM event_masters_revs WHERE event_control_id = (SELECT id FROM event_controls WHERE detail_tablename = 'qc_lady_screening_biopsy');
DELETE FROM event_controls WHERE detail_tablename = 'qc_lady_screening_biopsy';
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_lady_screening_biopsy');
DELETE FROM structure_fields WHERE tablename = 'qc_lady_screening_biopsy';
DELETE FROM structures WHERE alias = 'qc_lady_screening_biopsy';
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/EventMasters%' AND language_title = 'screening';
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'general', 'clinical', 'clinical evaluation', 1, 'qc_lady_clinical_evaluations', 'qc_lady_clinical_evaluations', 0, 'clinical evaluation', 0),
(null, 'general', 'clinical', 'imaging', 1, 'qc_lady_imagings', 'qc_lady_imagings', 0, 'imaging', 0);
CREATE TABLE IF NOT EXISTS `qc_lady_clinical_evaluations` (
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_clinical_evaluations_revs` (
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_clinical_evaluations`
  ADD CONSTRAINT `qc_lady_clinical_evaluations_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qc_lady_imagings` (
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_lady_imagings_revs` (
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_imagings`
  ADD CONSTRAINT `qc_lady_imagings_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
ALTER TABLE  qc_lady_imagings
 ADD COLUMN tumor_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_imagings_revs
 ADD COLUMN tumor_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_clinical_evaluations
 ADD COLUMN tumor_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_clinical_evaluations_revs
 ADD COLUMN tumor_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_mm_y float(8,2) DEFAULT NULL;	
INSERT INTO structures(`alias`) VALUES ('qc_lady_imagings');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'tumor_size_mm_x', 'float_positive',  NULL , '0', '', '', '', 'tumor size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'tumor_size_mm_y', 'float_positive',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm x mm)' AND `language_tag`=''), '2', '110', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('qc_lady_clinical_evaluations');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'tumor_size_mm_x', 'float_positive',  NULL , '0', '', '', '', 'tumor size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'tumor_size_mm_y', 'float_positive',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm x mm)' AND `language_tag`=''), '2', '110', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('clinical evaluation', 'Clinical Evalutaion', 'Évaluation clinique'),('imaging','Imaging','Imagerie'); 
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE event_controls SET databrowser_label = event_type ;


-- Creer plaque storage


INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'GQ plate 1A-12H', 'column', 'integer', 12, 'row', 'alphabetical', 8, 0, 0, 0, 0, 1, 0, 0, 0, 'storage_w_spaces', 'std_boxs', 'GQ plate 1A-12H', 1);
INSERT INTO i18n (id,en,fr) VALUES ('GQ plate 1A-12H','GQ Plate 1A-12H','GQ Plaque 1A-12H');
UPDATE storage_controls SET flag_active = 1 WHERE storage_type = 'GQ plate 1A-12H';
