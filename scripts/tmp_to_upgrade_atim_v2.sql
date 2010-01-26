UPDATE `structure_validations`
SET `flag_empty` = '0'
WHERE `rule` LIKE 'notEmpty'
AND `flag_empty` LIKE '1';

UPDATE `i18n` SET fr='Décembre' WHERE id='December';
update `i18n` set fr='Déc' WHERE id='dec';
update `i18n` set fr='Février' WHERE id='February';
update `i18n` set fr='Fév' WHERE id='feb';

UPDATE `structure_fields` 
SET `structure_value_domain` = (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'custom_laboratory_staff'),
type = 'select',
setting = null
WHERE old_id = 'CAN-999-999-000-999-499';

DELETE FROM `structure_formats` WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'available_bank_participants_aliquots');
DELETE FROM `structures` WHERE `alias` = 'available_bank_participants_aliquots';

DELETE FROM `structure_formats` WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'aliquot_masters_for_search_result');
DELETE FROM `structures` WHERE `alias` = 'aliquot_masters_for_search_result';

UPDATE `structure_fields` SET `type` = 'input',
`structure_value_domain` = '' WHERE `structure_fields`.`id` =490;
UPDATE `structure_fields` SET `type` = 'input',
`structure_value_domain` = '' WHERE `structure_fields`.`id` =491;

UPDATE `structure_fields` SET `structure_value_domain` = '0' WHERE `structure_fields`.`id` =490;
UPDATE `structure_fields` SET `structure_value_domain` = '0' WHERE `structure_fields`.`id` =491;

UPDATE `structure_fields` SET `type` = 'input',
`setting` = 'size=10',
`language_help` = 'help_pack years' WHERE `structure_fields`.`id` =582;

UPDATE `structure_fields` SET `language_label` = 'disease site form' WHERE `structure_fields`.`id` =490;

INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1090', 'aliquotmasters_summary', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1090_CAN-999-999-000-999-1107', (SELECT id FROM structures WHERE alias IN ('aliquotmasters_summary')), 'CAN-999-999-000-999-1090', 223, 'CAN-999-999-000-999-1107', 0, 23, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1090_CAN-999-999-000-999-1108', (SELECT id FROM structures WHERE alias IN ('aliquotmasters_summary')), 'CAN-999-999-000-999-1090', 224, 'CAN-999-999-000-999-1108', 0, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1090_CAN-999-999-000-999-1217', (SELECT id FROM structures WHERE alias IN ('aliquotmasters_summary')), 'CAN-999-999-000-999-1090', 328, 'CAN-999-999-000-999-1217', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1090_CAN-999-999-000-999-1100', (SELECT id FROM structures WHERE alias IN ('aliquotmasters_summary')), 'CAN-999-999-000-999-1090', 216, 'CAN-999-999-000-999-1100', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1090_CAN-999-999-000-999-1103', (SELECT id FROM structures WHERE alias IN ('aliquotmasters_summary')), 'CAN-999-999-000-999-1090', 219, 'CAN-999-999-000-999-1103', 0, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1090_CAN-999-999-000-999-1102', (SELECT id FROM structures WHERE alias IN ('aliquotmasters_summary')), 'CAN-999-999-000-999-1090', 218, 'CAN-999-999-000-999-1102', 0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1090_CAN-999-999-000-999-1018', (SELECT id FROM structures WHERE alias IN ('aliquotmasters_summary')), 'CAN-999-999-000-999-1090', 170, 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


UPDATE `structure_fields` 
SET `structure_value_domain` = (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'custom_laboratory_staff'),
type = 'select',
setting = null
WHERE old_id = 'CAN-999-999-000-999-499';

 UPDATE `structure_fields` 
SET `structure_value_domain` = (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'custom_laboratory_staff'),
type = 'select',
setting = null
WHERE old_id = 'CAN-999-999-000-999-514'; 
 
 
DELETE FROM `structure_formats` WHERE `structure_old_id` = 'CAN-999-999-000-999-62';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-496', 141, 'CAN-999-999-000-999-62', 740, 'CAN-999-999-000-999-496', 0, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-1269', 141, 'CAN-999-999-000-999-62', 383, 'CAN-999-999-000-999-1269', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-1270', 141, 'CAN-999-999-000-999-62', 385, 'CAN-999-999-000-999-1270', 1, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-505', 141, 'CAN-999-999-000-999-62', 751, 'CAN-999-999-000-999-505', 1, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-507', 141, 'CAN-999-999-000-999-62', 753, 'CAN-999-999-000-999-507', 1, 14, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-506', 141, 'CAN-999-999-000-999-62', 752, 'CAN-999-999-000-999-506', 1, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-508', 141, 'CAN-999-999-000-999-62', 754, 'CAN-999-999-000-999-508', 1, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-509', 141, 'CAN-999-999-000-999-62', 755, 'CAN-999-999-000-999-509', 1, 17, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-510', 141, 'CAN-999-999-000-999-62', 757, 'CAN-999-999-000-999-510', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-511', 141, 'CAN-999-999-000-999-62', 758, 'CAN-999-999-000-999-511', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-512', 141, 'CAN-999-999-000-999-62', 759, 'CAN-999-999-000-999-512', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-513', 141, 'CAN-999-999-000-999-62', 760, 'CAN-999-999-000-999-513', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-514', 141, 'CAN-999-999-000-999-62', 761, 'CAN-999-999-000-999-514', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structures`
SET flag_add_columns = '1',	flag_edit_columns = '1'
WHERE `old_id` LIKE 'CAN-999-999-000-999-62';

