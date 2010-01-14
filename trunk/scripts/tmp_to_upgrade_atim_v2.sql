 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('add uses', 'global', 'Add Uses', 'Cr&eacute;er utilisations');

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('access to order', 'global', 'Access To Order', 'Acc&eacute;der &agrave; la commande');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('add internal use', 'global', 'Add Internal Use', 'Cr&eacute;er utilisation interne');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('define realiquoted children', 'global', 'Define Realiquoted Children', 'D&eacute;finir enfants r&eacute;-aliquot&eacute;s');

UPDATE `i18n` SET `fr` = 'Utilisation interne' 
WHERE `id` = 'internal use';

INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`) VALUES
(null, '6', (SELECT id FROM `structure_permissible_values` WHERE `value` LIKE 'n/a' LIMIT 0,1), 0, 'yes', 'n/a');

UPDATE `structure_formats` SET `language_tag` = ':' 
WHERE `structure_formats`.`id` = 2208 ;

UPDATE `structure_formats` SET `language_tag` = ':' 
WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1277' ;

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
(':', 'global', ':', ':');

UPDATE `structures`
SET `alias` = 'aliquotuses_system_dependent'
WHERE `alias` = 'linkedaliquotuses';

DELETE FROM `i18n` WHERE `id` = 'used by';
 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('used by', 'global', 'Used By', 'Utilis&eacute; par');

DELETE FROM `i18n` WHERE `id` = 'study';
 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('study', 'global', 'Study', '&Eacute;tude');

UPDATE `menus` SET `use_link` = '/customize/profiles/index/' WHERE `menus`.`id` = 'core_CAN_42' LIMIT 1 ;

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('no new sample aliquot could be actually defined as realiquoted child', 'global', 
'No new sample aliquot could be actually defined as realiquoted child!', 
'Auncun nouvel aliquot de l''&eacute;chantillon ne peut actuellement &ecirc;tre d&eacute;fini comme aliquot r&eacute;-aliquot&eacute; (enfant)!');



UPDATE `structures`
SET `alias` = 'children_aliquots_selection'
WHERE `alias` = 'aliquot_children_linking';

DELETE FROM `structure_formats` WHERE  `structure_field_old_id` = 'CANM-00014';
DELETE FROM `structure_fields` WHERE  `old_id` = 'CANM-00014';

DELETE FROM `structure_formats` WHERE  `structure_field_old_id` = 'CANM-00013';
DELETE FROM `structure_fields` WHERE  `old_id` = 'CANM-00013';

DELETE FROM `structure_formats` WHERE  `structure_old_id` = 'CANM-00015';
DELETE FROM `structures` WHERE  `old_id` = 'CANM-00015';

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1289', 'Inventorymanagement', 'GeneratedParentAliquot', '', 'aliquot_volume_unit', '', '', 'select', '', '', 6, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE  `structure_old_id` = 'CANM-00011';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- barcode
(null, 'CANM-00011_CAN-999-999-000-999-1100', 193, 'CANM-00011', 216, 'CAN-999-999-000-999-1100', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- aliquot type
(null, 'CANM-00011_CAN-999-999-000-999-1102', 193, 'CANM-00011', 218, 'CAN-999-999-000-999-1102', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- status
(null, 'CANM-00011_CAN-999-999-000-999-1103', 193, 'CANM-00011', 219, 'CAN-999-999-000-999-1103', 1, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- use
(null, 'CANM-00011_CAN-999-999-000-999-1160', 193, 'CANM-00011', 274, 'CAN-999-999-000-999-1160', 1, 10, '', '1', 'define as child', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- date
(null, 'CANM-00011_CAN-999-999-000-999-1163', 193, 'CANM-00011', 277, 'CAN-999-999-000-999-1163', 1, 11, 
'', '1', 'realiquoting date', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- by
(null, 'CANM-00011_CAN-999-999-000-999-1280', 193, 'CANM-00011', 884, 'CAN-999-999-000-999-1280', 1, 12, 
'', '1', 'realiquoted by', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- used volume
(null, 'CANM-00011_CAN-999-999-000-999-1153', 193, 'CANM-00011', 266, 'CAN-999-999-000-999-1153', 1, 13, '', '1', 'parent used volume', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- used unit
(null, 'CANM-00011_CAN-999-999-000-999-1289', 193, 'CANM-00011', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1289'), 'CAN-999-999-000-999-1289',  1, 14, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- copy ctrl
(null, 'CANM-00011_CAN-999-999-000-999-1119', 193, 'CANM-00011', 235, 'AN-999-999-000-999-1119',  1, 99, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
  	
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('no aliquot has been defined as realiquoted child', 'global', 
'No aliquot has been defined as realiquoted child!', 
'Aucun aliquot n''a &eacute;t&eacute; d&eacute;fini comme aliquot r&eacute;-aliquot&eacute; (enfant)!');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('define as child', 'global', 'Define as Child', 'D&eacute;finir comme r&eacute;-aliquot&eacute;'),
('realiquoted children selection', 'global', 'Realiquoted Children Selection', 'Selection des aliquots r&eacute;-aliquot&eacute;s (enfant)'),
('parent used volume', 'global', 'Parent Used Volume', 'Volume utilis&eacute; du parent');

DELETE FROM menus where id = 'inv_CAN_22232';

UPDATE menus
set use_link = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%'
WHERE id = 'inv_CAN_2233';





--

UPDATE `structures`
SET `alias` = 'aliquotuses_system_dependent'
WHERE `alias` = 'linkedaliquotuses';

UPDATE `structures`
SET `alias` = 'children_aliquots_selection'
WHERE `alias` = 'aliquot_children_linking';

DELETE FROM `structures` WHERE  `old_id` = 'CANM-00015';