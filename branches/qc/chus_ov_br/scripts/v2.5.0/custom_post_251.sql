
UPDATE misc_identifier_controls SET autoincrement_name = '', misc_identifier_format = '' WHERE id IN (1,2);

ALTER TABLE collections 
  ADD COLUMN `chus_collection_date` date DEFAULT NULL,
  ADD COLUMN `chus_collection_date_accuracy` char(1) NOT NULL DEFAULT '';
ALTER TABLE collections_revs 
  ADD COLUMN `chus_collection_date` date DEFAULT NULL,
  ADD COLUMN `chus_collection_date_accuracy` char(1) NOT NULL DEFAULT '';  

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'chus_collection_date', 'date',  NULL , '0', '', '', '', 'collection datetime', '');
SET @new_structure_field_id =(SELECT id FROM structure_fields WHERE field = 'chus_collection_date' AND model = 'Collection');
SET @collection_datetime_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'collection_datetime' AND model = 'Collection');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT `structure_id`, @new_structure_field_id, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @collection_datetime_structure_field_id);
UPDATE structure_formats SET flag_add=0, flag_add_readonly=0, flag_edit=0, flag_edit_readonly=0, flag_search=0, flag_search_readonly=0, flag_addgrid=0, flag_addgrid_readonly=0, flag_editgrid=0, flag_editgrid_readonly=0, flag_batchedit=0, flag_batchedit_readonly=0, flag_index=0, flag_detail=0, flag_summary=0 WHERE structure_field_id = @collection_datetime_structure_field_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'chus_collection_date', 'date',  NULL , '0', '', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='chus_collection_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', 'view_collections', 'chus_collection_date', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') , '0', '', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_adv_search'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='chus_collection_date' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_adv_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='collection_datetime' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') AND `flag_confidential`='0');

ALTER TABLE specimen_details 
  ADD COLUMN `chus_collection_datetime` datetime DEFAULT NULL,
  ADD COLUMN `chus_collection_datetime_accuracy` char(1) NOT NULL DEFAULT '';
ALTER TABLE specimen_details_revs 
  ADD COLUMN `chus_collection_datetime` datetime DEFAULT NULL,
  ADD COLUMN `chus_collection_datetime_accuracy` char(1) NOT NULL DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'chus_collection_datetime', 'datetime',  NULL , '0', '', '', '', 'specimen collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='chus_collection_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen collection datetime' AND `language_tag`=''), '1', '299', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='399' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('specimen collection datetime','Specimen Collection Date','Date de collection du spécimen'),
('at least one specimen will have a collection date different than the date set to the collection', 'At least one specimen will have a collection date different than the date set to the collection','Au moins un spécimen aura une date différente de la date assignée à la collection');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/Adhocs%';

UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1202' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DROP VIEW view_aliquot_uses;

CREATE VIEW `view_aliquot_uses` AS 

SELECT concat(`source`.`id`,1) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'sample derivative creation' AS `use_definition`,
-- - NEW -------------------------------------------------------------------------------------
    CONCAT(`sampctrl`.`sample_type`, ' [', `samp`.`sample_code`, ']') AS `use_code`,
