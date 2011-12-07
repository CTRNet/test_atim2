-- BANK CUSTOMIZATION SCRIPT
-- ATiM Version: v2.3.4
-- Custom Version: v.02
-- Bank: Child and Family Research Institute - CCBR

-- =============================================================================== -- 
-- 								CORE
-- =============================================================================== -- 

-- Language
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.2', '');

-- Disable Modules/Menus not used
UPDATE `menus` SET `flag_active`=0 WHERE `id`='procd_CAN_01';
UPDATE `menus` SET `flag_active`=0 WHERE `id`='procd_CAN_02';

-- Disable Contact/Misc Identifiers section
UPDATE `menus` SET `flag_active`=0 WHERE `id`='clin_CAN_26';
UPDATE `menus` SET `flag_active`=0 WHERE `id`='clin_CAN_24';


-- =============================================================================== -- 
-- 							Clinical:Treatment
-- =============================================================================== -- 

-- LANGUAGE UPDATES
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('other treatment', 'Other Treatment', ''),
('ccbr bone marrow transplant', 'Bone Marrow Transplant', ''),
('ccbr bone marrow transplant specific', 'Bone Marrow Transplant Specific', ''),
('bone marrow transplant', 'Bone Marrow Transplant', ''),
('ccbr_children and womens', 'C&W', ''),
('ccbr_other_facility', 'If other, specify', ''),
('ccbr_inthrathecal_therapy', 'Inthrathecal Therapy', ''),
('ccbr_l_asparagine', 'L-Asparagine', ''),
('ccbr_additional treatment', 'Additional Treatment', ''),
('ccbr date induction chemo', 'Induction Chemotherapy', ''),
('ccbr date maintenance chemo', 'Maintenance Chemotherapy', ''),
('ccbr date intensification chemo', 'Intensification Chemotherapy', ''),
('ccbr date reinduction chemo', 'Re-induction Chemotherapy', ''),
('ccbr day8 bone marrow date', 'Date of Day 8 Bone Marrow', ''),
('ccbr day8 percent blasts', '% Blasts from Day 8', ''),
('ccbr day8 mrd', 'MRD % Blasts from Day 8', ''),
('ccbr day15 bone marrow date', 'Date of Day 15 Bone Marrow', ''),
('ccbr day15 percent blasts', '% Blasts from Day 15', ''),
('ccbr day15 mrd', 'MRD % Blasts from Day 15', ''),
('ccbr day29 bone marrow date', 'Date of Day 29 Bone Marrow', ''),
('ccbr day29 percent blasts', '% Blasts from Day 29', ''),
('ccbr day29 mrd', 'MRD % Blasts from Day 29', ''),
('ccbr other bone marrow date', 'Date of Other Bone Marrow', ''),
('ccbr other percent blasts', '% Blasts from Other', ''),
('ccbr other mrd', 'MRD % Blasts from Other', ''),
('ccbr response to chemotherapy', 'Response to Chemotherapy', ''),
('dose cgy', 'Dose cGy', ''),
('ccbr allogenic', 'Allogenic', ''),
('ccbr donor', 'Donor', ''),
('ccbr stem cell', 'Stem Cell', ''),
('ccbr acute', 'Acute', ''),
('ccbr chronic', 'Chronic', ''),
('ccbr na', 'NA', ''),
('ccbr transplant type', 'Transplant Type', ''),
('ccbr patient typing', 'Patient Typing', ''),
('ccbr donor mismatch', 'Donor Mismatch', ''),
('ccbr gvhd status', 'GVHD Status', '');

-- Add new treatment type tables
CREATE TABLE `txd_ccbr_transplants` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `ccbr_transplant_type` VARCHAR(50) ,
  `ccbr_patient_typing` VARCHAR(50) ,
  `ccbr_donor_mismatch` VARCHAR(255) , 
  `ccbr_gvhd_status` VARCHAR(50) ,
  `tx_master_id` INT NULL ,
  `deleted` TINYINT(3) NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `txd_ccbr_transplants_revs` (
  `id` INT NOT NULL ,
  `ccbr_transplant_type` VARCHAR(50) ,
  `ccbr_patient_typing` VARCHAR(50) ,
  `ccbr_donor_mismatch` VARCHAR(255) , 
  `ccbr_gvhd_status` VARCHAR(50) ,
  `tx_master_id` INT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATETIME NOT NULL ,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

CREATE TABLE `txd_ccbr_other_treatments` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `tx_master_id` INT NULL ,
  `deleted` TINYINT(3) NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `txd_ccbr_other_treatments_revs` (
  `id` INT NOT NULL ,
  `tx_master_id` INT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATETIME NOT NULL ,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

-- Add structures for new treatment types
INSERT INTO `structures` (`alias`) VALUES ('txd_ccbr_bone_marrow_transplants');
INSERT INTO `structures` (`alias`) VALUES ('txd_ccbr_other_treatments');
INSERT INTO `structures` (`alias`) VALUES ('txe_radiations');

-- Add extended Radiotherapy
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentExtend', 'txe_radiations', 'dose_cgy', 'integer',  NULL , '0', '', '', '', 'dose cgy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='dose_cgy' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dose cgy' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Add new treatment types to control table, disable un-needed types
INSERT INTO `tx_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `display_order`, `databrowser_label`)
	VALUES ('transplant', 'all', 1, 'txd_ccbr_bone_marrow_transplants', 'txd_ccbr_bone_marrow_transplants', 0, 'all|bone marrow transplant');
INSERT INTO `tx_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `display_order`, `databrowser_label`)
	VALUES ('other treatment', 'all', 1, 'txd_ccbr_other_treatments', 'txd_ccbr_other_treatments', 0, 'all|other treatment');
UPDATE `tx_controls` SET `flag_active`=0 WHERE `tx_method`='surgery without extend';	

UPDATE `tx_controls` SET `extend_tablename`='txe_radiations', `extend_form_alias`='txe_radiations' WHERE
`tx_method` = 'radiation' AND `detail_tablename` = 'txd_radiations' AND `form_alias` = 'txd_radiations';

-- New form for Other Treatment
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`) VALUES
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'tx_intent'), 1, 2, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'start_date'), 1, 3, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'finish_date'), 1, 4, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'facility'), 1, 7, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'notes'), 1, 99, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'information_source'), 1, 8, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'protocol_master_id'), 1, 9, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

-- New form for Transplants
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`) VALUES
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'tx_intent'), 1, 2, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'start_date'), 1, 3, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'finish_date'), 1, 4, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'facility'), 1, 7, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'notes'), 1, 99, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'information_source'), 1, 8, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'protocol_master_id'), 1, 9, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_transplant_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("allogenic", "ccbr allogenic");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transplant_type"),  (SELECT id FROM structure_permissible_values WHERE value="allogenic" AND language_alias="ccbr allogenic"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("donor", "ccbr donor");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transplant_type"),  (SELECT id FROM structure_permissible_values WHERE value="donor" AND language_alias="ccbr donor"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("stem cell", "ccbr stem cell");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transplant_type"),  (SELECT id FROM structure_permissible_values WHERE value="stem cell" AND language_alias="ccbr stem cell"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_gvhd_status', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("acute", "ccbr acute");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_gvhd_status"),  (SELECT id FROM structure_permissible_values WHERE value="acute" AND language_alias="ccbr acute"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("chronic", "ccbr chronic");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_gvhd_status"),  (SELECT id FROM structure_permissible_values WHERE value="chronic" AND language_alias="ccbr chronic"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("na", "ccbr na");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_gvhd_status"),  (SELECT id FROM structure_permissible_values WHERE value="na" AND language_alias="ccbr na"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_bone_marrow_transplants', 'ccbr_transplant_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_transplant_type') , '0', '', '', '', 'ccbr transplant type', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_bone_marrow_transplants', 'ccbr_patient_typing', 'input', NULL , '0', 'size=30', '', '', 'ccbr patient typing', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_bone_marrow_transplants', 'ccbr_donor_mismatch', 'input',  NULL , '0', 'size=30', '', '', 'ccbr donor mismatch', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_bone_marrow_transplants', 'ccbr_gvhd_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_gvhd_status') , '0', '', '', '', 'ccbr gvhd status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_transplant_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr transplant type' AND `language_tag`=''), '1', '10', 'ccbr bone marrow transplant specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_patient_typing' AND `type`='input' AND `structure_value_domain` IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ccbr patient typing' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_donor_mismatch' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ccbr donor mismatch' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_gvhd_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_gvhd_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr gvhd status' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Field: Treatment Facility
-- Change: Modify value domain, set C&W to default value
INSERT INTO `structure_value_domains` (`domain_name`, `category`) VALUES ('ccbr_tx_facility', '');
SET @VALUE_DOMAIN_ID = LAST_INSERT_ID();
UPDATE `structure_fields` SET `structure_value_domain` = @VALUE_DOMAIN_ID WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `field` = 'facility';

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES ('children and womens', 'ccbr_children and womens');
SET @VALUE_ID = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
(@VALUE_DOMAIN_ID, @VALUE_ID, 1, 1, 1),
(@VALUE_DOMAIN_ID, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other'), 2, 1, 1);

UPDATE `structure_fields` SET `default` = 'children and womens' WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `field` = 'facility';

ALTER TABLE `tx_masters` ADD COLUMN `ccbr_facility_other` VARCHAR(50) NULL AFTER `facility`;

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Clinicalannotation', 'TreatmentMaster', 'tx_masters', 'ccbr_facility_other', '', 'ccbr_other_facility', 'input', 'size=30', 'help_facility', 'open', 'open', 'open', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`) VALUES
((SELECT `id` FROM `structures` WHERE alias = 'treatmentmasters'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'ccbr_facility_other'), 1, 8, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_chemos'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'ccbr_facility_other'), 1, 8, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_radiations'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'ccbr_facility_other'), 1, 8, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_surgeries'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'ccbr_facility_other'), 1, 8, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_other_treatments'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'ccbr_facility_other'), 1, 8, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT `id` FROM `structures` WHERE alias = 'txd_ccbr_bone_marrow_transplants'), (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'Clinicalannotation' AND `model` = 'TreatmentMaster' AND `tablename` = 'tx_masters' AND `field` = 'ccbr_facility_other'), 1, 8, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');


