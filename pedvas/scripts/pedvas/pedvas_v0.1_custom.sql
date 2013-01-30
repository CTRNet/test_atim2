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
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_consent_type', 'select',  (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'pv_consent_type') , '0', '', '', 'pv help consent type', 'pv consent type', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_consent_type' AND `type`='select' AND `language_help`='pv help consent type' AND `language_label`='pv consent type'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


/*
	------------------------------------------------------------
	Eventum ID: 2457 - Disable unneeded clinical menus
	------------------------------------------------------------
*/

UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_10', 'clin_CAN_4', 'clin_CAN_68', 'clin_CAN_75');

