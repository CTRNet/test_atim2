ALTER TABLE `clinical_collection_links` 
ADD INDEX(participant_id),
ADD FOREIGN KEY (participant_id) REFERENCES participants(id),
ADD UNIQUE INDEX(collection_id),
ADD FOREIGN KEY (collection_id) REFERENCES collections(id),
ADD UNIQUE INDEX(diagnosis_master_id),
ADD FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id),
ADD UNIQUE INDEX(consent_master_id),
ADD FOREIGN KEY (consent_master_id) REFERENCES consent_masters(id);

UPDATE `menus` SET 
`use_link` = '/clinicalannotation/product_masters/contentTreeView/%%Participant.id%%',
`language_title` = 'products',
`language_description` = 'products' 
WHERE `menus`.`id` = 'clin_CAN_57' LIMIT 1 ;

INSERT INTO `menus` (`id` ,`parent_id` ,`is_root` ,`display_order` ,`language_title` ,`language_description` ,`use_link` ,`use_params` ,`use_summary` ,`active` ,`created` ,`created_by` ,`modified` ,`modified_by`)
VALUES ('clin_CAN_571', 'clin_CAN_57', '0', '0', 'tree view', 'tree view', '/clinicalannotation/product_masters/listall/%%Participant.id%%', '', 'Clinicalannotation.ProductMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


INSERT INTO `i18n` (`id` ,`page_id` ,`en` ,`fr`)
VALUES ('products list', 'global', 'Products list', 'Liste de produits'),
('loading', 'global', 'Loading', 'Chargement');

INSERT INTO `structures` (`old_id` ,`alias` ,`language_title` ,`language_help` ,`flag_add_columns` ,`flag_edit_columns` ,`flag_search_columns` ,`flag_detail_columns` ,`created`, `created_by` ,`modified` ,`modified_by`)
VALUES ('CANM-00007', 'collection_tree_view', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @ctv_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES ('CANM-00007_CAN-999-999-000-999-1000', @ctv_id, 'CANM-0007', '152', 'CAN-999-999-000-999-1000', '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
('CANM-00007_CAN-999-999-000-999-1004', @ctv_id, 'CANM-00007', '156', 'CAN-999-999-000-999-1004', '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-1223', @ctv_id, 'CANM-00007', '333', 'CAN-999-999-000-999-1223', '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