-- Chemotherapy Modifications --
-- New Section to Chemo: Additional Treatment
ALTER TABLE `txd_chemos`
	ADD COLUMN `ccbr_inthrathecal_therapy` VARCHAR(45) NULL DEFAULT NULL AFTER `completed_cycles` ,
	ADD COLUMN `ccbr_l_asparagine` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_inthrathecal_therapy` ,	
	ADD COLUMN `ccbr_date_induction_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_l_asparagine` ,
	ADD COLUMN `ccbr_date_maintenance_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_date_induction_chemo` ,
	ADD COLUMN `ccbr_date_intensification_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_date_maintenance_chemo` ,
	ADD COLUMN `ccbr_date_reinduction_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_date_intensification_chemo` ,
	ADD COLUMN `ccbr_day8_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_date_reinduction_chemo` ,
	ADD COLUMN `ccbr_day8_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_day8_bone_marrow_date` ,
	ADD COLUMN `ccbr_day8_mrd` INT NULL DEFAULT NULL AFTER `ccbr_day8_percent_blasts` ,
	ADD COLUMN `ccbr_day15_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_day8_mrd` ,
	ADD COLUMN `ccbr_day15_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_day15_bone_marrow_date` ,
	ADD COLUMN `ccbr_day15_mrd` INT NULL DEFAULT NULL AFTER `ccbr_day15_percent_blasts` ,
	ADD COLUMN `ccbr_day29_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_day15_mrd` ,
	ADD COLUMN `ccbr_day29_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_day29_bone_marrow_date` ,
	ADD COLUMN `ccbr_day29_mrd` INT NULL DEFAULT NULL AFTER `ccbr_day29_percent_blasts` ,
	ADD COLUMN `ccbr_other_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_day29_mrd` ,
	ADD COLUMN `ccbr_other_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_other_bone_marrow_date` ,
	ADD COLUMN `ccbr_other_mrd` INT NULL DEFAULT NULL AFTER `ccbr_other_percent_blasts` ;
	
ALTER TABLE `txd_chemos_revs`
	ADD COLUMN `ccbr_inthrathecal_therapy` VARCHAR(45) NULL DEFAULT NULL AFTER `completed_cycles` ,
	ADD COLUMN `ccbr_l_asparagine` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_inthrathecal_therapy` ,	
	ADD COLUMN `ccbr_date_induction_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_l_asparagine` ,
	ADD COLUMN `ccbr_date_maintenance_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_date_induction_chemo` ,
	ADD COLUMN `ccbr_date_intensification_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_date_maintenance_chemo` ,
	ADD COLUMN `ccbr_date_reinduction_chemo` DATE NULL DEFAULT NULL AFTER `ccbr_date_intensification_chemo` ,
	ADD COLUMN `ccbr_day8_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_date_reinduction_chemo` ,
	ADD COLUMN `ccbr_day8_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_day8_bone_marrow_date` ,
	ADD COLUMN `ccbr_day8_mrd` INT NULL DEFAULT NULL AFTER `ccbr_day8_percent_blasts` ,
	ADD COLUMN `ccbr_day15_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_day8_mrd` ,
	ADD COLUMN `ccbr_day15_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_day15_bone_marrow_date` ,
	ADD COLUMN `ccbr_day15_mrd` INT NULL DEFAULT NULL AFTER `ccbr_day15_percent_blasts` ,
	ADD COLUMN `ccbr_day29_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_day15_mrd` ,
	ADD COLUMN `ccbr_day29_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_day29_bone_marrow_date` ,
	ADD COLUMN `ccbr_day29_mrd` INT NULL DEFAULT NULL AFTER `ccbr_day29_percent_blasts` ,
	ADD COLUMN `ccbr_other_bone_marrow_date` DATE NULL DEFAULT NULL AFTER `ccbr_day29_mrd` ,
	ADD COLUMN `ccbr_other_percent_blasts` INT(11) NULL DEFAULT NULL AFTER `ccbr_other_bone_marrow_date` ,
	ADD COLUMN `ccbr_other_mrd` INT NULL DEFAULT NULL AFTER `ccbr_other_percent_blasts` ;	

