-- PedVas Custom Script
-- Version: v0.1
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'PedVas - v0.1 DEV', '');

-- Enable default users	
UPDATE `users` SET `flag_active`='1' WHERE `username`='administrator';
UPDATE `users` SET `flag_active`='1' WHERE `username`='manager';
UPDATE `users` SET `flag_active`='1' WHERE `username`='user';

/*
	------------------------------------------------------------
	Eventum ID: 2450 - Consent - Create General Consent Form
	------------------------------------------------------------
*/

-- Disable consent national form
UPDATE `consent_controls` SET `flag_active`='0' WHERE `controls_type`='Consent National';

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('PedVas - Consent', 'PedVas - Consent', '');

-- Create consent control record
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('PedVas - Consent', '1', 'cd_pv_consents', 'cd_pv_consents', '1', 'PedVas Consent');

-- Create new structure and value domain for consent fields
INSERT INTO `structures` (`alias`) VALUES ('cd_pv_consents');
INSERT INTO `structure_value_domains` (`domain_name`) VALUES ('pv_consent_type');

-- Detail Table General Consent
DROP TABLE IF EXISTS `cd_pv_consents`;
CREATE TABLE `cd_pv_consents` (
  `id` INT NOT NULL ,
  `pv_consent_type` VARCHAR(50) ,
  `pv_store_material` VARCHAR(50) ,
  `pv_future_contact_study` VARCHAR(50) ,
  `pv_future_contact_other_study` VARCHAR(50) ,
  `pv_assent_status` VARCHAR(50) ,
  `pv_date_assent` VARCHAR(50) ,
  `pv_opt_leftover_research_sample` VARCHAR(50) ,
  `pv_opt_leftover_diagnostic_sample` VARCHAR(50) ,
  `pv_opt_future_contact` VARCHAR(50) ,
  `pv_opt_future_research` VARCHAR(50) ,	
  `consent_master_id` INT(11) NOT NULL ,
  `deleted` TINYINT(3) DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

DROP TABLE IF EXISTS `cd_pv_consents_revs`;
CREATE TABLE `cd_pv_consents_revs` (
  `id` INT(11) NOT NULL ,
  `pv_consent_type` VARCHAR(50) ,
  `pv_store_material` VARCHAR(50) ,
  `pv_future_contact_study` VARCHAR(50) ,
  `pv_future_contact_other_study` VARCHAR(50) ,
  `pv_assent_status` VARCHAR(50) ,
  `pv_date_assent` VARCHAR(50) ,
  `pv_opt_leftover_research_sample` VARCHAR(50) ,
  `pv_opt_leftover_diagnostic_sample` VARCHAR(50) ,
  `pv_opt_future_contact` VARCHAR(50) ,
  `pv_opt_future_research` VARCHAR(50) ,
  `version_id` INT(11) DEFAULT 0 ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

-- Add value domain for consent type
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pv_open", "pv_open");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_consent_type"), (SELECT id FROM structure_permissible_values WHERE value="pv_open" AND language_alias="pv_open"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pv_closed", "pv_closed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_consent_type"), (SELECT id FROM structure_permissible_values WHERE value="pv_closed" AND language_alias="pv_closed"), "2", "1");

-- Add fields to consent form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_consent_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pv_consent_type') , '0', '', '', '', 'pv consent type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_consent_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_consent_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv consent type' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- General Consent
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_store_material', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv store material', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_future_contact_study', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv future contact study', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_future_contact_other_study', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv future contact other study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_store_material' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv store material' AND `language_tag`=''), '2', '1', 'pv general consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_future_contact_study' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv future contact study' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_future_contact_other_study' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv future contact other study' AND `language_tag`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Optional Consent
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_opt_leftover_research_sample', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv opt leftover research sample', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_opt_leftover_diagnostic_sample', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv opt leftover diagnostic sample', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_opt_future_contact', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv opt future contact', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_opt_future_research', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv opt future research', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_opt_leftover_research_sample' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv opt leftover research sample' AND `language_tag`=''), '2', '4', 'pv optional consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_opt_leftover_diagnostic_sample' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv opt leftover diagnostic sample' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_opt_future_contact' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv opt future contact' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_opt_future_research' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv opt future research' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Assent
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_assent_status', 'input',  NULL , '0', '', '', '', 'pv assent status', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_date_assent', 'date',  NULL , '0', '', '', '', 'pv date assent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_assent_status' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv assent status' AND `language_tag`=''), '2', '8', 'pv assent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_date_assent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv date assent' AND `language_tag`=''), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('pv_open', 'Open', ''),
	('pv_closed', 'Closed', ''),
	('pv consent type', 'Consent Type', ''),
	('pv general consent', 'General Consent', ''),
	('pv store material', 'Store Material at CFRI', ''),
	('pv future contact study', 'Contact Future Followup', ''),
	('pv future contact other study', 'Contact Future Research', ''),
	('pv optional consent', 'Optional Consent', ''),
	('pv opt leftover research sample', 'Use Leftover Research Samples', ''),
	('pv opt leftover diagnostic sample', 'Use Leftover Diagnostic Samples', ''),
	('pv opt future contact', 'Contact Future Research', ''),
	('pv opt future research', 'Contact Other Research', ''),
	('pv assent status', 'Assent Status', ''),
	('pv assent', 'Assent', ''),
	('pv date assent', 'Date of Assent', '');
	
/*
	------------------------------------------------------------
	Eventum ID: 2457 - Disable unneeded clinical menus
	------------------------------------------------------------
*/

UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_10', 'clin_CAN_4', 'clin_CAN_68', 'clin_CAN_75');

/*
	------------------------------------------------------------
	Eventum ID: 2461  - Profile Customization
	------------------------------------------------------------
*/

-- Set identifer to PedVas Lab ID
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('participant identifier', 'PEDVAS Laboratory ID', '');

-- Disable unneeded fields	
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add new field for subject type
ALTER TABLE `participants` ADD COLUMN `pv_subject_type` VARCHAR(45) NULL DEFAULT NULL AFTER `participant_identifier` ;
ALTER TABLE `participants_revs` ADD COLUMN `pv_subject_type` VARCHAR(45) NULL DEFAULT NULL AFTER `participant_identifier` ;	

-- Value domain for Subject Type	
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pv_subject_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("brainworks", "pv brainworks");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_subject_type"), (SELECT id FROM structure_permissible_values WHERE value="brainworks" AND language_alias="pv brainworks"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("DCVAS", "pv DCVAS");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_subject_type"), (SELECT id FROM structure_permissible_values WHERE value="DCVAS" AND language_alias="pv DCVAS"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ARCHIVE", "pv ARCHIVE");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_subject_type"), (SELECT id FROM structure_permissible_values WHERE value="ARCHIVE" AND language_alias="pv ARCHIVE"), "3", "1");

