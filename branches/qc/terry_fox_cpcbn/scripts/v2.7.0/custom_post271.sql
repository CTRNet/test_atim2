-- ----------------------------------------------------------------------------------------------------
-- Remove protocole for this version
-- ----------------------------------------------------------------------------------------------------
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE versions SET branch_build_number = '7377' WHERE version_number = '2.7.1';
UPDATE versions SET branch_build_number = '7399' WHERE version_number = '2.7.1';

-- Add QC

UPDATE menus SET flag_active=true WHERE id IN('inv_CAN_2224', 'inv_CAN_224');
UPDATE menus SET flag_active=true WHERE id IN('inv_CAN_22241', 'inv_CAN_2241');
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'QualityCtrl')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'));
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'QualityCtrl')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewSample'));
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create quality control';

-- Aliquot Use Event
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'));
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'StudySummary'));
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create uses/events (aliquot specific)';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create use/event (applied to all)';
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_add`='1', `flag_edit`='1', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_internal_use_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='study_summary_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

-- Slide

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tissue_slide', 'qc_tf_cpcbn_thickness', 'integer_positive',  NULL , '0', '', '', '', 'thickness (um)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tissue_slide' AND `field`='qc_tf_cpcbn_thickness' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='thickness (um)' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '1');
ALTER TABLE ad_tissue_slides ADD COLUMN qc_tf_cpcbn_thickness INT(6) DEFAULT NULL;
ALTER TABLE ad_tissue_slides_revs ADD COLUMN qc_tf_cpcbn_thickness INT(6) DEFAULT NULL;
UPDATE structure_fields SET tablename = 'ad_tissue_slides' WHERE tablename = 'ad_tissue_slide';
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tissue_slides' AND `field`='qc_tf_cpcbn_thickness');
UPDATE versions SET branch_build_number = '7434' WHERE version_number = '2.7.1';