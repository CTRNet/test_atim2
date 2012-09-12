
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

UPDATE aliquot_controls SET volume_unit = 'ul' WHERE sample_control_id IN (select id from sample_controls WHERE sample_type IN ('dna','rna','amplified rna','cdna'));

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aliquot used volume', '', 'Used Volume', 'Volume utilisé'),
('aliquots with volume', '', 'Aliquots with volume', 'Aliquots avec volume'),
('aliquots without volume', '', 'Aliquots without volume', 'Aliquots sans volume'),
('current volume', '', 'Current Volume', 'Volume courant'),
('initial volume', '', 'Initial Volume', 'Volume initial'),
('no volume has to be recorded for this aliquot type', '', 'No volume has to be recorded for this aliquot type!', 'Aucun volume doit être enregistré pour ce type d''aliquot!'),
('no volume has to be recorded when the volume unit field is empty', '', 'No volume has to be recorded when the volume unit field is empty!', 'Aucun volume ne doit être enregistré losque le champ ''unité'' est vide!'),
('parent used volume', '', 'Parent Used Volume', 'Volume utilisé du parent'),
('parent_used_volume_help', '', 'Volume of the parent aliquot used to create the children aliquot.', 'Volume de l''aliquot parent utilisé pour créer l''aliquot enfant.'),
('source aliquot used volume', '', 'Used Volume', 'Volume utilisé'),
('source_used_volume_help', '', 'Volume of the source aliquot to create the new derivative sample.', 'Volume de l''aliquot source utilisé pour créer l''échantillon dérivé.'),
('tested aliquot used volume', '', 'Used Volume', 'Volume utilisé'),
('tested_aliquot_volume_help', '', 'Volume of the aliquot used for the quality control.', 'Volume de l''aliquot utilisé pour le contrôle de qualité.'),
('the aliquot with barcode [%s] has reached a volume bellow 0', '', 'The aliquot with barcode [%s] has reached a volume below 0.', 'L''aliquot avec le code à barres [%s] a atteint un volume inférieur à 0.'),
('the inputed volume was automatically removed', '', 'The inputed volume was automatically removed', 'La valeur de volume entrée a été automatiquement retirée'),
('the used volume is higher than the remaining volume', '', 'The used volume is higher than the remaining volume', 'Le volume utilisé est supérieur au volume restant'),
('this aliquot has no recorded volume', '', 'This aliquot has no recorded volume', 'Cet aliquot n''a aucun volume enregistré'),
('used volume', '', 'Used Volume', 'Volume utilisé'),
('volume should be a positif decimal', '', 'Volume should be a positive decimal!', 'Le volume doit être un décimal positif!'),
('volume unit', '', 'Volume Unit', 'Unité de volume');


ALTER TABLE ad_tubes
  ADD COLUMN `chum_current_weight_ug` decimal(10,5) DEFAULT NULL;
ALTER TABLE ad_tubes_revs
  ADD COLUMN `chum_current_weight_ug` decimal(10,5) DEFAULT NULL;  

INSERT INTO structures(`alias`) VALUES ('chus_dna_rna_weight');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'chum_current_weight_ug', 'float',  NULL , '0', 'size=5', '', '', 'current weight ug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dna_rna_weight'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='chum_current_weight_ug' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current weight ug' AND `language_tag`=''), '1', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE aliquot_controls, sample_controls
SET aliquot_controls.detail_form_alias = CONCAT(aliquot_controls.detail_form_alias, ',chus_dna_rna_weight') 
WHERE aliquot_controls.sample_control_id  = sample_controls.id
AND sample_controls.sample_type IN ('dna','rna','amplified rna','cdna');

INSERT INTO i18n (id,en,fr) VALUES ('current weight ug','Current Weight (ug)','Poids courant (ug)');

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='concentration_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ug/ul" AND language_alias="ug/ul");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='concentration_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ng/ul" AND language_alias="ng/ul");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='concentration_unit' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="pg/ul" AND language_alias="pg/ul");


UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
















REPLACE INTO view_aliquots (SELECT 
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id, 
			Collection.bank_id, 
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id, 
			
			Participant.participant_identifier, 
			
Collection.misc_identifier_id AS misc_identifier_id,
MiscIdentifier.identifier_value AS frsq_number,
			
			Collection.acquisition_label, 
			
			SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
			SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
			ParentSampleControl.sample_type AS parent_sample_type,
			ParentSampleMaster.sample_control_id AS parent_sample_control_id,
			SampleControl.sample_type,
			SampleMaster.sample_control_id,
			
			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotControl.aliquot_type,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
			
			StorageMaster.code,
			StorageMaster.selection_label,
			AliquotMaster.storage_coord_x,
			AliquotMaster.storage_coord_y,
			
			StorageMaster.temperature,
			StorageMaster.temp_unit,
			
			AliquotMaster.created,
			
--			IF(AliquotMaster.storage_datetime IS NULL, NULL,
--			 IF(Collection.collection_datetime IS NULL, -1,
--			 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
--			 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
--			 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
IF(AliquotMaster.storage_datetime IS NULL, NULL,
 IF(InitialSpecimenDetail.chus_collection_datetime IS NULL, -1,
 IF(InitialSpecimenDetail.chus_collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
 IF(InitialSpecimenDetail.chus_collection_datetime > AliquotMaster.storage_datetime, -3,
 TIMESTAMPDIFF(MINUTE, InitialSpecimenDetail.chus_collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,			 
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(SpecimenDetail.reception_datetime IS NULL, -1,
			 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(DerivativeDetail.creation_datetime IS NULL, -1,
			 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,
			 
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes
			
			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
LEFT JOIN specimen_details AS InitialSpecimenDetail ON InitialSpecimenDetail.sample_master_id=SampleMaster.initial_specimen_sample_id
LEFT JOIN misc_identifiers MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id and MiscIdentifier.deleted <> 1
			WHERE AliquotMaster.deleted != 1 AND AliquotMaster.barcode != AliquotMaster.id)