-- Add field subject type
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'pv_subject_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pv_subject_type') , '0', '', '', 'help subject type', 'pv subject type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='pv_subject_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_subject_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help subject type' AND `language_label`='pv subject type' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('pv subject type', 'Subject Type', ''),
	('pv brainworks', 'Brainworks', ''),
	('pv DCVAS', 'DCVAS', ''),
	('pv ARCHIVE', 'ARCHIVE', '');

-- Add misc identifer for REDCAP ID	
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`) VALUES ('pedvas redcap id', '1', '1', '1', '0', '1');	
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`) VALUES ('brainworks id', '1', '2', '1', '0', '1');
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`) VALUES ('dcvas id', '1', '3', '1', '0', '1', '0');
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`) VALUES ('archive id', '1', '4', '1', '0', '1', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('pedvas redcap id', 'PedVas REDCAP ID', ''),
	('brainworks id', 'Brainworks ID', ''),
	('dcvas id', 'DCVAS ID', ''),
	('archive id', 'ARCHIVE ID', '');
	
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


/*
	------------------------------------------------------------
	Eventum ID: 2463 - Diagnosis
	------------------------------------------------------------
*/

-- Add value domain for diagnosis type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pv diagnosis type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("granulomatosis with polyangiitis (wegener’s granulomatosis)", "granulomatosis with polyangiitis (wegener’s granulomatosis)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="granulomatosis with polyangiitis (wegener’s granulomatosis)" AND language_alias="granulomatosis with polyangiitis (wegener’s granulomatosis)"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("limited granulomatosis with polyangiitis (limited wegener’s granulomatosis)", "limited granulomatosis with polyangiitis (limited wegener’s granulomatosis)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="limited granulomatosis with polyangiitis (limited wegener’s granulomatosis)" AND language_alias="limited granulomatosis with polyangiitis (limited wegener’s granulomatosis)"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("microscopic polyangiitis", "microscopic polyangiitis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="microscopic polyangiitis" AND language_alias="microscopic polyangiitis"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("microscopic polyangiitis with isolated renal involvement", "microscopic polyangiitis with isolated renal involvement");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="microscopic polyangiitis with isolated renal involvement" AND language_alias="microscopic polyangiitis with isolated renal involvement"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("eosinophilic granulomatosis with polyangiitis (churg-strauss syndrome)", "eosinophilic granulomatosis with polyangiitis (churg-strauss syndrome)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="eosinophilic granulomatosis with polyangiitis (churg-strauss syndrome)" AND language_alias="eosinophilic granulomatosis with polyangiitis (churg-strauss syndrome)"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("anca positive pauci-immune glomerulonephritis", "anca positive pauci-immune glomerulonephritis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="anca positive pauci-immune glomerulonephritis" AND language_alias="anca positive pauci-immune glomerulonephritis"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("polyarteritis nodosa", "polyarteritis nodosa");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="polyarteritis nodosa" AND language_alias="polyarteritis nodosa"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cutaneous polyarteritis nodosa", "cutaneous polyarteritis nodosa");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="cutaneous polyarteritis nodosa" AND language_alias="cutaneous polyarteritis nodosa"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("takayasu’s arteritis", "takayasu’s arteritis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="takayasu’s arteritis" AND language_alias="takayasu’s arteritis"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("unclassified primary vasculitis", "unclassified primary vasculitis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="unclassified primary vasculitis" AND language_alias="unclassified primary vasculitis"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("primary cns vasculitis - medium/large vessel", "primary cns vasculitis - medium/large vessel");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="primary cns vasculitis - medium/large vessel" AND language_alias="primary cns vasculitis - medium/large vessel"), "11", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("primary cns vasculitis - small vessel", "primary cns vasculitis - small vessel");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="primary cns vasculitis - small vessel" AND language_alias="primary cns vasculitis - small vessel"), "12", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('granulomatosis with polyangiitis (wegener’s granulomatosis)', 'Granulomatosis with polyangiitis (Wegener’s granulomatosis)', ''),
	('limited granulomatosis with polyangiitis (limited wegener’s granulomatosis)', 'Limited granulomatosis with polyangiitis (Limited Wegener’s granulomatosis)', ''),
	('microscopic polyangiitis', 'Microscopic polyangiitis', ''),
	('microscopic polyangiitis with isolated renal involvement', 'Microscopic polyangiitis with isolated renal involvement', ''),
	('eosinophilic granulomatosis with polyangiitis (churg-strauss syndrome)', 'Eosinophilic granulomatosis with polyangiitis (Churg-Strauss syndrome)', ''),
	('anca positive pauci-immune glomerulonephritis', 'ANCA positive pauci-immune glomerulonephritis', ''),
	('polyarteritis nodosa', 'Polyarteritis nodosa', ''),
	('cutaneous polyarteritis nodosa', 'Cutaneous polyarteritis nodosa', ''),
	('takayasu’s arteritis', 'Takayasu’s arteritis', ''),
	('unclassified primary vasculitis', 'Unclassified primary vasculitis', ''),
	('primary cns vasculitis - medium/large vessel', 'Primary CNS vasculitis - medium/large vessel', ''),
	('primary cns vasculitis - small vessel', 'Primary CNS vasculitis - small vessel', '');

/*
	------------------------------------------------------------
	Eventum ID: 2464 - Disable samples types
	------------------------------------------------------------
*/
    
-- Disable sample types 
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 23, 136, 25, 3, 24, 4, 5, 142, 143, 141, 144, 139, 11, 10);

/*
	------------------------------------------------------------
	Eventum ID: 2465 - Collection Customization
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('acquisition_label', 'PedVas Barcode', ''),
	('pv visit', 'Visit', ''),
	('pv date shipment', 'Shipment Date', ''),
	('pv time of diagnosis', 'Time of Diagnosis', ''),
	('pv 3-6 month visit', '3-6 Month Visit', ''),
	('pv 12 month visit', '12 Month Visit', ''),
	('pv disease flare', 'Disease Flare', ''),
	('pv flare follow-up', 'Flare Follow-up', '');

-- Add new fields visit and date of shipment	
ALTER TABLE `collections` 
	ADD COLUMN `pv_visit` VARCHAR(45) NULL DEFAULT NULL AFTER `collection_notes` ,
	ADD COLUMN `pv_date_shipment` DATE NULL AFTER `pv_visit` ;
	
ALTER TABLE `collections_revs` 
	ADD COLUMN `pv_visit` VARCHAR(45) NULL DEFAULT NULL AFTER `collection_notes` ,
	ADD COLUMN `pv_date_shipment` DATE NULL AFTER `pv_visit` ;

-- Value domain for visit
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pv_visit", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("time of diagnosis", "pv time of diagnosis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_visit"), (SELECT id FROM structure_permissible_values WHERE value="time of diagnosis" AND language_alias="pv time of diagnosis"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("3-6 month visit", "pv 3-6 month visit");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_visit"), (SELECT id FROM structure_permissible_values WHERE value="3-6 month visit" AND language_alias="pv 3-6 month visit"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("12 month visit", "pv 12 month visit");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_visit"), (SELECT id FROM structure_permissible_values WHERE value="12 month visit" AND language_alias="pv 12 month visit"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("disease flare", "pv disease flare");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_visit"), (SELECT id FROM structure_permissible_values WHERE value="disease flare" AND language_alias="pv disease flare"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("flare follow-up", "pv flare follow-up");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_visit"), (SELECT id FROM structure_permissible_values WHERE value="flare follow-up" AND language_alias="pv flare follow-up"), "5", "1");


-- Date of shipment	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'pv_date_shipment', 'date',  NULL , '0', '', '', '', 'pv date shipment', ''), 
('InventoryManagement', 'Collection', 'collections', 'pv_visit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pv_visit') , '0', '', '', '', 'pv visit', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='pv_date_shipment' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv date shipment' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='pv_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv visit' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
