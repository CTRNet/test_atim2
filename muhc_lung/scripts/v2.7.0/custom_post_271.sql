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

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
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
("surgery", "Surgery", "", '1', @control_id, 2, NOW(),2, NOW()),
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

-- -----------------------------------------------------------------------------------------------------------------------------------
-- study
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Collection & Bank Nbr
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Acquisition Label

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', 
`flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', 
`flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='acquisition_label');

-- Lung Bank Participant Identifier

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'lung bank participant number', 1, 50, '', '', 
0, 0, 1, 0, '^JS\-[0-9]{2}\-[0-9]{4}$', 'JS-00-0000', 0);
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('lung bank participant number', 'Lung Bank - Participant#', 'Banque Poumon - Participant#');

-- collections misc_identifier

ALTER TABLE collections 
  ADD COLUMN  `misc_identifier_id` int(11) DEFAULT NULL,
  ADD CONSTRAINT `cusm_collections_misc_identifier_ibfk` FOREIGN KEY (`misc_identifier_id`) REFERENCES `misc_identifiers` (`id`);
ALTER TABLE collections_revs 
  ADD COLUMN  `misc_identifier_id` int(11) DEFAULT NULL;
INSERT IGNORE  INTO i18n (id,en,fr)
VALUES
('participant bank number', 'Bank - Participant #', 'Banque - Participant #'),
('at least one collection is linked to that participant identifier', "At least one collection is linked to that 'Participant #'! Data can not be deleted!", "Au moins une collection est liée à ce 'Participant #'! La donnée ne peut pas être supprimée!");

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '25', '', '0', '1', 'participant bank number', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '0', '1', 'participant bank number', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- collection tree view

UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_collection_types') AND `flag_confidential`='0');


-- view_aliquot_joined_to_sample_and_collection

UPDATE structure_formats SET `display_order`='-1', `language_heading`='participant' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', '', 'input',  NULL , '0', 'size=15', '', '', 'participant bank number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='participant bank number' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

-- view_sample_joined_to_collection

UPDATE structure_formats SET `display_order`='-1', `language_heading`='participant' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'identifier_value', 'input',  NULL , '0', 'size=15', '', '', 'participant bank number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='participant bank number' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- view_collection

UPDATE structure_formats SET `display_order`='-1', `language_heading`='participant' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0', `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'identifier_value', 'input',  NULL , '0', 'size=15', '', '', 'participant bank number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='participant bank number' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');

-- Sample & Aliquot Tree View

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Storage
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET storage_type_en = 'Box81 A1-I9', storage_type_fr = 'Boîte81 A1-I9' WHERE id = 9;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Consent
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE `cusm_cd_lungs` 
  ADD COLUMN `stool_sampling` char(1) DEFAULT '',
  ADD COLUMN `pericardial_fat_sampling` char(1) DEFAULT '';
ALTER TABLE `cusm_cd_lungs_revs` 
  ADD COLUMN `stool_sampling` char(1) DEFAULT '',
  ADD COLUMN `pericardial_fat_sampling` char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cusm_cd_lungs', 'stool_sampling', 'yes_no',  NULL , '0', '', '', '', 'stool sampling', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cusm_cd_lungs', 'pericardial_fat_sampling', 'yes_no',  NULL , '0', '', '', '', 'pericardial fat sampling', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_cd_lungs'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_cd_lungs' AND `field`='stool_sampling' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stool sampling' AND `language_tag`=''), '2', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_cd_lungs'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_cd_lungs' AND `field`='pericardial_fat_sampling' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pericardial fat sampling' AND `language_tag`=''), '2', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('stool sampling', 'Stool Sampling', 'Prélèvement de selles'),
('pericardial fat sampling', 'Pericardial Fat Sampling', 'Prélèvement de graisse péricardique');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Inventory configuration
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('141', '188', '144', '220', '137', '142', '203');
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('102', '194', '7', '130', '101', '10', '3', '4');
UPDATE aliquot_controls SET flag_active=false WHERE id IN('11');
UPDATE realiquoting_controls SET flag_active=false WHERE id IN('12');
UPDATE realiquoting_controls SET flag_active=true WHERE id IN('48');
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('227', '25', '124');
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN('187', '158');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_ad_tissue_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cusm_storage_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_tissue_tube_storage_methods') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_ad_tissue_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cusm_storage_solution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_tissue_tube_storage_solutions') AND `flag_confidential`='0');

UPDATE structure_fields SET field = 'tissue_nature' WHERE field = 'cusm_tissue_nature';
UPDATE structure_permissible_values_custom_controls SET values_max_length = '15' WHERE name = "Tissue Natures";
ALTER TABLE sd_spe_tissues DROP COLUMN cusm_tissue_nature;
ALTER TABLE sd_spe_tissues_revs DROP COLUMN cusm_tissue_nature;

