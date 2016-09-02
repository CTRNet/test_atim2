-- -----------------------------------------------------------------------------------------------------------------------------------
-- ATiM v2.6.8 Upgrade Script
--
-- See ATiM wiki fpr more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -----------------------------------------------------------------------------------------------------------------------------------
--
-- MIGRATION DETAIL:
-- 
--   ### 1 # Added Investigator and Funding sub-models to study tool
--
--      To be able to create one to many investigators or fundings of a study.
--
--      TODO:
--
--      In /app/Plugin/StudyView/StudySummaries/detail.ctp, set the variables $display_study_fundings and/or $display_study_investigators
--      to 'false' to hide the section.
--
--
--   ### 2 # Replaced the study drop down list to both an autocomplete field and a text field
--
--      Replaced all 'study_summary_id' field with 'select' type and 'domain_name' equals to 'study_list' by the 2 following fields
--			- Study.FunctionManagement.autocomplete_{.*}_study_summary_id for any data creation and update
--			- Study.StudySummary.title for any data display in detail or index form.
--		A field study_summary_title has been created for both ViewAliquot and ViewAliquotUse.
--      The defintion of study linked to a created/updated data is now done through an 'autocomplete' field.
--      The search of a study linked to a data is done by the use of the text field (list could be complex to use for any long list of values).
--
--      TODO:
--
--      Review any of these forms:
--         - aliquotinternaluses
--         - aliquot_masters
--         - aliquot_master_edit_in_batchs
--         - consent_masters_study
--         - miscidentifiers_study
--         - orderlines
--         - orders
--         - tma_slides
--         - tma_slide_uses
--         - view_aliquot_joined_to_sample_and_collection
--         - viewaliquotuses
--
--      Update $table_querie variables of the ViewAliquotCustom and ViewAliquotUseCustom models (if exists).
--
--
--   ### 2 # Added Study Model to the databrowser
--
--      TODO:
--
--		Review the /app/webroot/img/dataBrowser/datamart_structures_relationships.vsd document.
--
--		Activate databrowser links (if required) using following query:
--			UPDATE datamart_browsing_controls 
--          SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
--          WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'Model1') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'Model2');
--
--
--   ### 3 # Added ICD-0-3-Topo Categories (tissue site/category)
--
--		The ICD-0-3-Topo categories have been defined based on an internet reasearch (no source file).
--		Created field 'diagnosis_masters.icd_0_3_topography_category' to record a ICD-0-3-Topo 3 digits codes (C07, etc) 
--		and let user searches on tissue site/category (more generic than tissue descritpion - ex: colon, etc).
--		A search field on ICD-0-3-Topo categories has been created for each form displaying a field linked to the ICD-0-3-Topo tool.
--      Note the StructureValueDomain 'icd_0_3_topography_categories' can also be used to set the site of any record of surgery, radiation, tissue source, etc .
--
--      TODO:
--
--		Check field add has been correctly done in each search form displaying the ICD-0-3-Topo tool.
--		Check field diagnosis_masters.icd_0_3_topography_category has been correctly populated based on diagnosis_masters.topography field (when
--		the diagnosis_masters.topography field contains ICD-0-3-Topo codes).
--
--
--   ### 4 # Changed field 'Disease Code (ICD-10_WHO code)' of secondary diagnosis form from ICD-10_WHO tool to a limited drop down list
--
-- 		New field is linked to the StructureValueDomain 'secondary_diagnosis_icd10_code_who' that gathers only ICD-10 codes of secondaries.
--
--      TODO:
--
--		Check any of your secondary diagnosis forms.
--
--
--   ### 5 # Changed DiagnosisControl.category values
-- 	
--		Changed:	
--         - 'secondary' to 'secondary - distant'
--         - 'progression' to 'progression - locoregional'
--         - 'recurrence' to 'recurrence - locoregional'
--
--      TODO:
--
--		Update custom code if required.
--
--
--   ### 6 # Replaced the drug drop down list to both an autocomplete field and a text field
--
--		Replaced all 'drug_id' field with 'select' type and 'domain_name' equals to 'drug_list' by the 3 following field
--			- ClinicalAnnotation.FunctionManagement.autocomplete_treatment_drug_id for any data creation and update
--			- Protocol.FunctionManagement.autocomplete_protocol_drug_id for any data creation and update
--			- Drug.Drug.generic_name for any data display in detail or index form
--
--      The definition of drug linked to a created/updated data is now done through an 'autocomplete' field.
--      The search of a drug linked to a data is done by the use of the text field (list could be complex to use for any long list of values).
--      The drug_id table fields of the models 'TreatmentExtendDetail' and 'ProtocolExtendDetail' should be moved to the Master level (already done
--		for txe_chemos and pe_chemos).
--
--      TODO:
--
--      Review any forms listed in treatment_extend_controls.detail_form_alias and protocol_extend_controls.detail_form_alias 
--      to update any of them containing a drug_id field.
--      Migrate drug_id values of any tablename listed in treatment_extend_controls.detail_tablename and protocol_extend_controls.detail_tablename
-- 		and having a drug_id field to the treatment_extend_masters.drug_id or protocol_extend_masters.drug_id field.
--      
--      UPDATE protocol_extend_masters Master, {tablename} Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id;
--      UPDATE protocol_extend_masters_revs Master, {tablename}_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
--      ALTER TABLE `{tablename}` DROP FOREIGN KEY `FK_{tablename}_drugs`;
--      ALTER TABLE {tablename} DROP COLUMN drug_id;
--      ALTER TABLE {tablename}_revs DROP COLUMN drug_id;
--      
--      UPDATE treatment_extend_masters Master, {tablename} Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
--      UPDATE treatment_extend_masters_revs Master, {tablename}_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
--      ALTER TABLE `{tablename}` DROP FOREIGN KEY `FK_{tablename}_drugs`;
--      ALTER TABLE {tablename} DROP COLUMN drug_id;
--      ALTER TABLE {tablename}_revs DROP COLUMN drug_id;
--
--   ### 7 # TMA slide new features
--
--      Created an immunochemistry autocomplete field.
-- 		Created a new object TmaSlideUse linked to a TmaSlide to track any slide scoring or analysis and added this one to the databrowser.
--
--		TODO:
--
--		Customize the TmaSlideUse controller and forms if required.
--		Activate the TmaSlide to TmaSlideUse databrowser link if required.
--		Review the /app/webroot/img/dataBrowser/datamart_structures_relationships.vsd document.
--
--   ### 8 # Order tool upgrade
--
--      The all Order tool has been redesigned to be able to:
--			- Add tma slide to an order (both aliquot and tma slide will be considered as OrderItem).
--			- Define a shipped item as returned to the bank.
--			- Browse on OrderLine model with the databrowser.
--
--		TODO:
--
--		Note the OrderItem.addAliquotsInBatch() function has been renamed to OrderItem.addOrderItemsInBatch(): Check if custom code has to be update or not.
--		Set core variable 'order_item_type_config' plus run following queries to let user to link a TMA slide to an order:
--			UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type = 'input');
--			UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') AND `flag_confidential`='0');
--			UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='is_tma_slide' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
--		Activate databrowser links if required plus review the /app/webroot/img/dataBrowser/datamart_structures_relationships.vsd document.
--      Update $table_querie variables of theViewAliquotUseCustom model (if exists).
--
--   ### 9 # New Sample and aliquot controls
--
--      Created Buffy Coat and Nail sample types.
--
--		TODO:
--
--		Activate these sample types if required.
--
--   ### 10 # Removed AliquotMaster.use_counter field
--
--		TODO:
--
--		Validate no custom code or migration script populate/update/use this field.
--
--   ### 11 # datamart_structures 'storage' replaced by either datamart_structures 'storage (non tma block)' and datamart_structures 'tma blocks (storages sub-set)'
--
--		TODO:
--		
--		Run following queries to check if some functions and reports have to be reviwed:
--			SELECT * FROM datamart_structure_functions WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage') AND label != 'list all children storages';
--			SELECT * FROM datamart_reports WHERE associated_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage' AND name != 'list all children storages');
--
--   ### 12 # Added new controls on storage_controls: coord_x_size and coord_y_size should be bigger than 1 if set
--
--		TODO:
--		
--		Run following query to detect errors
--			SELECT storage_type, coord_x_size, coord_y_size FROM storage_controls WHERE (coord_x_size IS NOT NULL AND coord_x_size < 2) OR (coord_y_size IS NOT NULL AND coord_y_size < 2);
--
-- -----------------------------------------------------------------------------------------------------------------------------------

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

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
SET @flag_index = (SELECT flag_detail
	FROM structure_fields sfi, structure_formats sfo, structures st
	WHERE sfo.structure_field_id = sfi.id AND st.id = sfo.structure_id
	AND st.alias = 'aliquot_masters' AND sfi.field LIKE 'study_summary_id' AND sfi.type='select');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', @flag_index, '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3308: Study - Add study to databarowser
