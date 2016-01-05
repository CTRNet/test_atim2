-- iCord Customization Script
-- Version: v0.1
-- ATiM Version: v2.6.5

-- Update bank name for version tracking during customization and enable admin
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.1', '');

UPDATE `users` SET `flag_active`='1' WHERE `username`='administrator';


--  -------------------------------------------------------------------
--	Profile
--	-------------------------------------------------------------------

-- Disable clinical menus
UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_10', 'clin_CAN_1_3', 'clin_CAN_25', 'clin_CAN_26', 'clin_CAN_4', 'clin_CAN_5', 'clin_CAN_68', 'clin_CAN_75');

-- Add new fields
ALTER TABLE `participants` 
CHANGE COLUMN `date_of_death` `date_of_death` DATETIME NULL DEFAULT NULL ,
ADD COLUMN `icord_age_at_admission` INT NULL DEFAULT NULL AFTER `participant_identifier`,
ADD COLUMN `icord_manner_of_death` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_age_at_admission`,
ADD COLUMN `icord_datetime_autopsy` DATETIME NULL DEFAULT NULL AFTER `icord_manner_of_death`,
ADD COLUMN `icord_cause_of_death` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_datetime_autopsy`,
ADD COLUMN `icord_accident_details` TEXT NULL DEFAULT NULL AFTER `icord_cause_of_death`,
ADD COLUMN `icord_asia_grade` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_accident_details`,
ADD COLUMN `icord_mechanism_of_injury` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_asia_grade`,
ADD COLUMN `icord_injury_level_anatomical` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_mechanism_of_injury`,
ADD COLUMN `icord_injury_level_neurological` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_injury_level_anatomical`,
ADD COLUMN `icord_clinical_dx` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_injury_level_neurological`,
ADD COLUMN `icord_neurological_dx` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_clinical_dx`,
ADD COLUMN `icord_injury_datetime` DATETIME NULL DEFAULT NULL AFTER `icord_neurological_dx`;

ALTER TABLE `participants_revs` 
CHANGE COLUMN `date_of_death` `date_of_death` DATETIME NULL DEFAULT NULL ,
ADD COLUMN `icord_age_at_admission` INT NULL DEFAULT NULL AFTER `participant_identifier`,
ADD COLUMN `icord_manner_of_death` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_age_at_admission`,
ADD COLUMN `icord_datetime_autopsy` DATETIME NULL DEFAULT NULL AFTER `icord_manner_of_death`,
ADD COLUMN `icord_cause_of_death` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_datetime_autopsy`,
ADD COLUMN `icord_accident_details` TEXT NULL DEFAULT NULL AFTER `icord_cause_of_death`,
ADD COLUMN `icord_asia_grade` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_accident_details`,
ADD COLUMN `icord_mechanism_of_injury` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_asia_grade`,
ADD COLUMN `icord_injury_level_anatomical` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_mechanism_of_injury`,
ADD COLUMN `icord_injury_level_neurological` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_injury_level_anatomical`,
ADD COLUMN `icord_clinical_dx` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_injury_level_neurological`,
ADD COLUMN `icord_neurological_dx` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_clinical_dx`,
ADD COLUMN `icord_injury_datetime` DATETIME NULL DEFAULT NULL AFTER `icord_neurological_dx`;

-- Fix discrepancies in participants form
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');

