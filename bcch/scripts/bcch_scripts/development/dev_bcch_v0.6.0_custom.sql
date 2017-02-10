-- BCCH Customization Script
-- Version 0.6
-- ATiM Version: 2.6.7

use atim_ccbr_dev;

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.6", '');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-148 SIPS Field
--	=============================================================================

ALTER TABLE `collections`
	ADD COLUMN `sips` VARCHAR(25) DEFAULT NULL AFTER `collection_property`;
	
ALTER TABLE `collections_revs`
	ADD COLUMN `sips` VARCHAR(25) DEFAULT NULL AFTER `collection_property`;
	
ALTER TABLE `view_collections`
	ADD COLUMN `sips` VARCHAR(25) DEFAULT NULL AFTER `collection_property`;

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `source`) VALUES
('bcch collection sips', 'open', 'StructurePermissibleValuesCustom::getCustomDropDown(''BCWH Collection SIPS'')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('BCWH Collection SIPS', 1, 50, 'inventory', 6, 6);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='BCWH Collection SIPS' AND `category`='inventory'),
 'Part One', 'Part One', 0, 1, NOW(), 1, NOW(), 1, 0),
 ((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='BCWH Collection SIPS' AND `category`='inventory'),
 'Part Two', 'Part Two', 0, 1, NOW(), 1, NOW(), 1, 0),
 ((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='BCWH Collection SIPS' AND `category`='inventory'),
 'Quad Screen', 'Quad Screen', 0, 1, NOW(), 1, NOW(), 1, 0),
 ((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='BCWH Collection SIPS' AND `category`='inventory'),
 'Maternal Serum AFP Only', 'Maternal Serum AFP Only', 0, 1, NOW(), 1, NOW(), 1, 0),
 ((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='BCWH Collection SIPS' AND `category`='inventory'),
 'Unknown', 'Unknown', 0, 1, NOW(), 1, NOW(), 1, 0),
 ((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='BCWH Collection SIPS' AND `category`='inventory'),
 'N/A', 'N/A', 0, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'Collection', 'collections', 'sips', 'sips', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch collection sips' AND `override` = 'open'), 'help_sips', 'open', 'open', 'open', 0),
('InventoryManagement', 'ViewCollection', '', 'sips', 'sips', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch collection sips' AND `override` = 'open'), 'help_sips', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='sips'),
0, 6, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='collections_for_collection_tree_view'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='sips'),
0, 6, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='linked_collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='sips'),
0, 6, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='clinicalcollectionlinks'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='sips'),
0, 6, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='view_collection'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='' AND `field`='sips'),
0, 6, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('sips', 'Serum Integrated Prenatal Screen (SIPS)', ''),
('part one', 'Part One', ''),
('part two', 'Part Two', ''),
('quad screen', 'Quad Screen', ''),
('maternal serum afp only', 'Maternal Serum AFP Only', '');


-- ============================================================================
-- Eventum ID:XXXX 
-- BB-185
-- ============================================================================ 

ALTER TABLE `collections`
	ADD COLUMN `visit_no` DECIMAL(7,2) DEFAULT NULL AFTER `collection_notes`,
    ADD COLUMN `visit_no_units` VARCHAR(20) DEFAULT NULL AFTER `visit_no`,
    ADD COLUMN `visit_details` TEXT DEFAULT NULL AFTER `visit_no_units`;
	
ALTER TABLE `collections_revs`
	ADD COLUMN `visit_no` DECIMAL(7,2) DEFAULT NULL AFTER `collection_notes`,
    ADD COLUMN `visit_no_units` VARCHAR(20) DEFAULT NULL AFTER `visit_no`,
    ADD COLUMN `visit_details` TEXT DEFAULT NULL AFTER `visit_no_units`;
	
ALTER TABLE `view_collections`
	ADD COLUMN `visit_no` DECIMAL(7,2) DEFAULT NULL AFTER `collection_notes`,
    ADD COLUMN `visit_no_units` VARCHAR(20) DEFAULT NULL AFTER `visit_no`,
    ADD COLUMN `visit_details` TEXT DEFAULT NULL AFTER `visit_no_units`;