-- -----------------------------------------------------------------------------------------------------------------------------------

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
((SELECT id FROM datamart_structures WHERE model = 'Order'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), @flag_active, @flag_active, 'default_study_summary_id');

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
  `modified_by` int(10) unsigned NOT NULL,
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
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='immunochemistry' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/StorageLayout/TmaSlides/autocompleteTmaSlideImmunochemistry' AND `default`='' AND `language_help`='' AND `language_label`='immunochemistry code' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='tma_slide_uses' AND `field`='picture_path' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=60' AND `default`='' AND `language_help`='' AND `language_label`='picture path' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '1', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0');
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
('more than one study matches the following data [%s]','More than one study matches the value [%s]','Plus d''une étude correspond à la valeur [%s]'),
('no study matches the following data [%s]','No study matches the value [%s]','Aucune étude ne correspond à la valeur [%s]');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'FunctionManagement', '', 'autocomplete_tma_slide_use_study_summary_id', 'autocomplete',  NULL , '0', 'url=/Study/StudySummaries/autocompleteStudy', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_use_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slide_uses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Study' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_study_summary_id' AND `language_label`='study / project' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) 
VALUES
(null, 'StorageLayout', 'TmaSlideUse', (SELECT id FROM structures WHERE alias = 'tma_slide_uses'), NULL, 'tma slide uses', '', '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/', '');

INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse'), (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), 0, 0, 'tma_slide_id'),
((SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse'), (SELECT id FROM datamart_structures WHERE model = 'StudySummary'), 0, 0, 'study_summary_id');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("TmaSlideUse", "tma slide uses");
INSERT IGNORE INTO structure_value_domains_permissible_values 
(structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="models"), (SELECT id FROM structure_permissible_values WHERE value="TmaSlideUse" AND language_alias="tma slide uses"), "", "1");

-- Changed field to read-only in TMA slide edit in batch function + add id

UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'id', 'hidden',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '1000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

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
('in stock detail', "Stock Detail", "Détail du stock"),
('a tma slide being not in stock can not be linked to a storage', "A TMA slide flagged 'Not in stock' cannot have storage location and label completed.", "Une lame de TMA non en stock ne peut être attachée à un entreposage!");
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
((SELECT id FROM structures WHERE alias='tma_slide_uses'), (SELECT id FROM structure_fields WHERE `model`='TmaSlideUse' AND `tablename`='tma_slide_uses' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '1000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3310: Be able to flag a shipped aliquot as returned
-- -----------------------------------------------------------------------------------------------------------------------------------

SET @flag_aliquot_label_detail = (SELECT `flag_detail` FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label'));

REPLACE INTO i18n (id,en,fr) 
VALUES 
('order_order management', 'Order/Shipment Management', 'Gestion des commandes/envois'),
('return','Return','Retour');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('at least one data should be updated', 'At least one data should be updated', 'Au moins une donnée doit être mise à jour'),
('use databrowser to submit a sub set of data','Use the databrowser to submit a sub set of data',"Utilisez le 'Navigateur de données' pour travailler sur un plus petit ensemble de données."),
('edit order items returned','Edit Items Returned','Modifier les articles retournés'),
('edit unshipped order items', 'Edit Items Unshipped', 'Modifier articles non-envoyés'),
('define order items returned','Define Items Returned', 'Définir articles retournés'),
('define order item as returned','Define Item as Returned', "Définir comme article 'retourné'"),
('item returned', 'Item Returned', 'Article retourné'),
('reason','Reason','Raison'),
('launch process on order items sub set', 'Launch process on order items sub set', 'Lancer le processus sur un sous-ensemble d''articles'),
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
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='order_shipment code' AND `language_tag`=''), '0', '40', 'shipment', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '0', '50', 'item returned', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reason_returned' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='reason' AND `language_tag`=''), '0', '51', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '0', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'id', 'hidden',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Core', 'FunctionManagement', '', 'defined_as_returned', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'defined as returned', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='defined_as_returned' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='defined as returned' AND `language_tag`=''), '0', '49', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='returned' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='defined_as_returned' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='order_status' AND `language_tag`=''), '0', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("shipped & returned", "shipped & returned");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="order_item_status"), 
(SELECT id FROM structure_permissible_values WHERE value="shipped & returned" AND language_alias="shipped & returned"), "0", "4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_in_stock_detail"), 
(SELECT id FROM structure_permissible_values WHERE value="shipped & returned" AND language_alias="shipped & returned"), "0", "4");

SET @flag_active = (SELECT IF(count(*) > 0, 1, 0) as use_in_databrowser
	FROM datamart_browsing_controls 
	WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'Order') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'Order'))
	AND (flag_active_1_to_2 = 1 OR flag_active_2_to_1 = 1));
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'OrderItem'), 'defined as returned', '/Order/OrderItems/defineOrderItemsReturned/', @flag_active, '');
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'OrderItem'), 'edit', '/Order/OrderItems/editInBatch/', @flag_active, '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '0', '50', 'return', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reason_returned' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='reason' AND `language_tag`=''), '0', '51', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '0', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

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
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='aliquot_master_id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`=@flag_aliquot_label_detail, `flag_edit_readonly`=@flag_aliquot_label_detail WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
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

-- -----------------------------------------------------------------------------------------------------------------------------------
-- List ATiM form fields displaying custom drop down list
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Generated', '', 'fields_linked_to_custom_list', 'textarea',  NULL , '0', '', '', '', 'fields', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdowns'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='fields_linked_to_custom_list' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fields' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Removed wrong Order menu
-- -----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM menus WHERE use_link LIKE '/Order/OrderItems/detail/%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Be able to add a TMA Slide to an order
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE `order_items` 
  MODIFY aliquot_master_id INT(11) DEFAULT NULL,
  ADD COLUMN tma_slide_id int(11) DEFAULT NULL;
