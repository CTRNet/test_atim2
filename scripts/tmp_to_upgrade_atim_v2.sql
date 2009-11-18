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
ADD `square_box` TINYINT( 1 ) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'This field is used if the storage only has one dimension size specified',
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
('warning', 'global', 'Warning', 'Avertissement'),
('unclassify', 'global', 'Unclassify', 'Déclasser');

CREATE TABLE `dxd_bloods` (
  `id` int(11) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) default NULL,
  `text_field` varchar(10) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `dxd_bloods_revs` (
  `id` int(11) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) default NULL,
  `text_field` varchar(10) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `dxd_tissues` (
  `id` int(11) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) default NULL,
  `text_field` varchar(10) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `dxd_tissues_revs` (
  `id` int(11) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) default NULL,
  `text_field` varchar(10) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` (`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00010', 'diagnosismasters', '', '', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00010_CAN-999-999-000-002-11', @last_structure_id, 'CANM-00010', 139, 'CAN-999-999-000-002-11', 1, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-324', @last_structure_id, 'CANM-00010', 585, 'CAN-999-999-000-999-324', 1, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-68', @last_structure_id, 'CANM-00010', 812, 'CAN-999-999-000-999-68', 1, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-69', @last_structure_id, 'CANM-00010', 813, 'CAN-999-999-000-999-69', 1, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-70', @last_structure_id, 'CANM-00010', 815, 'CAN-999-999-000-999-70', 1, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-71', @last_structure_id, 'CANM-00010', 816, 'CAN-999-999-000-999-71', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-72', @last_structure_id, 'CANM-00010', 817, 'CAN-999-999-000-999-72', 1, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2008-10-01 11:16:32', ''),
