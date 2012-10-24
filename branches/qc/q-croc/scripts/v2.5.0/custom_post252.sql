
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopControl' AND `tablename`='sop_controls' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sop_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='activated_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='lesion size (cm)' WHERE model='TreatmentDetail' AND tablename='qcroc_txd_liver_biopsies' AND field='lesion_size' AND `type`='float_positive' AND structure_value_domain  IS NULL ;

REPLACE INTO i18n (id,en) VALUES 
('sop_code','SOP#'),('sop_version','Version#'),
('lesion size (cm)','Lesion size (cm)');

-- -------------------------------------------------------------------------------------------
-- COLLECTION
-- -------------------------------------------------------------------------------------------

ALTER TABLE collections 
  ADD COLUMN `qcroc_collection_date` date DEFAULT NULL;
ALTER TABLE collections_revs 
  ADD COLUMN `qcroc_collection_date` date DEFAULT NULL;  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_collection_date', 'date',  NULL , '0', '', '', '', 'collection datetime', '');
SET @new_structure_field_id =(SELECT id FROM structure_fields WHERE field = 'qcroc_collection_date' AND model = 'Collection');
SET @collection_datetime_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'collection_datetime' AND model = 'Collection');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT `structure_id`, @new_structure_field_id, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @collection_datetime_structure_field_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qcroc_collection_date', 'date',  NULL , '0', '', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_collection_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', 'view_collections', 'qcroc_collection_date', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') , '0', '', '', '', 'collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_adv_search'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qcroc_collection_date' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection datetime' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_adv_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='collection_datetime' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime') AND `flag_confidential`='0');
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('view_collection','collections','linked_collections')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('bank_id','sop_master_id','acquisition_label','collection_datetime') AND model IN ('ViewCollection','Collection'));
REPLACE i18n (id,en,fr) VALUES ('collection datetime','Visite Date','Date de visite');

ALTER TABLE collections 
  ADD COLUMN `qcroc_protocol` varchar(50) DEFAULT NULL;
ALTER TABLE collections_revs 
  ADD COLUMN `qcroc_protocol` varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qcroc_protocol", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Collection: Protocol\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Collection: Protocol', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Collection: Protocol');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Q-CROC-01', 'Q-CROC-01', '', '1', @control_id, NOW(), NOW(), 1, 1),
('Q-CROC-02', 'Q-CROC-02', '', '1', @control_id, NOW(), NOW(), 1, 1),
('Q-CROC-03', 'Q-CROC-03', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_protocol', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol'), '0', '', '', '', 'qcroc protocol', '');
SET @new_structure_field_id =(SELECT id FROM structure_fields WHERE field = 'qcroc_protocol' AND model = 'Collection');
SET @collection_site_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'collection_site' AND model = 'Collection');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT `structure_id`, @new_structure_field_id, '0', '0', `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @collection_site_structure_field_id);
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='qcroc_protocol'), 'notEmpty', '', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qcroc_protocol', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol') , '0', '', '', '', 'qcroc protocol', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_protocol' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qcroc protocol' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

REPLACE INTO i18n (id,en) VALUES ('qcroc protocol','Protocol');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_collection_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_protocol' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------
-- Inventory Configuration
-- --------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 1, 12, 19, 131, 135, 23, 136, 2, 25, 3, 119, 132, 6, 142, 105, 112, 106, 143, 120, 124, 121, 141, 103, 109, 104, 144, 122, 127, 123, 7, 130, 101, 102, 140, 11, 10);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(33);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(34);

-- --------------------------------------------------------------------------------
-- TISSUE
-- --------------------------------------------------------------------------------

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('sd_spe_tissues'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');

ALTER TABLE specimen_details 
  ADD COLUMN `qcroc_collection_time` time DEFAULT NULL;
ALTER TABLE specimen_details_revs 
  ADD COLUMN `qcroc_collection_time` time DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'qcroc_collection_time', 'time',  NULL , '0', '', '', 'qcroc_collection_time_help', 'specimen collection datetime', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='qcroc_collection_time' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='specimen collection datetime' AND `language_tag`=''), '1', '299', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

REPLACE INTO i18n (id,en) VALUES ('specimen collection datetime','Collection Time (site)'),('qcroc_collection_time_help','Time of Bx / Time of blood draw (Site)');

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('specimens'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('coll_to_rec_spent_time_msg','time_at_room_temp_mn','coll_to_rec_spent_time_msg','reception_datetime','reception_by','supplier_dept'));

ALTER TABLE sd_spe_tissues
	ADD COLUMN qcroc_placed_in_stor_sol_within_5mn char(1) DEFAULT '',
	ADD COLUMN qcroc_placed_in_stor_sol_within_5mn_reason varchar(250) DEFAULT '';	
ALTER TABLE sd_spe_tissues_revs
	ADD COLUMN qcroc_placed_in_stor_sol_within_5mn char(1) DEFAULT '',
	ADD COLUMN qcroc_placed_in_stor_sol_within_5mn_reason varchar(250) DEFAULT '';	
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qcroc_placed_in_stor_sol_within_5mn', 'yes_no',  NULL , '0', '', '', '', 'qcroc placed in stor sol within 5mn', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qcroc_placed_in_stor_sol_within_5mn_reason', 'input',  NULL , '0', 'size=40', '', '', 'qcroc placed in stor sol within 5mn reason', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_placed_in_stor_sol_within_5mn' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qcroc placed in stor sol within 5mn' AND `language_tag`=''), '1', '441', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_placed_in_stor_sol_within_5mn_reason' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='qcroc placed in stor sol within 5mn reason' AND `language_tag`=''), '1', '442', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en)
VALUES
('qcroc placed in stor sol within 5mn','Was sample placed in RNAlater or Formalin within 5mn'),
('qcroc placed in stor sol within 5mn reason','If >5mn, provide a reason');
	
ALTER TABLE aliquot_masters
	ADD COLUMN qcroc_barcode varchar(60) DEFAULT '';
ALTER TABLE aliquot_masters_revs
	ADD COLUMN qcroc_barcode varchar(60) DEFAULT '';	
	
INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
(null, '', 'InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_barcode', 'barcode', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', 0),
(null, '', 'InventoryManagement', 'ViewAliquot', '', 'qcroc_barcode', 'barcode', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', 0);
SET @qcroc_barcode_field_id =(SELECT id FROM structure_fields WHERE field = 'qcroc_barcode' AND model = 'AliquotMaster');
SET @barcode_field_id = (SELECT id FROM structure_fields WHERE field = 'barcode' AND model = 'AliquotMaster');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT `structure_id`, @qcroc_barcode_field_id, 'display_column', 'display_order', `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @barcode_field_id);
SET @qcroc_barcode_field_id =(SELECT id FROM structure_fields WHERE field = 'qcroc_barcode' AND model = 'ViewAliquot');
SET @barcode_field_id = (SELECT id FROM structure_fields WHERE field = 'barcode' AND model = 'ViewAliquot');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT `structure_id`, @qcroc_barcode_field_id, 'display_column', 'display_order', `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @barcode_field_id);

UPDATE structure_fields SET language_label = 'aliquot system code' WHERE field = 'barcode' AND model LIKE '%Aliquot%';

UPDATE structure_formats SET `display_column`='1', `display_order`='1202', `flag_add`='0', `flag_addgrid`='0', `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1', `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

UPDATE aliquot_controls SET detail_tablename = 'qcroc_ad_tissue_tubes', detail_form_alias = 'qcroc_ad_tissue_tubes' WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue') AND aliquot_type = 'tube';

