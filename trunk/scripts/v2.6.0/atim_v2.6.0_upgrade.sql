INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.0', NOW(),'to define','to define');

REPLACE INTO i18n (id,en,fr) VALUES
('children', 'Children', 'Enfants'),
('results', 'Results', 'Résultats');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- UPDATE & ADD CORRECTIONS FOR SEARCH ON SPENT TIMES (collection to storage spent time, etc)
-- -----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='creat_to_stor_spent_time_msg')
AND `language_label`='collection to storage spent time (min)';

UPDATE structure_formats 
SET flag_override_label = '1', `language_label`='collection to storage spent time (min)'
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='coll_to_stor_spent_time_msg')
AND flag_search = '1';

UPDATE structure_formats 
SET flag_override_label = '1', `language_label`='collection to storage spent time (min)'
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='coll_to_stor_spent_time_msg')
AND flag_search = '1';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

SELECT '----------------------------------------------------------------------------------------------------------' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL
SELECT 'Structures & Spent Time Fields to Review (See below)' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL
SELECT 'Nothing to do if no result in following section' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = search field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'coll_to_creation_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(search_form.structure_alias, ' - ', search_form.field)
	FROM view_structure_formats_simplified AS search_form
	WHERE search_form.flag_search = '1' 
	AND  search_form.flag_index = '0' 
	AND search_form.flag_detail = '0'
	AND search_form.field LIKE 'coll_to_creation_spent_time_msg' 
	AND search_form.language_label LIKE 'collection to creation spent time (min)'
)
UNION ALL
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = result field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'coll_to_creation_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(result_form.structure_alias, ' - ', result_form.field)
	FROM view_structure_formats_simplified AS result_form
	WHERE result_form.flag_search = '0' 
	AND  result_form.flag_index = '1' 
	AND result_form.flag_detail = '1'
	AND result_form.field LIKE 'coll_to_creation_spent_time_msg' 
	AND result_form.language_label LIKE 'collection to creation spent time' 
)
-- -------------------------------------------------------------------------------------------------
UNION ALL
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = search field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'coll_to_rec_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(search_form.structure_alias, ' - ', search_form.field)
	FROM view_structure_formats_simplified AS search_form
	WHERE search_form.flag_search = '1' 
	AND  search_form.flag_index = '0' 
	AND search_form.flag_detail = '0'
	AND search_form.field LIKE 'coll_to_rec_spent_time_msg' 
	AND search_form.language_label LIKE 'collection to reception spent time (min)'
)
UNION ALL
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = search field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'coll_to_rec_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(result_form.structure_alias, ' - ', result_form.field)
	FROM view_structure_formats_simplified AS result_form
	WHERE result_form.flag_search = '0' 
	AND  result_form.flag_index = '1' 
	AND result_form.flag_detail = '1'
	AND result_form.field LIKE 'coll_to_rec_spent_time_msg' 
	AND result_form.language_label LIKE 'collection to reception spent time' 
)
-- -------------------------------------------------------------------------------------------------
UNION ALL
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = search field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'coll_to_stor_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(structure_alias, ' - ', search_form.field)
	FROM view_structure_formats_simplified AS search_form
	WHERE search_form.flag_search = '1' 
	AND  search_form.flag_index = '0' 
	AND search_form.flag_detail = '0'
	AND search_form.field LIKE 'coll_to_stor_spent_time_msg' 
	AND search_form.language_label LIKE 'collection to storage spent time (min)'
)
UNION ALL
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = result field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'coll_to_stor_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(result_form.structure_alias, ' - ', result_form.field)
	FROM view_structure_formats_simplified AS result_form
	WHERE result_form.flag_search = '0' 
	AND  result_form.flag_index = '1' 
	AND result_form.flag_detail = '1'
	AND result_form.field LIKE 'coll_to_stor_spent_time_msg' 
	AND result_form.language_label LIKE 'collection to storage spent time' 
)
-- -------------------------------------------------------------------------------------------------
UNION ALL
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT CONCAT(structure_alias ,'.', field, ' => error = search field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'creat_to_stor_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(search_form.structure_alias, ' - ', search_form.field)
	FROM view_structure_formats_simplified AS search_form
	WHERE search_form.flag_search = '1' 
	AND  search_form.flag_index = '0' 
	AND search_form.flag_detail = '0'
	AND search_form.field LIKE 'creat_to_stor_spent_time_msg' 
	AND search_form.language_label LIKE 'creation to storage spent time (min)'
)
UNION ALL
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = result field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'creat_to_stor_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(result_form.structure_alias, ' - ', result_form.field)
	FROM view_structure_formats_simplified AS result_form
	WHERE result_form.flag_search = '0' 
	AND  result_form.flag_index = '1' 
	AND result_form.flag_detail = '1'
	AND result_form.field LIKE 'creat_to_stor_spent_time_msg' 
	AND result_form.language_label LIKE 'creation to storage spent time' 
)
-- -------------------------------------------------------------------------------------------------
UNION ALL
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = search field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'rec_to_stor_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(search_form.structure_alias, ' - ', search_form.field)
	FROM view_structure_formats_simplified AS search_form
	WHERE search_form.flag_search = '1' 
	AND  search_form.flag_index = '0' 
	AND search_form.flag_detail = '0'
	AND search_form.field LIKE 'rec_to_stor_spent_time_msg' 
	AND search_form.language_label LIKE 'reception to storage spent time (min)'
)
UNION ALL
SELECT DISTINCT CONCAT(structure_alias,'.', field, ' => error = result field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified
WHERE field LIKE 'rec_to_stor_spent_time_msg'
AND CONCAT(structure_alias, ' - ', field) NOT IN (
	SELECT DISTINCT CONCAT(result_form.structure_alias, ' - ', result_form.field)
	FROM view_structure_formats_simplified AS result_form
	WHERE result_form.flag_search = '0' 
	AND  result_form.flag_index = '1' 
	AND result_form.flag_detail = '1'
	AND result_form.field LIKE 'rec_to_stor_spent_time_msg' 
	AND result_form.language_label LIKE 'reception to storage spent time' 
)
-- -------------------------------------------------------------------------------------------------
UNION ALL
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT CONCAT(search_form.structure_alias,'.', search_form.field, ' => error = search field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified AS search_form
WHERE search_form.flag_search = '1' 
AND  search_form.flag_index = '0' 
AND search_form.flag_detail = '0'
AND search_form.field LIKE '%spent_time_msg' 
AND search_form.language_label NOT LIKE '% spent time (min)'
-- -------------------------------------------------------------------------------------------------
UNION ALL
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT CONCAT(result_form.structure_alias,'.', result_form.field, ' => error = result field issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified AS result_form
WHERE result_form.flag_search = '0' 
AND  result_form.flag_index = '1' 
AND result_form.flag_detail = '1'
AND result_form.field LIKE '%spent_time_msg' 
AND result_form.language_label NOT LIKE '% spent time'
-- -------------------------------------------------------------------------------------------------
UNION ALL
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT CONCAT(result_form.structure_alias,'.', result_form.field, ' => error = language label & field mismatch issue') as 'SPENT TIME FIELDS REVIEW'
FROM view_structure_formats_simplified AS result_form
WHERE (field = 'coll_to_creation_spent_time_msg' AND language_label NOT LIKE 'collection to creation spent time%')
OR (field = 'coll_to_rec_spent_time_msg' AND language_label NOT LIKE 'collection to reception spent time%')
OR (field = 'coll_to_stor_spent_time_msg' AND language_label NOT LIKE 'collection to storage spent time%')
OR (field = 'creat_to_stor_spent_time_msg' AND language_label NOT LIKE 'creation to storage spent time%')
OR (field = 'rec_to_stor_spent_time_msg' AND language_label NOT LIKE 'reception to storage spent time%')
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL 
SELECT 'Query to use for control if section above is not empty' AS 'HELP FOR SPENT TIME REVISION'
UNION ALL 
SELECT '----------------------------------------------------------------------------------------------------------' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL 
SELECT "SELECT structure_alias, model, field, language_label , flag_search, flag_index, flag_detail
FROM view_structure_formats_simplified 
WHERE field like '%spent_time_msg' 
ORDER BY field, structure_alias" AS 'SPENT TIME FIELDS REVIEW'
UNION ALL 
SELECT '' AS 'SPENT TIME FIELDS REVIEW';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- END OF UPDATE & ADD CORRECTIONS FOR SEARCH ON SPENT TIMES 
-- -----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Merge participant Collection content & collection link issue #2551
-- -----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM menus WHERE use_link LIKE '/ClinicalAnnotation/ProductMasters/%';
DELETE FROM menus WHERE use_link LIKE '/ClinicalAnnotation/ClinicalCollectionLinks/%' AND id = 'clin_CAN_67';
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('collections content','Collections Content','Contenu des collections'),
('links to collections','Links to collections','Liens aux collections'),
('collections links','Collection Links','Liens de la collections'),
('linked collection','Linked Collection','Collection liée'),
('collection to link','Collection to link','Collection à lier'),
('use inventory management module to delete the entire collection','Use ''Inventory Management'' module to delete the entire collection','Utiliser le module de ''Gestion des échantillons'' pour supprimer l''intégralité de la collection');
REPLACE INTO i18n (id,en,fr) 
VALUES 
('delete collection link', 'Delete (Link)', 'Supprimer (Lien)');
INSERT INTO menus(id, parent_id, is_root, display_order, language_title, use_link, use_summary, flag_active, flag_submenu)
VALUES 
('clin_CAN_67.2','clin_CAN_57','0','1', 'linked collection', '/ClinicalAnnotation/ClinicalCollectionLinks/detail/%%Participant.id%%/%%Collection.id%%/', 'InventoryManagement.ViewCollection::summary', 1, 1);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add message to first browser node after launching browsing from batch set  #2569
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_browsing_results CHANGE browsing_type browsing_type varchar(30) NOT NULL DEFAULT '';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('initiated from batchset', 'Browsing initiated from batchset', 'navigation initiée d''un lot de données');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Be able to access all linked objets from study #2513
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('tool_CAN_105.2', 'tool_CAN_100', 0, 2, 'records linked to study', '', '/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/', 'Study.StudySummary::summary', 1, 1);
SET @structure_id = (SELECT id FROM structures WHERE alias='aliquotinternaluses');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
(SELECT @structure_id, sfo.structure_field_id, 0, -2, '', sfo.flag_override_label, sfo.language_label, sfo.flag_override_tag, sfo.language_tag, sfo.flag_override_help, sfo.language_help, sfo.flag_override_type, sfo.type, sfo.flag_override_setting, sfo.setting, sfo.flag_override_default, sfo.default, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0
FROM structure_formats sfo 
INNER JOIN structure_fields sfi ON sfi.id = sfo.structure_field_id
INNER JOIN structures st ON st.id = sfo.structure_id
WHERE st.alias = 'aliquot_masters' AND sfi.field = 'barcode'); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) 
(SELECT @structure_id, sfo.structure_field_id, 0, -1, '', sfo.flag_override_label, sfo.language_label, sfo.flag_override_tag, sfo.language_tag, sfo.flag_override_help, sfo.language_help, sfo.flag_override_type, sfo.type, sfo.flag_override_setting, sfo.setting, sfo.flag_override_default, sfo.default, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0
FROM structure_formats sfo 
INNER JOIN structure_fields sfi ON sfi.id = sfo.structure_field_id
INNER JOIN structures st ON st.id = sfo.structure_id
WHERE st.alias = 'aliquot_masters' AND sfi.field = 'aliquot_label'); 
UPDATE structure_formats SET display_column = (display_column +2) WHERE structure_id = (SELECT id FROM structures WHERE alias='orderlines');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('orders','Orders','Commandes'),('order lines','Order lines','Lignes de commande'),('records linked to study', 'Data linked to study', 'Données attachées à l''étude');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Display all aliquot uses as a node into the collection tree view  #2452
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('viewaliquotuses_for_collection_tree_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='viewaliquotuses_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_definition' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_use_definition')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use and/or event' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '', '1', ':', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_use_datetime_defintion' AND `language_label`='date' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('shipping','Shipping','Livraison');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Remove AdHoc Query tool #2589
-- -----------------------------------------------------------------------------------------------------------------------------------

DROP TABLE datamart_adhoc_permissions;
DROP TABLE datamart_adhoc_favourites;
DROP TABLE datamart_adhoc_saved;
DELETE FROM datamart_batch_ids WHERE set_id IN (SELECT id FROM datamart_batch_sets WHERE datamart_adhoc_id IS NOT NULL AND datamart_adhoc_id NOT LIKE '');
DELETE FROM datamart_batch_sets WHERE datamart_adhoc_id IS NOT NULL AND datamart_adhoc_id NOT LIKE '';
ALTER TABLE datamart_batch_sets DROP FOREIGN KEY datamart_batch_sets_ibfk_2;
ALTER TABLE datamart_batch_sets DROP COLUMN datamart_adhoc_id;
DROP TABLE datamart_adhoc;
DELETE FROM menus WHERE use_link LIKE '/Datamart/Adhocs%';
ALTER TABLE `datamart_batch_sets` CHANGE `datamart_structure_id` `datamart_structure_id` INT( 11 ) UNSIGNED NOT NULL ;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='querytool_batch_set') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Datamart' AND `model`='BatchSet' AND `tablename`='datamart_batch_sets' AND `field`='flag_use_query_results' AND `language_label`='result based on a specific query' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_flag_use_query_results' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Datamart' AND `model`='BatchSet' AND `tablename`='datamart_batch_sets' AND `field`='flag_use_query_results' AND `language_label`='result based on a specific query' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_flag_use_query_results' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Datamart' AND `model`='BatchSet' AND `tablename`='datamart_batch_sets' AND `field`='flag_use_query_results' AND `language_label`='result based on a specific query' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_flag_use_query_results' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add classification for custom drop down list #2542
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE structure_permissible_values_custom_controls ADD COLUMN category varchar(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Generated', '', 'custom_permissible_values_counter', 'input',  NULL , '0', 'size=5', '', '', 'number of values', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdowns'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='custom_permissible_values_counter' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='number of values' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO structure_value_domains (domain_name, override, category, source) VALUES ("permissible_values_custom_categories", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("inventory", "inventory");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="inventory" AND language_alias="inventory"), "", "1");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical" AND language_alias="clinical"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("consent", "consent");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="consent" AND language_alias="consent"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("order", "order");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="order" AND language_alias="order"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("quality control", "quality control");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="quality control" AND language_alias="quality control"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("sop", "sop");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="sop" AND language_alias="sop"), "", "1");
INSERT IGNORE INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'StructurePermissibleValuesCustomControl', 'structure_permissible_values_custom_controls', 'category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='permissible_values_custom_categories') , '0', '', '', '', 'category', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdowns'), (SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustomControl' AND `tablename`='structure_permissible_values_custom_controls' AND `field`='category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='permissible_values_custom_categories')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='category' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES
('empty lists','Empty lists', 'Listes vides'),
('used lists','Used lists','Listes utilisées');
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'aliquot use and event types';
UPDATE structure_permissible_values_custom_controls SET category = 'consent' WHERE name = 'consent form versions';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'laboratory sites';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'laboratory staff';
UPDATE structure_permissible_values_custom_controls SET category = 'order' WHERE name = 'orders_contact';
UPDATE structure_permissible_values_custom_controls SET category = 'order' WHERE name = 'orders_institution';
UPDATE structure_permissible_values_custom_controls SET category = 'quality control' WHERE name = 'quality control tools';
UPDATE structure_permissible_values_custom_controls SET category = 'sop' WHERE name = 'sop versions';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'specimen collection sites';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'specimen supplier departments';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('inventory','Inventory','Inventaire'),('sop','SOP','SOP');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add option to support Event creation on multi line #2537
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE event_controls ADD COLUMN use_addgrid tinyint(1) NOT NULL DEFAULT '0';
UPDATE event_controls SET use_addgrid = '1' WHERE event_type = 'comorbidity' AND disease_site = 'general';
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_comorbidities') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_comorbidities') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_comorbidities' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_comorbidities') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_comorbidities' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '3', '10000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('at least one record has to be created', 'At least one record has to be created', 'Au moins une donnée doit être crée');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- can not unlock a locked batchset #2591
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('you are not allowed to unlock this batchset','You are not allowed to unlock this batchset','Vous n''êtes pas autorisé à débloquer ce lot de données'),
('unlock','Unlock','Débloquer');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Be able to launch browsing or create batchset from report...  #2590
-- -----------------------------------------------------------------------------------------------------------------------------------

