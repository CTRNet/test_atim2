-- CCBR Customization Script
-- Version: v0.92
-- ATiM Version: v2.5.1
-- Notes: Must be run against ATiM v2.5.1 with all previous CCBR upgrades applied

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





