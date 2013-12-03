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
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_has_family_history' AND `language_label`='has family history' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_has_family_history' AND `language_label`='has family history' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_has_family_history' AND `language_label`='has family history' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE participants DROP COLUMN qc_lady_has_family_history;
ALTER TABLE participants_revs DROP COLUMN qc_lady_has_family_history;


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
('breast-breast', 'Breast-Breast', '', '1', @control_id),
('central nervous system-brain', 'Central Nervous System-Brain', '', '1', @control_id),
('central nervous system-other central nervous system', 'Central Nervous System-Other Central Nervous System', '', '1', @control_id),
('central nervous system-spinal cord', 'Central Nervous System-Spinal Cord', '', '1', @control_id),
('digestive-anal', 'Digestive-Anal', '', '1', @control_id),
('digestive-appendix', 'Digestive-Appendix', '', '1', @control_id),
('digestive-bile ducts', 'Digestive-Bile Ducts', '', '1', @control_id),
('digestive-colonic', 'Digestive-Colonic', '', '1', @control_id),
('digestive-esophageal', 'Digestive-Esophageal', '', '1', @control_id),
('digestive-gallbladder', 'Digestive-Gallbladder', '', '1', @control_id),
('digestive-liver', 'Digestive-Liver', '', '1', @control_id),
('digestive-other digestive', 'Digestive-Other Digestive', '', '1', @control_id),
('digestive-pancreas', 'Digestive-Pancreas', '', '1', @control_id),
('digestive-rectal', 'Digestive-Rectal', '', '1', @control_id),
('digestive-small intestine', 'Digestive-Small Intestine', '', '1', @control_id),
('digestive-stomach', 'Digestive-Stomach', '', '1', @control_id),
('female genital-cervical', 'Female Genital-Cervical', '', '1', @control_id),
('female genital-endometrium', 'Female Genital-Endometrium', '', '1', @control_id),
('female genital-fallopian tube', 'Female Genital-Fallopian Tube', '', '1', @control_id),
('female genital-gestational trophoblastic neoplasia', 'Female Genital-Gestational Trophoblastic Neoplasia', '', '1', @control_id),
('female genital-other female genital', 'Female Genital-Other Female Genital', '', '1', @control_id),
('female genital-ovary', 'Female Genital-Ovary', '', '1', @control_id),
('female genital-peritoneal pelvis abdomen', 'Female Genital-Peritoneal Pelvis Abdomen', '', '1', @control_id),
('female genital-uterine', 'Female Genital-Uterine', '', '1', @control_id),
('female genital-vagina', 'Female Genital-Vagina', '', '1', @control_id),
('female genital-vulva', 'Female Genital-Vulva', '', '1', @control_id),
('haematological-hodgkin''s disease', 'Haematological-Hodgkin''s Disease', '', '1', @control_id),
('haematological-leukemia', 'Haematological-Leukemia', '', '1', @control_id),
('haematological-lymphoma', 'Haematological-Lymphoma', '', '1', @control_id),
('haematological-non-hodgkin''s lymphomas', 'Haematological-Non-Hodgkin''s Lymphomas', '', '1', @control_id),
('haematological-other haematological', 'Haematological-Other Haematological', '', '1', @control_id),
('head & neck-larynx', 'Head & Neck-Larynx', '', '1', @control_id),
('head & neck-lip and oral cavity', 'Head & Neck-Lip and Oral Cavity', '', '1', @control_id),
('head & neck-nasal cavity and sinuses', 'Head & Neck-Nasal Cavity and Sinuses', '', '1', @control_id),
('head & neck-other head & neck', 'Head & Neck-Other Head & neck', '', '1', @control_id),
('head & neck-pharynx', 'Head & Neck-Pharynx', '', '1', @control_id),
('head & neck-salivary glands', 'Head & Neck-Salivary Glands', '', '1', @control_id),
('head & neck-thyroid', 'Head & Neck-Thyroid', '', '1', @control_id),
('musculoskeletal sites-bone', 'Musculoskeletal Sites-Bone', '', '1', @control_id),
('musculoskeletal sites-other bone', 'Musculoskeletal Sites-Other Bone', '', '1', @control_id),
('musculoskeletal sites-soft tissue sarcoma', 'Musculoskeletal Sites-Soft Tissue Sarcoma', '', '1', @control_id),
('ophthalmic-eye', 'Ophthalmic-Eye', '', '1', @control_id),
('ophthalmic-other eye', 'Ophthalmic-Other Eye', '', '1', @control_id),
('other-gross metastatic disease', 'Other-Gross Metastatic Disease', '', '1', @control_id),
('other-primary unknown', 'Other-Primary Unknown', '', '1', @control_id),
('skin-melanoma', 'Skin-Melanoma', '', '1', @control_id),
('skin-non melanomas', 'Skin-Non Melanomas', '', '1', @control_id),
('skin-other skin', 'Skin-Other Skin', '', '1', @control_id),
('thoracic-lung', 'Thoracic-Lung', '', '1', @control_id),
('thoracic-mesothelioma', 'Thoracic-Mesothelioma', '', '1', @control_id),
('thoracic-other thoracic', 'Thoracic-Other Thoracic', '', '1', @control_id),
('urinary tract-bladder', 'Urinary Tract-Bladder', '', '1', @control_id),
('urinary tract-kidney', 'Urinary Tract-Kidney', '', '1', @control_id),
('urinary tract-other urinary tract', 'Urinary Tract-Other Urinary Tract', '', '1', @control_id),
('urinary tract-renal pelvis and ureter', 'Urinary Tract-Renal Pelvis and Ureter', '', '1', @control_id),
('urinary tract-urethra', 'Urinary Tract-Urethra', '', '1', @control_id),
('unknown', 'Unknown', '', '1', @control_id);
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
ALTER TABLE family_histories
  CHANGE qc_lady_breast_or_ovarian_cancer qc_lady_breast_cancer char(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_lady_ovarian_cancer char(1) NOT NULL DEFAULT '';
ALTER TABLE family_histories_revs
  CHANGE qc_lady_breast_or_ovarian_cancer qc_lady_breast_cancer char(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_lady_ovarian_cancer char(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FamilyHistory', 'family_histories', 'qc_lady_ovarian_cancer', 'yes_no',  NULL , '0', '', '', '', 'ovarian cancer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_lady_ovarian_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovarian cancer' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `field`='qc_lady_breast_cancer', `language_label`='breast cancer' WHERE model='FamilyHistory' AND tablename='family_histories' AND field='qc_lady_breast_or_ovarian_cancer' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en,fr) values ('ovarian cancer', 'Ovarian Cancer', 'Cancer de l''ovaire'), ('breast cancer', 'Breast Cancer', 'Cancer du sein');


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
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_histological_grade", "open", "", NULL);
INSERT IGNORE INTO  structure_permissible_values (value, language_alias) VALUES("X","X"),("1","1"),("2","2"),("3","3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="X" AND language_alias="X"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_histological_grade"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "6", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_rcb_list", "open", "", NULL);
INSERT IGNORE INTO  structure_permissible_values (value, language_alias) VALUES("X","X"),("1","1"),("2","2"),("3","3"),("0","0");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="X" AND language_alias="X"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_rcb_list"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "4", "1");
INSERT INTO structure_value_domains (domain_name, source) VALUES ("qc_lady_morphology", "StructurePermissibleValuesCustom::getCustomDropdown(\'Morphology\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Morphology', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Morphology');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('IDC', '', '', '1', @control_id),
('ILC', '', '', '1', @control_id),
('AdnoC', '', '', '1', @control_id);
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
INSERT INTO i18n (id,en,fr) VALUES ('clinical evaluation', 'Clinical Evaluation', 'Évaluation clinique'),('imaging','Imaging','Imagerie'); 
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE event_controls SET databrowser_label = event_type ;


-- Creer plaque storage


INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'GQ plate 1A-12H', 'column', 'integer', 12, 'row', 'alphabetical', 8, 0, 0, 0, 0, 1, 0, 0, 0, 'storage_w_spaces', 'std_boxs', 'GQ plate 1A-12H', 1);
INSERT INTO i18n (id,en,fr) VALUES ('GQ plate 1A-12H','GQ Plate 1A-12H','GQ Plaque 1A-12H');
UPDATE storage_controls SET flag_active = 1 WHERE storage_type = 'GQ plate 1A-12H';


-- ------------------------------------------------------------------------------------------------------------------------
--
-- ------------------------------------------------------------------------------------------------------------------------


UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_lady_breast_cancer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES('vital status mismatch', 'Vital status mismatch', 'Disparité de statut vital');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='operation_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='blood collection and access clinical data' WHERE model='ConsentDetail' AND tablename='cd_nationals' AND field='qc_lady_allow_blood_collection' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en,fr) VALUES('blood collection and access clinical data', 'Bood collection and access clinical data', 'Collecte de sang et accès données cliniques');
SELECT 'Que faire avec le données de chirurgie du consentement? Va t''on les perdre?' AS MSG;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters DROP COLUMN qc_lady_path_stage_summary_at_dx;
ALTER TABLE diagnosis_masters_revs DROP COLUMN qc_lady_path_stage_summary_at_dx;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_path_stage_summary_at_dx' AND `language_label`='pathological stage at diagnosis' AND `language_tag`='' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_path_stage_summary_at_dx' AND `language_label`='pathological stage at diagnosis' AND `language_tag`='' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_path_stage_summary_at_dx' AND `language_label`='pathological stage at diagnosis' AND `language_tag`='' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters 
  ADD COLUMN `qc_lady_clinical_stage_update_date` date DEFAULT NULL,
  ADD COLUMN `qc_lady_clinical_stage_update_date_accuracy`  char(1) NOT NULL DEFAULT '';
ALTER TABLE diagnosis_masters_revs 
  ADD COLUMN `qc_lady_clinical_stage_update_date` date DEFAULT NULL,
  ADD COLUMN `qc_lady_clinical_stage_update_date_accuracy`  char(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_lady_clinical_stage_update_date', 'date',  NULL , '0', '', '', '', 'clinical stage date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_clinical_stage_update_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage date' AND `language_tag`=''), '2', '18', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='32' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='33' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_clinical_stage_update_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='24' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_lady_clinical_stage_summary_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('clinical stage date', 'Clinical Stage Date', 'Date du stade clinique');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE diagnosis_controls SET detail_form_alias = 'dx_primary,qc_lady_dx_breasts' WHERE detail_form_alias = 'qc_lady_dx_breasts';
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="histology" AND language_alias="histology");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="cytology" AND language_alias="cytology");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="surgical" AND language_alias="surgical");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="endoscopy" AND language_alias="endoscopy");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="autopsy" AND language_alias="autopsy");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="death certificate" AND language_alias="death certificate");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="radio/lab" AND language_alias="radio/lab");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='dx_method' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="surgical/clinical" AND language_alias="surgical/clinical");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dx_method"), (SELECT id FROM structure_permissible_values WHERE value="pathology" AND language_alias="pathology"), "", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_dx_laterality", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_dx_laterality"), (SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_dx_laterality"), (SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_dx_laterality"), (SELECT id FROM structure_permissible_values WHERE value="not applicable" AND language_alias="not applicable"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_dx_laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "3", "1");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dx_laterality')  WHERE model='DiagnosisDetail' AND tablename='qc_lady_dxd_breasts' AND field='laterality' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='laterality');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dx_laterality')  WHERE model='DiagnosisDetail' AND tablename='qc_lady_dxd_breasts' AND field='laterality' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='laterality');
UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES 
('age at diagnosis has been calculated with at least one unaccuracy date','Age at diagnosis has been calculated with at least one unaccuracy date'),
('unable to calculate age at diagnosis','Unable to calculate age at diagnosis');

ALTER TABLE qc_lady_txd_biopsy_surgeries
	ADD COLUMN path_tstage varchar(5) DEFAULT NULL,
	ADD COLUMN path_nstage varchar(5) DEFAULT NULL,
	ADD COLUMN path_mstage varchar(5) DEFAULT NULL,
	ADD COLUMN path_stage_summary varchar(5) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs
	ADD COLUMN path_tstage varchar(5) DEFAULT NULL,
	ADD COLUMN path_nstage varchar(5) DEFAULT NULL,
	ADD COLUMN path_mstage varchar(5) DEFAULT NULL,
	ADD COLUMN path_stage_summary varchar(5) DEFAULT NULL;	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_lady_txd_biopsy_surgeries', 'path_tstage', 'input',  NULL , '0', 'size=1,maxlength=3', '', '', 'pathological stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_lady_txd_biopsy_surgeries', 'path_nstage', 'input',  NULL , '0', 'size=1,maxlength=3', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_lady_txd_biopsy_surgeries', 'path_mstage', 'input',  NULL , '0', 'size=1,maxlength=3', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_lady_txd_biopsy_surgeries', 'path_stage_summary', 'input',  NULL , '0', 'size=1, maxlength=3', '', 'help_path_stage_summary', '', 'summary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '102', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1, maxlength=3' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '103', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='staging' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `model`='TreatmentDetail' WHERE model='DiagnosisDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='path_tstage' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='TreatmentDetail' WHERE model='DiagnosisDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='path_nstage' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='TreatmentDetail' WHERE model='DiagnosisDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='path_mstage' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='TreatmentDetail' WHERE model='DiagnosisDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='path_stage_summary' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE menus SET language_title = 'treatment/procedure' WHERE id = 'clin_CAN_75';
UPDATE menus SET language_title = 'treatment/procedure detail' WHERE id = 'clin_CAN_79';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('treatment/procedure', 'Treatment / Procedure', 'Traitement / Procédure'),('treatment/procedure detail','Detail','Détail');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/lifestyle%';
UPDATE event_controls SET flag_active = 0 WHERE event_type = 'smoking';

ALTER TABLE  qc_lady_imagings
 ADD COLUMN lymph_node_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_imagings_revs
 ADD COLUMN lymph_node_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_clinical_evaluations
 ADD COLUMN lymph_node_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_clinical_evaluations_revs
 ADD COLUMN lymph_node_size_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_mm_y float(8,2) DEFAULT NULL;	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'lymph_node_size_mm_x', 'float_positive',  NULL , '0', '', '', '', 'lymph node size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'lymph_node_size_mm_y', 'float_positive',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node size (mm x mm)' AND `language_tag`=''), '2', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '116', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'lymph_node_size_mm_x', 'float_positive',  NULL , '0', '', '', '', 'lymph node size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'lymph_node_size_mm_y', 'float_positive',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node size (mm x mm)' AND `language_tag`=''), '2', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '116', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('lymph node size (mm x mm)','Lymph Node Size (mm*mm)','Taille ganglions lymphatique (mm*mm)');
