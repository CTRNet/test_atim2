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
DELETE FROM structure_permissible_values_custom_controls WHERE source LIKE '%Sample Test %';
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





















