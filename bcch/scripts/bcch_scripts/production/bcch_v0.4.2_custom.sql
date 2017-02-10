-- BCCH Customization Script
-- Version 0.4.1
-- ATiM Version: 2.6.5

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.4.2", '');