-- Remove aliquot master to study

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 1 AND id2 =25) OR (id1 = 25 AND id2 =1);
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Other
-- -----------------------------------------------------------------------------------------------------------------------------------

-- New Identifiers

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'CHL-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0);
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('CHL-MRN', 'CHL-MRN', 'CHL-MRN');

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'participant identifiers report';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewCollection' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'print barcodes';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add tma slide use';

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Protocol/%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Drug/%';

UPDATE versions SET branch_build_number = '7543' WHERE version_number = '2.7.1';

-- View  collection and SOP

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Review

UPDATE aliquot_review_controls SET flag_active = 0;
UPDATE specimen_review_controls SET flag_active = 0;

UPDATE versions SET branch_build_number = '7548' WHERE version_number = '2.7.1';
UPDATE versions SET branch_build_number = '7554' WHERE version_number = '2.7.1';

-- ===================================================================================================================================
-- New Dev 2019-01-21 (Including Tumor Registry Form)
-- ===================================================================================================================================

-- Event

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/lab/%' OR use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Clinical/%';
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 2 AND id2 =14) OR (id1 = 14 AND id2 =2);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 14 AND id2 =4) OR (id1 = 4 AND id2 =14);

-- Diagnosis

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters%';
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 2 AND id2 =14) OR (id1 = 14 AND id2 =2);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 14 AND id2 =4) OR (id1 = 4 AND id2 =14);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 9 AND id2 =4) OR (id1 = 4 AND id2 =9);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 9 AND id2 =9) OR (id1 = 9 AND id2 =9);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 14 AND id2 =9) OR (id1 = 9 AND id2 =14);

-- Blood testing 
-- [Clinical Annotation - Event]
-- # ATiM Only #
-- -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'lab', 'blood testing', 1, 'cusm_ed_lab_blood_testing', 'cusm_ed_lab_blood_testings', 0, 'lab|blood testing', 1, 1, 1);
DROP TABLE IF EXISTS cusm_ed_lab_blood_testings;
CREATE TABLE `cusm_ed_lab_blood_testings` (
	wbc decimal(10,1) DEFAULT NULL,
	wbc_unit varchar(20) DEFAULT NULL,
	platelets decimal(10,1) DEFAULT NULL,
	platelets_unit varchar(20) DEFAULT NULL,
	neutrophil decimal(10,1) DEFAULT NULL,
	neutrophil_unit varchar(20) DEFAULT NULL,
	lymphocyte decimal(10,1) DEFAULT NULL,
	lymphocyte_unit varchar(20) DEFAULT NULL,
	monocyte decimal(10,1) DEFAULT NULL,
	monocyte_unit varchar(20) DEFAULT NULL,
	eosinophil decimal(10,1) DEFAULT NULL,
	eosinophil_unit varchar(20) DEFAULT NULL,
	basophil decimal(10,1) DEFAULT NULL,
	basophil_unit varchar(20) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `cusm_ed_lab_blood_testings`
  ADD KEY `event_master_id` (`event_master_id`),
  ADD CONSTRAINT `cusm_ed_lab_blood_testings_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
  DROP TABLE IF EXISTS cusm_ed_lab_blood_testings_revs;
CREATE TABLE `cusm_ed_lab_blood_testings_revs` (
	wbc decimal(10,1) DEFAULT NULL,
	wbc_unit varchar(20) DEFAULT NULL,
	platelets decimal(10,1) DEFAULT NULL,
	platelets_unit varchar(20) DEFAULT NULL,
	neutrophil decimal(10,1) DEFAULT NULL,
	neutrophil_unit varchar(20) DEFAULT NULL,
	lymphocyte decimal(10,1) DEFAULT NULL,
	lymphocyte_unit varchar(20) DEFAULT NULL,
	monocyte decimal(10,1) DEFAULT NULL,
	monocyte_unit varchar(20) DEFAULT NULL,
	eosinophil decimal(10,1) DEFAULT NULL,
	eosinophil_unit varchar(20) DEFAULT NULL,
	basophil decimal(10,1) DEFAULT NULL,
	basophil_unit varchar(20) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `cusm_ed_lab_blood_testings_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;

INSERT INTO structures(`alias`) VALUES ('cusm_ed_lab_blood_testing');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'wbc', 'float',  NULL , '0', '', '', '', 'wbc', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'platelets', 'float',  NULL , '0', '', '', '', 'platelets', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'neutrophil', 'float',  NULL , '0', '', '', '', 'neutrophil', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'lymphocyte', 'float',  NULL , '0', '', '', '', 'lymphocyte', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'monocyte', 'float',  NULL , '0', '', '', '', 'monocyte', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'eosinophil', 'float',  NULL , '0', '', '', '', 'eosinophil', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'basophil', 'float',  NULL , '0', '', '', '', 'basophil', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'cols=20,rows=1', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='wbc'), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='platelets'), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='neutrophil'), '1', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='lymphocyte'), '1', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='monocyte'), '1', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='eosinophil'), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='basophil'), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("cusm_blood_testing_units", "", "", "StructurePermissibleValuesCustom::getCustomDropdown('Blood Testing Units')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Blood Testing Units', 1, 20, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood Testing Units');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
("", "", "", '1', @control_id, 2, NOW(),2, NOW()),
("10e9/L", "", "", '1', @control_id, 2, NOW(),2, NOW()),
("10e12/L", "", "", '1', @control_id, 2, NOW(),2, NOW()),
("g/L", "", "", '1', @control_id, 2, NOW(),2, NOW()),
("%", "", "", '1', @control_id, 2, NOW(),2, NOW());
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'wbc_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_testing_units') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'platelets_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_testing_units') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'neutrophil_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_testing_units') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'lymphocyte_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_testing_units') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'monocyte_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_testing_units') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'eosinophil_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_testing_units') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_ed_lab_blood_testings', 'basophil_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_blood_testing_units') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='wbc_unit'), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='platelets_unit'), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='neutrophil_unit'), '1', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='lymphocyte_unit'), '1', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='monocyte_unit'), '1', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='eosinophil_unit'), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_ed_lab_blood_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_ed_lab_blood_testings' AND `field`='basophil_unit'), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('blood testing', 'Blood Testing', 'Test sanguin'),
('wbc', 'WBC', ''),
('platelets', 'Platelets', ''),
('neutrophil', 'Neutrophil', ''),
('lymphocyte', 'Lymphocyte', ''),
('monocyte', 'Monocyte', ''),
('eosinophil', 'Eosinophil', ''),
('basophil', 'Basophil', '');