UPDATE structure_fields SET  `language_tag`='X' WHERE model='EventDetail' AND field='tumor_size_mm_y' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_tag`='X' WHERE model='EventDetail' AND field='lymph_node_size_mm_y' AND `type`='float_positive' AND structure_value_domain  IS NULL ;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_hormonos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_hormonos' AND `field`='response' AND `language_label`='response' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='response') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_hormonos' AND `field`='response' AND `language_label`='response' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='response') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_hormonos' AND `field`='response' AND `language_label`='response' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='response') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE qc_lady_txd_hormonos DROP COLUMN response;
ALTER TABLE qc_lady_txd_hormonos_revs DROP COLUMN response;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='response');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', '', 'response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '2', '130', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE qc_lady_imagings ADD COLUMN `response` varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_imagings_revs ADD COLUMN `response` varchar(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', '', 'response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '2', '130', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE qc_lady_clinical_evaluations ADD COLUMN `response` varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_clinical_evaluations_revs ADD COLUMN `response` varchar(50) DEFAULT NULL;

ALTER TABLE qc_lady_imagings ADD COLUMN `type` varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_imagings_revs ADD COLUMN `type` varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qc_lady_imagings_types', "StructurePermissibleValuesCustom::getCustomDropdown(\'Imaging Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Imaging Types', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Imaging Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('PET-Scan', '', '', '1', @control_id),
('CT-Scan', '', '', '1', @control_id),
('ultrasound','Ultrasound','ultrason', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_imagings_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_imagings_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '90', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `display_order`='138', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='ki67_pct' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other markers' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='er_receptor_pct' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='140' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='fish_ratio' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN `ki67_not_performed` tinyint(1) DEFAULT '0';
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN `ki67_not_performed` tinyint(1) DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'ki67_not_performed', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'not performed', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='ki67_not_performed' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='not performed' AND `language_tag`=''), '2', '139', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN fish_ccl varchar(10) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN fish_ccl varchar(10) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'fish_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='fish_ccl' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '141', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE event_masters ADD COLUMN qc_lady_clinic_imaging_laterality varchar(50) NOT NULL DEFAULT '';
ALTER TABLE event_masters_revs ADD COLUMN qc_lady_clinic_imaging_laterality varchar(50) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'qc_lady_clinic_imaging_laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', '', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='qc_lady_clinic_imaging_laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '2', '105', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='qc_lady_clinic_imaging_laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '2', '105', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE treatment_masters ADD COLUMN qc_lady_laterality varchar(50) DEFAULT NULL;
ALTER TABLE treatment_masters_revs ADD COLUMN qc_lady_laterality varchar(50) DEFAULT NULL;
ALTER TABLE  qc_lady_txd_biopsy_surgeries DROP COLUMN laterality;
ALTER TABLE  qc_lady_txd_biopsy_surgeries_revs DROP COLUMN laterality;
UPDATE structure_fields SET  `field`='qc_lady_laterality',  `model`='TreatmentMaster',  `tablename`='treatment_masters',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='laterality' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='laterality');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ,  `language_label`='',  `language_tag`='not performed' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='ki67_not_performed' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'lymph_node_collection', 'yes_no',  NULL , '0', '', '', '', 'collected', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'lymph_node_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='lymph_node_collection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collected' AND `language_tag`=''), '2', '120', 'lymph nodes', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='lymph_node_ccl' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_result')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '121', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='122', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='nbr_of_lymph_nodes_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='123' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='largest_lymph_node_metastasis_diatmeter_mm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='125' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='rcb_score' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='126' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='rcb_list' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_rcb_list') AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('collected', 'Collected', 'Collecté');
ALTER TABLE qc_lady_txd_biopsy_surgeries
 ADD COLUMN lymph_node_collection char(1) default '',
 ADD COLUMN lymph_node_ccl varchar(10) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs
 ADD COLUMN lymph_node_collection char(1) default '',
 ADD COLUMN lymph_node_ccl varchar(10) DEFAULT NULL;

ALTER TABLE qc_lady_txd_biopsy_surgeries
 ADD COLUMN patho_nbr varchar(20) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs
 ADD COLUMN patho_nbr varchar(20) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'patho_nbr', 'input',  NULL , '0', 'size=20', '', '', 'patho report number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='patho report number' AND `language_tag`=''), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('patho report number','Patho #','# Patho');

ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN morphology_precision varchar(50) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN morphology_precision varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) VALUES ("qc_lady_morphology_2", "StructurePermissibleValuesCustom::getCustomDropdown(\'Morphology Precision\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Morphology Precision', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Morphology Precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('DCIS', '', '', '1', @control_id),
('LobCIS', '', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'morphology_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_morphology_2') , '0', '', '', '', '', ' ');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='morphology_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_morphology_2')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=' '), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET `language_tag`='+' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='morphology_precision' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_morphology_2');
INSERT INTO i18n (id,en,fr) VALUES ('+', '+', '+');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('diagnosis, treatments and/or events lateralities mismatch', 
'There are some mismatches between the diagnosis laterality and the lateralities of some treatments and/or annotations',
'Il ya des discordances entre la latéralité du diagnostic et celles des traitements et/ou des annotations');

UPDATE structure_formats SET `flag_index`='0', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field` IN ('icd10_code', 'topography'));

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ---------------------------------------

