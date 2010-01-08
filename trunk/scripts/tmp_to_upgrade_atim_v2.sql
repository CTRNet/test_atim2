UPDATE `structure_permissible_values` SET value='fre' WHERE id=757;
UPDATE `structure_permissible_values` SET value='eng' WHERE id=758;

UPDATE `structure_fields` SET `language_label` = 'city',
`language_tag` = '' WHERE `structure_fields`.`id` =69 LIMIT 1 ;

UPDATE `structure_fields` SET `language_label` = 'region',
`language_tag` = '' WHERE `structure_fields`.`id` =70 LIMIT 1 ;

UPDATE `structure_fields` SET `language_label` = 'country',
`language_tag` = '' WHERE `structure_fields`.`id` =71 LIMIT 1 ;

UPDATE `structure_fields` SET `language_label` = 'mail_code',
`language_tag` = '' WHERE `structure_fields`.`id` =72 LIMIT 1 ;

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('new search', 'global', 'New Search', 'Nouvelle recherche'),
('new search type', 'global', 'New Search Type', 'Nouveau type de recherche');

UPDATE `structure_fields`
SET field = 'block_aliquot_master_id'
WHERE old_id = 'CAN-999-999-000-999-1137';

UPDATE `structure_fields`
SET field = 'gel_matrix_aliquot_master_id'
WHERE old_id = 'CAN-999-999-000-999-1243';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cell count should be a positif decimal', 'global', 'Cell count should be a positive decimal!', 'Le nombre de cellules doit &ecirc;tre un d&eacute;cimal positif!');

UPDATE `menus` 
SET `use_link` = '/clinicalannotation/product_masters/productsTreeView/%%Participant.id%%'
WHERE `id` = 'clin_CAN_57';

DELETE FROM `menus` 
WHERE `id` IN ('clin_CAN_571', 'clin_CAN_572', 'clin_CAN_573');

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('clin_CAN_571', 'clin_CAN_57', 0, 1, 'tree view', NULL, '/clinicalannotation/product_masters/productsTreeView/%%Participant.id%%', '', 'Clinicalannotation.ClinicalCollectionLink::productFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_572', 'clin_CAN_57', 0, 2, 'listall participant samples', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_573', 'clin_CAN_57', 0, 3, 'listall participant aliquots', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('products', 'global', 'Products', 'Produits');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('listall participant aliquots', 'global', 'Aliquots', 'Aliquots'),
('listall participant samples', 'global', 'Samples', '&Eacute;chantillons');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('all products', 'global', 'All Products', 'Tous les produits');

UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_34' LIMIT 1 ;
UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'tool_CAN_38' LIMIT 1 ;
UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'tool_CAN_48' LIMIT 1 ;
