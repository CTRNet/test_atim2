-- ------------------------------------------------------
-- ATiM v2.6.0 Upgrade Script
-- version: 2.6.0
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

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
SELECT 'Structures & Spent Time Fields to Review' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL
SELECT 'Spent time field properties should be consistant with the following example (see array below)' AS 'SPENT TIME FIELDS REVIEW'
UNION ALL
SELECT '
+--------------------------+-------------+------------------------------+------------------+----------------------------------------+-------------+------------+-------------+----------+-----------+--------------+---------------+----------------+--------------+
| structure_alias          | model       | field                        | type             | language_label                         | flag_search | flag_index | flag_detail | flag_add | flag_edit | flag_addgrid | flag_editgrid | flag_batchedit | flag_summary |
+--------------------------+-------------+------------------------------+------------------+----------------------------------------+-------------+------------+-------------+----------+-----------+--------------+---------------+----------------+--------------+
| ad_der_tubes_incl_ml_vol | ViewAliquot | coll_to_stor_spent_time_msg  | input            | collection to storage spent time       |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |
| ad_der_tubes_incl_ml_vol | ViewAliquot | coll_to_stor_spent_time_msg  | integer_positive | collection to storage spent time (min) |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |
| ad_der_tubes_incl_ml_vol | ViewAliquot | creat_to_stor_spent_time_msg | input            | creation to storage spent time         |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |
| ad_der_tubes_incl_ml_vol | ViewAliquot | creat_to_stor_spent_time_msg | integer_positive | creation to storage spent time (min)   |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |
| ad_spec_tubes            | ViewAliquot | coll_to_stor_spent_time_msg  | input            | collection to storage spent time       |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |
| ad_spec_tubes            | ViewAliquot | coll_to_stor_spent_time_msg  | integer_positive | collection to storage spent time (min) |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |
| ad_spec_tubes            | ViewAliquot | rec_to_stor_spent_time_msg   | input            | reception to storage spent time        |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |
| ad_spec_tubes            | ViewAliquot | rec_to_stor_spent_time_msg   | integer_positive | reception to storage spent time (min)  |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |
+--------------------------+-------------+------------------------------+------------------+----------------------------------------+-------------+------------+-------------+----------+-----------+--------------+---------------+----------------+--------------+
' AS 'SPENT TIME FIELDS REVIEW'
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
SELECT "SELECT structure_alias, model, field, type, language_label , flag_search, flag_index, flag_detail, flag_add, flag_edit, flag_addgrid, flag_editgrid, flag_batchedit,  flag_summary FROM view_structure_formats_simplified WHERE field like '%spent_time_msg' ORDER BY structure_alias, field;" AS 'SPENT TIME FIELDS REVIEW'
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
('collections content','Collection Content','Contenu des collections'),
('links to collections','Links to collections','Liens aux collections'),
('collections links','Collection Links','Liens de la collections'),
('linked collection','Linked Collection','Collection liée'),
('collection to link','Collections to link','Collection à lier'),
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
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('orders','Orders','Commandes'),('order lines','Order lines','Lignes de commande'),('records linked to study', 'Records linked to study', 'Données attachées à l''étude');

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
(null, 'participant identifiers', 'list all identifiers of selected participants', 'report_participant_identifiers_criteria', 'report_participant_identifiers_result', 'index', 'participantIdentifiersSummary', 1);
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'Participant'), 'participant identifiers report', (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers'), 1, '');

SELECT '----------------------------------------------------------------------------------------------------------' AS 'PARTICIPANT IDENTIFIER REPORT'
UNION ALL 
SELECT "Queries to desactivate 'Participant Identifiers' demo report" as MSG
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'PARTICIPANT IDENTIFIER REPORT'
UNION ALL 
SELECT "UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';" as MSG
UNION ALL
SELECT "UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');" as 'PARTICIPANT IDENTIFIER REPORT'
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
('more than 1000 records are returned by the query - please redefine search criteria', 'Query returned more than 1000 records. Please redefine search criteria.', 'Plus de 1000 données ont été retournées par la requête. Veuillez redéfinir les critères de recherche.');

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
SELECT "UPDATE protocol_extend_masters SET deleted = 1 WHERE protocol_master_id IN (SELECT id FROM protocol_masters WHERE deleted = 1);" AS 'CUSTOM PROTOCOL EXTEND TABLES TO UPGRADE'
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
UPDATE protocol_extend_masters SET deleted = 1 WHERE protocol_master_id IN (SELECT id FROM protocol_masters WHERE deleted = 1);

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
SELECT "UPDATE treatment_extend_masters SET deleted = 1 WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted = 1);"  AS 'CUSTOM TREATMENT EXTEND TABLES TO UPGRADE'
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
('at least one precision is defined as protocol component', 'Unable to delete protocol. Please delete all associated precision records first.', 'Au moins une précision est définie comme composante de ce protocole'),
('at least one precision is defined as treatment component','Unable to delete treatment record. Please delete all associated precision records first.', 'Au moins une précision est définie comme composante de ce traitement'),
('drug is defined as a component of at least one protocol','Unable to delete drug. This drug is associated with treatment protocols. Please remove from all treatment protocols before deletion.', 'Le médicament est défini comme un composant d''au moins un protocole');

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
UPDATE treatment_extend_masters SET deleted = 1 WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted = 1);

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
UPDATE treatment_extend_masters SET deleted = 1 WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted = 1);

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

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0')
AND language_label = 'collection to storage spent time (min)';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '1', 'inv_coll_to_stor_spent_time_msg_defintion', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0')
AND language_label = 'collection to storage spent time (min)';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '1', 'inv_coll_to_stor_spent_time_msg_defintion', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

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

-- Table structure for saliva revisions
CREATE TABLE `sd_spe_salivas_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)  
) ENGINE=InnoDB;

-- Tube for new saliva
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `detail_form_alias`, `detail_tablename`, `flag_active`, `databrowser_label`) VALUES ((SELECT id FROM `sample_controls` WHERE `sample_type` = 'saliva'), 'tube', 'ad_spec_tubes', 'ad_tubes', '1', 'saliva|tube');
SET @last_aliquot_control_id = LAST_INSERT_ID();
INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`) VALUES (@last_aliquot_control_id,@last_aliquot_control_id,1);

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