('CANM-00010_CAN-999-999-000-999-73', @last_structure_id, 'CANM-00010', 818, 'CAN-999-999-000-999-73', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-74', @last_structure_id, 'CANM-00010', 819, 'CAN-999-999-000-999-74', 1, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-76', @last_structure_id, 'CANM-00010', 821, 'CAN-999-999-000-999-76', 1, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-77', @last_structure_id, 'CANM-00010', 823, 'CAN-999-999-000-999-77', 2, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-78', @last_structure_id, 'CANM-00010', 824, 'CAN-999-999-000-999-78', 2, 14, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-79', @last_structure_id, 'CANM-00010', 825, 'CAN-999-999-000-999-79', 2, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-80', @last_structure_id, 'CANM-00010', 827, 'CAN-999-999-000-999-80', 2, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-81', @last_structure_id, 'CANM-00010', 828, 'CAN-999-999-000-999-81', 2, 17, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-82', @last_structure_id, 'CANM-00010', 829, 'CAN-999-999-000-999-82', 2, 18, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-83', @last_structure_id, 'CANM-00010', 830, 'CAN-999-999-000-999-83', 2, 19, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-84', @last_structure_id, 'CANM-00010', 831, 'CAN-999-999-000-999-84', 2, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-85', @last_structure_id, 'CANM-00010', 832, 'CAN-999-999-000-999-85', 2, 21, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-86', @last_structure_id, 'CANM-00010', 833, 'CAN-999-999-000-999-86', 2, 22, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-87', @last_structure_id, 'CANM-00010', 834, 'CAN-999-999-000-999-87', 2, 23, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-88', @last_structure_id, 'CANM-00010', 835, 'CAN-999-999-000-999-88', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-89', @last_structure_id, 'CANM-00010', 836, 'CAN-999-999-000-999-89', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-90', @last_structure_id, 'CANM-00010', 837, 'CAN-999-999-000-999-90', 2, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00010_CAN-999-999-000-999-91', @last_structure_id, 'CANM-00010', 838, 'CAN-999-999-000-999-91', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

ALTER TABLE `aliquot_uses` 
ADD `use_code` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `use_definition`;
ALTER TABLE `aliquot_uses_revs` 
ADD `use_code` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `use_definition`;

ALTER TABLE `aliquot_uses` 
ADD `used_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `use_datetime`;
ALTER TABLE `aliquot_uses_revs` 
ADD `used_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `use_datetime`;

ALTER TABLE `quality_ctrls` 
ADD `run_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `run_id`;
ALTER TABLE `quality_ctrls_revs` 
ADD `run_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `run_id`;

ALTER TABLE `quality_ctrls` 
ADD `qc_code` VARCHAR( 20 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `id`;
ALTER TABLE `quality_ctrls_revs` 
ADD `qc_code` VARCHAR( 20 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL AFTER `id`;

DELETE FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1277';
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1277', 'Inventorymanagement', 'AliquotUse', '', 'use_code', '', 'code', 'input', 'size=30', '', '', '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1035_CAN-999-999-000-999-1277';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1035_CAN-999-999-000-999-1277', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1035'), 'CAN-999-999-000-999-1035', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1277'), 'CAN-999-999-000-999-1277', 0, 1, '', '0', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats`
SET `display_order` = '0'
WHERE `old_id` = 'CAN-999-999-000-999-1035_CAN-999-999-000-999-1161';

DELETE FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1278';
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1278', 'Inventorymanagement', 'QualityCtrl', '', 'qc_code', 'code', '', 'input', 'size=10', '', '', '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1278';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1278', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1038'), 'CAN-999-999-000-999-1038', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1278'), 'CAN-999-999-000-999-1278', 0, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_fields` SET field = 'aliquot_use_counter' WHERE old_id = 'CAN-999-999-000-999-1105';

DELETE FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1279';
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1279', 'Inventorymanagement', 'QualityCtrl', '', 'run_by', 'run by', '', 'input', 'size=20', '', 0, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1279';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1279', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1038'), 'CAN-999-999-000-999-1038', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1279'), 'CAN-999-999-000-999-1279', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
UPDATE `structure_formats` SET `display_order` = '3' WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1272';
	
UPDATE `structure_formats` SET `display_order` = '10' WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1167'; 	
UPDATE `structure_formats` SET `display_order` = '11' WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1168'; 	
	
UPDATE `structure_formats` SET `display_order` = '21' WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1170';	
UPDATE `structure_formats` SET `display_order` = '22' WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1171';	
UPDATE `structure_formats` SET `display_order` = '23' WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1172'; 	
UPDATE `structure_formats` SET `display_order` = '24' WHERE `old_id` = 'CAN-999-999-000-999-1038_CAN-999-999-000-999-1173';	

DELETE FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1280';
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1280', 'Inventorymanagement', 'AliquotUse', '', 'used_by', 'used by', '', 'input', 'size=10', '', '', '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1035_CAN-999-999-000-999-1280';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1035_CAN-999-999-000-999-1280', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1035'), 'CAN-999-999-000-999-1035', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1280'), 'CAN-999-999-000-999-1280', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats` SET `display_order` = '7' WHERE `old_id` = 'CAN-999-999-000-999-1035_CAN-999-999-000-999-1271';	

DELETE FROM  `i18n` WHERE `id` IN ('No aliquot has been defined as sample tested aliquot.',
'run by');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('run by', 'global', 'Run By', 'Ex&eacute;cut&eacute; par');

DELETE FROM `structure_formats` WHERE `structure_old_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'aliquot_masters_for_search_result');
DELETE FROM `structures` WHERE `alias` = 'aliquot_masters_for_search_results';

