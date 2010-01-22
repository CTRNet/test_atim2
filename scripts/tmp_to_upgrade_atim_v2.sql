﻿UPDATE `structure_validations`
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
