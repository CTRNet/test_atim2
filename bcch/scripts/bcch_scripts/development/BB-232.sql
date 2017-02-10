-- BCCH Customization Script

-- ATiM Version: 2.6.7
-- BB-203

-- Create tracking code in the revelent tables

/*
ALTER TABLE sample_masters
    ADD `tracking_code` VARCHAR(60) AFTER `sample_code`;

ALTER TABLE view_samples
    ADD `tracking_code` VARCHAR(60) AFTER `sample_code`;

ALTER TABLE sample_masters_revs
    ADD `tracking_code` VARCHAR(60) AFTER `sample_code`;
*/

-- The sample tracking code at the aliquot is based on the sample label of the example
-- For example:
-- Sample C00001BL001
-- The aliquots would have the tracking code: C00001BL001-01, C00001BL001-02

/*
Blood: aliquot_masters, ad_spec_tubes_incl_ml_vol
Serum: aliquot_masters, ad_der_tubes_incl_ml_vol, ad_hemolysis
Plasma: aliquot_masters, ad_der_tubes_incl_ml_vol, ad_hemolysis
Buffy Coat: aliquot_masters, ad_der_cell_tubes_incl_ml_vol
MC: aliquot_masters, ad_der_cell_tubes_incl_ml_vol 
*/

/*
ALTER TABLE aliquot_masters
    ADD `sample_tracking_code` VARCHAR(60) AFTER `aliquot_label`;

ALTER TABLE view_aliquots
    ADD `sample_tracking_code` VARCHAR(60) AFTER `aliquot_label`;

ALTER TABLE aliquot_masters_revs
    ADD `sample_tracking_code` VARCHAR(60) AFTER `aliquot_label`;

*/

ALTER TABLE ad_tubes
    ADD `sample_tracking_code` VARCHAR(60) AFTER `aliquot_master_id`;

ALTER TABLE ad_tubes_revs
    ADD `sample_tracking_code` VARCHAR(60) AFTER `aliquot_master_id`;


INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'sample_tracking_code', 'tracking code', '', 'input', 'size=30', NULL, '', 'open', 'open', 'open', 0),

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='ad_spec_tubes_incl_ml_vol'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ad_der_tubes_incl_ml_vol'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ad_der_cell_tubes_incl_ml_vol'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
1, 0, 0, 1, 1, 0, 0),



/*
INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'tracking_code', 'tracking code', '', 'input', 'size=30', NULL, '', 'open', 'open', 'open', 0),
('InventoryManagement', 'ViewAliquot', '', 'tracking_code', 'tracking code', '', 'input', 'size=30', NULL, '', 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='aliquot_masters'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 1, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='aliquotinternaluses'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 1, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='sourcealiquots'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 1, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='aliquot_masters'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 1, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='aliquot_masters_for_collection_tree_view'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 1, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='children_aliquots_selection'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 1, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='realiquotedparent'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='tracking_code'),
1, 999, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 1, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
*/

/*
ALTER TABLE sample_masters
    ADD INDEX `sample_barcode` (`sample_barcode`);
*/
/*
UPDATE sample_masters
SET `sample_barcode` = (FLOOR(RAND() * (1000000000 - 9999999999 + 1)) + 9999999999) WHERE `parent_id` IS NULL AND `parent_sample_type` IS NULL;
*/

/*
UPDATE view_samples, sample_masters
SET view_samples.`sample_barcode` = sample_masters.`sample_barcode`
WHERE view_samples.`sample_master_id` = sample_masters.`id` 
AND view_samples.`parent_id` IS NULL;

-- Update derivatives by getting info of parents from view_samples
UPDATE sample_masters, view_samples
SET sample_masters.`sample_barcode` = view_samples.`sample_barcode`
WHERE sample_masters.`parent_id` = view_samples.`sample_master_id`
AND sample_masters.`parent_id` IS NOT NULL;

-- Update the derivative in the view_samples table
UPDATE view_samples, sample_masters
SET view_samples.`sample_barcode` = sample_masters.`sample_barcode`
WHERE view_samples.`sample_master_id` = sample_masters.`id` 
AND view_samples.`parent_id` IS NOT NULL;

UPDATE sample_masters, sample_masters_revs
SET sample_masters_revs.`sample_barcode` = sample_masters.`sample_barcode`
WHERE sample_masters.`id` = sample_masters_revs.`id`;

UPDATE aliquot_masters, sample_masters
SET aliquot_masters.`sample_barcode` = sample_masters.`sample_barcode`
WHERE aliquot_masters.`sample_master_id` = sample_masters.`id`;

UPDATE aliquot_masters, aliquot_masters_revs
SET aliquot_masters_revs.`sample_barcode` = aliquot_masters.`sample_barcode`
WHERE aliquot_masters.`id` = aliquot_masters_revs.`id`;

UPDATE view_aliquots, aliquot_masters
SET view_aliquots.`sample_barcode`= aliquot_masters.`sample_barcode`
WHERE aliquot_masters.`id` = view_aliquots.`aliquot_master_id`;
*/
