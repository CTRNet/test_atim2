-- CCBR Customization Script
-- Version: v0.94
-- ATiM Version: v2.5.1
-- Notes: Run against an upgraded v2.5.1 CCBR installation. Minor patch to change layout of sample/aliquot forms

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.94', '');
	
--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2506 - Update Blood Aliquot Form
--	--------------------------------------------------------------------------