-- Profile 
-- [Clinical Annotation - Profile]
-- # Tumor Registry Only #
-- -------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND `display_order` >= '99' AND display_column = 3;

ALTER TABLE participants 
  ADD COLUMN cusm_tumor_registery_accession_number VARCHAR(100) DEFAULT NULL,
  ADD COLUMN cusm_tumor_registery_first_contact_at_muhc DATE DEFAULT NULL,
  ADD COLUMN cusm_tumor_registery_first_contact_at_muhc_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN cusm_tumor_registery_last_contact_at_muhc DATE DEFAULT NULL,
  ADD COLUMN cusm_tumor_registery_last_contact_at_muhc_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN cusm_tumor_registery_data_conflict CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN cusm_tumor_registery_data_conflict_details TEXT,
  ADD COLUMN cusm_tumor_registery_last_migration DATE DEFAULT NULL;
ALTER TABLE participants_revs
  ADD COLUMN cusm_tumor_registery_accession_number VARCHAR(100) DEFAULT NULL,
  ADD COLUMN cusm_tumor_registery_first_contact_at_muhc DATE DEFAULT NULL,
  ADD COLUMN cusm_tumor_registery_first_contact_at_muhc_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN cusm_tumor_registery_last_contact_at_muhc DATE DEFAULT NULL,
  ADD COLUMN cusm_tumor_registery_last_contact_at_muhc_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN cusm_tumor_registery_data_conflict CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN cusm_tumor_registery_data_conflict_details TEXT,
  ADD COLUMN cusm_tumor_registery_last_migration DATE DEFAULT NULL;
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_tumor_registery_accession_number', 'input',  NULL , '0', '', '', '', 'accession number', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_tumor_registery_first_contact_at_muhc', 'date',  NULL , '0', '', '', '', 'first contact at muhc', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_tumor_registery_last_contact_at_muhc', 'date',  NULL , '0', '', '', '', 'last contact at muhc', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_tumor_registery_data_conflict', 'yes_no',  NULL , '0', '', '', '', 'data conflict', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_tumor_registery_data_conflict_details', 'textarea',  NULL , '0', 'cols=40,rows=1', '', '', 'data conflict details', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_tumor_registery_last_migration', 'date',  NULL , '0', '', '', '', 'last migration', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_accession_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='accession number' AND `language_tag`=''), '3', '63', 'tumor registery - data migration', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_first_contact_at_muhc' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first contact at muhc' AND `language_tag`=''), '3', '64', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_last_contact_at_muhc' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact at muhc' AND `language_tag`=''), '3', '66', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_data_conflict' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='data conflict' AND `language_tag`=''), '3', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_data_conflict_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=1' AND `default`='' AND `language_help`=''), '3', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_last_migration' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last migration' AND `language_tag`=''), '3', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('tumor registery - data migration', 'Tumors Registery (Data Migration)', 'Registre des tumeurs (migration de données)'),
('tumor registery', 'Tumors Registery', 'Registre des tumeurs'),
('accession number', 'Accession #', 'Accession #'),
('last contact at muhc', 'Last Contact (at MUHC)', 'Dernier contact (au CUSM)'),
('first contact at muhc', 'First Contact (at MUHC)', 'Premier contact (au CUSM)'),
('data conflict', 'Data Conflict', 'Conflit de données'),
('data conflict details', 'Conflict Details', 'Détails conflits'),	
('last migration', 'Last Migration', 'Dernière migration');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND flag_edit = 1;
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Profile 
-- [Clinical Annotation - Profile]
-- # ATiM Only #
-- -------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE participants 
  ADD COLUMN cusm_last_contact DATE DEFAULT NULL,
  ADD COLUMN cusm_last_contact_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN cusm_last_contact DATE DEFAULT NULL,
  ADD COLUMN cusm_last_contact_accuracy CHAR(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'cusm_last_contact', 'date',  NULL , '0', '', '', '', 'last contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '3', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('last contact', 'Last Contact', 'Dernier contact');
  
-- Race

UPDATE structure_fields SET  `type`='input',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `setting`='size=15',  `language_label`='ethnicity' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('ethnicity', 'Ethnicity', 'Ethnicité');

-- Tumor Registry Diagnosis 
-- [Clinical Annotation - Diagnosis]
-- # Tumor Registry Only #
-- -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'tumor registry', 1, 'cusm_lung_dxd_tumor_registry', 'cusm_lung_dxd_tumor_registry', 0, 'primary|tumor registry', 0);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters 
   ADD COLUMN cusm_lung_topography_description VARCHAR(500) DEFAULT NULL,
   ADD COLUMN cusm_lung_morphology_description VARCHAR(500) DEFAULT NULL,
   ADD COLUMN cusm_lung_tumor_size_source VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_clinical_stage_descriptor VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_path_stage_descriptor VARCHAR(250) DEFAULT NULL,
   MODIFY dx_method varchar(250) DEFAULT NULL,
   ADD COLUMN cusm_sequence_number varchar(5) DEFAULT NULL,
   ADD COLUMN cusm_class_of_case varchar(5) DEFAULT NULL,
   ADD COLUMN cusm_facility varchar(250) DEFAULT NULL,
   ADD COLUMN cusm_dx_confirmation_method varchar(500) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs 
   ADD COLUMN cusm_lung_topography_description VARCHAR(500) DEFAULT NULL,
   ADD COLUMN cusm_lung_morphology_description VARCHAR(500) DEFAULT NULL,
   ADD COLUMN cusm_lung_tumor_size_source VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_clinical_stage_descriptor VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_path_stage_descriptor VARCHAR(250) DEFAULT NULL,
   MODIFY dx_method varchar(250) DEFAULT NULL,
   ADD COLUMN cusm_sequence_number varchar(5) DEFAULT NULL,
   ADD COLUMN cusm_class_of_case varchar(5) DEFAULT NULL,
   ADD COLUMN cusm_facility varchar(250) DEFAULT NULL,
   ADD COLUMN cusm_dx_confirmation_method varchar(500) DEFAULT NULL;