-- Disable participant fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add new iCord fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'icord_age_at_admission', 'integer',  NULL , '0', 'size=5', '', '', 'icord age at admission', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_manner_of_death', 'input',  NULL , '0', 'size=15', '', '', 'icord manner of death', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_datetime_autopsy', 'datetime',  NULL , '0', '', '', '', 'icord datetime autopsy', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_cause_of_death', 'input',  NULL , '0', 'size=15', '', '', 'icord cause of death', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_accident_details', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'icord accident details', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_asia_grade', 'input',  NULL , '0', 'size=15', '', '', 'icord asia grade', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_mechanism_of_injury', 'input',  NULL , '0', 'size=15', '', '', 'icord mechanism of injury', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_injury_level_anatomical', 'input',  NULL , '0', 'size=15', '', '', 'icord injury level anatomical', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_injury_level_neurological', 'input',  NULL , '0', 'size=15', '', '', 'icord injury level neurological', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_clinical_dx', 'input',  NULL , '0', 'size=100', '', '', 'icord clinical dx', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_neurological_dx', 'input',  NULL , '0', 'size=100', '', '', 'icord neurological dx', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'icord_injury_datetime', 'datetime',  NULL , '0', '', '', '', 'icord injury datetime', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_age_at_admission' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='icord age at admission' AND `language_tag`=''), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_manner_of_death' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='icord manner of death' AND `language_tag`=''), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_datetime_autopsy' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='icord datetime autopsy' AND `language_tag`=''), '1', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_cause_of_death' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='icord cause of death' AND `language_tag`=''), '1', '26', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_accident_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='icord accident details' AND `language_tag`=''), '1', '27', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_asia_grade' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='icord asia grade' AND `language_tag`=''), '1', '28', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_mechanism_of_injury' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='icord mechanism of injury' AND `language_tag`=''), '1', '29', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_injury_level_anatomical' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='icord injury level anatomical' AND `language_tag`=''), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_injury_level_neurological' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='icord injury level neurological' AND `language_tag`=''), '1', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_clinical_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=100' AND `default`='' AND `language_help`='' AND `language_label`='icord clinical dx' AND `language_tag`=''), '1', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_neurological_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=100' AND `default`='' AND `language_help`='' AND `language_label`='icord neurological dx' AND `language_tag`=''), '1', '33', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_injury_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='icord injury datetime' AND `language_tag`=''), '1', '34', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Re-organize form
UPDATE structure_formats SET `display_column`='3', `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_manner_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_datetime_autopsy' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_cause_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='icord injury details' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_age_at_admission' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='18' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_manner_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='75' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_accident_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_injury_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add lookup values for Manner of Death
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("icord_manner_death", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("suicide", "suicide");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_manner_death"), (SELECT id FROM structure_permissible_values WHERE value="suicide" AND language_alias="suicide"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_manner_death"), (SELECT id FROM structure_permissible_values WHERE value="natural" AND language_alias="natural"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("misadventure", "misadventure");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_manner_death"), (SELECT id FROM structure_permissible_values WHERE value="misadventure" AND language_alias="misadventure"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("homicide", "homicide");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_manner_death"), (SELECT id FROM structure_permissible_values WHERE value="homicide" AND language_alias="homicide"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_manner_death"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "5", "1");

UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='icord_manner_death') ,  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='icord_manner_of_death' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('misadventure', 'misadventure', ''),
('homicide', 'homicide', ''),
('suicide', 'suicide', '');

-- Increase size for cause of death
UPDATE structure_fields SET  `setting`='size=30' WHERE model='Participant' AND tablename='participants' AND field='icord_cause_of_death' AND `type`='input' AND structure_value_domain  IS NULL ;

-- Lookup values for ASIA Grade
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("icord_asia_grade", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("A", "A");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_asia_grade"), (SELECT id FROM structure_permissible_values WHERE value="A" AND language_alias="A"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("B", "B");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_asia_grade"), (SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="B"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C", "C");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_asia_grade"), (SELECT id FROM structure_permissible_values WHERE value="C" AND language_alias="C"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("D", "D");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_asia_grade"), (SELECT id FROM structure_permissible_values WHERE value="D" AND language_alias="D"), "4", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("E", "E");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="icord_asia_grade"), (SELECT id FROM structure_permissible_values WHERE value="E" AND language_alias="E"), "5", "1");

UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='icord_asia_grade') ,  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='icord_asia_grade' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('A', 'A', ''),
('B', 'B', ''),
('C', 'C', ''),
('D', 'D', ''),
('E', 'E', '');

-- Mechanism of Injury lookups
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("mechanism_injury", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Assault - blunt", "Assault - blunt");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Assault - blunt" AND language_alias="Assault - blunt"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Assault - penetrating", "Assault - penetrating");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Assault - penetrating" AND language_alias="Assault - penetrating"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Fall", "Fall");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Fall" AND language_alias="Fall"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Non-traumatic spinal cord dysfunction", "Non-traumatic spinal cord dysfunction");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Non-traumatic spinal cord dysfunction" AND language_alias="Non-traumatic spinal cord dysfunction"), "4", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Sports", "Sports");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Sports" AND language_alias="Sports"), "5", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Transport", "Transport");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Transport" AND language_alias="Transport"), "6", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Unspecified or Unknown", "Unspecified or Unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Unspecified or Unknown" AND language_alias="Unspecified or Unknown"), "7", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mechanism_injury"), (SELECT id FROM structure_permissible_values WHERE value="Other" AND language_alias="Other"), "8", "1");

UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='mechanism_injury') ,  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='icord_mechanism_of_injury' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Assault - blunt', 'Assault - blunt', ''),
('Assault - penetrating', 'Assault - penetrating', ''),
('Fall', 'Fall', ''),
('Non-traumatic spinal cord dysfunction', 'Non-traumatic spinal cord dysfunction', ''),
('Sports', 'Sports', ''),
('Transport', 'Transport', ''),
('Unspecified or Unknown', 'Unspecified or Unknown', '');

-- Add field for OTHER mechanism of injury
ALTER TABLE `participants` 
ADD COLUMN `icord_mechanism_of_injury_other` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_mechanism_of_injury`;