INSERT INTO `structure_value_domains` (`domain_name`, `category`) VALUES ('ccbr_yesnounknown', '');
SET @VALUE_DOMAIN_ID = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
(@VALUE_DOMAIN_ID, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'yes'), 1, 1, 1),
(@VALUE_DOMAIN_ID, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'no'), 2, 1, 1),
(@VALUE_DOMAIN_ID, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'unknown'), 3, 1, 1);

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_inthrathecal_therapy', 'ccbr_inthrathecal_therapy', '', 'select', '', @VALUE_DOMAIN_ID, '', 'open', 'open', 'open', 0);
SET @FIELD_ID = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`) VALUES
((SELECT `id` FROM `structures` WHERE alias = 'txd_chemos'), @FIELD_ID, 1, 20, 'ccbr_additional treatment', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_l_asparagine', 'ccbr_l_asparagine', '', 'select', '', @VALUE_DOMAIN_ID, '', 'open', 'open', 'open', 0);
SET @FIELD_ID = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`) VALUES
((SELECT `id` FROM `structures` WHERE alias = 'txd_chemos'), @FIELD_ID, 1, 30, '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_date_induction_chemo', 'date',  NULL , '0', '', '', '', 'ccbr date induction chemo', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_date_maintenance_chemo', 'date',  NULL , '0', '', '', '', 'ccbr date maintenance chemo', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_date_intensification_chemo', 'date',  NULL , '0', '', '', '', 'ccbr date intensification chemo', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_date_reinduction_chemo', 'date',  NULL , '0', '', '', '', 'ccbr date reinduction chemo', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_induction_chemo' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr date induction chemo' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_maintenance_chemo' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr date maintenance chemo' AND `language_tag`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_intensification_chemo' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr date intensification chemo' AND `language_tag`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_reinduction_chemo' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr date reinduction chemo' AND `language_tag`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Fields for Blasts section
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day8_bone_marrow_date', 'date',  NULL , '0', '', '', '', 'ccbr day8 bone marrow date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day8_percent_blasts', 'integer',  NULL , '0', '', '', '', 'ccbr day8 percent blasts', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day8_mrd', 'integer',  NULL , '0', '', '', '', 'ccbr day8 mrd', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day15_bone_marrow_date', 'date',  NULL , '0', '', '', '', 'ccbr day15 bone marrow date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day15_percent_blasts', 'integer',  NULL , '0', '', '', '', 'ccbr day15 percent blasts', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day15_mrd', 'integer',  NULL , '0', '', '', '', 'ccbr day15 mrd', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day29_bone_marrow_date', 'date',  NULL , '0', '', '', '', 'ccbr day29 bone marrow date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day29_percent_blasts', 'integer',  NULL , '0', '', '', '', 'ccbr day29 percent blasts', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day29_mrd', 'integer',  NULL , '0', '', '', '', 'ccbr day29 mrd', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_other_bone_marrow_date', 'date',  NULL , '0', '', '', '', 'ccbr other bone marrow date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_other_percent_blasts', 'integer',  NULL , '0', '', '', '', 'ccbr other percent blasts', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_other_mrd', 'integer',  NULL , '0', '', '', '', 'ccbr other mrd', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day8_bone_marrow_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day8 bone marrow date' AND `language_tag`=''), '1', '40', 'ccbr response to chemotherapy', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day8_percent_blasts' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day8 percent blasts' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day8_mrd' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day8 mrd' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day15_bone_marrow_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day15 bone marrow date' AND `language_tag`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day15_percent_blasts' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day15 percent blasts' AND `language_tag`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day15_mrd' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day15 mrd' AND `language_tag`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day29_bone_marrow_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day29 bone marrow date' AND `language_tag`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day29_percent_blasts' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day29 percent blasts' AND `language_tag`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day29_mrd' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr day29 mrd' AND `language_tag`=''), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_other_bone_marrow_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr other bone marrow date' AND `language_tag`=''), '1', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_other_percent_blasts' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr other percent blasts' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_other_mrd' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr other mrd' AND `language_tag`=''), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');


-- =============================================================================== -- 
-- 							Clinical:Consent
-- =============================================================================== -- 

-- LANGUAGE UPDATES
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr_consented', 'Consented', ''),
('ccbr_declined', 'Declined', ''),
('ccbr_withdrawn', 'Withdrawn', ''),
('ccbr_yes', 'Yes', ''),
('ccbr_no', 'No', ''),
('ccbr_na', 'NA', ''),
('ccbr_assented', 'Assented', ''),
('ccbr_age', 'Age', ''),
('ccbr_cognitive', 'Cognitive', ''),
('ccbr_other', 'Other', ''),
('ccbr consent', 'CCBR Consent Form', ''),
('ccbr_verbal_consent', 'Verbal Consent', ''),
('ccbr date verbal consent', 'Date of Verbal Consent', ''),
('ccbr person verbal consent', 'Person Consenting (Verbal)', ''),
('ccbr_formal_consent', 'Formal Consent', ''),
('ccbr date formal consent', 'Date of Formal Consent', ''),
('ccbr person formal consent', 'Person Consenting (Formal)', ''),
('ccbr consent blood donation', 'Consent to Donation of Left Over Blood', ''),
('ccbr consent international research', 'Consent to International Research', ''),
('ccbr consent any research', 'Consent to any Research', ''),
('ccbr_consent_details', 'Consent Details', ''),
('ccbr treating physician', 'Treating Physician', ''),
('ccbr formal consent', 'Formal Consent', ''),
('ccbr verbal consent', 'Verbal Consent', ''),
('ccbr_withdrawal', 'Withdrawal', ''),
('ccbr date withdrawal', 'Date of Withdrawal', ''),
('ccbr withdraw further samples', 'Withdrawl of Further Samples', ''),
('CCBR Consent Form', 'CCBR Consent Form', ''),
('ccbr assent status', 'Assent', ''),
('ccbr not assented', 'Not Assented', ''),
('ccbr_assent', 'Assent', ''),
('ccbr date assent', 'Date of Assent', ''),
('ccbr assent reason decline', 'Reason for Lack of Assent', ''),
('ccbr withdraw all samples', 'Withdrawal of All Samples', ''),
('ccbr consent stem cells', 'Consent to Donation of Left Over Stem Cells', '');

