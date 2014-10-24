-- Tx --

UPDATE treatment_controls SET disease_site = '', databrowser_label = tx_method WHERE flag_active = 1;

-- EVENT --

UPDATE event_controls SET disease_site = '', databrowser_label = event_type, flag_use_for_ccl = '0' WHERE flag_active = 1;
UPDATE event_controls SET use_addgrid = 1 WHERE flag_active = 1 AND event_type != 'brca';
UPDATE event_controls SET use_detail_form_for_index = 1 WHERE flag_active = 1;
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_vital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ca125s') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_ca125s' AND `field`='ca125' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ca125s'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '0', '1', 'test date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
REPLACE INTO i18n (id,en) VALUES ('follow-up date can not be empty','Follow-up date can not be empty');
ALTER TABLE ovcare_ed_brcas_revs DROP INDEX event_master_id;
ALTER TABLE ovcare_ed_ca125s_revs DROP INDEX event_master_id;
ALTER TABLE ovcare_ed_study_inclusions_revs DROP INDEX event_master_id;

-- Dx --

ALTER TABLE ovcare_dxd_others MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ovcare_dxd_ovaries MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ovcare_dxd_ovaries DROP COLUMN deleted;
ALTER TABLE ovcare_dxd_others_revs MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ovcare_dxd_ovaries_revs MODIFY diagnosis_master_id int(11) NOT NULL;

-- COLLECTION --

ALTER TABLE collections_revs DROP INDEX collection_voa_nbr;

-- SAMPLE --

ALTER TABLE sd_spe_salivas_revs DROP INDEX sample_master_id;
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(190); -- Saliva

-- OTHER.... --

UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';

UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Collection Types' WHERE name = 'ovcare collection types';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Tissue Sources' WHERE name = 'ovcare tissue sources';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'DNA/RNA Extraction Methods' WHERE name = 'ovcare dna rna extraction methods';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'DNA/RNA Enzyme Treatments' WHERE name = 'ovcare dna rna enzyme txs';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Tissue Tube Storage Methods' WHERE name = 'ovcare tissue tube storage methods';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Collection Types\')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare collection types\')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Sources\')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare tissue sources\')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'DNA/RNA Extraction Methods\')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown(\'dna rna extraction methods\')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'DNA/RNA Enzyme Treatments\')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown(\'dna rna enzyme txs\')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Tube Storage Methods\')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare tissue tube storage methods\')";
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE name = 'Vital Status';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery Type' WHERE name LIKE 'Surgery type';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Biopsy Type' WHERE name LIKE 'Biopsy Type';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Tissue Types' WHERE name LIKE 'Tissue Types';
UPDATE structure_permissible_values_custom_controls SET category = 'study / project' WHERE name LIKE 'Study Status';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Surgery Type\')" WHERE source LIKE "StructurePermissibleValuesCustom::getCustomDropdown%Surgery Type%";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy Type\')" WHERE source LIKE "StructurePermissibleValuesCustom::getCustomDropdown%Biopsy Type%";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Types\')" WHERE source LIKE "StructurePermissibleValuesCustom::getCustomDropdown%Tissue Types%";
DELETE FROM structure_value_domains WHERE source LIKE '%Sample Test %';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Sample Test Status');
DELETE FROM structure_permissible_values_customs WHERE control_id =  @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'Sample Test Status';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Sample Test Types');
DELETE FROM structure_permissible_values_customs WHERE control_id =  @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'Sample Test Types';

-- Report

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'medical_record_number', 'input',  NULL , '1', 'size=20', '', '', 'medical record number', ''), 
('Datamart', '0', '', 'personal_health_number', 'input',  NULL , '1', 'size=20', '', '', 'personal health number', ''), 
('Datamart', '0', '', 'bcca_number', 'input',  NULL , '1', 'size=20', '', '', 'bcca number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='medical_record_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='medical record number' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='personal_health_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='personal health number' AND `language_tag`=''), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bcca_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bcca number' AND `language_tag`=''), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='BR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='PR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='hospital_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'collection_voa_nbr', 'input',  NULL , '0', 'size=20', '', '', 'VOA#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='collection_voa_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='VOA#' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='collection_voa_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='VOA#' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='collection_voa_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='VOA#' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'collection_voa_nbr', 'input',  NULL , '0', 'size=20', '', '', 'VOA#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='collection_voa_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='VOA#' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- --------------------------------------------------------------------------------------------------------------------------------
-- NEW DESIGN BASED ON LAST FILE-MAKER APP CHANGES
-- --------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE ovcare_dxd_ovaries
  DROP COLUMN histo_type_adenocarcinoma                 ,
  DROP COLUMN histo_type_carcinoma                      ,
  DROP COLUMN histo_type_carcinosarcoma_mmmt            ,
  DROP COLUMN histo_type_brenner_tumour                 ,
  DROP COLUMN histo_type_clear_cell                     ,
  DROP COLUMN histo_type_cystadenocarcinoma             ,
  DROP COLUMN histo_type_cystadenoma                    ,
  DROP COLUMN histo_type_endometrioid_borderline        ,
  DROP COLUMN histo_type_endometrioid                   ,
  DROP COLUMN histo_type_granulosa_cell_tumour_adult    ,
  DROP COLUMN histo_type_granulosa_cell_tumour_juvenile ,
  DROP COLUMN histo_type_GIST                           ,
  DROP COLUMN histo_type_mixed                          ,
  DROP COLUMN histo_type_mucinous                       ,
  DROP COLUMN histo_type_mucinous_borderline            ,
  DROP COLUMN histo_type_serous                         ,
  DROP COLUMN histo_type_serous_borderline              ,
  DROP COLUMN histo_type_other                          ,
  DROP COLUMN histo_type_undifferentiated               ,
  DROP COLUMN histological_other_specification          ;
