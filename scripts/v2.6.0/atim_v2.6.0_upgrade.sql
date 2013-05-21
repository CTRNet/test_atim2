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










































