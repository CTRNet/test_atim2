-- CCBR Customization Script
-- Version: v0.7
-- ATiM Version: v2.4.1

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.7 DEV', '');


-- =============================================================================== -- 
-- 								TREATMENT
-- =============================================================================== --

-- Set % blasts fields to decimals
ALTER TABLE `txd_chemos` CHANGE COLUMN `ccbr_day8_percent_blasts` `ccbr_day8_percent_blasts` DECIMAL(10,3) NULL DEFAULT NULL  , CHANGE COLUMN `ccbr_day8_mrd` `ccbr_day8_mrd` DECIMAL(10,3) NULL DEFAULT NULL  , CHANGE COLUMN `ccbr_day15_percent_blasts` `ccbr_day15_percent_blasts` DECIMAL(10,3) NULL DEFAULT NULL  , CHANGE COLUMN `ccbr_day15_mrd` `ccbr_day15_mrd` DECIMAL(10,3) NULL DEFAULT NULL  , CHANGE COLUMN `ccbr_day29_percent_blasts` `ccbr_day29_percent_blasts` DECIMAL(10,3) NULL DEFAULT NULL  , CHANGE COLUMN `ccbr_day29_mrd` `ccbr_day29_mrd` DECIMAL(10,3) NULL DEFAULT NULL  , CHANGE COLUMN `ccbr_other_percent_blasts` `ccbr_other_percent_blasts` DECIMAL(10,3) NULL DEFAULT NULL  , CHANGE COLUMN `ccbr_other_mrd` `ccbr_other_mrd` DECIMAL(10,3) NULL DEFAULT NULL  ;

-- =============================================================================== -- 
-- 								ANNOTATION
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('chemo response', 'Chemo Response', '');

-- Create new LAB form for Chemo response information
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('ccbr', 'lab', 'chemo response', 1, 'eventmasters,ed_ccbr_lab_chemo_responses', 'ed_ccbr_lab_chemo_responses', 0, 'lab|ccbr|chemo responses');

INSERT INTO `structures` (`alias`) VALUES ('ed_ccbr_lab_chemo_responses');

-- Create detail/rev table
DROP TABLE IF EXISTS `ed_ccbr_lab_chemo_responses`;

CREATE TABLE `ed_ccbr_lab_chemo_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ccbr_day8_bone_marrow_date` date DEFAULT NULL,
  `ccbr_day8_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day8_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day8_source` varchar(45) DEFAULT NULL,
  `ccbr_day15_bone_marrow_date` date DEFAULT NULL,
  `ccbr_day15_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day15_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day15_source` varchar(45) DEFAULT NULL,
  `ccbr_day29_bone_marrow_date` date DEFAULT NULL,
  `ccbr_day29_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day29_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day29_source` varchar(45) DEFAULT NULL,
  `ccbr_other_bone_marrow_date` date DEFAULT NULL,
  `ccbr_other_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_other_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_other_source` varchar(45) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `ed_ccbr_lab_chemo_responses_revs`;

CREATE TABLE `ed_ccbr_lab_chemo_responses_revs` (
  `id` int(11) NOT NULL,
  `ccbr_day8_bone_marrow_date` date DEFAULT NULL,
  `ccbr_day8_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day8_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day8_source` varchar(45) DEFAULT NULL,
  `ccbr_day15_bone_marrow_date` date DEFAULT NULL,
  `ccbr_day15_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day15_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day15_source` varchar(45) DEFAULT NULL,
  `ccbr_day29_bone_marrow_date` date DEFAULT NULL,
  `ccbr_day29_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day29_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_day29_source` varchar(45) DEFAULT NULL,
  `ccbr_other_bone_marrow_date` date DEFAULT NULL,
  `ccbr_other_percent_blasts` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_other_mrd` DECIMAL(5,3) DEFAULT NULL,
  `ccbr_other_source` varchar(45) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Change fields from chemo treatment detail -> lab chemo response form
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day8_bone_marrow_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day8_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day8_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day15_bone_marrow_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day15_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day15_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day29_bone_marrow_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day29_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day29_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_other_bone_marrow_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_other_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses' WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_other_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day15_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source');
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day8_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source');
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_day29_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source');
UPDATE structure_fields SET  `model`='EventDetail',  `tablename`='ed_ccbr_lab_chemo_responses',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='ccbr_other_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source');

UPDATE `structure_formats` SET `structure_id` = (SELECT `id` FROM `structures` WHERE `alias` = 'ed_ccbr_lab_chemo_responses') WHERE `structure_id` = (SELECT `id` FROM `structures` WHERE `alias` = 'txd_chemos') AND `structure_field_id` IN (SELECT id FROM structure_fields where tablename = 'ed_ccbr_lab_chemo_responses');


-- Move all fields to column one
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day8_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day8_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day8_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day15_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day15_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day15_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day29_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day29_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day29_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_other_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_other_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_other_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day15_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day8_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_day29_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_chemo_responses' AND `field`='ccbr_other_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') AND `flag_confidential`='0');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_chemo_responses'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain` IS NULL), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Change field type to floats from integer
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_day8_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_day8_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_day15_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_day15_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_day29_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_day29_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_other_percent_blasts' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_chemo_responses' AND field='ccbr_other_mrd' AND `type`='integer' AND structure_value_domain  IS NULL ;


