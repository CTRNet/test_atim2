-- CCBR Customization Script
-- Version: v0.91
-- ATiM Version: v2.5.1
-- Notes: Must be run against ATiM v2.5.1 with all previous CCBR upgrades applied

-- Fix FK name for extended radiation tables
ALTER TABLE `txe_radiations` 
DROP FOREIGN KEY `FK_txe_radiations_tx_masters`;

ALTER TABLE `txe_radiations` 
CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL, 
ADD CONSTRAINT `FK_txe_radiations_tx_masters`
FOREIGN KEY (`treatment_master_id`)
REFERENCES `treatment_masters` (`id`);
  
ALTER TABLE `txe_radiations_revs` 
CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL;  


/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2396 - Consent - Multiple notes fields
	---------------------------------------------------------------------------
*/

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-18' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_notes' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2397 - Radiation Form - Fix layout
	---------------------------------------------------------------------------
*/

UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='ccbr_rad_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_treatment_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='ccbr_rad_total_dose' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_treatment_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='ccbr_rad_site_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');