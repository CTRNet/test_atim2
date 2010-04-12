-- Version: v2.0.2
-- Description: This SQL script is an upgrade for ATiM v2.0.1. to 2.0.2. and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.2', `date_installed` = '2010-04-12', `build_number` = ''
WHERE `versions`.`id` =1;

-- Drop all old pathology review related tables. Pathology review being added in v2.1
DROP TABLE
	`rd_bloodcellcounts`,
	`rd_bloodcellcounts_revs`,
	`rd_blood_cells`,
	`rd_blood_cells_revs`,
	`rd_breastcancertypes`,
	`rd_breastcancertypes_revs`,
	`rd_breast_cancers`,
	`rd_breast_cancers_revs`,
	`rd_coloncancertypes`,
	`rd_coloncancertypes_revs`,
	`rd_genericcancertypes`,
	`rd_genericcancertypes_revs`,
	`rd_ovarianuteruscancertypes`,
	`rd_ovarianuteruscancertypes_revs`,
	`review_controls`,
	`review_masters`,
	`review_masters_revs`;
	
-- Delete all structures without associated fields
DELETE FROM `structures` WHERE id NOT IN
(
	SELECT structure_id
	FROM structure_formats
);

-- Eventum 848
DELETE FROM i18n WHERE id IN ('1', '2', '3', '4', '5');