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

UPDATE structure_fields SET `type`='integer_positive' WHERE `field`='ld_lymph_specimen_number';
ALTER TABLE `sample_masters` CHANGE `ld_lymph_specimen_number` `ld_lymph_specimen_number` int(6) NOT NULL;
ALTER TABLE `sample_masters_revs` CHANGE `ld_lymph_specimen_number` `ld_lymph_specimen_number` int(6) NOT NULL;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0',`flag_search`='0', `flag_index`='0', `flag_summary`='0'  WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES ('cell pellets','Cell Pellets');
INSERT INTO i18n (id,en) VALUES ('lysed','Lysed'),('remained as part of the pellet','Remained as part of the pellet');

UPDATE structure_fields SET field = 'remained_as_part' WHERE field = 'remainded_as_part';

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(185);

ALTER TABLE ld_lymph_consent_details DROP COLUMN id, DROP COLUMN deleted;			
ALTER TABLE ld_lymph_consent_details_revs DROP COLUMN id;																												
ALTER TABLE ld_lymph_dxd_histo_transformations DROP COLUMN id, DROP COLUMN deleted;																					
ALTER TABLE ld_lymph_dxd_histo_transformations_revs DROP COLUMN id;																							
ALTER TABLE ld_lymph_dx_lymphomas DROP COLUMN id, DROP COLUMN deleted;																						
ALTER TABLE ld_lymph_dx_lymphomas_revs DROP COLUMN id;																													
ALTER TABLE ld_lymph_ed_biopsies DROP COLUMN id, DROP COLUMN deleted;																						
ALTER TABLE ld_lymph_ed_biopsies_revs DROP COLUMN id;																											
ALTER TABLE ld_lymph_ed_bone_marrows DROP COLUMN id, DROP COLUMN deleted;																					
ALTER TABLE ld_lymph_ed_bone_marrows_revs DROP COLUMN id;																						
ALTER TABLE ld_lymph_ed_imagings DROP COLUMN id, DROP COLUMN deleted;																										
ALTER TABLE ld_lymph_ed_imagings_revs DROP COLUMN id;																											
ALTER TABLE ld_lymph_ed_labs DROP COLUMN id, DROP COLUMN deleted;																									
ALTER TABLE ld_lymph_ed_labs_revs DROP COLUMN id;																													
ALTER TABLE ld_lymph_ed_reasearch_studies DROP COLUMN id, DROP COLUMN deleted;																									
ALTER TABLE ld_lymph_ed_reasearch_studies_revs DROP COLUMN id;																													
ALTER TABLE ld_lymph_sd_der_cell_pellets DROP COLUMN id, DROP COLUMN deleted;																													
ALTER TABLE ld_lymph_sd_der_cell_pellets_revs DROP COLUMN id;																													
ALTER TABLE ld_lymph_txd_observations DROP COLUMN id, DROP COLUMN deleted;																												
ALTER TABLE ld_lymph_txd_observations_revs DROP COLUMN id;																													
ALTER TABLE ld_lymph_txd_stem_cell_transplants DROP COLUMN id, DROP COLUMN deleted;																													
ALTER TABLE ld_lymph_txd_stem_cell_transplants_revs DROP COLUMN id;								
ALTER TABLE ld_lymph_txd_treatments DROP COLUMN id, DROP COLUMN deleted;		
ALTER TABLE ld_lymph_txd_treatments_revs DROP COLUMN id;			
ALTER TABLE ld_lymph_sd_der_cell_pellets_revs CHANGE `version_id` `version_id` int(11) NOT NULL AUTO_INCREMENT;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'ld_lymph_specimen_number', 'integer_positive',  NULL , '0', 'size=6', '', '', 'specimen number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='ld_lymph_specimen_number' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='specimen number' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

ALTER TABLE participants 
  ADD COLUMN ld_lymph_auto_immunity char(1) DEFAULT '',
  ADD COLUMN ld_lymph_auto_immune_icd10_code varchar(50) DEFAULT NULL,
  ADD COLUMN ld_lymph_thrombosis char(1) DEFAULT ''; 
ALTER TABLE participants_revs
  ADD COLUMN ld_lymph_auto_immunity char(1) DEFAULT '',
  ADD COLUMN ld_lymph_auto_immune_icd10_code varchar(50) DEFAULT NULL,
  ADD COLUMN ld_lymph_thrombosis char(1) DEFAULT '';   
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'ld_lymph_auto_immunity', 'yes_no',  NULL , '0', '', '', '', 'auto-immunity', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'ld_lymph_auto_immune_icd10_code', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who', '', '', 'auto-immunity precision', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'ld_lymph_thrombosis', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who', '', '', 'thrombosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ld_lymph_auto_immunity' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='auto-immunity' AND `language_tag`=''), '3', '10', 'diseases/disorders existence', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ld_lymph_auto_immune_icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='' AND `language_label`='auto-immunity precision' AND `language_tag`=''), '3', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ld_lymph_thrombosis' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='' AND `language_label`='thrombosis' AND `language_tag`=''), '3', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `type`='yes_no',  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='ld_lymph_thrombosis' AND `type`='autocomplete' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en) VALUES ('diseases/disorders existence','Diseases/Disorders Existence'),('auto-immunity','Auto-Immunity'),('auto-immunity precision','Auto-Immunity Precision'),('thrombosis','Thrombosis');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/Adhocs%';

UPDATE structure_fields SET type = 'input', setting = 'size=10,class=range file' WHERE `field`='participant_identifier';
UPDATE structure_fields SET type = 'input', setting = 'size=10,class=range file' WHERE `field`='ld_lymph_specimen_number';

UPDATE datamart_structure_functions SET flag_active = 0 where label = 'print barcodes';
INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`) 
VALUES
(null, 'ld_lymph_specimen_nbr_report', 'ld_lymph_specimen_nbr_report_desc', 'ld_lymph_specimen_nbr_report_params', 'ld_lymph_specimen_nbr_report_res', 'index', 'specimenNumbersReport', '1');
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'Participant'), 'ld_lymph_specimen_nbr_report', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'ld_lymph_specimen_nbr_report')), 1, '');
INSERT INTO i18n (id,en) VALUES ('ld_lymph_specimen_nbr_report', 'Specimen Numbers List'),('ld_lymph_specimen_nbr_report_desc','Build a list of all specimen numbers and the related diagnosis for consented patients.');
INSERT INTO structures(`alias`) VALUES ('ld_lymph_specimen_nbr_report_params');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_params'), (SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `field`='sample_type'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_params'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='lymphoma_type'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES 
('more than 3000 records are returned by the query - please redefine search criteria',
'More than 3000 records are returned by the query! Please redefine search criteria!',
'Plus de 3000 enregistrements sont retournés par la requête! Veuillez redéfinir vos paramêtres de recherche!');
INSERT INTO structures(`alias`) VALUES ('ld_lymph_specimen_nbr_report_res');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='participant_identifier'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='first_name'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='last_name'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res'), 
(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `field`='identifier_value'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='lymphoma_type'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `field`='ld_lymph_specimen_number'), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res'), 
(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `field`='sample_type'), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='name' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='RAMQ' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_specimen_nbr_report_res') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `versions` SET branch_build_number = '5204' WHERE version_number = '2.5.4';