ALTER TABLE `order_items_revs` 
  MODIFY aliquot_master_id INT(11) DEFAULT NULL,
  ADD COLUMN tma_slide_id int(11) DEFAULT NULL;
ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_tma_slides` FOREIGN KEY (`tma_slide_id`) REFERENCES `tma_slides` (`id`);

INSERT INTO structure_value_domains (domain_name) VALUES ("order_item_types");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("aliquot", "aliquot"),("tma slide", "tma slide");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="order_item_types"), (SELECT id FROM structure_permissible_values WHERE value="aliquot" AND language_alias="aliquot"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="order_item_types"), (SELECT id FROM structure_permissible_values WHERE value="tma slide" AND language_alias="tma slide"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Generated', '', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Generated', '', 'barcode', 'input',  NULL , '0', '', '', '', 'barcode', ''), 
('Order', 'Generated', '', 'aliquot_label', 'input',  NULL , '0', '', '', '', 'aliquot label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '1', '1', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0', '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0');

INSERT INTO structures(`alias`) VALUES ('addaliquotorderitems');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='addaliquotorderitems'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '0', '', '0', '', '0', '', '1', 'autocomplete', '1', 'url=/InventoryManagement/AliquotMasters/autocompleteBarcode', '0', '', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('addtmaslideorderitems');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'barcode', 'autocomplete',  NULL , '0', 'url=/StorageLayout/TmaSlides/autocompleteBarcode', '', '', 'barcode', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='addtmaslideorderitems'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/StorageLayout/TmaSlides/autocompleteBarcode' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/StorageLayout/TmaSlides/autocompleteBarcode' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), 'notEmpty', '');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_plus'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0'), '0', '20', '', '0', '1', 'type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_plus'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0'), '0', '20', '', '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('orders_short');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orders_short'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='order_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='order_order number' AND `language_tag`=''), '0', '33', 'order', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orders_short'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='default_study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help default study' AND `language_label`='default study / project' AND `language_tag`=''), '0', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orders_short'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='short_title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='order_short title' AND `language_tag`=''), '0', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orders_short'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='date_order_completed' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='NULL' AND `language_help`='' AND `language_label`='order_date order completed' AND `language_tag`=''), '0', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orders_short'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='processing_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='processing_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='order_processing status' AND `language_tag`=''), '0', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orders_short'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_institution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='the ordering institution' AND `language_label`='institution' AND `language_tag`=''), '0', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orders_short'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='contact' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_contact')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='the contact\'s name at the ordering institution' AND `language_label`='contact' AND `language_tag`=''), '0', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_type`='0', `type`='', `flag_override_setting`='1', `setting`='', `flag_add`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND type = 'input' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '37', 'tma slide', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='35', `language_heading`='aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='36' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='type' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `language_label`='barcode' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE datamart_structure_functions SET link = '/Order/OrderItems/addOrderItemsInBatch/AliquotMaster/' WHERE link LIKE '/Order/OrderItems/addAliquotsInBatch/';
SET @flag_active = (SELECT IF(count(*) = 0, 0, 1) AS flag FROM storage_controls WHERE is_tma_block = 1 AND flag_active = 1);
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) 
VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), 'add to order', '/Order/OrderItems/addOrderItemsInBatch/TmaSlide/', @flag_active, '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0', '0', '0', '0', @flag_aliquot_label_detail, @flag_aliquot_label_detail, '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `language_label`='barcode' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_returned') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `language_label`='aliquot label' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'tma_slide_id', 'hidden',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_returned'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='tma_slide_id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('error on order item type - contact your administartor', 'Error on order item type. Please contact your administartor.', "Une erreur existe avec le type de l'article. Veuillz contacter votre administrator."),
("a tma slide can only be added once to an order","A TMA slide can only be added once to an order!","Un lame de TMA ne peut être mise que dans une seule commande!"),
("a tma slide cannot be added twice to orders as long as this one has not been first returned","A TMA slide cannot be added twice to orders as long as this one has not been first flagged as 'Returned'.","Une lame de TMA ne peut pas être ajoutée à deux reprises à des commandes aussi longtemps que celle-ci n'a pas d'abord été définie comme 'retournée'."),
("order exists for the deleted tma slide","Your data cannot be deleted! <br>Orders exist for the deleted TMA slide.","Vos données ne peuvent être supprimées! Des commandes existent pour votre lame."),
('your data has been deleted - update the item in stock data',"Your data has been deleted. <br>Please update the 'In Stock' value for your item if required.","Votre donnée à été supprimée. <br>Veuillez mettre à jour la valeur de la donnée 'En stock' de votre article au besoin."),
('item storage data were deleted (if required)', "Item storage data were deleted (if required)!","Les données d'entreposage ont été supprimées (au besoin)!"),
("a tma slide barcode is required and should exist","Barcode is required and should be the barcode of an existing slide!","Le code à barres est requis et doit exister!"),
("the status of a tma slide flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses",
"The status of a TMA slide flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses.",
"Le statu d'une lame de TMA définie comme 'Retournée' ne peut pas être changée à 'En attente' ou 'Envoyée' lorsque celle-ci est déjà liée à une autre commande avec ces 2 status.");

UPDATE structure_formats SET structure_field_id = (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label') WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_label');
DELETE FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_label';

-- TMA SLide to order in databrowser

INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'OrderItem'), (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), 0, 0, 'tma_slide_id');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added source of the icd codes in help message
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET language_help = 'help_dx_icd10_code_who' WHERE language_help = 'help_primary code';
UPDATE structure_fields SET language_help = 'help_family_history_dx_icd10_code_who' WHERE language_help = 'help_primary_icd10_code';
UPDATE structure_fields SET language_help = 'help_cause_of_death_icd10_code_who' WHERE language_help = 'help_cod_icd10_code';
UPDATE structure_fields SET language_help = 'help_2nd_cause_of_death_icd10_code_who' WHERE language_help = 'help_secondary_cod_icd10_code';
UPDATE structure_fields SET language_help = 'help_dx_icd_o_3_morpho' WHERE language_help = 'help_morphology';
UPDATE structure_fields SET language_help = 'help_dx_icd_o_3_topo' WHERE language_help = 'help_topography';
UPDATE structure_fields SET language_help = 'help_icd_10_code_who' WHERE language_help = '' AND setting = 'size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("help_dx_icd10_code_who", "The disease or condition as represented by a code (ICD-10 codes from the 2009 Version of Stats Canada).", "La maladie ou la condition représentée par un code (ICD-10 codes de la version 2009 de 'Stats Canada')."),
("help_icd_10_code_who", "ICD-10 codes from the 2009 Version of Stats Canada", "ICD-10 codes de la version 2009 de 'Stats Canada'."),
("help_family_history_dx_icd10_code_who", "The disease or condition as represented by a code (ICD-10 codes from the 2009 Version of Stats Canada).", "La maladie ou la condition représentée par un code (ICD-10 codes de la version 2009 de 'Stats Canada')."),
("help_cause_of_death_icd10_code_who", "The disease or injury which initiated the train of morbid events leading directly to a person's death or the circumstances of the accident or violence which produced the fatal injury, as represented by a code (ICD-10 codes from the 2009 Version of Stats Canada).", "La maladie ou la blessure qui a initié la série d'événements de morbidité, menant directement au décès de la personne ou les circonstances de l'accident ou violence ayant produit une blessure fatale, telle que représentée par un code (ICD-10 codes de la version 2009 de 'Stats Canada')."),
("help_2nd_cause_of_death_icd10_code_who", "Any secondary disease, injury, circumstance of accident or violence which may have contributed to the person's death as represented by a code (ICD-10 codes from the 2009 Version of Stats Canada).", "N'importe quelle maladie secondaire, blessure, circonstance d'accident ou violence qui peut avoir contribué à  la mort de la personne, représenté par un code (ICD-10 codes de la version 2009 de 'Stats Canada')."),
("help_dx_icd_o_3_morpho", "Records the type of cell that has become neoplastic and its biologic activity (ICD-O-3 morphological codes from december 2010 version of the CIHI publications department ).", "Enregistre le type de cellules qui est devenue néoplasique ainsi que son activité biologique (codes morphologiques ICD-O-3 de la version de décembre 2010 du 'CIHI publications department')."),
("help_dx_icd_o_3_topo", "The topography code indicates the site of origin of a neoplasm (ICD-O-3 topological codes from 2009 version of Stats Canada).", "Le code de topographie indique le site de l'origine d'un néoplasme (codes morphologiques ICD-O-3 de la version 2009 de 'Stats Canada').");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added category/site to coding_icd_o_3_topography
-- 	Based on a internet reasearch:
--     - http://codes.iarc.fr/topography		
--     - http://docplayer.fr/14520236-Classification-internationale-des-maladies-pour-l-oncologie.html	
-- Added a drop down list to search on 
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE coding_icd_o_3_topography SET en_title = en_sub_title, fr_title = fr_sub_title;
UPDATE coding_icd_o_3_topography SET en_sub_title = "Lip", fr_sub_title = "Lèvre" WHERE id LIKE 'C00%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Base of tongue", fr_sub_title = "Base de la langue" WHERE id LIKE 'C01%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and unspecified parts of tongue", fr_sub_title = "Autres localisations et localisations non specifiees de la langue" WHERE id LIKE 'C02%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Gum", fr_sub_title = "Gencive" WHERE id LIKE 'C03%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Floor of mouth", fr_sub_title = "Plancher de la bouche" WHERE id LIKE 'C04%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Palate", fr_sub_title = "Palais" WHERE id LIKE 'C05%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and unspecified parts of mouth", fr_sub_title = "Autres localisations et localisations non spécifiées de la bouche" WHERE id LIKE 'C06%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Parotid glanid", fr_sub_title = "Glande parotide" WHERE id LIKE 'C07%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and unspecified major salivary glands", fr_sub_title = "Autres glandes salivaires principales et glandes salivaires principales non spécifiées" WHERE id LIKE 'C08%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Tonsil", fr_sub_title = "Amygdale" WHERE id LIKE 'C09%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Oropharynx", fr_sub_title = "Oropharynx" WHERE id LIKE 'C10%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Nasopharynx", fr_sub_title = "Nasopharynx (arrière-cavité des fosses nasales, cavum, épipharynx rhino-pharynx)" WHERE id LIKE 'C11%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Pyriform sinus", fr_sub_title = "Sinus piriforme" WHERE id LIKE 'C12%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Hypopharynx", fr_sub_title = "Hypopharynx" WHERE id LIKE 'C13%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and ill-defined sites in lip, oral cavity and pharynx", fr_sub_title = "Autres localisations et localisations maldéfinies de la lèvre, de la cavité buccale et du pharynx" WHERE id LIKE 'C14%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Esophagus", fr_sub_title = "Oesophage" WHERE id LIKE 'C15%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Stomach", fr_sub_title = "Estomac" WHERE id LIKE 'C16%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Small intestine", fr_sub_title = "Intestin grêle" WHERE id LIKE 'C17%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Colon", fr_sub_title = "Côlon" WHERE id LIKE 'C18%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Rectosigmoid junction", fr_sub_title = "Jonction recto-sigmoidienne" WHERE id LIKE 'C19%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Rectum", fr_sub_title = "Rectum" WHERE id LIKE 'C20%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Anus and anal canal", fr_sub_title = "Anus et canal anal" WHERE id LIKE 'C21%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Liver and intrahepatic bile ducts", fr_sub_title = "Foie et voiesbiliaires intrahépatiques" WHERE id LIKE 'C22%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Gallbladder", fr_sub_title = "Vésicule biliaire" WHERE id LIKE 'C23%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and unspecified parts of biliary tract", fr_sub_title = "Autres localisations et localisations non specifiées des voies biliaires" WHERE id LIKE 'C24%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Pancreas", fr_sub_title = "Pancréas" WHERE id LIKE 'C25%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and ill-defined digestive organs", fr_sub_title = "Autres localisations et localisations mal définies des organes digestifs" WHERE id LIKE 'C26%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Nasal cavity and middle ear", fr_sub_title = "Fosse nasale et oreille moyenne" WHERE id LIKE 'C30%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Accessory sinuses", fr_sub_title = "Sinus annexes de la face" WHERE id LIKE 'C31%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Larynx", fr_sub_title = "Larynx" WHERE id LIKE 'C32%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Trachea", fr_sub_title = "Trachée" WHERE id LIKE 'C33%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Bronchus and lung", fr_sub_title = "Bronche et poumon" WHERE id LIKE 'C34%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Thymus", fr_sub_title = "Thymus" WHERE id LIKE 'C37%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Heart, mediastinum, and pleura", fr_sub_title = "Coeur, médiastin et plèvre" WHERE id LIKE 'C38%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and ill-defined sites within respiratory system amd intrathoracic organs", fr_sub_title = "Autres localisations et localisations mal définies de l’appareil respiratoire et des organes intrathoraciques" WHERE id LIKE 'C39%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Bones, joints and articular cartilage of limbs", fr_sub_title = "Os, articulations et cartilage articulaire des membres" WHERE id LIKE 'C40%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Bones, joints and articular cartilage of other and unspecified sites", fr_sub_title = "Os, articulations et cartilage articulaire de localisations autres et non spécifiées" WHERE id LIKE 'C41%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Hematopoietic and reticuloendothelial systems", fr_sub_title = "Systèmes hématopoiétiqueet réticulo-endothélial" WHERE id LIKE 'C42%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Skin", fr_sub_title = "Peau" WHERE id LIKE 'C44%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Peripheral nerves and autonomic nervous system", fr_sub_title = "Nerfs périphériques et système nerveux autonome" WHERE id LIKE 'C47%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Retroperitoneum and peritoneum", fr_sub_title = "Rétropéritoine et péritoine" WHERE id LIKE 'C48%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Connective, subcutaneous and other soft tissues", fr_sub_title = "Tissu conjonctif, tissusous-cutané et autres tissus mous" WHERE id LIKE 'C49%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Breast", fr_sub_title = "Sein" WHERE id LIKE 'C50%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Vulva", fr_sub_title = "Vulve" WHERE id LIKE 'C51%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Vagina", fr_sub_title = "Vagin" WHERE id LIKE 'C52%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Cervix uteri", fr_sub_title = "Col utérin" WHERE id LIKE 'C53%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Corpus uteri", fr_sub_title = "Corps utérin" WHERE id LIKE 'C54%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Uterus, nos", fr_sub_title = "Utérus sai" WHERE id LIKE 'C55%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Ovary", fr_sub_title = "Ovaire" WHERE id LIKE 'C56%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other an unspecified female genital organs", fr_sub_title = "Organes génitaux féminins, autres et non spécifiés" WHERE id LIKE 'C57%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Placenta", fr_sub_title = "Placenta" WHERE id LIKE 'C58%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Penis", fr_sub_title = "Verge" WHERE id LIKE 'C60%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Prostate gland", fr_sub_title = "Prostate" WHERE id LIKE 'C61%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Testis", fr_sub_title = "Testicule" WHERE id LIKE 'C62%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and unspecified male genital organs", fr_sub_title = "Organesgénitaux masculins, autres et non spécifiés" WHERE id LIKE 'C63%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Kidney", fr_sub_title = "Rein" WHERE id LIKE 'C64%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Renal pelvis", fr_sub_title = "Bassinet (du rein)" WHERE id LIKE 'C65%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Ureter", fr_sub_title = "Uretère" WHERE id LIKE 'C66%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Bladder", fr_sub_title = "Vessie" WHERE id LIKE 'C67%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and unspecified urinary organs", fr_sub_title = "Organesurinaires, autres et non spécifiés" WHERE id LIKE 'C68%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Eye and adnexa", fr_sub_title = "Œil et annexes" WHERE id LIKE 'C69%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Meninges", fr_sub_title = "Méninges" WHERE id LIKE 'C70%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Brain", fr_sub_title = "Encéphale" WHERE id LIKE 'C71%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Spinal cord, cranial nerves, and other parts of central nervous system", fr_sub_title = "Moelle épinière, nerfs crâniens et autres régions du système nerveux central" WHERE id LIKE 'C72%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Thyroid gland", fr_sub_title = "Glande thyroide" WHERE id LIKE 'C73%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Adrenal gland", fr_sub_title = "Glande surrénale" WHERE id LIKE 'C74%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other endocrine glands and related structures", fr_sub_title = "Autres glandes endocrines et structures apparentées" WHERE id LIKE 'C75%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Other and ill-defined sites", fr_sub_title = "Autres localisations et localisations maldéfinies" WHERE id LIKE 'C76%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Lymph nodes", fr_sub_title = "Ganglions lymphatiques" WHERE id LIKE 'C77%';
UPDATE coding_icd_o_3_topography SET en_sub_title = "Unknown primary site", fr_sub_title = "Site primaireinconnu" WHERE id LIKE 'C80%';
UPDATE coding_icd_o_3_topography SET fr_title = 'Tumeurs malignes';

ALTER TABLE diagnosis_masters
   ADD COLUMN icd_0_3_topography_category VARCHAR(3) DEFAULT NULL AFTER topography;
ALTER TABLE diagnosis_masters_revs
   ADD COLUMN icd_0_3_topography_category VARCHAR(3) DEFAULT NULL AFTER topography;
