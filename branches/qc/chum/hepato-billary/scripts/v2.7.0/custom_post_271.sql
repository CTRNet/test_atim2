UPDATE versions SET branch_build_number = '7320' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------
-- 20180817
-- -----------------------------------------------------------------------------------------------------------------------------

-- Collection Tempalte Init
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `language_heading`='specimen' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation site' AND `language_tag`='' LIMIT 0 ,1), '1', '501', 'derivative', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_creation_datetime_defintion' AND `language_label`='creation date' AND `language_tag`='' LIMIT 0 ,1), '1', '503', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by' AND `language_tag`='' LIMIT 0 ,1), '1', '502', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_initial_storage_datetime_defintion' AND `language_label`='initial storage date' AND `language_tag`=''), '2', '1000', 'aliquot', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='0' AND `language_help`='inv_is_problematic_sample_defintion' AND `language_label`='is problematic' AND `language_tag`=''), '2', '1500', 'other if applicable', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue source' AND `language_tag`=''), '2', '1501', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_stored_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stored by' AND `language_tag`=''), '3', '1002', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('other if applicable', 'Other (If Applicable', 'Autre (Si applicable)');
        
UPDATE versions SET branch_build_number = '7379' WHERE version_number = '2.7.1';
UPDATE versions SET branch_build_number = '7397' WHERE version_number = '2.7.1';
UPDATE versions SET branch_build_number = '7428' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------
-- 20181023
-- -----------------------------------------------------------------------------------------------------------------------------

-- Update field external image

SET @modified_by = (SELECT id FROM users WHERE id = 2);
SET @modified = (SELECT NOW() FROM users WHERE id = 2);

UPDATE event_masters EventMaster, qc_hb_ed_hepatobilary_medical_imagings EventDetail
SET EventDetail.external = 1,
EventMaster.modified = @modified,
EventMaster.modified_by = @modified_by
WHERE EventMaster.deleted <> 1
AND EventMaster.id = EventDetail.event_master_id
AND EventDetail.external = 0
AND (EventMaster.event_summary LIKE 'ext'
OR EventMaster.event_summary LIKE 'ext.%'
OR EventMaster.event_summary LIKE 'ext %'
OR EventMaster.event_summary LIKE 'ext,%'
OR EventMaster.event_summary LIKE 'ext;%'
OR EventMaster.event_summary LIKE 'ext:%'
OR EventMaster.event_summary LIKE 'externe'
OR EventMaster.event_summary LIKE 'ext%rieur%'
OR EventMaster.event_summary LIKE 'film ext%rieur%'
OR EventMaster.event_summary LIKE 'fait % %l%ext%rieur%'
OR EventMaster.event_summary LIKE 'doc ext%'
OR EventMaster.event_summary LIKE 'doc.ext%'
OR EventMaster.event_summary LIKE 'doc ext%'
OR EventMaster.event_summary LIKE 'doc.ext%'
OR EventMaster.event_summary LIKE 'dox.ext%'
OR EventMaster.event_summary LIKE 'dox ext%'
OR EventMaster.event_summary LIKE '%examen ext%'
OR EventMaster.event_summary LIKE '%examen  ext%'
OR EventMaster.event_summary LIKE 'scan ext%'
OR EventMaster.event_summary LIKE 'irm ext%'
OR EventMaster.event_summary LIKE '%enteroscan externe%'
OR EventMaster.event_summary LIKE '%cho-abdo ext%'
OR EventMaster.event_summary LIKE '%en externe%'
OR EventMaster.event_summary LIKE '%ERCP en externe%'
OR EventMaster.event_summary LIKE '%ERCP externe%'
OR EventMaster.event_summary LIKE '%ref note % ext%'
OR EventMaster.event_summary LIKE '%info doc ext%'
OR EventMaster.event_summary LIKE '%film ext%rieur%'
OR EventMaster.event_summary LIKE '%externe note%'
OR EventMaster.event_summary LIKE '%coloscopie ext%'
OR EventMaster.event_summary LIKE '%ref consultation m%dicale externe%'
OR EventMaster.event_summary LIKE '%rapport ext non %');