CREATE TABLE IF NOT EXISTS `qcroc_ad_tissue_tubes` (
  `aliquot_master_id` int(11) NOT NULL,
  tube_type varchar(50) DEFAULT null,
  time_placed_at_4c time DEFAULT null,
  date_sample_received datetime DEFAULT null,
  time_remained_in_rna_later_days int(6) DEFAULT null,
  temperature_in_box_celsius decimal(6,2) DEFAULT NULL,
  sample_condition_at_reception  varchar(50) DEFAULT null,
  KEY `FK_ad_tubes_aliquot_masters` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qcroc_ad_tissue_tubes_revs` (
  `aliquot_master_id` int(11) NOT NULL,
  tube_type varchar(50) DEFAULT null,
  time_placed_at_4c time DEFAULT null,
  date_sample_received datetime DEFAULT null,
  time_remained_in_rna_later_days int(6) DEFAULT null,
  temperature_in_box_celsius decimal(6,2) DEFAULT NULL,
  sample_condition_at_reception  varchar(50) DEFAULT null,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qcroc_ad_tissue_tubes`
  ADD CONSTRAINT `FK_qcroc_ad_tissue_tubes_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('qcroc_ad_tissue_tubes');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qcroc_tissue_tube_type", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("rnalater", "rnalater"),("formaline", "formaline");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_tissue_tube_type"), (SELECT id FROM structure_permissible_values WHERE value="rnalater" AND language_alias="rnalater"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_tissue_tube_type"), (SELECT id FROM structure_permissible_values WHERE value="formaline" AND language_alias="formaline"), "2", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qcroc_tissue_condition_at_reception", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("thawed", "thawed"),("frozen", "frozen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_tissue_condition_at_reception"), (SELECT id FROM structure_permissible_values WHERE value="thawed" AND language_alias="thawed"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_tissue_condition_at_reception"), (SELECT id FROM structure_permissible_values WHERE value="frozen" AND language_alias="frozen"), "2", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'qcroc_ad_tissue_tubes', 'tube_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_tube_type') , '0', '', '', '', 'tube type', ''), 
('InventoryManagement', 'AliquotDetail', 'qcroc_ad_tissue_tubes', 'time_placed_at_4c', 'time',  NULL , '0', '', '', '', 'time placed at 4c', ''), 
('InventoryManagement', 'AliquotDetail', 'qcroc_ad_tissue_tubes', 'date_sample_received', 'datetime',  NULL , '0', '', '', '', 'date sample received', ''), 
('InventoryManagement', 'AliquotDetail', 'qcroc_ad_tissue_tubes', 'time_remained_in_rna_later_days', 'integer_positive',  NULL , '0', '', '', '', 'time remained in rna later (days)', ''), 
('InventoryManagement', 'AliquotDetail', 'qcroc_ad_tissue_tubes', 'temperature_in_box_celsius', 'float_positive',  NULL , '0', '', '', '', 'temperature in box celsius', ''), 
('InventoryManagement', 'AliquotDetail', 'qcroc_ad_tissue_tubes', 'sample_condition_at_reception', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_condition_at_reception') , '0', '', '', '', 'sample condition at reception', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='tube_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_tube_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tube type' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='time_placed_at_4c' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='time placed at 4c' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='date_sample_received' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date sample received' AND `language_tag`=''), '1', '72', 'reception at JGH', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='time_remained_in_rna_later_days' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='time remained in rna later (days)' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='temperature_in_box_celsius' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='temperature in box celsius' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='sample_condition_at_reception' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_condition_at_reception')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample condition at reception' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES 
((SELECT id FROM structure_fields WHERE `tablename`='aliquot_masters' AND `field`='qcroc_barcode'), 'notEmpty', '', ''),
((SELECT id FROM structure_fields WHERE `tablename`='qcroc_ad_tissue_tubes' AND `field`='tube_type'), 'notEmpty', '', '');

INSERT IGNORE INTO i18n (id,en)
VALUES
('time placed at 4c', 'Time placed at 4°C'),
('date sample received', 'Date sample received'),
('time remained in rna later (days)', 'Time sample remained in RNALater until reception (days)'),
('temperature in box celsius', 'Temperature inside the box (°C)'),
('sample condition at reception', 'Sample condition'),
('rnalater','RNALater'),
('tube type','Tube type'),
('thawed','Thawed'),
('reception at JGH','Reception at JGH'),
('formaline','Formaline');

REPLACE INTO i18n (id,en)
VALUES
('aliquot system code','Aliquot System Code'),
('aliquot label','Sample ID');
			
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE field = 'participant_identifier' AND model = 'Participant'), 'custom,/^[0-9]+$/', '', 'wrong participant identifier format');	
	
INSERT INTO i18n (id,en) VALUES ('wrong participant identifier format','Wrong participant identifier format! Expected number should be like 001.');	

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
((SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='qcroc_collection_date'), 'notEmpty', '', ''),
((SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `field`='qcroc_collection_time'), 'notEmpty', '', '');
	
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
((SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='date_sample_received'), 'notEmpty', '', '');

-- SAMPLE TRANSFER

UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_internal_use_type') AND `flag_confidential`='0');

ALTER TABLE aliquot_internal_uses
	ADD COLUMN qcroc_transfer_by varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_conditions varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_method_of_dispatch varchar(50) DEFAULT NULL;
ALTER TABLE aliquot_internal_uses_revs
	ADD COLUMN qcroc_transfer_by varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_conditions varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_method_of_dispatch varchar(50) DEFAULT NULL;	

INSERT INTO structures(`alias`) VALUES ('qcroc_aliquot_transfer');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qcroc_aliquot_transfer_conditions", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Aliquot Transfer: Conditions\')"),
("qcroc_aliquot_dispatch_methods", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Aliquot Transfer: Dispatch methods\')"),
("qcroc_aliquot_transfer_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Aliquot Transfer: Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Aliquot Transfer: Conditions', 1, 50),
('Aliquot Transfer: Dispatch methods', 1, 50),
('Aliquot Transfer: Types', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Transfer: Conditions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('dry ice', 'On dry ice', '', '1', @control_id, NOW(), NOW(), 1, 1),
('ice packs', 'On ice packs', '', '1', @control_id, NOW(), NOW(), 1, 1),
('room temperature', 'At room temperature', '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Transfer: Dispatch methods');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('fedex', 'FedEx', '', '1', @control_id, NOW(), NOW(), 1, 1),
('Taxi', 'Sent by taxi', '', '1', @control_id, NOW(), NOW(), 1, 1),
('in person', 'Given in person', '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Transfer: Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('site to HDQ','Site to HDQ', '', '1', @control_id, NOW(), NOW(), 1, 1),
('site to JGH','Site to JGH', '', '1', @control_id, NOW(), NOW(), 1, 1),
('HDQ to JGH','HDQ to JGH', '', '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_value_domains SET source = 'InventoryManagement.ViewAliquotUse::getLaboratoryStaff' WHERE domain_name = 'custom_laboratory_staff';
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qcroc_sites_and_hdq_staff", "", "", "InventoryManagement.ViewAliquotUse::getSitesAndHDQStaff");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Staff : Sites', 1, 50),
('Staff : HDQ', 1, 50),
('Staff : JGH', 1, 50);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types') , '0', '', '', '', 'type', ''), 
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'qcroc_transfer_by', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_sites_and_hdq_staff') , '0', '', '', '', 'shipped by', ''), 
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'qcroc_transfer_conditions', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_conditions') , '0', '', '', '', 'shipping conditions', ''), 
('InventoryManagement', 'AliquotInternalUse', 'aliquot_internal_uses', 'qcroc_transfer_method_of_dispatch', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_dispatch_methods') , '0', '', '', '', 'method of dispatch', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '2', '', '1', 'shipping number', '0', '', '0', '', '0', '', '1', 'size=15', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_use_datetime_defintion' AND `language_label`='date' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0'), '0', '8', '', '1', 'shipped to', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='details' AND `language_tag`=''), '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='created' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_created' AND `language_label`='created (into the system)' AND `language_tag`=''), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '1', '10000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='qcroc_transfer_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_sites_and_hdq_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='shipped by' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='qcroc_transfer_conditions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_conditions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='shipping conditions' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='qcroc_transfer_method_of_dispatch' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_dispatch_methods')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method of dispatch' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `field`='type' AND structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types')), 'notEmpty', '', '');

ALTER TABLE aliquot_internal_uses
	ADD COLUMN qcroc_is_transfer tinyint(1) NOT NULL DEFAULT '0';
ALTER TABLE aliquot_internal_uses_revs
	ADD COLUMN qcroc_is_transfer tinyint(1) NOT NULL DEFAULT '0';

REPLACE INTO i18n (id,en) VALUES 
('shipping number', 'Shipping #'),
('shipped by','Shipped by'),
('shipped to','Shipped to'),
('use/event','Use/Event'),
('transfer','Transfer'),
('shipping conditions','Shipping conditions'),
('method of dispatch','Dispatch method'),
('aliquot transfer','Aliquot transfer'),
('unable to calculate time sample remained in rnalater','Unable to calculate time sample remained in rnalater'),
('the treatment date used as default collection date was rough','The treatment date used as default collection date was rough');	

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(10);

REPLACE INTO i18n (id,en) VALUES 
('realiquoted by','Processed By (Realiquoting)'),
('realiquoting date','Processing Date (Realiquoting)');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen collection sites');
INSERT INTO structure_permissible_values_customs (control_id, value, display_order, use_as_input, created, created_by, modified, modified_by, deleted) VALUES 
(@control_id, 'CHUS', 1, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUM-HDM', 2, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUM-HND', 3, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUM-HSL', 4, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUQ-CHUL', 5, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUQ-HDQ', 6, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUQ-HSFA', 7, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'HSCM', 8, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'HSS', 9, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-HSM', 10, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-JGH', 11, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-MGH', 12, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-RVH', 13, 1, NOW(), 1, NOW(), 1, 0);

UPDATE structure_permissible_values_custom_controls SET name = 'SOP : Versions' WHERE name = 'sop versions';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'SOP : Versions\')" WHERE domain_name = 'custom_sop_verisons';

ALTER TABLE ad_blocks
	ADD COLUMN qcroc_methyl_butane_refrigeration varchar(50) default null,
	ADD COLUMN qcroc_carrot_longer_than_1_cm  char(1) DEFAULT '',
	ADD COLUMN qcroc_fragment_nbr  varchar(10) DEFAULT '',
	ADD COLUMN qcroc_fragment_nbr_specify  int(6) DEFAULT null,
	ADD COLUMN qcroc_sizes_mm  varchar(50) DEFAULT '';
ALTER TABLE ad_blocks_revs
	ADD COLUMN qcroc_methyl_butane_refrigeration varchar(50) default null,
	ADD COLUMN qcroc_carrot_longer_than_1_cm  char(1) DEFAULT '',
	ADD COLUMN qcroc_fragment_nbr  varchar(10) DEFAULT '',
	ADD COLUMN qcroc_fragment_nbr_specify  int(6) DEFAULT null,
	ADD COLUMN qcroc_sizes_mm  varchar(50) DEFAULT '';
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qcroc_methyl_butane_refrigeration", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("liquid nitrogen", "liquid nitrogen"),("dry ice", "dry ice");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_methyl_butane_refrigeration"), (SELECT id FROM structure_permissible_values WHERE value="liquid nitrogen" AND language_alias="liquid nitrogen"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_methyl_butane_refrigeration"), (SELECT id FROM structure_permissible_values WHERE value="dry ice" AND language_alias="dry ice"), "", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qcroc_carrot_fragement_nbr", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_carrot_fragement_nbr"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_carrot_fragement_nbr"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_carrot_fragement_nbr"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_carrot_fragement_nbr"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "", "1");
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_methyl_butane_refrigeration', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_methyl_butane_refrigeration') , '0', '', '', '', 'methyl butane refrigeration', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_carrot_longer_than_1_cm', 'yes_no',  NULL , '0', '', '', '', 'carrot longer than 1 cm', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_fragment_nbr', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_carrot_fragement_nbr') , '0', '', '', '', 'fragment nbr', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_sizes_mm', 'input',  NULL , '0', 'size=6', '', '', 'sizes mm', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_methyl_butane_refrigeration' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_methyl_butane_refrigeration')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='methyl butane refrigeration' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_carrot_longer_than_1_cm' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='carrot longer than 1 cm' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_fragment_nbr' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_carrot_fragement_nbr')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fragment nbr' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_sizes_mm' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='sizes mm' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES 
('methyl butane refrigeration','Methyl butane (isopentane) refrigeration'),  
('carrot longer than 1 cm','Was the biopsy carrot longer than 1cm'),  
('fragment nbr','Number of fragments'),  
('sizes mm','Size(s) (mm)'),  
("liquid nitrogen", "Liquid nitrogen"),("dry ice", "Dry ice");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_fragment_nbr_specify', 'integer_positive',  NULL , '0', 'size=6', '', '', '', 'specify');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_fragment_nbr_specify' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify'), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `setting`='size=30' WHERE model='AliquotDetail' AND tablename='ad_blocks' AND field='qcroc_sizes_mm' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='74' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_sizes_mm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(1);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12, 46);

SET @block_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue') AND aliquot_type = 'block');
INSERT INTO realiquoting_controls (parent_aliquot_control_id,child_aliquot_control_id,flag_active) VALUES (@block_control_id,@block_control_id,1);

INSERT INTO `templates` (`id`, `flag_system`, `name`, `owner`, `visibility`, `flag_active`, `owning_entity_id`, `visible_entity_id`) VALUES
(1, 1, 'Biopsy', 'all', 'all', 1, 1, 1);

INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`) VALUES
(1, NULL, 1, 5, 3, 1),
(2, 1, 1, 1, 1, 1),
(3, NULL, 1, 5, 3, 1),
(4, 3, 1, 1, 1, 1),
(5, NULL, 1, 5, 3, 1),
(6, 5, 1, 1, 1, 1);

UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='tissue carrot data (if applicable)' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_methyl_butane_refrigeration' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_methyl_butane_refrigeration') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES 
('tissue carrot data (if applicable)','Tissue carrot data (if applicable)');

REPLACE INTO i18n (id,en) VALUES 
('oct embedding of biopsies', 'OCT embedding of biopsies'),
('sampling or processing of oct embedded biopsies','Sampling/Processing of oct embedded biopsies'),
('batch aliquots processing','Batch aliquots processing');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `field`='start_date'), 'notEmpty', '', '');
UPDATE structure_formats SET `language_heading`='reception at JGH/HDQ' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='date_sample_received' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other information' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en) VALUES 
('reception at JGH/HDQ','Reception at JGH/HDQ'),
('tissue tubes transferring','Tissue tubes transferring'),
('create aliquot tranfers', 'Create aliquot tranfers'),
('other information','Other information');

INSERT INTO i18n (id,en) VALUES ('transfers','Transfers');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('at cryostat temperature', 'At Cryostat Temperature', '', '1', (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types'), NOW(), NOW(), 1, 1);

-- Review

UPDATE aliquot_review_controls SET flag_active = 0;
UPDATE specimen_review_controls SET flag_active = 0;
INSERT INTO `aliquot_review_controls` (`id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `aliquot_type_restriction`) VALUES
(null, 'qcroc tissue slide review', 1, 'qcroc_ar_tissue_slides', 'qcroc_ar_tissue_slides', 'slide');
INSERT INTO `specimen_review_controls` (`sample_control_id`, `aliquot_review_control_id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`) VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'tissue' ), (SELECT id FROM aliquot_review_controls  WHERE review_type = 'qcroc tissue slide review'), 'qcroc', 1, 'qcroc_spr_tissues', 'qcroc_spr_tissues', 'qcroc tissue review');

CREATE TABLE IF NOT EXISTS `qcroc_ar_tissue_slides` (
  `aliquot_review_master_id` int(11) NOT NULL,
  
  `perc_tumor_inside_whole` decimal(5,1) DEFAULT NULL,
  `perc_normal_inside_whole` decimal(5,1) DEFAULT NULL,
  
  `perc_neoplastic_cells_inside_tumor_zone` decimal(5,1) DEFAULT NULL,
  `perc_necrosis_inside_tumor_zone` decimal(5,1) DEFAULT NULL,
  `perc_non_neoplastic_cells_inside_tumor_zone` decimal(5,1) DEFAULT NULL,
  
  `comments` varchar(250) DEFAULT NULL,
  
  KEY `FK_qcroc_ar_tissue_slides_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `qcroc_ar_tissue_slides_revs` (
  `aliquot_review_master_id` int(11) NOT NULL,
  
  `perc_tumor_inside_whole` decimal(5,1) DEFAULT NULL,
  `perc_normal_inside_whole` decimal(5,1) DEFAULT NULL,
  
  `perc_neoplastic_cells_inside_tumor_zone` decimal(5,1) DEFAULT NULL,
  `perc_necrosis_inside_tumor_zone` decimal(5,1) DEFAULT NULL,
  `perc_non_neoplastic_cells_inside_tumor_zone` decimal(5,1) DEFAULT NULL,
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `qcroc_spr_tissues` (
  `specimen_review_master_id` int(11) NOT NULL,
  KEY `FK_spr_breast_cancer_types_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `qcroc_spr_tissues_revs` (
  `specimen_review_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qcroc_ar_tissue_slides`
  ADD CONSTRAINT `FK_qcroc_ar_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);
ALTER TABLE `qcroc_spr_tissues`
  ADD CONSTRAINT `FK_qcroc_spr_tissues` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('qcroc_spr_tissues');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_spr_tissues'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='sample_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_type_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen review type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_spr_tissues'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_spr_tissues'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review date' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_spr_tissues'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qcroc_ar_tissue_slides');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'qcroc_ar_tissue_slides', 'perc_tumor_inside_whole', 'float',  NULL , '0', 'size=5', '', '', 'perc. of tumor', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qcroc_ar_tissue_slides', 'perc_normal_inside_whole', 'float',  NULL , '0', 'size=5', '', '', 'perc. of normal', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qcroc_ar_tissue_slides', 'perc_neoplastic_cells_inside_tumor_zone', 'float',  NULL , '0', 'size=5', '', '', 'perc. of neoplastic cells', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qcroc_ar_tissue_slides', 'perc_non_neoplastic_cells_inside_tumor_zone', 'float',  NULL , '0', 'size=5', '', '', 'perc. of non neoplastic cells', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qcroc_ar_tissue_slides', 'perc_necrosis_inside_tumor_zone', 'float',  NULL , '0', 'size=5', '', '', 'perc. of necrosis', ''),
('InventoryManagement', 'AliquotReviewDetail', 'qcroc_ar_tissue_slides', 'comments', 'input',  NULL , '0', 'size=30', '', '', 'comments', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquots_list_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reviewed aliquot' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '0', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot_review_master_id' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='perc_tumor_inside_whole' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='perc. of tumor' AND `language_tag`=''), '0', '10', 'inside the whole zone', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='perc_normal_inside_whole' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='perc. of normal' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='perc_neoplastic_cells_inside_tumor_zone'), '0', '12', 'inside the tumor zone', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='perc_non_neoplastic_cells_inside_tumor_zone'), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='perc_necrosis_inside_tumor_zone' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='perc. of necrosis' AND `language_tag`=''), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='comments' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='comments' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id'), 'notEmpty', '', '');

INSERT IGNORE INTO i18n (id,en) VALUES
('inside the whole zone','Inside the whole zone'),
('inside the tumor zone','Inside the tumor zone'),	
('perc. of tumor','&#37; of tumor'),
('perc. of normal','&#37; of normal'),

('perc. of neoplastic cells','&#37; of neoplastic cells'),
('perc. of necrosis','&#37; of necrosis'),
('perc. of non neoplastic cells','&#37; of non neoplastic cells'),
('qcroc tissue review', 'Review'),
('comments','Comments');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

Replace into i18n (id,en) VALUEs ('specimen review','Histopathological evaluation');

ALTER TABLE collections 
  ADD COLUMN `qcroc_prior_to_chemo` char(1) DEFAULT '',
  ADD COLUMN `qcroc_prior_to_chemo_specify` varchar(50) DEFAULT NULL;
ALTER TABLE collections_revs
  ADD COLUMN `qcroc_prior_to_chemo` char(1) DEFAULT '',
  ADD COLUMN `qcroc_prior_to_chemo_specify` varchar(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_prior_to_chemo', 'yes_no', NULL, '0', '', '', '', 'prior to chemo', '');
SET @new_structure_field_id =(SELECT id FROM structure_fields WHERE field = 'qcroc_prior_to_chemo' AND model = 'Collection');
SET @qcroc_collection_date_structure_field_id = (SELECT id FROM structure_fields WHERE field = 'qcroc_collection_date' AND model = 'Collection');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT `structure_id`, @new_structure_field_id, '0', (display_order+1), `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @qcroc_collection_date_structure_field_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qcroc_prior_to_chemo', 'yes_no',  NULL , '0', '', '', '', 'prior to chemo', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_prior_to_chemo' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prior to chemo' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('prior to chemo','Prior to chemo (if applicable)');

UPDATE menus SET language_title = 'treatments/biopsies' where use_link like '/ClinicalAnnotation/TreatmentMasters/listall/%';
INSERT INTO i18n (id,en) VALUES ('treatments/biopsies','Treatments / Biopsies');

UPDATE treatment_controls SET flag_use_for_ccl = '1',databrowser_label = 'chemotherapy', disease_site = 'all', flag_active = 1, applied_protocol_control_id = NULL, extended_data_import_process = NULL WHERE id = 1;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `field` IN ('finish_date','notes'));
UPDATE structure_formats SET `flag_edit`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND `flag_confidential`='0');
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="1" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="chemotherapy" AND language_alias="chemotherapy");
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `tablename`='qcroc_txe_liver_biopsie_sedations' AND `field`='drug_id'), 'notEmpty', '', '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'qcroc_cycle', 'integer_positive',  NULL , '0', 'size=5', '', '', 'cycle', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qcroc_cycle' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cycle' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE treatment_masters ADD COLUMN qcroc_cycle int(6) DEFAULT NULL;
ALTER TABLE treatment_masters_revs ADD COLUMN qcroc_cycle int(6) DEFAULT NULL;
INSERT INTO i18n (id,en) VALUES ('cycle','Cycle');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `field`='qcroc_cycle'), 'notEmpty', '', '');

INSERT INTO structures(`alias`) VALUES ('qcroc_treatmentmasters_precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_treatmentmasters_precision'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qcroc_biopsy_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0'), '1', '303', '', '1', 'precision', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_treatmentmasters_precision'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qcroc_cycle' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '304', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO `sop_controls` (`sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
('blood collection', '', 'sopd_general_alls', 'sopd_general_all', '', '', 0, NULL, 0, NULL, 0, 1);
INSERT INTO i18n (id,en) VALUES ('blood collection','Blood collection'), ('tissue block','Tissue block ');
ALTER TABLE collections
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qcroc_sop_deviations text AFTER qcroc_sop_followed;  
ALTER TABLE collections_revs
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qcroc_sop_deviations text AFTER qcroc_sop_followed;  
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qcroc_collections_sops', 'open', '', 'Sop.SopMaster::getCollectionSopPermissibleValues');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qcroc_collections_sops') WHERE field = 'sop_master_id' AND model LIKE '%collection%';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'Collection', 'collections', 'qcroc_sop_deviations', 'input',  NULL , '0', 'cols=30,rows=3', '', '', 'sop deviations', ''),
('InventoryManagement', 'ViewCollection', '', 'qcroc_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_sop_deviations', 'input',  NULL , '0', 'cols=30,rows=2', '', '', 'sop deviations', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '0', '10', 'SOP', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_sop_deviations' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='qcroc_sop_followed'), '0', '10', 'SOP', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='qcroc_sop_deviations'), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '0', '10', 'SOP', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_sop_deviations' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=2' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='30', `language_heading`='other data' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_collections_sops') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_collection_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='51' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='50', `language_heading`='other data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='60' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_collections_sops') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_collections_sops') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qcroc_initials', 'input',  NULL , '0', 'size=6', '', '', 'initials', ''), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_biopsy_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types') , '0', '', '', '', 'type', ''), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_cycle', 'integer_positive',  NULL , '0', '', '', '', 'cycle', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_initials' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='initials' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '30', 'biopsy', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_cycle' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cycle' AND `language_tag`=''), '1', '20', 'blood collection', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_prior_to_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20', `language_heading`='blood collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_prior_to_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_cycle' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='61' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='60' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_collection_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='20', `language_heading`='blood collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_prior_to_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_collections_sops') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='51' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='50', `language_heading`='other data' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_protocol' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='20', `language_heading`='blood collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_prior_to_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_protocol' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_protocol') AND `flag_confidential`='0');

