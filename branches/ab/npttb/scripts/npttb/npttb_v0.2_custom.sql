-- NPTTB Custom Script
-- Version: v0.2
-- ATiM Version: v2.4.3A

-- This script must be run against a v2.4.3A ATiM database with the previous dev script applied (v0.1)

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.2 DEV', '');

/*
	------------------------------------------------------------
	Eventum ID: 2282 - Misc Identifier - Medical Record Number
	------------------------------------------------------------
*/

-- Create new control value for MRN number

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('Medical Record Number', 'Medical Record Number', ''),
	('TTB Number', 'TTB Number', ''),
	('npbttb MRN validation error', 'Medical Record Number invalid. Must be 11 or 12 digits.', '');

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`) VALUES ('Medical Record Number', 1, 3, 1, 0);