DROP TABLE IF EXISTS `cusm_lung_dxd_tumor_registry`;
CREATE TABLE `cusm_lung_dxd_tumor_registry` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  lymph_vascular_invasion char(1) DEFAULt '',
  KEY `diagnosis_master_id` (`diagnosis_master_id`),
  CONSTRAINT `cusm_lung_dxd_tumor_registry_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `cusm_lung_dxd_tumor_registry_revs`;
CREATE TABLE `cusm_lung_dxd_tumor_registry_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  lymph_vascular_invasion char(1) DEFAULt '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO structures(`alias`) VALUES ('cusm_lung_dxd_tumor_registry');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_lung_topography_description', 'input',  NULL , '0', 'size=20', '', '', '', 'details'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'dx_method', 'input',  NULL , '0', '', '', '', 'dx method', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_sequence_number', 'input',  NULL , '0', 'size=2', '', '', 'sequence number', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_dx_confirmation_method', 'input',  NULL , '0', '', '', '', '', 'confirmation'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_lung_morphology_description', 'input',  NULL , '0', 'size=20', '', '', '', 'details'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'cusm_lung_dxd_tumor_registry', 'lymph_vascular_invasion', 'yes_no',  NULL , '0', '', '', '', 'lymph vascular invasion', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'input',  NULL , '0', 'size=2', '', 'help_tumour grade', 'tumour grade', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_lung_clinical_stage_descriptor', 'input',  NULL , '0', 'size=20', '', '', 'descriptor', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_class_of_case', 'input',  NULL , '0', 'size=2', '', '', 'class of case', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_lung_path_stage_descriptor', 'input',  NULL , '0', 'size=20', '', '', 'descriptor', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_facility', 'input',  NULL , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'cusm_lung_dxd_tumor_registry', 'laterality', 'input',  NULL , '0', 'size=20', '', '', 'laterality', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'cusm_lung_tumor_size_source', 'input',  NULL , '0', 'size=20', '', '', '', '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumor_size_greatest_dimension', 'float',  NULL , '0', '', '', '', 'size of the tunor (mm)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_sequence_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=2' AND `default`='' AND `language_help`='' AND `language_label`='sequence number' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_class_of_case' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=2' AND `default`='' AND `language_help`='' AND `language_label`='class of case' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_facility' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '5', '', '0', '1', 'facility', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dx method' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_dx_confirmation_method' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='confirmation'), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '6', 'coding', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=10', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_topography_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '2', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=2' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '10', '', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=10', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='cusm_lung_dxd_tumor_registry' AND `field`='lymph_vascular_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph vascular invasion' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_morphology_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '19', 'staging', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='help_clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_clinical_stage_descriptor'), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='input'), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='input'), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='input'), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='input'), '2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), ((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_path_stage_descriptor'), '2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='cusm_lung_dxd_tumor_registry' AND `field`='laterality'), '2', '99', 'tissue specific', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension'), '2', '100', '', '0', '1', 'size of the tunor (mm)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_tumor_size_source'), '2', '101', '', '0', '0', '', '1', 'source', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_topography_description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('lymph vascular invasion', 'Lymph-Vascular Invasion', ''),
('sequence number', 'Sequence Number', 'Numéro de séquence'),
('class of case', 'Class of Case', 'Classe du cas'),
('dx method', 'Method', 'Méthode'),
('confirmation', 'Confirmation', 'Confirmation'),
('size of the tunor (mm)', 'size of the tunor (mm)', 'Taille de la tumeur (mm)'),
('source', 'Source', 'Source'),
('descriptor', 'Descriptor', 'Descripteur'),
('tumor registry', 'Tumor Registry', 'Registre des tumeurs');

-- Secondary

INSERT INTO `diagnosis_controls` 
VALUES 
(null,'secondary - distant','tumor registery',1,'cusm_lung_dxd_tumor_registry_secondary','dxd_secondaries',0,'secondary - distant|tumor registery',0);
INSERT INTO structures(`alias`) VALUES ('cusm_lung_dxd_tumor_registry_secondary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '6', 'coding', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=10', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_topography_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '2', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_secondary');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_topography_description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_secondary');

-- Recurrence

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) 
VALUES
(null, 'recurrence - locoregional', 'tumor registry', 1, 'cusm_lung_dxd_tumor_registry_recurence', 'dxd_recurrences', 0, 'recurrence - locoregional|tumor registry', 0);
INSERT INTO structures(`alias`) VALUES ('cusm_lung_dxd_tumor_registry_recurence');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_recurence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '6', 'coding', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=10', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_recurence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_topography_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '2', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
ALTER TABLE dxd_recurrences ADD COLUMN cusm_lung_type varchar(250) DEFAULT NULL;
ALTER TABLE dxd_recurrences ADD COLUMN cusm_lung_type_revs varchar(250) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'cusm_lung_type', 'input',  NULL , '0', 'size=20', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_lung_dxd_tumor_registry_recurence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='cusm_lung_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- View Diagnosis 
-- [Clinical Annotation - Diagnosis]
-- # N/A #
-- -------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_search`='0', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code');
UPDATE structure_formats 
SET `flag_search`='0', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd_0_3_topography_category');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cusm_lung_topography_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '2', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Lab
-- [Clinical Annotation - Annotation]
-- # Tumor Registry Only #
-- -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'lab', 'tumor registry laboratory testing', 1, 'cusm_lung_ed_lab_tumor_registry_laboratory_testing', 'cusm_lung_ed_lab_tumor_registry_laboratory_testings', 0, 'lab|tumor registry laboratory testing', 0, 1, 1);
DROP TABLE IF EXISTS cusm_lung_ed_lab_tumor_registry_laboratory_testings;
CREATE TABLE `cusm_lung_ed_lab_tumor_registry_laboratory_testings` (
   test_title varchar(250) DEFAULT NULL,
   test_result varchar(250) DEFAULT NULL,
   test_not_done tinyint(1) DEFAULT '0',
  `event_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `cusm_lung_ed_lab_tumor_registry_laboratory_testings`
  ADD KEY `event_master_id` (`event_master_id`),
  ADD CONSTRAINT `cusm_lung_ed_lab_tumor_registry_laboratory_testings_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
  DROP TABLE IF EXISTS cusm_lung_ed_lab_tumor_registry_laboratory_testings_revs;
CREATE TABLE `cusm_lung_ed_lab_tumor_registry_laboratory_testings_revs` (
   test_title varchar(250) DEFAULT NULL,
   test_result varchar(250) DEFAULT NULL,
   test_not_done tinyint(1) DEFAULT '0',
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `cusm_lung_ed_lab_tumor_registry_laboratory_testings_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structures(`alias`) VALUES ('cusm_lung_ed_lab_tumor_registry_laboratory_testing');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'cusm_lung_ed_lab_tumor_registry_laboratory_testings', 'test_title', 'input',  NULL , '0', 'size=10', '', '', 'test', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_lung_ed_lab_tumor_registry_laboratory_testings', 'test_result', 'input',  NULL , '0', 'size=10', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'cusm_lung_ed_lab_tumor_registry_laboratory_testings', 'test_not_done', 'checkbox',  NULL , '0', '', '', '', 'test not done', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_lung_ed_lab_tumor_registry_laboratory_testing'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'cols=20,rows=1', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_ed_lab_tumor_registry_laboratory_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_lung_ed_lab_tumor_registry_laboratory_testings' AND `field`='test_title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='test' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_ed_lab_tumor_registry_laboratory_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_lung_ed_lab_tumor_registry_laboratory_testings' AND `field`='test_result' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_ed_lab_tumor_registry_laboratory_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='cusm_lung_ed_lab_tumor_registry_laboratory_testings' AND `field`='test_not_done' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='test not done' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('tumor registry laboratory testing', 'Tumor Registry - Laboratory Testing', 'Registre des tumeurs - Tests de laboratoire'),
('test not done', 'Test Not Done', 'Test non fait');

