-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'MUHC - Skin Lesions', 'CUSM - Lésions cutanées');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('melanoma', 'Melanoma', 'Mélanome');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('skin lesions', 'Skin Lesions', 'Lésions cutanées');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('skin lesion', 'Skin Lesion', 'Lésion cutanée');

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

-- Skin Lesions

UPDATE banks
SET name = 'Skin Lesions/Lésions cutanées', description = ''
WHERE name = 'Default Bank';
UPDATE groups 
SET name = 'Skin Lesions - Administrators', bank_id = (SELECT id FROM banks WHERE name = 'Skin Lesions/Lésions cutanées'), flag_show_confidential = '1' 
WHERE name = 'Users'; 
UPDATE users 
SET username = 'Skin Lesions', first_name = 'Skin Lesions User Demo', email = '', password ='ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 1, deleted = '0', force_password_reset = null
WHERE username = 'user1';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
-- INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
-- VALUES
-- ("", "", "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());

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
('participant identifier', 'ATiM - Participant #', 'ATiM - Participant #');

-- MiscIdentifiers
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Skin Lesions Bank

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'ramq nbr', 1, 10, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'MGH-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'RVC-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0);
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('ramq nbr', 'RAMQ', 'RAMQ'),
('MGH-MRN', 'MGH-MRN', 'MGH-MRN'),
('RVC-MRN', 'RVC-MRN', 'RVC-MRN');

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'skin lesions bank participant study number', 1, 60, '', '', 
0, 0, 0, 0, '', '', 1);
INSERT IGNORE  into i18n (id,en,fr)
VALUES
('skin lesions bank participant study number', 'Skin Lesions Bank - Study#', 'Banque des lésions cutanées - Étude#');

-- Consents
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons') AND `flag_confidential`='0');
UPDATE structure_permissible_values_custom_controls SET flag_active = '0' WHERE name = 'Consent Form Versions';

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' 
AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0'), 'notBlank', '');

ALTER TABLE consent_masters 
  ADD COLUMN `cusm_sl_bk_with_restriction` char(1) DEFAULT '';
ALTER TABLE consent_masters_revs
  ADD COLUMN `cusm_sl_bk_with_restriction` char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'cusm_sl_bk_with_restriction', 'yes_no',  NULL , '0', '', '', '', 'with restriction', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='cusm_sl_bk_with_restriction' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='with restriction' AND `language_tag`=''), '2', '201', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('with restriction', 'With Restriction', 'Avec restriction');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='22', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='cusm_sl_bk_with_restriction' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Skin Lesions Consent

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'skin lesions bank consent', 1, 'cusm_sl_bk_cd_skin_lesions', 'cusm_sl_bk_cd_skin_lesions', 0, 'skin lesions bank consent');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('skin lesions bank consent', 'Skin Lesions Bank - Consent', 'Banque des lésions cutanées - Consentement');
INSERT INTO structures(`alias`) VALUES ('cusm_sl_bk_cd_skin_lesions');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cusm_sl_bk_consent_from_versions", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Skin Lesions - Consent Form Versions\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Skin Lesions - Consent Form Versions', 1, 50, 'clinical - consent');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Skin Lesions - Consent Form Versions');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
("1.7 2019-01-15", "v1.7 15 January 2019", "v1.7 15 Janvier 2019", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'consent_person', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'witness', ''),
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'form_version', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_consent_from_versions') , '0', '', '', '', 'form_version', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_consent_from_versions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='form_version' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='witness' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
Replace INTO i18n (id,en,fr)
VALUES
('witness', 'Witness', 'Témoin');