ALTER TABLE ovcare_dxd_ovaries_revs
  DROP COLUMN histo_type_adenocarcinoma                 ,
  DROP COLUMN histo_type_carcinoma                      ,
  DROP COLUMN histo_type_carcinosarcoma_mmmt            ,
  DROP COLUMN histo_type_brenner_tumour                 ,
  DROP COLUMN histo_type_clear_cell                     ,
  DROP COLUMN histo_type_cystadenocarcinoma             ,
  DROP COLUMN histo_type_cystadenoma                    ,
  DROP COLUMN histo_type_endometrioid_borderline        ,
  DROP COLUMN histo_type_endometrioid                   ,
  DROP COLUMN histo_type_granulosa_cell_tumour_adult    ,
  DROP COLUMN histo_type_granulosa_cell_tumour_juvenile ,
  DROP COLUMN histo_type_GIST                           ,
  DROP COLUMN histo_type_mixed                          ,
  DROP COLUMN histo_type_mucinous                       ,
  DROP COLUMN histo_type_mucinous_borderline            ,
  DROP COLUMN histo_type_serous                         ,
  DROP COLUMN histo_type_serous_borderline              ,
  DROP COLUMN histo_type_other                          ,
  DROP COLUMN histo_type_undifferentiated               ,
  DROP COLUMN histological_other_specification          ;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field` LIKE 'histo_type_%');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field` LIKE 'histological_other_specification');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field` LIKE 'histo_type_%');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field` LIKE 'histological_other_specification');
DELETE FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field` LIKE 'histo_type_%';
DELETE FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field` LIKE 'histological_other_specification';

ALTER TABLE ovcare_dxd_ovaries
  ADD COLUMN ovarian_histology varchar(100),
  ADD COLUMN uterine_histology varchar(100);
ALTER TABLE ovcare_dxd_ovaries_revs
  ADD COLUMN ovarian_histology varchar(100),
  ADD COLUMN uterine_histology varchar(100); 
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('ovcare_ovarian_histology', "StructurePermissibleValuesCustom::getCustomDropdown(\'Ovarian Histology\')"),
('ovcare_uterine_histology', "StructurePermissibleValuesCustom::getCustomDropdown(\'Uterine Histology\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Ovarian Histology', 'clinical - diagnosis', '100'), 
('Uterine Histology', 'clinical - diagnosis', '100');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'ovcare_dxd_ovaries', 'ovarian_histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'ovcare_dxd_ovaries', 'uterine_histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='ovarian_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '60', 'histology', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='uterine_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '61', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') ,  `language_label`='ovarian' WHERE model='DiagnosisDetail' AND tablename='ovcare_dxd_ovaries' AND field='ovarian_histology' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') ,  `language_label`='uterine' WHERE model='DiagnosisDetail' AND tablename='ovcare_dxd_ovaries' AND field='uterine_histology' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology');
INSERT INTO i18n (id,en) VALUES ('ovarian', 'Ovarian'), ('uterine', 'Uterine');

UPDATE users SET username = 'NicoEn', first_name = 'Nicolas', last_name = 'L', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 1;
UPDATE users SET username = 'migration', first_name = 'migration', last_name = 'migration', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 0 WHERE id = 2;
UPDATE groups SET name = 'System' WHERE id = 2;
UPDATE users SET flag_active = 0 WHERE id IN (2,3);
UPDATE users SET flag_active = 1 WHERE id IN (1);

UPDATE structure_formats SET `display_column`='1', `display_order`='7', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `display_order`='30', `language_heading`='coding' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='51' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='52' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='53' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='54' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='55' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='56' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='57' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

