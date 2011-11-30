-- Run against a 2.4.0 installation
-- Read the printed messages carefully

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.4.1', NOW(), '3918');

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

-- Split Treatment forms

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'treatmentmasters') AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field IN ('tx_method', 'start_date', 'disease_site'));
DELETE FROM structure_formats WHERE structure_id IN (SELECT st.id FROM treatment_controls as tc INNER JOIN structures as st ON st.alias = tc.form_alias) AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('tx_method', 'start_date', 'disease_site'));
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE treatment_controls SET form_alias = CONCAT('treatmentmasters,',form_alias);
UPDATE structure_fields SET language_label = 'date/start date' WHERE field = 'start_date' AND model = 'TreatmentMaster';
INSERT INTO i18n (id,en,fr) VALUES ('date/start date', 'Date/Start date', 'Date/Date de commencement');

-- Split Annotation forms

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'eventmasters') AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field IN ('disease_site', 'event_type', 'event_date', 'event_group'));
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id IN (SELECT st.id FROM event_controls as ec INNER JOIN structures as st ON st.alias = ec.form_alias) AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('disease_site', 'event_type', 'event_date', 'event_group'));
UPDATE event_controls SET form_alias = CONCAT('eventmasters,',form_alias);

-- diagnosis controls & undetailled diag

UPDATE diagnosis_controls SET controls_type = 'undetailed' WHERE controls_type IN ('basic secondary', 'basic remission', 'basic progression', 'basic recurrence');
INSERT INTO i18n (id,en,fr) VALUES ('undetailed' ,'Undetailed', 'non détaillée');

-- Add event comorbidity

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
( null, 'all', 'clinical', 'comorbidity', 1, 'eventmasters,ed_all_comorbidities', 'ed_all_comorbidities', 0, 'clinical|all|comorbidity');

CREATE TABLE IF NOT EXISTS `ed_all_comorbidities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `title` varchar(50) DEFAULT NULL,
  `icd10_code` varchar(10) DEFAULT NULL,
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `ed_all_comorbidities_revs` (
  `id` int(11) NOT NULL,
  
  `title` varchar(50) DEFAULT NULL,
  `icd10_code` varchar(10) DEFAULT NULL,
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ed_all_comorbidities`
  ADD CONSTRAINT `ed_all_comorbidities_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('ed_all_comorbidities');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_all_comorbidities', 'title', 'input',  NULL , '0', '', '', '', 'title', ''), 
('Clinicalannotation', 'EventDetail', 'ed_all_comorbidities', 'icd10_code', 'autocomplete',  NULL , '0', 'size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who', '', '', 'disease code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_comorbidities'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_comorbidities'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_comorbidities' AND `field`='title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='title' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_comorbidities'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_comorbidities' AND `field`='icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='' AND `language_label`='disease code' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES ('comorbidity','Comorbidity','Comorbidité');

UPDATE menus SET use_summary='Clinicalannotation.EventMaster::summary' WHERE use_summary='Clinicalannotation.EventControl::summary';