ALTER TABLE collections
  ADD COLUMN qcroc_is_baseline char(1) DEFAULT '';
ALTER TABLE collections_revs
  ADD COLUMN qcroc_is_baseline char(1) DEFAULT '';
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_is_baseline', 'yes_no',  NULL , '0', '', '', '', 'baseline', ''),
('InventoryManagement', 'ViewCollection', '', 'qcroc_is_baseline', 'yes_no',  NULL , '0', '', '', '', 'baseline', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_is_baseline'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_is_baseline'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_is_baseline' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

ALTER TABLE collections
  ADD COLUMN qcroc_banking_nbr int(6) DEFAULT NULL;
ALTER TABLE collections_revs
  ADD COLUMN qcroc_banking_nbr int(6) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_banking_nbr', 'integer_positive',  NULL , '0', 'size=3', '', '', 'banking #', ''),
('InventoryManagement', 'ViewCollection', '', 'qcroc_banking_nbr', 'integer_positive',  NULL , '0', 'size=3', '', '', 'banking #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_banking_nbr'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_banking_nbr'),  '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_banking_nbr'),  '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en) VALUES ('baseline','Baseline'),('other data','Other data'),('banking #','Banking #');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_prior_to_chemo_specify', 'input',  NULL , '0', 'size=30', '', '', '', 'specify'),
('InventoryManagement', 'ViewCollection', '', 'qcroc_prior_to_chemo_specify', 'input',  NULL , '0', 'size=30', '', '', '', 'specify');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_prior_to_chemo_specify'), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_prior_to_chemo_specify'),  '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_prior_to_chemo_specify'),  '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_prior_to_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_sop_followed' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_biopsy_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_cycle' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_is_baseline' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- change transfer record