update diagnosis_controls SET controls_type = 'ovary or endometrium', detail_form_alias = 'dx_primary,ovcare_dx_ovaries_endometriums', detail_tablename = 'ovcare_dxd_ovaries_endometriums' WHERE flag_active = 1 AND controls_type = 'ovary';
INSERT INTO i18n (id,en) VALUES ('ovary or endometrium', 'Ovary or Endometrium');
update diagnosis_controls SET databrowser_label = CONCAT(category,'|',controls_type); 
UPDATE structure_fields SET tablename = 'ovcare_dxd_ovaries_endometriums' WHERE tablename = 'ovcare_dxd_ovaries';
UPDATE structures SET alias = 'ovcare_dx_ovaries_endometriums' WHERE alias = 'ovcare_dx_ovaries';
INSERT INTO i18n (id,en) VALUES ('wrong selected tumor site','Wrong selected tumor site');
update diagnosis_controls SET controls_type = 'all' WHERE flag_active = 1 AND controls_type = 'other' AND category = 'secondary';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `language_label`='clinical history' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `language_label`='clinical diagnosis' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
RENAME TABLE ovcare_dxd_ovaries TO ovcare_dxd_ovaries_endometriums;
RENAME TABLE ovcare_dxd_ovaries_revs TO ovcare_dxd_ovaries_endometriums_revs;

ALTER TABLE diagnosis_masters ADD COLUMN ovcare_path_review_type varchar(100) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs ADD COLUMN ovcare_path_review_type varchar(100) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ovcare_path_review_type", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Path Review Type\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, category, values_max_length) VALUES ('Path Review Type', 1, 'annotation - diagnosis', 100);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'ovcare_path_review_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type') , '0', '', '', '', 'path review type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_path_review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path review type' AND `language_tag`=''), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('path review type', 'Path Review Type'); 
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_path_review_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type') AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-92' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `language_label`='clinical stage' AND `language_tag`='t stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-93' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `language_label`='' AND `language_tag`='n stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-94' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `language_label`='' AND `language_tag`='m stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-95' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_clinical_stage_summary' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-97' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `language_label`='pathological stage' AND `language_tag`='t stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-98' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `language_label`='' AND `language_tag`='n stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-99' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `language_label`='' AND `language_tag`='m stage' AND `type`='input' AND `setting`='size=1,maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-100' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `language_label`='' AND `language_tag`='summary' AND `type`='input' AND `setting`='size=1, maxlength=3' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_path_stage_summary' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES
('selected tumor site should be different than ovary or endometrium', 'Selected tumor site should be different than ovary or endometrium.'),
('either ovary or endometrium tumor site should be selected', 'Either ovary or endometrium tumor site should be selected');

UPDATE diagnosis_controls SET controls_type = 'ovary or endometrium tumor' WHERE controls_type = 'ovary or endometrium';
INSERT INTO i18n (id,en) VALUES ('ovary or endometrium tumor', 'Ovary or Endometrium Tumor');