-- =============================================================================== -- 
-- 								CONSENT 
-- =============================================================================== --

-- Fixed flags for detail form fields
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_date_formal_consent' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_formal_consent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_person_formal_consent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_person_consenting') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_assent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_assent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_date_withdrawal' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Set default for tranlsator used to 'No'
UPDATE structure_formats SET `flag_override_default`='1', `default`='n' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_indicator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- =============================================================================== -- 
-- 								STORAGE
-- =============================================================================== --

/*
	Storage Description:
		- Each Nitogen Tank has 4 quarters
		- Each quarter can hold 3 canes
		- Each cane can hold 15 boxes
		- Each box has 100 positions, numbered 1 - 100 numerically. The box is 10x10 so
		  first row is 1-10 and second row is 11-20 going left to right.
		- Example: A vial might be in position Q4C1B1P6
*/ 

-- Storage Language Updates
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('ccbr box100', 'Box 100', ''),
	('ccbr cane', 'Cane', ''),
	('ccbr quarter', 'Quarter', ''),
	('ccbr nitrogen tank', 'Nitrogen Tank', '');

-- Disable storage entities not used
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='room';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='cupboard';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='nitrogen locator';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='incubator';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='fridge';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='freezer';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='box';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='box81 1A-9I';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='box81';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='rack16';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='rack10';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='rack24';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='shelf';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='rack11';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='rack9';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='box25';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='box100 1A-20E';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='TMA-blc 23X15';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `storage_type`='TMA-blc 29X21';

-- Add new storage types
INSERT INTO `storage_controls` (
    `id`,
    `storage_type`,
    `coord_x_title`,
    `coord_x_type`,
    `coord_x_size`,
    `coord_y_title`,
    `coord_y_type`,
    `coord_y_size`,
    `display_x_size`,
    `display_y_size`,
    `reverse_x_numbering`,
    `reverse_y_numbering`,
    `horizontal_increment`,
    `set_temperature`,
    `is_tma_block`,
    `flag_active`,
    `form_alias`,
    `detail_tablename`,
    `databrowser_label`,
    `check_conflicts`) VALUES
(null, 'ccbr box100', 'position', 'integer', 100, NULL, NULL, NULL, 10, 10, 0, 0, 1, 0, 0, 1, 'storagemasters', 'std_boxs', 'box100', 1),
(null, 'ccbr cane', 'position', 'integer', 15, NULL, NULL, NULL, 1, 15, 0, 0, 1, 0, 0, 1, 'storagemasters', 'std_racks', 'rack15', 1),
(null, 'ccbr quarter', 'position', 'integer', 3, NULL, NULL, NULL, 1, 3, 0, 0, 1, 0, 0, 1, 'storagemasters', 'std_shelfs', 'quarter', 1),
(null, 'ccbr nitrogen tank', 'position', 'integer', 4, NULL, NULL, NULL, 1, 4, 0, 0, 1, 1, 0, 1, 'storagemasters,storage_temperature', 'std_nitro_locates', 'nitrogen tank', 1);

-- Populate Storage Tables

INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(1,'1',24,NULL,1,100,NULL,'N','N','','','',-80.00,'celsius','','2012-03-07 12:52:04',1,'2012-03-07 12:52:04',1,0),
(2,'2',23,1,2,99,NULL,'Q4','NQ4','','4','',-80.00,'celsius','','2012-03-07 12:53:04',1,'2012-03-07 12:53:04',1,0),
(3,'3',22,2,3,34,NULL,'C1','NQ4C1','','1','',-80.00,'celsius','','2012-03-07 12:53:17',1,'2012-03-07 12:53:17',1,0),
(4,'4',22,2,35,66,NULL,'C2','NQ4C2','','2','',-80.00,'celsius','','2012-03-07 12:53:29',1,'2012-03-07 12:53:29',1,0),
(5,'5',22,2,67,98,NULL,'C3','NQ4C3','','3','',-80.00,'celsius','','2012-03-07 12:53:42',1,'2012-03-07 12:53:42',1,0),
(6,'6',21,3,4,5,NULL,'B1','NQ4C1B1','','1','',-80.00,'celsius','','2012-03-07 12:55:41',1,'2012-03-07 12:55:41',1,0),
(7,'7',21,3,6,7,NULL,'B2','NQ4C1B2','','2','',-80.00,'celsius','','2012-03-07 12:55:57',1,'2012-03-07 12:55:57',1,0),
(8,'8',21,3,8,9,NULL,'B3','NQ4C1B3','','3','',-80.00,'celsius','','2012-03-07 12:56:37',1,'2012-03-07 12:56:37',1,0),
(9,'9',21,3,10,11,NULL,'B4','NQ4C1B4','','4','',-80.00,'celsius','','2012-03-07 12:56:49',1,'2012-03-07 12:56:49',1,0),
(10,'10',21,3,12,13,NULL,'B5','NQ4C1B5','','5','',-80.00,'celsius','','2012-03-07 12:57:02',1,'2012-03-07 12:57:02',1,0),
(11,'11',21,3,14,15,NULL,'B6','NQ4C1B6','','6','',-80.00,'celsius','','2012-03-07 12:57:16',1,'2012-03-07 12:57:16',1,0),
(12,'12',21,3,16,17,NULL,'B7','NQ4C1B7','','7','',-80.00,'celsius','','2012-03-07 12:57:39',1,'2012-03-07 12:57:39',1,0),
(13,'13',21,3,18,19,NULL,'B8','NQ4C1B8','','8','',-80.00,'celsius','','2012-03-07 12:57:51',1,'2012-03-07 12:57:51',1,0),
(14,'14',21,3,20,21,NULL,'B9','NQ4C1B9','','9','',-80.00,'celsius','','2012-03-07 12:58:03',1,'2012-03-07 12:58:03',1,0),
(15,'15',21,3,22,23,NULL,'B10','NQ4C1B10','','10','',-80.00,'celsius','','2012-03-07 12:58:25',1,'2012-03-07 12:58:25',1,0);

INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(16,'16',21,3,24,25,NULL,'B11','NQ4C1B11','','11','',-80.00,'celsius','','2012-03-07 12:58:38',1,'2012-03-07 12:58:38',1,0),
(17,'17',21,3,26,27,NULL,'B12','NQ4C1B12','','12','',-80.00,'celsius','','2012-03-07 12:58:48',1,'2012-03-07 12:58:48',1,0),
(18,'18',21,3,28,29,NULL,'B13','NQ4C1B13','','13','',-80.00,'celsius','','2012-03-07 12:59:01',1,'2012-03-07 12:59:01',1,0),
(19,'19',21,3,30,31,NULL,'B14','NQ4C1B14','','14','',-80.00,'celsius','','2012-03-07 12:59:11',1,'2012-03-07 12:59:11',1,0),
(20,'20',21,3,32,33,NULL,'B15','NQ4C1B15','','15','',-80.00,'celsius','','2012-03-07 12:59:21',1,'2012-03-07 12:59:21',1,0),
(21,'21',21,4,36,37,NULL,'B1','NQ4C2B1','','1','',-80.00,'celsius','','2012-03-08 10:58:46',1,'2012-03-08 10:58:46',1,0),
(22,'22',21,4,38,39,NULL,'B2','NQ4C2B2','','2','',-80.00,'celsius','','2012-03-08 10:58:56',1,'2012-03-08 10:58:56',1,0),
(23,'23',21,4,40,41,NULL,'B3','NQ4C2B3','','3','',-80.00,'celsius','','2012-03-08 10:59:08',1,'2012-03-08 10:59:08',1,0),
(24,'24',21,4,42,43,NULL,'B4','NQ4C2B4','','4','',-80.00,'celsius','','2012-03-08 10:59:19',1,'2012-03-08 10:59:19',1,0),
(25,'25',21,4,44,45,NULL,'B5','NQ4C2B5','','5','',-80.00,'celsius','','2012-03-08 10:59:29',1,'2012-03-08 10:59:29',1,0),
(26,'26',21,4,46,47,NULL,'B6','NQ4C2B6','','6','',-80.00,'celsius','','2012-03-08 10:59:38',1,'2012-03-08 10:59:38',1,0),
(27,'27',21,4,48,49,NULL,'B7','NQ4C2B7','','7','',-80.00,'celsius','','2012-03-08 10:59:48',1,'2012-03-08 10:59:48',1,0),
(28,'28',21,4,50,51,NULL,'B8','NQ4C2B8','','8','',-80.00,'celsius','','2012-03-08 10:59:57',1,'2012-03-08 10:59:57',1,0),
(29,'29',21,4,52,53,NULL,'B9','NQ4C2B9','','9','',-80.00,'celsius','','2012-03-08 11:00:06',1,'2012-03-08 11:00:06',1,0),
(30,'30',21,4,54,55,NULL,'B10','NQ4C2B10','','10','',-80.00,'celsius','','2012-03-08 11:00:16',1,'2012-03-08 11:00:16',1,0);

