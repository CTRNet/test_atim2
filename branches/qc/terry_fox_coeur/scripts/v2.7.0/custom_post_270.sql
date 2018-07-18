
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Databrowser
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SpecimenReviewMaster ViewSample
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
-- OrderItem TmaSlide
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
-- AliquotReviewMaster ViewAliquot
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
-- AliquotReviewMaster SpecimenReviewMaster
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster');
-- ViewAliquot StudySummary
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str 
SET fct.flag_active = '1' 
WHERE fct.datamart_structure_id = str.id AND str.model = 'SpecimenReviewMaster' AND label = 'number of elements per participant';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' 
WHERE fct.datamart_structure_id = str.id AND str.model = 'AliquotReviewMaster' AND label = 'number of elements per participant';

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'report_ctrnet_catalogue_name';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Actions
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' 
WHERE fct.datamart_structure_id = str.id 
AND str.model = 'TmaSlide' AND label = 'add tma slide use';

UPDATE datamart_structure_functions fct, datamart_structures str 
SET fct.flag_active = '0' 
WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlideUse' AND label = 'edit';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Users
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE users SET  flag_active = 0 WHERE group_id != 1;
SET @password = (SELECT password from users where username = 'NicoEn');
UPDATE users SET password = @password, deleted = 1 WHERE group_id != 1 OR flag_active = 0;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inventory Revision
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Collection

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Versions
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE `versions` SET branch_build_number = '6875' WHERE version_number = '2.7.0';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2017-10-05
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Clinical Annotation Revision
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_suspected_date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'EOC', 'clinical', 'pet scan', 1, 'qc_tf_ed_ct_scans', 'qc_tf_ed_ct_scans', 0, 'pet scan|EOC', 0, 1, 1);
INSERT INTO i18n (id,en,fr) VALUES ('pet scan', 'PET Scan', '');

