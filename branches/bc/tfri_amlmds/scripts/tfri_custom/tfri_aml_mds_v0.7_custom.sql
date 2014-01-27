-- TFRI AML/MDS Custom Script
-- Version: v0.7
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS-AML v0.7 DEV', '');
	
	