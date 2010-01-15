DELETE FROM `structure_formats` WHERE `structure_old_id` = 'CANM-00016';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CANM-00016_CAN-999-999-000-999-1100', 195, 'CANM-00016', 216, 'CAN-999-999-000-999-1100', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CANM-00016_CAN-999-999-000-999-1102', 195, 'CANM-00016', 218, 'CAN-999-999-000-999-1102', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
    	  		  	
(null, 'CANM-00016_CAN-999-999-000-999-1153', 195, 'CANM-00016', 266, 'CAN-999-999-000-999-1153', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CANM-00016_CAN-999-999-000-999-1131', 195, 'CANM-00016', 248, 'CAN-999-999-000-999-1131', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CANM-00016_CAN-999-999-000-999-1267', 195, 'CANM-00016', 381, 'CAN-999-999-000-999-1267', 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CANM-00016_CAN-999-999-000-999-1266', 195, 'CANM-00016', 380, 'CAN-999-999-000-999-1266', 0, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add validation rule
INSERT INTO `structure_validations` (`id`,`old_id`,`structure_field_id` ,`structure_field_old_id`,`rule`,`flag_empty`,`flag_required`,`on_action`,`language_message`,`created`,`created_by`,`modified`,`modifed_by`) VALUES
(null, '0', '521', 'CAN-999-999-000-999-26', 'isUnique', '1', '1', '', 'error_participant identifier must be unique', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `i18n` (`id` ,`page_id` ,`en` ,`fr`) VALUES
('error_participant identifier must be unique', '', 'Error - Participant Identifier must be unique', '');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('no new sample aliquot could be actually defined as source aliquot', 'global', 'No new sample aliquot could be actually defined as source aliquot!', 
'Aucun nouvel aliquot de l''&echantillon ne peut actuellement &ecirc;tre d&eacute;fini comme aliquot source!');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('no aliquot has been defined as source aliquot', 'global', 
'No aliquot has been defined as source child!',
'Aucun aliquot n''a &eacute;&eacute; d&eacute;fini comme aliquot source!');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('no aliquot has been defined as sample tested aliquot', 'global', 
'No aliquot has been defined as tested aliquot!',
'Aucun aliquot n''a &eacute;&eacute; d&eacute;fini comme aliquot test&eacute;!');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tested aliquots', 'global', 
'Tested Aliquots',
'Aliquots Test&eacute;s');

DELETE FROM `menus` WHERE `id` = 'inv_CAN_22242';