CREATE TABLE `cusm_sl_bk_cd_skin_lesions` (
  `consent_master_id` int(11) NOT NULL,
  `questionnaires` char(1) DEFAULT '',
  `blood_sampling` char(1) DEFAULT '',
  `urine_sampling` char(1) DEFAULT '',
  `stools_sampling` char(1) DEFAULT '',
  `tissue_sampling` char(1) DEFAULT '',
  `access_to_archived_samples` char(1) DEFAULT '',
  `future_specific_research` char(1) DEFAULT '',
  KEY `consent_master_id` (`consent_master_id`),
  CONSTRAINT `FK_cusm_sl_bk_cd_skin_lesions_consent_masters` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `cusm_sl_bk_cd_skin_lesions_revs` (
  `consent_master_id` int(11) NOT NULL,
  `questionnaires` char(1) DEFAULT '',
  `blood_sampling` char(1) DEFAULT '',
  `urine_sampling` char(1) DEFAULT '',
  `stools_sampling` char(1) DEFAULT '',
  `tissue_sampling` char(1) DEFAULT '',
  `access_to_archived_samples` char(1) DEFAULT '',
  `future_specific_research` char(1) DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cusm_sl_bk_cd_skin_lesions', 'questionnaires', 'yes_no',  NULL , '0', '', '', '', 'questionnaires', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cusm_sl_bk_cd_skin_lesions', 'blood_sampling', 'yes_no',  NULL , '0', '', '', '', 'blood sampling', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cusm_sl_bk_cd_skin_lesions', 'urine_sampling', 'yes_no',  NULL , '0', '', '', '', 'urine sampling', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cusm_sl_bk_cd_skin_lesions', 'stools_sampling', 'yes_no',  NULL , '0', '', '', '', 'stools sampling', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cusm_sl_bk_cd_skin_lesions', 'tissue_sampling', 'yes_no',  NULL , '0', '', '', '', 'tissue sampling', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cusm_sl_bk_cd_skin_lesions', 'access_to_archived_samples', 'yes_no',  NULL , '0', '', '', '', 'access to archived samples', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cusm_sl_bk_cd_skin_lesions', 'future_specific_research', 'yes_no',  NULL , '0', '', '', '', 'future research', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_sl_bk_cd_skin_lesions' AND `field`='questionnaires'), '2', '40', 'agreements', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_sl_bk_cd_skin_lesions' AND `field`='blood_sampling'), '2', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_sl_bk_cd_skin_lesions' AND `field`='urine_sampling'), '2', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_sl_bk_cd_skin_lesions' AND `field`='stools_sampling'), '2', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_sl_bk_cd_skin_lesions' AND `field`='tissue_sampling'), '2', '50', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_sl_bk_cd_skin_lesions' AND `field`='access_to_archived_samples'), '2', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_cd_skin_lesions'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cusm_sl_bk_cd_skin_lesions' AND `field`='future_specific_research'), '2', '61', 're-contact', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('agreements', 'Agreements', "Autorisations"),
('questionnaires', 'Questionnaires', "Questionnaires"),
('blood sampling', 'Blood Sampling', "Prélèvement sanguin"),
('urine sampling', 'Urine Sampling', "Prélèvement urine"),
('stools sampling', 'Stools Sampling', "Prélèvement selles"),
('tissue sampling', 'Tissue Sampling', "Prélèvement de tissus"),
('access to archived samples', 'Access to Archived Samples', "Accès aux échantillons archivés"),
('re-contact', 'Re-contact', "Re-Contact"),
('future research', 'Future Research', "Recherche future");

-- ....
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- SOP
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE sop_controls SET sop_group = 'bank', type = 'skin lesions' WHERE id = 1;
UPDATE sop_controls SET flag_active = '0' WHERE id = 2;

UPDATE structure_fields SET  `type`='input',  `structure_value_domain`= NULL ,  `setting`='size=20' WHERE model='SopMaster' AND tablename='sop_masters' AND field='version' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_sop_verisons');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sop_groups') ,  `language_label`='sop' WHERE model='SopControl' AND tablename='sop_controls' AND field='sop_group' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sop_groups');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sop_types') ,  `language_label`='' WHERE model='SopControl' AND tablename='sop_controls' AND field='type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sop_types');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Inventory
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Collection
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Collection Bank

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id'), 'notBlank', '');

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

-- Collection Tree View

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Generated', '', 'cusm_sl_bk_collection_specimens', 'input',  NULL , '0', 'size=20', '', '', 'collection specimens', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='cusm_sl_bk_collection_specimens' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='collection specimens' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Sample - All
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Sample Master : Is Problematic & SOP

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');

-- aliquot label

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats 
SET display_order = (display_order+1)
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'barcode' AND model IN ('ViewAliquot', 'AliquotMaster', 'AliquotMasterChildren', 'Generated'));
UPDATE structure_formats 
SET display_order = (display_order-1)
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'aliquot_label' AND model IN ('ViewAliquot', 'AliquotMaster', 'AliquotMasterChildren', 'Generated'));