-- report

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`) VALUES
(null, 'participant identifiers', 'list all identifiers of selected participants', 'report_participant_identifiers_criteria', 'report_participant_identifiers_result', 'index', 'participantIdentifiersSummary', 0);
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'Participant'), 'participant identifiers report', (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers'), 0, '');

SELECT '----------------------------------------------------------------------------------------------------------' AS 'PARTICIPANT IDENTIFIER REPORT'
UNION ALL 
SELECT "Queries to activate 'Participant Identifiers' demo report" as MSG
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'PARTICIPANT IDENTIFIER REPORT'
UNION ALL 
SELECT "UPDATE datamart_reports SET flag_active = 1 WHERE name = 'participant identifiers';" as MSG
UNION ALL
SELECT "UPDATE datamart_structure_functions SET flag_active = 1 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');" as 'PARTICIPANT IDENTIFIER REPORT'
UNION ALL 
SELECT '' AS 'PARTICIPANT IDENTIFIER REPORT';

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('list all identifiers of selected participants','List all identifiers of selected participants (version working on ATiM demo data)','Liste tous les identifiants de participants sélectionnés (version dévelopée sur les données ATiM demo'),
('participant identifiers','Participant Identifiers','Identifiants de participants'),
('participant identifiers report','Participant Identifiers Report','Rapport: Identifiants de participants');
INSERT INTO structures(`alias`) VALUES ('report_participant_identifiers_criteria');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_criteria'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', 'clin_demographics', '0', '', '0', '', '0', '', '0', '', '1', 'size=20,class=range file', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('report_participant_identifiers_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', '#BR', 'input',  NULL , '0', 'size=20', '', '', '#BR', ''),
('Datamart', '0', '', '#PR', 'input',  NULL , '0', 'size=20', '', '', '#PR', ''),
('Datamart', '0', '', 'hospital_number', 'input',  NULL, '1', 'size=20', '', '', 'hospital number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND field = 'first_name'), '0', '1', '', '1', 'name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND field = 'last_name'), '0', '2', '', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = '#BR'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = '#PR'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'hospital_number'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND field = 'participant_identifier'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('batch actions / reports','Batch Actions / Reports','Traitement par lot / Rapports'),
('more than 1000 records are returned by the query - please redefine search criteria', 'More than 1000 records are returned by the query. Please redefine search criteria.', 'Plus de 1000 données ont été retournées par la requête. Veuillez redéfinir les critères de recherche.');

-- batch set creation

ALTER TABLE datamart_reports ADD COLUMN  `associated_datamart_structure_id` int(10) unsigned  NULL;
ALTER TABLE `datamart_reports` ADD CONSTRAINT `datamart_reports_datamart_structures` FOREIGN KEY (`associated_datamart_structure_id`) REFERENCES `datamart_structures` (`id`);
UPDATE datamart_reports SET associated_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'Participant') WHERE name = 'participant identifiers';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('initiated from report', 'Browsing initiated from report', 'navigation initiée d''un rapport');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Move extend model to master detail models  #2454
-- -----------------------------------------------------------------------------------------------------------------------------------

-- **** PROTOCOL EXTEND ****
	
-- msg --

SELECT '----------------------------------------------------------------------------------------------------------'  AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT IF(COUNT(*) = 0,
"None: Don't execute following queries", 
"List of extend tables to work with:"
) AS 'Custom Protocol Extend tables to upgrade' 
FROM (SELECT DISTINCT extend_tablename FROM protocol_controls WHERE extend_tablename IS NOT NULL AND extend_tablename NOT IN ('pe_chemos')) AS extend_tables
UNION ALL
SELECT DISTINCT extend_tablename FROM protocol_controls WHERE extend_tablename IS NOT NULL AND extend_tablename NOT IN ('pe_chemos')
UNION ALL
SELECT 'Execute following queries (if required) to upgrade your database. Replace info between *** to appropriate values.' AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE' 
UNION ALL
SELECT "SET @protocol_extend_control_id = (SELECT id FROM protocol_extend_controls WHERE detail_tablename = '***EXTEND_TABLENAME***' AND detail_form_alias = '***EXTEND_FORM_ALIAS***');" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE protocol_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "INSERT INTO protocol_extend_masters (tmp_old_extend_id, protocol_extend_control_id, protocol_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @protocol_extend_control_id, protocol_master_id, created, created_by, modified, modified_by, deleted FROM ***EXTEND_TABLENAME***);" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME*** ADD protocol_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY FK_***EXTEND_TABLENAME***_protocol_masters, DROP COLUMN protocol_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "UPDATE protocol_extend_masters extend_master, ***EXTEND_TABLENAME*** extend_detail SET extend_detail.protocol_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME***_revs ADD COLUMN protocol_extend_master_id int(11) NOT NULL;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "UPDATE ***EXTEND_TABLENAME***_revs extend_detail_revs, ***EXTEND_TABLENAME*** extend_detail SET extend_detail_revs.protocol_extend_master_id = extend_detail.protocol_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME*** ADD CONSTRAINT FK_***EXTEND_TABLENAME***_protocol_extend_masters FOREIGN KEY (protocol_extend_master_id) REFERENCES protocol_extend_masters (id), DROP COLUMN id;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "INSERT INTO protocol_extend_masters_revs (id, protocol_extend_control_id, protocol_master_id, modified_by, version_created) (SELECT protocol_extend_master_id, @protocol_extend_control_id, protocol_master_id, modified_by, version_created FROM ***EXTEND_TABLENAME***_revs ORDER BY version_id ASC);" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE protocol_extend_masters DROP COLUMN tmp_old_extend_id;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME***_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN protocol_master_id;" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE';

SELECT '----------------------------------------------------------------------------------------------------------'  AS 'CUSTOM PROTOCOL EXTEND MODEL, CONTROLER AND VIEW UPGRADE'
UNION ALL
SELECT 'Don''t forget to uprgade your custom code' AS 'CUSTOM PROTOCOL EXTEND MODEL, CONTROLER AND VIEW UPGRADE'
UNION ALL
SELECT 'ProtocolExtends controllers, model an view have been changed to ProtocolExtendMasters' AS 'CUSTOM PROTOCOL EXTEND MODEL, CONTROLlER AND VIEW UPGRADE'
UNION ALL
SELECT '' AS 'CUSTOM PROTOCOL EXTEND MODEL, CONTROLlER AND VIEW UPGRADE';

-- work on control and master table --

CREATE TABLE `protocol_extend_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `detail_tablename` varchar(255) NOT NULL,
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