-- --------------------------------------------------------------------------------------
'' AS `use_details`,
`source`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`der`.`creation_datetime` AS `use_datetime`,
`der`.`creation_datetime_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`der`.`creation_by` AS `used_by`,
`source`.`created` AS `created`,
concat('inventorymanagement/aliquot_masters/listAllSourceAliquots/',`samp`.`collection_id`,'/',`samp`.`id`) AS `detail_url`,
`samp2`.`id` AS `sample_master_id`,
`samp2`.`collection_id` AS `collection_id` 
FROM `source_aliquots` `source` 
JOIN `sample_masters` `samp` ON `samp`.`id` = `source`.`sample_master_id` AND `samp`.`deleted` <> 1
-- - NEW -------------------------------------------------------------------------------------
    JOIN `sample_controls` `sampctrl` ON `samp`.`sample_control_id` = `sampctrl`.`id`
-- --------------------------------------------------------------------------------------
JOIN `derivative_details` `der` ON `samp`.`id` = `der`.`sample_master_id` 
JOIN `aliquot_masters` `aliq` ON `aliq`.`id` = `source`.`aliquot_master_id` AND `aliq`.`deleted` <> 1 
JOIN `aliquot_controls` `aliqc` ON `aliq`.`aliquot_control_id` = `aliqc`.`id` 
JOIN `sample_masters` `samp2` ON `samp2`.`id` = `aliq`.`sample_master_id` AND `samp`.`deleted` <> 1 WHERE (`source`.`deleted` <> 1) 
			
UNION ALL
 
SELECT concat(`realiq`.`id`,2) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'realiquoted to' AS `use_definition`,
-- - NEW -------------------------------------------------------------------------------------
	CONCAT(`child`.`aliquot_label`,' [',`child`.`barcode`,']') AS `use_code`,
-- --------------------------------------------------------------------------------------
'' AS `use_details`,
`realiq`.`parent_used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`realiq`.`realiquoting_datetime` AS `use_datetime`,
`realiq`.`realiquoting_datetime_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`realiq`.`realiquoted_by` AS `used_by`,
`realiq`.`created` AS `created`,
concat('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',`child`.`collection_id`,'/',`child`.`sample_master_id`,'/',`child`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM ((((`realiquotings` `realiq` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `realiq`.`parent_aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `aliquot_masters` `child` ON (((`child`.`id` = `realiq`.`child_aliquot_master_id`) AND (`child`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`realiq`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`qc`.`id`,3) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'quality control' AS `use_definition`,
`qc`.`qc_code` AS `use_code`,
'' AS `use_details`,
`qc`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`qc`.`date` AS `use_datetime`,
`qc`.`date_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`qc`.`run_by` AS `used_by`,
`qc`.`created` AS `created`,
concat('/inventorymanagement/quality_ctrls/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`qc`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`quality_ctrls` `qc` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `qc`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`qc`.`deleted` <> 1)

UNION ALL 

SELECT concat(`item`.`id`,4) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'aliquot shipment' AS `use_definition`,
-- - NEW -------------------------------------------------------------------------------------
	CONCAT(`sh`.`shipment_code`, ' - ', `sh`.`recipient`) AS `use_code`,
-- --------------------------------------------------------------------------------------
'' AS `use_details`,
'' AS `used_volume`,
'' AS `aliquot_volume_unit`,
`sh`.`datetime_shipped` AS `use_datetime`,
`sh`.`datetime_shipped_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
`sh`.`shipped_by` AS `used_by`,
`sh`.`created` AS `created`,
concat('/order/shipments/detail/',`sh`.`order_id`,'/',`sh`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`order_items` `item` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `item`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `shipments` `sh` ON (((`sh`.`id` = `item`.`shipment_id`) AND (`sh`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`item`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`alr`.`id`,5) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
'specimen review' AS `use_definition`,
`spr`.`review_code` AS `use_code`,
'' AS `use_details`,
'' AS `used_volume`,
'' AS `aliquot_volume_unit`,
`spr`.`review_date` AS `use_datetime`,
`spr`.`review_date_accuracy` AS `use_datetime_accuracy`,
'' AS `duration`,
'' AS `duration_unit`,
'' AS `used_by`,
`alr`.`created` AS `created`,
concat('/inventorymanagement/specimen_reviews/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`spr`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`aliquot_review_masters` `alr` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `alr`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `specimen_review_masters` `spr` ON (((`spr`.`id` = `alr`.`specimen_review_master_id`) AND (`spr`.`deleted` <> 1)))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`alr`.`deleted` <> 1) 

UNION ALL 

SELECT concat(`aluse`.`id`,6) AS `id`,
`aliq`.`id` AS `aliquot_master_id`,
`aluse`.`type` AS `use_definition`,
`aluse`.`use_code` AS `use_code`,
`aluse`.`use_details` AS `use_details`,
`aluse`.`used_volume` AS `used_volume`,
`aliqc`.`volume_unit` AS `aliquot_volume_unit`,
`aluse`.`use_datetime` AS `use_datetime`,
`aluse`.`use_datetime_accuracy` AS `use_datetime_accuracy`,
`aluse`.`duration` AS `duration`,
`aluse`.`duration_unit` AS `duration_unit`,
`aluse`.`used_by` AS `used_by`,
`aluse`.`created` AS `created`,
concat('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',`aliq`.`id`,'/',`aluse`.`id`) AS `detail_url`,
`samp`.`id` AS `sample_master_id`,
`samp`.`collection_id` AS `collection_id` 
FROM (((`aliquot_internal_uses` `aluse` 
JOIN `aliquot_masters` `aliq` ON (((`aliq`.`id` = `aluse`.`aliquot_master_id`) AND (`aliq`.`deleted` <> 1)))) 
JOIN `aliquot_controls` `aliqc` ON ((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
JOIN `sample_masters` `samp` ON (((`samp`.`id` = `aliq`.`sample_master_id`) AND (`samp`.`deleted` <> 1)))) 
WHERE (`aluse`.`deleted` <> 1);
