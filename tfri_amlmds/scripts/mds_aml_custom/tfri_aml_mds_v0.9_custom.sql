-- TFRI AML/MDS Custom Script
-- Version: v0.9
-- ATiM Version: v2.6.0

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS/AML Biobank v0.9 DEV', '');