SELECT '----------------------------------------------------------------------------------------------------------' AS 'STORAGE CONTROL REVIEW'
UNION ALL 
SELECT 'Storage coordinates review. Please correct detected issues if exists (see below)' AS 'STORAGE CONTROL REVIEW'
UNION ALL 
SELECT '----------------------------------------------------------------------------------------------------------' AS 'STORAGE CONTROL REVIEW'
UNION ALL 
SELECT CONCAT('storage control id ', id ,' to correct : coord_x_ fields (error #1 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE coord_x_title IS NULL AND (coord_x_type IS NOT NULL OR coord_x_size IS NOT NULL)
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : coord_x_ fields (error #2 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE coord_x_type IS NULL AND coord_x_size IS NOT NULL
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : coord_x_ fields (error #3 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE coord_x_type = 'list' AND (coord_x_title IS NULL OR coord_x_size IS NOT NULL)
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : coord_y_ fields (error #1 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE coord_y_title IS NULL AND (coord_y_type IS NOT NULL OR coord_y_size IS NOT NULL)
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : coord_y_ fields (error #2 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE coord_y_type IS NULL AND coord_y_size IS NOT NULL
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : coord_x&y_ fields (error #1 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE coord_x_title IS NULL AND coord_y_title IS NOT NULL
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : display_x_size x display_y_size fields (error #1 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE coord_x_size IS NOT NULL AND coord_y_title IS NULL AND (display_x_size * display_y_size) != coord_x_size
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : storage temperature (error #1 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE (detail_form_alias LIKE '%storage_temperature%' AND set_temperature = 0) OR (detail_form_alias NOT LIKE '%storage_temperature%' AND set_temperature = 1)
UNION ALL
SELECT  CONCAT('storage control id ', id ,' to correct : storage w. spaces (error #1 - see upgrade script for details)') AS 'STORAGE CONTROL REVIEW' FROM storage_controls 
WHERE detail_form_alias LIKE '%storage_w_spaces%' AND coord_x_title IS NULL
UNION ALL 
SELECT '' AS 'STORAGE CONTROL REVIEW';

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

DELETE FROM i18n WHERE id = 'storages';
INSERT INTO i18n (id,en,fr) VALUES ('storages','Storage','Entreposage');
INSERT INTO structure_permissible_values (value, language_alias) VALUES("storages", "storages");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="storages" AND language_alias="storages"), "", "1");

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

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Fixing system field in view_sample_joined_to_collection #2636
-- -----------------------------------------------------------------------------------------------------------------------------------

-- UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Administrate/Preferences/index/ does not work on demo + edit broken in 2.6 #2665
-- -----------------------------------------------------------------------------------------------------------------------------------

SET @id = (SELECT id from acos where alias='Administrate');
UPDATE acos SET alias='PreferencesAdmin' WHERE parent_id=@id and alias='Preferences';

UPDATE menus SET use_link='/Administrate/PreferencesAdmin/index/%%Group.id%%/%%User.id%%/' WHERE id='core_CAN_41_1_3_2';

ALTER TABLE users
 DROP COLUMN lang;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Be able to list QC to aliquots by 2 different ways #2593
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2, flag_active_2_to_1, use_field) VALUES
((SELECT id FROM datamart_structures WHERE model = 'QualityCtrl'), (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 1, 1, "aliquot_master_id");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add missing relation ship into the databrowser #2685
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO'
UNION ALL 
SELECT "Added new relationsips into databrowser" as TODO
UNION ALL
SELECT "Please flag inactive relationsips if required (see queries below). Don't forget Collection to Annotation, Treatment,Consent, etc if not requried." as TODO
UNION ALL
SELECT "SELECT str1.model AS model_1, str2.model AS model_2, use_field FROM datamart_browsing_controls ctrl, datamart_structures str1, datamart_structures str2 WHERE str1.id = ctrl.id1 AND str2.id = ctrl.id2 AND (ctrl.flag_active_1_to_2 = 1 OR ctrl.flag_active_2_to_1 = 1);" AS TODO
UNION ALL
SELECT "UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND/OR str.model IN ('Model1', 'Model2', 'Model...');" as TODO
UNION ALL
SELECT "Please flag inactive datamart structure functions if required (see queries below)." as TODO
UNION ALL
SELECT "UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...'));" as TODO
UNION ALL
SELECT "Please change datamart_structures_relationships_en(and fr).png in \app\webroot\img\dataBrowser" as TODO
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO';

-- Clean up specimen & aliquot review forms (master & detail)

SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO'
UNION ALL 
SELECT "Removed all fields of specimen review detail forms already included in specimen review detail form." as TODO
UNION ALL
SELECT "Please review all your specimen review forms." as TODO
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO'
UNION ALL 
SELECT DISTINCT sr.detail_form_alias AS 'TODO' FROM specimen_review_controls sr WHERE sr.flag_active = 1
UNION ALL 
SELECT '' AS 'TODO';
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_type_for_review') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='review_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats
WHERE structure_id IN (SELECT st.id FROM structures st INNER JOIN specimen_review_controls ctrl ON ctrl.detail_form_alias = st.alias)
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('review_code','sample_control_id','review_type','review_date','review_status','pathologist','notes') AND model IN ('SpecimenReviewControl','SpecimenReviewMaster'));

SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO'
UNION ALL 
SELECT "Created aliquot_review_masters form and removed all fields of aliquot review detail forms already included in it." as TODO
UNION ALL
SELECT "Please review all your aliquot review forms." as TODO
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO'
UNION ALL 
SELECT DISTINCT ar.detail_form_alias AS 'TODO' FROM aliquot_review_controls ar INNER JOIN specimen_review_controls sr ON sr.aliquot_review_control_id = ar.id WHERE ar.flag_active = 1 AND sr.flag_active = 1
UNION ALL 
SELECT '' AS 'TODO';
DELETE FROM structure_formats
WHERE structure_id IN (SELECT st.id FROM structures st INNER JOIN aliquot_review_controls ctrl ON ctrl.detail_form_alias = st.alias)
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('review_code','basis_of_specimen_review','aliquot_master_id','checkbox','id') AND model IN ('FunctionManagement','AliquotReviewMaster'));
INSERT INTO structures(`alias`) VALUES ('aliquot_review_masters');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_review_masters'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='review code' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_review_masters'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='basis of specimen review' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_review_masters'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquots_list_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reviewed aliquot' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_review_masters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '0', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_review_masters'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot_review_master_id' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE `aliquot_review_controls` ADD COLUMN `databrowser_label` varchar(50) NOT NULL DEFAULT '';
UPDATE aliquot_review_controls SET databrowser_label = review_type;
UPDATE structure_formats SET flag_search = '1' WHERE flag_index = 1 AND structure_id IN (SELECT st.id FROM structures st INNER JOIN aliquot_review_controls ctrl ON ctrl.detail_form_alias = st.alias);
INSERT INTO i18n (id,en,fr) VALUES ('breast tissue slide review', 'Breast Tissue Slide Review', 'Analyse des lame de tissu de sein');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquots_list_for_review') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Generated', '', 'reviewed_aliquot_label_for_display', 'input',  NULL , '0', 'size=30', '', '', 'reviewed aliquot', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_review_masters'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='reviewed_aliquot_label_for_display' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='reviewed aliquot' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) VALUES
(null, 'InventoryManagement', 'AliquotReviewMaster', (SELECT id FROM structures WHERE alias = 'aliquot_review_masters'), NULL, 'aliquot review', 'AliquotReviewMaster', '/InventoryManagement/SpecimenReviews/detail/%%SpecimenReviewMaster.collection_id%%/%%SpecimenReviewMaster.sample_master_id%%/%%SpecimenReviewMaster.id%%/', '');
INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2, flag_active_2_to_1, use_field) VALUES
((SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster'), (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster'), 1, 1, "specimen_review_master_id"),
((SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster'), (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 1, 1, "aliquot_master_id"),
((SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster'), (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster'), 1, 1, "parent_id");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add categories to permissible_values_custom_categories #no one
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("treatment", "treatment");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="treatment" AND language_alias="treatment"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("diagnosis", "diagnosis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="diagnosis" AND language_alias="diagnosis"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("annotation", "annotation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="annotation" AND language_alias="annotation"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("contact", "contact");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="contact" AND language_alias="contact"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("drug", "drug");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="drug" AND language_alias="drug"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("study / project", "study / project");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="study / project" AND language_alias="study / project"), "", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="specimen review" AND language_alias="specimen review"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("gynaecologic", "gynaecologic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="gynaecologic" AND language_alias="gynaecologic"), "", "1");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Be able to see storage layout from storage detail form  #2524
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('move storage content','Move Storage Contents','Déplacer contenu entreposage');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Unused parent and reentrant   #2690
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO'
UNION ALL 
SELECT "Should change trunk ViewSample to fix bug #2690: Changed [SampleMaster.parent_id AS parent_sample_id,] to [SampleMaster.parent_id AS parent_id]." as TODO
UNION ALL
SELECT "Please review custom ViewSample $table_query." as TODO
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'TODO'
UNION ALL 
SELECT '' AS 'TODO';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Replace expedié/expedition by envoyé/envoi for shipment (in french)  #No one
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) 
VALUES 
('add items to shipment','Add Items to Shipment','Ajouter article à une expédition'),
('no new item could be actually added to the shipment','No new item was added to the shipment.','Aucun nouvel article ne peut actuellement être ajouté à l''envoi.'),
('order item exists for the deleted shipment','Your data cannot be deleted! <br>Order item exists for the shipment.','Vos données ne peuvent être supprimées! Des articles sont liés à votre envoi.'),
('add shipment','Add Shipment','Ajouter une expédition'),
('shipment exists for the deleted order','Your data cannot be deleted! <br>Shipment records exist for the order.','Vos données ne peuvent être supprimées! Des envois existent pour votre commande.'),
('add items to shipment','Add Items to Shipment','Ajouter article à un envoi'),
('add shipment','Add Shipment','Ajouter un envoi'),
('define as shipped','Define as shipped','Définir comme envoyé'),
('shipping data','Shipping Data',' Données d''envoi'),
('this item cannot be deleted because it was already shipped','This item cannot be deleted because it was already shipped!','Cet item ne peut pas être supprimé car il a déjà été envoyé!');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add i18n linked to read and writte access  #No one
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) 
VALUES 
('you are not allowed to work on this batchset', 'You are not allowed to alter on this batchset', 'Vous n''êtes pas authorisés à travailler sur ce lot de données'),
('this batchset is locked', 'This batchset is locked', 'Ce lot de données est bloqué');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- create batch process to add one internal use to many aliquots (of a freezer, or from aliquots list)   #2702
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('storage event', 'Storage Event', 'Évenement d''entreposage', '1', (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types'), NOW(), NOW(), 1, 1);
SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`use_as_input`, `value`, `en`, `fr`, `control_id`, `modified_by`, `id`, `version_created`) 
(SELECT use_as_input, value, en, fr, control_id, modified_by, id, created FROM structure_permissible_values_customs WHERE id =  @last_id);
INSERT INTO `datamart_structure_functions` (`datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 'create use/event (applied to all)', '/InventoryManagement/AliquotMasters/addInternalUseToManyAliquots', 1, '');
UPDATE datamart_structure_functions SET label = 'create uses/events (aliquot specific)' WHERE label = 'create internal uses';
REPLACE INTO i18n (id,en,fr) VALUES ('use/event creation','Use/Event Creation','Création utilisation/événement');
INSERT IGNORE INTO i18n (id,en,fr) VALUES
('create uses/events (aliquot specific)', 'Create uses/events (aliquot specific)', 'Créer utilisations/événements (aliquot spécifique)'),
('create use/event (applied to all)', 'Create use/event (applied to all)', 'Créer utilisation/événement (applicabl à tous)'),
('no aliquot is contained into this storage', 'No aliquot is contained into this storage', 'Aucun aliquot n''est contenu dans cet entreposage'),
('aliquot(s) volume units are different - no used volume can be completed', 'The aliquot(s) volume units are different. No used volume can be completed.', 'Les unités de volume des aliquots sont différents. Aucun volume ne pourra être défini.'),
('you are about to create an use/event for %d aliquot(s)', 'You are about to create an use/event for %d aliquot(s)', 'Vous êtes sur le point de créer un(e) utilisation/événement pour %d aliquots'),
('you are about to create an use/event for %s aliquot(s) contained into %s', 'You are about to create an use/event for %s aliquot(s) contained into %s', 'Vous êtes sur le point de créer un(e) événement/utilisation pour %d aliquots contenus dans %s'),
('no used volume can be recorded', 'No used volume can be recorded', 'Aucun volume utilisé ne peut être enregistré'),
('add storage event to stored aliquots','Add Storage Event','Créer évenement d''entreposage');

ALTER TABLE datamart_saved_browsing_steps
 ADD COLUMN parent_children CHAR(1) NOT NULL DEFAULT '';

INSERT INTO structures(`alias`) VALUES ('view_storage_masters');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'ViewStorageMaster', 'view_storage_masters', 'code', 'input',  NULL , '0', 'size=30', '', 'storage_code_help', 'storage code', ''), 
('StorageLayout', 'ViewStorageMaster', 'view_storage_masters', 'storage_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') , '0', '', '', '', 'storage type', ''), 
('StorageLayout', 'ViewStorageMaster', 'view_storage_masters', 'short_label', 'input',  NULL , '0', 'size=6', '', 'stor_short_label_defintion', 'storage short label', ''), 
('StorageLayout', 'ViewStorageMaster', 'view_storage_masters', 'selection_label', 'input',  NULL , '0', 'size=20,url=/storagelayout/storage_masters/autoComplete/', '', 'stor_selection_label_defintion', 'storage selection label', ''), 
('StorageLayout', 'ViewStorageMaster', 'view_storage_masters', 'temperature', 'float',  NULL , '0', 'size=5', '', '', 'storage temperature', ''), 
('StorageLayout', 'ViewStorageMaster', 'view_storage_masters', 'temp_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') , '0', '', '', '', '', ''),
('StorageLayout', 'ViewStorageMaster', 'view_storage_masters', 'empty_spaces', 'integer_positive',  NULL , '0', '', '', '', 'empty spaces', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='storage_code_help' AND `language_label`='storage code' AND `language_tag`=''), '1', '100', 'system data', 0, '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '3', '', 0, '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '6', '', 0, '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,url=/storagelayout/storage_masters/autoComplete/' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage selection label' AND `language_tag`=''), '0', '8', '', 0, '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='temperature' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='storage temperature' AND `language_tag`=''), '0', '20', '', 0, '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='temp_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '21', '', 0, '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='empty_spaces'), '0', '24', '', 0, '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='empty_spaces' AND `type`='integer_positive' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='empty_spaces' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_structures 
    SET model='ViewStorageMaster', index_link='/StorageLayout/StorageMasters/detail/%%ViewStorageMaster.id%%/', structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') 
    WHERE model='StorageMaster';
    
UPDATE storage_controls
    SET detail_form_alias=REPLACE(detail_form_alias, ',storage_w_spaces', '')
    WHERE detail_form_alias LIKE '%,storage_w_spaces%';
UPDATE storage_controls
    SET detail_form_alias=REPLACE(detail_form_alias, 'storage_w_spaces', '')
    WHERE detail_form_alias LIKE '%storage_w_spaces%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Empty result in databrowser - Add message for browsing another way  #2692
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO external_links (name, link) VALUES ('databrowser_help', 'http://www.ctrnet.ca/mediawiki/index.php/Databrowser');
INSERT IGNORE INTO i18n (id,en,fr) VALUES
('data types relationship diagram','Data Types Relationship Diagram','Diagramme des realtions des types de données'),
('link to databrowser wiki page %s  + datamart structures relationship diagram access',
'The DataBrowser is a tool that allows you to browse from one data type to another through various search forms.<br>More information about databrowser is available <a href="%s" target="blank">here</a>.<br>By default, the system will use the shortest way to browse from one data type to another.<br>Be sure an appropriate way has been used checking the following document: ',
'Le Navigateur de données est un outil qui vous permet de naviguer d''un type de données à un autre à travers différents formulaires de recherche.<br>Plus d''informations sur le Navigateur de données sont disponibles <a href="%s" target="blank">ici</a>.<br>Par défaut, le système utilisera le chemin le plus court pour aller d''un type de données à un autre.<br>Assurez-vous qu''un chemin approprié a été utilisé en vous basant sur le diagramme suivant: ');
REPLACE INTO i18n (id,en,fr) VALUES
('no data matches your search parameters',
'No data matches your search parameters!<br><br><i>Note the system used the shortest way to browse from the previous data type to the selected one. Be sure no other appropriate way exists to browse your data checking the ''Data Types Relationship Diagram''.</i>',
'Aucune données ne correspond à vos critères de recherche!<br><br><i>Notez que le système à utilisé le chemin le plus court pour aller du précédant type de données à celui sélectionné. Assurez-vous qu''aucun autre chemin plus approprié ne peut être utilisé en vous basant sur le ''Diagramme des realtions des types de données''.</i>');
 
 -- -----------------------------------------------------------------------------------------------------------------------------------
-- Replace/Add new i18n
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES
('aliquot internal use code', 'Use/Event Defintion', 'Définition de l''utilisation/événement'),
('treatment precision', 'Treatment Precision', 'Précisions de Traitment');
UPDATE structure_fields SET language_label = 'use counter' WHERE field = 'use_counter';
INSERT INTO i18n (id,en,fr) VALUES ('use counter', 'Uses/Events', 'Utilisations/Événements');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Control table generic fields #2673
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE lbd_dna_extractions DROP COLUMN deleted;
ALTER TABLE lbd_slide_creations DROP COLUMN deleted;
ALTER TABLE consent_masters MODIFY consent_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE dxd_bloods MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE dxd_tissues MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE lbd_dna_extractions DROP PRIMARY KEY; ALTER TABLE lbd_dna_extractions MODIFY lab_book_master_id int(11) NOT NULL;
ALTER TABLE lbd_slide_creations DROP PRIMARY KEY; ALTER TABLE lbd_slide_creations MODIFY lab_book_master_id int(11) NOT NULL;
ALTER TABLE permissions_presets MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE permissions_presets MODIFY created datetime DEFAULT NULL;
ALTER TABLE permissions_presets MODIFY modified datetime DEFAULT NULL;
ALTER TABLE protocol_extend_masters MODIFY protocol_extend_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE protocol_masters MODIFY protocol_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE protocol_masters ADD CONSTRAINT FK_protocol_masters_aliquot_controls FOREIGN KEY (protocol_control_id) REFERENCES `protocol_controls` (`id`);
ALTER TABLE rtbforms MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE sd_der_cell_lysates MODIFY sample_master_id int(11) NOT NULL;
ALTER TABLE sd_der_cell_lysates ADD CONSTRAINT FK_sd_der_cell_lysates_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);
ALTER TABLE shipment_contacts MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE shipment_contacts MODIFY created datetime DEFAULT NULL;
ALTER TABLE shipment_contacts MODIFY modified datetime DEFAULT NULL;
ALTER TABLE sopd_general_alls MODIFY sop_master_id int(11) NOT NULL;
ALTER TABLE sopd_general_alls ADD CONSTRAINT FK_sopd_general_alls_sop_masters FOREIGN KEY (sop_master_id) REFERENCES sop_masters (id);
ALTER TABLE sopd_inventory_alls MODIFY sop_master_id int(11) NOT NULL;
ALTER TABLE sopd_inventory_alls ADD CONSTRAINT FK_sopd_inventory_alls_sop_masters FOREIGN KEY (sop_master_id) REFERENCES sop_masters (id);
ALTER TABLE sop_masters MODIFY sop_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE sop_masters ADD CONSTRAINT FK_sop_masters_sop_controls FOREIGN KEY (sop_control_id) REFERENCES sop_controls (id);
ALTER TABLE structure_permissible_values_customs MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE treatment_extend_masters MODIFY treatment_extend_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE treatment_masters MODIFY treatment_control_id int(11) NOT NULL DEFAULT '0';

ALTER TABLE dxd_primaries_revs DROP COLUMN deleted;
ALTER TABLE dxd_progressions_revs DROP COLUMN deleted;
ALTER TABLE dxd_recurrences_revs DROP COLUMN deleted;
ALTER TABLE dxd_remissions_revs DROP COLUMN deleted;

ALTER TABLE dxd_secondaries_revs DROP COLUMN deleted;
DROP INDEX participant_id ON event_masters_revs;
DROP INDEX diagnosis_id ON event_masters_revs;
DROP INDEX storage_id ON shelves_revs;

ALTER TABLE consent_masters_revs MODIFY consent_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE dxd_bloods_revs MODIFY diagnosis_master_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE dxd_tissues_revs MODIFY diagnosis_master_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE protocol_extend_masters_revs MODIFY protocol_extend_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE treatment_extend_masters_revs MODIFY treatment_extend_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE treatment_masters_revs MODIFY treatment_control_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE dxd_bloods_revs MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE dxd_tissues_revs MODIFY diagnosis_master_id int(11) NOT NULL;

ALTER TABLE shelves_revs MODIFY version_id int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE permissions_presets_revs MODIFY id int(11) NOT NULL;
ALTER TABLE rtbforms_revs MODIFY id int(11) NOT NULL;
ALTER TABLE shipment_contacts_revs MODIFY id int(11) NOT NULL;
ALTER TABLE structure_permissible_values_customs_revs MODIFY id int(11) NOT NULL;

DROP INDEX event_master_id ON ed_all_adverse_events_adverse_events_revs;
DROP INDEX event_master_id ON ed_all_clinical_followups_revs;
DROP INDEX event_master_id ON ed_all_clinical_presentations_revs;
DROP INDEX event_master_id ON ed_all_comorbidities_revs;
DROP INDEX event_master_id ON ed_all_lifestyle_smokings_revs;
DROP INDEX event_master_id ON ed_all_protocol_followups_revs;
DROP INDEX event_master_id ON ed_all_study_researches_revs;
DROP INDEX event_master_id ON ed_breast_screening_mammograms_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_ampullas_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_colon_biopsies_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_colon_rectum_resections_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_distalexbileducts_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_gallbladders_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_hepatocellular_carcinomas_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_intrahepbileducts_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_pancreasendos_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_pancreasexos_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_perihilarbileducts_revs;
DROP INDEX diagnosis_master_id ON ed_cap_report_smintestines_revs;
DROP INDEX event_control_id ON event_masters_revs;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Create a report to list all derivatives from a list of specimens  #2687
-- Add report to list all specimens from a list of samples   #2686
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, associated_datamart_structure_id) VALUES
(null, 'initial specimens display', 'list all initial specimens from a list of samples', 'report_initial_specimens_criteria_and_result', 'report_initial_specimens_criteria_and_result', 'index', 'getAllSpecimens', 1, (SELECT id FROM datamart_structures WHERE model = 'ViewSample')),
(null, 'all derivatives display', 'list all derivatives from a list of samples', 'report_list_all_derivatives_criteria_and_result', 'report_list_all_derivatives_criteria_and_result', 'index', 'getAllDerivatives', 1, (SELECT id FROM datamart_structures WHERE model = 'ViewSample'));
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewSample'), 'initial specimens display', (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'initial specimens display'), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewSample'), 'all derivatives display', (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'all derivatives display'), 1, '');

INSERT INTO structures(`alias`) VALUES ('report_list_all_derivatives_criteria_and_result');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='inv_acquisition_label_defintion' AND `language_label`='acquisition_label' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='initial specimen type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '10', 'derivatives', '0', '', '0', '', '0', '', '0', '', '1', 'size=30', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='generated_parent_sample_sample_type_help' AND `language_label`='parent sample type' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '101', 'selected parent samples', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation site' AND `language_tag`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_creation_datetime_defintion' AND `language_label`='creation date' AND `language_tag`='' LIMIT 0,1), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_derivatives_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by' AND `language_tag`=''), '0', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('report_initial_specimens_criteria_and_result');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='inv_acquisition_label_defintion' AND `language_label`='acquisition_label' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='initial specimen type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '10', 'specimens', '0', '', '0', '', '0', '', '0', '', '1', 'size=30', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='generated_parent_sample_sample_type_help' AND `language_label`='parent sample type' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '101', 'selected derivatives', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='supplier dept' AND `language_tag`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_reception_datetime_defintion' AND `language_label`='reception date' AND `language_tag`=''), '0', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_initial_specimens_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='time_at_room_temp_mn_help' AND `language_label`='time at room temp (mn)' AND `language_tag`=''), '0', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('selected parent samples','Selected Parent Samples','Échantillons parents sélectionnés'),
('initial specimens display', 'Initial Specimens Display', 'Affichage des spécimens sources'),
('all derivatives display', 'All Derivatives Display', 'Affichage des échantillons dérivés'),
('list all derivatives from a list of samples', 'List all derivatives created from a list of samples', 'Afficher tous les échantillons dérivés créés à partir d''une liste d''échantillons'),
('list all initial specimens from a list of samples', 'List all initial specimens from a list of samples', 'Afficher tous les spécimens sources d''une liste d''échantillons'),
('more than 100 samples have been selected - please redefine search criteria', 'More than 100 samples have been defines as search criteria. Please redefine search criteria.', 'Plus de 100 échantillons ont été définis comme critères de recherche. Veuillez redéfinir les critères de recherche.');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Create a report to list all storaged (direct child or not) of a storage #2689
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, associated_datamart_structure_id) VALUES
(null, 'list all children storages', 'list all children from a list of storages', 'report_list_all_storages_criteria_and_result', 'report_list_all_storages_criteria_and_result', 'index', 'getAllChildrenStorage', 1, (SELECT id FROM datamart_structures WHERE model = 'ViewStorageMaster'));
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewStorageMaster'), 'list all children storages', (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'list all children storages'), 1, '');

INSERT INTO structures(`alias`) VALUES ('report_list_all_storages_criteria_and_result');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='storage_code_help' AND `language_label`='storage code' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '0', 'stutied storages', '1', 'storage selection label', '0', '', '0', '', '0', '', '1', 'size=20,url=/storagelayout/storage_masters/autoComplete/', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='storage temperature' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='storage_code_help' AND `language_label`='storage code' AND `language_tag`=''), '0', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_storages_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,url=/storagelayout/storage_masters/autoComplete/' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage selection label' AND `language_tag`=''), '0', '101', 'children storages', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('list all children storages', 'List all child storage entities', 'Afficher tous les sous-entreposages'),
('list all children from a list of storages', 'List all child storage entities', 'Afficher tous les sous-entreposages d''une liste d''entreposages'),
('more than 10 storages have been selected - please redefine search criteria', 'More than 10 storage entities have been defines as search criteria. Please redefine search criteria.', 'Plus de 10 entreposages ont été définis comme critères de recherche. Veuillez redéfinir les critères de recherche.'),
('stutied storages', 'Studied Storages', 'Entreposages étudiés'),
('children storages', 'Children Storages', 'Sous-entreposages');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Create a report to list all linked diagnosis (primary, secondary, recurrence, etc) from 1 diagnosis  #2688
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, associated_datamart_structure_id) VALUES
(null, 'list all related diagnosis', 'list all related diagnosis from a list of diagnosis or participants', 'report_list_all_related_diagnosis_criteria_and_result', 'report_list_all_related_diagnosis_criteria_and_result', 'index', 'getAllRelatedDiagnosis', 1, (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster'));
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster'), 'list all related diagnosis', (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'list all related diagnosis'), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'Participant'), 'list all related diagnosis', (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'list all related diagnosis'), 1, '');

INSERT INTO structures(`alias`) VALUES ('report_list_all_related_diagnosis_criteria_and_result');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_related_diagnosis_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx date' AND `language_label`='dx_date' AND `language_tag`=''), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_related_diagnosis_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis control type' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_list_all_related_diagnosis_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='category' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_related_diagnosis_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'primary_id', 'input',  NULL , '0', 'size=20', '', '', 'diagnosis relation system code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_list_all_related_diagnosis_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_id' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis relation system code' AND `language_tag`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('more than 100 records have been selected - please redefine search criteria', 'More than 100 records returned. Please redefine search criteria.', 'Plus de 100 données ont été définis comme critères de recherche. Veuillez redéfinir les critères de recherche.'),
('list all related diagnosis', 'List all related diagnosis', 'Afficher tous les évenements de diagnostic connexes'),
('list all related diagnosis from a list of diagnosis or participants', 'List all related diagnosis from a list of diagnosis or participants', 'Afficher tous les évenements de diagnostic connexes à partir d''une liste de diagnostics ou de participants');
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('diagnosis relation system code', 'Related Diagnosis Id (System Code)', 'Id d''évenements connexes (Système code)');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Missing Translations & Sorted i18n.fr values starting with É #
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES 
('csf', 'CSF', 'LCR'),
('csf cells', 'CSF Cells', 'Cellules de LCR'),
('csf supernatant', 'CSF Supernatant', 'Surnageant de LCR'),
('saliva', 'Saliva', 'Salive');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('data saved', 'Data Saved', 'Données Sauvegardées'),
('generic',  'Generic', 'Générique'),
('selected derivatives', 'Selected Derivatives', 'Dérivés sélectionnés'),
('specimens', 'Specimens', 'Spécimens'),
('recurrent', 'Recurrent', 'Récurrent'),
('delivery department or door', 'Delivery Department or Door', 'Service de livraison ou porte'),
('delivery notes', 'Delivery Notes', 'Notes de livraison'),
('delivery phone #', 'Delivery Phone #', 'Téléphone pour livraison'),
('display name', 'Display Name', 'Afficher le nom'),
('hospital number', 'Hospital Number', 'Numéros hospitalier'),
('number of values', 'Number of Values', 'Nombre de valeurs');

REPLACE INTO i18n (id,en,fr) VALUES
('sample', 'Sample', 'Echantillon'),
('samples', 'Samples', 'Echantillons'); -- For databrowser options sort issue

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Display study in Uses/Events #2773
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquotUse', 'view_aliquot_uses', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('study_list_for_view', 'Study.StudySummary::getStudyPermissibleValuesForView');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list_for_view')  WHERE model='ViewAliquotUse' AND tablename='view_aliquot_uses' AND field='study_summary_id' AND `type`='select';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Use self::$display_limit in trunk reports.
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('the report contains too many results - please redefine search criteria', 'The report contains too many results. Please redefine search criteria.', 'Le rapport contient trop de résultats. Veuillez redéfinir les critères de recherche.');
UPDATE structure_fields SET field = 'BR_Nbr' WHERE field = '#BR' AND model = '0';
UPDATE structure_fields SET field = 'PR_Nbr' WHERE field = '#PR' AND model = '0';
UPDATE misc_identifier_controls SET misc_identifier_name = 'BR_Nbr' WHERE misc_identifier_name = '#BR';
UPDATE misc_identifier_controls SET misc_identifier_name = 'PR_Nbr' WHERE misc_identifier_name = '#PR';

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain` IS NULL AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `language_label`='check white space' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_2d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `language_label`='check white space' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_1d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `language_label`='check white space' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_tma') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `language_label`='check white space' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `language_label`='check white space' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='check_white_space' AND `language_label`='check white space' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE from structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_w_spaces');
DELETE FROM structures WHERE alias='storage_w_spaces';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- EventMaster.listall: use either Master from or detailed form #2802
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE event_controls ADD COLUMN use_detail_form_for_index TINYINT(1) NOT NULL DEFAULT '0';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add missing translation linked to permissions rebuild
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr) VALUES 
('rebuilt lft rght for datamart_browsing_results','Rebuilt lft & rght for datamart_browsing_results', 'Les valeurs lft & rght de datamart_browsing_results ont été regénérées'),
('language files have been rebuilt', 'Language files have been rebuilt', 'Fichiers de traductions ont été regénérés'),
('views have been rebuilt', 'Views have been rebuilt', 'Les vues ont été regénérées'),
('cache has been cleared', 'Cache has been cleared', 'Les fichiers temporaires ont été supprimés');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add message to define structure_permissible_values_custom_controls.category
-- Plus add aditional category
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE structure_permissible_values_custom_controls MODIFY category varchar(50) NOT NULL DEFAULT 'undefined';
UPDATE structure_permissible_values_custom_controls SET category = 'undefined' WHERE category = '';

SELECT '----------------------------------------------------------------------------------------------------------' AS 'structure_permissible_values_custom_controls category to set (nothing to do if empty)'
UNION ALL
SELECT name AS 'structure_permissible_values_custom_controls category to set' FROM structure_permissible_values_custom_controls WHERE category = 'undefined'
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------' AS 'structure_permissible_values_custom_controls category to set (nothing to do if empty)'
UNION ALL
SELECT '' AS 'structure_permissible_values_custom_controls category to set';

UPDATE structure_permissible_values_custom_controls SET category = 'clinical - consent' WHERE category = 'consent';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory - quality control' WHERE category = 'quality control';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment' WHERE category = 'treatment';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis' WHERE category = 'diagnosis';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE category = 'annotation';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - contact' WHERE category = 'contact';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory - specimen review' WHERE category = 'specimen review';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - gynaecologic' WHERE category = 'gynaecologic';		
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - consent", "clinical - consent");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - consent" AND language_alias="clinical - consent"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("inventory - quality control", "inventory - quality control");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="inventory - quality control" AND language_alias="inventory - quality control"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - treatment", "clinical - treatment");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - treatment" AND language_alias="clinical - treatment"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - diagnosis", "clinical - diagnosis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - diagnosis" AND language_alias="clinical - diagnosis"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - annotation", "clinical - annotation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - annotation" AND language_alias="clinical - annotation"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - contact", "clinical - contact");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - contact" AND language_alias="clinical - contact"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - gynaecologic", "clinical - gynaecologic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - gynaecologic" AND language_alias="clinical - gynaecologic"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("undefined", "undefined");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="undefined" AND language_alias="undefined"), "", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name = 'permissible_values_custom_categories' AND spv.value="quality control" AND spv.language_alias="quality control";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name = 'permissible_values_custom_categories' AND spv.value="gynaecologic" AND spv.language_alias="gynaecologic";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name = 'permissible_values_custom_categories' AND spv.value="consent" AND spv.language_alias="consent";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name = 'permissible_values_custom_categories' AND spv.value="treatment" AND spv.language_alias="treatment";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name = 'permissible_values_custom_categories' AND spv.value="diagnosis" AND spv.language_alias="diagnosis";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name = 'permissible_values_custom_categories' AND spv.value="annotation" AND spv.language_alias="annotation";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name = 'permissible_values_custom_categories' AND spv.value="contact" AND spv.language_alias="contact";
DELETE FROM structure_permissible_values WHERE value="quality control" AND language_alias="quality control" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
DELETE FROM structure_permissible_values WHERE value="consent" AND language_alias="consent" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
DELETE FROM structure_permissible_values WHERE value="treatment" AND language_alias="treatment" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
DELETE FROM structure_permissible_values WHERE value="diagnosis" AND language_alias="diagnosis" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
DELETE FROM structure_permissible_values WHERE value="annotation" AND language_alias="annotation" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
DELETE FROM structure_permissible_values WHERE value="contact" AND language_alias="contact" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - consent' WHERE category = 'consent';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory - quality control' WHERE category = 'quality control';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment' WHERE category = 'treatment';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis' WHERE category = 'diagnosis';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE category = 'annotation';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - contact' WHERE category = 'contact';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory - specimen review' WHERE category = 'specimen review';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - gynaecologic' WHERE category = 'gynaecologic';	
INSERT INTO i18n (id,en,fr) 
VALUES
('clinical - annotation', 'Clinical - Annotation','Clinique - Annotation'),
('clinical - consent', 'Clinical - Consent','Clinique - Consentement'),
('clinical - contact', 'Clinical - Contact','Clinique - Contact'),
('clinical - diagnosis', 'Clinical - Diagnosis','Clinique - Diagnostic'),
('clinical - gynaecologic', 'Clinical - Gynaecologic','Clinique - Gynécologique'),
('clinical - treatment', 'Clinical - Treatment','Clinique - Traitement'),
('inventory - quality control', 'Inventory - Quality Control', 'Inventaire - Contrôle de qualité'),
('inventory - specimen review', 'Inventory - Path Review', 'Inventaire - Rapport d''histologie');
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - family history", "clinical - family history");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - family history" AND language_alias="clinical - family history"), "", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical - reproductive history", "clinical - reproductive history");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="clinical - reproductive history" AND language_alias="clinical - reproductive history"), "", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("inventory - specimen review", "inventory - specimen review");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="inventory - specimen review" AND language_alias="inventory - specimen review"), "", "1");
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('clinical - family history', 'Clinical - Family History','Clinique - Antécédents Familiaux'),
('clinical - reproductive history', 'Clinical - Reproductive History','Clinique - Gynécologie'),
('inventory - specimen review', 'Inventory - Path Review', 'Inventaire - Rapport d''histologie');
UPDATE structure_permissible_values_custom_controls SET name = 'orders institutions' WHERE name = 'orders_institution';
UPDATE structure_permissible_values_custom_controls SET name = 'orders contacts' WHERE name = 'orders_contact';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- issue #2811: Manage Storage Content Display in treee view with a number of elements too important
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('message_for_storage_tree_view');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'Generated', '', 'storage_tree_view_item_summary', 'input',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='message_for_storage_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='storage_tree_view_item_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('sto_CAN_20', 'sto_CAN_01', 0, 2, 'storage content list', NULL, '/StorageLayout/StorageMasters/contentListView/%%StorageMaster.id%%', 'StorageLayout.StorageMaster::summary', 1, 1);
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('storage content list','Content (List)','Contenu (Liste)'),
('storage contains too many aliquots for display','Storage contains too many aliquots for display','L''entreposage contient trop d''aliquots pour l''affichage'),
('storage contains too many children storages for display','Storage contains too many children storages for display','L''entreposage contient trop de sous-entreposages pour l''affichage'),
('storage contains too many tma slides for display','Storage contains too many TMA slides for display','L''entreposage contient trop de lames de TMA pour l''affichage'),
('tma slides','TMA slides','Lames de TMA'),
('access to the list','Access to the list','Accéder à la liste');
REPLACE INTO i18n (id,en,fr) VALUES ('storages','Storages','Entreposages');
INSERT INTO structures(`alias`) VALUES ('storage_masters_for_storage_list_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='storage_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='storage_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='parent_storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '3', '', '0', '1', 'position', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='storage_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='parent_storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '4', '', '0', '0', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structures(`alias`) VALUES ('aliquot_masters_for_storage_list_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '21', '', '0', '1', 'position', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '22', '', '0', '0', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structures(`alias`) VALUES ('tma_slides_for_storage_list_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='tma_block_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='block' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '4', '', '0', '1', 'position', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '5', '', '0', '0', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '1', 'tma slide', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('cores','Cores','Cores'), ('there are too many main storages for display', 'There are too many ''main'' storages for display', 'Il existe trop d''entreposages principaux pour l''affichage');
UPDATE structure_fields SET model = 'Block', field = 'short_label' WHERE field = 'tma_block_identification';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- add missing translation
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('this is not a time','Data entered is not a valid time','La donnée saisie n''est pas un temps');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#2912: custom drop down list pagination 
-- Add  custom drop down list items counter
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE structure_permissible_values_custom_controls 
  ADD COLUMN  values_used_as_input_counter INT(7) DEFAULT '0',
  ADD COLUMN  values_counter INT(7) DEFAULT '0';
UPDATE structure_permissible_values_custom_controls ctrl
INNER JOIN (SELECT control_id, count(*) as counter FROM structure_permissible_values_customs WHERE deleted != 1 GROUP BY control_id) values_customs ON ctrl.id = values_customs.control_id
INNER JOIN (SELECT control_id, count(*) as counter FROM structure_permissible_values_customs WHERE deleted != 1  AND use_as_input = 1 GROUP BY control_id) values_customs_used_as_input ON ctrl.id = values_customs_used_as_input.control_id
SET ctrl.values_counter = values_customs.counter,  ctrl.values_used_as_input_counter = values_customs_used_as_input.counter;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'StructurePermissibleValuesCustomControl', 'structure_permissible_values_custom_controls', 'values_counter', 'input',  NULL , '0', 'size=5', '', 'NULL', 'number of values', ''), 
('Administrate', 'StructurePermissibleValuesCustomControl', 'structure_permissible_values_custom_controls', 'values_used_as_input_counter', 'input',  NULL , '0', 'size=5', '', '', 'number of values used as input', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdowns'), (SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustomControl' AND `tablename`='structure_permissible_values_custom_controls' AND `field`='values_counter' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='NULL' AND `language_label`='number of values' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='administrate_dropdowns'), (SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustomControl' AND `tablename`='structure_permissible_values_custom_controls' AND `field`='values_used_as_input_counter' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='number of values used as input' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='administrate_dropdowns') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='custom_permissible_values_counter' AND `language_label`='number of values' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='custom_permissible_values_counter' AND `language_label`='number of values' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field`='custom_permissible_values_counter' AND `language_label`='number of values' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('number of values used as input', 'Number of values used as input', 'Nombre de valeurs utilisées comme entrée');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #2943: Login Error Management : New rules 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('your connection has been temporarily disabled','Your connection has been temporarily disabled','votre connexion a été temporairement désactivée'),
('login failed. that username has been disabled', 'Login failed. That username has been disabled.','L''ouverture de session a échoué. L''utilisateur a été désactivé');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #2943: Login Error Management : New rules 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr) 
VALUES 
('Login failed. Invalid username or password or disabled user.', 'Login failed. Invalid username/password or disabled user.', 'L''ouverture de session a échoué. Nom d''utilisateur/mot de passe invalide ou ustilisateur désactivé.');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #2944: Password creation: new rules 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('password should be different than username','Password should be different than username','Le mot de passe doit être différent du nom d''utilisateur'),
('password should be different than the previous one','Password should be different than the previous one','Le mot de passe doit être différent du précédent');
DELETE from structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field in ('password','new_password'));
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='User' AND `field`='password'), 'notEmpty', 'password is required'),
((SELECT id FROM structure_fields WHERE `model`='User' AND `field`='new_password'), 'notEmpty', 'password is required');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('password_format_error_msg_3',
'Passwords must have a minimum length of 8 characters and contain uppercase letters, lowercase letters, numbers and special characters.',
'Les mots de passe doivent avoir une longueur minimale de 8 caractères et être composés de lettres majuscules, de lettres minuscules, de chiffres et de caractères spéciaux.'),
('password_format_error_msg_2',
'Passwords must have a minimum length of 8 characters and contain uppercase letters, lowercase letters and numbers.',
'Les mots de passe doivent avoir une longueur minimale de 8 caractères et être composés de lettres majuscules, de lettres minuscules et de chiffres.'),
('password_format_error_msg_1',
'Passwords must have a minimum length of 8 characters and contain lowercase letters.',
'Les mots de passe doivent avoir une longueur minimale de 8 caractères et être composés de lettres minuscules.');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #2945: Authentication credentials expiration 
-- Change Valide UserName format message
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE users ADD COLUMN password_modified datetime DEFAULT NULL;
INSERT INTO i18n (id,en,fr) VALUES (
'your password has expired. Please change your password for security reason.',
'Your password has expired. Please change your password for security reasons.', 
'Votre mot de passe a expiré. Veuillez changer votre mot de passe pour des raisons de sécurité.');

UPDATE structure_validations SET language_message = 'a valid username is required, between 5 to 15, and a mix of alphabetical and numeric characters only' WHERE language_message = 'A valid username is required, between 5 to 15, and a mix of alphabetical and numeric characters only.';
INSERT INTO i18n (id,en,fr) 
VALUES 
('a valid username is required, between 5 to 15, and a mix of alphabetical and numeric characters only',
'A valid username is required, between 5 to 15, and a mix of alphabetical and numeric characters only.',
'Un nom d''utilisateur valide est requis composé de 5 à 15 caractères et un mélange de caractères alphabétiques et numériques uniquement.');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Change structure_permissible_values_custom_controls.name with upperletters
-- Issue #2756: Missing Translations 
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET name = 'Aliquot Use and Event Types' WHERE name = 'aliquot use and event types';
UPDATE structure_permissible_values_custom_controls SET name = 'Consent Form Versions' WHERE name = 'consent form versions';
UPDATE structure_permissible_values_custom_controls SET name = 'Laboratory Sites' WHERE name = 'laboratory sites';
UPDATE structure_permissible_values_custom_controls SET name = 'Laboratory Staff' WHERE name = 'laboratory staff';
UPDATE structure_permissible_values_custom_controls SET name = 'Orders Contacts' WHERE name = 'orders contacts';
UPDATE structure_permissible_values_custom_controls SET name = 'Orders Institutions' WHERE name = 'orders institutions';
UPDATE structure_permissible_values_custom_controls SET name = 'Quality Control Tools' WHERE name = 'quality control tools';
UPDATE structure_permissible_values_custom_controls SET name = 'SOP Versions' WHERE name = 'sop versions';
UPDATE structure_permissible_values_custom_controls SET name = 'Specimen Collection Sites' WHERE name = 'specimen collection sites';
UPDATE structure_permissible_values_custom_controls SET name = 'Specimen Supplier Departments' WHERE name = 'specimen supplier departments';
UPDATE structure_permissible_values_custom_controls SET name = 'Storage Coordinate Titles' WHERE name = 'storage coordinate titles';
UPDATE structure_permissible_values_custom_controls SET name = 'Storage Types' WHERE name = 'storage types';
INSERT INTO i18n (id,en,fr) VALUES ('undefined','Undefined','Non défini');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Username control
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT '----------------------------------------------------------------------------------------------------------' AS 'username too small - to change (nothing to do if empty)'
UNION ALL 
SELECT username AS 'username too small - to change (nothing to do if empty)' from users where LENGTH(username) < 5
UNION ALL 
SELECT '' AS 'username too small - to change (nothing to do if empty)';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Disable addInternalUseToManyAliquots()
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 0 WHERE link LIKE '%addInternalUseToManyAliquots%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#2968: Edit Specimen Review: Copy Control Fields Duplicated
-- -----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ar_breast_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `language_label`='copy control' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#2786: set flag_confidential = 1 to appropriated fields
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET flag_confidential = '1' WHERE field IN ('first_name','last_name','date_of_birth','middle_name') AND model = 'Participant';
ALTER TABLE participant_contacts ADD COLUMN `confidential` tinyint(1) DEFAULT '0';
ALTER TABLE participant_contacts_revs ADD COLUMN `confidential` tinyint(1) DEFAULT '0';
INSERT INTO structures(`alias`) VALUES ('participantcontacts_confidential');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'confidential', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '1', '', '', '', 'confidential', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts_confidential'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='confidential' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confidential' AND `language_tag`=''), '1', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='confidential' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confidential' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET flag_confidential = '0' WHERE field = 'confidential' AND model = 'ParticipantContact';
INSERT INTO i18n (id,en,fr) VALUES ('confidential','Confidential','Confidentiel');
REPLACE INTO i18n (id,en,fr) VALUES 
('error_fk_participant_linked_contacts',
'Your data cannot be deleted! Linked contact record exists for this participant. Please note some contacts may be confidential and hidden.',
'Vos données ne peuvent être supprimées! Le participant que vous essayez de supprimer est lié à un contact! Certains contacts peuvent être confidentiels et caché.');
 
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Review Master/Detail forms for TreatmentExtend and ProtocolExtend
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Protocol Master/detail forms clean up
DELETE FROM structure_formats 
WHERE structure_id IN (SELECT structures.id FROM protocol_controls, structures WHERE protocol_controls.detail_form_alias = structures.alias) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model` IN ('ProtocolMaster','ProtocolControl') AND `field` IN ('notes','code','tumour_group','name','type'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='pd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Protocol' AND `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `language_label`='arm' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Protocol Extend Master/detail forms clean up
INSERT INTO structures(`alias`) VALUES ('protocol_extend_masters');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Disable Participant.batchEdit()
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = '0' WHERE link = '/ClinicalAnnotation/Participants/batchEdit/';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#2983: realiquot in batch tissue tubes: The aliquot uses/event counter is not updated
-- Including : In newVersionSetup(), Add code to correct all
--     . Wrong AliquotMaster.user_counter,
--     . Wrong AliquotMaster.current_volume,
--     . Realiquoting.parent_used_volume not null when (Parent)AliquotControl.volume_unit is null,
--     . InternalUse.used_volume not null when AliquotControl.volume_unit is null,
--     . SourceAliquot.used_volume not null when AliquotControl.volume_unit is null,
--     . QualityControl.used_volume not null when AliquotControl.volume_unit is null
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr) 
VALUES
('aliquot used volume has been removed for following aliquots : ', 'Aliquot used volume has been removed for following aliquots : ', 'Le volume utilisé a été supprimé pour les aliquots : '),
('aliquot current volume has been corrected for following aliquots : ','Aliquot current volume has been corrected for following aliquots : ', 'Le volume courant a été corrigé pour les aliquots : '),
('aliquot use counter has been corrected for following aliquots : ', 'Aliquot Uses/Events counter has been corrected for following aliquots : ', 'Le nombre d''Utilisations/Événements a été corrigé pour les aliquots : ');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#3012: Password change: Add control on old password or administrator password
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('old_password_for_change');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'FunctionManagement', '', 'old_password', 'password',  NULL , '0', '', '', '', 'old password', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='old_password_for_change'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='old_password' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='old password' AND `language_tag`=''), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structures(`alias`) VALUES ('admin_user_password_for_change');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'FunctionManagement', '', 'admin_user_password_for_change', 'password',  NULL , '0', '', '', '', 'your password', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='admin_user_password_for_change'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='admin_user_password_for_change' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='your password' AND `language_tag`=''), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO i18n(id,en,fr) VALUES ('old password','Old Password','Ancien mot de pass'),('your password','Enter Your Password','Saisissez votre mot de passe');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `field`='old_password'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `field`='admin_user_password_for_change'), 'notEmpty');
UPDATE structure_formats SET `display_order`='3', `language_heading`='security control' WHERE structure_id=(SELECT id FROM structures WHERE alias='admin_user_password_for_change') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='admin_user_password_for_change' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('security control','Security Control','Contrôle de sécurité');
INSERT INTO i18n (id,en,fr) 
VALUES
('your old password is invalid','Your old password is invalid','Votre ancien mot de passe n''est pas valide'),
('your own password is invalid','Your own password is invalid','Votre propre mot de passe n''est pas valide');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Change username user
-- -----------------------------------------------------------------------------------------------------------------------------------

update users set username = 'user1' where username = 'user';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.0', NOW(),'5617','n/a');