UPDATE event_controls SET event_group = 'clinical' WHERE event_type = 'ca125';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/lab%';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='2_3_grading_other_specification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_unknown_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical history' AND `language_tag`=''), '2', '20', 'summary', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_unknown_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical diagnosis' AND `language_tag`=''), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_path_review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path review type' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_unknown_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `language_label`='clinical diagnosis' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical diagnosis' AND `language_tag`=''), '2', '21', 'summary', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE storage_masters MODIFY `short_label` varchar(20) DEFAULT NULL;
ALTER TABLE storage_masters_revs MODIFY `short_label` varchar(20) DEFAULT NULL;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='1200', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Sources');
INSERT INTO `structure_permissible_values_customs` (`value`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('cecum', '1', @control_id, NOW(), NOW(), 1, 1),
('fallopian tube and fimbraie', '1', @control_id, NOW(), NOW(), 1, 1),
('fimbraie', '1', @control_id, NOW(), NOW(), 1, 1),
('groin', '1', @control_id, NOW(), NOW(), 1, 1),
('intra abdominal', '1', @control_id, NOW(), NOW(), 1, 1),
('intraperitoneum', '1', @control_id, NOW(), NOW(), 1, 1),
('myometrium', '1', @control_id, NOW(), NOW(), 1, 1),
('rectum', '1', @control_id, NOW(), NOW(), 1, 1),
('umbilical hernia', '1', @control_id, NOW(), NOW(), 1, 1),
('ureter', '1', @control_id, NOW(), NOW(), 1, 1),
('uterosacrel', '1', @control_id, NOW(), NOW(), 1, 1),
('vaginal Exudate', '1', @control_id, NOW(), NOW(), 1, 1);

update treatment_extend_controls SET type = 'biopsy procedure', databrowser_label = 'biopsy procedure' where detail_tablename = 'ovcare_txe_biopsies';
INSERT INTO i18n (id,en) VALUES ('biopsy procedure','Biopsy Procedure');

ALTER TABLE txd_surgeries MODIFY ovcare_residual_disease varchar(15) default null;
ALTER TABLE txd_surgeries_revs MODIFY ovcare_residual_disease varchar(15) default null;

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Sources');
UPDATE structure_permissible_values_customs set value = 'small intestine' WHERE value = 'small intestin' and control_id = @control_id ;

INSERT INTO i18n (id,en) VALUES ('tissue review', 'Tissue Review');

UPDATE structure_permissible_values_customs SET value = 'uterine cervix' WHERE value = 'uterine cervix ';
UPDATE structure_permissible_values_customs SET value = 'omentum' WHERE value = 'omentum ';

UPDATE treatment_controls SET tx_method = 'procedure - surgery and biopsy' WHERE tx_method = 'procedure - surgery';
UPDATE treatment_controls SET flag_active = 0 WHERE tx_method = 'procedure - biopsy';
UPDATE treatment_extend_controls SET flag_active = 0 WHERE databrowser_label like '%biopsy%';
UPDATE treatment_controls SET databrowser_label = tx_method;
INSERT INTO i18n (id,en) VALUES ('procedure - surgery and biopsy','Procedure - Surgery and Biopsy');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("female genital-ovary and endometrium", "female genital-ovary and endometrium");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_tumor_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-ovary and endometrium" AND language_alias="female genital-ovary and endometrium"), "", "1");
INSERT INTO i18n (id,en)  VALUES("female genital-ovary and endometrium", "Female Genital-Ovary and Endometrium");

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'rack14', 'position', 'integer', 14, NULL, NULL, NULL, 1, 14, 0, 0, 1, 0, 0, 1, '', 'std_racks', 'custom#storage types#rack14', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('rack14', 'Rack 14', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("macroscopic", "macroscopic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_residual_disease"), (SELECT id FROM structure_permissible_values WHERE value="macroscopic" AND language_alias="macroscopic"), "", "1");
INSERT INTO i18n (id,en) VALUES("macroscopic", "Macroscopic");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_ascites', 'ovcare_ischemia_time_mn', 'integer_positive',  NULL , '0', 'size=5', '', '', 'ischemia time mn', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_ascites'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_ascites' AND `field`='ovcare_ischemia_time_mn' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ischemia time mn' AND `language_tag`=''), '1', '440', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE sd_spe_ascites ADD COLUMN `ovcare_ischemia_time_mn` int(6) DEFAULT NULL;
ALTER TABLE sd_spe_ascites_revs ADD COLUMN `ovcare_ischemia_time_mn` int(6) DEFAULT NULL;
  
UPDATE versions SET branch_build_number = '5922' WHERE version_number = '2.6.3';

-- ==========================================================================================================================================
-- 20141021 : New Upgrade + Add TFRI fields
-- ==========================================================================================================================================

-- ** blood type **

