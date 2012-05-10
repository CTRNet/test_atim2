-- CCBR Customization Script
-- Version: v0.9
-- ATiM Version: v2.4.3A
-- Notes: Before running this script run custom_post_243a.sql

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.9 (RC1)', '');

-- Add new lookup value to DiagnosisMaster.InformationSource and TreatmentMaster.InformationSource
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr eve', 'EVE', '');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES ('eve', 'ccbr eve');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((select id from structure_value_domains where domain_name = 'information_source'), (SELECT id FROM structure_permissible_values where value = 'eve' and language_alias = 'ccbr eve'), 5, 1, 1);

-- Fix validation for PHN number
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr PHN validation error', 'PHN must have the format: DDDD DDD DDD', '');