INSERT INTO structure_value_domains (`domain_name`, `override`, `source`) VALUES
('collection_visit_no_units', 'open', 'StructurePermissibleValuesCustom::getCustomDropDown(''Collection Visit Number Units'')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Collection Visit Number Units', 1, 50, 'inventory', 5, 5);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Collection Visit Number Units' AND `category`='inventory'),
 'Hours', 'Hours', 1, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Collection Visit Number Units' AND `category`='inventory'),
 'Weeks', 'Weeks', 2, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Collection Visit Number Units' AND `category`='inventory'),
 'Months', 'Months', 3, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Collection Visit Number Units' AND `category`='inventory'),
 'Years', 'Years', 4, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Collection Visit Number Units' AND `category`='inventory'),
 'Visits', 'Visits', 5, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'Collection', 'collections', 'visit_no', 'visit no', '', 'float', '', NULL, '', 'open', 'open', 'open', 0),
('InventoryManagement', 'ViewCollection', '', 'visit_no', 'visit no', '', 'float', '', NULL, '', 'open', 'open', 'open', 0),

('InventoryManagement', 'Collection', 'collections', 'visit_no_units', '', 'visit no units', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_visit_no_units' AND `override` = 'open'), 'help_sips', 'open', 'open', 'open', 0),
('InventoryManagement', 'ViewCollection', '', 'visit_no_units', '', 'visit no units', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_visit_no_units' AND `override` = 'open'), 'help_sips', 'open', 'open', 'open', 0),

('InventoryManagement', 'Collection', 'collections', 'visit_details', 'visit details', '', 'textarea', '', NULL, '', 'open', 'open', 'open', 0),
('InventoryManagement', 'ViewCollection', '', 'visit_details', 'visit details', '', 'textarea', '', NULL, '', 'open', 'open', 'open', 0);

-- Start work here next day

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no'),
1, 8, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='collections_for_collection_tree_view'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no'),
0, 8, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='linked_collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no'),
0, 8, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='clinicalcollectionlinks'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no'),
0, 8, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='view_collection'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='' AND `field`='visit_no'),
1, 8, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),


((SELECT `id` FROM structures WHERE `alias`='collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no_units'),
1, 9, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='collections_for_collection_tree_view'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no_units'),
0, 9, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='linked_collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no_units'),
0, 9, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='clinicalcollectionlinks'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_no_units'),
0, 9, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='view_collection'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='' AND `field`='visit_no_units'),
1, 9, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),


((SELECT `id` FROM structures WHERE `alias`='collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_details'),
1, 10, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='collections_for_collection_tree_view'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_details'),
0, 10, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='linked_collections'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_details'),
0, 10, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='clinicalcollectionlinks'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='visit_details'),
0, 10, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='view_collection'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='' AND `field`='visit_details'),
1, 10, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

UPDATE structure_formats
SET `display_column` = 1, `display_order` = 7
WHERE structure_id = (SELECT id FROM structures WHERE `alias` = 'collections')
AND structure_field_id = (SELECT id FROm structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='study_summary_id');

UPDATE structure_formats
SET `display_column` = 1, `display_order` = 7
WHERE structure_id = (SELECT id FROM structures WHERE `alias` = 'view_collection')
AND structure_field_id = (SELECT id FROm structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='study_summary_id');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('visit no', 'Visit No.', ''),
('visit no units', 'Units', ''),
('visit details', 'Visit Details', ''),
('week_unit', 'wk', '');


--  =============================================================================
--	Eventum ID: #XXXX
--  BB-170 Update Consent
--	=============================================================================

ALTER TABLE cd_bcch_consents
    ADD COLUMN `bcch_consent_extra_blood_draw_without_med` VARCHAR(45) DEFAULT NULL AFTER `bcch_consent_stool`;

