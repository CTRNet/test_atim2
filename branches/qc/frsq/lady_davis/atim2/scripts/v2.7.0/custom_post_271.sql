
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Collection protocol
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

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
 
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Add tma slide use
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add tma slide use';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Sop
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_sop_master_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (`domain_name`, `source`) VALUES('qc_lady_collection_sop_list_add', 'Sop.SopMaster::getActiveCollectionSopPermissibleValues');
INSERT INTO structure_value_domains (`domain_name`, `source`) VALUES('qc_lady_sample_sop_list_add', 'Sop.SopMaster::getAciveSampleSopPermissibleValues');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'sop_master_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_sop_list_add') , '0', '', '', '', 'collection sop', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_sop_list_add')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection sop' AND `language_tag`=''), '1', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_sop_list_add')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection sop' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_default`='0', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_follow_up' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_follow_up') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'sop_master_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_sample_sop_list_add') , '0', '', '', '', 'sample sop', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_derivative_sop'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_sample_sop_list_add')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sop' AND `language_tag`=''), '1', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_derivative_sop') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='101' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_derivative_sop') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_lady_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_xenografts'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_sample_sop_list_add')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sop' AND `language_tag`=''), '1', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_xenografts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='101' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_xenografts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_lady_sop_deviations' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Aliquot Instock Detail
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Aliquot Stock Detail', 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Stock Detail');
SET @user_id = 1;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("empty", "Empty", "Vide", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("reserved for order", "Reserved For Order", "Réservé pour une commande", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("lost", "Lost", "Perdu", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("used", "Used", "Utilisé", "8", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("on loan", "On Loan", "Prêté", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("shipped", "Shipped", "Envoyé", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("contaminated", "Contaminated", "Contaminé", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("reserved for study", "Reserved For Study/Project", "Réservé pour une Étude/Projet", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("shipped &amp; returned", "Shipped and Returned", "Enovyé et Retourné", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 9, values_counter = 9 WHERE name = 'Aliquot Stock Detail';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Aliquot Stock Detail\')' WHERE domain_name = 'aliquot_in_stock_detail';
SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'aliquot_in_stock_detail');
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Stock Detail');
SET @user_id = 1;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("destroyed - biological hazard", "Destroyed (Biological Hazard)", "Détruit (risque biologique)", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("destroyed - unconsented", "Destroyed (No consent)", "Détruit (Aucun consentement)", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("destroyed - withdrawn", "Destroyed (Participant Withdrawn)", "Détruit (participant retiré)", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Participant# : Manage by user
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM key_increments WHERE key_name = 'main_participant_id';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Imaging
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_addgrid`=`flag_add` WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_imagings');
UPDATE event_controls SET use_addgrid = 1 WHERE event_type = 'imaging' AND flag_active = 1;
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='cols=40,rows=2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_imagings_types') AND `flag_confidential`='0');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='type'), 'notBlank', '', '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'qc_lady_tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='qc_lady_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '2', '104', 'response', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE qc_lady_imagings
  ADD COLUMN `qc_lady_tumor_site` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE qc_lady_imagings_revs
  ADD COLUMN `qc_lady_tumor_site` varchar(100) NOT NULL DEFAULT '';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('site', 'Site', 'Site');
INSERT INTO structure_value_domains (domain_name, source)
VALUES
('qc_lady_tumor_participant_diagnosis_selection', 'ClinicalAnnotation.DiagnosisMaster::getParticipantDiagnosisList');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FunctionManagement', '', 'diagnosis_master_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_participant_diagnosis_selection') , '0', '', '', '', 'related diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='diagnosis_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_participant_diagnosis_selection')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='related diagnosis' AND `language_tag`=''), '2', '131', 'diagnosis', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("mixte", "mixte");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="response"), (SELECT id FROM structure_permissible_values WHERE value="mixte" AND language_alias="mixte"), "5", "1");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('mixte', 'Mixte', 'Mixte');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="response"), (SELECT id FROM structure_permissible_values WHERE value="n/a" AND language_alias="n/a"), "6", "1");

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Diagnosis Control
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET controls_type = '-' WHERE category IN ('remission', 'progression - locoregional', 'recurrence - locoregional') AND controls_type = 'undetailed';
UPDATE diagnosis_controls SET controls_type = 'localized' WHERE category IN ('secondary - distant') AND controls_type = 'undetailed';
INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'secondary - distant', 'widespread', 1, '', 'dxd_secondaries', 0, 'secondary - distant|widespread', 0);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('widespread', 'Widespread', 'Généralisé'),
('localized', 'Localized', 'Localisé');
UPDATE diagnosis_controls SET databrowser_label = CONCAT(category, '|', controls_type);

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='' AND `field`='qc_lady_tumor_site'), 'notBlank', '', '');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7467' WHERE version_number = '2.7.1';

-- Move drug_id FROM treatmet extend detail table to master
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_extend_masters Master, qc_lady_txe_hormonos Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, qc_lady_txe_hormonos_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `qc_lady_txe_hormonos` DROP FOREIGN KEY `FK_qc_lady_txe_hormonos_drugs`;
ALTER TABLE qc_lady_txe_hormonos DROP COLUMN drug_id;
ALTER TABLE qc_lady_txe_hormonos_revs DROP COLUMN drug_id;

UPDATE treatment_extend_masters Master, qc_lady_txe_immunos Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, qc_lady_txe_immunos_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `qc_lady_txe_immunos` DROP FOREIGN KEY `FK_qc_lady_txe_immunos_drugs`;
ALTER TABLE qc_lady_txe_immunos DROP COLUMN drug_id;
ALTER TABLE qc_lady_txe_immunos_revs DROP COLUMN drug_id;

UPDATE treatment_extend_masters Master, qc_lady_txe_others Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, qc_lady_txe_others_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `qc_lady_txe_others` DROP FOREIGN KEY `FK_qc_lady_txe_others_drugs`;
ALTER TABLE qc_lady_txe_others DROP COLUMN drug_id;
ALTER TABLE qc_lady_txe_others_revs DROP COLUMN drug_id;

UPDATE versions SET branch_build_number = '7491' WHERE version_number = '2.7.1';

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
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_sop_list_add') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_sop_list_add') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_sop_list_add') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_sop_list_add') AND `flag_confidential`='0');

UPDATE versions SET branch_build_number = '7502' WHERE version_number = '2.7.1';