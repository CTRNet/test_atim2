-- NPTTB Custom Script
-- Version: v0.7
-- ATiM Version: v2.5.2

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.7 DEV', '');


/*
	------------------------------------------------------------
	Eventum ID: 2719 - Diagnosis - TTB Diagnosis 
	------------------------------------------------------------
*/

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Gliosarcoma", "npttb Gliosarcoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Gliosarcoma" AND language_alias="npttb Gliosarcoma"), "28", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('npttb Gliosarcoma', 'Gliosarcoma', '');
	
/*
	------------------------------------------------------------
	Eventum ID: 2726 - Invalid last modification datetime
	------------------------------------------------------------
*/
	
UPDATE participants
SET `last_modification` = NOW();


/*
	------------------------------------------------------------
	Eventum ID: 2727 - TTB number is not unique
	------------------------------------------------------------
*/

UPDATE `misc_identifier_controls` SET `flag_once_per_participant`='0', `flag_unique`='0', `reg_exp_validation`='\\A\\d{3,4}$', `user_readable_format`='three or four digits' WHERE `misc_identifier_name`='TTB Number (Pre-2010)';


/*
	------------------------------------------------------------
	Eventum ID: 2724 - ACB identifier not working (ACB-C244338)
	------------------------------------------------------------
*/

UPDATE `misc_identifier_controls` SET `reg_exp_validation`='\\A(ACB-C)\\d{6}$', `user_readable_format`='ACB-C followed by 6 digits' WHERE `misc_identifier_name`='ACB Number';


/*
	------------------------------------------------------------
	Eventum ID: 2725 - Recurrent diagnosis, add final path field
	------------------------------------------------------------
*/

ALTER TABLE `dxd_recurrences` 
ADD COLUMN `npttb_final_path` VARCHAR(255) NULL DEFAULT NULL AFTER `diagnosis_master_id`;

ALTER TABLE `dxd_recurrences_revs` 
ADD COLUMN `npttb_final_path` VARCHAR(255) NULL DEFAULT NULL AFTER `diagnosis_master_id`;

INSERT INTO structures(`alias`) VALUES ('dx_recurrence');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'npttb_final_path', 'input',  NULL , '0', 'size=30', '', '', 'npttb final path', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='npttb_final_path' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='npttb final path' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('npttb final path', 'Final Path Report', '');