INSERT INTO `storage_masters` (`id`,`code`,`storage_control_id`,`parent_id`,`lft`,`rght`,`barcode`,`short_label`,`selection_label`,`storage_status`,`parent_storage_coord_x`,`parent_storage_coord_y`,`temperature`,`temp_unit`,`notes`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
(31,'31',21,4,56,57,NULL,'B11','NQ4C2B11','','11','',-80.00,'celsius','','2012-03-08 11:00:25',1,'2012-03-08 11:00:25',1,0),
(32,'32',21,4,58,59,NULL,'B12','NQ4C2B12','','12','',-80.00,'celsius','','2012-03-08 11:00:34',1,'2012-03-08 11:00:34',1,0),
(33,'33',21,4,60,61,NULL,'B13','NQ4C2B13','','13','',-80.00,'celsius','','2012-03-08 11:00:43',1,'2012-03-08 11:00:43',1,0),
(34,'34',21,4,62,63,NULL,'B14','NQ4C2B14','','14','',-80.00,'celsius','','2012-03-08 11:00:52',1,'2012-03-08 11:00:52',1,0),
(35,'35',21,4,64,65,NULL,'B15','NQ4C2B15','','15','',-80.00,'celsius','','2012-03-08 11:01:02',1,'2012-03-08 11:01:02',1,0),
(36,'36',21,5,68,69,NULL,'B1','NQ4C3B1','','1','',-80.00,'celsius','','2012-03-08 11:01:57',1,'2012-03-08 11:01:57',1,0),
(37,'37',21,5,70,71,NULL,'B2','NQ4C3B2','','2','',-80.00,'celsius','','2012-03-08 11:02:07',1,'2012-03-08 11:02:07',1,0),
(38,'38',21,5,72,73,NULL,'B3','NQ4C3B3','','3','',-80.00,'celsius','','2012-03-08 11:02:15',1,'2012-03-08 11:02:15',1,0),
(39,'39',21,5,74,75,NULL,'B4','NQ4C3B4','','4','',-80.00,'celsius','','2012-03-08 11:02:23',1,'2012-03-08 11:02:23',1,0),
(40,'40',21,5,76,77,NULL,'B5','NQ4C3B5','','5','',-80.00,'celsius','','2012-03-08 11:02:33',1,'2012-03-08 11:02:33',1,0),
(41,'41',21,5,78,79,NULL,'B6','NQ4C3B6','','6','',-80.00,'celsius','','2012-03-08 11:02:42',1,'2012-03-08 11:02:42',1,0),
(42,'42',21,5,80,81,NULL,'B7','NQ4C3B7','','7','',-80.00,'celsius','','2012-03-08 11:02:51',1,'2012-03-08 11:02:51',1,0),
(43,'43',21,5,82,83,NULL,'B8','NQ4C3B8','','8','',-80.00,'celsius','','2012-03-08 11:03:01',1,'2012-03-08 11:03:01',1,0),
(44,'44',21,5,84,85,NULL,'B9','NQ4C3B9','','9','',-80.00,'celsius','','2012-03-08 11:03:14',1,'2012-03-08 11:03:14',1,0),
(45,'45',21,5,86,87,NULL,'B10','NQ4C3B10','','10','',-80.00,'celsius','','2012-03-08 11:03:25',1,'2012-03-08 11:03:25',1,0),
(46,'46',21,5,88,89,NULL,'B11','NQ4C3B11','','11','',-80.00,'celsius','','2012-03-08 11:03:37',1,'2012-03-08 11:03:37',1,0),
(47,'47',21,5,90,91,NULL,'B12','NQ4C3B12','','12','',-80.00,'celsius','','2012-03-08 11:03:47',1,'2012-03-08 11:03:47',1,0),
(48,'48',21,5,92,93,NULL,'B13','NQ4C3B13','','13','',-80.00,'celsius','','2012-03-08 11:03:56',1,'2012-03-08 11:03:56',1,0),
(49,'49',21,5,94,95,NULL,'B14','NQ4C3B14','','14','',-80.00,'celsius','','2012-03-08 11:04:05',1,'2012-03-08 11:04:05',1,0),
(50,'50',21,5,96,97,NULL,'B15','NQ4C3B15','','15','',-80.00,'celsius','','2012-03-08 11:04:14',1,'2012-03-08 11:04:14',1,0);

INSERT INTO `std_boxs` (`id`,`storage_master_id`,`deleted`) VALUES 
(1,6,0),
(2,7,0),
(3,8,0),
(4,9,0),
(5,10,0),
(6,11,0),
(7,12,0),
(8,13,0),
(9,14,0),
(10,15,0),
(11,16,0),
(12,17,0),
(13,18,0),
(14,19,0),
(15,20,0;

INSERT INTO `std_boxs` (`id`,`storage_master_id`,`deleted`) VALUES
(16,21,0),
(17,22,0),
(18,23,0),
(19,24,0),
(20,25,0),
(21,26,0),
(22,27,0),
(23,28,0),
(24,29,0),
(25,30,0),
(26,31,0),
(27,32,0),
(28,33,0),
(29,34,0),
(30,35,0);

INSERT INTO `std_boxs` (`id`,`storage_master_id`,`deleted`) VALUES
(31,36,0),
(32,37,0),
(33,38,0),
(34,39,0),
(35,40,0),
(36,41,0),
(37,42,0),
(38,43,0),
(39,44,0),
(40,45,0),
(41,46,0),
(42,47,0),
(43,48,0),
(44,49,0),
(45,50,0);

INSERT INTO `std_nitro_locates` (`id`,`storage_master_id`,`deleted`) VALUES 
(1,1,0);

INSERT INTO `std_racks` (`id`,`storage_master_id`,`deleted`) VALUES
(1,3,0),
(2,4,0),
(3,5,0);

INSERT INTO `std_shelfs` (`id`,`storage_master_id`,`deleted`) VALUES
(1,2,0);

-- Hide Storage Code field

UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='storagemasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- =============================================================================== -- 
-- 								INVENTORY
-- =============================================================================== --

-- Inventory Language Updates
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('cerebrospinal fluid', 'Cerebrospinal Fluid', ''),
	('stem cells', 'Stem Cells', '');

-- Hide acquisition label
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id') ,  `language_label`='specific aliquot type' WHERE model='ViewAliquot' AND tablename='' AND field='aliquot_control_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id');

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Create new sample types
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('stem cells', 'derivative', 'sample_masters,sd_undetailed_derivatives,derivatives', 'sd_der_stem_cells', 0, 'stem cells'),
('cerebrospinal fluid', 'specimen', 'sample_masters,specimens', 'sd_spe_cerebrospinal_fluid', 0);

-- Activate new types (CSF)
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'cerebrospinal fluid' AND `sample_category` = 'specimen'), 1);

-- Blood -> Stem Cells
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'blood' AND `sample_category` = 'specimen'), (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'stem cells' AND `sample_category` = 'derivative'), 1);

-- Bone Marrow -> Stem Cells
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
(SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'bone marrow' AND `sample_category` = 'specimen', (SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'stem cells' AND `sample_category` = 'derivative'), 1);

-- Detail table creation
DROP TABLE IF EXISTS `sd_der_stem_cells`;
CREATE TABLE `sd_der_stem_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `deleted` TINYINT(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `sd_der_stem_cells_revs`;
CREATE TABLE `sd_der_stem_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `sd_spe_cerebrospinal_fluid`;
CREATE TABLE `sd_spe_cerebrospinal_fluid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `collected_volume` DECIMAL(10,2) DEFAULT NULL,
  `collected_volume_unit` VARCHAR(20) DEFAULT NULL,
  `deleted` TINYINT(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `sd_spe_cerebrospinal_fluid_revs`;
CREATE TABLE `sd_spe_cerebrospinal_fluid_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `collected_volume` DECIMAL(10,2) DEFAULT NULL,
  `collected_volume_unit` VARCHAR(20) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
