-- PedVas Custom Script
-- Version: v0.4
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.
-- NOTE: PedVas wished to keep data entered on the development site. Be sure to run this update on that version!


-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'PedVas - v0.4 DEV', '');