-- DataBrowser 
-- [N/A]
-- # N/A #
-- -------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 10 AND id2 =4) OR (id1 = 4 AND id2 =10);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 20 AND id2 =10) OR (id1 = 10 AND id2 =20);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 14 AND id2 =9) OR (id1 = 9 AND id2 =14);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 2 AND id2 =14) OR (id1 = 14 AND id2 =2);

-- Tumor Registry Treatment 
-- [Clinical Annotation - Treatment]
-- # Tumor Registry Only #
-- -------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMaster%';

INSERT INTO treatment_extend_controls (id, detail_tablename, detail_form_alias, flag_active, type,databrowser_label)
VALUES
(null, 'cusm_lung_txe_chemos', 'cusm_lung_txe_chemos', 1, 'chemotherapy drug', 'chemotherapy drug');
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'chemotherapy', 'tumor registry', 1, 'cums_lung_txd_chemos', 'txd_chemos', 0, NULL, NULL, 'tumor registry|chemotherapy', 0, (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'cusm_lung_txe_chemos'), 0, 0),
(null, 'radiation', 'tumor registry', 1, 'cums_lung_txd_radiations', 'txd_radiations', 0, NULL, NULL, 'tumor registry|radiation', 0, NULL, 0, 0),
(null, 'surgery', 'tumor registry', 1, 'cums_lung_txd_surgeries', 'txd_surgeries', 0, 2, NULL, 'tumor registry|surgery', 0,NULL, 0, 0),
(null, 'dx procedure', 'tumor registry', 1, '', 'cums_lung_txd_dx_procedures', 0, 2, NULL, 'tumor registry|dx procedure', 0, NULL, 0, 0),
(null, 'palliatif', 'tumor registry', 1, '', 'cums_lung_txd_palliatifs', 0, 2, NULL, 'tumor registry|palliatif', 0, NULL, 0, 0);
UPDATE treatment_controls SET use_detail_form_for_index = 1 WHERE flag_active = 1 AND disease_site = 'tumor registry';

