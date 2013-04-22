UPDATE `versions` SET branch_build_number = 'xxx' WHERE version_number = '2.5.4';

UPDATE structure_formats SET `margin`='2' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field` IN ('baseline_b_symp_fever', 'baseline_b_symp_night_sweating', 'baseline_b_symp_weight_loss'));
REPLACE INTO i18n (id,en) VALUES 
('b symptoms : fever', 'Fever (B Sympt.)'), 
('b symptoms : night sweating', 'Night Sweating (B Sympt.)'), 
('b symptoms : weight loss', 'Weight loss (B Sympt.)');
INSERT IGNORE INTO i18n (id,en) VALUES ('unable to add a lymphoma secondary to a lymphoma primary','Unable to add a Lymphoma Secondary to a Lymphoma Primary');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_status_at_last_followup') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ld_lymph_cause_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_history_desc' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='comorbidities_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE diagnosis_controls SET detail_form_alias = '' WHERE detail_form_alias = 'diagnosismasters';
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_histological_transformation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dxd_histo_transformations' AND `field`='new_b_symptoms' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_progression') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_progressions' AND `field`='ld_lymph_trt_at_progression' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_progression') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_progressions' AND `field`='ld_lymph_progression_site_desc' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_bone_marrows') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_bone_marrows' AND `field`='hitological_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
REPLACE INTO i18n (id,en) VALUES
('immuno ki67 percent','KI67 (&#37;)'),
('cytomet cd20', 'CD20 (&#37;)'),
('cytomet cd5', 'CD5 (&#37;)'),
('cytomet cd23', 'CD23 (&#37;)'),
('cytomet cd2', 'CD2 (&#37;)'),
('cytomet cd3', 'CD3 (&#37;)'),
('cytomet cd4', 'CD4 (&#37;)'),
('cytomet cd8', 'CD8 (&#37;)'),
('cytomet lambda', '&#955; (&#37;)'),
('cytomet kappa', '&#954; (&#37;)'),
('cytomet cd10', 'CD10 (&#37;)'),
('cytomet cd19', 'CD19 (&#37;)');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='response_based_on_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='chemo_regimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '21', 'chemotherapy data', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=30', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='dose_modified_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='chemo_regimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_chemos') AND  type = 'input' AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_treatments' AND `field`='chemo_regimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `field`='surgical_procedure'), 'notEmpty', '', 'value is required');
UPDATE event_controls SET databrowser_label = event_type WHERE flag_active = 1;
UPDATE treatment_controls SET databrowser_label = tx_method WHERE flag_active = 1;
UPDATE menus SET flag_active = 0 WHERE use_link like '/Protocol%';
UPDATE menus SET flag_active = 0 WHERE use_link like '/Drug/%';
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/FamilyHistories%';
UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/ReproductiveHistories%';

REPLACE INTO i18n (id,en) VALUES ('ld lym tumor percentage','Tumor &#37;');




