ALTER TABLE `participants_revs` 
ADD COLUMN `icord_mechanism_of_injury_other` VARCHAR(255) NULL DEFAULT NULL AFTER `icord_mechanism_of_injury`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'icord_mechanism_of_injury_other', 'input',  NULL , '0', 'size=30', '', '', '', 'if other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='icord_mechanism_of_injury_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='if other'), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Lookup values for Injury Level
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("neuro_injury_level", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C1", "C1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C1" AND language_alias="C1"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C2", "C2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C2" AND language_alias="C2"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C3", "C3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C3" AND language_alias="C3"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C4", "C4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C4" AND language_alias="C4"), "4", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C5", "C5");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C5" AND language_alias="C5"), "5", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C6", "C6");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C6" AND language_alias="C6"), "6", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C7", "C7");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C7" AND language_alias="C7"), "7", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("C8", "C8");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="C8" AND language_alias="C8"), "8", "1");

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T1", "T1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T1" AND language_alias="T1"), "10", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T2", "T2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T2" AND language_alias="T2"), "11", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T3", "T3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T3" AND language_alias="T3"), "12", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T4", "T4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T4" AND language_alias="T4"), "13", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T5", "T5");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T5" AND language_alias="T5"), "14", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T6", "T6");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T6" AND language_alias="T6"), "15", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T7", "T7");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T7" AND language_alias="T7"), "16", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T8", "T8");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T8" AND language_alias="T8"), "17", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T9", "T9");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T9" AND language_alias="T9"), "18", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T10", "T10");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T10" AND language_alias="T10"), "19", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T11", "T11");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T11" AND language_alias="T11"), "20", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("T12", "T12");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="T12" AND language_alias="T12"), "21", "1");

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("L1", "L1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="L1" AND language_alias="L1"), "25", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("L2", "L2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="L2" AND language_alias="L2"), "26", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("L3", "L3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="L3" AND language_alias="L3"), "27", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("L4", "L4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="L4" AND language_alias="L4"), "28", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("L5", "L5");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="L5" AND language_alias="L5"), "29", "1");

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("S1", "S1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="S1" AND language_alias="S1"), "30", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("S2", "S2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="S2" AND language_alias="S2"), "31", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("S3", "S3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="neuro_injury_level"), (SELECT id FROM structure_permissible_values WHERE value="S3" AND language_alias="S3"), "32", "1");

UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='neuro_injury_level') ,  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='icord_injury_level_neurological' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('C1', 'C1', ''),
('C2', 'C2', ''),
('C3', 'C3', ''),
('C4', 'C4', ''),
('C5', 'C5', ''),
('C6', 'C6', ''),
('C7', 'C7', ''),
('C8', 'C8', ''),
('L1', 'L1', ''),
('L2', 'L2', ''),
('L3', 'L3', ''),
('L4', 'L4', ''),
('L5', 'L5', ''),
('T1', 'T1', ''),
('T2', 'T2', ''),
('T3', 'T3', ''),
('T4', 'T4', ''),
('T5', 'T5', ''),
('T6', 'T6', ''),
('T7', 'T7', ''),
('T8', 'T8', ''),
('T9', 'T9', ''),
('T10', 'T10', ''),
('T11', 'T11', ''),
('T12', 'T12', ''),
('S1', 'S1', ''),
('S2', 'S2', ''),
('S3', 'S3', '');

-- Language translations
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('participant identifier', 'SCI Participant Code', ''),
('if other', 'If other, specify', ''),
('icord age at admission', 'Age at Admission', ''),
('icord manner of death', 'Manner of Death', ''),
('icord datetime autopsy', 'Autopsy Datetime', ''),
('icord cause of death', 'Cause of Death', ''),
('icord accident details', 'Accident Details', ''),
('icord asia grade', 'ASIA Grade', ''),
('icord mechanism of injury', 'Mechanism of Injury', ''),
('icord injury level anatomical', 'Injury Level - Anatomical', ''),
('icord injury level neurological', 'Injury Level - Neurological', ''),
('icord clinical dx', 'Clinical Diagnosis', ''),
('icord neurological dx', 'Neurological Diagnosis', ''),
('icord injury datetime', 'Injury Datetime', ''),
('icord injury details', 'Injury Details', ''); 

-- Consent form
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='date_of_referral' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='route_of_referral' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='recruit_route') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='date_first_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='process_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_indicator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_signature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='facility_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='operation_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='facility' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='person handling consent',  `language_tag`='' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='consent_person' AND `type`='select' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='1', `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Consent National', 'iCord Consent', 'iCord Consent');



-- Change date of death to datetime
-- UPDATE structure_fields SET  `type`='datetime' WHERE model='Participant' AND tablename='participants' AND field='date_of_death' AND `type`='date' AND structure_value_domain  IS NULL ;
-- UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
