-- All DML related updates go here

/*
	Module: Core
	Description: 
*/

-- Add text to the footer links present on each page (Credits, About, Installation)
UPDATE `pages` SET `language_title` = 'about_title', `language_body` = 'about_body' WHERE `pages`.`id` = 'about';
UPDATE `pages` SET `language_title` = 'installation_title', `language_body` = 'installation_body' WHERE `pages`.`id` = 'installation';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('about_title', '', 'About', ''),
('about_body', '', 'The Canadian Tumour Repository Network (CTRNet) is a translational cancer research resource, funded by Canadian Institutes of Health Research, that furthers Canadian health research by linking cancer researchers with provincial tumour banks.', ''),
('credits_title', '', 'Credits', ''),
('credits_body', '', 'ATiM is an open-source project development by leading tumour banks across Canada. For more information on our development team, questions, comments or suggestions please visit our website at http://www.ctrnet.ca', ''),
('installation_title', '', 'Installation', ''),
('installation_body', '', 'To view your installed version number open the Administration Tool and select ATiM Version from the first menu. ATiM is built on the CakePHP framework (www.cakephp.org).', '');

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.1', `date_installed` = '2010-02-09 12:13:43', `build_number` = '954'
WHERE `versions`.`id` =1;

/*
	Module: Clinical
	Description: 
*/

-- Add Clinical Annotation System Error Page

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_clin_system_error', 1, 'system error', 'a system error has been detected', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add image upload field to the research Study form
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`,
`type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`,
`created`, `created_by`, `modified`, `modified_by`) VALUES
(NULL , '', 'CANM-00024', 'Clinicalannotation', 'EventDetail', '', 'file_name', 'Picture', '', 'file', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`,
`display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`,
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`,
`flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`,
`created_by`, `modified`, `modified_by`) VALUES 
(NULL , 'CAN-999-999-000-999-65_CANM-00024', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-65'), 'CAN-999-999-000-999-65', '908', 'CANM-00024', '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Updated clinical menu order to better match user workflow.
UPDATE `menus` SET `display_order` = '4' WHERE `menus`.`id` = 'clin_CAN_4';
UPDATE `menus` SET `display_order` = '3' WHERE `menus`.`id` = 'clin_CAN_5';
UPDATE `menus` SET `display_order` = '1' WHERE `menus`.`id` = 'clin_CAN_6';
UPDATE `menus` SET `display_order` = '5' WHERE `menus`.`id` = 'clin_CAN_75';
UPDATE `menus` SET `display_order` = '7' WHERE `menus`.`id` = 'clin_CAN_10';
UPDATE `menus` SET `display_order` = '10' WHERE `menus`.`id` = 'clin_CAN_25';
UPDATE `menus` SET `display_order` = '9' WHERE `menus`.`id` = 'clin_CAN_26';
UPDATE `menus` SET `display_order` = '8' WHERE `menus`.`id` = 'clin_CAN_68';
UPDATE `menus` SET `display_order` = '12' WHERE `menus`.`id` = 'clin_CAN_67';
UPDATE `menus` SET `display_order` = '1' WHERE `menus`.`id` = 'clin_CAN_31';
UPDATE `menus` SET `display_order` = '2' WHERE `menus`.`id` = 'clin_CAN_28';
UPDATE `menus` SET `display_order` = '3' WHERE `menus`.`id` = 'clin_CAN_30';
UPDATE `menus` SET `display_order` = '4' WHERE `menus`.`id` = 'clin_CAN_33';
UPDATE `menus` SET `display_order` = '5' WHERE `menus`.`id` = 'clin_CAN_27';
UPDATE `menus` SET `display_order` = '6' WHERE `menus`.`id` = 'clin_CAN_69';
UPDATE `menus` SET `display_order` = '7' WHERE `menus`.`id` = 'clin_CAN_32';
UPDATE `menus` SET `use_link` = '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%'  WHERE `menus`.`id` = 'clin_CAN_4';

-- Hide Adverse Events and Protocol menu option from Annotation (unused)
UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_32';
UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_69';


-- Updates to the misc identifiers section
DELETE FROM `misc_identifiers`;
DELETE FROM `misc_identifiers_revs`;
 
INSERT INTO `misc_identifier_controls` 
(`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `display_order`, `autoincrement_name`, `misc_identifier_format`) 
VALUES
(null, 'custom_identifier_hospital_nbr', 'CIHN', 'active', 0, '', ''),
(null, 'custom_identifier_insurance_nbr', 'CIIN', 'active', 1, '', ''),
(null, 'custom_identifier_breat_bank_nbr', 'CIBB', 'active', 2, 'part_ident_breat_bank_nbr', 'BR - PART [%%key_increment%%]'),
(null, 'custom_identifier_ovary_bank_nbr', 'CIOB', 'active', 3, 'part_ident_ovary_bank_nbr', 'OV_PCODE_%%key_increment%%');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('part_ident_breat_bank_nbr', 1340),
('part_ident_ovary_bank_nbr', 1232411);

DELETE FROM structure_formats WHERE structure_old_id LIKE 'CAN-999-999-000-999-8';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-34', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-34'), 'CAN-999-999-000-999-34', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-38', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-38'), 'CAN-999-999-000-999-38', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-35', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-102'), 'CAN-102', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-37', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-37'), 'CAN-999-999-000-999-37', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-36'), 'CAN-999-999-000-999-36', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structures` WHERE old_id = 'CAN-999-999-000-999-1091';
INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1091', 'incrementedmiscidentifiers', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM structure_formats WHERE structure_old_id LIKE 'CAN-999-999-000-999-1091';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-34', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-34'), 'CAN-999-999-000-999-34', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-38', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-38'), 'CAN-999-999-000-999-38', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-35', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-102'), 'CAN-102', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-37', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-37'), 'CAN-999-999-000-999-37', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-36'), 'CAN-999-999-000-999-36', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_fields` 
SET `structure_value_domain` = '0',
type = 'select',
setting = null
WHERE old_id IN ('CAN-999-999-000-999-34');

DELETE FROM `structure_validations`  WHERE `structure_field_old_id` = 'CAN-999-999-000-999-35' AND `rule` = 'notEmpty';
INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '0', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structures` WHERE old_id = 'CAN-999-999-000-999-1092';
INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1092', 'miscidentifierssummary', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM structure_formats WHERE structure_old_id LIKE 'CAN-999-999-000-999-1092';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-4', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-4'), 'CAN-999-999-000-999-4', 0, 1, '', '1', 'participant', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-1', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1'), 'CAN-999-999-000-999-1', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-295', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-295'), 'CAN-999-999-000-999-295', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-2', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-2'), 'CAN-999-999-000-999-2', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-34', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-34'), 'CAN-999-999-000-999-34', 0, 10, '', '1', 'participant identifier', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-38', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-38'), 'CAN-999-999-000-999-38', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-35', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM  `i18n` WHERE `id` LIKE 'misc identifiers';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('misc identifiers', 'global', 'Identifiers', 'Identifiants');

DELETE FROM  `i18n` WHERE `id` LIKE 'custom_identifier_%';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('custom_identifier_hospital_nbr', 'global', 'Hospital #', 'Hopital #'),
('custom_identifier_insurance_nbr', 'global', 'Insurance #', 'Assurance #'),
('custom_identifier_breat_bank_nbr', 'global', 'Breast Bank ID', 'Banque Sein #'),
('custom_identifier_ovary_bank_nbr', 'global', 'Ovary Bank ID', 'Banque Ovaire #');

DELETE FROM  `i18n` WHERE `id` LIKE 'value is required';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('value is required', 'global', 'The value is required!', 'La valeur est requise!');

