-- Run against a 2.4.0 installation
-- Read the printed messages carefully

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.4.1', NOW(), '> 3884');

REPLACE INTO i18n(id, en, fr) VALUES
('core_app_version', '2.4.1', '2.4.1');

RENAME TABLE tx_masters TO treatment_masters;
RENAME TABLE tx_masters_revs TO treatment_masters_revs;
RENAME TABLE tx_controls TO treatment_controls;
UPDATE structure_fields SET tablename='treatment_masters' WHERE tablename='tx_masters';
UPDATE datamart_structures SET control_field='treatment_control_id' WHERE control_field='tx_control_id';
ALTER TABLE treatment_masters
 DROP FOREIGN KEY FK_tx_masters_tx_controls,
 CHANGE tx_control_id treatment_control_id INT NOT NULL,
 ADD FOREIGN KEY (`treatment_control_id`) REFERENCES treatment_controls(id);
ALTER TABLE treatment_masters_revs
 CHANGE tx_control_id treatment_control_id INT NOT NULL;

ALTER TABLE txd_chemos
 DROP FOREIGN KEY FK_txd_chemos_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txd_chemos_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
ALTER TABLE txd_radiations
 DROP FOREIGN KEY FK_txd_radiations_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txd_radiations_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
ALTER TABLE txd_surgeries
 DROP FOREIGN KEY FK_txd_surgeries_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txd_surgeries_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
 
SELECT IF(MAX(id) > 4, 'You need to alter your existing treatment details table. The field "tx_master_id" should now be renamed to "treatment_master_id".', '') AS msg FROM treatment_controls;

