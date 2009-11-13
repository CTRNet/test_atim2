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

-- -----------------------

RENAME TABLE `qc_tested_aliquots`  TO `quality_ctrl_tested_aliquots` ;
RENAME TABLE `qc_tested_aliquots_revs`  TO `quality_ctrl_tested_aliquots_revs` ;

ALTER TABLE `quality_ctrl_tested_aliquots` CHANGE `quality_control_id` `quality_ctrl_id` INT( 11 ) NULL DEFAULT NULL;

DELETE FROM `i18n`
WHERE `id` IN 
('use exists for the deleted aliquot',
'realiquoting data exists for the deleted aliquot',
'review exists for the deleted aliquot',
'order exists for the deleted aliquot',
'either core or slide exists for the deleted aliquot',
'quality control',
'quality control abbreviation',
'aliquot has been linked to the deleted qc',
'listall tested aliquots',
'No new sample aliquot could be actually defined as tested aliquot', 
'no new sample aliquot could be actually defined as tested aliquot');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('quality control abbreviation', 'global', 'QC', 'QC'),
('quality control', 'global', 'Quality Control', 'Contr&ocirc;le de qualit&eacute;'),
('use exists for the deleted aliquot', 'global', 
'Your data cannot be deleted! <br>Uses exist for the deleted aliquot.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des utilisations existent pour votre aliquot.'),
('realiquoting data exists for the deleted aliquot', 'global', 
'Your data cannot be deleted! <br>Realiquoting data exist for the deleted aliquot.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des donn&eacute;es de r&eacute;aliquotage existent pour votre aliquot.'),
('review exists for the deleted aliquot', 'global', 
'Your data cannot be deleted! <br>Reviews exist for the deleted aliquot.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des rapports existent pour votre aliquot.'),
('order exists for the deleted aliquot', 'global', 
'Your data cannot be deleted! <br>Orders exist for the deleted aliquot.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des commandes existent pour votre aliquot.'),
('either core or slide exists for the deleted aliquot', 'global', 
'Your data cannot be deleted! <br>Either cores or slides exist for the deleted aliquot.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des ''cores'' ou des lames existent pour votre aliquot.'),
('aliquot has been linked to the deleted qc', 'global', 
'Your data cannot be deleted! <br>Aliquot has been linked to the deleted quality control.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des aliquots ont &eacute;t&eacute; d&eacute;finis pour votre contr&ocirc;le de qualit&eacute;.'),
('listall tested aliquots', 'global', 'Tested Aliquots', 'Aliquots test&ecute;s'),
('no new sample aliquot could be actually defined as tested aliquot', 'global', 'No new sample aliquot could be actually defined as tested aliquot!', 'Auncun nouvel aliquot ne peut actuellement &ecirc;tre d&eacute;fini comme aliquot ''test&eacute;''!');

DELETE FROM menus
WHERE id LIKE 'inv_CAN%';

