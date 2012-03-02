-- CCBR Customization Script
-- Version: v0.6
-- ATiM Version: v2.4.1

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.6', '');

-- Fix for v2.4.1 upgrade
-- You need to alter your existing treatment details table. 
-- The field "tx_master_id" should now be renamed to "treatment_master_id".

ALTER TABLE `txd_ccbr_bone_marrow_transplants` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;
ALTER TABLE `txd_ccbr_bone_marrow_transplants_revs` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;
ALTER TABLE `txd_ccbr_other_treatments` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;
ALTER TABLE `txd_ccbr_other_treatments_revs` CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NULL DEFAULT NULL  ;


-- =============================================================================== -- 
-- 								MENUS
-- =============================================================================== --

-- Enable Contacts and Identifiers
UPDATE `menus` SET `flag_active`=1 WHERE `id`='clin_CAN_26';
UPDATE `menus` SET `flag_active`=1 WHERE `id`='clin_CAN_24';

-- =============================================================================== -- 
-- 								IDENTIFIERS
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('PHN', 'PHN', ''),
	('MRN', 'MRN', ''),
	('COG Registration', 'COG Registration', ''),
	('ccbr PHN validation error', 'Validation error  - PHN must have the format: DDD DDD DDDD', ''),
	('ccbr MRN validation error', 'Validation error  - MRN must be 7 digits', ''),
	('ccbr COG validation error', 'Validation error  - COG Registration must be 6 characters', '');
	
INSERT INTO `misc_identifier_controls` VALUES 
(1, 'PHN', 1, 3, '', '', 1, 0),
(2, 'MRN', 1, 2, '', '', 1, 0),
(3, 'COG Registration', 1, 1, '', '', 1, 0);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Hide COG number on participants table
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_cog_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- =============================================================================== -- 
-- 								CONTACTS
-- =============================================================================== --

ALTER TABLE `participant_contacts`
	ADD COLUMN `ccbr_email` VARCHAR(45) NULL AFTER `relationship` ;
	
