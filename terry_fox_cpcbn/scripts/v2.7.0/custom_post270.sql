UPDATE users SET flag_active = 0, username = 'system', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE username = 'manager';
UPDATE groups SET name = 'System' WHERE id = 2;

-- Database Validation Tool : Ccl

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add tma slide use';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlideUse' AND label = 'edit';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add to order';

-- chronology

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='chronology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Drug/Treatment update

UPDATE structure_formats SET `flag_edit`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE treatment_extend_controls 
SET detail_form_alias = 'txe_chemos'
WHERE flag_active = 1;

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_tf_txe_chemo_drugs', 'qc_tf_txe_horm_drugs', 'qc_tf_txe_bone_drugs', 'qc_tf_txe_HR_drugs'));
DELETE FROM structures WHERE alias IN ('qc_tf_txe_chemo_drugs', 'qc_tf_txe_horm_drugs', 'qc_tf_txe_bone_drugs', 'qc_tf_txe_HR_drugs');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'drug_id' AND model = 'TreatmentExtendDetail');
DELETE FROM structure_fields WHERE field = 'drug_id' AND model = 'TreatmentExtendDetail';
DELETE FROM structure_value_domains WHERE source like 'Drug.Drug::get%' AND domain_name LIKE '%_drug_list';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('at least one selected drug does not match the type of the treatment', "At least one selected drug does not match the type of the treatment!", ""),
('biochemical', 'Biochemical', '');
UPDATE treatment_extend_controls SET type = 'chemotherapy drugs', databrowser_label = 'chemotherapy drugs' WHERE type = 'chemotherpay drugs';
UPDATE treatment_extend_controls SET type = 'hormonotherapy drugs', databrowser_label = 'hormonotherapy drugs' WHERE type = 'hormonotherpay drugs';
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('chemotherapy drugs','Chemotherapy Drugs', ''),
('hormonotherapy drugs','Hormonotherapy Drugs',  '');

-- qc_tf_txd_biopsies_and_turps.type

ALTER TABLE qc_tf_txd_biopsies_and_turps 
  ADD COLUMN type_specification VARCHAR(100) DEFAULT NULL,
  ADD COLUMN sent_to_chum tinyint(1) DEFAULT '0';
ALTER TABLE qc_tf_txd_biopsies_and_turps_revs
  ADD COLUMN type_specification VARCHAR(100) DEFAULT NULL,
  ADD COLUMN sent_to_chum tinyint(1) DEFAULT '0';  
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_tf_biopsy_type_specifications", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ("Dx", "Dx"),("follow-up", "follow-up"),("prior to Tx", "prior to Tx");
INSERT IGNORE INTO i18n (id,en,fr) VALUES ("Dx", "Dx", ''),("follow-up", "Follow-up", ''),("prior to Tx", "Prior to Tx", '');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type_specifications"), 
(SELECT id FROM structure_permissible_values WHERE value="Dx" AND language_alias="Dx"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type_specifications"), 
(SELECT id FROM structure_permissible_values WHERE value="follow-up" AND language_alias="follow-up"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type_specifications"), 
(SELECT id FROM structure_permissible_values WHERE value="prior to Tx" AND language_alias="prior to Tx"), "1", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies_and_turps', 'type_specification', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type_specifications') , '0', '', '', '', '', 'specification'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies_and_turps', 'sent_to_chum', 'checkbox',  NULL , '0', '', '', '', 'sent to chum', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='type_specification' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type_specifications')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specification'), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='sent_to_chum' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sent to chum' AND `language_tag`=''), '1', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ("specification", "Specification", ''),("sent to chum", "Sent To CHUM", '');
SET @modified = (SELECT NOW() FROM users where username = 'system');
SET @modified_by = (SELECT id FROM users where username = 'system');
UPDATE treatment_masters, qc_tf_txd_biopsies_and_turps
SET type = 'Bx', type_specification = 'Dx', modified = @modified, modified_by = @modified_by
WHERE id = treatment_master_id 
AND deleted <> 1
AND type = 'Bx Dx';
UPDATE treatment_masters, qc_tf_txd_biopsies_and_turps
SET type = 'Bx', type_specification = '', sent_to_chum = '1', modified = @modified, modified_by = @modified_by
WHERE id = treatment_master_id 
AND deleted <> 1
AND type = 'Bx CHUM';
UPDATE treatment_masters, qc_tf_txd_biopsies_and_turps
SET type = 'Bx', type_specification = 'prior to Tx', modified = @modified, modified_by = @modified_by
WHERE id = treatment_master_id 
AND deleted <> 1
AND type = 'Bx prior to Tx';
UPDATE treatment_masters, qc_tf_txd_biopsies_and_turps
SET type = 'TURP', type_specification = 'Dx', modified = @modified, modified_by = @modified_by
WHERE id = treatment_master_id 
AND deleted <> 1
AND type = 'TURP Dx';
UPDATE treatment_masters, qc_tf_txd_biopsies_and_turps
SET type = 'Bx TRUS-Guided', type_specification = 'Dx', modified = @modified, modified_by = @modified_by
WHERE id = treatment_master_id 
AND deleted <> 1
AND type = 'Bx Dx TRUS-Guided';
INSERT INTO treatment_masters_revs (treatment_control_id, qc_tf_disease_free_survival_start_events, id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes, protocol_master_id, participant_id, diagnosis_master_id, modified_by, version_created) 
(SELECT treatment_control_id, qc_tf_disease_free_survival_start_events, id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes, protocol_master_id, participant_id, diagnosis_master_id, modified_by, modified
FROM treatment_masters WHERE modified = @modified AND modified_by = @modified_by);
INSERT INTO qc_tf_txd_biopsies_and_turps_revs (sent_to_chum, total_number_taken, treatment_master_id, gleason_score, total_positive, greatest_percent_of_cancer, gleason_grade, type, ctnm, perineural_invasion, type_specification, chum, version_created)
(SELECT sent_to_chum, total_number_taken, treatment_master_id, gleason_score, total_positive, greatest_percent_of_cancer, gleason_grade, type, ctnm, perineural_invasion, type_specification, chum, modified 
FROM treatment_masters INNER JOIN qc_tf_txd_biopsies_and_turps ON id = treatment_master_id WHERE modified = @modified AND modified_by = @modified_by);
UPDATE structure_value_domains_permissible_values 
SET flag_active = '0'
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_turp_type")
AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value IN ('Bx Dx', 'Bx CHUM', 'Bx prior to Tx', 'Bx Dx TRUS-Guided', 'TURP Dx'));






















UPDATE versions SET branch_build_number = 'xxxxx' WHERE version_number = '2.7.0';



Types de lames doivent être déplacés au niveau des blocs de TMA
Ajouter 'Suregry pour métastases.