ALTER TABLE  protocol_controls
	ADD COLUMN `protocol_extend_control_id` int(11) DEFAULT NULL,
	DROP COLUMN created, 
	DROP COLUMN created_by, 
	DROP COLUMN modified, 
	DROP COLUMN modified_by;	
ALTER TABLE `protocol_controls` ADD CONSTRAINT `protocol_controls_protocol_extend_controls` FOREIGN KEY (`protocol_extend_control_id`) REFERENCES `protocol_extend_controls` (`id`);

INSERT INTO `protocol_extend_controls` (`detail_tablename`, `detail_form_alias`, `flag_active`) (SELECT DISTINCT extend_tablename, extend_form_alias, '1' FROM protocol_controls WHERE extend_tablename IS NOT NULL);
UPDATE protocol_controls pc, protocol_extend_controls pexc SET pc.protocol_extend_control_id = pexc.id WHERE pc.extend_tablename = pexc.detail_tablename AND pc.extend_form_alias = pexc.detail_form_alias AND pc.extend_tablename IS NOT NULL;
ALTER TABLE protocol_controls DROP COLUMN extend_tablename, DROP COLUMN extend_form_alias;

CREATE TABLE IF NOT EXISTS protocol_extend_masters (
  id int(11) NOT NULL AUTO_INCREMENT, 
  protocol_extend_control_id int(11) NOT NULL,
  protocol_master_id int(11) NOT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `protocol_extend_masters` 
  ADD CONSTRAINT `protocol_masters_protocol_extend_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`),
  ADD CONSTRAINT `protocol_extend_controls_protocol_extend_masters` FOREIGN KEY (`protocol_extend_control_id`) REFERENCES `protocol_extend_controls` (`id`);