INSERT INTO `menus` 
(`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `active`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('inv_CAN', 'MAIN_MENU_1', 1, 3, 'inventory management', 'inventory management', '/inventorymanagement/collections/index', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_1', 'inv_CAN', 0, 1, 'collection details', NULL, '/inventorymanagement/collections/detail/%%Collection.id%%', '', 'Inventorymanagement.Collection::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2', 'inv_CAN', 0, 2, 'listall collection content', NULL, '/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%', '', 'Inventorymanagement.Collection::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	('inv_CAN_21', 'inv_CAN_2', 0, 1, 'tree view', NULL, '/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	('inv_CAN_22', 'inv_CAN_2', 0, 2, 'listall collection samples', NULL, '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/-1', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_221', 'inv_CAN_22', 0, 1, 'details', NULL, '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_222', 'inv_CAN_22', 0, 2, 'listall derivatives', NULL, '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2221', 'inv_CAN_222', 0, 1, 'details', NULL, '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2222', 'inv_CAN_222', 0, 2, 'parent aliquots', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2223', 'inv_CAN_222', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22231', 'inv_CAN_2223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22232', 'inv_CAN_2223', 0, 2, 'listall aliquot uses', NULL, '/inventorymanagement/aliquot_masters/listAllAliquotUses/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22233', 'inv_CAN_2223', 0, 3, 'realiquoted parent', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2224', 'inv_CAN_222', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listall/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22241', 'inv_CAN_2224', 0, 1, 'details', NULL, '/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/%%SampleMaster.id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22242', 'inv_CAN_2224', 0, 2, 'listall tested aliquots', NULL, '/inventorymanagement/quality_ctrls/listallTestedAliquots/%%Collection.id%%/%%SampleMaster.id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_223', 'inv_CAN_22', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2231', 'inv_CAN_223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2232', 'inv_CAN_223', 0, 2, 'listall aliquot uses', NULL, '/inventorymanagement/aliquot_masters/listAllAliquotUses/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2233', 'inv_CAN_223', 0, 3, 'realiquoted parent', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_224', 'inv_CAN_22', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listall/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2241', 'inv_CAN_224', 0, 1, 'details', NULL, '/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2242', 'inv_CAN_224', 0, 2, 'listall tested aliquots', NULL, '/inventorymanagement/quality_ctrls/listallTestedAliquots/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	('inv_CAN_23', 'inv_CAN_2', 0, 3, 'listall collection aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/-1', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_3', 'inv_CAN', 0, 3, 'listall collection path reviews', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structures` SET `alias` = 'aliquotuses' WHERE `old_id` = 'CAN-999-999-000-999-1035';
UPDATE `structures` SET `alias` = 'qctestedaliquots' WHERE `old_id` = 'CAN-999-999-000-999-1071';

UPDATE `structure_formats`
SET `display_order` = '5'
WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1272';

UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1100'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1150';

UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1103'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1151';

UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1104'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1152';

UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1130'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1154';

UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1131'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1155';

UPDATE `structure_formats`
SET `flag_detail` = '0', `flag_add` = '0', `flag_edit` = '0', `flag_add_readonly` = '0', `flag_edit_readonly` = '0'
WHERE `structure_old_id` = 'CAN-999-999-000-999-1071';

UPDATE `structure_formats`
SET `display_order` = '3'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1102';

UPDATE `structure_formats`
SET `display_order` = '4'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1103';

UPDATE `structure_formats`
SET `display_order` = '5'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1104';

UPDATE `structure_fields` SET `type` ='checkbox' WHERE `type` LIKE 'checklist';
UPDATE `structure_fields` SET `structure_value_domain` =null WHERE `type` LIKE 'checkbox';

UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1215',
`structure_field_old_id` = 'CAN-999-999-000-999-1215',
`structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1215')
WHERE `old_id` = 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1260';
UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1069_CAN-999-999-000-999-1215',
`structure_field_old_id` = 'CAN-999-999-000-999-1215',
`structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1215')
WHERE `old_id` = 'CAN-999-999-000-999-1069_CAN-999-999-000-999-1260';
UPDATE `structure_formats`
SET `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1215',
`structure_field_old_id` = 'CAN-999-999-000-999-1215',
`structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1215')
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1260';

DELETE FROM `structure_fields` WHERE old_id = 'CAN-999-999-000-999-1260';

DELETE FROM  `i18n` WHERE `id` = 'remove_from_storage_help';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('remove_from_storage_help', 'global', 
'Will remove aliquot from its storage deleting all storage information for this aliquot.', 
'Supprimera l''aliquot de l''entreposage en &eacute;ffa&ccedil;ant les donn&eacute;es d''entreposage de l''aliquot');

UPDATE `structure_fields` 
SET `language_help` = 'remove_from_storage_help' WHERE `old_id` = 'CAN-999-999-000-999-1215';

DELETE FROM  `i18n` WHERE `id` = 'use_help';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('use_help', 'global', 
'Only selected rows will be taken in consideration!', 
'Seul les lignes s&eacute;lectionn&eacute;es seront prises en consid&eacute;ration!');

UPDATE `structure_fields` 
SET `language_help` = 'use_help' WHERE `old_id` = 'CAN-999-999-000-999-1160';

UPDATE `structure_formats`
SET `display_order` = '3'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1160';

UPDATE `structure_formats`
SET `display_order` = '1'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1100';

UPDATE `structure_formats`
SET `display_order` = '2'
WHERE `old_id` = 'CAN-999-999-000-999-1071_CAN-999-999-000-999-1102';

DELETE FROM  `i18n` WHERE `id` IN ('No aliquot has been defined as sample tested aliquot.',
'no aliquot has been defined as sample tested aliquot.',
'listall aliquot uses');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('listall aliquot uses', 'global', 'Uses', 'Utilisations'),
('no aliquot has been defined as sample tested aliquot.', 'global', 'No aliquot has been defined as sample tested aliquot.', 'Aucun aliquot n''a &eacute;t&eacute; d&eacute;fini comme aliquot ''test&eacute;''.');

ALTER TABLE `storage_controls` 
ADD `square_box` TINYINT( 1 ) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'This field is used if the storage only has one dimension size specified';
ADD `horizontal_display` TINYINT( 1 ) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'used on 1 dimension controls when y = 1';

UPDATE `storage_controls` SET `square_box` = '1' WHERE `storage_controls`.`id` = 10 OR `storage_controls`.`id` = 17 ;

ALTER TABLE `storage_masters` 
CHANGE `parent_storage_coord_x` `parent_storage_coord_x` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
CHANGE `parent_storage_coord_y` `parent_storage_coord_y` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL; 

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('reset', 'global', 'Reset', 'Réinitialiser'),
("unclassify all storage's items", 'global', "Unclassify all storage's items", 'Déclasser tous les items du contenant'),
("remove all storage's items", 'global', "Remove all storage's items", 'Retirer tous les items du contenant'),
('unclassified', 'global', 'Unclassified', 'Non classé'),
('remove all unclassified', 'global', 'Remove all unclassified', 'Retirer tous les non classés'),
('unclassify all removed', 'global', 'Unclassify all removed', 'Déclasser tous les retirés'),
('the data has been modified', 'global', 'The data has been modified', 'Les données ont été modifiées'),
('do not forget to save', 'global', 'Do not forget to save', "N'oubliez pas d'enregistrer"),
('unclassify', 'global', 'Unclassify', 'Déclasser');