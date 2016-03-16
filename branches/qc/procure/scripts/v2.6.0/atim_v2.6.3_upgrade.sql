-- ------------------------------------------------------
-- ATiM v2.6.3 Upgrade Script
-- version: 2.6.3.1
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add correction on getCustomDropdown call defined into structure_value_domains
-- -----------------------------------------------------------------------------------------------------------------------------------
UPDATE structure_value_domains
SET 
	`source` = "StructurePermissibleValuesCustom::getCustomDropdown('orders contacts')" 
	WHERE domain_name = 'orders_contact' 
		AND `source` like '%orders_contact%';
		
UPDATE structure_value_domains 
SET 
	`source` = "StructurePermissibleValuesCustom::getCustomDropdown('orders institutions')" 
	WHERE domain_name = 'orders_institution' 
		AND `source` like '%orders_institution%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO versions (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.3', NOW(),'5798','n/a');