DELETE FROM `structure_formats` WHERE `structure_old_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'aliquot_merged_into_sample_list');
DELETE FROM `structures` WHERE `alias` = 'aliquot_merged_into_sample_list';

DELETE FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077';
INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1077', 'linkedaliquotuses', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `structure_old_id` = 'CAN-999-999-000-999-1077';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1153', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1153'), 'CAN-999-999-000-999-1153', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1155', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1131'), 'CAN-999-999-000-999-1131', 0, 4, '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1161', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1161'), 'CAN-999-999-000-999-1161', 0, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1162', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1162'), 'CAN-999-999-000-999-1162', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1163', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1163'), 'CAN-999-999-000-999-1163', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1271', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1271'), 'CAN-999-999-000-999-1271', 0, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1277', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1277'), 'CAN-999-999-000-999-1277', 0, 1, '', '0', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1077_CAN-999-999-000-999-1280', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1077'), 'CAN-999-999-000-999-1077', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1280'), 'CAN-999-999-000-999-1280', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats` SET 
`flag_add` = '1', `flag_add_readonly` = '0', `flag_edit` = '1', `flag_edit_readonly` = '0'
WHERE `old_id` = 'CAN-999-999-000-999-1035_CAN-999-999-000-999-1277';

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
			('inv_CAN_2222', 'inv_CAN_222', 0, 2, 'listall source aliquots', NULL, '/inventorymanagement/aliquot_masters/listAllSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
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

UPDATE structures set alias = 'sourcealiquots' WHERE old_id = 'CAN-999-999-000-999-1036';

DELETE FROM `structure_formats` WHERE `structure_old_id` = 'CAN-999-999-000-999-1036';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1100', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1100'), 'CAN-999-999-000-999-1100', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1102', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1102'), 'CAN-999-999-000-999-1102', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1160', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1160'), 'CAN-999-999-000-999-1160', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1103', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1103'), 'CAN-999-999-000-999-1103', 0, 4, '', '1', 'new aliquot status', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1104', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1104'), 'CAN-999-999-000-999-1104', 0, 5, '', '1', 'new aliquot status reason', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1215', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1215'), 'CAN-999-999-000-999-1215', 0, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1153', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1153'), 'CAN-999-999-000-999-1153', 0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1130', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1130'), 'CAN-999-999-000-999-1130', 0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1036_CAN-999-999-000-999-1131', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1131'), 'CAN-999-999-000-999-1131', 0, 10, '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM  `i18n` WHERE `id` IN ('listall source aliquots');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('listall source aliquots', 'global', 'Source Aliquots', 'Aliquots sources');


#realiquoted children part--------------------

DELETE FROM structures WHERE id=94 OR id=95;
DELETE FROM structure_formats WHERE structure_id=94 OR structure_id=95;