UPDATE diagnosis_masters SET icd_0_3_topography_category =  SUBSTRING(topography FROM 1 FOR 3) WHERE topography REGEXP '^C[0-9]{3}$';
UPDATE diagnosis_masters_revs SET icd_0_3_topography_category = SUBSTRING(topography FROM 1 FOR 3) WHERE topography REGEXP '^C[0-9]{3}$';
INSERT INTO structure_value_domains (domain_name, source) VALUES ('icd_0_3_topography_categories', 'ClinicalAnnotation.DiagnosisControl::getIcdO3TopoCategoriesCodes') ;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'icd_0_3_topography_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories') , '0', '', '', 'help_dx_icd_o_3_topo_category', 'topography category', '');
SET @structure_field_id = (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd_0_3_topography_category');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_search`, `language_label`, `language_tag`, `language_help`) 
(SELECT `structure_id`, @structure_field_id, `display_column`, (`display_order` -1), `flag_search`, '', '', ''
FROM structure_formats 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND setting = 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo')
AND structure_id NOT IN (SELECT id FROM structures WHERE alias NOT IN ('dx_primary', 'dx_secondary')));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_index`, `language_label`, `language_tag`, `language_help`) 
(SELECT `structure_id`, @structure_field_id, `display_column`, 4, `flag_index` , '', '', ''
FROM structure_formats 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND setting = 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo')
AND structure_id NOT IN (SELECT id FROM structures WHERE alias NOT IN ('view_diagnosis')));
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('topography category', 'Topography - Category', 'Topographie - Catégorie'),
("help_dx_icd_o_3_topo", "The topography category is based on the first 3 characters of the topography code and indicates, more generally, the site of origin of a neoplasm (ICD-O-3 topological codes from 2009 version of Stats Canada).", "La catégorie topographique est basée sur les 3 premiers caractères du code topographique et indique de manière plus générale le site de l'origine d'un néoplasme (codes morphologiques ICD-O-3 de la version 2009 de 'Stats Canada').");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added locoregional and distant information to the add diagnosis button
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('locoregional', 'Locoregional', 'Locorégionale'),
('distant', 'Distant', 'Distant');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Worked on ICD-10-WHO code validation message + changed ICD-10-WHO code tool to a limited drop down list for disease code 
-- selection of a secondary diagnosis
-- -----------------------------------------------------------------------------------------------------------------------------------

SET @id = (SELECT id FROM structure_validations WHERE structure_field_id = 1024 AND rule = 'validateIcd10WhoCode' AND language_message = 'invalid primary disease code' LIMIT 0 ,1);
DELETE FROM structure_validations WHERE structure_field_id = 1024 AND rule = 'validateIcd10WhoCode' AND language_message = 'invalid primary disease code' AND id != @id;
UPDATE structure_validations SET language_message = 'invalid primary/secondary disease code' WHERE language_message = 'invalid primary disease code' AND structure_field_id = 1024;
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('invalid primary/secondary disease code', 'Invalid primary/secondary diagnosis disease code', 'Code de maladie du diagnostic primaire/secondaire invalide');

SET @flag_detail = (SELECT flag_detail FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'));
INSERT INTO structure_value_domains (domain_name, source) VALUES ('secondary_diagnosis_icd10_code_who', 'ClinicalAnnotation.DiagnosisControl::getSecondaryIcd10WhoCodesList') ;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'icd10_code', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='secondary_diagnosis_icd10_code_who') , '0', '', '', 'help_dx_icd10_code_who', 'disease code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='secondary_diagnosis_icd10_code_who')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx_icd10_code_who' AND `language_label`='disease code' AND `language_tag`=''), '2', '1', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', @flag_detail, '0', @flag_detail, '0', @flag_detail, '0', '0', '0', '0', '0', '0', '0', @flag_detail, @flag_detail, @flag_detail, '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added distant and locoregional to diagnosis control category to clarify data
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE diagnosis_controls MODIFY `category`varchar(200);
UPDATE diagnosis_controls SET category = 'secondary - distant' WHERE  category = 'secondary';
UPDATE diagnosis_controls SET category = 'progression - locoregional' WHERE  category = 'progression';
UPDATE diagnosis_controls SET category = 'recurrence - locoregional' WHERE  category = 'recurrence';
UPDATE diagnosis_controls SET databrowser_label = REPLACE(databrowser_label, 'secondary|', 'secondary - distant|');
UPDATE diagnosis_controls SET databrowser_label = REPLACE(databrowser_label, 'progression|', 'progression - locoregional|');
UPDATE diagnosis_controls SET databrowser_label = REPLACE(databrowser_label, 'recurrence|', 'recurrence - locoregional|');
ALTER TABLE diagnosis_controls MODIFY `category` enum('primary','secondary - distant','progression - locoregional','remission','recurrence - locoregional') NOT NULL DEFAULT 'primary';
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('secondary - distant', 'Secondary (Distant)', 'Secondaire (distant)'),
('progression - locoregional', 'Progression (Locoregional)', 'Progression (Locorégionale)'),
('recurrence - locoregional', 'Recurrence (Locoregional)', 'Récurrence (Locorégionale)'),
('new progression - locoregional', 'New Progression (Locoregional)', 'Nouvelle progression (Locorégionale)'),
('new recurrence - locoregional', 'New Recurrence (Locoregional)', 'Nouveau récurrence (Locorégionale)'),
('new secondary - distant', 'New Secondary (Distant)', 'Nouveau secondaire (distant)');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Redesigned the treatment detail form
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr)
VALUES
('from associated protocol', 'from associated protocol', 'à partir du protocole associé');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ICD Codes:
--     - Removed the CodingIcd.%_title, CodingIcd.%_sub_title and CodingIcd.%_descriptions fields 
--       then repalced them by a CodingIcd.generated_detail field
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('CodingIcd');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('CodingIcd', 'CodingIcd', '', 'generated_detail', 'input',  NULL , '0', '', '', '', 'detail', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='CodingIcd'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='id' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='CodingIcd'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='generated_detail'), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added code to create study funding and investigator
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('study investigator is assigned to the study/project', 'Your data cannot be deleted! This study/project is linked to an investigator.', "Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à un investigateur."),
('study funding is assigned to the study/project', 'Your data cannot be deleted! This study/project is linked to a funding.', "Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à un financement."),
('study investigator', 'Investigator', 'Investigateur'),
('study funding', 'Funding', 'Financement');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Changed all field study_summary_id with type = 'select' and structure_value_domain = 'study_list' to input field.
--    A left join to Drug model has been created for following models: TmaSlide, TmaSlideUse, Order, OrderLine, AliquotMaster,
--    ConsentMaster and MiscIdentifier
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET language_label = 'study / project' WHERE language_label = 'study' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list');
SET @study_title_field_id = (SELECT id FROM structure_fields WHERE model = 'StudySummary' AND field = 'title');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT structure_formats.structure_id, @study_title_field_id, structure_formats.display_column, structure_formats.display_order, structure_formats.language_heading, structure_formats.margin, '1', structure_fields.language_label, structure_formats.flag_override_tag, structure_formats.language_tag, structure_formats.flag_override_help, structure_formats.language_help, structure_formats.flag_override_type, structure_formats.type, structure_formats.flag_override_setting, structure_formats.setting, structure_formats.flag_override_default, structure_formats.default, structure_formats.flag_add, structure_formats.flag_add_readonly, structure_formats.flag_edit, structure_formats.flag_edit_readonly, structure_formats.flag_search, structure_formats.flag_search_readonly, structure_formats.flag_addgrid, structure_formats.flag_addgrid_readonly, structure_formats.flag_editgrid, structure_formats.flag_editgrid_readonly, structure_formats.flag_batchedit, structure_formats.flag_batchedit_readonly, structure_formats.flag_index, structure_formats.flag_detail, structure_formats.flag_summary, structure_formats.flag_float
FROM structure_formats 
INNER JOIN structure_fields ON structure_fields.id = structure_formats.structure_field_id
WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND structure_fields.model NOT LIKE 'View%');
UPDATE structure_fields SET setting = REPLACE(setting, 'size=50', 'size=40') WHERE model = 'StudySummary' AND field = 'title';
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND structure_fields.model NOT LIKE 'View%');
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND structure_fields.model NOT LIKE 'View%');
DELETE FROM structure_fields WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND structure_fields.model NOT LIKE 'View%';
UPDATE structure_fields SET field = 'study_title', type = 'input', setting = 'size=40', structure_value_domain = null WHERE model in ('ViewAliquotUse', 'ViewAliquot') AND field = 'study_summary_id';
UPDATE structure_fields SET field = 'study_summary_title' WHERE model in ('ViewAliquotUse', 'ViewAliquot') AND field = 'study_title';
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`=`flag_index` WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`= `flag_index` WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ProtocolExtend Model: Added drug autocomplete field 
--     plus changed all field drug_id with model = 'ProtocolExtendDetail', type = 'select' and structure_value_domain = 'drug_list' 
--     to field with model = 'ProtocolExtendMaster', type = 'input'.
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE protocol_extend_masters ADD COLUMN drug_id INT(11) DEFAULT NULL;
ALTER TABLE protocol_extend_masters_revs ADD COLUMN drug_id INT(11) DEFAULT NULL;
ALTER TABLE `protocol_extend_masters`
  ADD CONSTRAINT `FK_protocol_extend_masters_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);
