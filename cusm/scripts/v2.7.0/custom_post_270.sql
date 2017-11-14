-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Change Managers group to system

UPDATE groups SET name = 'System', deleted = 1 WHERE name = 'Managers'; 
UPDATE users SET username = 'system', first_name = 'System & Migration', email = '', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 0, deleted = '1' WHERE username = 'manager'; 
SET @user_system_id = (SELECT id FROM users WHERE username = 'system');

-- Admin User

UPDATE users 
SET username = 'NicoEn', first_name = 'Nicolas Luc', email = '', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 1, deleted = '0', force_password_reset = null 
WHERE username = 'administrator';
UPDATE groups SET flag_show_confidential = '1' WHERE name = 'Administrators'; 

-- First Bank User : Lung

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'lung bank number', 1, 50, 'lung bank number', 'JS-%%YY%%-%%key_increment%%', 
1, 0, 1, 0, '', '', 0),
(null, 'ramq nbr', 1, 10, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'MGH-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'RVC-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0);
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('lung bank number', 'Patient Id - Lung', 'Patient Id - Poumon'),
('ramq nbr', 'RAMQ', 'RAMQ'),
('MGH-MRN', 'MGH-MRN', 'MGH-MRN'),
('RVC-MRN', 'RVC-MRN', 'RVC-MRN');
INSERT INTO key_increments (key_name, key_value) VALUES ('lung bank number', '200');
UPDATE banks
SET name = 'Lung/Poumon', description = '', misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'lung bank number') 
WHERE name = 'Default Bank';
UPDATE groups SET name = 'Lung - Administrators', bank_id = (SELECT id FROM banks WHERE name = 'Lung/Poumon') WHERE name = 'Users'; 
UPDATE users 
SET username = 'Lung', first_name = 'Lung User Demo', email = '', password = md5('Lung'), flag_active = 1, deleted = '0', force_password_reset = null
WHERE username = 'user1'; 

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Participants
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='3', `display_order`='99', `language_heading`='', `flag_add`='0', `flag_edit_readonly`='1', `flag_addgrid_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='clin_demographics' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) 
VALUES
('participant identifier', 'ATiM-P#', 'ATiM-P#');







-- -----------------------------------------------------------------------------------------------------------------------------------
-- Inventory
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Collection Bank

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id'), 'notEmpty', '');

-- Collection Site

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
("montreal children's hospital", "Montreal Children's Hospital", "Hôpital de Montréal pour enfants", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("montreal chest institute", "Montreal Chest Institute", "Institut thoracique de Montréal", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("royal victoria hospital", "Royal Victoria Hospital", "Hôpital Royal Victoria", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("lachine hospital", "Hôpital Lachine", "Lachine Hospital", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("montreal neurological hospital", "Montreal Neurological Hospital", "Hôpital neurologique de Montréal", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("montreal general hospital", "Montreal General Hospital", "Hôpital général de Montréal", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());

-- Acquisition Label

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', 
`flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', 
`flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='acquisition_label');

-- Collection Bank Participant Id

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'cusm_collection_participant_bank_number', 'input',  NULL , '0', 'size=15', '', '', 'participant bank number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='cusm_collection_participant_bank_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='participant bank number' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'cusm_collection_participant_bank_number', 'input',  NULL , '0', 'size=15', '', '', 'participant bank number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='cusm_collection_participant_bank_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='participant bank number' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'cusm_collection_participant_bank_number', 'input',  NULL , '0', 'size=15', '', '', 'participant bank number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='cusm_collection_participant_bank_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='participant bank number' AND `language_tag`=''), '0', '0', 'collection', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en,fr) 
VALUES
('participant bank number', 'Bank Patient Id', 'Banque - Patient Id');

-- Sample Master : Is Problematic

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Aliquot View Header

UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');

























collections



collections




INSERT INTO banks 


UPDATE groups SET name = 'Lung Administartors', deleted = 1 WHERE name = 'Users';







UPDATE users 
SET 
WHERE id = 1;










-- -------------------------------------------------------------------------------------
-- 
-- -------------------------------------------------------------------------------------














UPDATE versions SET branch_build_number = '6920' WHERE version_number = '2.7.0';