CREATE TABLE IF NOT EXISTS protocol_extend_masters_revs (
  id int(11) NOT NULL,
  protocol_extend_control_id int(11) NOT NULL,
  protocol_master_id int(11) NOT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

UPDATE structure_fields SET model='ProtocolExtendDetail' WHERE model = 'ProtocolExtend';

UPDATE menus SET use_link = '/Protocol/ProtocolExtendMasters/listall/%%ProtocolMaster.id%%' WHERE use_link LIKE '/Protocol/ProtocolExtends/listall/%%ProtocolMaster.id%%';

-- specific upgrade statements of pe_chemos --

SET @protocol_extend_control_id = (SELECT id FROM protocol_extend_controls WHERE detail_tablename = 'pe_chemos' AND detail_form_alias = 'pe_chemos');
ALTER TABLE protocol_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;
INSERT INTO protocol_extend_masters (tmp_old_extend_id, protocol_extend_control_id, protocol_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @protocol_extend_control_id, protocol_master_id, created, created_by, modified, modified_by, deleted FROM pe_chemos);
ALTER TABLE pe_chemos ADD protocol_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY FK_pe_chemos_protocol_masters, DROP COLUMN protocol_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;
UPDATE protocol_extend_masters extend_master, pe_chemos extend_detail SET extend_detail.protocol_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;
ALTER TABLE pe_chemos_revs ADD COLUMN protocol_extend_master_id int(11) NOT NULL;
UPDATE pe_chemos_revs extend_detail_revs, pe_chemos extend_detail SET extend_detail_revs.protocol_extend_master_id = extend_detail.protocol_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;
ALTER TABLE pe_chemos ADD CONSTRAINT FK_pe_chemos_protocol_extend_masters FOREIGN KEY (protocol_extend_master_id) REFERENCES protocol_extend_masters (id), DROP COLUMN id;
INSERT INTO protocol_extend_masters_revs (id, protocol_extend_control_id, protocol_master_id, modified_by, version_created) (SELECT protocol_extend_master_id, @protocol_extend_control_id, protocol_master_id, modified_by, version_created FROM pe_chemos_revs ORDER BY version_id ASC);
ALTER TABLE protocol_extend_masters DROP COLUMN tmp_old_extend_id;
ALTER TABLE pe_chemos_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN protocol_master_id;

-- **** TREATMENT EXTEND ****
	
-- msg --

SELECT '----------------------------------------------------------------------------------------------------------'  AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT IF(COUNT(*) = 0,
"None: Don't execute following queries", 
"List of extend tables to work on"
) AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE' 
FROM (SELECT DISTINCT extend_tablename FROM treatment_controls WHERE extend_tablename IS NOT NULL AND extend_tablename NOT IN ('txe_chemos','txe_surgeries')) AS extend_tables
UNION ALL
SELECT DISTINCT extend_tablename FROM treatment_controls WHERE extend_tablename IS NOT NULL AND extend_tablename NOT IN ('txe_chemos','txe_surgeries')
UNION ALL
SELECT "SET @treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = '***EXTEND_TABLENAME***' AND detail_form_alias = '***EXTEND_FORM_ALIAS***');" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE treatment_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "INSERT INTO treatment_extend_masters (tmp_old_extend_id, treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted FROM ***EXTEND_TABLENAME***);" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME*** ADD treatment_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY ***EXTEND_TABLENAME***_ibfk_1, DROP COLUMN treatment_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "UPDATE treatment_extend_masters extend_master, ***EXTEND_TABLENAME*** extend_detail SET extend_detail.treatment_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME***_revs ADD COLUMN treatment_extend_master_id int(11) NOT NULL;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "UPDATE ***EXTEND_TABLENAME***_revs extend_detail_revs, ***EXTEND_TABLENAME*** extend_detail SET extend_detail_revs.treatment_extend_master_id = extend_detail.treatment_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME*** ADD CONSTRAINT FK_***EXTEND_TABLENAME***_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id), DROP COLUMN id;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "INSERT INTO treatment_extend_masters_revs (id, treatment_extend_control_id, treatment_master_id, modified_by, version_created) (SELECT treatment_extend_master_id, @treatment_extend_control_id, treatment_master_id, modified_by, version_created FROM ***EXTEND_TABLENAME***_revs ORDER BY version_id ASC);" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE treatment_extend_masters DROP COLUMN tmp_old_extend_id;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT "ALTER TABLE ***EXTEND_TABLENAME***_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN treatment_master_id;" AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
UNION ALL
SELECT '' AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE';

SELECT '----------------------------------------------------------------------------------------------------------'  AS 'CUSTOM TREATMENT EXTEND MODEL, CONTROLER AND VIEW UPGRADE'
UNION ALL
SELECT 'Don''t forget to uprgade your custom code' AS 'CUSTOM TREATMENT EXTEND MODEL, CONTROLER AND VIEW UPGRADE'
UNION ALL
SELECT 'TreatmentExtends controllers, model an view have been changed to TreatmentExtendMasters' AS 'CUSTOM TREATMENT EXTEND MODEL, CONTROLlER AND VIEW UPGRADE'
UNION ALL
SELECT '' AS 'CUSTOM TREATMENT EXTEND MODEL, CONTROLlER AND VIEW UPGRADE';

-- work on control and master table --

CREATE TABLE `treatment_extend_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `detail_tablename` varchar(255) NOT NULL,
  `detail_form_alias` varchar(255) NOT NULL DEFAULT '',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

ALTER TABLE  treatment_controls
	ADD COLUMN `treatment_extend_control_id` int(11) DEFAULT NULL;	
ALTER TABLE `treatment_controls` ADD CONSTRAINT `treatment_controls_treatment_extend_controls` FOREIGN KEY (`treatment_extend_control_id`) REFERENCES `treatment_extend_controls` (`id`);

INSERT INTO `treatment_extend_controls` (`detail_tablename`, `detail_form_alias`, `flag_active`) (SELECT DISTINCT extend_tablename, extend_form_alias, '1' FROM treatment_controls WHERE extend_tablename IS NOT NULL);
UPDATE treatment_controls pc, treatment_extend_controls pexc SET pc.treatment_extend_control_id = pexc.id WHERE pc.extend_tablename = pexc.detail_tablename AND pc.extend_form_alias = pexc.detail_form_alias AND pc.extend_tablename IS NOT NULL;
ALTER TABLE treatment_controls DROP COLUMN extend_tablename, DROP COLUMN extend_form_alias;

CREATE TABLE IF NOT EXISTS treatment_extend_masters (
  id int(11) NOT NULL AUTO_INCREMENT, 
  treatment_extend_control_id int(11) NOT NULL,
  treatment_master_id int(11) NOT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `treatment_extend_masters` 
  ADD CONSTRAINT `treatment_masters_treatment_extend_masters` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`),
  ADD CONSTRAINT `treatment_extend_controls_treatment_extend_masters` FOREIGN KEY (`treatment_extend_control_id`) REFERENCES `treatment_extend_controls` (`id`);