UPDATE protocol_extend_masters Master, pe_chemos Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id;
UPDATE protocol_extend_masters_revs Master, pe_chemos_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `pe_chemos` DROP FOREIGN KEY `FK_pe_chemos_drugs`;
ALTER TABLE pe_chemos DROP COLUMN drug_id;
ALTER TABLE pe_chemos_revs DROP COLUMN drug_id;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Protocol', 'FunctionManagement', '', 'autocomplete_protocol_drug_id', 'autocomplete',  NULL , '0', 'url=/Drug/Drugs/autocompleteDrug', '', '', 'drug', '');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_protocol_drug_id'), 'notEmpty', '');
SET @autocomplete_drug_field_id = (SELECT id FROM structure_fields WHERE model = 'FunctionManagement' AND field = 'autocomplete_protocol_drug_id');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT structure_formats.structure_id, @autocomplete_drug_field_id, structure_formats.display_column, structure_formats.display_order, structure_formats.language_heading, structure_formats.margin, '1', structure_fields.language_label, structure_formats.flag_override_tag, structure_formats.language_tag, structure_formats.flag_override_help, structure_formats.language_help, structure_formats.flag_override_type, structure_formats.type, structure_formats.flag_override_setting, structure_formats.setting, structure_formats.flag_override_default, structure_formats.default, structure_formats.flag_add, structure_formats.flag_add_readonly, structure_formats.flag_edit, structure_formats.flag_edit_readonly, '0', structure_formats.flag_search_readonly, structure_formats.flag_addgrid, structure_formats.flag_addgrid_readonly, structure_formats.flag_editgrid, structure_formats.flag_editgrid_readonly, structure_formats.flag_batchedit, structure_formats.flag_batchedit_readonly, '0', '0', '0', structure_formats.flag_float
FROM structure_formats 
INNER JOIN structure_fields ON structure_fields.id = structure_formats.structure_field_id
WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'ProtocolExtendDetail');
SET @drug_generic_name_field_id = (SELECT id FROM structure_fields WHERE model = 'Drug' AND field = 'generic_name');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT structure_formats.structure_id, @drug_generic_name_field_id, structure_formats.display_column, structure_formats.display_order, structure_formats.language_heading, structure_formats.margin, '1', structure_fields.language_label, structure_formats.flag_override_tag, structure_formats.language_tag, structure_formats.flag_override_help, structure_formats.language_help, structure_formats.flag_override_type, structure_formats.type, structure_formats.flag_override_setting, structure_formats.setting, structure_formats.flag_override_default, structure_formats.default, '0', '0', '0','0', structure_formats.flag_search, structure_formats.flag_search_readonly, '0', '0', '0', '0', '0', '0', structure_formats.flag_index, structure_formats.flag_detail, structure_formats.flag_summary, structure_formats.flag_float
FROM structure_formats 
INNER JOIN structure_fields ON structure_fields.id = structure_formats.structure_field_id
WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'ProtocolExtendDetail');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('drug is defined as a component of at least one participant treatment','The drug is defined as a component of at least one participant treatment!',"Le médicament est défini comme étant le composant d'au moins un traitement de participant!"),
('more than one drug matches the following data [%s]', 'More than one drug matches the value [%s]', "Plus d'un médicament correspond à la valeur [%s]"),
('no drug matches the following data [%s]', 'No drug matches the value [%s]', "Aucune médicament ne correspond à la valeur [%s]");
DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'ProtocolExtendDetail');
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'ProtocolExtendDetail');
DELETE FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'ProtocolExtendDetail';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- TreatmentExtend Model: Added drug autocomplete field 
--     plus changed all field drug_id with model = 'TreatmentExtendDetail', type = 'select' and structure_value_domain = 'drug_list' 
--     to field with model = 'TreatmentExtendMaster', type = 'input'.
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE treatment_extend_masters ADD COLUMN drug_id INT(11) DEFAULT NULL;
ALTER TABLE treatment_extend_masters_revs ADD COLUMN drug_id INT(11) DEFAULT NULL;
ALTER TABLE `treatment_extend_masters`
  ADD CONSTRAINT `FK_treatment_extend_masters_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);
UPDATE treatment_extend_masters Master, txe_chemos Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
UPDATE treatment_extend_masters_revs Master, txe_chemos_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
ALTER TABLE `txe_chemos` DROP FOREIGN KEY `FK_txe_chemos_drugs`;
ALTER TABLE txe_chemos DROP COLUMN drug_id;
ALTER TABLE txe_chemos_revs DROP COLUMN drug_id;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FunctionManagement', '', 'autocomplete_treatment_drug_id', 'autocomplete',  NULL , '0', 'url=/Drug/Drugs/autocompleteDrug', '', '', 'drug', '');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_treatment_drug_id'), 'notEmpty', '');
SET @autocomplete_drug_field_id = (SELECT id FROM structure_fields WHERE model = 'FunctionManagement' AND field = 'autocomplete_treatment_drug_id');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT structure_formats.structure_id, @autocomplete_drug_field_id, structure_formats.display_column, structure_formats.display_order, structure_formats.language_heading, structure_formats.margin, '1', structure_fields.language_label, structure_formats.flag_override_tag, structure_formats.language_tag, structure_formats.flag_override_help, structure_formats.language_help, structure_formats.flag_override_type, structure_formats.type, structure_formats.flag_override_setting, structure_formats.setting, structure_formats.flag_override_default, structure_formats.default, structure_formats.flag_add, structure_formats.flag_add_readonly, structure_formats.flag_edit, structure_formats.flag_edit_readonly, '0', structure_formats.flag_search_readonly, structure_formats.flag_addgrid, structure_formats.flag_addgrid_readonly, structure_formats.flag_editgrid, structure_formats.flag_editgrid_readonly, structure_formats.flag_batchedit, structure_formats.flag_batchedit_readonly, '0', '0', '0', structure_formats.flag_float
FROM structure_formats 
INNER JOIN structure_fields ON structure_fields.id = structure_formats.structure_field_id
WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail');
SET @drug_generic_name_field_id = (SELECT id FROM structure_fields WHERE model = 'Drug' AND field = 'generic_name');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT structure_formats.structure_id, @drug_generic_name_field_id, structure_formats.display_column, structure_formats.display_order, structure_formats.language_heading, structure_formats.margin, '1', structure_fields.language_label, structure_formats.flag_override_tag, structure_formats.language_tag, structure_formats.flag_override_help, structure_formats.language_help, structure_formats.flag_override_type, structure_formats.type, structure_formats.flag_override_setting, structure_formats.setting, structure_formats.flag_override_default, structure_formats.default, '0', '0', '0','0', structure_formats.flag_search, structure_formats.flag_search_readonly, '0', '0', '0', '0', '0', '0', structure_formats.flag_index, structure_formats.flag_detail, structure_formats.flag_summary, structure_formats.flag_float
FROM structure_formats 
INNER JOIN structure_fields ON structure_fields.id = structure_formats.structure_field_id
WHERE structure_fields.structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail');
DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail');
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail');
DELETE FROM structure_fields WHERE structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND structure_fields.model LIKE 'TreatmentExtendDetail';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3209: Added buffy coat
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'buffy coat', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_buffy_coats', 0, 'buffy coat');
CREATE TABLE IF NOT EXISTS `sd_der_buffy_coats` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_buffy_coats_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `sd_der_buffy_coats_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `sd_der_buffy_coats`
  ADD CONSTRAINT `FK_sd_der_buffy_coats_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('buffy coat', 'Buffy Coat', 'Buffy Coat');
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'blood'), (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat'), 0, NULL);
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat'), (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate'), 0, NULL);
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat'), 'tube', '', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml specific for cells', 0, 'buffy coat|tube');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(null, (SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'buffy coat'), 
(SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'buffy coat'), 0, NULL);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3313: AppModel->getSpentTime() seams to fail with date >= 2038
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('months', 'Months', 'Mois');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Removed AliquotMaster.use_counter field
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_float`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='use_counter');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added nail
-- -----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `sd_spe_nails` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_spe_nails_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `sd_spe_nails_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `sd_spe_nails`
  ADD CONSTRAINT `FK_sd_spe_nails_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
CREATE TABLE IF NOT EXISTS `ad_envelopes` (
  `aliquot_master_id` int(11) NOT NULL,
  KEY `FK_ad_envelopes_aliquot_masters` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ad_envelopes_revs` (
  `aliquot_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `ad_envelopes`
  ADD CONSTRAINT `FK_ad_envelopes_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`);