UPDATE structure_fields SET  `type`='integer_positive' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='er_receptor_pct' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='integer_positive' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='pr_receptor_pct' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='input',  `setting`='size=5' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='her2_receptor_score' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='integer_positive' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='ki67_pct' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='receptors' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='er_receptor_pct' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='142' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='ki67_not_performed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
ALTER TABLE qc_lady_txd_biopsy_surgeries 
	MODIFY her2_receptor_score varchar(20) DEFAULT NULL,
	MODIFY fish_ratio float(8,1) DEFAULT NULL,
	MODIFY er_receptor_pct int(8) DEFAULT NULL,
	MODIFY pr_receptor_pct int(8) DEFAULT NULL,
	MODIFY ki67_pct int(8) DEFAULT NULL;
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs
	MODIFY her2_receptor_score varchar(20) DEFAULT NULL,
	MODIFY fish_ratio float(8,1) DEFAULT NULL,
	MODIFY er_receptor_pct int(8) DEFAULT NULL,
	MODIFY pr_receptor_pct int(8) DEFAULT NULL,
	MODIFY ki67_pct int(8) DEFAULT NULL;
INSERT INTO i18n(id,en,fr) VALUES ('receptors','Receptors','Récepteurs');	
UPDATE structure_formats SET `display_order`='145' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='ki67_pct' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='146' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='ki67_not_performed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
ALTER TABLE qc_lady_txd_biopsy_surgeries MODIFY `ki67_not_performed` char(1) DEFAULT '';
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs MODIFY `ki67_not_performed` char(1) DEFAULT '';
UPDATE qc_lady_txd_biopsy_surgeries SET ki67_not_performed = 'y' WHERE ki67_not_performed = '1';
UPDATE qc_lady_txd_biopsy_surgeries SET ki67_not_performed = 'n' WHERE ki67_not_performed != 'y';
UPDATE structure_fields SET field='ki67_performed', `type`='yes_no',  `structure_value_domain`= NULL ,  `language_tag`='performed' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='ki67_not_performed' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
ALTER TABLE qc_lady_txd_biopsy_surgeries CHANGE COLUMN `ki67_not_performed` ki67_performed char(1) DEFAULT '';
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs CHANGE COLUMN `ki67_not_performed` ki67_performed char(1) DEFAULT '';
INSERT INTO i18n (id,en) VALUES ('performed','Performed');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_lady_tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');