select '*** Test blood types ****' AS MSG;
select sample_master_id, blood_type FROM sd_spe_bloods WHERE blood_type Is NOT NULL;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("serum", "serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "", "1");
INSERT IGNORE INTO i18n (id,en) VALUES("serum", "Serum");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' 
AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' 
AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `field`='blood_type'), 'notEmpty');
-- plasma update
UPDATE sample_masters spe, sd_spe_bloods blood, sample_masters der, sample_controls ctrblood, sample_controls ctrlder
SET blood.blood_type = 'EDTA'
WHERE spe.deleted <> 1 AND spe.sample_control_id = ctrblood.id AND ctrblood.sample_type = 'blood'
AND spe.id = blood.sample_master_id
AND der.initial_specimen_sample_id = spe.id AND der.deleted <> 1 AND der.sample_control_id = ctrlder.id AND ctrlder.sample_type = 'plasma'
AND (blood.blood_type IS NULL OR blood.blood_type LIKE ''); 
UPDATE sample_masters spe, sd_spe_bloods_revs blood, sample_masters der, sample_controls ctrblood, sample_controls ctrlder
SET blood.blood_type = 'EDTA'
WHERE spe.deleted <> 1 AND spe.sample_control_id = ctrblood.id AND ctrblood.sample_type = 'blood'
AND spe.id = blood.sample_master_id
AND der.initial_specimen_sample_id = spe.id AND der.deleted <> 1 AND der.sample_control_id = ctrlder.id AND ctrlder.sample_type = 'plasma'
AND (blood.blood_type IS NULL OR blood.blood_type LIKE ''); 
-- serum update
UPDATE sample_masters spe, sd_spe_bloods blood, sample_masters der, sample_controls ctrblood, sample_controls ctrlder
SET blood.blood_type = 'serum'
WHERE spe.deleted <> 1 AND spe.sample_control_id = ctrblood.id AND ctrblood.sample_type = 'blood'
AND spe.id = blood.sample_master_id
AND der.initial_specimen_sample_id = spe.id AND der.deleted <> 1 AND der.sample_control_id = ctrlder.id AND ctrlder.sample_type = 'serum'
AND (blood.blood_type IS NULL OR blood.blood_type LIKE ''); 
UPDATE sample_masters spe, sd_spe_bloods_revs blood, sample_masters der, sample_controls ctrblood, sample_controls ctrlder
SET blood.blood_type = 'serum'
WHERE spe.deleted <> 1 AND spe.sample_control_id = ctrblood.id AND ctrblood.sample_type = 'blood'
AND spe.id = blood.sample_master_id
AND der.initial_specimen_sample_id = spe.id AND der.deleted <> 1 AND der.sample_control_id = ctrlder.id AND ctrlder.sample_type = 'serum'
AND (blood.blood_type IS NULL OR blood.blood_type LIKE ''); 
-- blood cell update
UPDATE sample_masters spe, sd_spe_bloods blood, sample_masters der, sample_controls ctrblood, sample_controls ctrlder
SET blood.blood_type = 'EDTA'
WHERE spe.deleted <> 1 AND spe.sample_control_id = ctrblood.id AND ctrblood.sample_type = 'blood'
AND spe.id = blood.sample_master_id
AND der.initial_specimen_sample_id = spe.id AND der.deleted <> 1 AND der.sample_control_id = ctrlder.id AND ctrlder.sample_type = 'blood cell'
AND (blood.blood_type IS NULL OR blood.blood_type LIKE ''); 
UPDATE sample_masters spe, sd_spe_bloods_revs blood, sample_masters der, sample_controls ctrblood, sample_controls ctrlder
SET blood.blood_type = 'EDTA'
WHERE spe.deleted <> 1 AND spe.sample_control_id = ctrblood.id AND ctrblood.sample_type = 'blood'
AND spe.id = blood.sample_master_id
AND der.initial_specimen_sample_id = spe.id AND der.deleted <> 1 AND der.sample_control_id = ctrlder.id AND ctrlder.sample_type = 'blood cell'
AND (blood.blood_type IS NULL OR blood.blood_type LIKE ''); 
-- blood type unknown
UPDATE sd_spe_bloods SET blood_type = 'unknown' WHERE blood_type IS NULL OR blood_type LIKE '';
UPDATE sd_spe_bloods_revs SET blood_type = 'unknown' WHERE blood_type IS NULL OR blood_type LIKE '';

-- ** blood type 'blood cell' => 'buffy coat' **

UPDATE i18n SET en = 'Buffy Coat', fr = 'Buffy Coat' WHERE id = 'blood cell';