DELETE FROM `structures` WHERE `old_id` IN ('CANM-00023');
INSERT INTO `structures` (
`old_id` ,
`alias` ,
`language_title` ,
`language_help` ,
`flag_add_columns` ,
`flag_edit_columns` ,
`flag_search_columns` ,
`flag_detail_columns` ,
`created` ,
`created_by` ,
`modified` ,
`modified_by`
)
VALUES (
'CANM-00023', 'addAliquotsInBatchInfo', '', '', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''
);

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (
`old_id` ,
`structure_id` ,
`structure_old_id` ,
`structure_field_id` ,
`structure_field_old_id` ,
`display_column` ,
`display_order` ,
`language_heading` ,
`flag_override_label` ,
`language_label` ,
`flag_override_tag` ,
`language_tag` ,
`flag_override_help` ,
`language_help` ,
`flag_override_type` ,
`type` ,
`flag_override_setting` ,
`setting` ,
`flag_override_default` ,
`default` ,
`flag_add` ,
`flag_add_readonly` ,
`flag_edit` ,
`flag_edit_readonly` ,
`flag_search` ,
`flag_search_readonly` ,
`flag_datagrid` ,
`flag_datagrid_readonly` ,
`flag_index` ,
`flag_detail` ,
`created` ,
`created_by` ,
`modified` ,
`modified_by`
)
VALUES 
('CANM-00023_CAN-999-999-000-999-498', @last_id , 'CANM-00023', 742 , 'CAN-999-999-000-999-498', '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00023_CAN-999-999-000-999-499', @last_id , 'CANM-00023', 743 , 'CAN-999-999-000-999-499', '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');



DELETE FROM `structure_formats` WHERE `structure_old_id` = 'CAN-999-999-000-999-62';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-496', 141, 'CAN-999-999-000-999-62', 740, 'CAN-999-999-000-999-496', 0, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-1269', 141, 'CAN-999-999-000-999-62', 383, 'CAN-999-999-000-999-1269', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-1270', 141, 'CAN-999-999-000-999-62', 385, 'CAN-999-999-000-999-1270', 1, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-505', 141, 'CAN-999-999-000-999-62', 751, 'CAN-999-999-000-999-505', 1, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-507', 141, 'CAN-999-999-000-999-62', 753, 'CAN-999-999-000-999-507', 1, 14, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-506', 141, 'CAN-999-999-000-999-62', 752, 'CAN-999-999-000-999-506', 1, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-508', 141, 'CAN-999-999-000-999-62', 754, 'CAN-999-999-000-999-508', 1, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-509', 141, 'CAN-999-999-000-999-62', 755, 'CAN-999-999-000-999-509', 1, 17, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-510', 141, 'CAN-999-999-000-999-62', 757, 'CAN-999-999-000-999-510', 0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-511', 141, 'CAN-999-999-000-999-62', 758, 'CAN-999-999-000-999-511', 0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-512', 141, 'CAN-999-999-000-999-62', 759, 'CAN-999-999-000-999-512', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-513', 141, 'CAN-999-999-000-999-62', 760, 'CAN-999-999-000-999-513', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-62_CAN-999-999-000-999-514', 141, 'CAN-999-999-000-999-62', 761, 'CAN-999-999-000-999-514', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1262';
DELETE FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1262';

DELETE FROM `structure_formats` WHERE `structure_old_id` = 'CAN-999-999-000-999-1068';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1068_CAN-999-999-000-999-1160', 93, 'CAN-999-999-000-999-1068', 274, 'CAN-999-999-000-999-1160', 1, 20, '', '1', 'define as shipped', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1068_CAN-999-999-000-999-1100', 93, 'CAN-999-999-000-999-1068', 216, 'CAN-999-999-000-999-1100', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1068_CAN-999-999-000-999-498', 93, 'CAN-999-999-000-999-1068', 742, 'CAN-999-999-000-999-498', 1, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1068_CAN-999-999-000-999-499', 93, 'CAN-999-999-000-999-1068', 743, 'CAN-999-999-000-999-499', 1, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

