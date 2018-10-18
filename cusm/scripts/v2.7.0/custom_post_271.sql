-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hide collection protocol
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Misc Identifiers
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Diagnosis		
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET flag_active = 0;
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters%';
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 2 AND id2 =9) OR (id1 = 9 AND id2 =2);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 10 AND id2 =9) OR (id1 = 9 AND id2 =10);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 14 AND id2 =9) OR (id1 = 9 AND id2 =14);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 9 AND id2 =9) OR (id1 = 9 AND id2 =9);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 9 AND id2 =4) OR (id1 = 4 AND id2 =9);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Treatment		
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_active = 0;
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters%';
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 20 AND id2 =10) OR (id1 = 10 AND id2 =20);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 10 AND id2 =4) OR (id1 = 4 AND id2 =10);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 2 AND id2 =10) OR (id1 = 10 AND id2 =2);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- EVent		
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE event_controls SET flag_active = 0;
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%';
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 14 AND id2 =4) OR (id1 = 4 AND id2 =14);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 2 AND id2 =14) OR (id1 = 14 AND id2 =2);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Clinical Collection		
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- template_init_structure
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation site' AND `language_tag`=''), '2', '300', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_creation_datetime_defintion' AND `language_label`='creation date' AND `language_tag`='' LIMIT 0,1), '2', '100', 'derivative', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by' AND `language_tag`=''), '2', '200', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `language_heading`='specimen' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_initial_storage_datetime_defintion' AND `language_label`='initial storage date' AND `language_tag`=''), '3', '1000', 'aliquot', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- TMA Slide : analysis/scoring
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 27 AND id2 =23) OR (id1 = 23 AND id2 =27);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 27 AND id2 =25) OR (id1 = 25 AND id2 =27);

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlideUse' AND label = 'edit';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Reproductive History
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 19 AND id2 =4) OR (id1 = 4 AND id2 =19);
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- First/last name not empty
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), 'notBlank', '', ''),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), 'notBlank', '', '');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Stool
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN('222', '224', '225');
UPDATE aliquot_controls SET flag_active=true WHERE id IN('68');
UPDATE realiquoting_controls SET flag_active=true WHERE id IN('71');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- New bank people
-- -----------------------------------------------------------------------------------------------------------------------------------

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = CONCAT("Lung Bank [", (SELECT id FROM banks WHERE name = 'Lung/Poumon'),"] - Staff"));
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
("Samantha", "", "", '1', @control_id, '2', NOW(),'2', NOW()),
("Marianne", "", "", '1', @control_id, '2', NOW(),'2', NOW()),
("Nick Berthos", "", "", '1', @control_id, '2', NOW(),'2', NOW());

-- -----------------------------------------------------------------------------------------------------------------------------------
-- History : Time
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='chronology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Collection
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Collection Type

ALTER TABLE collections ADD COLUMN cusm_collection_type VARCHAR(100) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN cusm_collection_type VARCHAR(100) DEFAULT NULL;

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("cusm_collection_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown('Collection Types')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Collection Types', 1, 100, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Collection Types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
("pre-surgery", "Pre-surgery", "", '1', @control_id, 2, NOW(),2, NOW()),
("post-surgery", "Post-surgery", "", '1', @control_id, 2, NOW(),2, NOW()),
("baseline", "Baseline", "", '1', @control_id, 2, NOW(),2, NOW());

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'cusm_collection_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_type'), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_type' ), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_type' ), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_type'), '0', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'cusm_collection_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='cusm_collection_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='cusm_collection_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'cusm_collection_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='cusm_collection_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types') AND `flag_confidential`='0');

-- Collection Pathology Nbr

ALTER TABLE collections ADD COLUMN cusm_collection_pathology_nbr VARCHAR(100) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN cusm_collection_pathology_nbr VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'cusm_collection_pathology_nbr', 'input',  NULL , '1', '', '', '', 'pathology number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_pathology_nbr'), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_pathology_nbr'), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_pathology_nbr' ), '0', '45', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', '', 'cusm_collection_pathology_nbr', 'input',  NULL , '1', '', '', '', 'pathology number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='' AND `field`='cusm_collection_pathology_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathology number' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- view_sample_joined_to_collection
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `language_heading`='participant' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='cusm_collection_participant_bank_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='cusm_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- view_aliquot_joined_to_sample_and_collection
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `language_heading`='participant' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='cusm_collection_participant_bank_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1', `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- storage
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = 0;
UPDATE storage_controls SET flag_active = 1 WHERE storage_type IN ('nitrogen locator', 'freezer', 'rack9', 'rack16', 'box81 1A-9I');
UPDATE storage_controls SET permute_x_y = 1 WHERE storage_type = 'box81 1A-9I';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- barcode & aliquot_label
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,placeholder=-- ATiM# --' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_validations 
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'barcode') AND rule = 'notBlank';
-- INSERT INTO structure_validations (structure_field_id, rule, language_message)
-- VALUES
-- ((SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'barcode'), 'custom,/^(?![Aa][Tt][Ii][Mm]#).*/', 'error barcode should be different than system barcode');
INSERT INTO i18n (id,en,fr)
VALUES
('error barcode should be different than system barcode', 
"The barcode value should not beginn as 'ATiM#'!", "La valeur du code-barres ne doit pas commencer par 'ATiM#'!");
INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='aliquot_label'), 
'notBlank', '', '');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- aliquot_masters_for_collection_tree_view
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7458' WHERE version_number = '2.7.0';



# Label of the aliquots (labelled from 1 to n)
     - Tissue in OCT :: JS-00-0000 OCT T/N (all tissues in the initial .xls are in OCT) 
     - Flash Frozen Tissue :: JS-00-0000 FF T/N
     - Tissue in DMSO :: JS-00-0000 CC T/N 
     
Plus generate label into the code 

lab people into colelction

format des boites et racks