-- treatment_masters

ALTER TABLE treatment_masters 
  MODIFY facility varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_course varchar(10) DEFAULT NULL,
  ADD COLUMN cusm_lung_treatment_this_facility char(1) DEFAULT '', 
  ADD COLUMN cusm_lung_physician varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_physician_license varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_treatment_code varchar(250) DEFAULT NULL;  
ALTER TABLE treatment_masters_revs
  MODIFY facility varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_course varchar(10) DEFAULT NULL,
  ADD COLUMN cusm_lung_treatment_this_facility char(1) DEFAULT '', 
  ADD COLUMN cusm_lung_physician varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_physician_license varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_treatment_code varchar(250) DEFAULT NULL;  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'cusm_lung_course', 'input',  NULL , '0', 'size=20', '', '', 'course', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'cusm_lung_treatment_this_facility', 'input',  NULL , '0', 'size=20', '', '', 'treatment this facility', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'cusm_lung_physician', 'input',  NULL , '0', 'size=20', '', '', 'physician', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'cusm_lung_physician_license', 'input',  NULL , '0', 'size=10', '', '', 'physician license', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'cusm_lung_treatment_code', 'input',  NULL , '0', '', '', '', 'treatment code', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'facility', 'input',  NULL , '0', 'size=20', '', '', 'facility', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='cusm_lung_course' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='course' AND `language_tag`=''), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='cusm_lung_treatment_this_facility' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='treatment this facility' AND `language_tag`=''), '1', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='cusm_lung_physician' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='physician' AND `language_tag`=''), '1', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='cusm_lung_physician_license' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='physician license' AND `language_tag`=''), '1', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='cusm_lung_treatment_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment code' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='facility' AND `language_tag`=''), '1', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `type`='yes_no',  `setting`='' WHERE model='TreatmentMaster' AND tablename='treatment_masters' AND field='cusm_lung_treatment_this_facility' AND `type`='input' AND structure_value_domain  IS NULL ;
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('dx procedure', 'Dx Procedure', 'Dc procedure'),
('palliatif', 'Palliatif', 'Palliatif'),
('course', 'Course', 'Branche'),
('treatment code', 'Code', 'Code'),
('treatment this facility', 'Treatment This Facility', 'Traitement de cet établissement'),
('facility', 'Facility', 'Établissement'),
('physician', 'Physician', 'Médecin'),
('physician license', 'Physician License', 'License du médecin');

