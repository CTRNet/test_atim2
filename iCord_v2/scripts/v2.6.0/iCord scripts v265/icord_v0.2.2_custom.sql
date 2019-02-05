
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.2.2', '');

-- Collection Site

ALTER TABLE collections MODIFY `collection_site` VARCHAR(200);

ALTER TABLE collections_revs MODIFY `collection_site` VARCHAR(200);

UPDATE structure_value_domains
SET `source` = 'StructurePermissibleValuesCustom::getCustomDropdown(''Collection Sites'')'
WHERE `domain_name` = 'custom_collection_site';

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES 
('Collection Sites', 1, 200, 'inventory', 5, 5);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Collection Sites' AND `category` = 'inventory'), 'Hopital du Sacre Couer de Montreal', 'Hopital du Sacre Couer de Montreal', 'Hopital du Sacre Couer de Montreal', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Collection Sites' AND `category` = 'inventory'), 'Vancouver General Hospital', 'Vancouver General Hospital', 'Vancouver General Hospital', 0, 1, NOW(), 1, NOW(), 1, 0),

((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Collection Sites' AND `category` = 'inventory'), 'QEII HSC - Halifax Infirmary', 'QEII HSC - Halifax Infirmary', 'QEII HSC - Halifax Infirmary', 0, 1, NOW(), 1, NOW(), 1, 0),

((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Collection Sites' AND `category` = 'inventory'), 'Victoria Hospital, London', 'Victoria Hospital, London', 'Victoria Hospital, London', 0, 1, NOW(), 1, NOW(), 1, 0),

((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Collection Sites' AND `category` = 'inventory'), 'San Franciso General Hospital', 'San Franciso General Hospital', 'San Franciso General Hospital', 0, 1, NOW(), 1, NOW(), 1, 0);

-- Rename acquisition label to study id number

UPDATE structure_formats
SET `flag_override_label` = 1, `language_label` = 'Study ID Number'
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'acquisition_label' AND `type` = 'input');

-- Remove Bank from colleciton view

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index`= 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'bank_id' AND `type` = 'select');

-- Remove other collection fields
-- Collection Date
-- Autopsy Site
-- Autopsy Date
-- Collection Timepoint
-- Collection Volume
-- Collection Availability
-- Value of Quantity

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index`= 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'collection_datetime' AND `type` = 'select')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'autopsy_datetime' AND `type` = 'datetime')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'autopsy_location' AND `type` = 'select')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'collection_timepoint' AND `type` = 'select')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'volume' AND `type` = 'select')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'availability' AND `type` = 'select')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'value_of_quantity' AND `type` = 'integer_positive');

-- Remove the fields from ViewCollection

UPDATE structure_formats
SET `flag_override_label` = 1, `language_label` = 'Study ID Number'
WHERE
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = '' AND `field` = 'acquisition_label' AND `type` = 'input')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'view_collection');


UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index`= 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = '' AND `field` = 'collection_datetime' AND `type` = 'datetime')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = '' AND `field` = 'bank_id' AND `type` = 'select');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index`= 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'collection_datetime' AND `type` = 'datetime')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'collection_timepoint' AND `type` = 'select')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'autopsy_location' AND `type` = 'select')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'autopsy_datetime' AND `type` = 'datetime')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'value_of_quantity' AND `type` = 'integer_positive')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'availability' AND `type` = 'select')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'volume' AND `type` = 'select');







-- remove fields in samples

DELETE FROM structure_formats
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_vial_id' AND `type`='input')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_approx_timepoint' AND `type`='integer_positive')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_actual_timepoint' AND `type`='float_positive');

DELETE FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_vial_id' AND `type`='input';
DELETE FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_approx_timepoint' AND `type`='integer_positive';
DELETE FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_actual_timepoint' AND `type`='float_positive';

ALTER TABLE sample_masters 
DROP `icord_vial_id`,
DROP `icord_approx_timepoint`,
DROP `icord_actual_timepoint`;