ALTER TABLE `participant_contacts_revs`
	ADD COLUMN `ccbr_email` VARCHAR(45) NULL AFTER `relationship` ;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('ccbr email', 'Email Address', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ParticipantContact', 'participant_contacts', 'ccbr_email', 'input',  NULL , '0', 'size=30', '', '', 'ccbr email', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='ccbr_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ccbr email' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- =============================================================================== -- 
-- 								DIAGNOSIS
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('ccbr_hematopatholgy', 'Hematopathology', '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("hematopatholgy", "ccbr_hematopatholgy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="dx_method"),  (SELECT id FROM structure_permissible_values WHERE value="hematopatholgy" AND language_alias="ccbr_hematopatholgy"), "5", "1");


-- =============================================================================== -- 
-- 								COLLECTION
-- =============================================================================== --

-- Hide aquisition field
UPDATE `structure_formats` SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `structure_formats` SET `flag_add`=0, `flag_edit`=0 
WHERE
	`structure_id`=(SELECT id FROM structures WHERE alias='linked_collections') AND 
	`structure_field_id`=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND 		`field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `structure_formats` SET `flag_editgrid`=0, `flag_editgrid_readonly`=0, `flag_index`=0
WHERE 
	`structure_id`=(SELECT id FROM structures WHERE alias='lab_book_derivatives_summary') AND 
	`structure_field_id`=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND 		`field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `structure_formats` SET `flag_editgrid`=0, `flag_editgrid_readonly`=0, `flag_index`=0
WHERE 
	`structure_id`=(SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary') AND 
	`structure_field_id`=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND 		`field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `structure_formats` SET `flag_summary`=0, `flag_index`=0 
WHERE 
	`structure_id`=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND 
	`structure_field_id`=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND 		`field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `structure_formats` SET `flag_summary`=0, `flag_index`=0 
WHERE 
	`structure_id`=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND 
	`structure_field_id`=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND 		`field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- =============================================================================== -- 
-- 								PROFILE
-- =============================================================================== --

-- Fix participant identifer validation to check for CCBR instead of BD
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('Parent or Legal Guardian', 'Parent or Legal Guardian', ''),
	('ccbr parent guardian name', 'Parent or Guardian Name', ''),
	('ccbr relationship to participant', 'Relationship to Participant', ''),
	('ccbr relationship other', 'If other', ''); 
	
UPDATE `structure_validations` SET `rule`='/^CCBR[0-9]+$/' WHERE `structure_field_id`=(SELECT id FROM structure_fields WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'participant_identifier');

-- Enable name fields (Title, First, Middle, Last)
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');


-- Alter table
ALTER TABLE `participants`
	ADD COLUMN `ccbr_parent_guardian_name` VARCHAR(100) NULL  AFTER `ccbr_cog_registration` ,
	ADD COLUMN `ccbr_relationship_to_participant` VARCHAR(45) NULL  AFTER `ccbr_parent_guardian_name` ,
	ADD COLUMN `ccbr_relationship_other` VARCHAR(45) NULL DEFAULT NULL  AFTER `ccbr_relationship_to_participant` ;
	
ALTER TABLE `participants_revs`
	ADD COLUMN `ccbr_parent_guardian_name` VARCHAR(100) NULL  AFTER `ccbr_cog_registration` ,
	ADD COLUMN `ccbr_relationship_to_participant` VARCHAR(45) NULL  AFTER `ccbr_parent_guardian_name` ,
	ADD COLUMN `ccbr_relationship_other` VARCHAR(45) NULL DEFAULT NULL  AFTER `ccbr_relationship_to_participant` ;


-- Add parent or guardian name field and if other field.
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ccbr_parent_guardian_name', 'input',  NULL , '0', 'size=30', '', '', 'ccbr parent guardian name', ''), 
('Clinicalannotation', 'Participant', 'participants', 'ccbr_relationship_to_participant', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='relation') , '0', 'size=30', '', '', 'ccbr relationship to participant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_parent_guardian_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ccbr parent guardian name' AND `language_tag`=''), '3', '9', 'Parent or Legal Guardian', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_relationship_to_participant' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='relation')  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ccbr relationship to participant' AND `language_tag`=''), '3', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='relation') ,  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='ccbr_relationship_to_participant' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='relation');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'part', 'ccbr_relationship_other', 'input',  NULL , '0', 'size=30', '', '', '', 'ccbr relationship other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='part' AND `field`='ccbr_relationship_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr relationship other'), '3', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_parent_guardian_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_relationship_to_participant' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='relation') AND `flag_confidential`='0');

-- =============================================================================== -- 
-- 								TREATMENT
-- =============================================================================== --

-- Fix language dropdown list
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('partial', 'Partial Response', ''),
	('complete', 'Complete Response', '');

-- Change order of chemo date fields
UPDATE structure_formats SET `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_induction_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='19' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_maintenance_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_reinduction_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- =============================================================================== -- 
-- 								SAMPLE SETUP
-- =============================================================================== --

-- Toggle existing samples types for CCBR
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(184, 167, 186);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 142, 143, 141, 144, 140);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(44, 45);

-- Reception label change
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('reception by', 'Delivery Taken By', ''),
	('ccbr sample pickup by', 'Sample Pickup By', ''),
	('ccbr sample pickup other', 'Sample Pickup By (Other)', ''),
	('ccbr reception by other', 'Delivery Taken By (Other)', '');
	

-- New fields for 'other' persons and picked up by
ALTER TABLE `specimen_details` 
	ADD COLUMN `ccbr_reception_by_other` VARCHAR(255) NULL AFTER `reception_by` ,
	ADD COLUMN `ccbr_sample_pickup_by` VARCHAR(255) NULL AFTER `ccbr_reception_by_other` ,
	ADD COLUMN `ccbr_sample_pickup_other` VARCHAR(255) NULL AFTER `ccbr_sample_pickup_by` ;

ALTER TABLE `specimen_details_revs` 
	ADD COLUMN `ccbr_reception_by_other` VARCHAR(255) NULL AFTER `reception_by` ,
	ADD COLUMN `ccbr_sample_pickup_by` VARCHAR(255) NULL AFTER `ccbr_reception_by_other` ,
	ADD COLUMN `ccbr_sample_pickup_other` VARCHAR(255) NULL AFTER `ccbr_sample_pickup_by` ;
	
-- Custom lookup values for reception by
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'laboratory staff'), 'amina karimina', 'Amina Karimina', '', 1, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'laboratory staff'), 'arnawaz kaleem', 'Arnawaz Kaleem', '', 2, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'laboratory staff'), 'gregor reid', 'Gregor Reid', '', 3, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'laboratory staff'), 'nina rolf', 'Nina Rolf', '', 4, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'laboratory staff'), 'other', 'Other', '', 5, 1);

-- Custom lookup values for pickup by

INSERT INTO `structure_value_domains` (`domain_name`, `source`) VALUES
('custom_ccbr_sample_pickup', 'StructurePermissibleValuesCustom::getCustomDropdown(\'ccbr sample pickup by\')');

INSERT INTO `structure_permissible_values_custom_controls` (`name`, `flag_active`, `values_max_length`) VALUES ('ccbr sample pickup by', 1, 50);

INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr sample pickup by'), 'amina karimina', 'Amina Karimina', '', 1, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr sample pickup by'), 'arnawaz kaleem', 'Arnawaz Kaleem', '', 2, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr sample pickup by'), 'tamsin tarling', 'Tamsin Tarling', '', 3, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'ccbr sample pickup by'), 'other', 'Other', '', 4, 1);

-- Add new fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenDetail', 'specimen_details', 'ccbr_reception_by_other', 'input',  NULL , '0', 'size=30', '', '', 'ccbr reception by other', ''), 
('Inventorymanagement', 'SpecimenDetail', 'specimen_details', 'ccbr_sample_pickup_by', 'input',  NULL , '0', 'size=30', '', '', 'ccbr sample pickup other', ''), 
('Inventorymanagement', 'SpecimenDetail', 'specimen_details', 'ccbr_sample_pickup_by', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_ccbr_sample_pickup') , '0', '', '', '', 'ccbr sample pickup by', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='ccbr_reception_by_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ccbr reception by other' AND `language_tag`=''), '1', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='ccbr_sample_pickup_by' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ccbr sample pickup other' AND `language_tag`=''), '1', '150', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='ccbr_sample_pickup_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_ccbr_sample_pickup')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr sample pickup by' AND `language_tag`=''), '1', '125', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_fields SET  `setting`='' WHERE model='Generated' AND tablename='' AND field='coll_to_rec_spent_time_msg' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');




