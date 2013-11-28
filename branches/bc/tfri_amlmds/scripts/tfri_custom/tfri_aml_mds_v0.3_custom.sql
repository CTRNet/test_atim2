-- TFRI AML/MDS Custom Script
-- Version: v0.2
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI AML-MDS v0.3 DEV', '');

/*
	Eventum Issue: #2789 - Vital Status - Default to Alive
*/
	
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='health_status') ,  `default`='alive' WHERE model='Participant' AND tablename='participants' AND field='vital_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='health_status');

/*
	Eventum Issue: #2777 - Profile - Screening number validation
*/

-- Change field from INT to VARCHAR. Screening contains alphabetic characters
ALTER TABLE `participants` 
CHANGE COLUMN `tfri_aml_screening_code` `tfri_aml_screening_code` VARCHAR(50) NULL DEFAULT NULL ;

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT `id` FROM `structure_fields` WHERE `field` = 'tfri_aml_screening_code'), 'custom,/^\\A\\d{4}\\[A-F]$/', 'tfri_aml screening number validation error');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri_aml screening number validation error', 'Screening number must be 4 digits then an upper case site letter', '');