ALTER TABLE qcroc_ad_tissue_tubes DROP COLUMN date_sample_received, DROP COLUMN temperature_in_box_celsius, DROP COLUMN sample_condition_at_reception;
ALTER TABLE qcroc_ad_tissue_tubes_revs DROP COLUMN date_sample_received, DROP COLUMN temperature_in_box_celsius, DROP COLUMN sample_condition_at_reception;

DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'qcroc_ad_tissue_tubes' AND field IN ('date_sample_received','temperature_in_box_celsius','sample_condition_at_reception'));
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'qcroc_ad_tissue_tubes' AND field IN ('date_sample_received','temperature_in_box_celsius','sample_condition_at_reception'));
DELETE FROM structure_fields WHERE tablename = 'qcroc_ad_tissue_tubes' AND field IN ('date_sample_received','temperature_in_box_celsius','sample_condition_at_reception');

ALTER TABLE aliquot_internal_uses 
	DROP COLUMN qcroc_transfer_by, 
	DROP COLUMN qcroc_transfer_conditions, 
	DROP COLUMN qcroc_transfer_method_of_dispatch;
ALTER TABLE aliquot_internal_uses_revs
	DROP COLUMN qcroc_transfer_by, 
	DROP COLUMN qcroc_transfer_conditions, 
	DROP COLUMN qcroc_transfer_method_of_dispatch;
	
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'aliquot_internal_uses' AND field LIKE 'qcroc_transfer_%');
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'aliquot_internal_uses' AND field LIKE 'qcroc_transfer_%');
DELETE FROM structure_fields WHERE tablename = 'aliquot_internal_uses' AND field LIKE 'qcroc_transfer_%';
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'qcroc_aliquot_transfer');
DELETE FROM structures WHERE alias = 'qcroc_aliquot_transfer';

ALTER TABLE aliquot_masters
	ADD COLUMN qcroc_transfer_type varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_shipping_nbr varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_shipping_date date DEFAULT NULL,
	ADD COLUMN qcroc_transfer_by varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_to varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_conditions varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_method_of_dispatch varchar(50) DEFAULT NULL,
  	ADD COLUMN qcroc_transfer_date_sample_received datetime DEFAULT null,
  	ADD COLUMN qcroc_transfer_temperature_in_box_celsius decimal(6,2) DEFAULT NULL,
  	ADD COLUMN qcroc_transfer_sample_condition_at_reception  varchar(50) DEFAULT null;
ALTER TABLE aliquot_masters_revs
	ADD COLUMN qcroc_transfer_type varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_shipping_nbr varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_shipping_date date DEFAULT NULL,
	ADD COLUMN qcroc_transfer_by varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_to varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_conditions varchar(50) DEFAULT NULL,
	ADD COLUMN qcroc_transfer_method_of_dispatch varchar(50) DEFAULT NULL,
  	ADD COLUMN qcroc_transfer_date_sample_received datetime DEFAULT null,
  	ADD COLUMN qcroc_transfer_temperature_in_box_celsius decimal(6,2) DEFAULT NULL,
  	ADD COLUMN qcroc_transfer_sample_condition_at_reception  varchar(50) DEFAULT null;
UPDATE structure_value_domains SET domain_name = 'qcroc_transfer_sample_condition_at_reception' WHERE domain_name = 'qcroc_tissue_condition_at_reception';
INSERT INTO structures(`alias`) VALUES ('qcroc_site_to_site_aliquot_transfer');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types') , '0', '', '', '', 'type', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_shipping_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_to', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'shipped to', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_by', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_sites_and_hdq_staff') , '0', '', '', '', 'shipped by', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_conditions', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_conditions') , '0', '', '', '', 'shipping conditions', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_method_of_dispatch', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_dispatch_methods') , '0', '', '', '', 'method of dispatch', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_shipping_nbr', 'input',  NULL , '0', 'size=15', '', '', 'shipping number', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_date_sample_received', 'datetime',  NULL , '0', '', '', '', 'date sample received', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_temperature_in_box_celsius', 'float_positive',  NULL , '0', '', '', '', 'temperature in box celsius', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_transfer_sample_condition_at_reception', 'select',  NULL , '0', '', '', '', 'sample condition at reception', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_shipping_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_to' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='shipped to' AND `language_tag`=''), '1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_sites_and_hdq_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='shipped by' AND `language_tag`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_conditions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_conditions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='shipping conditions' AND `language_tag`=''), '1', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_method_of_dispatch' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_dispatch_methods')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method of dispatch' AND `language_tag`=''), '1', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_shipping_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='shipping number' AND `language_tag`=''), '1', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_date_sample_received' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date sample received' AND `language_tag`=''), '1', '87', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_temperature_in_box_celsius' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='temperature in box celsius' AND `language_tag`=''), '1', '88', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_sample_condition_at_reception' AND `type`='select' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample condition at reception' AND `language_tag`=''), '1', '89', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_value_domains SET source = 'InventoryManagement.ViewCollection::getSitesAndHDQStaff' WHERE domain_name = 'qcroc_sites_and_hdq_staff';
UPDATE structure_value_domains SET source = 'InventoryManagement.ViewCollection::getLaboratoryStaff' WHERE domain_name = 'custom_laboratory_staff';

UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias,',qcroc_site_to_site_aliquot_transfer') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue') AND aliquot_type IN ('tube','slide','block');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types') ,  `language_label`='transfer type' WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='qcroc_transfer_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types');
UPDATE structure_formats SET `language_heading`='transfer data if applicable' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_transfer_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_aliquot_transfer_types') AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_transfer_sample_condition_at_reception')  WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='qcroc_transfer_sample_condition_at_reception' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT INTO i18n (id,en) VALUES ('transfer data if applicable','Transfer data (if applicable)'),('transfer type','Transfer type');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='time_placed_at_4c' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `field`='qcroc_collection_time');

UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qcroc_blocks_sops', 'open', '', 'Sop.SopMaster::getBlockSopPermissibleValues');
INSERT INTO `sop_controls` (`sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
('tissue block', '', 'sopd_general_alls', 'sopd_general_all', '', '', 0, NULL, 0, NULL, 0, 1);

ALTER TABLE aliquot_masters
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qcroc_sop_deviations text AFTER qcroc_sop_followed;  
ALTER TABLE aliquot_masters_revs
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qcroc_sop_deviations text AFTER qcroc_sop_followed;  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'sop_master_id', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'qcroc_blocks_sops') , '0', '', '', '', 'sop#', ''), 
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'qcroc_sop_deviations', 'input',  NULL , '0', 'cols=30,rows=3', '', '', 'sop deviations', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '1', '80', 'SOP', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_blocks_sops')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop#' AND `language_tag`=''), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_sop_deviations' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_site_to_site_aliquot_transfer');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `language_heading`='tissue tube data' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='tube_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_tube_type') AND `flag_confidential`='0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qcroc_tissue_slides_sops', 'open', '', 'Sop.SopMaster::getTissueSlideSopPermissibleValues');
INSERT INTO `sop_controls` (`sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
('tissue slide', '', 'sopd_general_alls', 'sopd_general_all', '', '', 0, NULL, 0, NULL, 0, 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', 'aliquot_masters', 'sop_master_id', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'qcroc_tissue_slides_sops') , '0', '', '', '', 'sop#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '1', '80', 'SOP', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_slides_sops')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop#' AND `language_tag`=''), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qcroc_sop_deviations' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('tissue tube data','Tissue tube data'),
('tissue slide','Tissue slide'),
('qcroc','Q-CROC');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/QualityCtrls/listAll/%';

DROP TABLE IF EXISTS `view_aliquot_uses`;
DROP VIEW IF EXISTS `view_aliquot_uses`;
CREATE VIEW `view_aliquot_uses` AS 

select concat(`source`.`id`,1) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'sample derivative creation' AS `use_definition`,
`samp`.`sample_code` AS `use_code`,
'' AS `use_details`,`source`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`der`.`creation_datetime` AS `use_datetime`,`der`.`creation_datetime_accuracy` AS `use_datetime_accuracy`,'' AS `duration`,'' AS `duration_unit`,`der`.`creation_by` AS `used_by`,`source`.`created` AS `created`,concat('inventorymanagement/aliquot_masters/listAllSourceAliquots/',`samp`.`collection_id`,'/',`samp`.`id`) AS `detail_url`,`samp2`.`id` AS `sample_master_id`,`samp2`.`collection_id` AS `collection_id` from (((((`source_aliquots` `source` join `sample_masters` `samp` on(((`samp`.`id` = `source`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) join `derivative_details` `der` on((`samp`.`id` = `der`.`sample_master_id`))) join `aliquot_masters` `aliq` on(((`aliq`.`id` = `source`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) join `sample_masters` `samp2` on(((`samp2`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`source`.`deleted` <> 1) 

union all 

select concat(`realiq`.`id`,2) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'realiquoted to' AS `use_definition`,
CONCAT(`child`.`qcroc_barcode`, ' [', `child`.`aliquot_label`, ']') AS `use_code`,
'' AS `use_details`,`realiq`.`parent_used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`realiq`.`realiquoting_datetime` AS `use_datetime`,`realiq`.`realiquoting_datetime_accuracy` AS `use_datetime_accuracy`,'' AS `duration`,'' AS `duration_unit`,`realiq`.`realiquoted_by` AS `used_by`,`realiq`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',`child`.`collection_id`,'/',`child`.`sample_master_id`,'/',`child`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from ((((`realiquotings` `realiq` join `aliquot_masters` `aliq` on(((`aliq`.`id` = `realiq`.`parent_aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) join `aliquot_masters` `child` on(((`child`.`id` = `realiq`.`child_aliquot_master_id`) and (`child`.`deleted` <> 1)))) join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`realiq`.`deleted` <> 1) 

union all 

select concat(`qc`.`id`,3) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'quality control' AS `use_definition`,
`qc`.`qc_code` AS `use_code`,
'' AS `use_details`,`qc`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`qc`.`date` AS `use_datetime`,`qc`.`date_accuracy` AS `use_datetime_accuracy`,'' AS `duration`,'' AS `duration_unit`,`qc`.`run_by` AS `used_by`,`qc`.`created` AS `created`,concat('/inventorymanagement/quality_ctrls/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`qc`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`quality_ctrls` `qc` join `aliquot_masters` `aliq` on(((`aliq`.`id` = `qc`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`qc`.`deleted` <> 1) 

union all 

select concat(`item`.`id`,4) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'aliquot shipment' AS `use_definition`,
`sh`.`shipment_code` AS `use_code`,
'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`sh`.`datetime_shipped` AS `use_datetime`,`sh`.`datetime_shipped_accuracy` AS `use_datetime_accuracy`,'' AS `duration`,'' AS `duration_unit`,`sh`.`shipped_by` AS `used_by`,`sh`.`created` AS `created`,concat('/order/shipments/detail/',`sh`.`order_id`,'/',`sh`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`order_items` `item` join `aliquot_masters` `aliq` on(((`aliq`.`id` = `item`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) join `shipments` `sh` on(((`sh`.`id` = `item`.`shipment_id`) and (`sh`.`deleted` <> 1)))) join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`item`.`deleted` <> 1) 

union all 

select concat(`alr`.`id`,5) AS `id`,`aliq`.`id` AS `aliquot_master_id`,'specimen review' AS `use_definition`,
`spr`.`review_code` AS `use_code`,
'' AS `use_details`,'' AS `used_volume`,'' AS `aliquot_volume_unit`,`spr`.`review_date` AS `use_datetime`,`spr`.`review_date_accuracy` AS `use_datetime_accuracy`,'' AS `duration`,'' AS `duration_unit`,'' AS `used_by`,`alr`.`created` AS `created`,concat('/inventorymanagement/specimen_reviews/detail/',`aliq`.`collection_id`,'/',`aliq`.`sample_master_id`,'/',`spr`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_review_masters` `alr` join `aliquot_masters` `aliq` on(((`aliq`.`id` = `alr`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) join `specimen_review_masters` `spr` on(((`spr`.`id` = `alr`.`specimen_review_master_id`) and (`spr`.`deleted` <> 1)))) join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`alr`.`deleted` <> 1) 

union all 

select concat(`aluse`.`id`,6) AS `id`,`aliq`.`id` AS `aliquot_master_id`,`aluse`.`type` AS `use_definition`,
`aluse`.`use_code` AS `use_code`,
`aluse`.`use_details` AS `use_details`,`aluse`.`used_volume` AS `used_volume`,`aliqc`.`volume_unit` AS `aliquot_volume_unit`,`aluse`.`use_datetime` AS `use_datetime`,`aluse`.`use_datetime_accuracy` AS `use_datetime_accuracy`,`aluse`.`duration` AS `duration`,`aluse`.`duration_unit` AS `duration_unit`,`aluse`.`used_by` AS `used_by`,`aluse`.`created` AS `created`,concat('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',`aliq`.`id`,'/',`aluse`.`id`) AS `detail_url`,`samp`.`id` AS `sample_master_id`,`samp`.`collection_id` AS `collection_id` from (((`aliquot_internal_uses` `aluse` join `aliquot_masters` `aliq` on(((`aliq`.`id` = `aluse`.`aliquot_master_id`) and (`aliq`.`deleted` <> 1)))) join `aliquot_controls` `aliqc` on((`aliq`.`aliquot_control_id` = `aliqc`.`id`))) join `sample_masters` `samp` on(((`samp`.`id` = `aliq`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) where (`aluse`.`deleted` <> 1) ;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_spr_tissues'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='review code' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='0', `flag_edit_readonly`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_spr_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='review_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- BLOOD ---------------------------------------------------------------------------------------------------------

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="EDTA" AND language_alias="EDTA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paxgene" AND language_alias="paxgene");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("K-EDTA", "K-EDTA");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="K-EDTA" AND language_alias="K-EDTA"), "", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("CTAD", "CTAD");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="CTAD" AND language_alias="CTAD"), "", "1");
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_tube_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ("CTAD", "CTAD"),("K-EDTA", "K-EDTA");

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='73' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='71', `language_heading`='volume' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias,',qcroc_site_to_site_aliquot_transfer') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood') AND aliquot_type IN ('tube');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_creation_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_creation_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES ('creation date','Processing date'), ('created by','Processed by');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qcroc_sites_and_laboratory_staff", "", "", "InventoryManagement.ViewCollection::getSitesAndLaboratoryStaff");
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_sites_and_laboratory_staff') WHERE model = 'DerivativeDetail' AND field = 'creation_by';

UPDATE structure_value_domains SET source = 'InventoryManagement.ViewCollection::getSitesAndLaboratoryStaff' WHERE domain_name = 'qcroc_sites_and_laboratory_staff';

ALTER TABLE sd_der_plasmas 
	ADD COLUMN qcroc_approx_vol_plasma_ml decimal(6,2) DEFAULT NULL,
	ADD COLUMN qcroc_plasma_color varchar(20) DEFAULT NULL;
ALTER TABLE sd_der_plasmas_revs 
	ADD COLUMN qcroc_approx_vol_plasma_ml decimal(6,2) DEFAULT NULL,
	ADD COLUMN qcroc_plasma_color varchar(20) DEFAULT NULL;	
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qcroc_plasma_color", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("yellow", "yellow");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_plasma_color"), (SELECT id FROM structure_permissible_values WHERE value="yellow" AND language_alias="yellow"), "", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pink", "pink");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_plasma_color"), (SELECT id FROM structure_permissible_values WHERE value="pink" AND language_alias="pink"), "", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("red", "red");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qcroc_plasma_color"), (SELECT id FROM structure_permissible_values WHERE value="red" AND language_alias="red"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_plasmas', 'qcroc_approx_vol_plasma_ml', 'input',  NULL , '0', 'size=6', '', '', 'approx volume of plasma ml', ''), 
('InventoryManagement', 'SampleDetail', 'sd_der_plasmas', 'qcroc_plasma_color', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_plasma_color') , '0', '', '', '', 'color of plasma', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_plasmas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qcroc_approx_vol_plasma_ml' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='approx volume of plasma ml' AND `language_tag`=''), '1', '300', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_plasmas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qcroc_plasma_color' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_plasma_color')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='color of plasma' AND `language_tag`=''), '1', '301', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('approx volume of plasma ml','Approx volume of plasma collected (ml)'),	    
('color of plasma','Color of plasma'),('red','Red'),('yellow','Yellow'),('pink','Pink');

ALTER TABLE sample_masters
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qcroc_sop_deviations text AFTER qcroc_sop_followed;  
ALTER TABLE sample_masters_revs
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '' AFTER sop_master_id,  
  ADD COLUMN qcroc_sop_deviations text AFTER qcroc_sop_followed;  
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qcroc_blood_processing_sops', 'open', '', 'Sop.SopMaster::getBloodPRocessingSopPermissibleValues');
INSERT INTO `sop_controls` (`sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
('blood processing', '', 'sopd_general_alls', 'sopd_general_all', '', '', 0, NULL, 0, NULL, 0, 1);
INSERT INTO i18n (id,en) VALUEs ('blood processing','Blood processing'); 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qcroc_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'sop_master_id', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'qcroc_blood_processing_sops') , '0', '', '', '', 'sop#', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qcroc_sop_deviations', 'input',  NULL , '0', 'cols=30,rows=3', '', '', 'sop deviations', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_plasmas'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qcroc_sop_followed'), '1', '310', 'SOP', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_plasmas'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_blood_processing_sops')), '1', '311', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_plasmas'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qcroc_sop_deviations'), '1', '311', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='73' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='74' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='71', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='72', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='volume' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='74' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_hemolysis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='hemolysis_signs' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='72' WHERE `flag_add`='1' AND structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES ('pbmc','Buffy Coat');

UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias,',qcroc_site_to_site_aliquot_transfer') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'plasma') AND aliquot_type IN ('tube');
UPDATE aliquot_controls SET detail_form_alias = 'ad_der_tubes_incl_ml_vol,ad_hemolysis,qcroc_site_to_site_aliquot_transfer' WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc') AND aliquot_type IN ('tube');
UPDATE aliquot_controls SET volume_unit = 'ul' WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type  IN ('plasma','pbmc')) AND aliquot_type IN ('tube');

-- DNA RNA

INSERT INTO structures(`alias`) VALUES ('qcroc_sd_der_dnas_rnas');
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qcroc_dna_rna_extraction_sops', 'open', '', 'Sop.SopMaster::getDnaRnaExtractionSopPermissibleValues');
INSERT INTO `sop_controls` (`sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
('dna rna extraction', '', 'sopd_general_alls', 'sopd_general_all', '', '', 0, NULL, 0, NULL, 0, 1);
INSERT INTO i18n (id,en) VALUEs ('dna rna extraction','DNA RNA extraction'); 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'sop_master_id', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'qcroc_dna_rna_extraction_sops') , '0', '', '', '', 'sop#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qcroc_sop_followed'), '1', '310', 'SOP', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_dna_rna_extraction_sops')), '1', '311', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qcroc_sop_deviations'), '1', '311', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias,',qcroc_sd_der_dnas_rnas') WHERE sample_type IN ('dna','rna');

ALTER TABLE sd_der_dnas 
  ADD COLUMN qcroc_elution_buffer varchar(50) default null,
  ADD COLUMN qcroc_buffer_volume_ul decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_final_eluate_volume_ul decimal(6,2) default null;
ALTER TABLE sd_der_dnas_revs
  ADD COLUMN qcroc_elution_buffer varchar(50) default null,
  ADD COLUMN qcroc_buffer_volume_ul decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_final_eluate_volume_ul decimal(6,2) default null;
ALTER TABLE sd_der_rnas 
  ADD COLUMN qcroc_elution_buffer varchar(50) default null,
  ADD COLUMN qcroc_buffer_volume_ul decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_final_eluate_volume_ul decimal(6,2) default null;
ALTER TABLE sd_der_rnas_revs
  ADD COLUMN qcroc_elution_buffer varchar(50) default null,
  ADD COLUMN qcroc_buffer_volume_ul decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_final_eluate_volume_ul decimal(6,2) default null;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qcroc_dna_rna_elution_buffer", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'DNA & RNA: Elution buffer\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('DNA & RNA: Elution buffer', 1, 50);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'qcroc_elution_buffer', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_dna_rna_elution_buffer') , '0', '', '', '', 'elution buffer', ''), 
('InventoryManagement', 'SampleDetail', '', 'qcroc_buffer_volume_ul', 'float_positive',  NULL , '0', '', '', '', 'buffer volume ul', ''), 
('InventoryManagement', 'SampleDetail', '', 'qcroc_final_eluate_volume_ul', 'float_positive',  NULL , '0', '', '', '', 'final eluate volume ul', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_elution_buffer' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_dna_rna_elution_buffer')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='elution buffer' AND `language_tag`=''), '1', '200', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_buffer_volume_ul' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='buffer volume ul' AND `language_tag`=''), '1', '201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_final_eluate_volume_ul' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='final eluate volume ul' AND `language_tag`=''), '1', '202', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO i18n (id,en) VALUEs 
('elution buffer','Elution buffer'),
('buffer volume ul','Buffer volume (ul)'),
('final eluate volume ul','Final eluate volume (ul)');

ALTER TABLE sd_der_dnas 
  ADD COLUMN qcroc_radtio_260_280 decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_radtio_260_230 decimal(6,2) DEFAULT NULL;
ALTER TABLE sd_der_dnas_revs 
  ADD COLUMN qcroc_radtio_260_280 decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_radtio_260_230 decimal(6,2) DEFAULT NULL;
ALTER TABLE sd_der_rnas 
  ADD COLUMN qcroc_radtio_260_280 decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_radtio_260_230 decimal(6,2) DEFAULT NULL;
ALTER TABLE sd_der_rnas_revs 
  ADD COLUMN qcroc_radtio_260_280 decimal(6,2) DEFAULT NULL,
  ADD COLUMN qcroc_radtio_260_230 decimal(6,2) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'qcroc_radtio_260_280', 'float_positive',  NULL , '0', '', '', '', 'ratio 260 280', ''), 
('InventoryManagement', 'SampleDetail', '', 'qcroc_radtio_260_230', 'float_positive',  NULL , '0', '', '', '', 'ratio 260 230', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_radtio_260_280' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ratio 260 280' AND `language_tag`=''), '1', '250', 'ratios', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_radtio_260_230' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ratio 260 230' AND `language_tag`=''), '1', '251', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUEs 
('ratios','Ratios'),('ratio 260 280','ratio 260nm/280nm'),('ratio 260 230','ratio 260nm/230nm');

UPDATE structure_formats SET `language_heading`='', `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='conclusion' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='tool' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_qc_tool') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_type_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE aliquot_controls SET volume_unit = 'ul' WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('dna','rna')) AND aliquot_type IN ('tube');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='73' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='71' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='72' WHERE flag_add = '1' AND structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='74' WHERE flag_add = '0' AND structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='volume' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit') AND `flag_confidential`='0');

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/InventoryManagement/QualityCtrls/listAll/%' AND use_summary LIKE '%derivativeSummary%';

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Quality Control: Type\')" WHERE domain_name = 'quality_control_type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Quality Control: Unit\')" WHERE domain_name = 'quality_control_unit';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Quality Control: Type', 1, 30),
('Quality Control: Unit', 1, 30);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Quality Control: Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('picogreen gel','PicoGreen Gel', '', '1', @control_id, NOW(), NOW(), 1, 1),
('bioanalyzer','BioAnalyzer', '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Quality Control: Unit');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('rin','RIN', '', '1', @control_id, NOW(), NOW(), 1, 1);

ALTER TABLE quality_ctrls 
	ADD COLUMN qcroc_concentration_ng_ul decimal(6,2) DEFAULT NULL,
	ADD COLUMN qcroc_amout_ng decimal(6,2) DEFAULT NULL,
	ADD COLUMN qcroc_analysis_id varchar(50) DEFAULT NULL;
ALTER TABLE quality_ctrls_revs 
	ADD COLUMN qcroc_concentration_ng_ul decimal(6,2) DEFAULT NULL,
	ADD COLUMN qcroc_amout_ng decimal(6,2) DEFAULT NULL,
	ADD COLUMN qcroc_analysis_id varchar(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qcroc_concentration_ng_ul', 'float_positive',  NULL , '0', '', '', '', 'qc concentration ng ul', ''), 
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qcroc_amout_ng', 'float_positive',  NULL , '0', '', '', '', 'qc amount ng', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls_volume'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qcroc_concentration_ng_ul'), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls_volume'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qcroc_amout_ng'), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('qc amount ng', 'Amount loaded/used (ng)'),('qc concentration ng ul', 'Concentration loaded/used (ng/ul)');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE treatment_controls SET flag_active = 0 WHERE tx_method = 'chemotherapy';

ALTER TABLE treatment_masters DROP COLUMN qcroc_cycle;
ALTER TABLE treatment_masters_revs DROP COLUMN qcroc_cycle;
DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `field`='qcroc_cycle');
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `field`='qcroc_cycle');
DELETE FROM structure_fields WHERE `model`='TreatmentMaster' AND `field`='qcroc_cycle';

ALTER TABLE collections ADD COLUMN qcroc_cycle int(6) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN qcroc_cycle int(6) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_cycle', 'integer_positive',  NULL , '0', '', '', '', 'cycle', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_cycle' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cycle' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_cycle' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cycle' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE menus SET language_title = 'biopsies' where use_link like '/ClinicalAnnotation/TreatmentMasters/listall/%';
INSERT INTO i18n (id,en) VALUES ('biopsies','Biopsies');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='qcroc_treatmentmasters_precision');
DELETE FROM structures WHERE  alias='qcroc_treatmentmasters_precision';

INSERT INTO structures(`alias`) VALUES ('qcroc_treatmentmasters_precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_treatmentmasters_precision'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qcroc_biopsy_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0'), '1', '303', '', '1', 'precision', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `language_heading`='biopsy' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='blood collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_prior_to_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_cycle' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cycle' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('box81','box81 1A-9I','box','freezer','fridge','nitrogen locator');
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'site', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, 0, '', 'qcroc_std_sites', 'site', 0),
(null, 'rack4x4', 'column', 'integer', 4, 'row', 'integer', 4, 0, 0, 1, 0, 1, 0, 0, 0, 'storage_w_spaces', 'std_racks', 'rack4x4', 1);
CREATE TABLE IF NOT EXISTS `qcroc_std_sites` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_qcroc_std_sites_storage_masters` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `qcroc_std_sites`
  ADD CONSTRAINT `FK_qcroc_std_sites_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`);
UPDATE storage_controls SET flag_active = 1 WHERE storage_type IN ('site','rack4x4');
INSERT IGNORE INTO i18n (id,en) VALUES ('rack4x4','Rack 4x4'),('site','Site');

UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');













SELECT CONCAT('', ViewCollection.collection_id) AS ids 
FROM `qcroc`.`view_collections` AS `ViewCollection` 
INNER JOIN `qcroc`.`collections` AS `Collection` ON (`ViewCollection`.`collection_id` = `Collection`.`id`) 
LEFT JOIN `qcroc`.`participants` AS `Participant` ON (`ViewCollection`.`participant_id` = `Participant`.`id`) 
LEFT JOIN `qcroc`.`diagnosis_masters` AS `DiagnosisMaster` ON (`ViewCollection`.`diagnosis_master_id` = `DiagnosisMaster`.`id`) 
LEFT JOIN `qcroc`.`consent_masters` AS `ConsentMaster` ON (`ViewCollection`.`consent_master_id` = `ConsentMaster`.`id`) 
WHERE `ViewCollection`.`qcroc_collection_date` 
GROUP BY `ViewCollection`.`collection_id` ORDER BY `ViewCollection`.`collection_id` ASC 

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qcroc_collection_date' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime'));
DELETE FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qcroc_collection_date' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='adv_coll_datetime');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/Adhocs/%';

UPDATE datamart_structure_functions SET flag_active = 0 WHERE label LIKE 'print barcodes';

SELECT 'TODO: qualityctrls_volume_for_detail?' AS msg;
SELECT 'TODO: SHOULD SAMPLE ID MOVED TO SAMPLE LEVEL?' AS msg;

-- -------------------------------------------------------------------------------------------
-- OTHER
-- -------------------------------------------------------------------------------------------

INSERT INTO structure_permissible_values_customs_revs (id, control_id, value, display_order, use_as_input, modified_by, version_created)
(SELECT id, control_id, value, display_order, use_as_input, modified_by, modified FROM structure_permissible_values_customs);

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Protocol/%';

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ReproductiveHistory','ParticipantContact','EventMaster','FamilyHistory','DiagnosisMaster','ConsentMaster','MiscIdentifier'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ReproductiveHistory','ParticipantContact','EventMaster','FamilyHistory','DiagnosisMaster','ConsentMaster','MiscIdentifier'));

-- -------------------------------------------------------------------------------------------
-- Example values to delete
-- -------------------------------------------------------------------------------------------

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Staff : Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('site staff 1','', '', '1', @control_id, NOW(), NOW(), 1, 1),
('site staff 2','', '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Staff : HDQ');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('HDQ staff 1','', '', '1', @control_id, NOW(), NOW(), 1, 1),
('HDQ staff 2','', '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Staff : JGH');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('JGH staff 1','', '', '1', @control_id, NOW(), NOW(), 1, 1),
('JGH staff 2','', '', '1', @control_id, NOW(), NOW(), 1, 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name =  'SOP : Versions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('sv1','', '', '1', @control_id, NOW(), NOW(), 1, 1),
('sv2','', '', '1', @control_id, NOW(), NOW(), 1, 1);

