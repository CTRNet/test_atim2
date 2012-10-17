-- CCBR Customization Script
-- Version: v0.92
-- ATiM Version: v2.5.1
-- Notes: Must be run against ATiM v2.5.1 with all previous CCBR upgrades applied


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
	
	