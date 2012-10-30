-- CCBR Customization Script
-- Version: v0.92
-- ATiM Version: v2.5.1
-- Notes: Must be run against ATiM v2.5.1 with all previous CCBR upgrades applied

-- Update bank version number
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.92', '');

-- Fix spelling of Karyotype
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr karotype', 'Karyotype', '');	

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('karotype', 'Karyotype', '');	

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2405 - Lab -> CBC and Bone Marrow fix Cellularity Label
	---------------------------------------------------------------------------
*/

UPDATE `i18n` SET `en`='Cellularity Value (Percent)' WHERE `id`='ccbr bone marrow cellularity value' ;
UPDATE `i18n` SET `en`='Percent Blast Cells' WHERE `id`='ccbr percent blast cells' ;

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2407 - CBC and Bone Marrow - Verify all decimal validations
	---------------------------------------------------------------------------
*/

ALTER TABLE 
	`ed_ccbr_lab_cbc_bone_marrows`
CHANGE COLUMN
	`ccbr_bone_marrow_cellularity_value` `ccbr_bone_marrow_cellularity_value` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN 
	`ccbr_percent_blast_cells` `ccbr_percent_blast_cells` INT(11) NULL DEFAULT NULL  ;

-- Change from FLOAT datatype to DECIMAL with two decimal places of precision	
ALTER TABLE 
	`ed_ccbr_lab_cbc_bone_marrows` 
CHANGE COLUMN `ccbr_wbc_count` `ccbr_wbc_count` DECIMAL(10,2) NULL DEFAULT NULL ,
CHANGE COLUMN `ccbr_hemoglobin` `ccbr_hemoglobin` DECIMAL(10,2) NULL DEFAULT NULL ,
CHANGE COLUMN `ccbr_platelet_count` `ccbr_platelet_count` DECIMAL(10,2) NULL DEFAULT NULL , 
CHANGE COLUMN `ccbr_ldh_level` `ccbr_ldh_level` DECIMAL(10,2) NULL DEFAULT NULL , 
CHANGE COLUMN `ccbr_neutrophil_count` `ccbr_neutrophil_count` DECIMAL(10,2) NULL DEFAULT NULL  ;


-- Set percent fields to integer type
UPDATE structure_fields SET  `type`='integer' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_percent_blast_cells' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='integer' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_bone_marrow_cellularity_value' AND `type`='float' AND structure_value_domain  IS NULL ;

-- Add range validation for percentage fields
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_percent_blast_cells' AND `type`='integer' AND structure_value_domain  IS NULL) , 'range,-1,101', 'ccbr percent must be between 0-100');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_bone_marrow_cellularity_value' AND `type`='integer' AND structure_value_domain  IS NULL), 'range,-1,101', 'ccbr percent must be between 0-100');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr percent must be between 0-100', 'Percent values must be an integer value between 0-100', '');
	
/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2415 - Consent - Add field (Use of DNA)
	---------------------------------------------------------------------------
*/

-- Add field to detail and rev table
ALTER TABLE `cd_ccbr_consents` ADD COLUMN `ccbr_consent_dna` VARCHAR(45) NULL DEFAULT NULL  AFTER `ccbr_consent_blood_donation` ;
ALTER TABLE `cd_ccbr_consents_revs` ADD COLUMN `ccbr_consent_dna` VARCHAR(45) NULL DEFAULT NULL  AFTER `ccbr_consent_blood_donation` ;

-- Add new structure field and link to form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_dna', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent dna', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_dna' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent dna' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr consent dna', 'Consent to left over DNA', '');	
