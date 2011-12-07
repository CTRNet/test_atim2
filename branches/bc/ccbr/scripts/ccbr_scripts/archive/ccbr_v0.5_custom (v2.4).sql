-- CCBR Customization Script
-- Version: v0.5
-- ATiM Version: v2.4.0

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.5', '');

-- =============================================================================== -- 
-- 								TREATMENT
-- =============================================================================== --

-- Hide cycle data on chemo form
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='completed_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- New source fields for MRD
ALTER TABLE `txd_chemos`
	ADD COLUMN `ccbr_day8_source` VARCHAR(45) NULL AFTER `ccbr_day8_mrd` ,
	ADD COLUMN `ccbr_day15_source` VARCHAR(45) NULL AFTER `ccbr_day15_mrd` ,
	ADD COLUMN `ccbr_day29_source` VARCHAR(45) NULL AFTER `ccbr_day29_mrd` , 
	ADD COLUMN `ccbr_other_source` VARCHAR(45) NULL AFTER `ccbr_other_mrd` ;
	
ALTER TABLE `txd_chemos_revs`
	ADD COLUMN `ccbr_day8_source` VARCHAR(45) NULL AFTER `ccbr_day8_mrd` ,
	ADD COLUMN `ccbr_day15_source` VARCHAR(45) NULL AFTER `ccbr_day15_mrd` ,
	ADD COLUMN `ccbr_day29_source` VARCHAR(45) NULL AFTER `ccbr_day29_mrd` , 
	ADD COLUMN `ccbr_other_source` VARCHAR(45) NULL AFTER `ccbr_other_mrd` ;

-- Language Updates
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr blood', 'Blood', ''), 
('ccbr day15 source', 'Day 15 Source', ''), 
('ccbr day8 source', 'Day 8 Source', ''), 
('ccbr day29 source', 'Day 29 Source', ''), 
('ccbr other source', 'Other Source', ''),
('ccbr anatomical pathology', 'Anatomical Pathology', ''), 
('ccbr hem/onc clinic', 'Hem/Onc Clinic', ''),
('ccbr operating room', 'Operating Room', ''),
('ccbr anatomical pathology', 'Anatomical Pathology', ''),
('ccbr biochemistry', 'Biochemistry', ''),
('ccbr genetic laboratory', 'Genetic Laboratory', ''),
('ccbr hematopathology', 'Hematopathology', ''),
('ccbr microbiology', 'Microbiology', '');

-- Add value domain for MRD Source	
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_mrd_source', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("blood", "ccbr blood");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_mrd_source"),  (SELECT id FROM structure_permissible_values WHERE value="blood" AND language_alias="ccbr blood"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("bone marrow", "ccbr bone marrow");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_mrd_source"),  (SELECT id FROM structure_permissible_values WHERE value="bone marrow" AND language_alias="ccbr bone marrow"), "2", "1");

-- Insert fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day15_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') , '0', '', '', '', '', 'ccbr day15 source'), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day8_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') , '0', '', '', '', '', 'ccbr day8 source');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day15_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr day15 source'), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day8_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr day8 source'), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_day29_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') , '0', '', '', '', '', 'ccbr day29 source'), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ccbr_other_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source') , '0', '', '', '', '', 'ccbr other source');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day29_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr day29 source'), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_other_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_mrd_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr other source'), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- =============================================================================== -- 
-- 								COLLECTION
-- =============================================================================== --

-- Specimen Collection Sites
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'), 'anatomical pathology','Anatomical Pathology','',1,1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'),'hem/onc clinic','Hem/Onc Clinic','',2,1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'), 'operating room','Operating Room','',3,1);

-- Supplier Deptartment
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), 'anatomical pathology','Anatomical Pathology','', 1,1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), 'biochemistry','Biochemistry','', 2,1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), 'genetic laboratory','Genetic Laboratory','', 3,1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), 'hematopathology','Hematopathology','', 4,1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), 'microbiology','Microbiology','', 5,1);

-- Update banks list
UPDATE `banks` SET `name` = 'CCBR', `description` = 'Child and Family Research Institute' WHERE `banks`.`id` = 1;
INSERT INTO `banks` (`name`) VALUES ('BOAS');

-- Hide Collection SOP field
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');


-- =============================================================================== -- 
-- 								SAMPLE: BLOOD
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr titrate', 'Titrate', ''); 

-- Add Titrate to Blood Tube Type
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("titrate", "ccbr titrate");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"),  (SELECT id FROM structure_permissible_values WHERE value="titrate" AND language_alias="ccbr titrate"), "7", "1");

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- =============================================================================== -- 
-- 								ALIQUOT MASTER
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr reserved for expansion', 'Reserved for expansion', ''); 

-- New stock detail value
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("reserved for expansion", "ccbr reserved for expansion");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_in_stock_detail"),  (SELECT id FROM structure_permissible_values WHERE value="reserved for expansion" AND language_alias="ccbr reserved for expansion"), "1", "1");

-- Disable Aliquot SOP
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');