ALTER TABLE cd_bcch_consents_revs
    ADD COLUMN `bcch_consent_extra_blood_draw_without_med` VARCHAR(45) DEFAULT NULL AFTER `bcch_consent_stool`;
    
ALTER TABLE cd_bcwh_consents
    ADD COLUMN `bcwh_consent_extra_blood_draw_without_med` VARCHAR(45) DEFAULT NULL AFTER `bcwh_consent_stool`;

ALTER TABLE cd_bcwh_consents_revs
    ADD COLUMN `bcwh_consent_extra_blood_draw_without_med` VARCHAR(45) DEFAULT NULL AFTER `bcwh_consent_stool`;
    
ALTER TABLE cd_bcwh_maternal_consents
    ADD COLUMN `bcwh_maternal_consent_amniotic_fluid` VARCHAR(45) DEFAULT NULL AFTER `bcwh_maternal_consent_stool`,
    ADD COLUMN `bcwh_maternal_consent_extra_blood_draw_without_med` VARCHAR(45) DEFAULT NULL AFTER `bcwh_maternal_consent_amniotic_fluid`,
    ADD COLUMN `bcwh_maternal_consent_newborn_info` VARCHAR(45) DEFAULT NULL AFTER `bcwh_maternal_consent_extra_blood_draw_without_med`;

ALTER TABLE cd_bcwh_maternal_consents_revs
    ADD COLUMN `bcwh_maternal_consent_amniotic_fluid` VARCHAR(45) DEFAULT NULL AFTER `bcwh_maternal_consent_stool`,
    ADD COLUMN `bcwh_maternal_consent_extra_blood_draw_without_med` VARCHAR(45) DEFAULT NULL AFTER `bcwh_maternal_consent_amniotic_fluid`,
    ADD COLUMN `bcwh_maternal_consent_newborn_info` VARCHAR(45) DEFAULT NULL AFTER `bcwh_maternal_consent_extra_blood_draw_without_med`;
    

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcch_consents', 'bcch_consent_extra_blood_draw_without_med', 'consent to blood draw without medical blood draw', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcch_consent_yesnona'), '', 'open', 'open', 'open', 0),