INSERT INTO `structure_fields` (`id` ,`public_identifier` ,`old_id` ,`plugin` ,`model` ,`tablename` ,`field` ,`language_label` ,`language_tag` ,`type` ,`setting` ,`default` ,`structure_value_domain` ,`language_help` ,`validation_control` ,`value_domain_control` ,`field_control` ,`created` ,`created_by`, `modified` ,`modified_by`) VALUES 
(NULL , '', 'CANM-00013', '', 'FunctionManagement', '', 'input_number', '', '', 'input', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL , '', 'CANM-00014', '', 'FunctionManagement', '', 'realiquoting_date', '', '', 'datetime', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @sfields_last_id = LAST_INSERT_ID();

INSERT INTO `structure_validations` (`old_id` ,`structure_field_id` ,`structure_field_old_id` ,`rule` ,`flag_empty` ,`flag_required` ,`on_action` ,`language_message` ,`created` ,`created_by` ,`modified` ,`modifed_by`)
VALUES ('CANM-00012', @sfields_last_id, 'CANM-00013', 'decimal', '1', '0', '', 'used volume should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structures` (`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00011', 'aliquot_children_linking', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00015', 'datetime_input', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @structure_last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00011_CAN-999-999-000-999-1100', @structure_last_id, 'CANM-00011', '216', 'CAN-999-999-000-999-1100', '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00011_CAN-999-999-000-999-1160', @structure_last_id, 'CANM-00011', '274', 'CAN-999-999-000-999-1160', '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00011_CANM-00013', @structure_last_id, 'CANM-00011', @sfields_last_id, 'CANM-00013', '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00011_CAN-999-999-000-999-1131', @structure_last_id, 'CANM-00011', '248', 'CAN-999-999-000-999-1131', '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00015_CANM-00014', @structure_last_id + 1, 'CANM-00015', @sfields_last_id + 1, 'CANM-00014', '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

ALTER TABLE `realiquotings`
  DROP `realiquoted_by`,
  DROP `realiquoted_datetime`;
 
UPDATE `atim_new`.`structure_fields` SET `model` = 'AliquotUse', `field` = 'used_by', `language_label` = 'use by' WHERE `structure_fields`.`id` =380 LIMIT 1;
UPDATE `atim_new`.`structure_fields` SET `model` = 'AliquotUse', `field` = 'use_datetime', `language_label` = 'use date' WHERE `structure_fields`.`id` = 381 LIMIT 1 ;

  
ALTER TABLE `realiquotings` ADD UNIQUE `parent_child_combo` ( `parent_aliquot_master_id` , `child_aliquot_master_id` );

UPDATE `menus` SET `language_title` = 'listall realiquoted parent', use_link='/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' WHERE `menus`.`id` = 'inv_CAN_22233' OR `menus`.`id` = 'inv_CAN_2233';


INSERT INTO `structures` (`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00016', 'realiquotedparent', '', '', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00016_CAN-999-999-000-999-1153', @last_structure_id, 'CANM-00016', 266, 'CAN-999-999-000-999-1153', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00016_CAN-999-999-000-999-1155', @last_structure_id, 'CANM-00016', 248, 'CAN-999-999-000-999-1131', 0, 4, '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00016_CAN-999-999-000-999-1162', @last_structure_id, 'CANM-00016', 276, 'CAN-999-999-000-999-1162', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00016_CAN-999-999-000-999-1277', @last_structure_id, 'CANM-00016', 881, 'CAN-999-999-000-999-1277', 0, 1, '', '1', 'barcode', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00016_CAN-999-999-000-999-1266', @last_structure_id, 'CANM-00016', 380, 'CAN-999-999-000-999-1266', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00016_CAN-999-999-000-999-1267', @last_structure_id, 'CANM-00016', 381, 'CAN-999-999-000-999-1267', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ------------------------------------------------------------

UPDATE `structure_fields` SET `field` = 'product_code'
WHERE `old_id` = 'CAN-999-999-000-999-488';

UPDATE `structure_fields` SET `field` = 'discount_code'
WHERE `old_id` = 'CAN-999-999-000-999-495';

DELETE FROM  `i18n` WHERE `id` IN ('order number is required');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('order number is required', 'global', 'Order number is required!', 'Le num&eacute;ro de commande est requis!');

DELETE FROM pages where id LIKE 'err_order_%';

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('err_order_system_error', 1, 'system error', 'a system error has been detetced', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_record_err', 1, 'data creation - update error', 'an error occured during the creation or the update of the data', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_deletion_err', 1, 'data deletion error', 'the system is unable to delete correctly the data', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM  `i18n` WHERE `id` IN ('system error', 'a system error has been detetced', 
'parameter missing', 'a paramater used by the executed function has not been set', 
'data not found', 'no data exists for the specified id', 
'data creation - update error', 'an error occured during the creation or the update of the data', 
'data deletion error', 'the system is unable to delete correctly the data');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('system error', 'global', 'System Error', 'Erreur syst&egrave;me'),
('a system error has been detetced', 'global', 
'A system error has been detetced!<br>Please try again or contact your system administrator.', 
'Une erreur du syst&egrave;me a &eacute;t&eacute; detect&eacute;e!<br>Essayez de nouveau ou contactez votre administrateur du syst&egrave;me.'),

('parameter missing', 'global', 'Missing Parameter', 'Param&egrave;tre manquant'),
('a paramater used by the executed function has not been set', 'global', 
'All required parameters are not defined!<br>Please try again or contact your system administrator.', 
'Tous les param&egrave;tres requis ne sont pas d&eacute;finis!<br>Essayez de nouveau ou contactez votre administrateur du syst&egrave;me.'),

('data not found', 'global', 'Data Not Found', 'Donn&eacute;es innexistantes'), 
('no data exists for the specified id', 'global', 
'No data matches the specified ID!<br>Please try again or contact your system administrator.', 
'Aucune donnÈe ne correspond &agrave; l''ID sp&eacute;cifi&eacute;!<br>Essayez de nouveau ou contactez votre administrateur du syst&egrave;me.'),

('data creation - update error', 'global', 'Data Creation/Update Error', 'Erreur durant la cr&eacute;ation/mise &agrave; jour des donn&eacute;es'),
('an error occured during the creation or the update of the data', 'global', 
'An error occured during the data creation/update!<br>Please try again or contact your system administrator.', 
'Une erreur a &eacute;t&eacute; d&eacute;tect&eacute;e durant la cr&eacute;ation/mise &agrave; jour des donn&eacute;es!<br>Essayez de nouveau ou contactez votre administrateur du syst&egrave;me.'),

('data deletion error', 'global', 'Data Deletion Error', 'Erreur durant la suppression des donn&eacute;es'),
('the system is unable to delete correctly the data', 'global', 
'The system is unable to delete correctly the data!<br>Please try again or contact your system administrator.', 
'Le syst&egrave;me ne peut pas supprimer les donn&eacute;es correctement!<br>Essayez de nouveau ou contactez votre administrateur du syst&egrave;me.');

DELETE FROM `i18n` WHERE `id` IN ('your data has been deleted', 'your data has been saved', 'your data has been updated');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('your data has been deleted', 'global', 'Your data has been deleted.', 'Vos donn&eacute;es ont &eacute;t&eacute; supprim&eacute;es.'),
('your data has been saved', 'global', 'Your data has been saved.', 'Vos donn&eacute;es ont &eacute;t&eacute; sauvegard&eacute;es.'),
('your data has been updated', 'global', 'Your data has been updated.', 'Vos donn&eacute;es ont &eacute;t&eacute; mises &agrave; jour.');

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
			('inv_CAN_2222', 'inv_CAN_222', 0, 2, 'listall source aliquots', NULL, '/inventorymanagement/aliquot_masters/listAllSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2223', 'inv_CAN_222', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22231', 'inv_CAN_2223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22232', 'inv_CAN_2223', 0, 2, 'listall aliquot uses', NULL, '/inventorymanagement/aliquot_masters/listAllAliquotUses/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22233', 'inv_CAN_2223', 0, 3, 'realiquoted parent', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2224', 'inv_CAN_222', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listAll/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22241', 'inv_CAN_2224', 0, 1, 'details', NULL, '/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/%%SampleMaster.id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22242', 'inv_CAN_2224', 0, 2, 'listall tested aliquots', NULL, '/inventorymanagement/quality_ctrls/listAllTestedAliquots/%%Collection.id%%/%%SampleMaster.id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_223', 'inv_CAN_22', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2231', 'inv_CAN_223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2232', 'inv_CAN_223', 0, 2, 'listall aliquot uses', NULL, '/inventorymanagement/aliquot_masters/listAllAliquotUses/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2233', 'inv_CAN_223', 0, 3, 'realiquoted parent', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_224', 'inv_CAN_22', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2241', 'inv_CAN_224', 0, 1, 'details', NULL, '/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2242', 'inv_CAN_224', 0, 2, 'listall tested aliquots', NULL, '/inventorymanagement/quality_ctrls/listAllTestedAliquots/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	('inv_CAN_23', 'inv_CAN_2', 0, 3, 'listall collection aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/-1', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_3', 'inv_CAN', 0, 3, 'listall collection path reviews', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