INSERT INTO event_masters_revs (id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy,
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, modified_by, version_created)
(SELECT id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy,
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, modified_by, modified
FROM event_masters WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO qc_hb_ed_hepatobilary_medical_imagings_revs (event_master_id, segment_1_number, segment_1_size, segment_2_number, segment_2_size, segment_3_number, segment_3_size, segment_4_number, segment_4_size, segment_4a_number, 
segment_4a_size, segment_4b_number, segment_4b_size, segment_5_number, segment_5_size, segment_6_number, segment_6_size, segment_7_number, segment_7_size, segment_8_number, 
segment_8_size, other_segment_is_multi, other_segment_size, other_segment_location, density, type, diameter_first_measure_mm, diameter_second_measure_mm, 
diameter_third_measure_mm, diameter2_first_measure_mm, diameter2_second_measure_mm, diameter2_third_measure_mm, diameter3_first_measure_mm, diameter3_second_measure_mm, 
diameter3_third_measure_mm, radiologic_tace_response, radiologic_rf_response, lungs_number, lungs_size, lungs_laterality, lymph_node_number, lymph_node_size, colon_number, 
colon_size, rectum_number, rectum_size, bile_ducts_number, bile_ducts_size, bile_ducts_specify, bones_number, bones_size, other_localisation_1, other_localisation_1_number, 
other_localisation_1_size, other_localisation_2, other_localisation_2_number, other_localisation_2_size, other_localisation_3, other_localisation_3_number, 
other_localisation_3_size, hepatic_artery, coeliac_trunk, splenic_artery, superior_mesenteric_artery, portal_vein, superior_mesenteric_vein, splenic_vein, 
metastatic_lymph_nodes, pancreas_number, pancreas_size, is_volumetry_post_pve, total_liver_volume, resected_liver_volume, 
remnant_liver_volume, tumoral_volume, remnant_liver_percentage, normal_result, metastatic_lymph_nodes_number, metastatic_lymph_nodes_size, request_nbr, external, version_created)
(SELECT event_master_id, segment_1_number, segment_1_size, segment_2_number, segment_2_size, segment_3_number, segment_3_size, segment_4_number, segment_4_size, segment_4a_number, 
segment_4a_size, segment_4b_number, segment_4b_size, segment_5_number, segment_5_size, segment_6_number, segment_6_size, segment_7_number, segment_7_size, segment_8_number, 
segment_8_size, other_segment_is_multi, other_segment_size, other_segment_location, density, type, diameter_first_measure_mm, diameter_second_measure_mm, 
diameter_third_measure_mm, diameter2_first_measure_mm, diameter2_second_measure_mm, diameter2_third_measure_mm, diameter3_first_measure_mm, diameter3_second_measure_mm, 
diameter3_third_measure_mm, radiologic_tace_response, radiologic_rf_response, lungs_number, lungs_size, lungs_laterality, lymph_node_number, lymph_node_size, colon_number, 
colon_size, rectum_number, rectum_size, bile_ducts_number, bile_ducts_size, bile_ducts_specify, bones_number, bones_size, other_localisation_1, other_localisation_1_number, 
other_localisation_1_size, other_localisation_2, other_localisation_2_number, other_localisation_2_size, other_localisation_3, other_localisation_3_number, 
other_localisation_3_size, hepatic_artery, coeliac_trunk, splenic_artery, superior_mesenteric_artery, portal_vein, superior_mesenteric_vein, splenic_vein, 
metastatic_lymph_nodes, pancreas_number, pancreas_size, is_volumetry_post_pve, total_liver_volume, resected_liver_volume, 
remnant_liver_volume, tumoral_volume, remnant_liver_percentage, normal_result, metastatic_lymph_nodes_number, metastatic_lymph_nodes_size, request_nbr, external, modified
FROM event_masters INNER JOIN qc_hb_ed_hepatobilary_medical_imagings ON id = event_master_id
WHERE modified = @modified AND modified_by = @modified_by);

UPDATE versions SET branch_build_number = '7467' WHERE version_number = '2.7.1';