
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

INSERT INTO structures(`alias`) VALUES ('qcroc_txd_liver_biopsy_for_clini_coll_link');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy_for_clini_coll_link'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='303' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='biopsy_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types') AND `flag_confidential`='0');

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

UPDATE structure_formats SET `flag_override_label` = 1, `language_label` = 'used by/shipped to' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES 
('shipping number', 'Shipping #'),
('shipped by','Shipped by'),
('shipped to','Shipped to'),
('use/event','Use/Event'),
('transfer','Transfer'),
('shipping conditions','Shipping conditions'),
('method of dispatch','Dispatch method'),
('aliquot transfer','Aliquot transfer'),
('used by/shipped to','Used by/Shipped to'),
('unable to calculate time sample remained in rnalater','Unable to calculate time sample remained in rnalater'),
('the treatment date used as default collection date was rough','The treatment date used as default collection date was rough');	

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(10);

REPLACE INTO i18n (id,en) VALUES 
('realiquoted by','Processed By (Realiquoting)'),
('realiquoting date','Processing Date (Realiquoting)');

ALTER TABLE realiquotings
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '',  
  ADD COLUMN qcroc_sop_master_id int(11) DEFAULT NULL,
  ADD COLUMN qcroc_sop_deviations text;  
ALTER TABLE realiquotings_revs
  ADD COLUMN qcroc_sop_followed char(1) DEFAULT '',  
  ADD COLUMN qcroc_sop_master_id int(11) DEFAULT NULL,
  ADD COLUMN qcroc_sop_deviations text;  

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qcroc_blocks_sops', 'open', '', 'Sop.SopMaster::getBlockSopPermissibleValues');
INSERT INTO `sop_controls` (`sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
('tissue block', '', 'sopd_general_alls', 'sopd_general_all', '', '', 0, NULL, 0, NULL, 0, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Realiquoting', 'realiquotings', 'qcroc_sop_followed', 'yes_no',  NULL , '0', '', '', '', 'sop followed', ''), 
('InventoryManagement', 'Realiquoting', 'realiquotings', 'qcroc_sop_master_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_blocks_sops') , '0', '', '', '', 'sop#', ''), 
('InventoryManagement', 'Realiquoting', 'realiquotings', 'qcroc_sop_deviations', 'textarea',  NULL , '0', 'cols=30,rows=3', '', '', 'sop deviations', ''); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_without_vol'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='qcroc_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '1', '2013', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_without_vol'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='qcroc_sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_blocks_sops')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop#' AND `language_tag`=''), '1', '2014', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_without_vol'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='qcroc_sop_deviations' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '1', '2015', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_with_vol'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='qcroc_sop_followed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop followed' AND `language_tag`=''), '1', '2015', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_with_vol'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='qcroc_sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_blocks_sops')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sop#' AND `language_tag`=''), '1', '2016', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_with_vol'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='qcroc_sop_deviations' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='sop deviations' AND `language_tag`=''), '1', '2017', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0');

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

UPDATE structure_formats SET `language_heading`='tissue carrot data (if applied)' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_methyl_butane_refrigeration' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_methyl_butane_refrigeration') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES 
('tissue carrot data (if applied)','Tissue carrot data (if applied)');

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

INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, 1, 'create aliquot tranfers', '/InventoryManagement/AliquotMasters/addAliquotTransfer/', 1, '');




















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
-- Exampel values to delete

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


 
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

exit
in progress




























-- Review

UPDATE aliquot_review_controls SET flag_active = 0;
UPDATE specimen_review_controls SET flag_active = 0;
INSERT INTO `aliquot_review_controls` (`id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `aliquot_type_restriction`) VALUES
(null, 'qcroc tissue slide review', 1, 'qcroc_ar_tissue_slides', 'qcroc_ar_tissue_slides', 'qcroc tissue slide review');
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue' ), (SELECT id FROM aliquot_review_controls  WHERE review_type = 'qcroc tissue slide review'), 'qcroc tissue review', 1, 'qcroc_spr_tissues', 'qcroc_spr_tissues', 'qcroc tissue review');

CREATE TABLE IF NOT EXISTS `qcroc_ar_tissue_slides` (
  `aliquot_review_master_id` int(11) NOT NULL,
  `type` varchar(100) NOT NULL,
  `length` decimal(5,1) DEFAULT NULL,
  `width` decimal(5,1) DEFAULT NULL,
  `invasive_percentage` decimal(5,1) DEFAULT NULL,
  `in_situ_percentage` decimal(5,1) DEFAULT NULL,
  `normal_percentage` decimal(5,1) DEFAULT NULL,
  `stroma_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_inv_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_is_percentage` decimal(5,1) DEFAULT NULL,
  `inflammation` int(4) DEFAULT NULL,
  `quality_score` int(4) DEFAULT NULL,
  KEY `FK_qcroc_ar_tissue_slides_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `qcroc_ar_tissue_slides_revs` (
  `aliquot_review_master_id` int(11) NOT NULL,
  `type` varchar(100) NOT NULL,
  `length` decimal(5,1) DEFAULT NULL,
  `width` decimal(5,1) DEFAULT NULL,
  `invasive_percentage` decimal(5,1) DEFAULT NULL,
  `in_situ_percentage` decimal(5,1) DEFAULT NULL,
  `normal_percentage` decimal(5,1) DEFAULT NULL,
  `stroma_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_inv_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_is_percentage` decimal(5,1) DEFAULT NULL,
  `inflammation` int(4) DEFAULT NULL,
  `quality_score` int(4) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `spr_breast_cancer_types` (
  `specimen_review_master_id` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `other_type` varchar(250) DEFAULT NULL,
  `tumour_grade_score_tubules` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_nuclear` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_mitosis` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_total` decimal(5,1) DEFAULT NULL,
  `tumour_grade_category` varchar(100) DEFAULT NULL,
  KEY `FK_spr_breast_cancer_types_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `spr_breast_cancer_types_revs` (
  `specimen_review_master_id` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `other_type` varchar(250) DEFAULT NULL,
  `tumour_grade_score_tubules` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_nuclear` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_mitosis` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_total` decimal(5,1) DEFAULT NULL,
  `tumour_grade_category` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qcroc_ar_tissue_slides`
  ADD CONSTRAINT `FK_qcroc_ar_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);
ALTER TABLE `spr_breast_cancer_types`
  ADD CONSTRAINT `FK_spr_breast_cancer_types_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

UPDATE structure_formats SET `display_column`='1', `display_order`='71', `language_heading`='collection information at site' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='time_placed_at_4c' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');




