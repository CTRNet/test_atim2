-- CCBR Customization Script
-- Version: v0.8
-- ATiM Version: v2.4.3A

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.8 (RC1)', '');
	
-- Set sample code to user input instead of readonly. Custom hook to override automatic setting of code.

UPDATE structure_formats SET `flag_add`='1', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Fix error message for participant identifier
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr error participant identifier', 'Participant identifier must begin with CCBR and is followed by digits only', '');
