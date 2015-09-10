-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trunkate all inventory
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE ad_tissue_cores; TRUNCATE ad_tissue_cores_revs;
DELETE FROM aliquot_masters; DELETE FROM aliquot_masters_revs;

TRUNCATE sd_spe_tissues; TRUNCATE sd_spe_tissues_revs;
TRUNCATE specimen_details; TRUNCATE specimen_details_revs;
UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null;
DELETE FROM sample_masters; DELETE FROM sample_masters_revs;
			
TRUNCATE std_tma_blocks; TRUNCATE std_tma_blocks_revs;
UPDATE storage_masters SET parent_id = null;
DELETE FROM storage_masters; DELETE FROM storage_masters_revs;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inventory Configuration
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(193, 200, 203, 194);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Collection
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr)
VALUES 
('independent collection', 'Collection of controls (Independent)', 'Collection de contrôles (indépendante)');
INSERT INTO i18n (id,en,fr)  
VALUES 
('no field has to be completed','No field has to be completed','Aucun champ ne doit être complété');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Sample
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- view

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Remove Sample Nature & Precision

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_tf_collected_specimen_nature' AND `language_label`='collected specimen nature' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_nature') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_tf_collected_specimen_nature_precision' AND `language_label`='collected specimen nature precision' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_tf_collected_specimen_nature' AND `language_label`='collected specimen nature' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_nature') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_tf_collected_specimen_nature_precision' AND `language_label`='collected specimen nature precision' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_tf_collected_specimen_nature' AND `language_label`='collected specimen nature' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_nature') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_tf_collected_specimen_nature_precision' AND `language_label`='collected specimen nature precision' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE sd_spe_tissues 
	DROP COLUMN `qc_tf_collected_specimen_nature`,
	DROP COLUMN `qc_tf_collected_specimen_nature_precision`;
ALTER TABLE sd_spe_tissues_revs
	DROP COLUMN `qc_tf_collected_specimen_nature`,
	DROP COLUMN `qc_tf_collected_specimen_nature_precision`;	
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Tissue source

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');
UPDATE structure_value_domains SET source = null, `override`="" WHERE domain_name='tissue_source_list';
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list"), (SELECT id FROM structure_permissible_values WHERE value="breast" AND language_alias="breast"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("ovary", "ovary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list"), (SELECT id FROM structure_permissible_values WHERE value="ovary" AND language_alias="ovary"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("prostate", "prostate");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list"), (SELECT id FROM structure_permissible_values WHERE value="prostate" AND language_alias="prostate"), "", "1");
INSERT INTO i18n (id,en,fr) VALUES ('ovary','Ovary','Ovaire');

-- Add control infromation

ALTER TABLE sample_masters 
  ADD COLUMN qc_tf_is_tma_sample_control char(1) default 'n',
  ADD COLUMN qc_tf_tma_sample_control_code varchar(50),
  ADD COLUMN qc_tf_tma_sample_control_bank_id int(11);
ALTER TABLE sample_masters_revs 
  ADD COLUMN qc_tf_is_tma_sample_control char(1) default 'n',
  ADD COLUMN qc_tf_tma_sample_control_code varchar(50),
  ADD COLUMN qc_tf_tma_sample_control_bank_id int(11);
ALTER TABLE `sample_masters`
  ADD CONSTRAINT `FK_sample_masters_banks` FOREIGN KEY (`qc_tf_tma_sample_control_bank_id`) REFERENCES `banks` (`id`);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qc_tf_is_tma_sample_control', 'yes_no',  NULL , '0', '', '', '', 'control', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qc_tf_tma_sample_control_code', 'input',  NULL , '0', 'size=20', '', '', 'control name', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qc_tf_tma_sample_control_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_tf_is_tma_sample_control' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='control' AND `language_tag`=''), '1', '700', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_tf_tma_sample_control_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='control name' AND `language_tag`=''), '1', '701', 'control details', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_tf_tma_sample_control_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '702', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('control name','Code'),('control details', 'Control Details (If applicable)');