-- Remove
-- Sample SOP
-- Reception Datetime
-- Time at room temp
-- Type
-- Collected Volume

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index`= 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SampleMaster' AND `tablename` = 'sample_masters' AND `field` = 'sop_master_id' AND `type` = 'select')
OR 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SpecimenDetail' AND `tablename` = 'specimen_details' AND `field` = 'reception_datetime' AND `type` = 'datetime')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SpecimenDetail' AND `tablename` = 'specimen_details' AND `field` = 'time_at_room_temp_mn' AND `type` = 'integer')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SampleDetail' AND `tablename` = '' AND `field` = 'collected_volume' AND `type` = 'float_positive')
OR
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SampleDetail' AND `tablename` = '' AND `field` = 'collected_volume_unit' AND `type` = 'select');





-- Rename Number of Collected Tubes
-- Rename Supplier Department 
-- Rename Taken Delivery By

UPDATE structure_formats
SET `flag_override_label` = 1, `language_label` = 'number of aliquots frozen'
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SampleDetail' AND `tablename` = '' AND `field` = 'collected_tube_nbr' AND `type` = 'integer_positive');


UPDATE structure_formats
SET `flag_override_label` = 1, `language_label` = 'hospital department'
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SpecimenDetail' AND `tablename` = 'specimen_details' AND `field` = 'supplier_dept' AND `type` = 'select');

UPDATE structure_value_domains
SET `source` = 'StructurePermissibleValuesCustom::getCustomDropdown(''Hospital Departments'')'
WHERE `domain_name` = 'custom_specimen_supplier_dept';

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Hospital Departments', 1, 100, 'inventory', 8, 8);


INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'CP9', 'CP9', 'CP9', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'ICU', 'ICU', 'ICU', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'ED', 'ED', 'ED', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'OR', 'OR', 'OR', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'Morgue', 'Morgue', 'Morgue', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'Pre-Op Area', 'Pre-Op Area', 'Pre-Op Area', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'BTHA', 'BTHA', 'BTHA', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Hospital Departments' AND `category` = 'inventory'), 'Other', 'Other', 'Other', 0, 1, NOW(), 1, NOW(), 1, 0);



UPDATE structure_formats
SET `flag_override_label` = 1, `language_label` = 'sample collected by'
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SpecimenDetail' AND `tablename` = 'specimen_details' AND `field` = 'reception_by' AND `type` = 'select');

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Laboratory Staff' AND `category` = 'inventory'), 'Lise Belanger', 'Lise Belanger', 'Lise Belanger', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Laboratory Staff' AND `category` = 'inventory'), 'Jiwan Gill', 'Jiwan Gill', 'Jiwan Gill', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Laboratory Staff' AND `category` = 'inventory'), 'Leanna Ritchie', 'Leanna Ritchie', 'Leanna Ritchie', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Laboratory Staff' AND `category` = 'inventory'), 'Angela Tsang', 'Angela Tsang', 'Angela Tsang', 0, 1, NOW(), 1, NOW(), 1, 0);







-- Should these field sbe in the specimen_detail instead.

-- Add Site Specimen Drawn
-- Create Time Drawn
-- create Time frozen

ALTER TABLE specimen_details
ADD COLUMN `site_specimen_drawn` VARCHAR(100) DEFAULT NULL AFTER `reception_datetime_accuracy`,
ADD COLUMN `time_specimen_drawn` DATETIME DEFAULT NULL AFTER `site_specimen_drawn`,
ADD COLUMN `time_specimen_frozen` DATETIME DEFAULT NULL AFTER `time_specimen_drawn`;


ALTER TABLE specimen_details_revs
ADD COLUMN `site_specimen_drawn` VARCHAR(100) DEFAULT NULL AFTER `reception_datetime_accuracy`,
ADD COLUMN `time_specimen_drawn` DATETIME DEFAULT NULL AFTER `site_specimen_drawn`,
ADD COLUMN `time_specimen_frozen` DATETIME DEFAULT NULL AFTER `time_specimen_drawn`;

INSERT INTO structure_value_domains
(`domain_name`, `override`, `source`)
VALUES
('specimen_drawn_sites', 'open', 'StructurePermissibleValuesCustom::getCustomDropdown(''Specimen Drawn Sites'')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Specimen Drawn Sites', 1, 100, 'inventory', 5, 5);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Arterial Line', 'Arterial Line', 'Arterial Line', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Central Line', 'Central Line', 'Central Line', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Peripheral Draw', 'Peripheral Draw', 'Peripheral Draw', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'ITC', 'ITC', 'ITC', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Direct Puncture', 'Direct Puncture', 'Direct Puncture', 0, 1, NOW(), 1, NOW(), 1, 0);


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'site_specimen_drawn', 'specimen drawn site', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'specimen_drawn_sites'), '', 0),
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'time_specimen_drawn', 'time drawn', '', 'datetime', '', '', NULL, '', 0),
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'time_specimen_frozen', 'time frozen', '', 'datetime', '', '', NULL, '', 0);



INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'specimens'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='site_specimen_drawn' AND `type`='select'), 
1, 400, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
1, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'specimens'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_specimen_drawn' AND `type`='datetime'), 
1, 500, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
1, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'specimens'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_specimen_frozen' AND `type`='datetime'), 
1, 600, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
1, 1, 0, 0, 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'template_init_structure'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='site_specimen_drawn' AND `type`='select'), 
1, 400, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'template_init_structure'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_specimen_drawn' AND `type`='datetime'), 
1, 500, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'template_init_structure'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_specimen_frozen' AND `type`='datetime'), 
1, 600, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'report_initial_specimens_criteria_and_result'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='site_specimen_drawn' AND `type`='select'), 
0, 25, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'report_initial_specimens_criteria_and_result'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_specimen_drawn' AND `type`='datetime'), 
0, 26, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'report_initial_specimens_criteria_and_result'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_specimen_frozen' AND `type`='datetime'), 
0, 27, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 0, 0, 0);



REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('hospital department', 'Hospital Department', 'Hospital Department'),
('sample collected by', 'Sample Collected By:', ''),
('specimen drawn site', 'Specimen Drawn Site', ''),
('number of aliquots frozen', 'Number of Aliquots Frozen', ''),
('time drawn', 'Time Drawn', ''),
('time frozen', 'Time Frozen', '');


-- Aliquots

-- Lot Number, Study/Project/Aliquot SOP removal

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_editgrid` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'AliquotDetail' AND `field` = 'lot_number' AND `type` = 'input');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_editgrid` = 0, `flag_index` = 0, `flag_detail` = 0, `flag_batchedit` = 0
WHERE `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'AliquotMaster' AND `field` = 'sop_master_id' AND `type` = 'select');


UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_addgrid` = 0, `flag_editgrid` = 0, `flag_index` = 0, `flag_detail` = 0, `flag_batchedit` = 0
WHERE `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'AliquotMaster' AND `field` = 'study_summary_id' AND `type` = 'select');







