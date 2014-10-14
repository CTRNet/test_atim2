-- BCCH Customization Script
-- Version: v0.1
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.1", '');
	
--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2791 - Diagnosis form - New bone marrow fields
--	--------------------------------------------------------------------------