INSERT INTO i18n (id,en)  
VALUES 
('control', 'Control'),
('tissue source of a participant tissue should be a prostate','Tissue source of a participant tissue should be a prostate'),
('the code of a control is required','The code of a control is required'),
('no control data has to be set for a participant tissue','No control data has to be set for a participant tissue');

-- View update

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_tf_tma_sample_control_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0'), '0', '1', '', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_tf_tma_sample_control_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`=''), '0', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'qc_tf_is_tma_sample_control', 'yes_no',  NULL , '0', '', '', '', 'control', ''), 
('InventoryManagement', 'ViewSample', '', 'qc_tf_tma_sample_control_code', 'input',  NULL , '0', 'size=20', '', '', 'control name', ''), 
('InventoryManagement', 'ViewSample', '', 'qc_tf_tma_sample_control_bank_id', 'bank', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'select', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_is_tma_sample_control' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='control' AND `language_tag`=''), '0', '10', 'control detail', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_tma_sample_control_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='control name' AND `language_tag`=''), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_tma_sample_control_bank_id' AND `type`='bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='select' AND `language_tag`=''), '0', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='banks') ,  `language_label`='bank' WHERE model='ViewSample' AND tablename='' AND field='qc_tf_tma_sample_control_bank_id' AND `type`='bank' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='banks');
UPDATE structure_formats SET `language_heading`='control details' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_is_tma_sample_control' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_is_tma_sample_control' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='control details' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_tma_sample_control_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1000' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_is_tma_sample_control' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1001' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_tma_sample_control_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1002' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_tma_sample_control_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- *** NOTE: This line has been added to fix bug 3243: Error when saving edited sample data with no specimen field dispalyed ***

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='0', `display_order`='1000', `flag_override_label`='1', `language_label`=''
WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') 
AND structure_field_id=(SELECT id FROM structure_fields 
WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');

-- Remove derivative list all

UPDATE menus SET flag_active = 0 WHERE use_link like '/InventoryManagement/SampleMasters/listAllDerivatives%';

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Aliquot
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Aliquot nature

ALTER TABLE ad_tissue_cores 
	ADD COLUMN `qc_tf_core_nature_site` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qc_tf_core_nature_revised` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qc_tf_core_nature_precision` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE ad_tissue_cores_revs
	ADD COLUMN `qc_tf_core_nature_site` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qc_tf_core_nature_revised` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qc_tf_core_nature_precision` varchar(100) NOT NULL DEFAULT '';
UPDATE structure_value_domains SET domain_name = 'qc_tf_tissue_core_nature' WHERE domain_name = 'qc_tf_tissue_nature';
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("uninformative", "uninformative");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tissue_core_nature"), (SELECT id FROM structure_permissible_values WHERE value="uninformative" AND language_alias="uninformative"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'qc_tf_core_nature_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature') , '0', '', '', '', 'nature - site', ''), 
('InventoryManagement', 'AliquotDetail', '', 'qc_tf_core_nature_revised', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature') , '0', '', '', '', 'nature - revised', ''), 
('InventoryManagement', 'AliquotDetail', '', 'qc_tf_core_nature_precision', 'input',  NULL , '0', '', '', '', 'precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_tf_core_nature_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature - site' AND `language_tag`=''), '1', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_tf_core_nature_revised' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature - revised' AND `language_tag`=''), '1', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_tf_core_nature_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en) 
VALUES
('nature - site', 'Nature - Site'),
('nature - revised', 'Nature - Revised'),
('uninformative','Uninformative');

-- in stock details

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');

-- aliquot label

UPDATE structure_fields SET flag_confidential = 0 WHERE field = 'aliquot_label';

UPDATE structure_formats SET `display_order`='98' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='99', `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- view update

UPDATE structure_formats SET `display_order`='-1', `flag_override_type`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_bank_participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='parent_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'qc_tf_is_tma_sample_control', 'yes_no',  NULL , '0', '', '', '', 'control', ''), 
('InventoryManagement', 'ViewAliquot', '', 'qc_tf_tma_sample_control_code', 'input',  NULL , '0', 'size=20', '', '', 'control name', ''), 
('InventoryManagement', 'ViewAliquot', '', 'qc_tf_tma_sample_control_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_is_tma_sample_control' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='control' AND `language_tag`=''), '0', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_tma_sample_control_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='control name' AND `language_tag`=''), '1', '1001', 'control details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_tma_sample_control_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '1002', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_is_tma_sample_control' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');

-- i18n 

UPDATE structure_fields
SET `language_label`='bank of the control'
WHERE `field`='qc_tf_tma_sample_control_bank_id';
INSERT INTO i18n (id,en) VALUES ('bank of the control', 'Provider');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Path Review
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';
INSERT INTO `aliquot_review_controls` (`id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `aliquot_type_restriction`, `databrowser_label`) VALUES
(null, 'tissue core review', 1, 'qc_tf_ar_tissue_cores', 'qc_tf_ar_tissue_cores', 'core', 'tissue core review');
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM aliquot_review_controls WHERE review_type = 'tissue core review'), 'core review', 1, 'qc_tf_spr_tissue_cores', 'qc_tf_spr_tissue_cores', 'tissue|core review');