('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_extra_blood_draw_without_med', 'consent to blood draw without medical blood draw', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_consent_yesnona'), '', 'open', 'open', 'open', 0),

('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_amniotic_fluid', 'consent to amniotic fluid', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_maternal_consent_yesnona'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_extra_blood_draw_without_med', 'consent to blood draw without medical blood draw', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_maternal_consent_yesnona'), '', 'open', 'open', 'open', 0),

('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_newborn_info', 'consent to newborn info', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_maternal_consent_yesnona'), '', 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcch_consents' AND `field` = 'bcch_consent_extra_blood_draw_without_med' AND `language_label`='consent to blood draw without medical blood draw' AND `type`='select'),
1, 32, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),


((SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field` = 'bcwh_consent_extra_blood_draw_without_med' AND `language_label`='consent to blood draw without medical blood draw' AND `type`='select'),
1, 32, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_amniotic_fluid' AND `language_label`='consent to amniotic fluid' AND `type`='select'),
1, 30, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_extra_blood_draw_without_med' AND `language_label`='consent to blood draw without medical blood draw' AND `type`='select'),
1, 32, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_newborn_info' AND `language_label`='consent to newborn info' AND `type`='select'),
1, 95, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Move consent to previous material and other material to the bottom of the forms

UPDATE structure_formats
SET `display_order` = 89
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_prev_materials' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 90
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_other_materials' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 90
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_other_materials_description' AND `type` = 'textarea');


UPDATE structure_formats
SET `display_order` = 89
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_prev_materials' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 90
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_other_materials' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 90
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_other_materials_description' AND `type` = 'textarea');


UPDATE structure_formats
SET `display_order` = 89
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_prev_materials' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 90
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_other_materials' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 90
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_other_materials_description' AND `type` = 'textarea');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('consent to amniotic fluid', 'Consent to Amniotic Fluid', ''),
('consent to blood draw without medical blood draw', 'Collection of Additional Blood Without Medical Blood Draw Procedure', '');

-- Rename Consent to Donation of Blood

UPDATE structure_fields
SET `language_label` = 'bcch consent left over blood'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_blood' AND `type` = 'select';

UPDATE structure_fields
SET `language_label` = 'bcwh consent left over blood'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_blood' AND `type` = 'select';

UPDATE structure_fields
SET `language_label` = 'bcwh maternal consent left over blood'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_blood' AND `type` = 'select';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('bcch consent left over blood', 'Consent to Use of Left-over Blood', ''),
('bcwh consent left over blood', 'Consent to Use of Left-over Blood', ''),
('bcwh maternal consent left over blood', 'Consent to Use of Left-over Blood', '');

-- Rename Consent to Collection of an Additional Blood Draw

UPDATE structure_fields
SET `language_label` = 'bcch consent additional blood'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_extra_blood' AND `type` = 'select';

UPDATE structure_fields
SET `language_label` = 'bcwh consent additional blood'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_extra_blood' AND `type` = 'select';

UPDATE structure_fields
SET `language_label` = 'bcwh maternal consent additional blood'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_extra_blood' AND `type` = 'select';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('bcch consent additional blood', 'Consent to Extra Blood at Blood Draw', ''),
('bcwh consent additional blood', 'Consent to Extra Blood at Blood Draw', ''),
('bcwh maternal consent additional blood', 'Consent to Extra Blood at Blood Draw', '');

-- Move positions of BCCH Consent Details

UPDATE structure_formats
SET `display_order` = 13
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_tissue' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 15
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_bone_marrow' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 17
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_blood' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 19
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_extra_blood' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 21
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_extra_blood_draw_without_med' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 23
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_csf' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 25
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_leukopheresis' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 27
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_genetic_material' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 29
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_stem_cells' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 31
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_buccal_swabs' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 33
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_saliva' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 35
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_urine' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 37
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcch_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_consent_stool' AND `type` = 'select');


-- Moving BCWH Consent Form fields

UPDATE structure_formats
SET `display_order` = 14
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_tissue' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 16
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_blood' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 18, `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_index` = 0, `flag_summary` = 0, `flag_detail` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_extra_blood' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 20
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_extra_blood_draw_without_med' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 22
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_genetic_material' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 24
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_swabs' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 26
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_placenta' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 28
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_umbilical_cord_blood' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 30
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_urine' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 32
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_consent_stool' AND `type` = 'select');


-- Moving BCWH Maternal Consent Form Fields

UPDATE structure_formats
SET `display_order` = 14, `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_index` = 0, `flag_summary` = 0, `flag_detail` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_tissue' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 16
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_blood' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 18
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_extra_blood' AND `type` = 'select');


UPDATE structure_formats
SET `display_order` = 20
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_extra_blood_draw_without_med' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 22
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_amniotic_fluid' AND `type` = 'select');


UPDATE structure_formats
SET `display_order` = 24, `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_index` = 0, `flag_summary` = 0, `flag_detail` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_genetic_material' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 26, `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_index` = 0, `flag_summary` = 0, `flag_detail` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_swabs' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 28
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_umbilical_cord_blood' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 30
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_placenta' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 32, `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_index` = 0, `flag_summary` = 0, `flag_detail` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_urine' AND `type` = 'select');

UPDATE structure_formats
SET `display_order` = 34, `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_index` = 0, `flag_summary` = 0, `flag_detail` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_consent_stool' AND `type` = 'select');



REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('consent to newborn info', 'Consent to Collection of Newborn Info', '');

-- Data migration of Amniotic Fluid

UPDATE cd_bcwh_maternal_consents
SET `bcwh_maternal_consent_amniotic_fluid` = 'yes'
WHERE `bcwh_maternal_other_materials_description` LIKE '%Amniotic%' AND `bcwh_maternal_consent_other_materials` = 'yes';

UPDATE cd_bcwh_maternal_consents_revs
SET `bcwh_maternal_consent_amniotic_fluid` = 'yes'
WHERE `bcwh_maternal_other_materials_description` LIKE '%Amniotic%' AND `bcwh_maternal_consent_other_materials` = 'yes';

UPDATE cd_bcwh_maternal_consents
SET `bcwh_maternal_consent_amniotic_fluid` = 'no'
WHERE `bcwh_maternal_other_materials_description` LIKE '%Amniotic%' AND `bcwh_maternal_consent_other_materials` = 'no';

UPDATE cd_bcwh_maternal_consents_revs
SET `bcwh_maternal_consent_amniotic_fluid` = 'no'
WHERE `bcwh_maternal_other_materials_description` LIKE '%Amniotic%' AND `bcwh_maternal_consent_other_materials` = 'no';

UPDATE cd_bcwh_maternal_consents
SET `bcwh_maternal_consent_amniotic_fluid` = 'na'
WHERE `bcwh_maternal_other_materials_description` LIKE '%Amniotic%' AND `bcwh_maternal_consent_other_materials` = 'na';

UPDATE cd_bcwh_maternal_consents_revs
SET `bcwh_maternal_consent_amniotic_fluid` = 'na'
WHERE `bcwh_maternal_other_materials_description` LIKE '%Amniotic%' AND `bcwh_maternal_consent_other_materials` = 'na';


--  =============================================================================
--	Eventum ID: #XXXX
--  BB-184 Make "Referral Clinic" Searchable
--	=============================================================================

UPDATE structure_formats
SET `flag_search` = 1
WHERE structure_id = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND structure_field_id = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'ccbr_referral_clinic' AND `type` = 'select');


-- ============================================================================
-- Eventum ID:XXXX 
-- BB-188
-- ============================================================================    

INSERT INTO misc_identifier_controls
(`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('Kingella ID', 1, 14, 0, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Kingella ID', 'Kingella ID', 'Kingella ID');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('MRN', 'MRN', 'MRN');

-- ============================================================================
-- Eventum ID:XXXX 
-- BB-189
-- ============================================================================  

UPDATE misc_identifiers
SET `deleted` = 1
WHERE `participant_id` = (SELECT `id` FROM participants WHERE `participant_identifier` = 'C00370');

UPDATE participants
SET `deleted` = 1
WHERE `participant_identifier` = 'C00370';

-- ============================================================================
-- Eventum ID:XXXX 
-- BB-190 Add "Plasma" as a derivative to "Bone Marrow"
-- ============================================================================ 

INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`)
VALUES 
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'bone marrow' AND `detail_tablename` = 'sd_spe_bone_marrows'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'plasma' AND `detail_tablename` = 'sd_der_plasmas'),
 1, NULL);
 
-- ============================================================================
-- Eventum ID:XXXX 
-- BB-191 AKI ID
-- ============================================================================  

INSERT INTO misc_identifier_controls
(`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('AKI ID', 1, 15, 0, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('AKI ID', 'AKI ID', 'AKI ID');


-- ============================================================================
-- Eventum ID:XXXX 
-- BB-195 
-- ============================================================================  

-- Fixed Translation

UPDATE structure_fields
SET `default` = ""
WHERE `plugin` = 'ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename` = 'dxd_bcwh_pregnancies';

UPDATE structure_fields
SET `default` = ""
WHERE `plugin` = 'ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename` = 'dxd_bcwh_deliveries';

UPDATE structure_fields
SET `default` = ""
WHERE `plugin` = 'ClinicalAnnotation' AND `model`='EventDetail' AND `tablename` = 'ed_bcwh_live_births';

UPDATE structure_fields
SET `default` = ""
WHERE `plugin` = 'ClinicalAnnotation' AND `model`='EventDetail' AND `tablename` = 'ed_bcwh_stillbirths';

 
-- Demonliazation

-- Participant Table --

-- First Name --

UPDATE `participants` SET `first_name` = cast(SHA1(`first_name`) AS CHAR(20) CHARACTER SET utf8);

-- Middle Name --

UPDATE `participants` SET `middle_name` = cast(SHA1(`middle_name`) AS CHAR(20) CHARACTER SET utf8);

-- Last Name --

UPDATE `participants` SET `last_name` = cast(SHA1(`last_name`) AS CHAR(20) CHARACTER SET utf8);

-- Date of Birth --

UPDATE `participants` SET `date_of_birth` = DATE_ADD(`date_of_birth`, INTERVAL FLOOR(1000*RAND()) DAY);

-- Parent or Guardian Name --

UPDATE `participants` SET `ccbr_parent_guardian_name` = cast(SHA1(`ccbr_parent_guardian_name`) AS CHAR(20) CHARACTER SET utf8);

-- Participant log tables --

UPDATE `participants`, `participants_revs`
SET `participants_revs`.`first_name` = `participants`.`first_name`,
`participants_revs`.`middle_name` = `participants`.`middle_name`,
`participants_revs`.`last_name` = `participants`.`last_name`,
`participants_revs`.`date_of_birth` = `participants`.`date_of_birth`,
`participants_revs`.`ccbr_parent_guardian_name` = `participants`.`ccbr_parent_guardian_name`
WHERE `participants`.`id` = `participants_revs`.`id`;

-- Identifiers Table --

-- COG --

UPDATE `misc_identifiers` SET `identifier_value` = CAST(SHA1(`identifier_value`) AS CHAR(6) CHARACTER SET UTF8)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM `misc_identifier_controls` WHERE `misc_identifier_name` = 'COG Registration');

-- MRN --

UPDATE `misc_identifiers` SET `identifier_value` = FLOOR(10000000*RAND())
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'MRN');

-- PHN --

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(1000*RAND()), ' ', FLOOR(1000*RAND()), ' ', FLOOR(10000*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

-- Identifiers Revs Table --

UPDATE `misc_identifiers`, `misc_identifiers_revs`
SET `misc_identifiers_revs`.`identifier_value` = `misc_identifiers`.`identifier_value`
WHERE `misc_identifiers`.`id` = `misc_identifiers_revs`.`id`;

-- Participants Contact Information --

-- Contact Name


UPDATE `participant_contacts` SET `contact_name` = cast(SHA1(`contact_name`) AS CHAR(50) CHARACTER SET utf8);


-- Email Address

UPDATE `participant_contacts` SET `ccbr_email` = cast(SHA1(`ccbr_email`) AS CHAR(45) CHARACTER SET utf8);


-- Street

UPDATE `participant_contacts` SET `street` = cast(SHA1(`street`) AS CHAR(50) CHARACTER SET utf8);

-- City

UPDATE `participant_contacts` SET `locality` = cast(SHA1(`locality`) AS CHAR(50) CHARACTER SET utf8);

-- Postal Code

UPDATE `participant_contacts` SET `mail_code` = cast(SHA1(`mail_code`) AS CHAR(10) CHARACTER SET utf8);

-- Primary Phone Number

UPDATE `participant_contacts` SET `phone` = cast(SHA1(`phone`) AS CHAR(15) CHARACTER SET utf8);

-- Secondary Phone Number

UPDATE `participant_contacts` SET `phone_secondary` = cast(SHA1(`phone_secondary`) AS CHAR(30) CHARACTER SET utf8);

-- Participants Contact Log Table --

UPDATE `participant_contacts`, `participant_contacts_revs`
SET `participant_contacts_revs`.`contact_name` = `participant_contacts`.`contact_name`,
`participant_contacts_revs`.`ccbr_email` = `participant_contacts`.`ccbr_email`,
`participant_contacts_revs`.`street` = `participant_contacts`.`street`,
`participant_contacts_revs`.`locality` = `participant_contacts`.`locality`,
`participant_contacts_revs`.`mail_code` = `participant_contacts`.`mail_code`,
`participant_contacts_revs`.`phone` = `participant_contacts`.`phone`,
`participant_contacts_revs`.`phone_secondary` = `participant_contacts`.`phone_secondary`
WHERE `participant_contacts_revs`.`id` = `participant_contacts`.`id`;    
