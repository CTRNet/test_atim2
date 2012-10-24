-- NPTTB Custom Script
-- Version: v0.3
-- ATiM Version: v2.4.3A

-- This script must be run against a v2.4.3A ATiM database with the previous dev script applied (v0.2)

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.3 DEV', '');


/*
	------------------------------------------------------------
	Eventum ID: 2331 - Diagnosis -> Add preliminary
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb preliminary dx', 'Preliminary Diagnosis', ''),
	('npttb help preliminary', '', '');

ALTER TABLE `dxd_npttb_tissue` 
	ADD COLUMN `npttb_preliminary_dx` VARCHAR(100) NULL DEFAULT NULL AFTER `npttb_path_final_dx` ;
	
ALTER TABLE `dxd_npttb_tissue_revs` 
	ADD COLUMN `npttb_preliminary_dx` VARCHAR(100) NULL DEFAULT NULL AFTER `npttb_path_final_dx` ;
	
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'dxd_npttb_tissue', 'npttb_preliminary_dx', 'input',  NULL , '0', 'size=50', '', 'npttb help preliminary', 'npttb preliminary dx', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_npttb_tissue'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_preliminary_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='npttb help preliminary' AND `language_label`='npttb preliminary dx' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

/*
	------------------------------------------------------------
	Eventum ID: 2246 - Surgery Path Number Validation
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb error surgery path number', 'Validation error - Pathology Number must be AA DD-DDDD', '');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `tablename` = 'txd_surgeries' AND `field` = 'path_num'), "/^\\A\\w{2}\\s{1}\\d{2}(-)\\d{5}$^/", 'npttb error surgery path number');


/*
	Add age field for data migration from npttb spreadsheet
*/

ALTER TABLE `participants` ADD COLUMN `npttb_age` INT NULL  AFTER `last_chart_checked_date_accuracy` ;

ALTER TABLE `cd_npttb_consent_baker_v2` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_npttb_consent_baker_v3` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_npttb_consent_brain_bank` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;

/*
	Fix custom consent values for person consenting
*/

UPDATE `structure_permissible_values_customs` SET `value`='ruxandra petcu', `en`='Ruxandra Petcu'
WHERE `value`='ruxandra';

UPDATE `structure_permissible_values_customs` SET `value`='sherri lang', `en`='Sherri Lang'
WHERE `value`='sherri';

UPDATE `structure_permissible_values_customs` SET `value`='jane rigel', `en`='Jane Rigel'
WHERE `value`='jane';

UPDATE `structure_permissible_values_customs` SET `value`='errin st thomas', `en`='Errin St. Thomas'
WHERE `value`='errin';

/*
	New custom consent values for person consenting
*/

INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `display_order`, `use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr forsyth', 'Dr. Forsyth', 22, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr cairncross', 'Dr. Cairncross', 22, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'ds', 'DS', 22, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'ra', 'RA', 22, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'mary', 'Mary', 22, 0);