-- Reports & Summary
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_index`='1'
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='qc_tf_tumor_site');

UPDATE i18n SET en = "Breast" WHERE id = "Breast-Breast";
UPDATE i18n SET en = "Brain" WHERE id = "Central Nervous System-Brain";
UPDATE i18n SET en = "Other Central Nervous System" WHERE id = "Central Nervous System-Other Central Nervous System";
UPDATE i18n SET en = "Spinal Cord" WHERE id = "Central Nervous System-Spinal Cord";
UPDATE i18n SET en = "Anal" WHERE id = "Digestive-Anal";
UPDATE i18n SET en = "Appendix" WHERE id = "Digestive-Appendix";
UPDATE i18n SET en = "Bile Ducts" WHERE id = "Digestive-Bile Ducts";
UPDATE i18n SET en = "Colonic" WHERE id = "Digestive-Colonic";
UPDATE i18n SET en = "Esophageal" WHERE id = "Digestive-Esophageal";
UPDATE i18n SET en = "Gallbladder" WHERE id = "Digestive-Gallbladder";
UPDATE i18n SET en = "Liver" WHERE id = "Digestive-Liver";
UPDATE i18n SET en = "Other Digestive" WHERE id = "Digestive-Other Digestive";
UPDATE i18n SET en = "Pancreas" WHERE id = "Digestive-Pancreas";
UPDATE i18n SET en = "Rectal" WHERE id = "Digestive-Rectal";
UPDATE i18n SET en = "Small Intestine" WHERE id = "Digestive-Small Intestine";
UPDATE i18n SET en = "Stomach" WHERE id = "Digestive-Stomach";
UPDATE i18n SET en = "Cervical" WHERE id = "Female Genital-Cervical";
UPDATE i18n SET en = "Endometrium" WHERE id = "Female Genital-Endometrium";
UPDATE i18n SET en = "Fallopian Tube" WHERE id = "Female Genital-Fallopian Tube";
UPDATE i18n SET en = "Gestational Trophoblastic Neoplasia" WHERE id = "Female Genital-Gestational Trophoblastic Neoplasia";
UPDATE i18n SET en = "Other Female Genital" WHERE id = "Female Genital-Other Female Genital";
UPDATE i18n SET en = "Ovary" WHERE id = "Female Genital-Ovary";
UPDATE i18n SET en = "Peritoneal Pelvis Abdomen" WHERE id = "Female Genital-Peritoneal Pelvis Abdomen";
UPDATE i18n SET en = "Uterine" WHERE id = "Female Genital-Uterine";
UPDATE i18n SET en = "Vagina" WHERE id = "Female Genital-Vagina";
UPDATE i18n SET en = "Vulva" WHERE id = "Female Genital-Vulva";
UPDATE i18n SET en = "Hodgkin's Disease" WHERE id = "Haematological-Hodgkin's Disease";
UPDATE i18n SET en = "Leukemia" WHERE id = "Haematological-Leukemia";
UPDATE i18n SET en = "Lymphoma" WHERE id = "Haematological-Lymphoma";
UPDATE i18n SET en = "Non-Hodgkin's Lymphomas" WHERE id = "Haematological-Non-Hodgkin's Lymphomas";
UPDATE i18n SET en = "Other Haematological" WHERE id = "Haematological-Other Haematological";
UPDATE i18n SET en = "Larynx" WHERE id = "Head & Neck-Larynx";
UPDATE i18n SET en = "Lip and Oral Cavity" WHERE id = "Head & Neck-Lip and Oral Cavity";
UPDATE i18n SET en = "Nasal Cavity and Sinuses" WHERE id = "Head & Neck-Nasal Cavity and Sinuses";
UPDATE i18n SET en = "Other Head & Neck" WHERE id = "Head & Neck-Other Head & Neck";
UPDATE i18n SET en = "Pharynx" WHERE id = "Head & Neck-Pharynx";
UPDATE i18n SET en = "Salivary Glands" WHERE id = "Head & Neck-Salivary Glands";
UPDATE i18n SET en = "Thyroid" WHERE id = "Head & Neck-Thyroid";
UPDATE i18n SET en = "Bone" WHERE id = "Musculoskeletal Sites-Bone";
UPDATE i18n SET en = "Other Bone" WHERE id = "Musculoskeletal Sites-Other Bone";
UPDATE i18n SET en = "Soft Tissue Sarcoma" WHERE id = "Musculoskeletal Sites-Soft Tissue Sarcoma";
UPDATE i18n SET en = "Eye" WHERE id = "Ophthalmic-Eye";
UPDATE i18n SET en = "Other Eye" WHERE id = "Ophthalmic-Other Eye";
UPDATE i18n SET en = "Gross Metastatic Disease" WHERE id = "Other-Gross Metastatic Disease";
UPDATE i18n SET en = "Primary Unknown" WHERE id = "Other-Primary Unknown";
UPDATE i18n SET en = "Melanoma" WHERE id = "Skin-Melanoma";
UPDATE i18n SET en = "Non Melanomas" WHERE id = "Skin-Non Melanomas";
UPDATE i18n SET en = "Other Skin" WHERE id = "Skin-Other Skin";
UPDATE i18n SET en = "Lung" WHERE id = "Thoracic-Lung";
UPDATE i18n SET en = "Mesothelioma" WHERE id = "Thoracic-Mesothelioma";
UPDATE i18n SET en = "Other Thoracic" WHERE id = "Thoracic-Other Thoracic";
UPDATE i18n SET en = "Bladder" WHERE id = "Urinary Tract-Bladder";
UPDATE i18n SET en = "Kidney" WHERE id = "Urinary Tract-Kidney";
UPDATE i18n SET en = "Other Urinary Tract" WHERE id = "Urinary Tract-Other Urinary Tract";
UPDATE i18n SET en = "Renal Pelvis and Ureter" WHERE id = "Urinary Tract-Renal Pelvis and Ureter";
UPDATE i18n SET en = "Urethra" WHERE id = "Urinary Tract-Urethra";
UPDATE i18n SET en = "Unknown" WHERE id = "unknown";
UPDATE i18n SET en = "Ascite" WHERE id = "ascite";

UPDATE datamart_reports SET associated_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'Participant') WHERE name  = 'COEUR Summary';
UPDATE datamart_reports SET associated_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') WHERE name  = 'COEUR Summary from pathology department block code';

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='diagnosis' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='progression_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='first chemotherapy' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_end_of_first_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_chemo_drugs' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='first progression' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_first_progression_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_first_first_chemo_to_first_progression_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other diagnoses' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_other_dx_tumor_site_1' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_date of death' AND `language_label`='registered date of death' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='help_date of birth' AND `language_label`='date of birth' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results');

UPDATE structure_fields SET sortable = '1' WHERE id IN (SELECT structure_field_id FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'));

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_tf_coeur_age_at_last_contact', 'input',  NULL , '0', '', '', '', 'age at last contact', ''), 
('Datamart', '0', '', 'qc_tf_coeur_age_at_death', 'input',  NULL , '0', '', '', '', 'age at death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_age_at_death' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='age at death' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_age_at_last_contact' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='age at last contact' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('age at last contact', 'Age at Last Contact', 'Âge au dernier contact'),
('age at death', 'Age at Death', 'Âge au décès');

UPDATE structure_formats SET display_order = (display_order*6) WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_tf_coeur_start_of_first_chemo', 'date',  NULL , '0', '', '', '', 'start date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_start_of_first_chemo' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='start date' AND `language_tag`=''), '0', '299', 'first chemotherapy', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_end_of_first_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_start_of_first_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_tf_coeur_start_of_first_radio', 'date',  NULL , '0', '', '', '', 'start date', ''), 
('Datamart', '0', '', 'qc_tf_coeur_end_of_first_radio', 'date',  NULL , '0', '', '', '', 'finish date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_start_of_first_radio' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='start date' AND `language_tag`=''), '0', '310', 'first radiotherapy', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_end_of_first_radio' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='finish date' AND `language_tag`=''), '0', '311', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('first radiotherapy', '1st Radiotherapy', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_tf_coeur_start_of_ovarectomy', 'date',  NULL , '0', '', '', '', 'start date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE  `field`='qc_tf_coeur_start_of_ovarectomy'), '0', '315', 'first ovarectomy', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('first ovarectomy', '1st Ovarectomy', '');

REPLACE INTO i18n (id,en,fr)
VALUES
('first chemotherapy', '1st Chemotherapy', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_tf_coeur_first_progression_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_first_progression_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '0', '331', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_tf_coeur_first_ca125_recurrence_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('Datamart', '0', '', 'qc_tf_coeur_first_chemo_to_first_ca125_recurrence_months', 'input',  NULL , '0', '', '', '', 'first chemo to first ca125 recurrence (months)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_first_ca125_recurrence_date'), '0', '337', 'first ca125 recurrence', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_first_chemo_to_first_ca125_recurrence_months'), '0', '339', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('first ca125 recurrence', '1st CA125 Recurrence', ''),
('first chemo to first ca125 recurrence (months)', '1st Chemo to 1st CA125 Recurrence (months)', '');

UPDATE structure_formats SET `language_heading`='first progression != ca125' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_first_progression_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('first progression != ca125', '1st Progression (not CA125)', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'qc_tf_coeur_first_ca125_recurrence_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_first_ca125_recurrence_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '0', '338', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `display_order`='25' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='25' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='qc_tf_coeur_age_at_last_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_coeur_summary_results'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '0', '121', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE `versions` SET branch_build_number = '6889' WHERE version_number = '2.7.0';

-- -------------------------------------------------------------------------------------------------------------------------
-- 
-- -------------------------------------------------------------------------------------------------------------------------

SET @otb_bank_id = (select id FROM banks WHERE name = 'OTB');

SET @modified_by = (SELECT id FROM users WHERE username = 'System');
SET @modified = (SELECT now() FROM users WHERE username = 'System');

UPDATE collections
SET modified = @modified,
modified_by = @modified_by,
collection_datetime_accuracy = 'h',
collection_notes = CONCAT("Dates accuracy in excel was equals to 'Year'. Migration process changed it to 'Day' to allow system to set automatically the dates of treatments, events, etc based on the 'Number of days from collection' defined into Excel. ", collection_notes) 
WHERE  participant_id IN (SELECT id FROM participants WHERE deleted <> 1 AND qc_tf_bank_id = @otb_bank_id)
AND collection_datetime_accuracy = 'm'
AND collection_datetime IS NOT NULL;

INSERT INTO collections_revs (id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property, collection_notes, participant_id, 
diagnosis_master_id, consent_master_id, treatment_master_id, event_master_id, modified_by, version_created)
(SELECT id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property, collection_notes, participant_id, 
diagnosis_master_id, consent_master_id, treatment_master_id, event_master_id, modified_by, modified FROM collections 
WHERE modified = @modified aND modified_by = @modified_by);

SET @ovarectomy_control_id = (select id FROM treatment_controls WHERE tx_method = 'ovarectomy' AND flag_Active = 1);
SET @tissue_sample_control_id = (select id FROM sample_controls WHERE sample_type = 'tissue');

UPDATE treatment_masters TM, collections CO, sample_masters SM
SET TM.start_date = CO.collection_datetime,
TM.start_date_accuracy = 'c',
TM.modified = @modified,
TM.modified_by = @modified_by,
TM.notes = CONCAT("Dates set by migration process based on tissue collection date. ", IFNULL(collection_notes, '')) 
WHERE CO.deleted <> 1
AND TM.deleted <> 1 
AND SM.deleted <> 1  
AND TM.start_date IS NULL
AND TM.treatment_control_id = @ovarectomy_control_id 
AND TM.participant_id IN (SELECT id FROM participants WHERE deleted <> 1 AND qc_tf_bank_id = @otb_bank_id)
AND TM.participant_id = CO.participant_id
AND CO.id = SM.collection_id
AND SM.sample_control_id = @tissue_sample_control_id;

INSERT INTO treatment_masters_revs (id,treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,modified_by,participant_id,
diagnosis_master_id,version_created)
(SELECT id,treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,participant_id,
diagnosis_master_id,modified_by,modified
FROM treatment_masters WHERE modified = @modified aND modified_by = @modified_by);
INSERT INTO qc_tf_tx_empty_revs (treatment_master_id, version_created) (SELECT id,modified FROM treatment_masters WHERE modified = @modified aND modified_by = @modified_by);

UPDATE `versions` SET branch_build_number = '6910' WHERE version_number = '2.7.0';

-- -------------------------------------------------------------------------------------------------------------------------
-- 2018-04-23
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="6" WHERE svd.domain_name='qc_tf_grade' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_grade"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "5", "1");

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("microscopic", "microscopic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_residual_disease"), (SELECT id FROM structure_permissible_values WHERE value="microscopic" AND language_alias="microscopic"), "0", "1");
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('microscopic', 'Microscopic', 'Microscopique');

-- -------------------------------------------------------------------------------------------------------------------------
-- 2018-07-18
-- -------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('dead from disease', 'Dead from Disease', 'Décédé de la maladie');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("dead", "dead from disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="dead" AND language_alias="dead from disease"), "2", "1");

UPDATE `versions` SET branch_build_number = '7255' WHERE version_number = '2.7.0';

-- -------------------------------------------------------------------------------------------------------------------------
-- 2018-07-19
-- -------------------------------------------------------------------------------------------------------------------------

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="health_status" AND spv.value="dead" AND spv.language_alias="dead from disease";
DELETE FROM structure_permissible_values WHERE value="dead" AND language_alias="dead from disease" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="5" WHERE svd.domain_name='health_status' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("deceased from disease", "deceased from disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="deceased from disease" AND language_alias="deceased from disease"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("deceased from other disease", "deceased from other disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="deceased from other disease" AND language_alias="deceased from other disease"), "4", "1");

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('deceased from disease', 'Deceased from Disease', 'Décédé de la maladie'),
('deceased from other disease', 'Deceased from Other Disease', "Décédé d'une autre maladie");

UPDATE `versions` SET branch_build_number = '7259' WHERE version_number = '2.7.0';











