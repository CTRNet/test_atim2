-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'MUHC', 'CUSM');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Bank/User Management
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr)
VALUES
('you are not allowed to create/modify the data', 'You are not allowed to create/modify the data', "Vous n'êtes pas autorisé à créer/modified la donnée");

SELECT 'Remove permission on add, edit, delete banks for all groups.' AS '###TODO###';

-- Administrators & System Groups
-- -------------------------------------------------------------------------------

UPDATE groups SET name = 'System', deleted = 1 WHERE name = 'Managers'; 
UPDATE users 
SET username = 'system', first_name = 'System & Migration', email = '', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 0, deleted = '1' 
WHERE username = 'manager'; 
SET @user_system_id = (SELECT id FROM users WHERE username = 'system');

UPDATE users 
SET username = 'NicoEn', first_name = 'Nicolas Luc', email = '', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 1, deleted = '0', force_password_reset = null 
WHERE username = 'administrator';
UPDATE groups SET flag_show_confidential = '1' WHERE name = 'Administrators'; 

-- Banks Groups
-- -------------------------------------------------------------------------------

-- Lung

UPDATE banks
SET name = 'Lung/Poumon', description = ''
WHERE name = 'Default Bank';
UPDATE groups 
SET name = 'Lung - Administrators', bank_id = (SELECT id FROM banks WHERE name = 'Lung/Poumon'), flag_show_confidential = '1' 
WHERE name = 'Users'; 
UPDATE users 
SET username = 'Lung', first_name = 'Lung User Demo', email = '', password ='ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 1, deleted = '0', force_password_reset = null
WHERE username = 'user1';

