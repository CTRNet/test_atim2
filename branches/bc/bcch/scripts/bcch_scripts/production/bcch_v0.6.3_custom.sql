-- BCCH Customization Script
-- Version 0.6.3
-- ATiM Version: 2.6.7

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.6.3", '');

-- ============================================================================
-- BB-209
-- ============================================================================

UPDATE structure_formats
SET `flag_edit` = 0, `flag_batchedit` = 0
WHERE `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'AliquotMaster' AND `tablename` = 'aliquot_masters' AND `field` ='sop_master_id' AND `type` = 'select');

-- ============================================================================
-- BB-225
-- ============================================================================

INSERT INTO misc_identifier_controls
(`misc_identifier_name`, `flag_active`, `display_order`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('EoE ID', 1, 16, NULL, 1, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('EoE ID', 'EoE ID', 'EoE ID');

-- ============================================================================
-- BB-226
-- ============================================================================

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Swab Locations', 1, 50, 'Inventory - Swab', 4, 4);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'buccal', 'Buccal', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'cervix', 'Cervix', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'vagina', 'Vagina', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'throat', 'Throat', '', 0, 1, NOW(), 1, NOW(), 1, 0);

UPDATE structure_value_domains 
SET `source` = 'StructurePermissibleValuesCustom::getCustomDropDown(\'Swab Locations\')', `override`='open'
WHERE `domain_name`= 'ccbr_swab_location';

DELETE FROM structure_value_domains_permissible_values
WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_swab_location');

-- ============================================================================
-- BB-230
-- ============================================================================

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`,
`flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'view_aliquot_joined_to_sample_and_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model` = 'AliquotMaster' AND `tablename`='aliquot_masters' AND `field` = 'study_summary_id' AND `type`='select'), 0, 2,
0, 0, 0, 0, 0,
0, 0, 0, 0, 1, 0,
0, 0, 0, 0, 1,
0, 0, 1, 0, 0, 0);