INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.0', NOW(),'to define','to define');

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

SELECT '-----------------------------------------------------' AS TODO
UNION ALL 
SELECT 'Structures & Spent Time Fields to Review (See below)' AS TODO
UNION ALL 
SELECT '-----------------------------------------------------' AS TODO;

SELECT DISTINCT structure_alias, field, 'search field issue' as type_of_error
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
UNION 
SELECT DISTINCT structure_alias, field, 'result field issue' as type_of_error
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
UNION 
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT structure_alias, field, 'search field issue' as type_of_error
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
UNION 
SELECT DISTINCT structure_alias, field, 'search field issue' as type_of_error
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
UNION 
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT structure_alias, field, 'search field issue' as type_of_error
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
UNION 
SELECT DISTINCT structure_alias, field, 'result field issue' as type_of_error
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
UNION 
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT structure_alias, field, 'search field issue' as type_of_error
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
UNION 
SELECT DISTINCT structure_alias, field, 'result field issue' as type_of_error
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
UNION 
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT structure_alias, field, 'search field issue' as type_of_error
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
UNION 
SELECT DISTINCT structure_alias, field, 'result field issue' as type_of_error
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
UNION 
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT search_form.structure_alias, search_form.field, 'search field issue' as type_of_error
FROM view_structure_formats_simplified AS search_form
WHERE search_form.flag_search = '1' 
AND  search_form.flag_index = '0' 
AND search_form.flag_detail = '0'
AND search_form.field LIKE '%spent_time_msg' 
AND search_form.language_label NOT LIKE '% spent time (min)'
-- -------------------------------------------------------------------------------------------------
UNION 
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT result_form.structure_alias, result_form.field, 'result field issue' as type_of_error
FROM view_structure_formats_simplified AS result_form
WHERE result_form.flag_search = '0' 
AND  result_form.flag_index = '1' 
AND result_form.flag_detail = '1'
AND result_form.field LIKE '%spent_time_msg' 
AND result_form.language_label NOT LIKE '% spent time'
-- -------------------------------------------------------------------------------------------------
UNION 
-- -------------------------------------------------------------------------------------------------
SELECT DISTINCT result_form.structure_alias, result_form.field, 'language label & field mismatch issue' as type_of_error
FROM view_structure_formats_simplified AS result_form
WHERE (field = 'coll_to_creation_spent_time_msg' AND language_label NOT LIKE 'collection to creation spent time%')
OR (field = 'coll_to_rec_spent_time_msg' AND language_label NOT LIKE 'collection to reception spent time%')
OR (field = 'coll_to_stor_spent_time_msg' AND language_label NOT LIKE 'collection to storage spent time%')
OR (field = 'creat_to_stor_spent_time_msg' AND language_label NOT LIKE 'creation to storage spent time%')
OR (field = 'rec_to_stor_spent_time_msg' AND language_label NOT LIKE 'reception to storage spent time%');

SELECT '-----------------------------------------------------' AS 'help for control'
UNION ALL 
SELECT 'Query to execute for control if results listed above' AS 'help for control'
UNION ALL 
SELECT '-----------------------------------------------------' AS 'help for control'
UNION ALL 
SELECT "SELECT structure_alias, model, field, language_label , flag_search, flag_index, flag_detail
FROM view_structure_formats_simplified 
WHERE field like '%spent_time_msg' 
ORDER BY field, structure_alias" AS 'help for control';

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
('used lists','used lists','Listes utilisées');
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
SELECT "Queries to activate 'Participant Identifiers' demo report" as msg
UNION ALL
SELECT "UPDATE datamart_reports SET flag_active = 1 WHERE name = 'participant identifiers';" as msg
UNION ALL
SELECT "UPDATE datamart_structure_functions SET flag_active = 1 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');" as msg;

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










