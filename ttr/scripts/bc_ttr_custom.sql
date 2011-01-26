-- collection type
REPLACE INTO i18n (id, en, fr) VALUES
("collection type", "Collection type", "Type de collection");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'Collection', 'collections', 'bc_ttr_collection_type', 'collection type', '', 'select', '', '',  144 , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bc_ttr_collection_type'), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '1');
-- TODO: create that field into view_collections

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_blocs', 'bc_ttr_is_large', 'large', '', 'checkbox', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocs' AND `field`='bc_ttr_is_large' AND `language_label`='large' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');



-- blocks
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_site' AND `language_label`='tissue site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_site')  AND `language_help`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_type' AND `language_label`='tissue type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_type')  AND `language_help`=''), '1', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size_of_tumour' AND `language_label`='size of tumour' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_observation' AND `language_label`='tissue observation' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_time_of_removal' AND `language_label`='time of removal' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '79', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_page_time' AND `language_label`='page time' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_arrival_in_patho_lab' AND `structure_value_domain`  IS NULL  ), '1', '81', '', '1', 'tissue arrival in patho lab', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_pathologist_presence' AND `language_label`='pathologist presence' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_in_transporter' AND `language_label`='tissue in transporter' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_transporter' AND `language_label`='transporter' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_path_reference' AND `language_label`='path reference' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size1' AND `structure_value_domain`  IS NULL  ), '1', '86', '', '1', 'size', '0', '', '0', '', '1', 'float', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size2' AND `structure_value_domain`  IS NULL  ), '1', '87', '', '0', '', '0', '', '0', '', '1', 'float', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size3' AND `structure_value_domain`  IS NULL  ), '1', '88', '', '0', '', '0', '', '0', '', '1', 'float', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_subsite' AND `language_label`='tissue subsite' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_subsite')  AND `language_help`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_block_observation' AND `structure_value_domain`  IS NULL  ), '1', '89', '', '1', 'bc ttr block observation', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

UPDATE structure_fields SET setting='' WHERE id IN(1887, 1888);

ALTER TABLE `storage_masters` ADD `label_precision` VARCHAR( 50 ) NULL AFTER `short_label` ;
ALTER TABLE `storage_masters_revs` ADD `label_precision` VARCHAR( 50 ) NULL AFTER `short_label` ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Storagelayout', 'StorageMaster', 'storage_masters', 'label_precision', '', '-', 'input', 'size=10', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='label_precision' AND `language_label`='' AND `language_tag`='-' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_surr_tmp'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='label_precision' AND `language_label`='' AND `language_tag`='-' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='storagemasters'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='label_precision' AND `language_label`='' AND `language_tag`='-' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE storage_controls SET set_temperature = 'FALSE', is_tma_block = 'FALSE' WHERE storage_type IN ('box 1,1-9,9', 'tower');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='code' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_control_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='selection_label' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='temperature' AND type='float' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='temp_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code'));
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='short_label' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='temp_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code'));

-- update parent id of blood cell
update atim.sample_masters spec , atim.sample_masters der
set der.parent_id = spec.id
where der.collection_id = spec.collection_id
and spec.sample_type = 'blood'
and der.sample_type = 'blood cell';

-- update parent id of plasma
update atim.sample_masters spec , atim.sample_masters der
set der.parent_id = spec.id
where der.collection_id = spec.collection_id
and spec.sample_type = 'blood'
and der.sample_type = 'plasma';

UPDATE sample_masters 
SET initial_specimen_sample_id = id, initial_specimen_sample_type = sample_type
WHERE sample_category = 'specimen';

UPDATE sample_masters spec, sample_masters deri
SET deri.initial_specimen_sample_id = spec.id, deri.initial_specimen_sample_type = spec.sample_type
WHERE spec.id = deri.parent_id AND spec.sample_category = 'specimen'
AND deri.sample_category = 'derivative';

INSERT INTO specimen_details
(sample_master_id, created, created_by, modified, modified_by, deleted)
SELECT id, created, created_by, modified, modified_by, deleted
FROM  sample_masters WHERE sample_category = 'specimen'; 

INSERT INTO derivative_details
(sample_master_id, created, created_by, modified, modified_by, deleted)
SELECT id, created, created_by, modified, modified_by, deleted
FROM  sample_masters WHERE sample_category = 'derivative'; 

-- clean up revs tables...

ALTER TABLE  atim.`ad_whatman_papers_revs` ADD  `bc_ttr_dna_card_type` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`ad_whatman_papers_revs` ADD  `bc_ttr_dna_card_lot_no` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`ad_whatman_papers_revs` ADD  `bc_ttr_dna_card_spot` TINYINT( 4 ) NULL AFTER  `deleted_date`;

ALTER TABLE  atim.`aliquot_masters_revs` ADD  `bc_ttr_old_sample_master_id` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`aliquot_masters_revs` ADD  `bc_ttr_old_parent_sample_id` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`aliquot_masters_revs` ADD  `bc_ttr_old_collection_id` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`aliquot_masters_revs` ADD  `bc_ttr_sample_type` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`aliquot_masters_revs` ADD  `bc_ttr_release_barcode` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`aliquot_masters_revs` ADD  `bc_ttr_previous_box_id` VARCHAR( 20 ) NULL AFTER  `deleted_date`;

ALTER TABLE  atim.`sample_masters_revs` ADD  `bc_ttr_buffy_coat_lab_tech` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters_revs` ADD  `bc_ttr_ttrdb_acquisition_label` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters_revs` ADD  `bc_ttr_plasma_transporter_time` time NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters_revs` ADD  `bc_ttr_plasma_temperature` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters_revs` ADD  `bc_ttr_plasma_Gval` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters_revs` ADD  `bc_ttr_plasma_duration` INT(4) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters_revs` ADD  `bc_ttr_plasma_lab_tech` VARCHAR( 20 ) NULL AFTER  `deleted_date`;

ALTER TABLE  atim.`sd_der_plasmas_revs` ADD  `bc_ttr_plasma_transporter_time` time NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas_revs` ADD  `bc_ttr_plasma_temperature` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas_revs` ADD  `bc_ttr_plasma_Gval` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas_revs` ADD  `bc_ttr_plasma_duration` INT(4) NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas_revs` ADD  `bc_ttr_plasma_lab_tech` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;

ALTER TABLE  atim.`sd_der_blood_cells_revs` ADD  `bc_ttr_buffy_coat_lab_tech` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;

ALTER TABLE atim.aliquot_masters_revs
 ADD COLUMN tmp_id int DEFAULT NULL,
 ADD COLUMN tmp_slide_id int DEFAULT NULL;

ALTER TABLE atim.aliquot_masters_revs
 ADD COLUMN bc_ttr_prev_storage_id int DEFAULT NULL;

ALTER TABLE aliquot_review_masters_revs CHANGE   `aliquot_masters_id` `aliquot_master_id` int(11) DEFAULT NULL;

DROP TABLE tmp_slides;
DROP TABLE a_tmp_tubes;
DROP TABLE a_tmp_tubes_plasma;
DROP TABLE a_tmp_whatman_paper;

CREATE TABLE IF NOT EXISTS `std_towers_revs` (
  `id` int(11) NOT NULL,
  
  `storage_master_id` int(11) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;