DROP VIEW view_aliquot_uses;
CREATE VIEW `view_aliquot_uses` AS select concat(`source`.`id`,1) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'sample derivative creation' AS `use_definition`,`samp`.`sample_code` AS `use_code`,'' AS `use_details`,`source`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`der`.`creation_datetime` AS `use_datetime`,`der`.`creation_datetime_accuracy` AS `use_datetime_accuracy`,`der`.`creation_by` AS `used_by`,`source`.`created` AS `created`,concat('inventorymanagement/aliquot_masters/listAllSourceAliquots/',`samp`.`collection_id`,'/',`samp`.`id`) AS `detail_url`,`samp2`.`id` AS `sample_master_id`,`samp2`.`collection_id` AS `collection_id` from (((((`source_aliquots` `source` 
join `sample_masters` `samp` on(((`samp`.`id` = `source`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) 
join `derivative_details` `der` on(((`samp`.`id` = `der`.`sample_master_id`) and (`der`.`deleted` <> 1)))) 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `source`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp2` on(((`samp2`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`source`.`deleted` <> 1) 
union all 
select concat(`realiq`.`id`,2) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'realiquoted to' AS `use_definition`,`child`.`barcode` AS `use_code`,'' AS `use_details`,`realiq`.`parent_used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`realiq`.`realiquoting_datetime` AS `use_datetime`,`realiq`.`realiquoting_datetime_accuracy` AS `use_datetime_accuracy`,`realiq`.`realiquoted_by` AS `used_by`,`realiq`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',`child`.`collection_id`,'/',`child`.`sample_master_id`,'/',`child`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from ((((`realiquotings` `realiq` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `realiq`.`parent_aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `aliquot_masters` `child` on(((`child`.`id` = `realiq`.`child_aliquot_master_id`) and (`child`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`realiq`.`deleted` <> 1) 
union all 
select concat(`qc`.`id`,3) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'quality control' AS `use_definition`,`qc`.`qc_code` AS `use_code`,'' AS `use_details`,`qc`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`qc`.`date` AS `use_datetime`,`qc`.`date_accuracy` AS `use_datetime_accuracy`,`qc`.`run_by` AS `used_by`,`qc`.`created` AS `created`,concat('/inventorymanagement/quality_ctrls/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`qc`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`quality_ctrls` `qc` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `qc`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`qc`.`deleted` <> 1)
union all 
select concat(`item`.`id`,4) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'aliquot shipment' AS `use_definition`,`sh`.`shipment_code` AS `use_code`,'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`sh`.`datetime_shipped` AS `use_datetime`,`sh`.`datetime_shipped_accuracy` AS `use_datetime_accuracy`,`sh`.`shipped_by` AS `used_by`,`sh`.`created` AS `created`,concat('/order/shipments/detail/',`sh`.`order_id`,'/',`sh`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`order_items` `item` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `item`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `shipments` `sh` on(((`sh`.`id` = `item`.`shipment_id`) and (`sh`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`item`.`deleted` <> 1) 
union all 
select concat(`alr`.`id`,5) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'specimen review' AS `use_definition`,`spr`.`review_code` AS `use_code`,'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`spr`.`review_date` AS `use_datetime`,`spr`.`review_date_accuracy` AS `use_datetime_accuracy`,'' AS `used_by`,`alr`.`created` AS `created`,concat('/inventorymanagement/specimen_reviews/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`spr`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_review_masters` `alr` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `alr`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `specimen_review_masters` `spr` on(((`spr`.`id` = `alr`.`specimen_review_master_id`) and (`spr`.`deleted` <> 1)))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`alr`.`deleted` <> 1) 
union all 
select concat(`aluse`.`id`,6) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'internal use' AS `use_definition`,`aluse`.`use_code` AS `use_code`,`aluse`.`use_details` AS `use_details`,`aluse`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`aluse`.`use_datetime` AS `use_datetime`,`aluse`.`use_datetime_accuracy` AS `use_datetime_accuracy`,`aluse`.`used_by` AS `used_by`,`aluse`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',`aliq`.`id`,'/',`aluse`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_internal_uses` `aluse` 
join `aliquot_masters` `aliq` on(((`aliq`.`id` = `aluse`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) 
join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) 
join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`aluse`.`deleted` <> 1);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('parent_sample_type', '', '', 'Inventorymanagement.SampleControl::getParentSampleTypePermissibleValues');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type')  WHERE model='ViewSample' AND tablename='' AND field='parent_sample_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type');
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('parent_sample_type_from_id', '', '', 'Inventorymanagement.SampleControl::getParentSampleTypePermissibleValuesFromId');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id')  WHERE model='ViewSample' AND tablename='' AND field='parent_sample_control_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id')  WHERE model='ViewAliquot' AND tablename='' AND field='parent_sample_control_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type')  WHERE model='ViewAliquot' AND tablename='' AND field='parent_sample_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type');

INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('all', 'clinical', 'biopsy', 1, 'eventmasters', 'qc_nd_ed_biopsy', 0, 'clinical|all|biopsy');

CREATE TABLE qc_nd_ed_biopsy(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_masters INT NOT NULL,
 precision VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_biopsy_revs(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_masters INT NOT NULL,
 precision VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0
)Engine=InnoDb;

ALTER TABLE txd_surgeries
 ADD COLUMN qc_nd_precision VARCHAR(200) NOT NULL DEFAULT '' AFTER treatment_master_id;
ALTER TABLE txd_surgeries_revs
 ADD COLUMN qc_nd_precision VARCHAR(200) NOT NULL DEFAULT '' AFTER treatment_master_id;

DELETE FROM protocol_controls;
INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(1, 'all', 'chemotherapy', 'pd_chemos', 'pd_chemos', 'pe_chemos', 'pe_chemos', NULL, 0, NULL, 0, 1),
(2, 'all', 'surgery', 'pd_surgeries', 'pd_surgeries', NULL, NULL, NULL, 0, NULL, 0, 1);


DELETE FROM treatment_controls;
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(1, 'chemotherapy', 'all', 1, 'txd_chemos', 'treatmentmasters,txd_chemos', 'txe_chemos', 'txe_chemos', 0, 1, 'importDrugFromChemoProtocol', 'all|chemotherapy'),
(2, 'radiation', 'all', 1, 'txd_radiations', 'treatmentmasters,txd_radiations', NULL, NULL, 0, NULL, NULL, 'all|radiation'),
(3, 'surgery', 'all', 1, 'txd_surgeries', 'treatmentmasters,txd_surgeries', 'txe_surgeries', 'txe_surgeries', 0, 2, NULL, 'all|surgery'),
(4, 'surgery without extension', 'all', 1, 'txd_surgeries', 'treatmentmasters,txd_surgeries', NULL, NULL, 0, 2, NULL, 'all|surgery without extension');