CREATE TABLE IF NOT EXISTS treatment_extend_masters_revs (
  id int(11) NOT NULL,
  treatment_extend_control_id int(11) NOT NULL,
  treatment_master_id int(11) NOT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

UPDATE structure_fields SET model='TreatmentExtendDetail' WHERE model = 'TreatmentExtend';

UPDATE menus SET use_link = '/ClinicalAnnotation/TreatmentExtendMasters/listall/%%Participant.id%%/%%TreatmentMaster.id%%' WHERE use_link LIKE '/ClinicalAnnotation/TreatmentExtends/listall/%%Participant.id%%/%%TreatmentMaster.id%%';

ALTER TABLE treatment_extend_controls 
	ADD COLUMN type varchar(255) NOT NULL DEFAULT '',
	ADD COLUMN databrowser_label varchar(50) NOT NULL DEFAULT '';
UPDATE treatment_extend_controls SET type = 'chemotherapy drug', databrowser_label = 'chemotherapy drug' WHERE detail_form_alias = 'txe_chemos' AND detail_tablename = 'txe_chemos';
UPDATE treatment_extend_controls SET type = 'surgery procedure', databrowser_label = 'surgery procedure' WHERE detail_form_alias = 'txe_surgeries' AND detail_tablename = 'txe_surgeries';
UPDATE treatment_extend_controls SET type = 'unknown precision', databrowser_label = 'unknown precision' WHERE type = '' AND databrowser_label = '';

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('surgery procedure','Surgery Procedure','Procédure de Chirurgie'),
('treatment precision','Treatment Precision','Précision des Traitment'),
('chemotherapy drug','Chemotherapy Drug','Molécule de chimiothérapie'),
('unknown precision','Precision','Précision');

INSERT INTO structures(`alias`) VALUES ('treatment_extend_masters');
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'tx_precision_type', 'open', '', 'ClinicalAnnotation.TreatmentExtendControl::getPrecisionTypeValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendControl', 'treatment_extend_controls', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tx_precision_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatment_extend_masters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendControl' AND `tablename`='treatment_extend_controls' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_precision_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) VALUES
(null, 'ClinicalAnnotation', 'TreatmentExtendMaster', (SELECT id FROM structures WHERE alias = 'treatment_extend_masters'), NULL, 'treatment precision', 'TreatmentExtendMaster', '/ClinicalAnnotation/TreatmentMasters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/', '');

INSERT INTO i18n (id,en,fr) 
VALUES 
('at least one precision is defined as protocol component', 'At least one precision is defined as protocol component', 'Au moins une précision est définie comme composante de ce protocole'),
('at least one precision is defined as treatment component','At least one precision is defined as treatment component', 'Au moins une précision est définie comme composante de ce traitement'),
('drug is defined as a component of at least one protocol','Drug is defined as a component of at least one protocol', 'Le médicament est défini comme un composant d''au moins un protocole');

-- specific upgrade statements of txe_chemos -- 

SET @treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos' AND detail_form_alias = 'txe_chemos');
ALTER TABLE treatment_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;
INSERT INTO treatment_extend_masters (tmp_old_extend_id, treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted FROM txe_chemos);
ALTER TABLE txe_chemos ADD treatment_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY txe_chemos_ibfk_1, DROP COLUMN treatment_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;
UPDATE treatment_extend_masters extend_master, txe_chemos extend_detail SET extend_detail.treatment_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;
ALTER TABLE txe_chemos_revs ADD COLUMN treatment_extend_master_id int(11) NOT NULL;
UPDATE txe_chemos_revs extend_detail_revs, txe_chemos extend_detail SET extend_detail_revs.treatment_extend_master_id = extend_detail.treatment_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;
ALTER TABLE txe_chemos ADD CONSTRAINT FK_txe_chemos_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id), DROP COLUMN id;
INSERT INTO treatment_extend_masters_revs (id, treatment_extend_control_id, treatment_master_id, modified_by, version_created) (SELECT treatment_extend_master_id, @treatment_extend_control_id, treatment_master_id, modified_by, version_created FROM txe_chemos_revs ORDER BY version_id ASC);
ALTER TABLE treatment_extend_masters DROP COLUMN tmp_old_extend_id;
ALTER TABLE txe_chemos_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN treatment_master_id;

-- specific upgrade statements of txe_surgeries --

SET @treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_surgeries' AND detail_form_alias = 'txe_surgeries');
ALTER TABLE treatment_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;
INSERT INTO treatment_extend_masters (tmp_old_extend_id, treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted FROM txe_surgeries);
ALTER TABLE txe_surgeries ADD treatment_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY txe_surgeries_ibfk_1, DROP COLUMN treatment_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;
UPDATE treatment_extend_masters extend_master, txe_surgeries extend_detail SET extend_detail.treatment_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;
ALTER TABLE txe_surgeries_revs ADD COLUMN treatment_extend_master_id int(11) NOT NULL;
UPDATE txe_surgeries_revs extend_detail_revs, txe_surgeries extend_detail SET extend_detail_revs.treatment_extend_master_id = extend_detail.treatment_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;
ALTER TABLE txe_surgeries ADD CONSTRAINT FK_txe_surgeries_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id), DROP COLUMN id;
INSERT INTO treatment_extend_masters_revs (id, treatment_extend_control_id, treatment_master_id, modified_by, version_created) (SELECT treatment_extend_master_id, @treatment_extend_control_id, treatment_master_id, modified_by, version_created FROM txe_surgeries_revs ORDER BY version_id ASC);
ALTER TABLE treatment_extend_masters DROP COLUMN tmp_old_extend_id;
ALTER TABLE txe_surgeries_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN treatment_master_id;

-- specific upgrade statements of txe_radiations --

SELECT IF(COUNT(*) = 0, 
"Please drop table txe_radiations: DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;",
"Seams you are using txe_radiations. Be sure you correctly upgraded txe_radiations."
) AS 'txe_radiations TABLE DELETION' 
FROM txe_radiations;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Be able to browse on treatment extend  #2605
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'TreatmentExtendMaster'), (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster'), 1, 1, 'treatment_master_id');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id IN (SELECT structures.id FROM structures INNER JOIN treatment_extend_controls ON treatment_extend_controls.detail_form_alias = structures.alias);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add missing value to structure_value_domains models  # (no issue)
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_permissible_values (value, language_alias) VALUES("TreatmentExtendMaster", "treatment precisions");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="models"), (SELECT id FROM structure_permissible_values WHERE value="TreatmentExtendMaster" AND language_alias="treatment precisions"), "", "1");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- date format export in csv to be excel complaint  #2595
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('date in excel format','Date in excel format','Date au format excel'),
('date_accuracy_value_c','Exact','Exacte'),
('date_accuracy_value_y','±Year','±Année'),
('date_accuracy_value_m','Year','Année'),
('date_accuracy_value_d','Month','Mois'),
('date_accuracy_value_h','Day','Jour'),
('date_accuracy_value_i','Hour','Heure');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- hide field type in csv popup
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='csv_popup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_export_type') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add new specimen type CSF #2596
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Add new type to controls table
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('csf', 'specimen', 'sd_spe_csf,specimens', 'sd_spe_csfs', 0, 'csf');

-- Create empty structure for new CSF type
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_csf');

-- Build table and rev for CSF
CREATE TABLE `sd_spe_csfs` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  KEY `FK_sd_spe_csfs_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_csfs_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_spe_csfs_revs` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Enable for use
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('csf', 'CSF', '');

-- Add tables for CSF derivatives (supernataunt and cells)

