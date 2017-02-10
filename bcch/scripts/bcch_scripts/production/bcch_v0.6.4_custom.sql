-- BCCH Customization Script
-- Version 0.6.4
-- ATiM Version: 2.6.7

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.6.4", '');

-- ============================================================================
-- BB-231
-- ============================================================================

INSERT INTO misc_identifier_controls
(`misc_identifier_name`, `flag_active`, `display_order`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('POG ID', 1, 16, NULL, 1, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('POG ID', 'POG ID', 'POG ID');