-- Aliquot - All
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Aliquot View Header

UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='sample' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');

-- Aliquot
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');

-- Tissue
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories')  
WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='tissue_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues');

ALTER TABLE sd_spe_tissues ADD COLUMN cusm_sl_bk_tissue_nature varchar(50) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs ADD COLUMN cusm_sl_bk_tissue_nature varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cusm_sl_bk_tissue_natures", "", "", CONCAT("StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Natures\')"));
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ("Tissue Natures", 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = "Tissue Natures");
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
('benign','Benign', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
('tumor','Tumor', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
('metastatic','Metastatic', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
('normal','Normal', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
('unknown','Unknown', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'cusm_sl_bk_tissue_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_tissue_natures') , '0', '', '', '', 'nature', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='cusm_sl_bk_tissue_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_tissue_natures')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature' AND `language_tag`=''), '1', '442', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE ad_tubes
  ADD COLUMN cusm_sl_bk_storage_method VARCHAR(100) DEFAULT NULL,
  ADD COLUMN cusm_sl_bk_storage_solution VARCHAR(100) DEFAULT NULL;
ALTER TABLE ad_tubes_revs
  ADD COLUMN cusm_sl_bk_storage_method VARCHAR(100) DEFAULT NULL,
  ADD COLUMN cusm_sl_bk_storage_solution VARCHAR(100) DEFAULT NULL;
UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias, ',cusm_sl_bk_ad_tissue_tubes') 
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue') 
AND aliquot_type = 'tube';
INSERT INTO structures(`alias`) VALUES ('cusm_sl_bk_ad_tissue_tubes');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("cusm_sl_bk_tissue_tube_storage_methods", "", "", CONCAT("StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Tube Storage Methods\')")),
("cusm_sl_bk_tissue_tube_storage_solutions", "", "", CONCAT("StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Tube Storage Solutions\')"));
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
("Tissue Tube Storage Methods", 1, 50, 'inventory'),
("Tissue Tube Storage Solutions", 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = "Tissue Tube Storage Methods");
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
('flash freeze','Flash Freeze', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = "Tissue Tube Storage Solutions");
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
('OCT','', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
('DMSO','', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'cusm_sl_bk_storage_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_tissue_tube_storage_methods') , '0', '', '', '', 'storage method', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'cusm_sl_bk_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_tissue_tube_storage_solutions') , '0', '', '', '', 'storage solution', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cusm_sl_bk_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_tissue_tube_storage_methods')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage method' AND `language_tag`=''), '1', '75', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_sl_bk_ad_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cusm_sl_bk_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_tissue_tube_storage_solutions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage solution' AND `language_tag`=''), '1', '76', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES
('storage method', 'Storage Method', "Méthode d'entreposage"),
('storage solution', 'Storage Solution', "Solution d'entreposage");

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source'), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='cusm_sl_bk_tissue_nature'), '0', '6', '', '0', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_blood_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='', `flag_override_tag`='1', `language_tag`='#' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Blood
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cusm_sl_bk_blood_types", "", "", CONCAT("StructurePermissibleValuesCustom::getCustomDropdown(\'Blood Types\')"));
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ("Blood Types", 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = "Blood Types");
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified_by`, `created`, `created_by`, `modified`)
VALUES
('edta','EDTA', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
('serum','Serum', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW()),
('paxgen','Paxgen', "", '1', @control_id, @user_system_id, NOW(),@user_system_id, NOW());
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='cusm_sl_bk_blood_types') 
WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type';

-- buffy coat

UPDATE parent_to_derivative_sample_controls 
SET flag_active=true 
WHERE derivative_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat');
UPDATE parent_to_derivative_sample_controls 
SET flag_active=true 
WHERE parent_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
AND derivative_sample_control_id != (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
UPDATE aliquot_controls 
SET flag_active=true
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat') 
AND aliquot_type = 'tube';
UPDATE realiquoting_controls SET flag_active=true 
WHERE parent_aliquot_control_id = (
	SELECT id FROM aliquot_controls 
	WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat') 
	AND aliquot_type = 'tube'
);

-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6920' WHERE version_number = '2.7.0';