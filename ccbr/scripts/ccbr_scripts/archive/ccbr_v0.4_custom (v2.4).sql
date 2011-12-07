-- CCBR Customization Script
-- Version: v0.4
-- ATiM Version: v2.4.0

-- =============================================================================== -- 
-- 								CORE
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.4', ''); 

-- Custom Domain - Treating Physician
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'paul rogers','Paul Rogers','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'sheila pritchard','Sheila Pritchard','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'juliette hukin','Juliette Hukin','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'chris fryer','Chris Fryer','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'jeff davis','Jeff Davis','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'david dix','David Dix','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'mason bond','Mason Bond','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'john wu','John Wu','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'suzanne vercauteren','Suzanne Vercauteren','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'lucy turnham','Lucy Turnham','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'caron strahlendorf','Caron Strahlendorf','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'roona sinha','Roona Sinha','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'kirk schultz','Kirk Schultz','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'jacob rozmus','Jacob Rozmus','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr treating physician'),'rod rassekh','Rod Rassekh','',0,1,'2011-10-28 13:12:57',1,'2011-10-28 13:12:57',1,0);

-- Custom Domain - Treating Physician
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`,`created`,`created_by`,`modified`,`modified_by`,`deleted`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'saima alvi','Saima Alvi','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'tanya brown','Tanya Brown','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'jessica halparin','Jessica Halparin','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'melissa harvey','Melissa Harvey','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'nina rolf','Nina Rolf','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'sarah steed','Sarah Steed','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'anne van eyssen','Anne Van Eyssen','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr person consenting'),'tamsin tarling','Tamsin Tarling','',0,1,'2011-10-28 13:09:48',1,'2011-10-28 13:09:48',1,0);

-- Fix Participant Identifer validation
UPDATE `structure_validations` SET `rule`='/^BD[0-9]+$/' WHERE `rule` = '/^BD-[0-9]+$/' AND `language_message` = 'ccbr error participant identifier';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr error participant identifier', 'Error - Participant Identifier must begin with BD then integer values', ''),
('ccbr hematologist', 'Hematologist', '');
	
-- Add hematologist to info source drop down list
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("hematologist", "ccbr hematologist");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="information_source"),  (SELECT id FROM structure_permissible_values WHERE value="hematologist" AND language_alias="ccbr hematologist"), "4", "1");

-- =============================================================================== -- 
-- 								ANNOTATION
-- =============================================================================== -- 

-- Update forms with new field type for unknown checkbox (yesnounknown)

UPDATE `structure_fields` SET `type` = 'y_n_u' WHERE `tablename` = 'ed_ccbr_lab_immunophenotypes';
UPDATE `structure_fields` SET `type` = 'y_n_u' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics';

-- Enable DX Nature on Add form as readonly so default value will save
UPDATE structure_formats SET `flag_add`='1', `flag_add_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');

-- Fix Solid tumour layout
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='26' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_ccbr_solid_tumour' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');


-- =============================================================================== -- 
-- 								TREATMENT
-- =============================================================================== -- 

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("syngenic", "ccbr syngenic");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transplant_type"),  (SELECT id FROM structure_permissible_values WHERE value="syngenic" AND language_alias="ccbr syngenic"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr syngenic', 'Syngenic', '');
	
-- =============================================================================== -- 
-- 								PROTOCOL
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('radiotherapy', 'Radiotherapy', ''),
('other medication', 'Other Medication', ''),
('combination', 'Combination', '');
	
-- Add new protocol types
INSERT INTO `protocol_controls` (`tumour_group`, `type`, `detail_tablename`, `form_alias`) VALUES
('ccbr', 'radiotherapy', 'pd_ccbr_radiotherapy', 'pd_ccbr_radiotherapy'),
('ccbr', 'other medication', 'pd_ccbr_other_medication', 'pd_ccbr_other_medication'),
('ccbr', 'combination', 'pd_ccbr_combination', 'pd_ccbr_combination');

-- Add new structures
INSERT INTO `structures` (`alias`, `description`) VALUES
('pd_ccbr_radiotherapy', ''),
('pd_ccbr_other_medication', ''),
('pd_ccbr_combination', '');

-- Create new protocol detail tables
CREATE TABLE `pd_ccbr_radiotherapy` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `deleted` TINYINT UNSIGNED NOT NULL DEFAULT 0 ,
  `protocol_master_id` INT NULL DEFAULT NULL , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `pd_ccbr_radiotherapy_revs` (
  `id` INT NOT NULL ,
  `protocol_master_id` INT NULL DEFAULT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATE NOT NULL ,    
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci; 

CREATE TABLE `pd_ccbr_other_medication` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `deleted` TINYINT UNSIGNED NOT NULL DEFAULT 0 ,
  `protocol_master_id` INT NULL DEFAULT NULL , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `pd_ccbr_other_medication_revs` (
  `id` INT NOT NULL ,
  `protocol_master_id` INT NULL DEFAULT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATE NOT NULL ,    
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci; 

CREATE TABLE `pd_ccbr_combination` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `deleted` TINYINT UNSIGNED NOT NULL DEFAULT 0 ,
  `protocol_master_id` INT NULL DEFAULT NULL , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `pd_ccbr_combination_revs` (
  `id` INT NOT NULL ,
  `protocol_master_id` INT NULL DEFAULT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATE NOT NULL ,    
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci; 

-- Add master fields to detail form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='pd_ccbr_radiotherapy'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_radiotherapy'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_radiotherapy'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_radiotherapy'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='arm' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_radiotherapy'), (SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='tumour_group' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour group' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_radiotherapy'), (SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='pd_ccbr_other_medication'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_other_medication'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_other_medication'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_other_medication'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='arm' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_other_medication'), (SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='tumour_group' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour group' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_other_medication'), (SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='pd_ccbr_combination'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_combination'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_combination'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_combination'), (SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='arm' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_combination'), (SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='tumour_group' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour group' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_ccbr_combination'), (SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

-- =============================================================================== -- 
-- 								DIAGNOSIS
-- =============================================================================== -- 

-- Set age at dx fields to readonly
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_leukemia') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_leukemia') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_leukemia') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_leukemia') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
