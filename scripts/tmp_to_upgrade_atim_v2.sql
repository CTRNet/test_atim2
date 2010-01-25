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