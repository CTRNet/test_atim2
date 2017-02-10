-- BCCH Customization Script
-- Version 0.6.2
-- ATiM Version: 2.6.7

use atim_ccbr_dev;

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.6.3", '');

-- ============================================================================
-- BB-209
-- ============================================================================

UPDATE structure_formats
SET `flag_edit` = 0, `flag_batchedit` = 0
WHERE `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'AliquotMaster' AND `tablename` = 'aliquot_masters' AND `field` ='sop_master_id' AND `type` = 'select');

-- ============================================================================
-- BB-225
-- ============================================================================

INSERT INTO misc_identifier_controls
(`misc_identifier_name`, `flag_active`, `display_order`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('EoE ID', 1, 16, NULL, 1, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('EoE ID', 'EoE ID', 'EoE ID');

-- ============================================================================
-- BB-226
-- ============================================================================

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Swab Locations', 1, 50, 'Inventory - Swab', 4, 4);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'buccal', 'Buccal', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'cervix', 'Cervix', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'vagina', 'Vagina', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Swab Locations'), 'throat', 'Throat', '', 0, 1, NOW(), 1, NOW(), 1, 0);

UPDATE structure_value_domains 
SET `source` = 'StructurePermissibleValuesCustom::getCustomDropDown(\'Swab Locations\')', `override`='open'
WHERE `domain_name`= 'ccbr_swab_location';

DELETE FROM structure_value_domains_permissible_values
WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_swab_location');

-- ============================================================================
-- BB-230
-- ============================================================================

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`,
`flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'view_aliquot_joined_to_sample_and_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model` = 'AliquotMaster' AND `tablename`='aliquot_masters' AND `field` = 'study_summary_id' AND `type`='select'), 0, 2,
0, 0, 0, 0, 0,
0, 0, 0, 0, 1, 0,
0, 0, 0, 0, 1,
0, 0, 1, 0, 0, 0);

-- Demonliazation

-- Participant Table --

-- First Name --

UPDATE `participants` SET `first_name` = cast(SHA1(`first_name`) AS CHAR(20) CHARACTER SET utf8);

-- Middle Name --

UPDATE `participants` SET `middle_name` = cast(SHA1(`middle_name`) AS CHAR(20) CHARACTER SET utf8);

-- Last Name --

UPDATE `participants` SET `last_name` = cast(SHA1(`last_name`) AS CHAR(20) CHARACTER SET utf8);

-- Date of Birth --

UPDATE `participants` SET `date_of_birth` = DATE_ADD(`date_of_birth`, INTERVAL FLOOR(1000*RAND()) DAY);

-- Parent or Guardian Name --

UPDATE `participants` SET `ccbr_parent_guardian_name` = cast(SHA1(`ccbr_parent_guardian_name`) AS CHAR(20) CHARACTER SET utf8);

-- Participant log tables --

UPDATE `participants`, `participants_revs`
SET `participants_revs`.`first_name` = `participants`.`first_name`,
`participants_revs`.`middle_name` = `participants`.`middle_name`,
`participants_revs`.`last_name` = `participants`.`last_name`,
`participants_revs`.`date_of_birth` = `participants`.`date_of_birth`,
`participants_revs`.`ccbr_parent_guardian_name` = `participants`.`ccbr_parent_guardian_name`
WHERE `participants`.`id` = `participants_revs`.`id`;

-- Identifiers Table --

-- COG --

UPDATE `misc_identifiers` SET `identifier_value` = CAST(SHA1(`identifier_value`) AS CHAR(6) CHARACTER SET UTF8)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM `misc_identifier_controls` WHERE `misc_identifier_name` = 'COG Registration');

-- MRN --

UPDATE `misc_identifiers` SET `identifier_value` = FLOOR(10000000*RAND())
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'MRN');

-- PHN --

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(1000*RAND()), ' ', FLOOR(1000*RAND()), ' ', FLOOR(10000*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

-- Identifiers Revs Table --

UPDATE `misc_identifiers`, `misc_identifiers_revs`
SET `misc_identifiers_revs`.`identifier_value` = `misc_identifiers`.`identifier_value`
WHERE `misc_identifiers`.`id` = `misc_identifiers_revs`.`id`;

-- Participants Contact Information --

-- Contact Name


UPDATE `participant_contacts` SET `contact_name` = cast(SHA1(`contact_name`) AS CHAR(50) CHARACTER SET utf8);


-- Email Address

UPDATE `participant_contacts` SET `ccbr_email` = cast(SHA1(`ccbr_email`) AS CHAR(45) CHARACTER SET utf8);


-- Street

UPDATE `participant_contacts` SET `street` = cast(SHA1(`street`) AS CHAR(50) CHARACTER SET utf8);

-- City

UPDATE `participant_contacts` SET `locality` = cast(SHA1(`locality`) AS CHAR(50) CHARACTER SET utf8);

-- Postal Code

UPDATE `participant_contacts` SET `mail_code` = cast(SHA1(`mail_code`) AS CHAR(10) CHARACTER SET utf8);

-- Primary Phone Number

UPDATE `participant_contacts` SET `phone` = cast(SHA1(`phone`) AS CHAR(15) CHARACTER SET utf8);

-- Secondary Phone Number

UPDATE `participant_contacts` SET `phone_secondary` = cast(SHA1(`phone_secondary`) AS CHAR(30) CHARACTER SET utf8);

-- Participants Contact Log Table --

UPDATE `participant_contacts`, `participant_contacts_revs`
SET `participant_contacts_revs`.`contact_name` = `participant_contacts`.`contact_name`,
`participant_contacts_revs`.`ccbr_email` = `participant_contacts`.`ccbr_email`,
`participant_contacts_revs`.`street` = `participant_contacts`.`street`,
`participant_contacts_revs`.`locality` = `participant_contacts`.`locality`,
`participant_contacts_revs`.`mail_code` = `participant_contacts`.`mail_code`,
`participant_contacts_revs`.`phone` = `participant_contacts`.`phone`,
`participant_contacts_revs`.`phone_secondary` = `participant_contacts`.`phone_secondary`
WHERE `participant_contacts_revs`.`id` = `participant_contacts`.`id`;    