CREATE TABLE `sd_der_csf_sups` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_csf_sups_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_csf_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_der_csf_sups_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_der_csf_cells` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_csf_cells_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_csf_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_der_csf_cells_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add new type to controls table
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('csf supernatant', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_csf_sups', '0', 'csf supernatant'),
('csf cells', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_csf_cells', '0', 'csf cells');

-- Enable for use
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
 ((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf supernatant' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), '1'),
 ((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf cells' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('csf cells', 'CSF Cells', ''),
	('csf supernatant', 'CSF Supernatant', '');


-- Aliquot for CSF specimen
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), 'tube', '(ul)', 'ad_spec_tubes_incl_ul_vol', 'ad_tubes', 'ul', '1', 'Specimen tube requiring volume in ul', '0', 'csf|tube');

-- Structure for ul specimen tube
INSERT INTO `structures` (`alias`) VALUES ('ad_spec_tubes_incl_ul_vol');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='lot number' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '1', 'inv_coll_to_stor_spent_time_msg_defintion', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
 
-- Aliquot for CSF Cell
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf cells' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), 'tube', '(ul)', 'ad_der_tubes_incl_ul_vol', 'ad_tubes', 'ul', '1', 'Derivative tube requiring volume in ul', '0', 'csf cells|tube');

-- Aliquot for CSF Supernatant
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf supernatant' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), 'tube', '(ul)', 'ad_der_tubes_incl_ul_vol', 'ad_tubes', 'ul', '1', 'Derivative tube requiring volume in ul', '0', 'csf supernatant|tube');

-- Structure for ul derivative tube
INSERT INTO `structures` (`alias`) VALUES ('ad_der_tubes_incl_ul_vol');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='lot number' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '1', 'inv_coll_to_stor_spent_time_msg_defintion', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add new specimen type Saliva #2597
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Add new saliva sample	
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('saliva', 'specimen', 'sd_spe_salivas,specimens', 'sd_spe_salivas', '1', 'saliva');

-- New blank structure for saliva specimen
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_salivas');

-- Table structure for saliva
CREATE TABLE `sd_spe_salivas` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_spe_salivas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_salivas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB;

-- Tube for new saliva
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `detail_form_alias`, `detail_tablename`, `flag_active`, `databrowser_label`) VALUES ((SELECT id FROM `sample_controls` WHERE `sample_type` = 'saliva'), 'tube', 'ad_spec_tubes', 'ad_tubes', '1', 'saliva|tube');

-- Allow DNA creation from new saliva sample and enable saliva
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES ((SELECT id FROM `sample_controls` WHERE `sample_type` = 'saliva'), '12', '1');
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT id FROM `sample_controls` WHERE `sample_type` = 'saliva'), '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	("saliva", "Saliva", '');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Function to list differences between 2 nodes or batchset  #2522
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('batchset_and_node_elements_distribution');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'Generated', '', 'batchset_and_node_elements_distribution_description', 'input',  NULL , '0', 'size=30', '', '', 'batchset and node elements distribution description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='batchset_and_node_elements_distribution'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='batchset_and_node_elements_distribution_description' AND `type`='input'), '-10', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('compare contents','Compare Contents','Comparer le contenu'),
('compare to compatible batchset', 'Compare to compatible batchset', 'Comparer à un lot de données compatible'),
('batchset and node elements distribution description', 'Data distribution', 'Répartition des données'),
('data of previously displayed %s_1 (1)', 'Previously displayed %s_1 (1)', '%s_1 précédemment affiché (1)'),
('data of selected %s_2 (2)', 'Selected %s_2 (2)', "%s_2 sélectionné (2)"),
('data of previously displayed %s_1 only (1)', 'Previously displayed %s_1 only (1)', '%s_1 précédemment affiché seulement (1)'),
('data of selected %s_2 only (2)', 'Selected %s_2 only (2)', "%s_2 sélectionné seulement (2)"),
('data both in previously displayed %s_1 and selected %s_2 (1 & 2)', 'Both in previously displayed %s_1 and selected %s_2 (1 & 2)', 'Dans le %s_1 précédemment affiché et le %s_2 sélectionné (1 & 2)'),
('databrowser_node','Databrowser Node', "Noeud du 'Navigateur de Données'"),
('compare','Compare','comparer');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Reetrant browsing #2361
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO datamart_browsing_controls(id1, id2, flag_active_1_to_2, flag_active_2_to_1, use_field) VALUES
(5, 5, 1, 1, "parent_id");

ALTER TABLE datamart_browsing_results
 ADD COLUMN parent_children CHAR( 1 ) NOT NULL DEFAULT  ' ' AFTER browsing_structures_sub_id;

-- -----------------------------------------------------------------------------------------------------------------------------------
--  Create tool to create new storage type (storage controls)  #2423
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('core_CAN_41_7', 'core_CAN_41', 0, 3, 'manage storage types', '', '/Administrate/StorageControls/listAll/', '', 1, 1);

-- create demo storage 

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'demo1', 'column', 'integer', 4, 'row', 'integer', 3, 0, 0, 0, 0, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '101', 1),
(null, 'demo2', 'column', 'integer', 4, 'row', 'integer', 3, 0, 0, 1, 0, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '102', 1),
(null, 'demo3', 'column', 'integer', 4, 'row', 'integer', 3, 0, 0, 0, 1, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '103', 1),
(null, 'demo4', 'column', 'integer', 8, NULL, NULL, NULL, 1, 8, 0, 0, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '104', 1),
(null, 'demo5', 'column', 'integer', 8, NULL, NULL, NULL, 1, 8, 0, 1, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '105', 1),
(null, 'demo6', 'column', 'integer', 8, NULL, NULL, NULL, 8, 1, 0, 0, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '106', 1),
(null, 'demo7', 'column', 'integer', 8, NULL, NULL, NULL, 8, 1, 1, 0, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '107', 1),
(null, 'demo8', 'column', 'integer', 8, NULL, NULL, NULL, 4, 2, 0, 0, 1, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '108', 1),
(null, 'demo9', 'column', 'integer', 8, NULL, NULL, NULL, 4, 2, 1, 0, 1, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '109', 1),
(null, 'demo10', 'column', 'integer', 8, NULL, NULL, NULL, 4, 2, 0, 0, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '110', 1),
(null, 'demo11', 'column', 'integer', 8, NULL, NULL, NULL, 4, 2, 1, 0, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '111', 1),
(null, 'demo12', 'column', 'integer', 8, NULL, NULL, NULL, 4, 2, 1, 1, 0, 0, 0, 0, 'storage_w_spaces', 'std_boxs', '112', 1);
UPDATE storage_controls SET databrowser_label = storage_type WHERE storage_type LIKE 'demo%';
INSERT INTO i18n (id,en,fr)
VALUES 
('demo1', 'Demo1', 'Demo1'),
('demo2', 'Demo2', 'Demo2'),
('demo3', 'Demo3', 'Demo3'),
('demo4', 'Demo4', 'Demo4'),
('demo5', 'Demo5', 'Demo5'),
('demo6', 'Demo6', 'Demo6'),
('demo7', 'Demo7', 'Demo7'),
('demo8', 'Demo8', 'Demo8'),
('demo9', 'Demo9', 'Demo9'),
('demo10', 'Demo10', 'Demo10'),
('demo11', 'Demo11', 'Demo11'),
('demo12', 'Demo12', 'Demo12');

--  existing controls check and clean up

UPDATE storage_controls SET coord_x_title = null WHERE coord_x_title = '';
UPDATE storage_controls SET coord_x_size = null WHERE coord_x_size = '';
UPDATE storage_controls SET coord_y_title = null WHERE coord_y_title = '';
UPDATE storage_controls SET coord_y_size = null WHERE coord_y_size = '';
UPDATE storage_controls SET display_x_size = 0, display_y_size = 0, horizontal_increment = 0 WHERE coord_y_title IS NOT NULL;

SELECT id AS 'storage control id to correct', 'coord_x_ fields error #1' AS 'issue detail' FROM storage_controls 
WHERE coord_x_title IS NULL AND (coord_x_type IS NOT NULL OR coord_x_size IS NOT NULL)
UNION ALL
SELECT id AS 'storage control id to correct', 'coord_x_ fields error #2' AS 'issue detail' FROM storage_controls 
WHERE coord_x_type IS NULL AND coord_x_size IS NOT NULL
UNION ALL
SELECT id AS 'storage control id to correct', 'coord_x_ fields error #3' AS 'issue detail' FROM storage_controls 
WHERE coord_x_type = 'list' AND (coord_x_title IS NULL OR coord_x_size IS NOT NULL)
UNION ALL
SELECT id AS 'storage control id to correct', 'coord_y_ fields error #1' AS 'issue detail' FROM storage_controls 
WHERE coord_y_title IS NULL AND (coord_y_type IS NOT NULL OR coord_y_size IS NOT NULL)
UNION ALL
SELECT id AS 'storage control id to correct', 'coord_y_ fields error #2' AS 'issue detail' FROM storage_controls 
WHERE coord_y_type IS NULL AND coord_y_size IS NOT NULL
UNION ALL
SELECT id AS 'storage control id to correct', 'coord_x&y_ fields error #1' AS 'issue detail' FROM storage_controls 
WHERE coord_x_title IS NULL AND coord_y_title IS NOT NULL
UNION ALL
SELECT id AS 'storage control id to correct', 'display_x_size x display_y_size fields error #1' AS 'issue detail' FROM storage_controls 
WHERE coord_x_size IS NOT NULL AND coord_y_title IS NULL AND (display_x_size * display_y_size) != coord_x_size
UNION ALL
SELECT id AS 'storage control id to correct', 'storage temperature error #1' AS 'issue detail' FROM storage_controls 
WHERE (detail_form_alias LIKE '%storage_temperature%' AND set_temperature = 0) OR (detail_form_alias NOT LIKE '%storage_temperature%' AND set_temperature = 1)
UNION ALL
SELECT id AS 'storage control id to correct', 'storage w. spaces error #1' AS 'issue detail' FROM storage_controls 
WHERE detail_form_alias LIKE '%storage_w_spaces%' AND coord_x_title IS NULL;

-- remove storage temperature from detail_form_alias

UPDATE storage_controls SET detail_form_alias = REPLACE(detail_form_alias, 'storage_temperature,', '') WHERE detail_form_alias LIKE '%storage_temperature%';
UPDATE storage_controls SET detail_form_alias = REPLACE(detail_form_alias, ',storage_temperature', '') WHERE detail_form_alias LIKE '%storage_temperature%';
UPDATE storage_controls SET detail_form_alias = REPLACE(detail_form_alias, 'storage_temperature', '') WHERE detail_form_alias LIKE '%storage_temperature%';

-- remove storage w space from detail_form_alias if required

UPDATE storage_controls SET detail_form_alias = REPLACE(detail_form_alias, 'storage_w_space,', '') WHERE coord_x_title IS NULL;
UPDATE storage_controls SET detail_form_alias = REPLACE(detail_form_alias, ',storage_w_space', '') WHERE coord_x_title IS NULL;
UPDATE storage_controls SET detail_form_alias = REPLACE(detail_form_alias, 'storage_w_space', '') WHERE coord_x_title IS NULL;

-- structure

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("storage_coord_types", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="storage_coord_types"), (SELECT id FROM structure_permissible_values WHERE value="list" AND language_alias="list"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="storage_coord_types"), (SELECT id FROM structure_permissible_values WHERE value="integer" AND language_alias="integer"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="storage_coord_types"), (SELECT id FROM structure_permissible_values WHERE value="alphabetical" AND language_alias="alphabetical"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("storage_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'storage types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('storage types', 1, 30, 'storages');
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) (SELECT sc.storage_type, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 FROM storage_controls sc LEFT JOIN i18n ON i18n.id = sc.storage_type);

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'storage coordinate titles\')" WHERE domain_name = 'storage_coordinate_title';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('storage coordinate titles', 1, 30, 'storages');
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT val.value, i18n.en, i18n.fr, '1', @control_id, NOW(), NOW(), 1, 1 FROM structure_value_domains svd INNER JOIN structure_value_domains_permissible_values link ON link.structure_value_domain_id = svd.id INNER JOIN structure_permissible_values val ON link.structure_permissible_value_id = val.id LEFT JOIN i18n ON i18n.id = val.language_alias WHERE svd.domain_name = 'storage_coordinate_title');
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="row" AND spv.language_alias="row";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="column" AND spv.language_alias="column";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="position" AND spv.language_alias="position";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="n/a" AND spv.language_alias="n/a";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="shelf" AND spv.language_alias="shelf";

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageCtrl', 'storage_controls', 'storage_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='storage_types') , '0', '', '', '', 'storage type', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'flag_active', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'active', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'coord_x_title', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title') , '0', '', '', '', 'coord_x_title', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'coord_x_type', '', (SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types') , '0', '', '', '', 'coord_x_type', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'coord_x_size', 'input',  NULL , '0', 'size=5', '', '', 'coord_x_size', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'display_x_size', 'input',  NULL , '0', 'size=3', '', '', 'display_x_size', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'reverse_x_numbering', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'reverse_x_numbering', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'horizontal_increment', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'horizontal_increment', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'coord_y_title', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title') , '0', '', '', '', 'coord_y_title', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'coord_y_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types') , '0', '', '', '', 'coord_y_type', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'coord_y_size', 'input',  NULL , '0', 'size=5', '', '', 'coord_y_size', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'display_y_size', 'input',  NULL , '0', 'size=3', '', '', 'display_y_size', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'reverse_y_numbering', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'reverse_y_numbering', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'set_temperature', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'set temperature', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'is_tma_block', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tma block', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'check_conflicts', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'check conflicts', ''), 
('StorageLayout', 'FunctionManagement', '', 'check_white_space', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'check white space', '');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_title'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_type'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_title'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_type'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size'), 'notEmpty');

INSERT INTO structures(`alias`) VALUES ('storage_controls');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='flag_active' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='active' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_title' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_title' AND `language_tag`=''), '0', '10', 'storage_coord_x', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_type' AND `type`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_type' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_size' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_x_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='display_x_size' AND `language_tag`=''), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_x_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_x_numbering' AND `language_tag`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='horizontal_increment' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='horizontal_increment' AND `language_tag`=''), '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_title' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_title' AND `language_tag`=''), '0', '30', 'storage_coord_y', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_type' AND `language_tag`=''), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_size' AND `language_tag`=''), '0', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_y_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='display_y_size' AND `language_tag`=''), '0', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_y_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_y_numbering' AND `language_tag`=''), '0', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='set_temperature' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='set temperature' AND `language_tag`=''), '0', '50', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='is_tma_block' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tma block' AND `language_tag`=''), '0', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check conflicts' AND `language_tag`=''), '0', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check white space' AND `language_tag`=''), '0', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageCtrl', 'storage_controls', 'storage_type', 'input',  NULL , '0', 'size=10', '', '', 'storage type', '');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='input' AND `structure_value_domain`  IS NULL ), 'isUnique'),
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='input' AND `structure_value_domain`  IS NULL ), 'notEmpty');

INSERT INTO structures(`alias`) VALUES ('storage_control_1d');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`,`flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_title' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_title' AND `language_tag`=''), '0', '10', 'storage_coord_x', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_type' AND `type`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_type' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_size' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_x_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='display_x_size' AND `language_tag`=''), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_x_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_x_numbering' AND `language_tag`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='horizontal_increment' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='horizontal_increment' AND `language_tag`=''), '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_y_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='display_y_size' AND `language_tag`=''), '0', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_y_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_y_numbering' AND `language_tag`=''), '0', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='set_temperature' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='set temperature' AND `language_tag`=''), '0', '50', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check conflicts' AND `language_tag`=''), '0', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_1d'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check white space' AND `language_tag`=''), '0', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('storage_control_2d');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_title' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_title' AND `language_tag`=''), '0', '10', 'storage_coord_x', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_type' AND `type`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_type' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_size' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_x_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_x_numbering' AND `language_tag`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_title' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_title' AND `language_tag`=''), '0', '30', 'storage_coord_y', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_type' AND `language_tag`=''), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_size' AND `language_tag`=''), '0', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_y_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_y_numbering' AND `language_tag`=''), '0', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='set_temperature' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='set temperature' AND `language_tag`=''), '0', '50', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check conflicts' AND `language_tag`=''), '0', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check white space' AND `language_tag`=''), '0', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('storage_control_no_d');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_no_d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_no_d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_no_d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='set_temperature' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='set temperature' AND `language_tag`=''), '0', '50', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_fields SET type ='select' WHERE model = 'StorageCtrl' AND field =  'coord_x_type' AND type ='';

INSERT INTO structures(`alias`) VALUES ('storage_control_tma');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_title' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_title' AND `language_tag`=''), '0', '10', 'storage_coord_x', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_type' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='coord_x_size' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_x_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_x_numbering' AND `language_tag`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_title' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_title' AND `language_tag`=''), '0', '30', 'storage_coord_y', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coord_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_type' AND `language_tag`=''), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='coord_y_size' AND `language_tag`=''), '0', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='reverse_y_numbering' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reverse_y_numbering' AND `language_tag`=''), '0', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check conflicts' AND `language_tag`=''), '0', '52', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='check white space' AND `language_tag`=''), '0', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_fields SET type ='integer_positive' WHERE model = 'StorageCtrl' AND field IN ('coord_x_size', 'coord_y_size');

-- Custom storage details table

CREATE TABLE IF NOT EXISTS `std_customs` (
  `storage_master_id` int(11) NOT NULL,
  KEY `FK_std_boxs_storage_masters` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `std_customs_revs` (
  `storage_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;