-- ** Family Histories **

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
ALTER TABLE family_histories ADD COLUMN ovcare_tumor_site varchar(100) DEFAULT NULL;
ALTER TABLE family_histories_revs ADD COLUMN ovcare_tumor_site varchar(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FamilyHistory', 'family_histories', 'ovcare_tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='ovcare_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `field`='ovcare_tumor_site' AND tablename = 'family_histories'), 'notEmpty');

-- ** ClinicalAnnotation Notes **

SELECT 'Change user permissions to not allow notes access: Will hide the quick launch icon' AS TODO;

-- ** Collection Path Number Displayed **

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'path_num', 'input',  NULL , '1', 'size=30', '', '', 'pathology number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='path_num' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='pathology number' AND `language_tag`=''), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='path_num' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_fields SET `flag_confidential`='1' WHERE `field`='path_num';

-- ** Add 'setting = file range' to some fields **

UPDATE structure_formats SET `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=10,class=range file' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `type`='input',  `setting`='size=10,class=range file' WHERE model='ViewCollection' AND tablename='' AND field='participant_identifier' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='size=20,class=file' WHERE model='ViewCollection' AND tablename='' AND field='collection_voa_nbr' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=10,class=range file' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=20,class=file' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='collection_voa_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `type`='input',  `setting`='size=10,class=range file' WHERE model='ViewAliquot' AND tablename='' AND field='participant_identifier' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='size=20,class=file' WHERE model='ViewAliquot' AND tablename='' AND field='collection_voa_nbr' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=20,class=file' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=20,class=file' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,class=range file' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ** Add xenograft flag to tissue and ascites **

ALTER TABLE sd_spe_ascites ADD COLUMN joined_to_xenograft CHAR(1) DEFAULT '';
ALTER TABLE sd_spe_ascites_revs ADD COLUMN joined_to_xenograft CHAR(1) DEFAULT '';
ALTER TABLE sd_spe_tissues ADD COLUMN joined_to_xenograft CHAR(1) DEFAULT '';
ALTER TABLE sd_spe_tissues_revs ADD COLUMN joined_to_xenograft CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'joined_to_xenograft', 'yes_no',  NULL , '0', '', '', '', 'joined to xenograft', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='joined_to_xenograft' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='joined to xenograft' AND `language_tag`=''), '1', '460', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_ascites', 'joined_to_xenograft', 'yes_no',  NULL , '0', '', '', '', 'joined to xenograft', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_ascites'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_ascites' AND `field`='joined_to_xenograft' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='joined to xenograft' AND `language_tag`=''), '1', '460', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('joined to xenograft', 'Joined to xenograft');

-- ** Deleted any surgeyr/biopsy with no data and not linked to a collection **

SET @modified_by = (SELECT id FROM users WHERE username LIKE 'migration');
SET @modified = (SELECT NOW() FROM users LIMIT 0 ,1);
UPDATE treatment_masters TreatmentMaster, txd_surgeries TreatmentDetail
SET TreatmentMaster.deleted = 1, TreatmentMaster.modified_by = @modified_by, TreatmentMaster.modified = @modified
WHERE TreatmentMaster.treatment_control_id = 7 AND TreatmentMaster.deleted <> 1 AND TreatmentDetail.treatment_master_id = TreatmentMaster.id
AND (TreatmentDetail.path_num LIKE '' OR TreatmentDetail.path_num IS NULL)
AND (TreatmentMaster.notes LIKE '' OR TreatmentMaster.notes IS NULL)
AND (TreatmentDetail.ovcare_residual_disease LIKE '' OR TreatmentDetail.ovcare_residual_disease IS NULL)
AND TreatmentDetail.ovcare_neoadjuvant_chemotherapy LIKE ''
AND TreatmentDetail.ovcare_adjuvant_radiation LIKE ''
AND TreatmentMaster.id NOT IN (SELECT treatment_master_id FROM treatment_extend_masters WHERE deleted <> 1)
AND TreatmentMaster.id NOT IN (SELECT treatment_master_id FROM collections WHERE deleted <> 1 AND treatment_master_id IS NOT NULL);
INSERT INTO treatment_masters_revs (id,treatment_control_id,tx_intent,target_site_icdo,start_date,start_date_accuracy,finish_date,finish_date_accuracy,information_source,facility,notes,protocol_master_id,participant_id,diagnosis_master_id, modified_by, version_created)
(SELECT id,treatment_control_id,tx_intent,target_site_icdo,start_date,start_date_accuracy,finish_date,finish_date_accuracy,information_source,facility,notes,protocol_master_id,participant_id,diagnosis_master_id, modified_by, modified FROM treatment_masters WHERE modified_by = @modified_by AND modified = @modified);
INSERT INTO txd_surgeries_revs (path_num,ovcare_age_at_surgery,ovcare_residual_disease,treatment_master_id,ovcare_neoadjuvant_chemotherapy,ovcare_adjuvant_radiation,ovcare_age_at_surgery_precision, version_created)
(SELECT path_num,ovcare_age_at_surgery,ovcare_residual_disease,treatment_master_id,ovcare_neoadjuvant_chemotherapy,ovcare_adjuvant_radiation,ovcare_age_at_surgery_precision, modified FROM treatment_masters INNER JOIN txd_surgeries ON txd_surgeries.treatment_master_id = treatment_masters.id WHERE modified_by = @modified_by AND modified = @modified);

-- ** Sample Creation From Template **

UPDATE structure_formats SET `language_heading`='', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='specimen data' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

-- ** Add Prior radiation yes/no to biopsy surgery **

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'TreatmentDetail', 'txd_surgeries', 'ovcare_prior_radiation', 'yes_no',  NULL , '0', '', '', '', 'prior radiation', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ovcare_prior_radiation' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prior radiation' AND `language_tag`=''), '1', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE txd_surgeries ADD COLUMN ovcare_prior_radiation char(1) DEFAULT '';
ALTER TABLE txd_surgeries_revs ADD COLUMN ovcare_prior_radiation char(1) DEFAULT '';
INSERT INTO i18n (id,en) VALUES ('prior radiation', 'Prior Radiation');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ovcare_prior_radiation' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ** Display tissue anatomic location in collection tree view **

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0'), '0', '2', '', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- ** Link collection to patient Dx when patient is linked to one dx **

SET @modified_by = (SELECT id FROM users WHERE username LIKE 'migration');
SET @modified = (SELECT NOW() FROM users LIMIT 0 ,1);
UPDATE collections Collection, diagnosis_masters DiagnosisMaster 
SET Collection.diagnosis_master_id = DiagnosisMaster.id, Collection.modified = @modified, Collection.modified_by = @modified_by
WHERE Collection.deleted <> 1
AND DiagnosisMaster.deleted <> 1
AND Collection.participant_id = DiagnosisMaster.participant_id
AND Collection.participant_id IN (SELECT participant_id FROM (SELECT count(*) as dx_nbr, participant_id FROM diagnosis_masters WHERE deleted <> 1 GROUP BY participant_id) AS res WHERE res.dx_nbr = 1)
AND Collection.diagnosis_master_id IS NULL;
INSERT INTO collections_revs (id,acquisition_label,bank_id,collection_site,collection_datetime,collection_datetime_accuracy,ovcare_collection_type,sop_master_id,collection_property,collection_notes,participant_id,diagnosis_master_id,
consent_master_id,treatment_master_id,event_master_id,collection_voa_nbr,modified_by,version_created) 
(SELECT id,acquisition_label,bank_id,collection_site,collection_datetime,collection_datetime_accuracy,ovcare_collection_type,sop_master_id,collection_property,collection_notes,participant_id,diagnosis_master_id,
consent_master_id,treatment_master_id,event_master_id,collection_voa_nbr,modified_by,modified FROM collections WHERE modified = @modified AND modified_by = @modified_by);

-- ** Histopathology **

ALTER TABLE ovcare_dxd_ovaries_endometriums
  ADD COLUMN histopathology varchar(100);
ALTER TABLE ovcare_dxd_ovaries_endometriums_revs
  ADD COLUMN histopathology varchar(100); 
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('ovcare_histopathology', "StructurePermissibleValuesCustom::getCustomDropdown(\'Histopathology\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Histopathology', 'clinical - diagnosis', '100');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Histopathology');
INSERT INTO `structure_permissible_values_customs` (`value`, en, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('clear cells', 'Clear Cells', '1', @control_id, NOW(), NOW(), 1, 1),
('endometrioid', 'Endometrioid', '1', @control_id, NOW(), NOW(), 1, 1),
('high grade serous', 'High Grade Serous', '1', @control_id, NOW(), NOW(), 1, 1),
('low grade serous', 'Low Grade Serous', '1', @control_id, NOW(), NOW(), 1, 1),
('mixed', 'Mixed', '1', @control_id, NOW(), NOW(), 1, 1),
('mucinous', 'Mucinous', '1', @control_id, NOW(), NOW(), 1, 1),
('undifferentiated', 'Undifferentiated', '1', @control_id, NOW(), NOW(), 1, 1),
('serous', 'Serous', '1', @control_id, NOW(), NOW(), 1, 1),
('other', 'Other', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown', 'Unknown', '1', @control_id, NOW(), NOW(), 1, 1),
('non applicable', 'Non Applicable', '1', @control_id, NOW(), NOW(), 1, 1),
('low grade', 'Low Grade', '1', @control_id, NOW(), NOW(), 1, 1),
('high grade', 'High Grade', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'ovcare_dxd_ovaries_endometriums', 'histopathology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') , '0', '', '', '', 'general', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='histopathology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='general' AND `language_tag`=''), '3', '59', 'histopathology', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='ovarian_histology' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('histopathology','Histopathology');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='2_3_grading_system' AND `language_label`='two-tier grading system' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_2_3_grading_system') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='2_3_grading_other_specification' AND `language_label`='' AND `language_tag`='precisions' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations 
WHERE structure_field_id IN (SELECT id FROM structure_fields 
WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='2_3_grading_system' AND `language_label`='two-tier grading system' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_2_3_grading_system') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') 
	OR (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='2_3_grading_other_specification' AND `language_label`='' AND `language_tag`='precisions' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields 
WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='2_3_grading_system' AND `language_label`='two-tier grading system' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_2_3_grading_system') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') 
	OR (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='2_3_grading_other_specification' AND `language_label`='' AND `language_tag`='precisions' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="ovcare_2_3_grading_system" AND spv.value="other" AND spv.language_alias="other";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="ovcare_2_3_grading_system" AND spv.value="not applicable" AND spv.language_alias="not applicable";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="ovcare_2_3_grading_system" AND spv.value="low grade" AND spv.language_alias="low grade";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="ovcare_2_3_grading_system" AND spv.value="high grade" AND spv.language_alias="high grade";
DELETE FROM structure_permissible_values WHERE value="low grade" AND language_alias="low grade" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
DELETE FROM structure_permissible_values WHERE value="high grade" AND language_alias="high grade" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
DELETE from structure_value_domains where domain_name = 'ovcare_2_3_grading_system';
UPDATE ovcare_dxd_ovaries_endometriums SET histopathology = 2_3_grading_system;
UPDATE ovcare_dxd_ovaries_endometriums_revs SET histopathology = 2_3_grading_system;
UPDATE ovcare_dxd_ovaries_endometriums SET histopathology = 'non applicable' WHERE histopathology = 'not applicable';
UPDATE ovcare_dxd_ovaries_endometriums_revs SET histopathology = 'non applicable' WHERE histopathology = 'not applicable';
ALTER TABLE ovcare_dxd_ovaries_endometriums DROP COLUMN 2_3_grading_other_specification, DROP COLUMN 2_3_grading_system;
ALTER TABLE ovcare_dxd_ovaries_endometriums_revs DROP COLUMN 2_3_grading_other_specification, DROP COLUMN 2_3_grading_system;

-- ** Dx : Laterality **

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "3", "1");

-- ** Dx : Lesions **

ALTER TABLE ovcare_dxd_ovaries_endometriums ADD COLUMN benign_lesions_precursor_presence varchar(100), ADD COLUMN fallopian_tube_lesions varchar(100);
ALTER TABLE ovcare_dxd_ovaries_endometriums_revs ADD COLUMN benign_lesions_precursor_presence varchar(100), ADD COLUMN fallopian_tube_lesions varchar(100);
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('ovcare_benign_lesions_precursor_presence', "StructurePermissibleValuesCustom::getCustomDropdown(\'Presence of Benign Lesions Precursor\')"),
('ovcare_fallopian_tube_lesions', "StructurePermissibleValuesCustom::getCustomDropdown(\'Fallopian Tube Lesions\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Presence of Benign Lesions Precursor', 'clinical - diagnosis', '100'),
('Fallopian Tube Lesions', 'clinical - diagnosis', '100');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Presence of Benign Lesions Precursor');
INSERT INTO `structure_permissible_values_customs` (`value`, en, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('unknown', 'Unknown', '1', @control_id, NOW(), NOW(), 1, 1),
('ovarian cysts', 'Ovarian Cysts', '1', @control_id, NOW(), NOW(), 1, 1),
('endometriosis', 'Endometriosis', '1', @control_id, NOW(), NOW(), 1, 1),
('benign or borderline tumours', 'Benign or Borderline Tumours', '1', @control_id, NOW(), NOW(), 1, 1),
('no', 'No', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Fallopian Tube Lesions');
INSERT INTO `structure_permissible_values_customs` (`value`, en, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('unknown', 'Unknown', '1', @control_id, NOW(), NOW(), 1, 1),
('yes', 'Yes', '1', @control_id, NOW(), NOW(), 1, 1),
('benign tumors', 'Benign Tumors', '1', @control_id, NOW(), NOW(), 1, 1),
('no', 'No', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'ovcare_dxd_ovaries_endometriums', 'benign_lesions_precursor_presence', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') , '0', '', '', '', 'presence of benign lesions precursor', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'ovcare_dxd_ovaries_endometriums', 'fallopian_tube_lesions', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') , '0', '', '', '', 'fallopian tube lesions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='benign_lesions_precursor_presence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence of benign lesions precursor' AND `language_tag`=''), '3', '70', 'lesions', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='fallopian_tube_lesions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube lesions' AND `language_tag`=''), '3', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) 
VALUES 
('presence of benign lesions precursor','Presence of Precursor of Benign Lesions'),
('lesions','Lesions'),
('fallopian tube lesions','Fallopian Tube Lesions');

-- ** Dx : Progression status **

ALTER TABLE ovcare_dxd_ovaries_endometriums ADD COLUMN progression_status varchar(50);
ALTER TABLE ovcare_dxd_ovaries_endometriums_revs ADD COLUMN progression_status varchar(50);
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('ovcare_dx_progression_status', "StructurePermissibleValuesCustom::getCustomDropdown(\'Diagnosis Progression status\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Diagnosis Progression status', 'clinical - diagnosis', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Diagnosis Progression status');
INSERT INTO `structure_permissible_values_customs` (`value`, en, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('unknown', 'Unknown', '1', @control_id, NOW(), NOW(), 1, 1),
('yes', 'Yes', '1', @control_id, NOW(), NOW(), 1, 1),
('progressive disease', 'Progressive Diseases', '1', @control_id, NOW(), NOW(), 1, 1),
('no', 'No', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'ovcare_dxd_ovaries_endometriums', 'progression_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_dx_progression_status') , '0', '', '', '', 'status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='progression_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_dx_progression_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '3', '80', 'progression', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
































UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = 'xxxxx' WHERE version_number = '2.6.3';

=== QUESTIONS FOR YING ==========================================================================================================================================

** Blood Type **

Set blood type = 'serum' for all blood linked to serum (blood spined to get serum).
Set blood type = 'EDTA' for all blood linked to plasma or buffy coat (blood spined to get plasma and buffy coat).


TODO
- Check why I was not able to search rack in storage layout to move box from one rach to another one
- The databrowser relationship diagram is not displayed.






** Migration: BRCA values to confirm **

BRCA1 mutated = BRCA1+ ?
BRCA2 mutated = BRCA2+ ?
wild type = ? Add the value to the form?