CREATE TABLE `cd_ccbr_consents` (
  `id` INT NOT NULL ,
  `ccbr_verbal_consent` VARCHAR(45) NULL ,
  `ccbr_date_verbal_consent` DATE NULL ,
  `ccbr_person_verbal_consent` VARCHAR(45) NULL ,
  `ccbr_formal_consent` VARCHAR(45) NULL ,
  `ccbr_date_formal_consent` DATE NULL ,
  `ccbr_person_formal_consent` VARCHAR(45) NULL ,
  `ccbr_consent_blood_donation` VARCHAR(45) NULL ,
  `ccbr_consent_international_research` VARCHAR(45) NULL ,
  `ccbr_consent_any_research` VARCHAR(45) NULL ,
  `ccbr_assent_status` VARCHAR(45) NULL ,
  `ccbr_date_assent` DATE NULL ,
  `ccbr_assent_reason_decline` VARCHAR(45) NULL ,
  `ccbr_date_withdrawal` DATE NULL ,
  `ccbr_withdrawal_samples` VARCHAR(45) NULL,
  `ccbr_consent_stem_cells` VARCHAR(45) NULL ,
  `ccbr_withdraw_all_samples` VARCHAR(45) NULL ,
  `consent_master_id` INT(11) NULL ,
  `deleted` TINYINT(3) DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `cd_ccbr_consents_rev` (
  `id` INT(11) NOT NULL ,
  `ccbr_verbal_consent` VARCHAR(45) NULL ,
  `ccbr_date_verbal_consent` DATE NULL ,
  `ccbr_person_verbal_consent` VARCHAR(45) NULL ,
  `ccbr_formal_consent` VARCHAR(45) NULL ,
  `ccbr_date_formal_consent` DATE NULL ,
  `ccbr_person_formal_consent` VARCHAR(45) NULL ,
  `ccbr_consent_blood_donation` VARCHAR(45) NULL ,
  `ccbr_consent_international_research` VARCHAR(45) NULL ,
  `ccbr_consent_any_research` VARCHAR(45) NULL ,
  `ccbr_assent_status` VARCHAR(45) NULL ,
  `ccbr_date_assent` DATE NULL ,
  `ccbr_assent_reason_decline` VARCHAR(45) NULL ,
  `ccbr_date_withdrawal` DATE NULL ,
  `ccbr_withdrawal_samples` VARCHAR(45) NULL,
  `ccbr_consent_stem_cells` VARCHAR(45) NULL ,
  `ccbr_withdraw_all_samples` VARCHAR(45) NULL ,
  `consent_master_id` INT(11) NOT NULL ,
  `version_id` INT(11) DEFAULT 0 ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('ccbr consent', 1, 'cd_ccbr_consents', 'cd_ccbr_consents', 1, 'ccbr consent');

-- Disable national form
UPDATE `consent_controls` SET `flag_active`=0 WHERE controls_type = 'Consent National';

-- Create CCBR consent structure
INSERT INTO `structures` (`alias`) VALUES ('cd_ccbr_consents');

-- Create consent value domains

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_consent_status', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("consented", "ccbr_consented");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_consent_status"),  (SELECT id FROM structure_permissible_values WHERE value="consented" AND language_alias="ccbr_consented"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("declined", "ccbr_declined");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_consent_status"),  (SELECT id FROM structure_permissible_values WHERE value="declined" AND language_alias="ccbr_declined"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withdrawn", "ccbr_withdrawn");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_consent_status"),  (SELECT id FROM structure_permissible_values WHERE value="withdrawn" AND language_alias="ccbr_withdrawn"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_consent_yesnona', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("yes", "ccbr_yes");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_consent_yesnona"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="ccbr_yes"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("no", "ccbr_no");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_consent_yesnona"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="ccbr_no"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("na", "ccbr_na");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_consent_yesnona"),  (SELECT id FROM structure_permissible_values WHERE value="na" AND language_alias="ccbr_na"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_assent_status', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("assented", "ccbr_assented");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_assent_status"),  (SELECT id FROM structure_permissible_values WHERE value="assented" AND language_alias="ccbr_assented"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("declined", "ccbr_declined");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_assent_status"),  (SELECT id FROM structure_permissible_values WHERE value="declined" AND language_alias="ccbr_declined"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("not assented", "ccbr not assented");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_assent_status"),  (SELECT id FROM structure_permissible_values WHERE value="not assented" AND language_alias="ccbr not assented"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_assent_reason_decline', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("age", "ccbr_age");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_assent_reason_decline"),  (SELECT id FROM structure_permissible_values WHERE value="age" AND language_alias="ccbr_age"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("cognitive", "ccbr_cognitive");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_assent_reason_decline"),  (SELECT id FROM structure_permissible_values WHERE value="cognitive" AND language_alias="ccbr_cognitive"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "ccbr_other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_assent_reason_decline"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="ccbr_other"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('custom_person_consenting', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''ccbr person consenting'')');
INSERT INTO `structure_permissible_values_custom_controls` (`name`, `flag_active`, `values_max_length`) VALUES ('ccbr person consenting', 1, 20);


-- Create fields for detail consent form

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_date_verbal_consent', 'date',  NULL , '0', '', '', '', 'ccbr date verbal consent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_person_verbal_consent', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='custom_person_consenting') , '0', '', '', '', 'ccbr person verbal consent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_verbal_consent', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_status') , '0', '', '', '', 'ccbr verbal consent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_formal_consent', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_status') , '0', '', '', '', 'ccbr formal consent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_date_formal_consent', 'date',  NULL , '0', '', '', '', 'ccbr date formal consent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_person_formal_consent', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='custom_person_consenting') , '0', '', '', '', 'ccbr person formal consent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_blood_donation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent blood donation', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_international_research', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent international research', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_any_research', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent any research', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_date_withdrawal', 'date',  NULL , '0', '', '', '', 'ccbr date withdrawal', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_withdrawal_samples', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr withdraw further samples', ''),
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_assent_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_assent_status') , '0', '', '', '', 'ccbr assent status', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_date_assent', 'date',  NULL , '0', '', '', '', 'ccbr date assent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_assent_reason_decline', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_assent_reason_decline') , '0', '', '', '', 'ccbr assent reason decline', ''),
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_stem_cells', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent stem cells', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_withdraw_all_samples', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr withdraw all samples', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_date_verbal_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr date verbal consent' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_person_verbal_consent' AND `type`='select'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_verbal_consent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr verbal consent' AND `language_tag`=''), '1', '1', 'ccbr_verbal_consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_formal_consent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr formal consent' AND `language_tag`=''), '1', '4', 'ccbr_formal_consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_date_formal_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr date formal consent' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_person_formal_consent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_person_consenting')), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_blood_donation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent blood donation' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_international_research' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent international research' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_any_research' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent any research' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_date_withdrawal' AND `type`='date' AND `structure_value_domain` IS NULL), '2', '1', 'ccbr_withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_withdrawal_samples' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno')), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_assent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_assent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr assent status' AND `language_tag`=''), '2', '10', 'ccbr_assent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_date_assent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr date assent' AND `language_tag`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_assent_reason_decline' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_assent_reason_decline')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr assent reason decline' AND `language_tag`=''), '2', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_stem_cells' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent stem cells' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_withdraw_all_samples' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr withdraw all samples' AND `language_tag`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM `structure_fields` where plugin = 'Clinicalannotation' AND model = 'ConsentMaster' AND field = 'translator_indicator' AND `type` = 'yes_no' AND structure_value_domain IS NULL), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM `structure_fields` where plugin = 'Clinicalannotation' AND model = 'ConsentMaster' AND field = 'translator_signature' AND `type` = 'yes_no' AND structure_value_domain IS NULL), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM `structure_fields` where plugin = 'Clinicalannotation' AND model = 'ConsentMaster' AND field = 'notes' AND structure_value_domain IS NULL), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');