DROP TABLE IF EXISTS `cums_lung_txd_dx_procedures`;
CREATE TABLE `cums_lung_txd_dx_procedures` (
  `treatment_master_id` int(11) NOT NULL,
  KEY `treatment_master_id` (`treatment_master_id`),
  CONSTRAINT `cums_lung_txd_dx_procedures_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `cums_lung_txd_dx_procedures_revs`;
CREATE TABLE `cums_lung_txd_dx_procedures_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `cums_lung_txd_palliatifs`;
CREATE TABLE `cums_lung_txd_palliatifs` (
  `treatment_master_id` int(11) NOT NULL,
  KEY `treatment_master_id` (`treatment_master_id`),
  CONSTRAINT `cums_lung_txd_palliatifs_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `cums_lung_txd_palliatifs_revs`;
CREATE TABLE `cums_lung_txd_palliatifs_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Suregery

ALTER TABLE txd_surgeries
   ADD COLUMN cusm_lung_surgical_margins VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_scope_reg_ln_surgery VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_surgery_other_site VARCHAR(250) DEFAULT NULL;
ALTER TABLE txd_surgeries_revs
   ADD COLUMN cusm_lung_surgical_margins VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_scope_reg_ln_surgery VARCHAR(250) DEFAULT NULL,
   ADD COLUMN cusm_lung_surgery_other_site VARCHAR(250) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('cums_lung_txd_surgeries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'cusm_lung_surgical_margins', 'input',  NULL , '0', 'size=20', '', '', 'surgical margins', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'cusm_lung_scope_reg_ln_surgery', 'input',  NULL , '0', 'size=20', '', '', 'scope reg ln surgery', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'cusm_lung_surgery_other_site', 'input',  NULL , '0', 'size=20', '', '', 'surgery other site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cums_lung_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='cusm_lung_surgical_margins' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='surgical margins' AND `language_tag`=''), '2', '40', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='cusm_lung_scope_reg_ln_surgery' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='scope reg ln surgery' AND `language_tag`=''), '2', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='cusm_lung_surgery_other_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='surgery other site' AND `language_tag`=''), '2', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('surgical margins', 'Surgical Margins', ""),
('scope reg ln surgery', 'Scope Reg LN Surgery', ""),
('surgery other site', 'Surgery Other Site', "");

-- Chemotherapy

INSERT INTO structures(`alias`) VALUES ('cums_lung_txd_chemos');
DROP TABLE IF EXISTS `cusm_lung_txe_chemos`;
CREATE TABLE `cusm_lung_txe_chemos` (
  `start` DATE DEFAULT NULL,
  `start_accuracy` CHAR(1) NOT NULL DEFAULT '',
  `end` DATE DEFAULT NULL,
  `end_accuracy` CHAR(1) NOT NULL DEFAULT '',
  `nsc_number` varchar(250) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_cusm_lung_txe_chemos_treatment_extend_masters` (`treatment_extend_master_id`),
  CONSTRAINT `FK_cusm_lung_txe_chemos_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `cusm_lung_txe_chemos_revs`;
CREATE TABLE `cusm_lung_txe_chemos_revs` (
  `start` DATE DEFAULT NULL,
  `start_accuracy` CHAR(1) NOT NULL DEFAULT '',
  `end` DATE DEFAULT NULL,
  `end_accuracy` CHAR(1) NOT NULL DEFAULT '',
  `nsc_number` varchar(250) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO structures(`alias`) VALUES ('cusm_lung_txe_chemos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'cusm_lung_txe_chemos', 'start', 'date',  NULL , '0', '', '', '', 'start', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'cusm_lung_txe_chemos', 'end', 'date',  NULL , '0', '', '', '', 'end', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'cusm_lung_txe_chemos', 'nsc_number', 'input',  NULL , '0', '', '', '', 'nsc number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_lung_txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='cusm_lung_txe_chemos' AND `field`='start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='start' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='cusm_lung_txe_chemos' AND `field`='end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='end' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cusm_lung_txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='cusm_lung_txe_chemos' AND `field`='nsc_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nsc number' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('end', 'End', "Fin"),
('nsc number', 'NSC Number', "NSC#");

-- Radiation

ALTER TABLE treatment_masters  
  MODIFY target_site_icdo varchar(250) DEFAULt NULL;
ALTER TABLE treatment_masters_revs  
  MODIFY target_site_icdo varchar(250) DEFAULt NULL;
INSERT INTO structures(`alias`) VALUES ('cums_lung_txd_radiations');
ALTER TABLE txd_radiations
  ADD COLUMN cusm_lung_regional_modality varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_regional_dose_cgy decimal(10,2) DEFAULT NULL,
  ADD COLUMN cusm_lung_boost_modality varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_boost_dose_cgy decimal(10,2) DEFAULT NULL;
ALTER TABLE txd_radiations_revs
  ADD COLUMN cusm_lung_regional_modality varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_regional_dose_cgy decimal(10,2) DEFAULT NULL,
  ADD COLUMN cusm_lung_boost_modality varchar(250) DEFAULT NULL,
  ADD COLUMN cusm_lung_boost_dose_cgy decimal(10,2) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_radiations', 'cusm_lung_regional_modality', 'input',  NULL , '0', '', '', '', 'modality', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_radiations', 'cusm_lung_regional_dose_cgy', 'float',  NULL , '0', 'size=3', '', '', 'dose cgy', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_radiations', 'cusm_lung_boost_modality', 'input',  NULL , '0', '', '', '', 'modality', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_radiations', 'cusm_lung_boost_dose_cgy', 'float',  NULL , '0', 'size=3', '', '', 'dose cgy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='target_site_icdo' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_target_site_icdo' AND `language_label`='target site' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '2', '8', 'radiation specific', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_rad_completed' AND `language_label`='completed' AND `language_tag`=''), '2', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='cusm_lung_regional_modality' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='modality' AND `language_tag`=''), '2', '14', 'regional', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='cusm_lung_regional_dose_cgy' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='dose cgy' AND `language_tag`=''), '2', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='cusm_lung_boost_modality' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='modality' AND `language_tag`=''), '2', '16', 'boost', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='cusm_lung_boost_dose_cgy' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='dose cgy' AND `language_tag`=''), '2', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('regional', 'Regional', "Regionale"),
('modality', 'Modality', "Modalité"),
('dose cgy', 'Dose (cGy)', "Dose (cGy)"),
('boost', 'Boost', "Boost");
  
-- Participant - Tumor Registry Data Update
-- [Clinical Annotation - Profile]
-- # N/A #
-- -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('cums_lung_participants_tumor_registry');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cums_lung_participants_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_accession_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='accession number' AND `language_tag`=''), '3', '63', 'tumor registery - data migration', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_participants_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_first_contact_at_muhc' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first contact at muhc' AND `language_tag`=''), '3', '64', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_participants_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_last_contact_at_muhc' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact at muhc' AND `language_tag`=''), '3', '66', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_participants_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_last_migration' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last migration' AND `language_tag`=''), '3', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_participants_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_data_conflict' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='data conflict' AND `language_tag`=''), '3', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='cums_lung_participants_tumor_registry'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cusm_tumor_registery_data_conflict_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=1' AND `default`='' AND `language_help`='' AND `language_label`='data conflict details' AND `language_tag`=''), '3', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');