ALTER TABLE `std_customs`
  ADD CONSTRAINT `FK_std_customs_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`);

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('storage_coord_x', 'Coordinate ''X'' (X-axis)', 'Coordonné ''X'' (Abscisse)'),
('storage_coord_y', 'Coordinate ''Y'' (Y-axis)', 'Coordonné ''Y'' (Ordonnée)'),
('coord_x_size','Values number','Nombre de valeurs'),
('coord_x_title','Title','Titre'),
('coord_x_type','Type','Type'),
('coord_y_size','Values number','Nombre de valeurs'),
('coord_y_title','Title','Titre'),
('coord_y_type','Type','Type'),
('display_x_size','Size for display (X-axis)','Taille pour affichage (Abscisse)'),
('display_y_size','Size for display (Y-axis)','Taille pour affichage (Ordonnée)'),
('horizontal_increment','Increment horizontally','Incrémenter horizontalement'),
('manage storage types','Manage storage types','Gestion des types d''entreposage'),
('reverse_x_numbering','Reverse numbering (X-axis)','Inverser la numérotation (Abscisse)'),
('reverse_y_numbering','Reverse numbering (Y-axis)','Inverser la numérotation (Ordonnée)'),
('set temperature','Set temperature','Definir temprature'),
('TMA Block','TMA Block','TMA Bloc'),
('check conflicts','Check conflicts','Vérifier les conflits'),
('check white space','Check white space','Vérifier espaces vides'),
('the coordinate x size has to be completed', 'The size of the coordinate ''X'' (X-axis) has to be completed', 'La taille de la coordonné ''X'' (Abscisse) doit être définie'),
('no type list can be set for x or y fields in 2 dimensions storage type', 'No type ''List'' can be set for both coordinates of a 2 dimensions storages', 'Aucun type ''Liste'' ne peut être choisi pour une coordonné d''un entreposage à deux dimensions'),
('a size of an alphabetical coordinate has to be less than 25 values', 'The size of an alphabetical coordinate has to be less than 25 values', 'La taille d''une coordonné ''Alphabétique'' doit être inferieure à 25'),
('no coordinate x size has to be set for list', 'No size has to be set for a coordinate ''X'' (X-axis) having type equal to ''List''', 'Aucun taille ne doit être définie pour une coordonné ''X'' (Abscisse)  de type ''Liste'''),
('a coordinate x size has to be set', 'A coordinate ''X'' (X-axis) has to be set', 'Une coordonné ''Alphabétique'' doit être saisie'),
('display y size * display y size should be equal to coord x size', '[Size for display of X-axis] * [Size for display of Y-axis] should be equal to [values number of (X-axis)]', '[Taille pour affichage (Abscisse)] * [Taille pour affichage (Ordonnée)] doit être égal au nombre de valeurs de la coordonné ''X'' (Abscisse)'),
('no coordinate', 'No coordinate', 'No coordinate'),
('1 coordinate', '1 coordinate', '1 coordinate'),
('2 coordinates', '2 coordinates', '2 coordinates'),
('please use custom drop down list administration tool to add storage type translations', 'Please use Dropdown List Configuration tool to add storage type translations', "Utiliser l'outil de gestion des listes de valeurs pour ajouter les traductions des types d'entreposage."),
('you are not allowed to work on active storage type', 'You are not allowed to work on active storage type', "Vous n'êtes pas autorisé à travailler sur des types d'entreposage actifs"),
('this storage type has already been used to build a storage - active status ca not be changed', 'This storage type has already been used to build storages - Active status can not be changed to inactive', 'Ce type d''entreposage a déjà été utilisé pour construire un entreposage - L''état ​​actif ne peut pas être modifié à inactif'),
('change active status', 'Change active status', 'Changer le statu'),
('no layout exists', 'No layout exists', 'Aucun plan de l''entreposage n''existe'),
('see layout', 'See Layout', 'Afficher le plan'),
('custom layout will be built adding coordinates to a created storage','No layout - Custom layout will be defined adding coordinates to a created storage','Aucun plan de l''entreposage - Le plan de l''entreposage sera défini en ajoutant des coordonnées à un entreposage créé'),
('this storage type has already been used to build a storage - active status can not be changed','This storage type has already been used to build a storage - Active status can not be changed','Ce type d''entreposage a déjà été utilisé pour construire un entreposage - Le statu ne peut pas être modifié'),
('custom layout will be built adding coordinates to a created storage','No layout - Custom layout will be defined adding coordinates to a created storage','Aucun plan de l''entreposage - Le plan de l''entreposage sera défini en ajoutant des coordonnées à un entreposage créé'),
('no layout exists - add coordinates first', 'No layout can be built - Add coordinates first', 'Aucun plan de l''entreposage ne peut être créé - Veuiller définir les coordonnées de l''entreposage'),
('at least one stored element is not displayed in layout', 'At least one stored element is not displayed in layout', 'Au moins un élément entreposé n''a pas de position définie');