-- =============================================================================== -- 
-- 							Clinical:Profile
-- =============================================================================== -- 


-- LANGUAGE UPDATES
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr autopsy code', 'Autopsy Code', ''),
('ccbr cause of death', 'Cause of Death', ''),
('ccbr_disease related', 'Disease Related', ''),
('ccbr_accidental', 'Accidental', ''),
('ccbr_unknown', 'Unknown', ''),
('ccbr age at death', 'Age at Death', ''),
('ccbr error autopsy code', 'Error - Autopsy Code must be 6 digits', ''),
('ccbr error participant identifier', 'Error - Participant Identifer must have the format: BD-', ''),
('ccbr cog registration', 'COG Registration', ''),
('ccbr error cog registration', 'Error - COG Registration must be a 6 digit integer value', ''),
('ccbr autopsy', 'Autopsy', '');

-- Table Changes
ALTER TABLE `participants`
	ADD COLUMN `ccbr_autopsy_code` INT(10) NULL DEFAULT NULL AFTER `participant_identifier` ,
	ADD COLUMN `ccbr_autopsy` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_autopsy_code` ,
	ADD COLUMN `ccbr_treating_physician` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_autopsy` ,
	ADD COLUMN `ccbr_cause_of_death` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_treating_physician` ,
	ADD COLUMN `ccbr_age_at_death` INT(11) NULL DEFAULT NULL AFTER `ccbr_cause_of_death`,
	ADD COLUMN `ccbr_cog_registration` INT(11) NULL DEFAULT NULL AFTER `ccbr_age_at_death`,
	ADD UNIQUE INDEX `ccbr_cog_registration_UNIQUE` (`ccbr_cog_registration` ASC);
	
ALTER TABLE `participants_revs`
	ADD COLUMN `ccbr_autopsy_code` INT(10) NULL DEFAULT NULL AFTER `participant_identifier` ,
	ADD COLUMN `ccbr_autopsy` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_autopsy_code` ,
	ADD COLUMN `ccbr_treating_physician` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_autopsy` ,
	ADD COLUMN `ccbr_cause_of_death` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_treating_physician` ,
	ADD COLUMN `ccbr_age_at_death` INT(11) NULL DEFAULT NULL AFTER `ccbr_cause_of_death`,
	ADD COLUMN `ccbr_cog_registration` INT(11) NULL DEFAULT NULL AFTER `ccbr_age_at_death`;
	
-- New Value Domain
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_cause_of_death', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("disease related", "ccbr_disease related");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_cause_of_death"),  (SELECT id FROM structure_permissible_values WHERE value="disease related" AND language_alias="ccbr_disease related"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("accidental", "ccbr_accidental");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_cause_of_death"),  (SELECT id FROM structure_permissible_values WHERE value="accidental" AND language_alias="ccbr_accidental"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "ccbr_unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_cause_of_death"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="ccbr_unknown"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('custom ccbr treating physician', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''ccbr treating physician'')');
INSERT INTO `structure_permissible_values_custom_controls` (`name`, `flag_active`, `values_max_length`) VALUES ('ccbr treating physician', 1, 20);

-- Disable unneeded fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add new fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ccbr_autopsy_code', 'integer',  NULL , '0', 'size=8', '', '', 'ccbr autopsy code', ''), 
('Clinicalannotation', 'Participant', 'participants', 'ccbr_autopsy', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='yesno'), '0', '', '', '', 'ccbr autopsy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_autopsy_code' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=8' AND `default`='' AND `language_help`='' AND `language_label`='ccbr autopsy code' AND `language_tag`=''), '3', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_autopsy' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr autopsy' AND `language_tag`=''), '3', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ccbr_treating_physician', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom ccbr treating physician'), '0', '', '', '', 'ccbr treating physician', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_treating_physician' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='custom ccbr treating physician')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr treating physician' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ccbr_cause_of_death', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_cause_of_death') , '0', '', '', '', 'ccbr cause of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_cause_of_death' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_cause_of_death')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr cause of death' AND `language_tag`=''), '3', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ccbr_age_at_death', 'integer',  NULL , '0', '', '', '', 'ccbr age at death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_age_at_death' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr age at death' AND `language_tag`=''), '3', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ccbr_cog_registration', 'integer',  NULL , '0', '', '', '', 'ccbr cog registration', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_cog_registration' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr cog registration' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Validations 
INSERT INTO structure_validations(`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_autopsy_code' AND `type`='integer' AND `structure_value_domain` IS NULL), 'minLength,6', '', 'ccbr error autopsy code' ),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_autopsy_code' AND `type`='integer' AND `structure_value_domain` IS NULL), 'maxLength,6', '', 'ccbr error autopsy code' );

INSERT INTO structure_validations(`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain` IS NULL), '/^BD-[0-9]+$/', '', 'ccbr error participant identifier' );

INSERT INTO structure_validations(`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_cog_registration' AND `structure_value_domain` IS NULL), 'minLength,6', '', 'ccbr error cog registration' ),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_cog_registration' AND `structure_value_domain` IS NULL), 'maxLength,6', '', 'ccbr error cog registration' );

-- =============================================================================== -- 
-- 							Clinical:Diagnosis
-- =============================================================================== --

-- Turn off all CAP Report forms
UPDATE `diagnosis_controls` SET `flag_active`=0 WHERE `controls_type` NOT IN ('blood', 'tissue');


-- =============================================================================== -- 
-- 							Clinical:Annotation
-- =============================================================================== -- 

-- LANGUAGE UPDATES
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr', 'CCBR', ''),
('cytogenetics', 'Cytogenetics', ''),
('immunophenotype', 'Immunophenotype', ''),
('cbc and bone marrow', 'CBC and Bone Marrow', ''),
('ccbr date bone marrow', 'Date of Bone Marrow Procedure', ''),
('ccbr wbc count', 'White Blood Cell Count', ''),
('ccbr platelet count', 'Platelet Count', ''),
('ccbr ldh level', 'LDH Level', ''),
('ccbr abnormal cell count', 'Abnormal Cell Count', ''),
('ccbr neutrophil count', 'Neutrophil Count', ''),
('ccbr bone marrow cellularity', 'Bone Marrow Cellularity', ''),
('ccbr abnormal infiltrate present', 'Abnormal Infiltrate Present', ''),
('ccbr abnormal infiltrate details', 'Abnormal Infiltrate Details', ''),
('ccbr percent blast cells', 'Percent Blast Cells', ''),
('ccbr dysplasia', 'Dysplasia', ''),
('ccbr erythropoiesis', 'Erythropoiesis', ''),
('ccbr mylopoiesis', 'Mylopoiesis', ''),
('ccbr megakaryopoiesis', 'Megakaryopoiesis', ''),
('ccbr immunophenotype', 'Immunophenotype', '');

-- Disable all existing event control forms
UPDATE `event_controls` SET `flag_active`=0;

