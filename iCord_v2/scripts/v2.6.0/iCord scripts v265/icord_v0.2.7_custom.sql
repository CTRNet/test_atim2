REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES ('core_installname', 'iCord v0.2.7', 'iCord v0.2.7');

-- Removed time from collection date
-- Fixed a bug where collection date was not displaying in detail view
UPDATE `structure_fields` SET `type`='date' WHERE  `plugin`='InventoryManagement' and `model`='collection' and field = 'collection_datetime';
UPDATE `structure_fields` SET `type`='date' WHERE  `plugin`='InventoryManagement' and `model`='ViewCollection' and field = 'collection_datetime';

ALTER TABLE `collections` CHANGE COLUMN `collection_datetime` `collection_datetime` DATE NULL DEFAULT NULL AFTER `collection_timepoint`;
ALTER TABLE `view_collections` CHANGE COLUMN `collection_datetime` `collection_datetime` DATE NULL DEFAULT NULL AFTER `collection_timepoint`;
ALTER TABLE `collections_revs` CHANGE COLUMN `collection_datetime` `collection_datetime` DATE NULL DEFAULT NULL AFTER `collection_timepoint`;

UPDATE `structure_formats` SET `flag_add` = 1, `flag_edit` = 1, `flag_search` = 1, `flag_index` = 1, `flag_detail` = 1 WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'view_collection') AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `field`='collection_datetime' AND `tablename`='');


-- Still need to remove the original study ID number field
-- Need to write script to remove the validation rules for Study ID Number

DELETE FROM structure_validations
WHERE structure_validations.rule = 'isUnique'
AND structure_validations.structure_field_id = (SELECT `id` 
FROM structure_fields 
WHERE `plugin` = 'InventoryManagement' 
AND `model` = 'Collection' 
AND `tablename` = 'collections' 
AND `field` = 'acquisition_label');

DELETE FROM structure_validations
WHERE structure_validations.rule = 'isUnique'
AND structure_validations.structure_field_id = (SELECT `id` 
FROM structure_fields 
WHERE `plugin` = 'InventoryManagement' 
AND `model` = 'Collection' 
AND `tablename` = 'collections' 
AND `field` = 'acquisition_label');

-- #720 - Change units in Initial Volume from ml to ul for Serum and Plasma
UPDATE `aliquot_controls` SET `aliquot_type_precision`='(ul)', `detail_form_alias`='ad_der_tubes_incl_ul_vol,ad_hemolysis',`volume_unit`='ul',`comment`='Derivative tube requiring volume in ul' WHERE `sample_control_id`=(SELECT id FROM sample_controls WHERE `sample_type`='serum' AND `sample_category` = 'specimen' AND `detail_tablename` = 'sd_spe_serums') AND `detail_form_alias` = 'ad_der_tubes_incl_ml_vol,ad_hemolysis';
UPDATE `aliquot_controls` SET `aliquot_type_precision`='(ul)', `detail_form_alias`='ad_der_tubes_incl_ul_vol,ad_hemolysis',`volume_unit`='ul',`comment`='Derivative tube requiring volume in ul' WHERE `sample_control_id`=(SELECT id FROM sample_controls WHERE `sample_type`='plasma' AND `sample_category` = 'specimen' AND `detail_tablename` = 'sd_spe_plasmas') AND `detail_form_alias` = 'ad_der_tubes_incl_ml_vol,ad_hemolysis';

-- #718 Create a new field Hospital department in collection form
-- Delete old fields from structure_formats
DELETE FROM structure_formats
WHERE structure_formats.structure_id IN (SELECT id FROM structures WHERE alias IN ('specimens','report_initial_specimens_criteria_and_result') AND structure_field_id = (SELECT id FROM structure_fields WHERE field = 'supplier_dept'));
-- create new filds
ALTER TABLE collections
  ADD COLUMN `supplier_dept` VARCHAR(55) DEFAULT NULL AFTER `collection_datetime`;

ALTER TABLE collections_revs
  ADD COLUMN `supplier_dept` VARCHAR(55) DEFAULT NULL AFTER `collection_datetime`;

ALTER TABLE view_collections
  ADD COLUMN `supplier_dept` VARCHAR(55) DEFAULT NULL AFTER `collection_datetime`;

UPDATE `structure_fields` SET `model`='Collection', `tablename` = 'collections', `language_label` = 'Hospital Department' WHERE  `plugin`='InventoryManagement' AND `field`='supplier_dept' AND `type`='select';
INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
  ('InventoryManagement', 'ViewCollection', 'view_collections', 'supplier_dept', 'Hospital Department', '', 'select', '', '',(SELECT id FROM `structure_value_domains` WHERE domain_name = 'custom_specimen_supplier_dept'),'help_supplier_dept', 'open', 'open', 'open', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`,
                               `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`,
                               `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
                               `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`,
                               `flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
  ((SELECT `id` FROM structures WHERE `alias` = 'collections'),
    (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections'  AND `field`='supplier_dept' AND `type`='select'),
    0, 4, '', 0, '', 0, '', 0, '',
    0, '', 0, '', 0, '',
    1, 0, 1, 0, 1, 0,
                0, 0, 0, 0, 0, 0,
                0, 1, 1, 0, 0),
  ((SELECT `id` FROM structures WHERE `alias` = 'linked_collections'),
    (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='supplier_dept' AND `type`='select'),
    0, 4, '', 0, '', 0, '', 0, '',
    0, '', 0, '', 0, '',
    1, 0, 1, 0, 0, 0,
                0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0),
  ((SELECT `id` FROM structures WHERE `alias` = 'view_collection'),
    (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='supplier_dept' AND `type`='select'),
    0, 4, '', 0, '', 0, '', 0, '',
    0, '', 0, '', 0, '',
    1, 0, 1, 0, 1, 0,
                0, 0, 0, 0, 0, 0,
                1, 1, 0, 0, 0);
REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES ('Supplier Department', 'Hospital Department', 'Hospital Department');

-- Create a new field specimen_frozen  in Collection details form
ALTER TABLE sample_masters
  ADD COLUMN `specimen_frozen` CHAR(1) DEFAULT NULL AFTER `is_problematic`;

ALTER TABLE sample_masters_revs
  ADD COLUMN `specimen_frozen` CHAR(1) DEFAULT NULL AFTER `is_problematic`;


INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
  ('InventoryManagement', 'SampleMaster', 'sample_masters', 'specimen_frozen', 'Specimen Frozen', '', 'yes_no', '', 0,null,'help_specimen_frozen', 'open', 'open', 'open', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`,
                               `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`,
  									    `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`,
                               `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
                               `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`,
                               `flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
  ((SELECT `id` FROM structures WHERE `alias` = 'sample_masters'),
    (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters'  AND `field`='specimen_frozen' AND `type`='yes_no'),
    0, 501, '', 0, '', 0, '', 0, '',
    0, '', 0, '', 0, '',
    1, 0, 1, 0, 0, 0,
    1, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0);
REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES ('Specimen Frozen', 'Was Specimen Frozen?', 'Was Specimen Frozen?');

-- Increase allowable range for Injury Force (kdynes) #620
ALTER TABLE `dxd_animals` CHANGE COLUMN `pig_injury_force` `pig_injury_force` DECIMAL(7,2) NULL DEFAULT NULL AFTER `pig_injury_height`;