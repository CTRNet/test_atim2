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










