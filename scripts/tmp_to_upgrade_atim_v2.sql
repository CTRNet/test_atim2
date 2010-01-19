DELETE FROM `i18n` WHERE `en` = '' AND `fr` = '';

UPDATE `i18n` SET `id` = 'date created',
`fr` = '' WHERE `i18n`.`id` = 'Date Created' AND `i18n`.`page_id` = 'global';

DELETE FROM `i18n` WHERE `id` IN ('xApplication');

INSERT INTO `i18n` (`id`,`page_id`,`en`,`fr`) VALUES
('may', 'global', 'May', 'Mai'),
('define_date_format', 'global', 'Date Format', ''),
('define_csv_separator', 'global', 'File Export Separator', ''),
('define_show_summary', 'global', 'Show Summary', ''),
('config_debug', 'global', 'Debug Mode', ''),
('atim version', 'global', 'ATiM Version', ''),
('version number', 'global', 'Version Number', ''),
('date installed', 'global', 'Date Installed', ''),
('build number', 'global', 'Build Number', '');

-- Fix all validations with notEmpty
UPDATE `structure_validations` SET `flag_empty` = '0' WHERE `id` =36 LIMIT 1 ;

-- Fixed spelling error on field
ALTER TABLE `structure_validations` CHANGE `modifed_by` `modified_by` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT ''

UPDATE `pages` SET `language_title` = 'credits_title',
`language_body` = 'credits_body' WHERE `pages`.`id` = 'credits';

UPDATE `structure_fields` SET `field` = 'pagination' WHERE `structure_fields`.`id` =94;

INSERT INTO `structure_value_domains` (`id` ,`domain_name` ,`override` ,`category`) VALUES
(182, 'pagination', 'open', 'administration');

INSERT INTO `structure_permissible_values` (`id` ,`value` ,`language_alias`) VALUES
(830, '5', '5'),
(831, '10', '10'),
(832, '20', '20'),
(833, '50', '50');

INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`) VALUES
(NULL , '182', '830', '1', 'yes', '5'),
(NULL , '182', '831', '2', 'yes', '10'),
(NULL , '182', '832', '3', 'yes', '20'),
(NULL , '182', '833', '4', 'yes', '50');

UPDATE `structure_fields` SET `structure_value_domain` = '182' WHERE `structure_fields`.`id` =94;

-- Cleanup installed version form and table
UPDATE `menus` SET `language_title` = 'atim version',
`language_description` = 'atim version' WHERE `menus`.`id` = 'core_CAN_70';
UPDATE `menus` SET `use_link` = '/administrate/versions/detail/' WHERE `menus`.`id` = 'core_CAN_70';
UPDATE `structure_fields` SET `language_label` = 'version number', `type` = 'input-readonly' WHERE `structure_fields`.`id` =856;

ALTER TABLE `versions` CHANGE `status` `build_number` VARCHAR( 45 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

UPDATE `structure_fields` SET `old_id` = 'CAN-856',
`plugin` = 'Administrate',
`tablename` = 'versions' WHERE `structure_fields`.`id` =856;

UPDATE `structure_fields` SET `old_id` = 'CAN-857',
`plugin` = 'Administrate',
`tablename` = 'versions',
`language_label` = 'date installed' WHERE `structure_fields`.`id` =857;

UPDATE `structure_fields` SET `old_id` = 'CAN-858',
`plugin` = 'Administrate',
`tablename` = 'versions',
`field` = 'build_number',
`language_label` = 'build number',
`type` = 'input-readonly' WHERE `structure_fields`.`id` =858;

DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1805;
DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1806;
DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1807;
DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1808;
DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1809;
DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1810;
DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1811;
DELETE FROM `atim2`.`structure_formats` WHERE `structure_formats`.`id` = 1812;

UPDATE `structure_formats` SET `old_id` = '',
`structure_old_id` = 'CAN-155',
`structure_field_old_id` = 'CAN-856',
`display_column` = '1',
`display_order` = '1',
`language_heading` = 'current version information',
`language_tag` = '',
`type` = '',
`flag_detail` = '1' WHERE `structure_formats`.`id` =196;

UPDATE `structure_formats` SET `structure_old_id` = 'CAN-155',
`structure_field_id` = '857',
`structure_field_old_id` = 'CAN-857',
`display_order` = '3',
`language_help` = '' WHERE `structure_formats`.`id` =1803;

UPDATE `structure_formats` SET `structure_field_id` = '858',
`display_order` = '2',
`language_help` = '' WHERE `structure_formats`.`id` =1804;

UPDATE `atim2`.`structure_fields` SET `language_label` = '',
`language_tag` = 'build number' WHERE `structure_fields`.`id` =858;
