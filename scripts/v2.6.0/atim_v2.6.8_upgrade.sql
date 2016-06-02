-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3307: Study - Autocomplete fields
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_aliquot_master_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_float`)
(SELECT
sfo.`structure_id`, (SELECT id FROM structure_fields WHERE field = 'autocomplete_aliquot_master_study_summary_id' AND model = 'FunctionManagement'), sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`margin`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`, sfo.`flag_override_type`, sfo.`type`, sfo.`flag_override_setting`, sfo.`setting`, sfo.`flag_override_default`, sfo.`default`, 
sfo.`flag_add`, sfo.`flag_add_readonly`, sfo.`flag_edit`, sfo.`flag_edit_readonly`, sfo.`flag_addgrid`, sfo.`flag_addgrid_readonly`, sfo.`flag_editgrid`, sfo.`flag_editgrid_readonly`, sfo.`flag_batchedit`, sfo.`flag_batchedit_readonly`, 
sfo.`flag_float`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.model LIKE 'AliquotMaster' AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_aliquot_internal_use_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_float`)
(SELECT
sfo.`structure_id`, (SELECT id FROM structure_fields WHERE field = 'autocomplete_aliquot_internal_use_study_summary_id' AND model = 'FunctionManagement'), sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`margin`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`, sfo.`flag_override_type`, sfo.`type`, sfo.`flag_override_setting`, sfo.`setting`, sfo.`flag_override_default`, sfo.`default`, 
sfo.`flag_add`, sfo.`flag_add_readonly`, sfo.`flag_edit`, sfo.`flag_edit_readonly`, sfo.`flag_addgrid`, sfo.`flag_addgrid_readonly`, sfo.`flag_editgrid`, sfo.`flag_editgrid_readonly`, sfo.`flag_batchedit`, sfo.`flag_batchedit_readonly`, 
sfo.`flag_float`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.model LIKE 'AliquotInternalUse' AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_consent_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_float`)
(SELECT
sfo.`structure_id`, (SELECT id FROM structure_fields WHERE field = 'autocomplete_consent_study_summary_id' AND model = 'FunctionManagement'), sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`margin`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`, sfo.`flag_override_type`, sfo.`type`, sfo.`flag_override_setting`, sfo.`setting`, sfo.`flag_override_default`, sfo.`default`, 
sfo.`flag_add`, sfo.`flag_add_readonly`, sfo.`flag_edit`, sfo.`flag_edit_readonly`, sfo.`flag_addgrid`, sfo.`flag_addgrid_readonly`, sfo.`flag_editgrid`, sfo.`flag_editgrid_readonly`, sfo.`flag_batchedit`, sfo.`flag_batchedit_readonly`, 
sfo.`flag_float`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.model LIKE 'ConsentMaster' AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_misc_identifier_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_float`)
(SELECT
sfo.`structure_id`, (SELECT id FROM structure_fields WHERE field = 'autocomplete_misc_identifier_study_summary_id' AND model = 'FunctionManagement'), sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`margin`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`, sfo.`flag_override_type`, sfo.`type`, sfo.`flag_override_setting`, sfo.`setting`, sfo.`flag_override_default`, sfo.`default`, 
sfo.`flag_add`, sfo.`flag_add_readonly`, sfo.`flag_edit`, sfo.`flag_edit_readonly`, sfo.`flag_addgrid`, sfo.`flag_addgrid_readonly`, sfo.`flag_editgrid`, sfo.`flag_editgrid_readonly`, sfo.`flag_batchedit`, sfo.`flag_batchedit_readonly`, 
sfo.`flag_float`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.model LIKE 'MiscIdentifier' AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1'));
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_misc_identifier_study_summary_id'), 'notEmpty', '');
DELETE FROM structure_validations WHERE rule = 'notEmpty' AND structure_field_id = (SELECT id FROM structure_fields WHERE `field`='study_summary_id' AND model = 'MiscIdentifier');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_order_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_float`)
(SELECT
sfo.`structure_id`, (SELECT id FROM structure_fields WHERE field = 'autocomplete_order_study_summary_id' AND model = 'FunctionManagement'), sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`margin`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`, sfo.`flag_override_type`, sfo.`type`, sfo.`flag_override_setting`, sfo.`setting`, sfo.`flag_override_default`, sfo.`default`, 
sfo.`flag_add`, sfo.`flag_add_readonly`, sfo.`flag_edit`, sfo.`flag_edit_readonly`, sfo.`flag_addgrid`, sfo.`flag_addgrid_readonly`, sfo.`flag_editgrid`, sfo.`flag_editgrid_readonly`, sfo.`flag_batchedit`, sfo.`flag_batchedit_readonly`, 
sfo.`flag_float`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.model LIKE 'Order' AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_order_line_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_float`)
(SELECT
sfo.`structure_id`, (SELECT id FROM structure_fields WHERE field = 'autocomplete_order_line_study_summary_id' AND model = 'FunctionManagement'), sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`margin`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`, sfo.`flag_override_type`, sfo.`type`, sfo.`flag_override_setting`, sfo.`setting`, sfo.`flag_override_default`, sfo.`default`, 
sfo.`flag_add`, sfo.`flag_add_readonly`, sfo.`flag_edit`, sfo.`flag_edit_readonly`, sfo.`flag_addgrid`, sfo.`flag_addgrid_readonly`, sfo.`flag_editgrid`, sfo.`flag_editgrid_readonly`, sfo.`flag_batchedit`, sfo.`flag_batchedit_readonly`, 
sfo.`flag_float`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.model LIKE 'OrderLine' AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_tma_slide_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_float`)
(SELECT
sfo.`structure_id`, (SELECT id FROM structure_fields WHERE field = 'autocomplete_tma_slide_study_summary_id' AND model = 'FunctionManagement'), sfo.`display_column`, sfo.`display_order`, 
sfo.`language_heading`, sfo.`margin`, sfo.`flag_override_label`, sfo.`language_label`, sfo.`flag_override_tag`, sfo.`language_tag`, sfo.`flag_override_help`, sfo.`language_help`, sfo.`flag_override_type`, sfo.`type`, sfo.`flag_override_setting`, sfo.`setting`, sfo.`flag_override_default`, sfo.`default`, 
sfo.`flag_add`, sfo.`flag_add_readonly`, sfo.`flag_edit`, sfo.`flag_edit_readonly`, sfo.`flag_addgrid`, sfo.`flag_addgrid_readonly`, sfo.`flag_editgrid`, sfo.`flag_editgrid_readonly`, sfo.`flag_batchedit`, sfo.`flag_batchedit_readonly`, 
sfo.`flag_float`
FROM structure_fields sfi
INNER JOIN structure_formats sfo ON sfo.structure_field_id = sfi.id
WHERE sfi.model LIKE 'TmaSlide' AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1'));

UPDATE structure_fields sfi, structure_formats sfo
SET sfo.flag_add= '0', sfo.flag_edit= '0', sfo.flag_addgrid= '0', sfo.flag_editgrid= '0',
sfo.flag_add_readonly= '0', sfo.flag_edit_readonly= '0', sfo.flag_addgrid_readonly= '0', sfo.flag_editgrid_readonly= '0'
WHERE sfo.structure_field_id = sfi.id
AND sfi.field LIKE '%study_summary_id%' AND sfi.type='select'
AND (sfo.flag_add= '1' OR sfo.flag_edit= '1' OR sfo.flag_addgrid= '1' OR sfo.flag_editgrid= '1' OR sfo.flag_batchedit = '1');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
SET @flag_index = (SELECT flag_detail
	FROM structure_fields sfi, structure_formats sfo, structures st
	WHERE sfo.structure_field_id = sfi.id AND st.id = sfo.structure_id
	AND st.alias = 'aliquot_masters' AND sfi.field LIKE 'study_summary_id' AND sfi.type='select');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '26', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', @flag_index, '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3308: Study - Add study to databarowser
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT 'Added Study to databrowser. Please check all realationships have been correctly set.' AS '### MESSAGE ### New DataBrowser realtionships';

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) 
VALUES
(null, 'Study', 'StudySummary', (SELECT id FROM structures WHERE alias = 'studysummaries'), NULL, 'study', '', '/Study/StudySummaries/detail/%%StudySummary.id%%/', '');

-- ViewAliquot

SET @form_structure_id = (SELECT id FROM structures WHERE alias = 'aliquot_masters');
SET @datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');

SET @used_in_form = (SELECT IF(count(*) > 0, 1, 0) as use_in_form
	FROM structure_formats sfo
	INNER JOIN structure_fields sfi ON sfo.structure_field_id = sfi.id
	WHERE sfi.field LIKE '%study_summary_id'
	AND sfo.structure_id = @form_structure_id
	AND flag_detail = '1');
SET @used_in_databrowser = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = @datamart_structure_id OR id2 = @datamart_structure_id)
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
SET @flag_active = (SELECT IF((@used_in_form + @used_in_databrowser) = 2,1,0) AS res);
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), @flag_active, @flag_active, 'study_summary_id');

-- ViewAliquotUse

SET @form_structure_id = (SELECT id FROM structures WHERE alias = 'aliquotinternaluses');
SET @datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse');

SET @used_in_form = (SELECT IF(count(*) > 0, 1, 0) as use_in_form
	FROM structure_formats sfo
	INNER JOIN structure_fields sfi ON sfo.structure_field_id = sfi.id
	WHERE sfi.field LIKE '%study_summary_id'
	AND sfo.structure_id = @form_structure_id
	AND flag_detail = '1');
SET @used_in_databrowser = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = @datamart_structure_id OR id2 = @datamart_structure_id)
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
SET @flag_active = (SELECT IF((@used_in_form + @used_in_databrowser) = 2,1,0) AS res);
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), @flag_active, @flag_active, 'study_summary_id');

-- ConsentMaster

SET @datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster');

SET @used_in_consent = (SELECT IF(count(*) > 0, 1, 0) as use_in_consent FROM consent_controls WHERE detail_form_alias LIKE '%consent_masters_study%' AND flag_active = 1);
SET @used_in_databrowser = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = @datamart_structure_id OR id2 = @datamart_structure_id)
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
SET @flag_active = (SELECT IF((@used_in_consent + @used_in_databrowser) = 2,1,0) AS res);
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'ConsentMaster'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), @flag_active, @flag_active, 'study_summary_id');

-- MiscIdentifier

SET @datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier');

SET @used_as_misc_identifier = (SELECT IF(count(*) > 0, 1, 0) as field_used FROM misc_identifier_controls WHERE flag_link_to_study = 1 AND flag_active = 1);
SET @used_in_databrowser = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = @datamart_structure_id OR id2 = @datamart_structure_id)
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
SET @flag_active = (SELECT IF((@used_in_consent + @used_as_misc_identifier) = 2,1,0) AS res);
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), @flag_active, @flag_active, 'study_summary_id');

-- Order

SET @form_structure_id = (SELECT id FROM structures WHERE alias = 'orders');
SET @datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'Order');

SET @used_in_form = (SELECT IF(count(*) > 0, 1, 0) as use_in_form
	FROM structure_formats sfo
	INNER JOIN structure_fields sfi ON sfo.structure_field_id = sfi.id
	WHERE sfi.field LIKE '%study_summary_id'
	AND sfo.structure_id = @form_structure_id
	AND flag_detail = '1');
SET @used_in_databrowser = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = @datamart_structure_id OR id2 = @datamart_structure_id)
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
SET @flag_active = (SELECT IF((@used_in_form + @used_in_databrowser) = 2,1,0) AS res);
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'Order'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), @flag_active, @flag_active, 'study_summary_id');

-- TmaSlide

SET @form_structure_id = (SELECT id FROM structures WHERE alias = 'tma_slides');
SET @datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');

SET @used_in_form = (SELECT IF(count(*) > 0, 1, 0) as use_in_form
	FROM structure_formats sfo
	INNER JOIN structure_fields sfi ON sfo.structure_field_id = sfi.id
	WHERE sfi.field LIKE '%study_summary_id'
	AND sfo.structure_id = @form_structure_id
	AND flag_detail = '1');
SET @used_in_databrowser = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = @datamart_structure_id OR id2 = @datamart_structure_id)
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
SET @flag_active = (SELECT IF((@used_in_form + @used_in_databrowser) = 2,1,0) AS res);
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), @flag_active, @flag_active, 'study_summary_id');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3309: Order Line - Add to databrowser
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) 
VALUES
(null, 'Order', 'OrderLine', (SELECT id FROM structures WHERE alias = 'orderlines'), NULL, 'order line', '', '/Order/Orders/detail/%%OrderLine.order_id%%/', '');
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) 
VALUES
((SELECT id FROM datamart_structures WHERE model = 'OrderLine'), (SELECT id FROM datamart_structures WHERE model = 'Order'), '0', '0', 'order_id'),
((SELECT id FROM datamart_structures WHERE model = 'OrderItem'), (SELECT id FROM datamart_structures WHERE model = 'OrderLine'), '0', '0', 'order_line_id'),
((SELECT id FROM datamart_structures WHERE model = 'OrderLine'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), '0', '0', 'study_summary_id');

SELECT 'Added Order Line to databrowser. Run following query to activate the link.' AS '### MESSAGE ### New DataBrowser realtionships'
UNION ALL
SELECT "UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine');" AS '### MESSAGE ### New DataBrowser realtionships';

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='sample_aliquot_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_aliquot_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='aliquot_control_id');

SET @flag_search = (SELECT flag_index FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
	AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sample_control_id')));
UPDATE structure_formats 
SET `flag_search`=@flag_search 
WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sample_control_id'));

SET @flag_search = (SELECT flag_index FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
	AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('date_required')));
UPDATE structure_formats 
SET `flag_search`=@flag_search 
WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('date_required'));

SET @flag_search = (SELECT flag_index FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
	AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('status')));
UPDATE structure_formats 
SET `flag_search`=@flag_search 
WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('status'));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Changed batch_process_aliq_storage_and_in_stock_details format : Use 2 columns
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='2' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='batch_process_aliq_storage_and_in_stock_details') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0')
AND flag_edit = '1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Fix bug on index_link of the datamart_structures record of a OrderItem
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structures SET index_link = '/Order/Orders/detail/%%OrderItem.order_id%%/' WHERE model = 'OrderItem';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- TMA Slide New Designe
-- -----------------------------------------------------------------------------------------------------------------------------------

-- AC autocomplete field

UPDATE structure_fields SET  `type`='autocomplete',  `setting`='url=/StorageLayout/TmaSlides/autocompleteTmaSlideImmunochemistry' WHERE model='TmaSlide' AND tablename='tma_slides' AND field='immunochemistry';

-- Update structure tma_blocks_for_slide_creation

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id')  AND `flag_confidential`='0'), '0', '-5', '', '0', '1', '', '1', 'storage type', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id')  AND `flag_confidential`='0'), '0', '-5', '', '0', '1', '', '1', 'storage type', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '-6', 'tma block', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks_for_slide_creation'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,url=/storagelayout/storage_masters/autoComplete/' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage selection label' AND `language_tag`=''), '0', '-3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0');

-- TMA slides uses

CREATE TABLE `tma_slide_uses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tma_slide_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `date_accuracy` char(1) NOT NULL DEFAULT '',
  `study_summary_id` int(11) DEFAULT NULL,
  `immunochemistry` varchar(50) DEFAULT NULL,
  `picture_path` varchar(200) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `tma_slide_uses_revs` (
  `id` int(11) NOT NULL,
  `tma_slide_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `date_accuracy` char(1) NOT NULL DEFAULT '',
  `study_summary_id` int(11) DEFAULT NULL,
  `immunochemistry` varchar(50) DEFAULT NULL,
  `picture_path` varchar(200) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `tma_slide_uses`
  ADD CONSTRAINT `FK_tma_slide_uses_tma_slides` FOREIGN KEY (`tma_slide_id`) REFERENCES `tma_slides` (`id`);

INSERT INTO structures(`alias`) VALUES ('tma_slides_for_use_creation');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides_for_use_creation'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '1', '0', 'tma slide', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('tma_slide_uses');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlideUse', 'tma_slide_uses', 'date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('StorageLayout', 'TmaSlideUse', 'tma_slide_uses', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', ''), 
('StorageLayout', 'TmaSlideUse', 'tma_slide_uses', 'immunochemistry', 'autocomplete',  NULL , '0', 'url=/StorageLayout/TmaSlides/autocompleteTmaSlideImmunochemistry', '', '', 'immunochemistry code', ''), 
('StorageLayout', 'FunctionManagement', 'tma_slide_uses', 'picture_path', 'input',  NULL , '0', 'size=60', '', '', 'picture path', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='immunochemistry' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/StorageLayout/TmaSlides/autocompleteTmaSlideImmunochemistry' AND `default`='' AND `language_help`='' AND `language_label`='immunochemistry code' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='tma_slide_uses' AND `field`='picture_path' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=60' AND `default`='' AND `language_help`='' AND `language_label`='picture path' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '1', '10000', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0');
UPDATE structure_fields SET  `model`='TmaSlideUse' WHERE model='FunctionManagement' AND tablename='tma_slide_uses' AND field='picture_path' AND `type`='input' AND structure_value_domain  IS NULL ;

SET @flag_active = (SELECT IF(count(*) = 0, 0, 1) AS flag FROM storage_controls WHERE is_tma_block = 1 AND flag_active = 1);
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), 'add tma slide use', '/StorageLayout/TmaSlideUses/add/', @flag_active, '');

INSERT IGNORE INTO i18n 
(id,en,fr)
 VALUES
('add tma slide use','Add Analysis/Scoring', 'Créer analyse/score'),
('use exists for the deleted tma slide','Your data cannot be deleted! <br>Uses exist for the deleted slide.',"Vos données ne peuvent être supprimées! Des utilisations existent pour votre lame."),
('tma slide uses', 'TMA Slide Analysis/Scoring', 'Analyse/Score de lame de TMA'),
('you must create at least one use for each tma slide','You must create at least one use per slide','Vous devez créer au moins une utilisation par lame'),
('add use', 'Add Use', 'Créer utilisation'),
('more than one study matche the following data [%s]','More than one study matche the value [%s]','Plus d''une étude correspond à la valeur [%s]'),
('no study matches the following data [%s]','No study matches the value [%s]','Aucune étude ne correspond à la valeur [%s]');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_tma_slide_use_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_use_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slide_uses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Study' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_study_summary_id' AND `language_label`='study / project' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) 
VALUES
(null, 'StorageLayout', 'TmaSlideUse', (SELECT id FROM structures WHERE alias = 'tma_slide_uses'), NULL, 'tma slide uses', '', '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/', '');

INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse'), (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), 0, 0, 'tma_slide_id'),
((SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), 0, 0, 'study_summary_id');
SELECT 'Added TMA SLide Use to databrowser. Run following query to activate the link.' AS '### MESSAGE ### New DataBrowser realtionships'
UNION ALL
SELECT "UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');" AS '### MESSAGE ### New DataBrowser realtionships'
UNION ALL
SELECT "UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');" AS '### MESSAGE ### New DataBrowser realtionships';

-- Changed field to read-only in TMA slide edit in batch function + add id

UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'id', 'hidden',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '1000', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

-- Added in_stock and in_stock details values

ALTER TABLE tma_slides
   ADD COLUMN in_stock varchar(30) default null,
   ADD COLUMN in_stock_detail varchar(30) default null;
ALTER TABLE tma_slides_revs
   ADD COLUMN in_stock varchar(30) default null,
   ADD COLUMN in_stock_detail varchar(30) default null;
INSERT INTO structure_value_domains (domain_name) VALUES ('tma_slide_in_stock_values'), ('tma_slide_in_stock_detail');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("shipped & returned", "shipped & returned");
INSERT IGNORE INTO structure_value_domains_permissible_values 
(structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_values"), (SELECT id FROM structure_permissible_values WHERE value="yes - available" AND language_alias="yes - available"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_values"), (SELECT id FROM structure_permissible_values WHERE value="yes - not available" AND language_alias="yes - not available"), "", "2"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_values"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="reserved for order" AND language_alias="reserved for order"), "", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="lost" AND language_alias="lost"), "", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="on loan" AND language_alias="on loan"), "", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="shipped" AND language_alias="shipped"), "", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="tma_slide_in_stock_detail"), (SELECT id FROM structure_permissible_values WHERE value="shipped & returned" AND language_alias="shipped & returned"), "", "3");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'in_stock', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_in_stock_values') , '0', '', 'yes - available', '', 'in stock', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'in_stock_detail', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_in_stock_detail') , '0', '', '', '', 'in stock detail', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='yes - available' AND `language_help`='' AND `language_label`='in stock' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='in_stock_detail' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_in_stock_detail')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='in stock detail' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='in_stock' AND model = 'TmaSlide'), 'notEmpty', '');
UPDATE tma_slides SET in_stock = 'yes - available';
UPDATE tma_slides_revs SET in_stock = 'yes - available';
REPLACE INTO i18n (id,en,fr) 
VALUES
('in stock', 'In Stock', 'En stock'),
('in stock detail', 'Stock Detail', 'Détail du stock'),
('a tma slide being not in stock can not be linked to a storage', 'A TMA slide flagged \'Not in stock\' cannot have storage location and label completed.','Une lame de TMA non en stock ne peut être attachée à un entreposage!');
UPDATE structure_formats SET `language_heading`='status' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_in_stock_values') AND `flag_confidential`='0');

-- Edit TMA Slide Use In Batch

SET @flag_active = (SELECT IF(count(*) = 0, 0, 1) AS flag FROM storage_controls WHERE is_tma_block = 1 AND flag_active = 1);
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse'), 'edit', '/StorageLayout/TmaSlideUses/editInBatch/', @flag_active, '');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slide_uses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slide_uses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slide_uses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_use_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='analysis/scoring' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slide_uses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n 
(id,en,fr)
 VALUES
('analysis/scoring','Analysis/Scoring', 'Analyse/score');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlideUse', 'tma_slide_uses', 'id', 'hidden',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '1000', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3310: Be able to flag a shipped aliquot as returned
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT 'Review Order tool custom code. Source code has been changed.' AS '### TODO ### New Source Code';

REPLACE INTO i18n (id,en,fr) 
VALUES 
('order_order management', 'Order/Shipment Management', 'Gestion des commandes/envois'),
('return','Return','Retour');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('at least one data should be updated', 'At least one data should be updated', 'Au moins une donnée doit être mise à jour'),
('use databrowser to submit a sub set of data','Use the databrowser to submit a sub set of data',"Utilisez le 'Navigateur de données' pour travailler sur un plus petit ensemble de données."),
('edit order items returned','Edit Order Items Returned','Modifier les articles de commande retournés'),
('edit unshipped order items', 'Edit Order Items Unshipped', 'Modifier articles de commande non-envoyés'),
('define order items returned','Define Order Items Returned', 'Définir articles de commande retournés'),
('item returned', 'Item Returned', 'Article retourné'),
('reason','Reason','Raison'),
('launch process on order items sub set', 'Launch process on order items sub set', 'Lancer le processus sur un sous-ensemble d''articles de commande'),
("shipped & returned","Shipped & Returned","Enovyé & Retourné"),
('returned', 'Returned', 'Retourné'),
('change status to shipped',"Change Status to 'Shipped'","Modifier le statu à 'Envoyé'"),
("the status of an aliquot flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses",
"The status of an aliquot flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses.",
"Le statu d'un aliquot défini comme 'Retourné' ne peut pas être changé à 'En attente' ou 'Envoyé' lorsque celui-ci est déjà lié à une autre commande avec ces 2 status."),
("an aliquot cannot be added twice to orders as long as this one has not been first returned", 
"An aliquot cannot be added twice to orders as long as this one has not been first flagged as 'Returned'.", "Un aliquot ne peut pas être ajouté à deux reprises à des commandes aussi longtemps que celui-ci n'a pas d'abord été défini comme 'retourné'."),
('the return information was deleted','The return information was deleted', "l'information de retour a été effacée"),
('at least one item should be defined as returned','At least one item should be defined as returned',"Au moins un article doit être défini comme 'retourné'"),
('defined as returned', 'Defined as Returned', "'Définir comme 'Retourné'"),
('no order items can be defined as returned', 'No order items can be defined as returned', "Aucun article de commande peut être défini comme 'retourné'"),
('no unshipped item exists','No unshipped item exists','Aucun article a envoyer existe'),
('no returned item exists','No returned item exists','Aucun article défini comme retourné existe'),
('only shipped items can be defined as returned', 'Only shipped items can be defined as returned', "Seuls les articles envoyés peuvent être définis comme 'retourné'");

ALTER TABLE order_items
  ADD COLUMN `date_returned` date DEFAULT NULL,
  ADD COLUMN `date_returned_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `reason_returned` varchar(250) DEFAULT NULL,
  ADD COLUMN `reception_by` varchar(255) DEFAULT NULL;
ALTER TABLE order_items_revs
  ADD COLUMN `date_returned` date DEFAULT NULL,
  ADD COLUMN `date_returned_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `reason_returned` varchar(250) DEFAULT NULL,
  ADD COLUMN `reception_by` varchar(255) DEFAULT NULL;

INSERT INTO structures(`alias`) VALUES ('orderitems_returned');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'date_returned', 'date',  NULL , '0', '', '', '', 'date', ''), 
('Order', 'OrderItem', 'order_items', 'reason_returned', 'input',  NULL , '0', 'size=40', '', '', 'reason', ''), 
('Order', 'OrderItem', 'order_items', 'reception_by', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'reception by', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '0', '', '0', '', '0', '', '1', 'autocomplete', '1', 'url=/InventoryManagement/AliquotMasters/autocompleteBarcode', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '2', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='order_shipment code' AND `language_tag`=''), '0', '40', 'shipment', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '0', '50', 'item returned', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reason_returned' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='reason' AND `language_tag`=''), '0', '51', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '0', '52', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'id', 'hidden',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Core', 'FunctionManagement', '', 'defined_as_returned', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'defined as returned', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='defined_as_returned' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='defined as returned' AND `language_tag`=''), '0', '49', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='returned' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='defined_as_returned' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='order_status' AND `language_tag`=''), '0', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("shipped & returned", "shipped & returned");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="order_item_status"), 
(SELECT id FROM structure_permissible_values WHERE value="shipped & returned" AND language_alias="shipped & returned"), "", "4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_in_stock_detail"), 
(SELECT id FROM structure_permissible_values WHERE value="shipped & returned" AND language_alias="shipped & returned"), "", "4");

SET @flag_active = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'Order') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'Order'))
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'OrderItem'), 'defined as returned', '/Order/OrderItems/defineOrderItemsReturned/', @flag_active, '');
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'OrderItem'), 'edit', '/Order/OrderItems/editInBatch/', @flag_active, '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '0', '50', 'return', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reason_returned' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='reason' AND `language_tag`=''), '0', '51', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '0', '52', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('orderitems_returned_flag');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned_flag'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='defined_as_returned' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='defined as returned' AND `language_tag`=''), '0', '49', 'returned', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='defined_as_returned' AND `language_label`='defined as returned' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO i18n (id,en,fr) 
VALUES
('shipped aliquot return','Shipped Aliquot Return','Retour d''aliquot envoyé'),
('order preparation','Order Preparation','Préparation de commande');

REPLACE INTO i18n (id,en,fr) 
VALUES
('aliquot shipment','Aliquot Shipment','Envoi d''aliquots');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'aliquot_master_id', 'hidden',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='aliquot_master_id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reason_returned' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='return' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned_flag') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='defined_as_returned' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='item' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('item','Item','Article'),
('items should have the same status to be updated in batch','Items should have the same status to be updated in batch',"Les articles devraient avoir le même statut pour être modifiés ensemble"),
('items should have a status different than shipped to be updated in batch', "Items should have a status different than 'shipped' to be updated in batch", "Les articles devraient avoir un statut différent de 'envoyé' pour être modifiés"),
('no item to update', 'No item to update', 'Aucun article à modifier');






























mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.0_full_installation.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.0_demo_data.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.1_upgrade.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.2_upgrade.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.3_upgrade.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.4_upgrade.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.5_upgrade.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.6_upgrade.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.7_upgrade.sql
mysql -u root trunk --default-character-set=utf8 <  atim_v2.6.8_upgrade.sql












-- -----------------------------------------------------------------------------------------------------------------------------------
-- TMA Slide
--   Une TMA Slide pourrait être envoyé
--   Une TMA Slide pourrait être retourné
-- -----------------------------------------------------------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

lister les champs dans lesquels une custom drop down list est utlisée

SELECT 
REPLACE(svd.source, 'StructurePermissibleValuesCustom::getCustomDropdown(', '') AS custom_list,
str.alias AS structure_alias,
sfi.plugin AS plugin,
sfi.model AS model,
sfi.tablename AS tablename,
sfi.field AS field,
sfi.structure_value_domain AS structure_value_domain,
svd.domain_name AS structure_value_domain_name,
IF((sfo.flag_override_label = '1'),sfo.language_label,sfi.language_label) AS language_label,
IF((sfo.flag_override_tag = '1'),sfo.language_tag,sfi.language_tag) AS language_tag
FROM structure_formats sfo 
INNER JOIN structure_fields sfi ON sfo.structure_field_id = sfi.id
INNER JOIN structures str ON str.id = sfo.structure_id
INNER JOIN structure_value_domains svd ON svd.id = sfi.structure_value_domain
WHERE (sfo.flag_add =1 OR sfo.flag_addgrid =1 OR sfo.flag_index =1 OR sfo.flag_detail)
AND svd.source LIKE 'StructurePermissibleValuesCustom::getCustomDropdown(%)'
ORDER BY svd.source;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.6.8', NOW(),'????','n/a');