INSERT INTO sample_controls ( sample_type, sample_category, detail_form_alias, detail_tablename, databrowser_label) 
VALUES
('nail', 'specimen','specimens', 'sd_spe_nails', 'nail');
ALTER TABLE aliquot_controls MODIFY `aliquot_type` enum('block','cell gel matrix','core','slide','tube','whatman paper', 'envelope') NOT NULL COMMENT 'Generic name.';
INSERT INTO aliquot_controls (sample_control_id,aliquot_type,detail_form_alias,detail_tablename,flag_active,databrowser_label)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'nail'), 'tube', 'ad_spec_tubes', 'ad_tubes', '1', 'nail|tube'),
((SELECT id FROM sample_controls WHERE sample_type = 'nail'), 'envelope', '', 'ad_envelopes', '1', 'nail|envelope');
INSERT INTO parent_to_derivative_sample_controls (derivative_sample_control_id, flag_active)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'nail'), '1');
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'nail'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 0, NULL);
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('nail', 'Nail', 'Ongle'),('envelope', 'Envelope', 'Enveloppe');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Changed labels of order buttons and fields
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('edit addition to order data', 'Edit Addition To Order Data', "Modifier données d'ajout à la commande"),
('add items to order line','Add Items to Order Line', "Ajouter des articles à la ligne de commande"),
('edit return data', 'Edit Return Data', "Modifier données de retour"),
('shipment details', 'Shipment Details', "Détails de l'envoie"),
('items details', 'Items Details', "Détails de l'article");
UPDATE i18n SET en = 'No new item can be added to the shipment.' WHERE id = 'no new item could be actually added to the shipment';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Change type to order item type (aliquot or tma slide)
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET `language_label`='item type' WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') AND `flag_confidential`='0';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('item type', 'Item Type', 'Type de l''article');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add TMA slide to order line product type plus change code to generate order line product type
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE order_lines ADD is_tma_slide tinyint(3) unsigned NOT NULL DEFAULT '0';
ALTER TABLE order_lines_revs ADD is_tma_slide tinyint(3) unsigned NOT NULL DEFAULT '0';

