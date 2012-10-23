INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'include_tissue_storage_details', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'include tissue storage details in the count', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='include_tissue_storage_details' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='include tissue storage details in the count' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('include tissue storage details in the count','Include tissue storage details in the count','Inclure les détails d''entreposage des tissus dans le décompte'),
('frozen tissue tube','Frozen Tissue Tube','Tube de tissu congelé');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'display_tissue_derivative_count_split_per_nature', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'display tissue derivative count split per nature', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='display_tissue_derivative_count_split_per_nature' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='display tissue derivative count split per nature' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('display tissue derivative count split per nature', 'Display tissue derivatives count split per nature', 'Afficher le décompte des dérivés de tissu par nature');

REPLACE INTO i18n (id,en,fr) VALUES 
('tissue dna','Tissu DNA','ADN de tissu'),
('tissue rna','Tissu RNA','ARN de tissu'),
('tissue cell culture','Tissu Cell Culture','Culture céllulaire de tissu');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_nd_sample_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET flag_add= 0,flag_add_readonly= 0,flag_edit= 0,flag_edit_readonly= 0,flag_search= 0,flag_search_readonly= 0,flag_addgrid= 0,flag_addgrid_readonly= 0,flag_editgrid= 0,flag_editgrid_readonly= 0,flag_batchedit= 0,flag_batchedit_readonly= 0,flag_index= 0,flag_detail= 0,flag_summary= 0,flag_float= 0 WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sop_master_id');

UPDATE i18n SET fr=en WHERE id like '%trizol%' AND fr = '';
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters_revs DROP COLUMN survival_time_months;

UPDATE datamart_reports SET form_alias_for_search = 'report_date_range_definition' WHERE id = 3;
UPDATE datamart_reports SET form_alias_for_search = 'report_datetime_range_definition' WHERE id = 4;

UPDATE datamart_reports SET flag_active = 0 WHERE name IN ( 'PROCURE - consent report', 'banking activity');

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'box2-procure', 'row', 'integer', 2, NULL, NULL, NULL, 2, 0, 0, 0, 0, 0, 0, 1, '', 'std_boxs', 'box2-procure', 0);
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'rack8-procure', 'row', 'integer', 8, NULL, NULL, NULL, 4, 2, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_racks', 'rack8-procure', 1),
(null, 'rack4-procure', 'row', 'integer', 4, NULL, NULL, NULL, 4, 0, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_racks', 'rack4-procure', 1);
INSERT INTO i18n (id,en,fr)
VALUES 
('rack8-procure','Rack8-PROCURE','Râtelier8-PROCURE'),
('rack4-procure','Rack4-PROCURE','Râtelier4-PROCURE'),
('box2-procure','Box2-PROCURE','Boîte2-PROCURE'),
('rack20 vertical numbering','Râtelier20-Vert.','Râtelier20-Vert.');

-- -----------------------------------------------------------------------------------------------------------------
-- CHANGE DROP DOWN LIST TO CUSTOM DROP DOWN LIST
-- -----------------------------------------------------------------------------------------------------------------

-- DNA RNA : Storage solution / qc_dna_rna_storage_solution

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'DNA RNA : Storage solution\')" WHERE domain_name = 'qc_dna_rna_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('DNA RNA : Storage solution', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DNA RNA : Storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT  spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_dna_rna_storage_solution');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_dna_rna_storage_solution';

-- DNA RNA : Source storage method / qc_source_storage_method

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'DNA RNA : Source storage method\')" WHERE domain_name = 'qc_source_storage_method';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('DNA RNA : Source storage method', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DNA RNA : Source storage method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT  spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_source_storage_method');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_source_storage_method';

-- RNA : Extraction method / qc_rna_extraction_method

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'RNA : Extraction method\')" WHERE domain_name = 'qc_rna_extraction_method';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('RNA : Extraction method', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'RNA : Extraction method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT  spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_rna_extraction_method');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_rna_extraction_method';

-- DNA RNA : Source storage solution / qc_source_storage_solution

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'DNA RNA : Source storage solution\')" WHERE domain_name = 'qc_source_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('DNA RNA : Source storage solution', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DNA RNA : Source storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_source_storage_solution');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_source_storage_solution';

------------------------------

-- Ascite Cells : Storage solution / qc_ascit_cell_storage_solution

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Ascite Cells : Storage solution\')" WHERE domain_name = 'qc_ascit_cell_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Ascite Cells : Storage solution', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Ascite Cells : Storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_ascit_cell_storage_solution');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_ascit_cell_storage_solution';

-- Ascite Cells : Storage method / qc_ascit_cell_storage_method

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Ascite Cells : Storage method\')" WHERE domain_name = 'qc_ascit_cell_storage_method';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Ascite Cells : Storage method', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Ascite Cells : Storage method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_ascit_cell_storage_method');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_ascit_cell_storage_method';

-- Cell Culture : Collection method / qc_cell_collection_method

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Cell Culture : Collection method\')" WHERE domain_name = 'qc_cell_collection_method';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Cell Culture : Collection method', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Cell Culture : Collection method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_cell_collection_method');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_cell_collection_method';

-- Cell Culture : Hormone / qc_culture_hormone

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Cell Culture : Hormone\')" WHERE domain_name = 'qc_culture_hormone';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Cell Culture : Hormone', 1, 40);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Cell Culture : Hormone');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_culture_hormone');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_culture_hormone';

-- Cell Culture : Solution / qc_culture_solution

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Cell Culture : Solution\')" WHERE domain_name = 'qc_culture_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Cell Culture : Solution', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Cell Culture : Solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_culture_solution');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_culture_solution';

-- Cell Culture : Storage solution / qc_cell_storage_solution

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Cell Culture : Storage solution\')" WHERE domain_name = 'qc_cell_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Cell Culture : Storage solution', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Cell Culture : Storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_cell_storage_solution');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_cell_storage_solution';

-- Tissue : Storage solution / qc_tissue_storage_solution

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue : Storage solution\')" WHERE domain_name = 'qc_tissue_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Tissue : Storage solution', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_tissue_storage_solution');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_tissue_storage_solution';

-- Tissue : Storage method / qc_tissue_storage_method

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue : Storage method\')" WHERE domain_name = 'qc_tissue_storage_method';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Tissue : Storage method', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue : Storage method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_tissue_storage_method');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_tissue_storage_method';

-- Blood cell : Storage solution / qc_blood_cell_storage_solution

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Blood cell : Storage solution\')" WHERE domain_name = 'qc_blood_cell_storage_solution';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Blood cell : Storage solution', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood cell : Storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_blood_cell_storage_solution');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_blood_cell_storage_solution';

-- Amp. RNA : Amp. method / qc_rna_amplification_method

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Amp. RNA : Amp. method\')" WHERE domain_name = 'qc_rna_amplification_method';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Amp. RNA : Amp. method', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Amp. RNA : Amp. method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_rna_amplification_method');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_rna_amplification_method';

-- DNA : Extraction method / qc_dna_extraction_method

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'DNA : Extraction method\')" WHERE domain_name = 'qc_dna_extraction_method';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('DNA : Extraction method', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DNA : Extraction method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT DISTINCT spv.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
LEFT JOIN i18n ON i18n.id = spv.language_alias
WHERE svd.domain_name = 'qc_dna_extraction_method');
DELETE svdpv
FROM structure_value_domains AS svd
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svd.id = svdpv.structure_value_domain_id
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id 
WHERE svd.domain_name = 'qc_dna_extraction_method';
