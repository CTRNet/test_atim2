-- -------------------------------------------------------------------------------------------------------------------------
-- Spent time field correction
-- -------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` IN ('creat_to_stor_spent_time_msg','coll_to_stor_spent_time_msg'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` IN ('creat_to_stor_spent_time_msg','coll_to_stor_spent_time_msg'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` IN ('creat_to_stor_spent_time_msg','coll_to_stor_spent_time_msg'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_cell_culture_tubes') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` IN ('creat_to_stor_spent_time_msg','coll_to_stor_spent_time_msg'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_cell_culture_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_cell_culture_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_cell_culture_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_cell_culture_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field` IN ('rec_to_stor_spent_time_msg','coll_to_stor_spent_time_msg'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_rec_to_stor_spent_time_msg_defintion' AND `language_label`='reception to storage spent time' AND `language_tag`=''), '1', '61', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '61', '', '0', '1', 'reception to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- -------------------------------------------------------------------------------------------------------------------------
-- txe_radiations
-- -------------------------------------------------------------------------------------------------------------------------

DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

-- -------------------------------------------------------------------------------------------------------------------------
-- Storage Control Review
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET coord_y_type = null WHERE id = 106;
UPDATE storage_controls SET display_y_size = 1 WHERE id = 107;
UPDATE storage_controls SET display_y_size = 1 WHERE id = 109;

-- -------------------------------------------------------------------------------------------------------------------------
-- Disable sample type : saliva and csf
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(188, 190, 189, 192);

-- --------------------------------------------------------------------------------------------------------
-- Queries to desactivate 'Participant Identifiers' demo report
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

-- --------------------------------------------------------------------------------------------------------
-- Added new relationsips into databrowser
-- Please flag unactive relationsips if required.
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str
SET fct.flag_active = 0 
WHERE fct.datamart_structure_id = str.id AND str.model IN ('DiagnosisMaster', 'TreatmentMaster', 'FamilyHistory', 'SpecimenReviewMaster', 'TreatmentExtendMaster', 'AliquotReviewMaster');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster', 'TreatmentMaster', 'FamilyHistory', 'SpecimenReviewMaster', 'TreatmentExtendMaster', 'AliquotReviewMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster', 'TreatmentMaster', 'FamilyHistory', 'SpecimenReviewMaster', 'TreatmentExtendMaster', 'AliquotReviewMaster'));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add structure_permissible_values_custom_controls.category
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET category = 'inventory - quality control' WHERE name = 'quality control tools';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - consent' WHERE name = 'qc consent version';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'qc visit label';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'qc mycoplasma tests';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'researchers';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'rna purification method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'laterality';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'treatment facility';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'information source';
UPDATE structure_permissible_values_custom_controls SET category = 'order', name = 'shipping cie' WHERE name = 'qc_nd_shipping_cie';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'DNA RNA : Storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'DNA RNA : Source storage method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'RNA : Extraction method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'DNA RNA : Source storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Ascite Cells : Storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Ascite Cells : Storage method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Cell Culture : Collection method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Cell Culture : Hormone';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Cell Culture : Solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Cell Culture : Storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Tissue : Storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Tissue : Storage method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Blood cell : Storage solution';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'Amp. RNA : Amp. method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'DNA : Extraction method';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'procure slice origins' WHERE name = 'procure _slice origins';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Manon request / Box25
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('box25','Box25 1-25','Boîte25 1-25');
SELECT id AS storage_master_id_issue_if_not_empty 
FROM storage_masters 
WHERE parent_id IN (SELECT id FROM storage_masters WHERE storage_control_id = 17 AND short_label REGEXP ('^0[0-9]$') AND selection_label REGEXP ('^17[0-9]-[0-9]-0[0-9]$') AND deleted <> 1);
UPDATE storage_masters
SET short_label = SUBSTRING(short_label, 2), selection_label = CONCAT(SUBSTRING(selection_label, 1, 6),SUBSTRING(selection_label, 8))
WHERE storage_control_id = 17 AND short_label REGEXP ('^0[0-9]$') AND selection_label REGEXP ('^17[0-9]-[0-9]-0[0-9]$') AND deleted <> 1 ;
UPDATE storage_masters_revs
SET short_label = SUBSTRING(short_label, 2), selection_label = CONCAT(SUBSTRING(selection_label, 1, 6),SUBSTRING(selection_label, 8))
WHERE storage_control_id = 17 AND short_label REGEXP ('^0[0-9]$') AND selection_label REGEXP ('^17[0-9]-[0-9]-0[0-9]$') ;
UPDATE structure_permissible_values_customs SET `en` = 'Box25 1-25', `fr` = 'Boîte25 1-25' WHERE `en` = 'Box25 1-25';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '????' WHERE version_number = '2.6.0';