ALTER TABLE order_lines CHANGE sample_aliquot_precision product_type_precision varchar(30);
ALTER TABLE order_lines_revs CHANGE sample_aliquot_precision product_type_precision varchar(30);
UPDATE structure_fields SET field = 'product_type_precision', language_tag = 'precision' WHERE field = 'sample_aliquot_precision' AND model = 'OrderLine';

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='sample_aliquot_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_aliquot_type_list') AND `flag_confidential`='0');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES ('order_line_product_types', 'Order.OrderLine::getProductTypes');
UPDATE structure_fields SET `field`='product_type', `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_line_product_types') 
WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='sample_aliquot_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_aliquot_type_list') AND `flag_confidential`='0';

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='product_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_line_product_types') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderLine', 'order_lines', 'sample_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sample_type') , '0', '', '', '', 'product type', ''), 
('Order', 'OrderLine', 'order_lines', 'aliquot_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') , '0', '', '', '', '', ''), 
('Order', 'OrderLine', 'order_lines', 'is_tma_slide', 'checkbox',  NULL , '0', '', '', '', '', 'is tma slide');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderlines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='product type' AND `language_tag`=''), '2', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderlines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='aliquot_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderlines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='is_tma_slide' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='is tma slide'), '2', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr)
VALUES
('storage contains too many tma blocks for display','Storage contains too many TMA blocks for display','L\'entreposage contient trop de blocs de TMA pour l\'affichage');
INSERT INTO structures(`alias`) VALUES ('tma_blocks_for_storage_tree_view');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaBlock', 'storage_masters', 'storage_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id') , '0', '', '', '', 'storage type', ''), 
('StorageLayout', 'TmaBlock', 'storage_masters', 'selection_label', 'input',  NULL , '0', 'size=20', '', 'stor_selection_label_defintion', 'storage', ''), 
('StorageLayout', 'TmaBlock', 'storage_masters', 'parent_storage_coord_x', 'input',  NULL , '0', 'size=4', '', '', 'position', 'position'), 
('StorageLayout', 'TmaBlock', 'storage_masters', 'parent_storage_coord_y', 'input',  NULL , '0', 'size=4', '', '', '', '-');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_blocks_for_storage_tree_view'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_types_from_control_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks_for_storage_tree_view'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='storage_masters' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks_for_storage_tree_view'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='storage_masters' AND `field`='parent_storage_coord_x' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='position' AND `language_tag`='position'), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='tma_blocks_for_storage_tree_view'), (SELECT id FROM structure_fields WHERE `model`='TmaBlock' AND `tablename`='storage_masters' AND `field`='parent_storage_coord_y' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_fields SET  `language_label`='block' WHERE model='TmaBlock' AND tablename='storage_masters' AND field='selection_label' AND `type`='input' AND structure_value_domain  IS NULL ;
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('storage layout & tma blocks management', 'Storage & TMA Blocks', 'Entreposage & blocs de TMA'),
('storage layout & tma blocks management description', 'Management of TMA blocks and all bank storage entities (boxes, freezers, etc).', "Gestion des blocs de TMA et de toutes les entitées d'entreposage de la banque (boites, congélateurs, etc).");
REPLACE INTO i18n (id,en,fr)
VALUES
('storage layout management' ,'Storage', "Entreposage"),
('storage layout management description' ,'Management of all bank storage entities (boxes, freezers, etc).', "Gestion de toutes les entitées d'entreposage de la banque (boites, congélateurs, etc).");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("storage layout management - value generated by newVersionSetup function",'',''),
("storage layout management description - value generated by newVersionSetup function",'','');
UPDATE menus SET language_title = "storage layout management - value generated by newVersionSetup function" WHERE language_title = 'storage layout management'; 
UPDATE menus SET language_description = "storage layout management description - value generated by newVersionSetup function" WHERE language_description = 'storage layout management description'; 
REPLACE INTO i18n (id,en,fr) (SELECT "storage layout management - value generated by newVersionSetup function", en, fr FROM i18n WHERE id = 'storage layout management');
REPLACE INTO i18n (id,en,fr) (SELECT "storage layout management description - value generated by newVersionSetup function", en, fr FROM i18n WHERE id = 'storage layout & tma blocks management description');
INSERT INTO structures(`alias`) VALUES ('non_tma_block_storages');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('non_tma_block_storage_types_from_control_id', "StorageLayout.StorageControl::getNonTmaBlockStorageTypePermissibleValues");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'NonTmaBlockStorage', 'view_storage_masters', 'code', 'input',  NULL , '0', 'size=30', '', 'storage_code_help', 'storage code', ''), 
('StorageLayout', 'NonTmaBlockStorage', 'view_storage_masters', 'storage_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='non_tma_block_storage_types_from_control_id') , '0', '', '', '', 'storage type', ''), 
('StorageLayout', 'NonTmaBlockStorage', 'view_storage_masters', 'short_label', 'input',  NULL , '0', 'size=6', '', 'stor_short_label_defintion', 'storage short label', ''), 
('StorageLayout', 'NonTmaBlockStorage', 'view_storage_masters', 'selection_label', 'input',  NULL , '0', 'size=20,url=/storagelayout/storage_masters/autoComplete/', '', 'stor_selection_label_defintion', 'storage selection label', ''), 
('StorageLayout', 'NonTmaBlockStorage', 'view_storage_masters', 'temperature', 'float',  NULL , '0', 'size=5', '', '', 'storage temperature', ''), 
('StorageLayout', 'NonTmaBlockStorage', 'view_storage_masters', 'temp_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') , '0', '', '', '', '', ''), 
('StorageLayout', 'NonTmaBlockStorage', 'view_storage_masters', 'empty_spaces', 'integer_positive',  NULL , '0', '', '', '', 'empty spaces', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='non_tma_block_storages'), (SELECT id FROM structure_fields WHERE `model`='NonTmaBlockStorage' AND `tablename`='view_storage_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='storage_code_help' AND `language_label`='storage code' AND `language_tag`=''), '1', '100', 'system data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='non_tma_block_storages'), (SELECT id FROM structure_fields WHERE `model`='NonTmaBlockStorage' AND `tablename`='view_storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='non_tma_block_storage_types_from_control_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='non_tma_block_storages'), (SELECT id FROM structure_fields WHERE `model`='NonTmaBlockStorage' AND `tablename`='view_storage_masters' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='non_tma_block_storages'), (SELECT id FROM structure_fields WHERE `model`='NonTmaBlockStorage' AND `tablename`='view_storage_masters' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20,url=/storagelayout/storage_masters/autoComplete/' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage selection label' AND `language_tag`=''), '0', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='non_tma_block_storages'), (SELECT id FROM structure_fields WHERE `model`='NonTmaBlockStorage' AND `tablename`='view_storage_masters' AND `field`='temperature' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='storage temperature' AND `language_tag`=''), '0', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='non_tma_block_storages'), (SELECT id FROM structure_fields WHERE `model`='NonTmaBlockStorage' AND `tablename`='view_storage_masters' AND `field`='temp_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='non_tma_block_storages'), (SELECT id FROM structure_fields WHERE `model`='NonTmaBlockStorage' AND `tablename`='view_storage_masters' AND `field`='empty_spaces' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='empty spaces' AND `language_tag`=''), '0', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

SET @datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewStorageMaster');
UPDATE datamart_structures
SET plugin = 'StorageLayout',
model = 'NonTmaBlockStorage',
structure_id = (SELECT id FROM structures WHERE alias = 'non_tma_block_storages'),
adv_search_structure_alias = NULL,
display_name = 'storage (non tma block)',
control_master_model = NULL, 
index_link = '/StorageLayout/StorageMasters/detail/%%NonTmaBlockStorage.id%%/',
batch_edit_link = NULL
WHERE id = @datamart_structure_id;

UPDATE datamart_browsing_results
SET browsing_structures_sub_id = 0,
serialized_search_params = NULL
WHERE browsing_structures_id = @datamart_structure_id;

UPDATE datamart_saved_browsing_steps
SET datamart_sub_structure_id = 0,
serialized_search_params = NULL
WHERE datamart_structure_id = @datamart_structure_id;

INSERT IGNORE INTO i18n (id)
VALUES
("'storage (non tma block)' - value generated by newVersionSetup function");
ALTER TABLE datamart_structures MODIFY `display_name` varchar(100) NOT NULL;
UPDATE datamart_structures SET display_name = 'storage (non tma block) - value generated by newVersionSetup function' WHERE id = @datamart_structure_id;
REPLACE INTO i18n (id,en,fr) (SELECT "storage (non tma block) - value generated by newVersionSetup function", en, fr FROM i18n WHERE id = 'storage');
INSERT INTO i18n (id,en,fr) VALUES ('storage (non tma block)', 'Entreposage (Non TMA Block)', 'Entreposage (Bloc de TMA exclu)'); 

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Change structure_value_domains 'models' to get data directly from datamart_structures table
-- -----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name='models');
UPDATE structure_value_domains SET source = "Datamart.DatamartStructure::getDisplayNameFromModel" WHERE domain_name='models';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Change MTool enu title and description
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES
('administration description',
'ATiM administrator tool to set the ATiM users permissions and preferences, to manage all application custom drop down lists, to create new storage types and to get the installed application version information.',
"Outil de l'administarteur d'ATiM utilisé pour définir les droits et préférences des utilisateurs d'ATiM, pour gérer toutes les listes déroulantes personnalisées de l'application, pour créer de nouveaux types d'entreposage et pour afficher les informations relatives à la version de l'application installée."),
('collection_template_description',
'Creation of collections templates allowing users to quickly create collection content without the need to browse the menus after the creation of each element of a new collection (specimen, derivative, aliquot).',
"Création de modèles de collections permettant aux utilisateurs de créer rapidement le contenu d'une collection sans devoir naviguer au travers des menus après la création de chaque élément d'une nouvelle collection (spécimen, dérivé, aliquot)."),
('drug module description', 
'Defintion of drugs and/or active principles that could be used to create common treatment protocols and set the drugs and/or treatments a participant received.',
"Défintion des médicaments et/ou des principes actifs qui pourraient être utilisés pour créer des protocoles de traitement et définir les médicaments et/ou les traitements qu'un participant a reçu."),
('order management description',
 'Tracking orders system to track any research materials (samples aliquots) requests. Each order can be completed across many shipments. Research materials of one order can be classified according to their type.',
 "Système de suivi des commandes de matériels de recherche (aliquots d'échantillons). Chaque commande peut être complétée par plusieurs livraisons. Le matériel de recherche d'une commande peut être classé selon leur nature."),
('protocol description', 
'Setup and define standard treatment protocols used for patients treatment and that could be used to create the participant clinical directory into ATiM.',
"Enregistrement de protocoles standards de traitement qui peuvent être utilisés pour la création des dossiers cliniques des patients dans ATiM."),
('research study description', 
'Gather all information about studies submitted to the bank: Investigators, Approvals, etc. These studies information could be linked to material order, patient consents, etc into ATiM.',
"Regroupe toute l'information des études soumises à la banque: Invéstigateurs, approbations, etc. Ces données d'études pourront ensuite être attachées dans ATiM à des commandes de matériels, des consentements de patient, etc."),
('standard operating procedure description',
'Definition of all the bank standard operating procedures.',
"Définition de toutes les procédures normalisées de fonctionnement de la banque (PNF)."),
('standard operating procedure',
'SOP (Standard Operating Procedure)',
'PNF (Procédure normalisée de fonctionnement)');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#3315: No control on type of a stored item when moving element to a TMA block with the content layout tool
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("the storage data of %s element(s) have been updated", "The storage data of %s element(s) have been updated.", "Les données d'entreposage de %s éléments ont été mises à jour."),
("no storage data has been updated", "No storage data has been updated.", "Aucune donnée d'entreposage n'a été mise à jour."),
("storage data (including position) don't have been updated", "Storage data (including position) don't have been updated!", 'Les données d''entreposage (incluant les postions) n''ont pas été mises à jour!');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#3316: Administration > Manage storage types : Unable to display 20 or 50 records per page
-- Issue#3317: Wrong storage layout for a storage control with Xoordinate 'X' type equal to 'Alphabetical
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_value_domains (domain_name) VALUES ('storage_check_conflicts');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("0", "none"),("1", "warning"),("2", "error");
INSERT IGNORE INTO structure_value_domains_permissible_values 
(structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="storage_check_conflicts"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="none"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="storage_check_conflicts"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="warning"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="storage_check_conflicts"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="error"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageCtrl', 'storage_controls', 'check_conflicts', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='storage_check_conflicts') , '0', '', '1', '', 'check conflicts', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_check_conflicts') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT `id` FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_check_conflicts')), 'notEmpty', '');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('error', 'Error', 'Erreur');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_check_conflicts') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_1d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_check_conflicts') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_2d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_check_conflicts')) WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_tma') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='check_conflicts' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (model='StorageCtrl' AND tablename='storage_controls' AND field='check_conflicts' AND `type`='checkbox' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')));
DELETE FROM structure_fields WHERE (model='StorageCtrl' AND tablename='storage_controls' AND field='check_conflicts' AND `type`='checkbox' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'));

UPDATE structure_formats SET `flag_detail`=flag_index WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') AND `display_order` >= 10;
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') AND `display_order` >= 30;
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') AND `display_order` >= 50;
UPDATE structure_formats SET language_heading='' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='set_temperature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), "range,1,1000000", 'value must be bigger than 1');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('value must be bigger than 1', 'Value must be bigger than 1', 'La valeur doit être supérieure à 1');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), "range,1,1000000", 'value must be bigger than 1');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('value must be bigger than 1', 'Value must be bigger than 1', 'La valeur doit être supérieure à 1');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('storage control data of the storage type [%s] are not correctly set - please contact your administartor',
'Storage properties of the storage type [%s] are not correctly defined. Please contact your ATiM administrator.',
"Les propriétés du type d'entreposage [% s] ne sont pas correctement définies. Veuillez contactervotre administrateur d'ATiM.");

SET @control_id = (SELECT ID FROM structure_permissible_values_custom_controls WHERE name = 'storage types');
DELETE FROM `structure_permissible_values_customs` 
WHERE control_id = @control_id
AND `value` IN (SELECT storage_type from storage_controls WHERE storage_type regexp('^demo[0-9]+$') AND flag_active <> 1);
DELETE FROM storage_controls WHERE storage_type regexp('^demo[0-9]+$') AND flag_active <> 1;


-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.6.8', NOW(),'????','n/a');
