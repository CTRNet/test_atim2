-- PedVas Custom Script
-- Version: v0.3
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.
-- NOTE: PedVas wished to keep data entered on the development site. Be sure to run this update on that version!


-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'PedVas - v0.3 DEV', '');
	

/*
	------------------------------------------------------------
	Eventum ID: 2661 - New Identifier (UKVAS)	
	------------------------------------------------------------
*/

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_unique`, `pad_to_length`) VALUES ('ukvas id', '1', '5', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ukvas id', 'UKVAS ID', '');

/*
	------------------------------------------------------------
	Eventum ID: 2662 - Combine Identifiers
	------------------------------------------------------------
*/

UPDATE `misc_identifier_controls` SET `misc_identifier_name`='pedvas/archive id' WHERE `misc_identifier_name`='archive id';

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pedvas/archive id', 'PedVas/ARCHIVE ID', '');
	
DELETE FROM `misc_identifier_controls` WHERE `id`='1';


/*
	------------------------------------------------------------
	Eventum ID: 2655 - Enable treatment menus
	------------------------------------------------------------
*/

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_75', 'clin_CAN_80');


/*
	------------------------------------------------------------
	Eventum ID: 2651 - Consent - Date of Verbal Consent
	------------------------------------------------------------
*/

ALTER TABLE `cd_pv_consents` 
ADD COLUMN `pv_date_verbal_consent` DATE NULL DEFAULT NULL AFTER `pv_consent_type`;

ALTER TABLE `cd_pv_consents_revs` 
ADD COLUMN `pv_date_verbal_consent` DATE NULL DEFAULT NULL AFTER `pv_consent_type`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_date_verbal_consent', 'date',  NULL , '0', '', '', '', 'pv date verbal consent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_date_verbal_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv date verbal consent' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv date verbal consent', 'Date of Verbal Consent', '');


/*
	------------------------------------------------------------
	Eventum ID: 2499 - Profile - Year of Birth validation
	------------------------------------------------------------
*/

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `field` = 'pv_birth_year'), 'range,1850,2100', 'pv enter 4 digit year value between 1850 and 2100');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv enter 4 digit year value between 1850 and 2100', 'Enter 4 digit year value between 1850 and 2100', '');


/*
	------------------------------------------------------------
	Eventum ID: 2649 - Collection Bank - Values
	------------------------------------------------------------
*/

UPDATE `banks` SET `name`='PedVas', `description`='', `created_by`='1' WHERE `id`='1';
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('General Rheumatology', '1', '2013-09-23 00:00:00');
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('PREVENT JIA', '1', '2013-09-23 00:00:00');
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('PARC', '1', '2013-09-23 00:00:00');
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('Other', '1', '2013-09-23 00:00:00');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');


/*
	------------------------------------------------------------
	Eventum ID: 2648 - Add field clinic visit
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv visit', 'Clinic Visit', '');


