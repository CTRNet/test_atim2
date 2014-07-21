-- TFRI AML/MDS Custom Script
-- Version: v0.10
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS/AML Biobank v0.10 DEV', '');
	
	