(null, 'CAN-999-999-000-999-1068_CAN-999-999-000-999-1264', 93, 'CAN-999-999-000-999-1068', 378, 'CAN-999-999-000-999-1264', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1068_CAN-999-999-000-999-1281', 93, 'CAN-999-999-000-999-1068', 887, 'CAN-999-999-000-999-1281', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 	
DELETE FROM menus WHERE id = 'ord_CAN_120';
 	
UPDATE structures 
SET alias = 'shippeditems'
WHERE old_id LIKE 'CAN-999-999-000-999-1068';


-- Keith's Changes

-- ***** Clinical Annotation *****

	--  /Profile/ 
	UPDATE `structure_value_domains_permissible_values` SET `display_order` = '0' WHERE `structure_value_domains_permissible_values`.`id` =343 LIMIT 1 ;
	UPDATE `i18n` SET `en` = 'Aboriginal' WHERE `i18n`.`id` = 'aboriginal' AND `i18n`.`page_id` = 'global' LIMIT 1 ;

	--  /Consent Form/ 
	UPDATE `structure_fields` SET `language_label` = 'status date',
	`language_tag` = '' WHERE `structure_fields`.`id` =117 LIMIT 1 ;

	-- Operation Date (date time tag)
	UPDATE `structure_fields` SET `language_tag` = 'date/time' WHERE `structure_fields`.`id` =120 LIMIT 1 ;

	-- / Diagnosis /
	UPDATE `structure_fields` SET `language_label` = 'summary',
	`language_tag` = '' WHERE `structure_fields`.`id` =833 LIMIT 1 ;
	UPDATE `structure_fields` SET `language_label` = 'summary',
	`language_tag` = '' WHERE `structure_fields`.`id` =837 LIMIT 1 ;


	-- / Treatment /
	UPDATE `structure_value_domains_permissible_values` SET `display_order` = '1' WHERE `structure_value_domains_permissible_values`.`id` =246 LIMIT 1 ;
	
	
-- ***** Study *****
	
	-- /Contact names/
	UPDATE `structure_fields` SET `setting` = 'size=25' WHERE `structure_fields`.`id` =619 LIMIT 1 ;
	UPDATE `structure_fields` SET `setting` = 'size=25' WHERE `structure_fields`.`id` =620 LIMIT 1 ;
	UPDATE `structure_fields` SET `setting` = 'size=25' WHERE `structure_fields`.`id` =621 LIMIT 1 ;
	
	-- /Contact phone changes/
	UPDATE `structure_fields` SET `language_tag` = 'study_number',
	`setting` = '' WHERE `structure_fields`.`id` =776 LIMIT 1 ;
	UPDATE `structure_fields` SET `language_tag` = 'study_number',
	`setting` = '' WHERE `structure_fields`.`id` =777 LIMIT 1 ;
	UPDATE `structure_fields` SET `language_tag` = 'study_number',
	`setting` = '' WHERE `structure_fields`.`id` =778 LIMIT 1 ;
	
	DELETE FROM `structure_fields` WHERE `structure_fields`.`id` =632;
	DELETE FROM `structure_fields` WHERE `structure_fields`.`id` =633;
	DELETE FROM `structure_fields` WHERE `structure_fields`.`id` =635;
	DELETE FROM `structure_fields` WHERE `structure_fields`.`id` =638;
	DELETE FROM `structure_fields` WHERE `structure_fields`.`id` =640;
	DELETE FROM `structure_fields` WHERE `structure_fields`.`id` =641;
	
	DELETE FROM `structure_formats` WHERE `structure_field_id` =632;
	DELETE FROM `structure_formats` WHERE `structure_field_id` =633;
	DELETE FROM `structure_formats` WHERE `structure_field_id` =635;
	DELETE FROM `structure_formats` WHERE `structure_field_id` =638;
	DELETE FROM `structure_formats` WHERE `structure_field_id` =640;
	DELETE FROM `structure_formats` WHERE `structure_field_id` =641;

	UPDATE `structure_fields` SET `field` = 'phone_number' WHERE `structure_fields`.`id` =776 LIMIT 1 ;
	UPDATE `structure_fields` SET `field` = 'phone2_number' WHERE `structure_fields`.`id` =777 LIMIT 1 ;
	UPDATE `structure_fields` SET `field` = 'fax_number' WHERE `structure_fields`.`id` =778 LIMIT 1 ;
	
	UPDATE `structure_validations`
SET flag_empty = '0', flag_required = '0'
WHERE structure_field_old_id IN ('CAN-999-999-000-999-1100', 'CAN-999-999-000-999-1183', 
'CAN-999-999-000-999-1232', 'CAN-999-999-000-999-26');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES (NULL, 'none', 'none');
SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`)
VALUES(NULL, 109, @last_id, 6, 'yes', 'none');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES (NULL, 'not applicable', 'not applicable');
SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`)
VALUES(NULL, 37, @last_id, 4, 'yes', 'not applicable');