UPDATE structure_permissible_values_custom_controls SET flag_active = '0' WHERE name = 'Laboratory Staff';
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cusm_lung_bank_staff", "", "", CONCAT("StructurePermissibleValuesCustom::getCustomDropdown(\'Lung Bank [", (SELECT id FROM banks WHERE name = 'Lung/Poumon'),"] - Staff\')"));
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES (CONCAT("Lung Bank [", (SELECT id FROM banks WHERE name = 'Lung/Poumon'),"] - Staff"), 1, 50, 'administration');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = CONCAT("Lung Bank [", (SELECT id FROM banks WHERE name = 'Lung/Poumon'),"] - Staff"));
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
("Aya Siblini", "", "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("Emma Lee", "", "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("Julie Breau", "", "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
("Jonathan Spicer", "", "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());

-- Breast

INSERT INTO banks (name, description, `modified_by`, `created`, `created_by`, `modified`)
VALUES
('Breast/Sein', '', @user_system_id, NOW(),@user_system_id, NOW());  
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cusm_breast_bank_staff", "", "", CONCAT("StructurePermissibleValuesCustom::getCustomDropdown(\'Breast Bank [", (SELECT id FROM banks WHERE name = 'Breast/Sein'),"] - Staff\')"));
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES (CONCAT("Breast Bank [", (SELECT id FROM banks WHERE name = 'Breast/Sein'),"] - Staff"), 1, 50, 'administration');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = CONCAT("Breast Bank [", (SELECT id FROM banks WHERE name = 'Breast/Sein'),"] - Staff"));
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
("Morag Park", "", "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());

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
('participant identifier', 'ATiM - Participant#', 'ATiM - Patient#');

-- MiscIdentifiers
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE misc_identifier_controls
  ADD COLUMN `cusm_bank_id` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_is_main_bank_participant_identifier` tinyint(1) DEFAULT '0';
ALTER TABLE misc_identifier_controls
  ADD CONSTRAINT `CUSM_FK_misc_identifier_controls_banks` FOREIGN KEY (`cusm_bank_id`) REFERENCES `banks` (`id`);  

-- (TODO: Note sure these custom fields are required)

ALTER TABLE misc_identifiers
  ADD COLUMN `cusm_bank_id` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_is_main_bank_participant_identifier` tinyint(1) DEFAULT '0';
ALTER TABLE misc_identifiers_revs
  ADD COLUMN `cusm_bank_id` int(11) DEFAULT NULL,
  ADD COLUMN `cusm_is_main_bank_participant_identifier` tinyint(1) DEFAULT '0';
ALTER TABLE misc_identifiers
  ADD CONSTRAINT `CUSM_FK_misc_identifiers_banks` FOREIGN KEY (`cusm_bank_id`) REFERENCES `banks` (`id`);  

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Lung Bank

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'lung bank participant number', 1, 50, 'lung bank participant number', 'JS-%%YY%%-%%key_increment%%', 
1, 0, 1, 0, '', '', 0),
(null, 'ramq nbr', 1, 10, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'MGH-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'RVC-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0);
UPDATE misc_identifier_controls 
SET cusm_bank_id = (SELECT id FROM banks WHERE name = 'Lung/Poumon'), cusm_is_main_bank_participant_identifier = '1'
WHERE misc_identifier_name = 'lung bank participant number';
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('lung bank participant number', 'Lung Bank - Participant#', 'Banque Poumon - Patient#'),
('ramq nbr', 'RAMQ', 'RAMQ'),
('MGH-MRN', 'MGH-MRN', 'MGH-MRN'),
('RVC-MRN', 'RVC-MRN', 'RVC-MRN');
INSERT INTO key_increments (key_name, key_value) VALUES ('lung bank participant number', '200');

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'lung bank participant study number', 1, 60, '', '', 
0, 0, 0, 0, '', '', 1);
UPDATE misc_identifier_controls 
SET cusm_bank_id = (SELECT id FROM banks WHERE name = 'Lung/Poumon')
WHERE misc_identifier_name = 'lung - participant study identifier';
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('lung bank participant study number', 'Lung Bank - Study#', 'Banque Poumon - Étude#');

-- Breast bank

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'breast bank participant number', 1, 45, 'breast bank participant number', '??-%%key_increment%%',1, 0, 1, 0, '', '', 0);
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('breast bank participant number', 'Breast Bank - Participant#', 'Banque Sein - Patient#');
INSERT INTO key_increments (key_name, key_value) VALUES ('breast bank participant number', '1');
UPDATE misc_identifier_controls 
SET cusm_bank_id = (SELECT id FROM banks WHERE name = 'Breast/Sein'), cusm_is_main_bank_participant_identifier = '1'
WHERE misc_identifier_name = 'breast bank participant number';

-- Consents
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0;

ALTER TABLE consent_controls
  ADD COLUMN `cusm_bank_id` int(11) DEFAULT NULL;
ALTER TABLE consent_controls
  ADD CONSTRAINT `CUSM_FK_consent_controls_banks` FOREIGN KEY (`cusm_bank_id`) REFERENCES `banks` (`id`);  

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons') AND `flag_confidential`='0');
UPDATE structure_permissible_values_custom_controls SET flag_active = '0' WHERE name = 'Consent Form Versions';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '21', '', '0', '1', 'witness', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_override_type`='1', `type`='input' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Lung Consent

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, cusm_bank_id) VALUES
(null, 'lung bank consent', 1, 'cusm_cd_lungs', 'cusm_cd_lungs', 0, 'lung bank consent', (SELECT id FROM banks WHERE name = 'Lung/Poumon'));

CREATE TABLE `cusm_cd_lungs` (
  `consent_master_id` int(11) NOT NULL,
  `with_restriction` char(1) DEFAULT '',
  KEY `consent_master_id` (`consent_master_id`),
  CONSTRAINT `CUSM_FK_cusm_cd_lungs_consent_masters` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `cusm_cd_lungs_revs` (
  `consent_master_id` int(11) NOT NULL,
  `with_restriction` char(1) DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO structures(`alias`) VALUES ('cusm_cd_lungs');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cusm_lung_consent_from_versions", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Lung - Consent Form Versions\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Lung - Consent Form Versions', 1, 50, 'clinical - consent');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'form_version', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_lung_consent_from_versions') , '0', '', '', '', 'form_version', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cusm_cd_lungs', 'with_restriction', 'yes_no',  NULL , '0', '', '', '', 'with restriction', ''), 
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'consent_person', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_lung_bank_staff') , '0', '', '', '', 'witness', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_cd_lungs'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_lung_consent_from_versions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='form_version' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_cd_lungs'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_cd_lungs' AND `field`='with_restriction' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='with restriction' AND `language_tag`=''), '2', '201', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_cd_lungs'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_lung_bank_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='witness' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('lung bank consent', 'Lung Bank - Consent', 'Banque Poumon - Consentement'),
('with restriction', 'With Restriction', 'Avec restriction'),
('witness', 'Witness', 'Témoin');






























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
('participant bank number', 'Bank - Participant#', 'Banque - Patient#');

-- Sample Master : Is Problematic

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Aliquot View Header

UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');










-- -------------------------------------------------------------------------------------
-- 
-- -------------------------------------------------------------------------------------














UPDATE versions SET branch_build_number = '6920' WHERE version_number = '2.7.0';