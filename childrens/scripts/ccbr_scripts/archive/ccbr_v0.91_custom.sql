-- CCBR Customization Script
-- Version: v0.91
-- ATiM Version: v2.5.1
-- Notes: Must be run against ATiM v2.5.1 with all previous CCBR upgrades applied

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.91', '');

-- Fix FK name for extended radiation table
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

UPDATE structure_fields SET  `language_label`='',  `language_tag`='ccbr rad site other' WHERE model='TreatmentDetail' AND tablename='txd_radiations' AND field='ccbr_rad_site_other' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `setting`='size=30' WHERE model='TreatmentDetail' AND tablename='txd_radiations' AND field='ccbr_rad_site_other' AND `type`='input' AND structure_value_domain  IS NULL ;

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2400 - Sample Type - Expanded Cells
	---------------------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr expanded cells', 'Expanded Cells', '');

-- Add new type to controls table
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('ccbr expanded cells', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_ccbr_expanded_cells', 0, 'expanded cells');

-- Blood -> Expanded Cells
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'blood' AND `sample_category` = 'specimen'), (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr expanded cells' AND `sample_category` = 'derivative'), 1);

-- Bone Marrow -> Expanded Cells
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'bone marrow' AND `sample_category` = 'specimen'), (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr expanded cells' AND `sample_category` = 'derivative'), 1);

-- Create new aliquot tube for Expanded Cells
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
 ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr expanded cells' AND `sample_category` = 'derivative'), 'tube', '', 'ad_ccbr_spec_tubes_incl_cell_count', 'ad_tubes', 'ml', 1, 'Derivative tube requiring cell count for CCBR', 0, 'tube');

-- Detail table creation
DROP TABLE IF EXISTS `sd_der_ccbr_expanded_cells`;
CREATE TABLE `sd_der_ccbr_expanded_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `deleted` TINYINT(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `sd_der_ccbr_expanded_cells_revs`;
CREATE TABLE `sd_der_ccbr_expanded_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2401 - Unique Sample Code - Error Message
	---------------------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr sample code must be unique', 'Sample code must be unique', '');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT `id` FROM `structure_fields` WHERE `tablename` = 'sample_masters' AND `field` = 'sample_code'), 'isUnique', 'ccbr sample code must be unique');