UPDATE structure_value_domains SET domain_name = 'storage_types_from_control_id' WHERE domain_name = 'storage_type';

REPLACE INTO i18n (id,en,fr) VALUES ('storages','Storages','Entreposage');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Translated Storage Types not correctly displayed in databrowser   #2638
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE storage_controls MODIFY databrowser_label varchar(150) NOT NULL DEFAULT '';
UPDATE storage_controls SET databrowser_label = CONCAT('custom#storage types#',storage_type);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- delete from db all temporary browser trees when tmp_browsing_limit is reached #2641
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_browsing_results DROP COLUMN deleted;
ALTER TABLE datamart_browsing_indexes DROP COLUMN deleted;
DROP TABLE datamart_browsing_indexes_revs;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Search aliquots then collection having more than 2 aliquots #2643
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
(1, 2, 1, 1, 'collection_id');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Saved Browsing Steps : See Steps details #2511
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'Generated', '', 'description', 'textarea',  NULL , '0', '', '', '', 'saved browsing description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_saved_browsing'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='description' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='saved browsing description' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('saved browsing description', 'Steps', 'Étapes'), ('no search criteria', 'No search criteria', 'Aucun critères de recherche');
REPLACE INTO i18n (id,en,fr) VALUES ('saved browsing description', 'Steps', 'Étapes'), ('no search criteria', 'No search criteria', 'Aucun critères de recherche');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @id = (SELECT id from acos where alias='Administrate');
UPDATE acos SET alias='PreferencesAdmin' WHERE parent_id=@id and alias='Preferences';

UPDATE menus SET use_link='/Administrate/PreferencesAdmin/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_2';

ALTER TABLE users
 DROP COLUMN lang;

INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2, flag_active_2_to_1, use_field) VALUES
(13, 1, 1, 1, "aliquot_master_id");