CREATE TABLE IF NOT EXISTS `qc_tf_spr_tissue_cores` (
  `specimen_review_master_id` int(11) NOT NULL,
  KEY `FK_qc_tf_spr_tissue_cores_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_tf_spr_tissue_cores_revs` (
  `specimen_review_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_tf_spr_tissue_cores`
  ADD CONSTRAINT `FK_qc_tf_spr_tissue_cores_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);
UPDATE structure_fields SET  `language_label`='pathologist/reviewer' WHERE model='SpecimenReviewMaster' AND tablename='specimen_review_masters' AND field='pathologist' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `field`='review_date'), 'notEmpty');

CREATE TABLE IF NOT EXISTS `qc_tf_ar_tissue_cores` (
  `aliquot_review_master_id` int(11) NOT NULL,
  revised_nature varchar(50) NOT NULL DEFAULT '', 
  grade varchar(20) NOT NULL DEFAULT '',
  notes text,
  KEY `FK_qc_tf_ar_tissue_cores_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_tf_ar_tissue_cores_revs` (
  `aliquot_review_master_id` int(11) NOT NULL,
  revised_nature varchar(50) NOT NULL DEFAULT '', 
  grade varchar(20) NOT NULL DEFAULT '',
  notes text,  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_tf_ar_tissue_cores`
  ADD CONSTRAINT `FK_qc_tf_ar_tissue_cores_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_tf_core_review_grade", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("2+2", "2+2"),
("3+2", "3+2"),
("3+3", "3+3"),
("3+3+4", "3+3+4"),
("3+3+5", "3+3+5"),
("3+4", "3+4"),
("3+4+5", "3+4+5"),
("3+5", "3+5"),
("4+3", "4+3"),
("4+4", "4+4"),
("4+4+3", "4+4+3"),
("4+5", "4+5"),
("5+3", "5+3"),
("5+4", "5+4"),
("5+5", "5+5"),
("B", "B");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="2+2" AND language_alias="2+2"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="3+2" AND language_alias="3+2"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="3+3" AND language_alias="3+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="3+3+4" AND language_alias="3+3+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="3+3+5" AND language_alias="3+3+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="3+4" AND language_alias="3+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="3+4+5" AND language_alias="3+4+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="3+5" AND language_alias="3+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="4+3" AND language_alias="4+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="4+4" AND language_alias="4+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="4+4+3" AND language_alias="4+4+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="4+5" AND language_alias="4+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="5+3" AND language_alias="5+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="5+4" AND language_alias="5+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="5+5" AND language_alias="5+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_core_review_grade"), (SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="B"), "", "1");
INSERT IGNORE INTO i18n (id,en) 
VALUES
("2+2", "2+2"),
("3+2", "3+2"),
("3+3", "3+3"),
("3+3+4", "3+3+4"),
("3+3+5", "3+3+5"),
("3+4", "3+4"),
("3+4+5", "3+4+5"),
("3+5", "3+5"),
("4+3", "4+3"),
("4+4", "4+4"),
("4+4+3", "4+4+3"),
("4+5", "4+5"),
("5+3", "5+3"),
("5+4", "5+4"),
("5+5", "5+5"),
("B", "B");
INSERT INTO structures(`alias`) VALUES ('qc_tf_ar_tissue_cores');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', '', 'revised_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature') , '0', '', '', '', 'nature', ''), 
('InventoryManagement', 'AliquotReviewDetail', '', 'grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_core_review_grade') , '0', '', '', '', 'grade', ''), 
('InventoryManagement', 'AliquotReviewDetail', '', 'notes', 'textarea',  NULL , '0', 'rows=2cols=30', '', '', 'notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ar_tissue_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='' AND `field`='revised_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ar_tissue_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='' AND `field`='grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_core_review_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade' AND `language_tag`=''), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ar_tissue_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id'), 'notEmpty');

INSERT INTO i18n (id,en) 
VALUES
('core review', 'Core Review'),
('pathologist/reviewer','Pathologist/Reviewer');

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tissue_core_nature"), (SELECT id FROM structure_permissible_values WHERE value="benign" AND language_alias="benign"), "0", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="qc_tf_tissue_core_nature" AND spv.value="benin" AND spv.language_alias="benin";
DELETE FROM structure_permissible_values WHERE value="benin" AND language_alias="benin" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tissue_core_nature"), (SELECT id FROM structure_permissible_values WHERE value="tumor" AND language_alias="tumor"), "0", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="qc_tf_tissue_core_nature" AND spv.value="tumoral" AND spv.language_alias="tumoral";
DELETE FROM structure_permissible_values WHERE value="tumoral" AND language_alias="tumoral" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Aliquot Use
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='duration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='duration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='duration_unit') AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') ,  `language_label`='' WHERE model='ViewAliquotUse' AND tablename='view_aliquot_uses' AND field='aliquot_volume_unit' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='duration_unit') AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TMA Block 29X29
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = '0';
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'TMA-blc 29X29', 'column', 'integer', 29, 'row', 'integer', 29, 0, 0, 0, 0, 0, 0, 1, 1, 'std_tma_blocks', 'std_tma_blocks', 'custom#storage types#TMA-blc 29X29', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types ');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('TMA-blc 29X29', 'TMA-block 29X29',  'TMA-bloc 29X29', '1', @control_id, NOW(), NOW(), 1, 1);
ALTER TABLE storage_masters  MODIFY short_label varchar(50) DEFAULT NULL;
ALTER TABLE storage_masters_revs  MODIFY short_label varchar(50) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'ViewStorageMaster', '', 'qc_tf_tma_name', 'input',  NULL , '0', 'size=20', '', '', 'tma name central', ''), 
('StorageLayout', 'ViewStorageMaster', '', 'qc_tf_tma_label_site', 'input',  NULL , '0', 'size=20', '', '', 'TMA label site', ''), 
('StorageLayout', 'ViewStorageMaster', '', 'qc_tf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qc_tf_tma_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='tma name central' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qc_tf_tma_label_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='TMA label site' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qc_tf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qc_tf_tma_label_site' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qc_tf_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='storagemasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='storagemasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES ('TMA label site','TMA Label-Bank');

DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('qc_tf_bank_id', 'qc_tf_tma_label_site') AND model = 'StorageMaster');

INSERT INTO i18n (id,en) VALUES ('a bank has to be selected','A bank has to be selected');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Clean Up System Data
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE groups MODIFY deleted tinyint(3) unsigned NOT NULL DEFAULT '0';

UPDATE datamart_structure_functions SET flag_active = '0'
WHERE label = 'number of elements per participant'
AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','ReproductiveHistory','FamilyHistory','ParticipantMessage','ParticipantContact','QualityCtrl'));
UPDATE datamart_structure_functions SET flag_active = '0'
WHERE label = 'create uses/events (aliquot specific)';

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster','AliquotReviewMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster','AliquotReviewMaster'));

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ViewAliquotUse'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ViewAliquotUse'));

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- New Bug Fix
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Bank display in invetory

INSERT INTO structure_value_domains (domain_name, source) VALUES ('qc_tf_banks_for_controls', 'Administrate.Bank::getBankPermissibleValuesForControls');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_banks_for_controls') WHERE field = 'qc_tf_tma_sample_control_bank_id';

-- Search on aliquot ATiM TFRI# as an integer

UPDATE structure_fields SET  `type`='integer_positive',  `setting`='size=10' WHERE model='ViewAliquot' AND tablename='' AND field='participant_identifier' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Report Update
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Metastasis', '', 'qc_tf_first_bone_metastasis', 'date',  NULL , '0', '', '', '', 'first bone metastasis date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Metastasis' AND `tablename`='' AND `field`='qc_tf_first_bone_metastasis' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first bone metastasis date' AND `language_tag`=''), '0', '602', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='603' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Metastasis' AND `tablename`='' AND `field`='other_types' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('first bone metastasis date','1st Bone Metastasis Date');
UPDATE structure_fields SET field = 'qc_tf_first_bone_metastasis_date' WHERE field = 'qc_tf_first_bone_metastasis';

UPDATE datamart_reports SET name = 'CPCBN Summary - Clinical Data' WHERE name = 'CPCBN Summary';
UPDATE datamart_reports SET name = 'CPCBN Summary - Clinical Data + Cores Positions', description = 'Include both clinical data and TMA cores positions' WHERE name = 'Full CPCBN Summary';
INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`, `associated_datamart_structure_id`, `limit_access_from_datamart_structrue_function`) VALUES
(null, 'CPCBN Summary - Clinical Data + Cores Positions & Revisions Data', 'Include clinical data, TMA cores positions and core revisions data', 'qc_tf_cpcbn_summary_parameters', 'qc_tf_cpcbn_summary_results,qc_tf_cpcbn_summary_positions,qc_tf_cpcbn_summary_core_details', 'index', 'buildCpcbnSummaryLevel3', 1, NULL, 0, NULL, 0, 4, 0);
UPDATE datamart_reports SET function = 'buildCpcbnSummaryLevel2' WHERE function = 'buildFullCpcbnSummary';
UPDATE datamart_reports SET name = 'CPCBN Summary - Level1' WHERE name = 'CPCBN Summary - Clinical Data';
UPDATE datamart_reports SET name = 'CPCBN Summary - Level2' WHERE name = 'CPCBN Summary - Clinical Data + Cores Positions';
UPDATE datamart_reports SET name = 'CPCBN Summary - Level3' WHERE name LIKE 'CPCBN Summary - Clinical Data + Cores Positions &%';
INSERT IGNORE INTO i18n (id,en)
VALUES
('CPCBN Summary - Level1', 'CPCBN Summary - Clinical Data'),
('CPCBN Summary - Level2', 'CPCBN Summary - Clinical Data + Cores Positions'),
('CPCBN Summary - Level3', 'CPCBN Summary - Clinical Data + Cores Positions & Revisions Data'),
('Include both clinical data and TMA cores positions', 'Include both clinical data and TMA cores positions'),
('Include clinical data, TMA cores positions and core revisions data', 'Include clinical data, TMA cores positions and core revisions data');
UPDATE datamart_structure_functions SET label = 'build cpcbn summary level 1' WHERE label = 'build cpcbn summary';
UPDATE datamart_structure_functions SET label = 'build cpcbn summary level 2' WHERE label = 'build full cpcbn summary';
SET @control_id = (SELECT id FROM datamart_reports WHERE name = 'CPCBN Summary - Level3');
INSERT INTO datamart_structure_functions (`datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`)
(SELECT `datamart_structure_id`, 'build cpcbn summary level 3', CONCAT('/Datamart/Reports/manageReport/',@control_id), `flag_active`, `ref_single_fct_link` FROM `datamart_structure_functions` WHERE label = 'build cpcbn summary level 2');
INSERT IGNORE INTO i18n (id,en)
VALUES
('build cpcbn summary level 1', 'Build CPCBN Summary - Clinical Data'),
('build cpcbn summary level 2', 'Build CPCBN Summary - Clinical Data + Cores Positions'),
('build cpcbn summary level 3', 'Build CPCBN Summary - Clinical Data + Cores Positions & Revisions Data');

INSERT INTO structures(`alias`) VALUES ('qc_tf_cpcbn_summary_core_details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_core_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_tf_core_nature_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature - site' AND `language_tag`=''), '0', '1000', 'core details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_core_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_tf_core_nature_revised' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature - revised' AND `language_tag`=''), '0', '1001', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_core_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='' AND `field`='revised_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_core_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature' AND `language_tag`=''), '0', '1050', 'core review', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_core_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='' AND `field`='grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_core_review_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade' AND `language_tag`=''), '0', '1051', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO i18n (id,en) VALUES ('core details','Core Details');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6213' WHERE version_number = '2.6.4';
UPDATE versions SET branch_build_number = '6217' WHERE version_number = '2.6.4';
UPDATE versions SET branch_build_number = '6241' WHERE version_number = '2.6.4';
INSERT INTO i18n (id,en) VALUES ('for review', 'For Review');
UPDATE versions SET branch_build_number = '6242' WHERE version_number = '2.6.4';

-- 2015-09-10 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='gleason_score_biopsy_turp');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_biopsy_turp' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason score biopsy and turp' AND `language_tag`=''), '0', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Generated', '', 'qc_tf_gleason_grade_rp', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') , '0', '', '', '', 'gleason grade rp', ''), 
('ClinicalAnnotation', 'Generated', '', 'qc_tf_gleason_grade_biopsy_turp', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') , '0', '', '', '', 'gleason grade biopsy and turp', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_tf_gleason_grade_rp' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade rp' AND `language_tag`=''), '0', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_tf_gleason_grade_biopsy_turp' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade biopsy and turp' AND `language_tag`=''), '0', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO i18n (id,en) VALUES ('gleason grade rp', 'Gleason Grade RP'),('gleason grade biopsy and turp', 'Gleason Grade Biopsy / TURP');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Generated', '', 'qc_tf_rp_to_bone_met', 'input',  NULL , '0', '', '', '', '', 'rp to bone met'),
('ClinicalAnnotation', 'Generated', '', 'qc_tf_rp_to_bcr', 'input',  NULL , '0', '', '', '', '', 'rp to bcr'),
('ClinicalAnnotation', 'Generated', '', 'qc_tf_rp_to_last_contact', 'input',  NULL , '0', '', '', '', '', 'rp to last contact');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_tf_rp_to_last_contact'), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_tf_rp_to_bcr'), '0', '400', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_tf_rp_to_bone_met'), '0', '602', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `field`='start_date'), '0', '10', '', '', '1', 'rp date', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
REPLACE INTO i18n (id,en)
VALUES
('rp to bone met', 'Since RP (Months)'),
('rp to bcr', 'Since RP (Months)'),
('rp to last contact', 'Since RP (Months)'),
('rp date', 'RP Date'),
('intervals from rp have been calculated with at least one inaccuracy date','Intervals from RP have been calculated with at least one inaccuracy date.');
UPDATE versions SET branch_build_number = '6264' WHERE version_number = '2.6.4';