-- Create new annotation control forms and structures
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('ccbr', 'lab', 'cytogenetics', 1, 'ed_ccbr_lab_cytogenetics', 'ed_ccbr_lab_cytogenetics', 0, 'lab|ccbr|cytogenetics'),
('ccbr', 'lab', 'immunophenotype', 1, 'ed_ccbr_lab_immunophenotypes', 'ed_ccbr_lab_immunophenotypes', 0, 'lab|ccbr|immunophenotype'),
('ccbr', 'lab', 'cbc and bone marrow', 1, 'ed_ccbr_lab_cbc_bone_marrows', 'ed_ccbr_lab_cbc_bone_marrows', 0, 'lab|ccbr|cbc bonemarrow');

INSERT INTO `structures` (`alias`) VALUES
('ed_ccbr_lab_cbc_bone_marrows'),
('ed_ccbr_lab_immunophenotypes'),
('ed_ccbr_lab_cytogenetics');

-- New detail tables
CREATE TABLE `ed_ccbr_lab_cbc_bone_marrows` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `ccbr_wbc_count` INT NULL ,
  `ccbr_hemoglobin` INT NULL ,
  `ccbr_platelet_count` INT NULL ,
  `ccbr_ldh_level` INT NULL ,
  `ccbr_abnormal_cell_count` INT NULL ,
  `ccbr_neutrophil_count` INT NULL ,
  `ccbr_date_bone_marrow` DATE NULL ,
  `ccbr_bone_marrow_cellularity` INT NULL ,
  `ccbr_abnormal_infiltrate_present` VARCHAR(45) NULL ,
  `ccbr_abnormal_infiltrate_details` TEXT NULL ,
  `ccbr_percent_blast_cells` INT NULL ,
  `ccbr_dysplasia` VARCHAR(45) NULL ,
  `ccbr_erythropoiesis` VARCHAR(45) NULL ,
  `ccbr_mylopoiesis` VARCHAR(45) NULL ,
  `ccbr_megakaryopoiesis` VARCHAR(45) NULL ,
  `deleted` TINYINT UNSIGNED NOT NULL DEFAULT 0 ,
  `event_master_id` INT NULL DEFAULT NULL , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `ed_ccbr_lab_cbc_bone_marrows_revs` (
  `id` INT NOT NULL ,
  `ccbr_wbc_count` INT NULL ,
  `ccbr_hemoglobin` INT NULL ,
  `ccbr_platelet_count` INT NULL ,
  `ccbr_ldh_level` INT NULL ,
  `ccbr_abnormal_cell_count` INT NULL ,
  `ccbr_neutrophil_count` INT NULL ,
  `ccbr_date_bone_marrow` DATE NULL ,
  `ccbr_bone_marrow_cellularity` INT NULL ,
  `ccbr_abnormal_infiltrate_present` VARCHAR(45) NULL ,
  `ccbr_abnormal_infiltrate_details` TEXT NULL ,
  `ccbr_percent_blast_cells` INT NULL ,
  `ccbr_dysplasia` VARCHAR(45) NULL ,
  `ccbr_erythropoiesis` VARCHAR(45) NULL ,
  `ccbr_mylopoiesis` VARCHAR(45) NULL ,
  `ccbr_megakaryopoiesis` VARCHAR(45) NULL ,
  `event_master_id` INT NULL DEFAULT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATE NOT NULL ,   
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

-- Form: ed_ccbr_lab_cbc_bone_marrows
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_wbc_count', 'integer',  NULL , '0', '', '', '', 'ccbr wbc count', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_platelet_count', 'integer',  NULL , '0', '', '', '', 'ccbr platelet count', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_ldh_level', 'integer',  NULL , '0', '', '', '', 'ccbr ldh level', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_abnormal_cell_count', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr abnormal cell count', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_neutrophil_count', 'integer',  NULL , '0', '', '', '', 'ccbr neutrophil count', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_bone_marrow_cellularity', 'integer',  NULL , '0', '', '', '', 'ccbr bone marrow cellularity', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_abnormal_infiltrate_present', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr abnormal infiltrate present', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_abnormal_infiltrate_details', 'input',  NULL , '0', '', '', '', 'ccbr abnormal infiltrate details', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_percent_blast_cells', 'integer',  NULL , '0', '', '', '', 'ccbr percent blast cells', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_dysplasia', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr dysplasia', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_erythropoiesis', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr erythropoiesis', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_mylopoiesis', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr mylopoiesis', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_megakaryopoiesis', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr megakaryopoiesis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_wbc_count' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr wbc count' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_platelet_count' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr platelet count' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_ldh_level' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr ldh level' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_abnormal_cell_count' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr abnormal cell count' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_neutrophil_count' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr neutrophil count' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_bone_marrow_cellularity' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr bone marrow cellularity' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_abnormal_infiltrate_present' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr abnormal infiltrate present' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_abnormal_infiltrate_details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr abnormal infiltrate details' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_percent_blast_cells' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr percent blast cells' AND `language_tag`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_dysplasia' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr dysplasia' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_erythropoiesis' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr erythropoiesis' AND `language_tag`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_mylopoiesis' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr mylopoiesis' AND `language_tag`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cbc_bone_marrows' AND `field`='ccbr_megakaryopoiesis' AND `type`='select' AND `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr megakaryopoiesis' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '3', '99', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');


-- Immunophenotype

-- LANGUAGE UPDATES
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr CD34', 'CD34', ''),
('ccbr HLA-DR', 'HLA-DR', ''),
('ccbr CD19', 'CD19', ''),
('ccbr CD20', 'CD20', ''),
('ccbr CD22', 'CD22', ''),
('ccbr CD23', 'CD23', ''),
('ccbr kappa', 'Kappa', ''),
('ccbr lambda', 'Lambda', ''),
('ccbr CD2', 'CD2', ''),
('ccbr CD3', 'CD3', ''),
('ccbr CD4', 'CD4', ''),
('ccbr CD8', 'CD8', ''),
('ccbr CD1', 'CD1', ''),
('ccbr CD5', 'CD5', ''),
('ccbr CD7', 'CD7', ''),
('ccbr CD13', 'CD13', ''),
('ccbr CD33', 'CD33', ''),
('ccbr CD15', 'CD15', ''),
('ccbr CD14', 'CD14', ''),
('ccbr CD11c', 'CD11c', ''),
('ccbr CD117', 'CD117', ''),
('ccbr CD64', 'CD64', ''),
('ccbr CD41', 'CD41', ''),
('ccbr CD61', 'CD61', ''),
('ccbr cyto CD79a', 'Cyto CD79a', ''),
('ccbr cyto CD3', 'Cyto CD3', ''),
('ccbr cyto MPO', 'Cyto MPO', ''),
('ccbr cyto mu', 'Cyto MU', ''),
('ccbr cyto CD22', 'Cyto CD22', ''),
('ccbr TdT', 'TdT', '');

CREATE TABLE `ed_ccbr_lab_immunophenotypes` (
`id` INT NOT NULL AUTO_INCREMENT ,
`ccbr_CD34` CHAR(3) NULL ,
`ccbr_HLA-DR` CHAR(3) NULL ,
`ccbr_CD19` CHAR(3) NULL ,
`ccbr_CD20` CHAR(3) NULL ,
`ccbr_CD22` CHAR(3) NULL ,
`ccbr_CD23` CHAR(3) NULL ,
`ccbr_kappa` CHAR(3) NULL ,
`ccbr_lambda` CHAR(3) NULL ,
`ccbr_CD2` CHAR(3) NULL ,
`ccbr_CD3` CHAR(3) NULL ,
`ccbr_CD4` CHAR(3) NULL ,
`ccbr_CD8` CHAR(3) NULL ,
`ccbr_CD1` CHAR(3) NULL ,
`ccbr_CD5` CHAR(3) NULL ,
`ccbr_CD7` CHAR(3) NULL ,
`ccbr_CD13` CHAR(3) NULL ,
`ccbr_CD33` CHAR(3) NULL ,
`ccbr_CD15` CHAR(3) NULL ,
`ccbr_CD14` CHAR(3) NULL ,
`ccbr_CD11c` CHAR(3) NULL ,
`ccbr_CD117` CHAR(3) NULL ,
`ccbr_CD64` CHAR(3) NULL ,
`ccbr_CD41` CHAR(3) NULL ,
`ccbr_CD61` CHAR(3) NULL ,
`ccbr_cyto_CD79a` CHAR(3) NULL ,
`ccbr_cyto_CD3` CHAR(3) NULL ,
`ccbr_cyto_MPO` CHAR(3) NULL ,
`ccbr_cyto_mu` CHAR(3) NULL ,
`ccbr_cyto_CD22` CHAR(3) NULL ,
`ccbr_TdT` CHAR(3) NULL ,
  `deleted` TINYINT UNSIGNED NOT NULL DEFAULT 0 ,
  `event_master_id` INT NULL DEFAULT NULL , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `ed_ccbr_lab_immunophenotypes_revs` (
`id` INT NOT NULL ,
`ccbr_CD34` CHAR(3) NULL ,
`ccbr_HLA-DR` CHAR(3) NULL ,
`ccbr_CD19` CHAR(3) NULL ,
`ccbr_CD20` CHAR(3) NULL ,
`ccbr_CD22` CHAR(3) NULL ,
`ccbr_CD23` CHAR(3) NULL ,
`ccbr_kappa` CHAR(3) NULL ,
`ccbr_lambda` CHAR(3) NULL ,
`ccbr_CD2` CHAR(3) NULL ,
`ccbr_CD3` CHAR(3) NULL ,
`ccbr_CD4` CHAR(3) NULL ,
`ccbr_CD8` CHAR(3) NULL ,
`ccbr_CD1` CHAR(3) NULL ,
`ccbr_CD5` CHAR(3) NULL ,
`ccbr_CD7` CHAR(3) NULL ,
`ccbr_CD13` CHAR(3) NULL ,
`ccbr_CD33` CHAR(3) NULL ,
`ccbr_CD15` CHAR(3) NULL ,
`ccbr_CD14` CHAR(3) NULL ,
`ccbr_CD11c` CHAR(3) NULL ,
`ccbr_CD117` CHAR(3) NULL ,
`ccbr_CD64` CHAR(3) NULL ,
`ccbr_CD41` CHAR(3) NULL ,
`ccbr_CD61` CHAR(3) NULL ,
`ccbr_cyto_CD79a` CHAR(3) NULL ,
`ccbr_cyto_CD3` CHAR(3) NULL ,
`ccbr_cyto_MPO` CHAR(3) NULL ,
`ccbr_cyto_mu` CHAR(3) NULL ,
`ccbr_cyto_CD22` CHAR(3) NULL ,
`ccbr_TdT` CHAR(3) NULL ,
  `event_master_id` INT NULL DEFAULT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATE NOT NULL ,    
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_HLA-DR', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr HLA-DR', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD34', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD34', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD19', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD19', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD20', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD20', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD22', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD22', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD23', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD23', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_kappa', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr kappa', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_lambda', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr lambda', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD2', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD2', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD3', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD3', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD4', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD4', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD8', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD8', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD1', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD1', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD5', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD5', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD7', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD7', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD13', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD13', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD33', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD33', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD15', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD15', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD14', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD14', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD11c', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD11c', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD117', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD117', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_TdT', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr TdT', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_cyto_CD22', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr cyto CD22', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_cyto_mu', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr cyto mu', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_cyto_MPO', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr cyto MPO', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_cyto_CD3', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr cyto CD3', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_cyto_CD79a', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr cyto CD79a', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD61', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD61', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD41', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD41', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD64', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr CD64', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_HLA-DR' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr HLA-DR' AND `language_tag`=''), '3', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD34' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD34' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD19' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD19' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD20' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD20' AND `language_tag`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD22' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD22' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD23' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD23' AND `language_tag`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_kappa' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr kappa' AND `language_tag`=''), '3', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_lambda' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr lambda' AND `language_tag`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD2' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD2' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD3' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD3' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD4' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD4' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD8' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD8' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD1' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD1' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD5' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD5' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD7' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD7' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD13' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD13' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD33' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD33' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD15' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD15' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD14' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD14' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD11c' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD11c' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD117' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD117' AND `language_tag`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_TdT' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr TdT' AND `language_tag`=''), '3', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_cyto_CD22' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr cyto CD22' AND `language_tag`=''), '3', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_cyto_mu' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr cyto mu' AND `language_tag`=''), '3', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_cyto_MPO' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr cyto MPO' AND `language_tag`=''), '3', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_cyto_CD3' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr cyto CD3' AND `language_tag`=''), '3', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_cyto_CD79a' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr cyto CD79a' AND `language_tag`=''), '3', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD61' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD61' AND `language_tag`=''), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD41' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD41' AND `language_tag`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD64' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD64' AND `language_tag`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '3', '99', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');


-- Cytogenetics

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr +11q23', '+11q23', ''),
('ccbr t(4 11)', 't(4;11)', ''),
('ccbr t(1 19)', 't(1;19)', ''),
('ccbr t(9 22)', 't(9;22)', ''),
('ccbr t(12 21)', 't(12;21)', ''),
('ccbr t(5 14)', 't(5;14)', ''),
('ccbr +x', '+x', ''),
('ccbr +4', '+4', ''),
('ccbr +10', '+10', ''),
('ccbr +17', '+17', ''),
('ccbr +21', '+21', ''),
('ccbr +5', '+5', ''),
('ccbr +18', '+18', ''),
('ccbr t(15 17)', 't(15;17)', ''),
('ccbr inv(16) t(16 16)', 'inv(16) t(16 16)', ''),
('ccbr t(8 21)', 't(8;21)', ''),
('ccbr t(9 11)', 't(9;11)', ''),
('ccbr t(6 9)', 't(6;9)', ''),
('ccbr inv(3) t(3 3)', 'inv(3) t(3 3)', ''),
('ccbr t(1 22)', 't(1;22)', ''),
('ccbr +8', '+8', ''),
('ccbr -7', '-7', ''),
('ccbr inversion', 'Inversion', ''),
('ccbr diploid', 'Diploid', ''),
('ccbr other', 'Other', ''),
('ccbr -5 5q', '-5;5q', ''),
('ccbr translocation', 'Translocation', ''),
('ccbr hypodiploid less 44', 'Hypodiploid <44', ''),
('ccbr hyperdiploid greater 44', 'Hyperdiploid >44', ''); 

CREATE TABLE `ed_ccbr_lab_cytogenetics` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `ccbr_+11q23` CHAR(3) NULL ,
  `ccbr_t(4_11)` CHAR(3) NULL ,
  `ccbr_t(1_19)` CHAR(3) NULL ,
  `ccbr_t(9_22)` CHAR(3) NULL ,
  `ccbr_t(12_21)` CHAR(3) NULL ,
  `ccbr_t(5_14)` CHAR(3) NULL ,
  `ccbr_+x` CHAR(3) NULL ,
  `ccbr_+4` CHAR(3) NULL ,
  `ccbr_+10` CHAR(3) NULL ,
  `ccbr_+17` CHAR(3) NULL ,
  `ccbr_+21` CHAR(3) NULL ,
  `ccbr_+5` CHAR(3) NULL ,
  `ccbr_+18` CHAR(3) NULL ,
  `ccbr_t(15_17)` CHAR(3) NULL ,
  `ccbr_inv(16)_t(16_16)` CHAR(3) NULL ,
  `ccbr_t(8_21)` CHAR(3) NULL ,
  `ccbr_t(9_11)` CHAR(3) NULL ,
  `ccbr_t(6_9)` CHAR(3) NULL ,
  `ccbr_inv(3)_t(3_3)` CHAR(3) NULL ,
  `ccbr_t(1_22)` CHAR(3) NULL ,
  `ccbr_+8` CHAR(3) NULL ,
  `ccbr_-7` CHAR(3) NULL ,
  `ccbr_-5_5q` CHAR(3) NULL ,
  `ccbr_hypodiploid_less_44` CHAR(3) NULL ,
  `ccbr_hypodiploid_greater_44` CHAR(3) NULL ,
  `deleted` TINYINT UNSIGNED NOT NULL DEFAULT 0 ,
  `event_master_id` INT NULL DEFAULT NULL , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `ed_ccbr_lab_cytogenetics_revs` (
  `id` INT NOT NULL ,
  `ccbr_+11q23` CHAR(3) NULL ,
  `ccbr_t(4_11)` CHAR(3) NULL ,
  `ccbr_t(1_19)` CHAR(3) NULL ,
  `ccbr_t(9_22)` CHAR(3) NULL ,
  `ccbr_t(12_21)` CHAR(3) NULL ,
  `ccbr_t(5_14)` CHAR(3) NULL ,
  `ccbr_+x` CHAR(3) NULL ,
  `ccbr_+4` CHAR(3) NULL ,
  `ccbr_+10` CHAR(3) NULL ,
  `ccbr_+17` CHAR(3) NULL ,
  `ccbr_+21` CHAR(3) NULL ,
  `ccbr_+5` CHAR(3) NULL ,
  `ccbr_+18` CHAR(3) NULL ,
  `ccbr_t(15_17)` CHAR(3) NULL ,
  `ccbr_inv(16)_t(16_16)` CHAR(3) NULL ,
  `ccbr_t(8_21)` CHAR(3) NULL ,
  `ccbr_t(9_11)` CHAR(3) NULL ,
  `ccbr_t(6_9)` CHAR(3) NULL ,
  `ccbr_inv(3)_t(3_3)` CHAR(3) NULL ,
  `ccbr_t(1_22)` CHAR(3) NULL ,
  `ccbr_+8` CHAR(3) NULL ,
  `ccbr_-7` CHAR(3) NULL ,
  `ccbr_-5_5q` CHAR(3) NULL ,
  `ccbr_hypodiploid_less_44` CHAR(3) NULL ,
  `ccbr_hypodiploid_greater_44` CHAR(3) NULL ,
  `event_master_id` INT NULL DEFAULT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATE NOT NULL ,    
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+11q23', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +11q23', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(4_11)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(4 11)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(1_19)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(1 19)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(9_22)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(9 22)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(12_21)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(12 21)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(5_14)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(5 14)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+x', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +x', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+4', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +4', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+10', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +10', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+17', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +17', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+21', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +21', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+5', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +5', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+18', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +18', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(15_17)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(15 17)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_inv(16)_t(16_16)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr inv(16) t(16 16)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(8_21)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(8 21)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(9_11)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(9 11)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(6_9)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(6 9)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_inv(3)_t(3_3)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr inv(3) t(3 3)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_t(1_22)', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr t(1 22)', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_+8', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr +8', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_-7', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr -7', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_-5_5q', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr -5 5q', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_hypodiploid_less_44', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr hypodiploid less 44', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cytogenetics', 'ccbr_hyperdiploid_greater_44', 'yes_no',  NULL , '0', '', 'n', '', 'ccbr hyperdiploid greater 44', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+11q23' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +11q23' AND `language_tag`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(4_11)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(4 11)' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(1_19)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(1 19)' AND `language_tag`=''), '1', '1', 'ccbr translocation', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(9_22)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(9 22)' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(12_21)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(12 21)' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(5_14)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(5 14)' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+x' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +x' AND `language_tag`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+4' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +4' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+10' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +10' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+17' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +17' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+21' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +21' AND `language_tag`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+5' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +5' AND `language_tag`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+18' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +18' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(15_17)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(15 17)' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_inv(16)_t(16_16)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr inv(16) t(16 16)' AND `language_tag`=''), '3', '1', 'ccbr inversion', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(8_21)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(8 21)' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(9_11)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(9 11)' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(6_9)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(6 9)' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_inv(3)_t(3_3)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr inv(3) t(3 3)' AND `language_tag`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_t(1_22)' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr t(1 22)' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+8' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr +8' AND `language_tag`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_-7' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr -7' AND `language_tag`=''), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_-5_5q' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr -5 5q' AND `language_tag`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_hypodiploid_less_44' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr hypodiploid less 44' AND `language_tag`=''), '3', '3', 'ccbr diploid', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_hyperdiploid_greater_44' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr hyperdiploid greater 44' AND `language_tag`=''), '3', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '3', '99', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');


-- =============================================================================== -- 
-- 							Clinical:Family History
-- =============================================================================== -- 

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr disease site', 'Disease Site', '');

-- Disable all coding systems
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE `family_histories`
	ADD COLUMN `ccbr_disease_site` INT(11) NULL DEFAULT NULL AFTER `family_domain` ;
	
ALTER TABLE `family_histories_revs`
	ADD COLUMN `ccbr_disease_site` INT(11) NULL DEFAULT NULL AFTER `family_domain` ;

-- TODO: Fix DX list	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'FamilyHistory', 'family_histories', 'ccbr_disease_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') , '0', '', '', '', 'ccbr disease site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='ccbr_disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr disease site' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- =============================================================================== -- 
-- 							Clinical:Reproductive History
-- =============================================================================== -- 


-- =============================================================================== -- 
-- 							Inventory:Collection
-- =============================================================================== -- 
