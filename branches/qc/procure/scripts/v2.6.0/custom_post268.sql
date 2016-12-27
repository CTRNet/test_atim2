
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Profile
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `language_heading`='vital status' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');

-- Consent
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_signed_date'), 'notEmpty');

-- delete procure_cd_sigantures.patient_identity_verified
ALTER TABLE procure_cd_sigantures CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
ALTER TABLE procure_cd_sigantures_revs CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_consent_form_siganture') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- delete consent_masters.procure_form_identification
ALTER TABLE consent_masters CHANGE procure_form_identification procure_deprecated_field_procure_form_identification VARCHAR(50) DEFAULT NULL;
ALTER TABLE consent_masters_revs CHANGE procure_form_identification procure_deprecated_field_procure_form_identification VARCHAR(50) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_form_identification' AND `language_label`='consent form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_form_identification' AND `language_label`='consent form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_form_identification' AND `language_label`='consent form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES ('procure consent form signature', 'PROCURE Consent', 'Consentement PROCURE');

-- Contact
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
ALTER TABLE participant_contacts
  ADD COLUMN procure_email varchar(100) DEFAULT NULL;
ALTER TABLE participant_contacts_revs
  ADD COLUMN procure_email varchar(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'procure_email', 'input',  NULL , '0', 'size=40', '', '', 'email', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='procure_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='email' AND `language_tag`=''), '2', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('email', 'Email', 'Courriel');

-- Diagnosis
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET flag_active = 0;

-- Event
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- delete event_masters.procure_form_identification
ALTER TABLE event_masters CHANGE procure_form_identification procure_deprecated_field_procure_form_identification VARCHAR(50) DEFAULT NULL;
ALTER TABLE event_masters_revs CHANGE procure_form_identification procure_deprecated_field_procure_form_identification VARCHAR(50) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `language_label`='event form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `language_label`='event form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `language_label`='event form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- @@@ Laboratory (previous APS) @@@
--      ** Event Type : procure follow-up worksheet - aps => prostate cancer - laboratory
--      ** Table Name : procure_ed_clinical_followup_worksheet_aps => procure_ed_prostate_cancer_laboratory
--      ** Form Alias : procure_ed_followup_worksheet_aps =>  procure_ed_prostate_cancer_laboratory

UPDATE event_controls
SET event_type = 'prostate cancer - laboratory', 
detail_form_alias = 'procure_ed_prostate_cancer_laboratory', 
detail_tablename = 'procure_ed_prostate_cancer_laboratory'
WHERE event_type = 'procure follow-up worksheet - aps';
INSERT INTO i18n (id,en,fr) VALUES ('prostate cancer - laboratory', 'Laboratory', 'Laboratoire');

ALTER TABLE procure_ed_clinical_followup_worksheet_aps 
  RENAME procure_ed_prostate_cancer_laboratory;
ALTER TABLE procure_ed_clinical_followup_worksheet_aps_revs 
  RENAME procure_ed_prostate_cancer_laboratory_revs;
ALTER TABLE procure_ed_prostate_cancer_laboratory
   CHANGE total_ngml psa_total_ngml decimal(10,2) DEFAULT NULL,
   ADD COLUMN testosterone_nmoll decimal(10,2) DEFAULT NULL;
ALTER TABLE procure_ed_prostate_cancer_laboratory_revs
   CHANGE total_ngml psa_total_ngml decimal(10,2) DEFAULT NULL,
   ADD COLUMN testosterone_nmoll decimal(10,2) DEFAULT NULL;
UPDATE structures SET alias = 'procure_ed_prostate_cancer_laboratory' WHERE alias = 'procure_ed_followup_worksheet_aps';
UPDATE structure_fields SET tablename = 'procure_ed_prostate_cancer_laboratory' WHERE tablename = 'procure_ed_clinical_followup_worksheet_aps';
UPDATE structure_fields SET field = 'psa_total_ngml', language_label = 'psa - total ng/ml' WHERE tablename = 'procure_ed_prostate_cancer_laboratory' AND field = 'total_ngml';
INSERT INTO i18n (id,en,fr) VALUES ('psa - total ng/ml', 'PSA - Total (ng/ml)', 'APS - Total (ng/ml)');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_prostate_cancer_laboratory', 'testosterone_nmoll', 'float_positive',  NULL , '0', 'size=5', '', '', 'testosterone - nmol/l', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_laboratory'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_laboratory' AND `field`='testosterone_nmoll' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='testosterone - nmol/l' AND `language_tag`=''), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('testosterone - nmol/l', 'Testosterone (nmol/l)', 'Téstostérone (nmol/l)');
DELETE FROM structure_validations WHERE structure_field_id = (SELECT id from structure_fields WHERE field = 'psa_total_ngml');
INSERT INTO i18n (id,en,fr) VALUES ('at least a psa or testosterone value should be set', 'At least a psa or testosterone value should be set', 'Au moins une valeur d''APS ou de téstostérone doit être saisie');

ALTER TABLE procure_ed_prostate_cancer_laboratory
  ADD COLUMN psa_free_ngml  decimal(10,2) DEFAULT NULL;
ALTER TABLE procure_ed_prostate_cancer_laboratory_revs
  ADD COLUMN psa_free_ngml  decimal(10,2) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_prostate_cancer_laboratory', 'psa_free_ngml', 'float_positive',  NULL , '0', 'size=5', '', '', 'psa - free ng/ml', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_laboratory'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_laboratory' AND `field`='psa_free_ngml' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='psa - free ng/ml' AND `language_tag`=''), '1', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='psa' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_laboratory') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_laboratory' AND `field`='psa_total_ngml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_laboratory') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_laboratory' AND `field`='testosterone_nmoll' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr)
VALUES
('psa - free ng/ml', 'PSA - Free (ng/ml)', 'APS - Libre (ng/ml)');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_laboratory') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_laboratory' AND `field`='psa_free_ngml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- @@@ Clinical Exam @@@
--      ** Event Type : procure follow-up worksheet - clinical event => prostate cancer - clinical exam
--      ** Table Name : procure_ed_clinical_followup_worksheet_clinical_events => procure_ed_prostate_cancer_clinical_exams
--      ** Form Alias : procure_ed_followup_worksheet_clinical_event =>  procure_ed_prostate_cancer_clinical_exams

INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('biopsy','biopsy'),
('clinical exam to define','clinical exam to define');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('clinical exam to define', 'Exam (To define)', 'Examen (À définir)');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_exam_types"), (SELECT id FROM structure_permissible_values WHERE value="biopsy" AND language_alias="biopsy"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_exam_types"), (SELECT id FROM structure_permissible_values WHERE value="clinical exam to define" AND language_alias="clinical exam to define"), "1000", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_followup_exam_type_precisions", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Exam Precisions\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Clinical Exam Precisions', 1, 100, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Exam Precisions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('chest' ,'Chest', 'Poitrine', '1', @control_id),
('fdg' ,'FDG', '', '1', @control_id),
('abdomen / pelvis' ,'Abdomen/Pelvis', 'Abdomen/Bassin', '1', @control_id),
('spine' ,'Spine', 'Colonne vertébrale', '1', @control_id),
('bone' ,'Bone', 'Os', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'type_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_type_precisions') , '0', '', '', '', '', 'precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='type_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_type_precisions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='precision'), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events ADD COLUMN type_precision VARCHAR(100) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs ADD COLUMN type_precision VARCHAR(100) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events ADD COLUMN progression_comorbidity VARCHAR(100) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs ADD COLUMN progression_comorbidity VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_progressions_comorbidities", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Progressions & Comorbidities\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Progressions & Comorbidities', 1, 100, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Progressions & Comorbidities');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('progressions comorbidity to define', 'Progression/Comorbidity (To Define)', 'Progression/comorbidité (À définir)', '1', @control_id),
('local tumor progression', 'Local tumor progression', 'Progression locale de la tumeur', '1', @control_id),
("bone metastases", "Bone metastases", "Métastases osseuses", '1', @control_id),
("hydronephrosis", "Hydronephrosis", "Hydronephrose", '1', @control_id),
("liver metastases", "Liver metastases", "Métastases hépatiques", '1', @control_id),
("lung metastases", "Lung metastases", "Métastases pulmonaires", '1', @control_id),
("pelvic lymph nodes", "Pelvic lymph nodes", "Nodules lymphatiques pelviens", '1', @control_id),
("retroperitoneal lymph nodes", "Retroperitoneal lymph nodes", "Glandes rétropéritonéales", '1', @control_id),
("spinal cord compression", "Spinal cord compression", "Compression de la moelle épinière", '1', @control_id),
("spine metastases", "Spine metastases", "Métastases de la colonne vertébrale", '1', @control_id),
("thoracic lymph nodes", "Thoracic lymph nodes", "Noeuds lymphatiques thoraciques", '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'progression_comorbidity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_progressions_comorbidities') , '0', '', '', '', 'progression / comorbidity', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='progression_comorbidity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_progressions_comorbidities')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progression / comorbidity' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('progression / comorbidity', 'Progression/Comorbidity' ,'Progression/Comorbidité');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('result should be set to positive or suspicious for any progression or comorbidity diagnosis',
'Result should be set to positive or suspicious for any progression or comorbidity diagnosis',
'Le résultat doit être positif ou suspect pour tout diagnostic de progression ou de comorbidité'),
('no progression/comorbidity should be set for a prostate clinical exam',
'No progression/comorbidity should be set for a prostate clinical exam',
'Aucune progression / comorbidité ne devrait être fixée pour un examen clinique de la prostate');

UPDATE structure_value_domains SET domain_name="procure_clinical_exam_types" WHERE domain_name="procure_followup_exam_types";
UPDATE structure_value_domains SET domain_name="procure_clinical_exam_results" WHERE domain_name="procure_followup_exam_results";
UPDATE structure_value_domains SET domain_name="procure_clinical_exam_type_precisions" WHERE domain_name="procure_followup_exam_type_precisions";

UPDATE event_controls
SET event_type = 'prostate cancer - clinical exam', 
detail_form_alias = 'procure_ed_prostate_cancer_clinical_exams', 
detail_tablename = 'procure_ed_prostate_cancer_clinical_exams'
WHERE event_type = 'procure follow-up worksheet - clinical event';
UPDATE structures SET alias = 'procure_ed_prostate_cancer_clinical_exams' WHERE alias = 'procure_ed_followup_worksheet_clinical_event';
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events 
  RENAME TO procure_ed_prostate_cancer_clinical_exams;
ALTER TABLE procure_ed_clinical_followup_worksheet_clinical_events_revs 
  RENAME TO procure_ed_prostate_cancer_clinical_exams_revs;
UPDATE structure_fields SET tablename = 'procure_ed_prostate_cancer_clinical_exams' WHERE tablename = 'procure_ed_clinical_followup_worksheet_clinical_events';
INSERT INTO i18n (id,en,fr) 
VALUES ('prostate cancer - clinical exam', 'Clinical Exam', 'Examen clinique');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Exam Precisions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
("prostate", "Prostate", "Prostate", '1', @control_id);

-- Prostate Diagnostic
--      ** Event Type : procure diagnostic information worksheet => prostate cancer - diagnosis
--      ** Table Name : procure_ed_lab_diagnostic_information_worksheets => procure_ed_prostate_cancer_diagnosis
--      ** Form Alias : procure_ed_diagnostic_information_worksheet =>  procure_ed_prostate_cancer_diagnosis

-- delete procure_ed_lab_diagnostic_information_worksheets.patient_identity_verified
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets_revs CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_fields SET field = 'data_collection_date' WHERE field = 'id_confirmation_date' AND tablename = 'procure_ed_lab_diagnostic_information_worksheets';
UPDATE structure_fields SET  `language_label`='date',  `language_tag`='' WHERE model='EventDetail' AND tablename='procure_ed_lab_diagnostic_information_worksheets' AND field='data_collection_date' AND `type`='date' AND structure_value_domain  IS NULL ;
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets 
  CHANGE id_confirmation_date data_collection_date date DEFAULT NULL,
  CHANGE id_confirmation_date_accuracy data_collection_date_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets_revs 
  CHANGE id_confirmation_date data_collection_date date DEFAULT NULL,
  CHANGE id_confirmation_date_accuracy data_collection_date_accuracy char(1) NOT NULL DEFAULT '';

UPDATE event_controls
SET event_type = 'prostate cancer - diagnosis', 
detail_form_alias = 'procure_ed_prostate_cancer_diagnosis', 
detail_tablename = 'procure_ed_prostate_cancer_diagnosis'
WHERE event_type = 'procure diagnostic information worksheet';
UPDATE structures SET alias = 'procure_ed_prostate_cancer_diagnosis' WHERE alias = 'procure_ed_diagnostic_information_worksheet';
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets 
  RENAME TO procure_ed_prostate_cancer_diagnosis;
ALTER TABLE procure_ed_lab_diagnostic_information_worksheets_revs 
  RENAME TO procure_ed_prostate_cancer_diagnosis_revs;
UPDATE structure_fields SET tablename = 'procure_ed_prostate_cancer_diagnosis' WHERE tablename = 'procure_ed_lab_diagnostic_information_worksheets';
INSERT INTO i18n (id,en,fr) 
VALUES ('prostate cancer - diagnosis', 'Prostate - Diagnosis (Pathology of biopsy)', 'Prostate - Diagnostic (pathologie de la biopsie)');

UPDATE structure_formats SET `language_heading`='biopsy' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_pre_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsies_before');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_date');
UPDATE structure_fields SET  `language_label`='',  `language_tag`='date' WHERE model='EventDetail' AND tablename='procure_ed_prostate_cancer_diagnosis' AND field='biopsy_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsies_before' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_pre_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE procure_ed_prostate_cancer_diagnosis 
  CHANGE data_collection_date procure_deprecated_field_data_collection_date date DEFAULT NULL,
   CHANGE data_collection_date_accuracy procure_deprecated_field_data_collection_date_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE procure_ed_prostate_cancer_diagnosis_revs 
  CHANGE data_collection_date procure_deprecated_field_data_collection_date date DEFAULT NULL,
   CHANGE data_collection_date_accuracy procure_deprecated_field_data_collection_date_accuracy char(1) NOT NULL DEFAULT '';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='data_collection_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='data_collection_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='data_collection_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- data migration of biopsy information
SELECT Participant.participant_identifier AS 'Participant with biopsies before the biopsy of diagnostic but no date set. No biospy will be created by migration process. Please review patient clinical history.', EventMaster.id AS 'EventMaster id record'
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE Participant.deleted <> 1
AND EventMaster.deleted <> 1
AND EventDetail.biopsies_before = 'y'
AND (EventDetail.biopsy_date IS NULL OR EventDetail.biopsy_date LIKE '');

ALTER TABLE event_masters ADD COLUMN tmp_procure_migration varchar(100) DEFAULT NULL;
SET @clinical_exam_event_control_id = (SELECT id FROM event_controls WHERE event_type = 'prostate cancer - clinical exam');
SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
INSERT INTO event_masters (participant_id, event_control_id, event_date, event_date_accuracy, procure_created_by_bank, event_summary, 
modified, created, created_by, modified_by, tmp_procure_migration) 
(SELECT DISTINCT EventMaster.participant_id, @clinical_exam_event_control_id, EventDetail.biopsy_date, EventDetail.biopsy_date_accuracy, procure_created_by_bank, "Created by migration process from 'Diagnosis' form based on 'Biopsy pre diagnostic' field.",
@modified, @modified, @modified_by, @modified_by, '1'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND (EventDetail.biopsy_date IS NOT NULL AND EventDetail.biopsy_date NOT LIKE '')
AND EventMaster.id NOT IN (
	SELECT DxBiopsyRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.biopsy_date, EventDetail.biopsy_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND (EventDetail.biopsy_date IS NOT NULL AND EventDetail.biopsy_date NOT LIKE '')
	) DxBiopsyRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_clinical_exams EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.type = 'biopsy'
		AND (EventMaster.event_date IS NOT NULL AND EventMaster.event_date NOT LIKE '')
	) ExamBiopsyRec
	WHERE DxBiopsyRec.participant_id = ExamBiopsyRec.participant_id
	AND DxBiopsyRec.biopsy_date = ExamBiopsyRec.event_date
	AND DxBiopsyRec.biopsy_date_accuracy = ExamBiopsyRec.event_date_accuracy
));
INSERT INTO procure_ed_prostate_cancer_clinical_exams (type, type_precision, results, event_master_id)
(SELECT 'biopsy', 'prostate', '', id FROM event_masters WHERE tmp_procure_migration = '1' AND created = @modified AND created_by = @modified_by);

INSERT INTO event_masters (participant_id, event_control_id, event_date, event_date_accuracy, procure_created_by_bank, event_summary, 
modified, created, created_by, modified_by, tmp_procure_migration) 
(SELECT DISTINCT EventMaster.participant_id, @clinical_exam_event_control_id, EventDetail.biopsy_pre_surgery_date, EventDetail.biopsy_pre_surgery_date_accuracy, procure_created_by_bank, "Created by migration process from 'Diagnosis' form based on 'Biopsy of diagnostic' field.",
@modified, @modified, @modified_by, @modified_by, '2'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND (EventDetail.biopsy_pre_surgery_date IS NOT NULL AND EventDetail.biopsy_pre_surgery_date NOT LIKE '')
AND EventMaster.id NOT IN (
	SELECT DxBiopsyRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.biopsy_pre_surgery_date, EventDetail.biopsy_pre_surgery_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND (EventDetail.biopsy_pre_surgery_date IS NOT NULL AND EventDetail.biopsy_pre_surgery_date NOT LIKE '')
	) DxBiopsyRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_clinical_exams EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.type = 'biopsy'
		AND EventDetail.results = 'positive'
		AND (EventMaster.event_date IS NOT NULL AND EventMaster.event_date NOT LIKE '')
	) ExamBiopsyRec
	WHERE DxBiopsyRec.participant_id = ExamBiopsyRec.participant_id
	AND DxBiopsyRec.biopsy_pre_surgery_date = ExamBiopsyRec.event_date
	AND DxBiopsyRec.biopsy_pre_surgery_date_accuracy = ExamBiopsyRec.event_date_accuracy
));
INSERT INTO procure_ed_prostate_cancer_clinical_exams (type, type_precision, results, event_master_id)
(SELECT 'biopsy', 'prostate', 'positive', id FROM event_masters WHERE tmp_procure_migration = '2' AND created = @modified AND created_by = @modified_by);
INSERT INTO event_masters_revs (id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
version_created, modified_by)
(SELECT id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
modified, modified_by 
FROM event_masters WHERE tmp_procure_migration IN ('1', '2') AND created = @modified AND created_by = @modified_by);
INSERT INTO procure_ed_prostate_cancer_clinical_exams_revs (type, event_master_id, results, type_precision, progression_comorbidity, version_created)
(SELECT type, event_master_id, results, type_precision, progression_comorbidity, modified
FROM event_masters INNER JOIN procure_ed_prostate_cancer_clinical_exams ON id = event_master_id
WHERE tmp_procure_migration IN ('1', '2') AND created = @modified AND created_by = @modified_by);
ALTER TABLE event_masters DROP COLUMN tmp_procure_migration;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsies_before' AND `language_label`='did the patient have biopsies before' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsies_before' AND `language_label`='did the patient have biopsies before' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsies_before' AND `language_label`='did the patient have biopsies before' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_date' AND `language_label`='' AND `language_tag`='date' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_ed_prostate_cancer_diagnosis 
  CHANGE biopsy_date procure_deprecated_field_biopsy_date date DEFAULT NULL,
  CHANGE biopsy_date_accuracy procure_deprecated_field_biopsy_date_accuracy char(1) NOT NULL DEFAULT '',
  CHANGE biopsies_before procure_deprecated_field_biopsies_before char(1) NOT NULL DEFAULT '';
ALTER TABLE procure_ed_prostate_cancer_diagnosis_revs 
  CHANGE biopsy_date procure_deprecated_field_biopsy_date date DEFAULT NULL,
  CHANGE biopsy_date_accuracy procure_deprecated_field_biopsy_date_accuracy char(1) NOT NULL DEFAULT '',
  CHANGE biopsies_before procure_deprecated_field_biopsies_before char(1) NOT NULL DEFAULT '';

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='biopsy' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='biopsy_pre_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- data migration of PSA information
SELECT Participant.participant_identifier AS 'Participant with PSA information but either date or value is missing to be migrated. No PSA will be created by migration process. Please review patient clinical history.',
EventMaster.id AS 'EventMaster id record',
aps_pre_surgery_date AS 'PSA DATE',
aps_pre_surgery_total_ng_ml AS 'PSA total', 
aps_pre_surgery_free_ng_ml AS 'PSA free'
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE Participant.deleted <> 1
AND EventMaster.deleted <> 1
AND (((EventDetail.aps_pre_surgery_date IS NULL OR EventDetail.aps_pre_surgery_date LIKE '')
AND ((EventDetail.aps_pre_surgery_total_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_total_ng_ml NOT LIKE '') OR (EventDetail.aps_pre_surgery_free_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_free_ng_ml NOT LIKE '')))
OR ((EventDetail.aps_pre_surgery_date IS NOT NULL AND EventDetail.aps_pre_surgery_date NOT LIKE '')
AND ((EventDetail.aps_pre_surgery_total_ng_ml IS NULL OR EventDetail.aps_pre_surgery_total_ng_ml LIKE '') AND (EventDetail.aps_pre_surgery_free_ng_ml IS NULL OR EventDetail.aps_pre_surgery_free_ng_ml LIKE ''))));

ALTER TABLE event_masters 
  ADD COLUMN tmp_procure_migration varchar(100) DEFAULT NULL,
  ADD COLUMN tmp_aps_pre_surgery_total_ng_ml decimal(10,2) DEFAULT NULL,
  ADD COLUMN tmp_aps_pre_surgery_free_ng_ml decimal(10,2) DEFAULT NULL;
SET @clinical_psa_event_control_id = (SELECT id FROM event_controls WHERE event_type = 'prostate cancer - laboratory');
SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
INSERT INTO event_masters (participant_id, event_control_id, event_date, event_date_accuracy, 
tmp_aps_pre_surgery_total_ng_ml, tmp_aps_pre_surgery_free_ng_ml,
procure_created_by_bank, event_summary, 
modified, created, created_by, modified_by, tmp_procure_migration) 
(SELECT DISTINCT EventMaster.participant_id, @clinical_psa_event_control_id, EventDetail.aps_pre_surgery_date, EventDetail.aps_pre_surgery_date_accuracy, 
EventDetail.aps_pre_surgery_total_ng_ml, EventDetail.aps_pre_surgery_free_ng_ml,
procure_created_by_bank, "Created by migration process from 'Diagnosis' form based on 'PSA' field.",
@modified, @modified, @modified_by, @modified_by, '1'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND EventDetail.aps_pre_surgery_date IS NOT NULL AND EventDetail.aps_pre_surgery_date NOT LIKE ''
AND ((EventDetail.aps_pre_surgery_total_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_total_ng_ml NOT LIKE '') OR (EventDetail.aps_pre_surgery_free_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_free_ng_ml NOT LIKE ''))
AND EventMaster.id NOT IN (
	SELECT DxPsaRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.aps_pre_surgery_date, EventDetail.aps_pre_surgery_date_accuracy, EventDetail.aps_pre_surgery_total_ng_ml
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.aps_pre_surgery_date IS NOT NULL AND EventDetail.aps_pre_surgery_date NOT LIKE ''
		AND ((EventDetail.aps_pre_surgery_total_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_total_ng_ml NOT LIKE '') OR (EventDetail.aps_pre_surgery_free_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_free_ng_ml NOT LIKE ''))
	) DxPsaRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy, psa_total_ngml
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_laboratory EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventMaster.event_date IS NOT NULL AND EventMaster.event_date NOT LIKE ''
		AND psa_total_ngml NOT LIKE '' AND psa_total_ngml IS NOT NULL
	) PsaRec
	WHERE DxPsaRec.participant_id = PsaRec.participant_id
	AND DxPsaRec.aps_pre_surgery_date = PsaRec.event_date
	AND DxPsaRec.aps_pre_surgery_date_accuracy = PsaRec.event_date_accuracy
	AND DxPsaRec.aps_pre_surgery_total_ng_ml = PsaRec.psa_total_ngml
));
INSERT INTO procure_ed_prostate_cancer_laboratory (psa_total_ngml, psa_free_ngml, event_master_id)
(SELECT tmp_aps_pre_surgery_total_ng_ml, tmp_aps_pre_surgery_free_ng_ml, id FROM event_masters WHERE tmp_procure_migration = '1' AND created = @modified AND created_by = @modified_by);
CREATE TABLE tmp_psa (
  event_master_id int(11), 
  aps_pre_surgery_free_ng_ml decimal(10,2));
INSERT INTO tmp_psa (event_master_id, aps_pre_surgery_free_ng_ml)
(SELECT PsaRec.event_master_id psa_to_update_event_master_id, DxPsaRec.aps_pre_surgery_free_ng_ml
FROM (
	SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.aps_pre_surgery_date, EventDetail.aps_pre_surgery_date_accuracy, EventDetail.aps_pre_surgery_total_ng_ml, aps_pre_surgery_free_ng_ml
	FROM event_masters EventMaster
	INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
	WHERE EventMaster.deleted <> 1
	AND EventDetail.aps_pre_surgery_date IS NOT NULL AND EventDetail.aps_pre_surgery_date NOT LIKE ''
	AND EventDetail.aps_pre_surgery_total_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_total_ng_ml NOT LIKE '' AND EventDetail.aps_pre_surgery_free_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_free_ng_ml NOT LIKE ''
) DxPsaRec,
(
	SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy, psa_total_ngml
	FROM event_masters EventMaster
	INNER JOIN procure_ed_prostate_cancer_laboratory EventDetail ON EventMaster.id = EventDetail.event_master_id
	WHERE EventMaster.deleted <> 1
	AND EventMaster.event_date IS NOT NULL AND EventMaster.event_date NOT LIKE ''
	AND psa_total_ngml NOT LIKE '' AND psa_total_ngml IS NOT NULL
	AND (psa_free_ngml IS NULL OR psa_free_ngml LIKE '')
) PsaRec
WHERE DxPsaRec.participant_id = PsaRec.participant_id
AND DxPsaRec.aps_pre_surgery_date = PsaRec.event_date
AND DxPsaRec.aps_pre_surgery_date_accuracy = PsaRec.event_date_accuracy
AND DxPsaRec.aps_pre_surgery_total_ng_ml = PsaRec.psa_total_ngml);
UPDATE tmp_psa TmpPsa, event_masters EventMaster, procure_ed_prostate_cancer_laboratory EventDetail
SET EventDetail.psa_free_ngml = TmpPsa.aps_pre_surgery_free_ng_ml, EventMaster.modified_by = @modified_by, EventMaster.modified = @modified, tmp_procure_migration = '2'
WHERE TmpPsa.event_master_id = EventMaster.id AND EventDetail.event_master_id = EventMaster.id;
DROP TABLE tmp_psa;
INSERT INTO event_masters_revs (id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
version_created, modified_by)
(SELECT id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
modified, modified_by 
FROM event_masters WHERE tmp_procure_migration IN ('1', '2') AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_ed_prostate_cancer_laboratory_revs (psa_total_ngml,event_master_id,biochemical_relapse,testosterone_nmoll,psa_free_ngml,version_created)
(SELECT psa_total_ngml,event_master_id,biochemical_relapse,testosterone_nmoll,psa_free_ngml,modified
FROM event_masters INNER JOIN procure_ed_prostate_cancer_laboratory ON id = event_master_id
WHERE tmp_procure_migration IN ('1', '2') AND modified = @modified AND modified_by = @modified_by);
ALTER TABLE event_masters 
  DROP COLUMN tmp_procure_migration,
  DROP COLUMN tmp_aps_pre_surgery_total_ng_ml,
  DROP COLUMN tmp_aps_pre_surgery_free_ng_ml;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_total_ng_ml' AND `language_label`='total ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_free_ng_ml' AND `language_label`='free ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_ed_prostate_cancer_diagnosis 
  CHANGE aps_pre_surgery_total_ng_ml procure_deprecated_aps_pre_surgery_total_ng_ml decimal(10,2) DEFAULT NULL,
  CHANGE aps_pre_surgery_free_ng_ml procure_deprecated_aps_pre_surgery_free_ng_ml decimal(10,2) DEFAULT NULL,
  CHANGE aps_pre_surgery_date procure_deprecated_field_aps_pre_surgery_date date DEFAULT NULL,
  CHANGE aps_pre_surgery_date_accuracy procure_deprecated_field_aps_pre_surgery_date_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE procure_ed_prostate_cancer_diagnosis_revs 
  CHANGE aps_pre_surgery_total_ng_ml procure_deprecated_aps_pre_surgery_total_ng_ml decimal(10,2) DEFAULT NULL,
  CHANGE aps_pre_surgery_free_ng_ml procure_deprecated_aps_pre_surgery_free_ng_ml decimal(10,2) DEFAULT NULL,
  CHANGE aps_pre_surgery_date procure_deprecated_field_aps_pre_surgery_date date DEFAULT NULL,
  CHANGE aps_pre_surgery_date_accuracy procure_deprecated_field_aps_pre_surgery_date_accuracy char(1) NOT NULL DEFAULT '';

-- @@@ Clinical Note @@@
--      ** Event Type : procure follow-up worksheet - clinical note => prostate cancer - clinical note
--      ** Table Name : procure_ed_followup_worksheet_clinical_notes => procure_ed_prostate_cancer_clinical_notes
--      ** Form Alias : procure_ed_followup_worksheet_clinical_notes =>  procure_ed_prostate_cancer_clinical_notes

UPDATE event_controls
SET event_type = 'prostate cancer - clinical note', 
detail_form_alias = 'procure_ed_prostate_cancer_clinical_notes', 
detail_tablename = 'procure_ed_prostate_cancer_clinical_notes'
WHERE event_type = 'procure follow-up worksheet - clinical note';
UPDATE structures SET alias = 'procure_ed_prostate_cancer_clinical_notes' WHERE alias = 'procure_ed_followup_worksheet_clinical_notes';
ALTER TABLE procure_ed_followup_worksheet_clinical_notes 
  RENAME TO procure_ed_prostate_cancer_clinical_notes;
ALTER TABLE procure_ed_followup_worksheet_clinical_notes_revs 
  RENAME TO procure_ed_prostate_cancer_clinical_notes_revs;
UPDATE structure_fields SET tablename = 'procure_ed_prostate_cancer_clinical_notes' WHERE tablename = 'procure_ed_followup_worksheet_clinical_notes';
INSERT INTO i18n (id,en,fr) 
VALUES ('prostate cancer - clinical note', 'Clinical Note', 'Note clinique');

ALTER TABLE procure_ed_prostate_cancer_clinical_notes
  ADD COLUMN type varchar(50) DEFAULT NULL;
ALTER TABLE procure_ed_prostate_cancer_clinical_notes_revs
  ADD COLUMN type varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_event_note_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Note Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Clinical Note Types', 1, 100, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Note Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('hospitalization' ,'Hospitalization', 'Hospitalization', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_prostate_cancer_clinical_notes', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_event_note_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_clinical_notes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_clinical_notes' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_event_note_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- @@@ Questionnaire @@@
--      ** Event Type : procure questionnaire administration worksheet => questionnaire
--      ** Table Name : procure_ed_lifestyle_quest_admin_worksheets => procure_ed_questionnaires
--      ** Form Alias : procure_ed_questionnaire_administration_worksheet =>  procure_ed_questionnaires

UPDATE event_controls
SET event_type = 'questionnaire', 
detail_form_alias = 'procure_ed_questionnaires', 
detail_tablename = 'procure_ed_questionnaires'
WHERE event_type = 'procure questionnaire administration worksheet';
UPDATE structures SET alias = 'procure_ed_questionnaires' WHERE alias = 'procure_ed_questionnaire_administration_worksheet';
ALTER TABLE procure_ed_lifestyle_quest_admin_worksheets 
  RENAME TO procure_ed_questionnaires;
ALTER TABLE procure_ed_lifestyle_quest_admin_worksheets_revs 
  RENAME TO procure_ed_questionnaires_revs;
UPDATE structure_fields SET tablename = 'procure_ed_questionnaires' WHERE tablename = 'procure_ed_lifestyle_quest_admin_worksheets';
INSERT INTO i18n (id,en,fr) 
VALUES ('questionnaire', 'Questionnaire', 'Questionnaire');

-- delete procure_ed_questionnaires.patient_identity_verified
ALTER TABLE procure_ed_questionnaires CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_questionnaires_revs CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_questionnaires') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_questionnaires' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_questionnaires' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_questionnaires' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- @@@ Other Tumor Diagnosis @@@
--      ** Event Type : procure follow-up worksheet - other tumor dx => other tumor diagnosis
--      ** Table Name : procure_ed_followup_worksheet_other_tumor_diagnosis => procure_ed_other_tumor_diagnosis
--      ** Form Alias : procure_ed_followup_worksheet_other_tumor_diagnosis =>  procure_ed_other_tumor_diagnosis

UPDATE event_controls
SET event_type = 'other tumor diagnosis', 
detail_form_alias = 'procure_ed_other_tumor_diagnosis', 
detail_tablename = 'procure_ed_other_tumor_diagnosis'
WHERE event_type = 'procure follow-up worksheet - other tumor dx';
UPDATE structures SET alias = 'procure_ed_other_tumor_diagnosis' WHERE alias = 'procure_ed_followup_worksheet_other_tumor_diagnosis';
ALTER TABLE procure_ed_followup_worksheet_other_tumor_diagnosis 
  RENAME TO procure_ed_other_tumor_diagnosis;
ALTER TABLE procure_ed_followup_worksheet_other_tumor_diagnosis_revs 
  RENAME TO procure_ed_other_tumor_diagnosis_revs;
UPDATE structure_fields SET tablename = 'procure_ed_other_tumor_diagnosis' WHERE tablename = 'procure_ed_followup_worksheet_other_tumor_diagnosis';
INSERT INTO i18n (id,en,fr) 
VALUES ('other tumor diagnosis', 'Other tumor - Diagnosis', 'Autre tumeur - Diagnostic');

-- @@@ Pathology report @@@

REPLACE INTO i18n (id,en,fr) VALUES ('procure pathology report', 'Prostate - Pathology (Surgery)', 'Prostate - Pathologie (Chirurgie)');

-- Treatment
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);

-- delete event_masters.procure_form_identification

ALTER TABLE treatment_masters CHANGE procure_form_identification procure_deprecated_field_procure_form_identification VARCHAR(50) DEFAULT NULL;
ALTER TABLE treatment_masters_revs CHANGE procure_form_identification procure_deprecated_field_procure_form_identification VARCHAR(50) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `language_label`='treatment form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `language_label`='treatment form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `language_label`='treatment form identification' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Help message linked to drugs fields (study field)

UPDATE structure_fields 
SET `language_help`='procure_help_drug_study'
WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='procure_study' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0';
INSERT INTO i18n (id,en,fr)
VALUES
('procure_help_drug_study', 
"For any experimental treatment or clinical study that you could classify with another type (ex: chemotherapy, hormonal therapy) than the generic type 'experimental treatment'. This will be more informative.", 
'Pour tout traitement expérimental ou étude clinique que vous pourriez classer avec un autre type (ex: chimiothérapie, hormonothérapie) que le type générique «traitement expérimental». Ce sera plus instructif.');

-- Move drug_id field from procure_txd_followup_worksheet_treatments table to treatment_masters table

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name'), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_drug_list') AND `language_help`='procure_help_treatment_drug' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_drug_list') AND `language_help`='procure_help_treatment_drug' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_drug_list') AND `language_help`='procure_help_treatment_drug' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' );

ALTER TABLE treatment_masters ADD COLUMN procure_drug_id INT(11) DEFAULT NULL;
ALTER TABLE treatment_masters_revs ADD COLUMN procure_drug_id INT(11) DEFAULT NULL;
ALTER TABLE treatment_masters
  ADD CONSTRAINT `FK_procure_tx_drugs` FOREIGN KEY (`procure_drug_id`) REFERENCES `drugs` (`id`);
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.procure_drug_id = TreatmentDetail.drug_id, modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1 
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.drug_id IS NOT NULL 
AND TreatmentDetail.drug_id NOT LIKE '';
ALTER TABLE procure_txd_followup_worksheet_treatments DROP FOREIGN KEY `FK_procure_txd_followup_worksheet_treatments_drugs`;
ALTER TABLE procure_txd_followup_worksheet_treatments CHANGE drug_id procure_deprecated_field_drug_id INT(11) DEFAULT NULL;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs CHANGE drug_id procure_deprecated_field_drug_id INT(11) DEFAULT NULL;

-- Add duration to treatment

ALTER TABLE procure_txd_followup_worksheet_treatments
  ADD COLUMN duration VARCHAR(50) DEFAULT NULL;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs
  ADD COLUMN duration VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'duration', 'input',  NULL , '0', '', '', '', 'duration', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='duration' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='duration' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_fields SET  `setting`='size=15' WHERE model='TreatmentDetail' AND tablename='procure_txd_followup_worksheet_treatments' AND field IN ('duration', 'dosage');

-- Move medication form to treatment form

INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('prostate','prostate medication'),
('other diseases','other diseases medication'),
('open sale','open sale medication');
UPDATE structure_value_domains_permissible_values
SET structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='prostate' AND language_alias='prostate medication')
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='prostate' AND language_alias='prostate')
AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type");
UPDATE structure_value_domains_permissible_values
SET structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='other diseases' AND language_alias='other diseases medication')
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='other diseases' AND language_alias='other diseases')
AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type");
UPDATE structure_value_domains_permissible_values
SET structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='open sale' AND language_alias='open sale medication')
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='open sale' AND language_alias='open sale')
AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('prostate medication','Prostate medication', 'Médicament pour prostate'),
('other diseases medication','Other diseases medication', 'Médicament pour autre maladie'),
('open sale medication','Open sale medication', 'Médicament en vente libre');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('prostate medication','prostate medication'),
('other diseases medication','other diseases medication'),
('open sale medication','open sale medication');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types"), 
(SELECT id FROM structure_permissible_values WHERE value='prostate medication' AND language_alias='prostate medication'), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types"), 
(SELECT id FROM structure_permissible_values WHERE value='other diseases medication' AND language_alias='other diseases medication'), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types"), 
(SELECT id FROM structure_permissible_values WHERE value='open sale medication' AND language_alias='open sale medication'), "1", "1");

SET @control_id = (SELECT id from treatment_controls WHERE tx_method = 'procure follow-up worksheet - treatment');
SET @old_control_id = (SELECT id from treatment_controls WHERE tx_method = 'procure medication worksheet - drug');
UPDATE treatment_masters SET treatment_control_id = @control_id, modified = @modified, modified_by = @modified_by WHERE treatment_control_id = @old_control_id;
UPDATE treatment_masters_revs SET treatment_control_id = @control_id WHERE treatment_control_id = @old_control_id;
INSERT INTO procure_txd_followup_worksheet_treatments (dosage, duration, procure_deprecated_field_drug_id, treatment_master_id)
(SELECT dose, duration, drug_id, treatment_master_id FROM procure_txd_medication_drugs);
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.procure_drug_id = TreatmentDetail.procure_deprecated_field_drug_id
WHERE TreatmentMaster.deleted <> 1 
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.procure_deprecated_field_drug_id IS NOT NULL 
AND TreatmentDetail.procure_deprecated_field_drug_id NOT LIKE ''
AND modified = @modified AND modified_by = @modified_by
AND id IN (SELECT treatment_master_id FROM procure_txd_medication_drugs);
INSERT INTO procure_txd_followup_worksheet_treatments_revs (dosage, duration, procure_deprecated_field_drug_id, treatment_master_id,version_created)
(SELECT dose,duration,drug_id,treatment_master_id,version_created FROM procure_txd_medication_drugs_revs ORDER BY version_id ASC);
ALTER TABLE procure_txd_medication_drugs_revs RENAME procure_deprecated_table_txd_medication_drugs_revs;
ALTER TABLE procure_txd_medication_drugs RENAME procure_deprecated_table_txd_medication_drugs;
UPDATE treatment_controls SET flag_active = 0 WHERE tx_method = 'procure medication worksheet - drug';
UPDATE procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug
SET TreatmentDetail.treatment_type = CONCAT(Drug.type, ' medication')
WHERE procure_deprecated_field_drug_id = Drug.id
AND treatment_master_id IN (SELECT treatment_master_id FROM procure_deprecated_table_txd_medication_drugs_revs);
UPDATE structure_value_domains_permissible_values
SET structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='open sale medication' AND language_alias='open sale medication')
WHERE structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='open sale')
AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type");
UPDATE structure_value_domains_permissible_values
SET structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='other diseases medication' AND language_alias='other diseases medication')
WHERE structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='other diseases')
AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type");
UPDATE structure_value_domains_permissible_values
SET structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value='prostate medication' AND language_alias='prostate medication')
WHERE structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='prostate')
AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type");
UPDATE drugs SET type = CONCAT(type, ' medication') WHERE type in ('open sale', 'prostate', 'other disease');

-- Rename Follow-up treatment

UPDATE treatment_controls SET tx_method = 'treatment', detail_tablename = 'procure_txd_treatments', detail_form_alias = 'procure_txd_treatments' WHERE tx_method = 'procure follow-up worksheet - treatment';
ALTER TABLE procure_txd_followup_worksheet_treatments RENAME TO procure_txd_treatments;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs RENAME TO procure_txd_treatments_revs;
UPDATE structure_fields SET tablename = 'procure_txd_treatments' WHERE tablename = 'procure_txd_followup_worksheet_treatments';
UPDATE structures SET alias = 'procure_txd_treatments' WHERE alias = 'procure_txd_followup_worksheet_treatment';

-- Surgery type + add surgery to treatment type

ALTER TABLE procure_txd_treatments ADD COLUMN surgery_type VARCHAR(100) DEFAULT NULL;
ALTER TABLE procure_txd_treatments_revs ADD COLUMN surgery_type VARCHAR(100) DEFAULT NULL;

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_surgery_type", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Surgery Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Surgery Types', 1, 100, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgery Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('transurethral resection of prostate' ,'Transurethral resection of prostate', 'Résection transurethral de la prostate', '1', @control_id),
('transurethral resection of bladder lesion' ,'Transurethral resection of bladder lesion', 'Résection transurethral des lésions de la vessie', '1', @control_id),
('cystoscopy double J placement' ,'Cystoscopy double J placement', '', '1', @control_id),
('radical cystoprostatectomy', 'Radical cystoprostatectomy', 'Cysto-prostatectomie radicale', '1', @control_id),
('prostatectomy', 'Prostatectomy', 'Prostatectomie', '1', @control_id),
('prostatectomy aborted', 'Prostatectomy (Aborted)', 'Prostatectomie (Abandonnée)', '1', @control_id),
('prostatic hyperplasia surgery', 'Prostatic Hyperplasia surgery', 'Chirurgie de l''hyperplasie prostatique', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_treatments', 'surgery_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_surgery_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='surgery_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_surgery_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '4', 'surgery precision', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('surgery','surgery');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types"), 
(SELECT id FROM structure_permissible_values WHERE value='surgery' AND language_alias='surgery'), "1", "1");

-- Add site to radiotherapy sites and rename to treatment site

UPDATE structure_permissible_values_custom_controls SET name = 'Treatment Sites' WHERE name = 'Radiotherapy Sites';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Sites\')' WHERE domain_name = 'procure_treatment_site';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Sites');
SELECT `value` AS 'Custom value of Treatment Site not supported by procure. To clean up.' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value != 'prostate bed';
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
(SELECT DISTINCT lower(`en_sub_title`), `en_sub_title`, `fr_sub_title`, '1', @control_id FROM `coding_icd_o_3_topography` WHERE en_sub_title != 'unknown primary site');

-- Remove prostatectomy from treatment type

UPDATE treatment_masters, procure_txd_treatments
SET treatment_type = 'surgery', surgery_type = 'prostatectomy aborted', treatment_site = 'prostate gland', modified = @modified, modified_by = @modified_by
WHERE deleted <> 1 
AND id = treatment_master_id
AND treatment_type = 'aborted prostatectomy';
UPDATE treatment_masters, procure_txd_treatments
SET treatment_type = 'surgery', surgery_type = 'prostatectomy', treatment_site = 'prostate gland', modified = @modified, modified_by = @modified_by
WHERE deleted <> 1 
AND id = treatment_master_id
AND treatment_type = 'prostatectomy';
DELETE FROM structure_value_domains_permissible_values
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types")
AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value LIKE '%prostatectomy%');

-- Move other tumor treatment to treatment

UPDATE treatment_masters, procure_txd_followup_worksheet_other_tumor_treatments
SET modified = @modified, 
modified_by = @modified_by,
notes = CONCAT(notes, " Treatment of '", SUBSTRING(tumor_site FROM (POSITION(" - " IN tumor_site) + 3)), "' other tumor'")
WHERE id = treatment_master_id 
AND deleted <>1 
AND notes IS NOT NULL;
UPDATE treatment_masters, procure_txd_followup_worksheet_other_tumor_treatments
SET modified = @modified, 
modified_by = @modified_by,
notes = CONCAT(" Treatment of '", SUBSTRING(tumor_site FROM (POSITION(" - " IN tumor_site) + 3)), "' other tumor'")
WHERE id = treatment_master_id 
AND deleted <>1 
AND notes IS NULL;
SET @control_id = (SELECT id from treatment_controls WHERE tx_method = 'treatment');
SET @old_control_id = (SELECT id from treatment_controls WHERE tx_method = 'procure follow-up worksheet - other tumor tx');
UPDATE treatment_masters
SET modified = @modified, 
modified_by = @modified_by,
treatment_control_id = @control_id
WHERE treatment_control_id = @old_control_id;
UPDATE treatment_masters_revs
SET treatment_control_id = @control_id
WHERE treatment_control_id = @old_control_id;
INSERT INTO procure_txd_treatments (treatment_master_id, treatment_type)
(SELECT treatment_master_id, treatment_type
FROM treatment_masters 
INNER JOIN procure_txd_followup_worksheet_other_tumor_treatments ON id = treatment_master_id);
INSERT INTO procure_txd_treatments_revs (treatment_type, treatment_master_id,version_created)
(SELECT REPLACE(treatment_type, 'other', 'other treatment'),treatment_master_id,version_created FROM procure_txd_followup_worksheet_other_tumor_treatments_revs ORDER BY version_id ASC);
UPDATE treatment_controls SET flag_active = 0 WHERE tx_method = 'procure follow-up worksheet - other tumor tx';
ALTER TABLE procure_txd_followup_worksheet_other_tumor_treatments RENAME TO procure_deprecated_table_txd_fw_other_tumor_treatments;
ALTER TABLE procure_txd_followup_worksheet_other_tumor_treatments_revs RENAME TO procure_deprecated_table_txd_fw_other_tumor_treatments_revs;
UPDATE procure_txd_treatments SET treatment_type = 'other treatment' WHERE treatment_type = 'other';

-- revs table

INSERT INTO treatment_masters_revs (id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
version_created, modified_by)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
modified, modified_by FROM treatment_masters WHERE modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_treatments_revs (treatment_type, dosage, treatment_master_id, procure_deprecated_field_drug_id, treatment_site, treatment_precision, treatment_combination, treatment_line, duration, surgery_type, version_created)
(SELECT treatment_type, dosage, treatment_master_id, procure_deprecated_field_drug_id, treatment_site, treatment_precision, treatment_combination, treatment_line, duration, surgery_type, modified
FROM treatment_masters INNEr JOIN procure_txd_treatments ON id= treatment_master_id
WHERE modified = @modified AND modified_by = @modified_by);

-- Treatment control

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('field [%s] can only be completed for following treatment(s) : %s',
'Field [%s] can only be completed for following treatment(s) : %s',
'Le champ[%s] peut être saisi uniquement pour le(s) traitement(s) suivant(s): %s');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_surgery_type') ,  `language_label`='surgery detail' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='surgery_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_surgery_type');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='surgery_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_surgery_type') AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES ('surgery detail', 'Surgery Detail', 'Détails de la chirurgie');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_site') ,  `language_help`='' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='treatment_site' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_site');

-- Follow-up worksheet
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE event_controls
SET event_type = 'visit/contact', 
detail_form_alias = 'procure_ed_visits', 
detail_tablename = 'procure_ed_visits'
WHERE event_type = 'procure follow-up worksheet';
UPDATE structures SET alias = 'procure_ed_visits' WHERE alias = 'procure_ed_followup_worksheet';
ALTER TABLE procure_ed_clinical_followup_worksheets 
  RENAME TO procure_ed_visits;
ALTER TABLE procure_ed_clinical_followup_worksheets_revs 
  RENAME TO procure_ed_visits_revs;
UPDATE structure_fields SET tablename = 'procure_ed_visits' WHERE tablename = 'procure_ed_clinical_followup_worksheets';
INSERT INTO i18n (id,en,fr) 
VALUES ('visit/contact', 'Visit / Contact', 'Visite / Contact');

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Patient confirmation

ALTER TABLE procure_ed_visits CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_visits_revs CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Biochemical Recurrence

SELECT DISTINCT Participant.participant_identifier AS 'Participant with BCR defined but no BCR exists iton ATiM (see laboratory records). To correct.'
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE biochemical_recurrence ='y' AND EventMaster.deleted <> 1
AND Participant.id NOT IN (
	SELECT participant_id FROM event_masters INNER JOIN procure_ed_prostate_cancer_laboratory ON id = event_master_id WHERE deleted <> 1 AND biochemical_relapse = 'y'
);
ALTER TABLE procure_ed_visits CHANGE biochemical_recurrence procure_deprecated_field_biochemical_recurrence CHAR(1) DEFAULT '';
ALTER TABLE procure_ed_visits_revs CHANGE biochemical_recurrence procure_deprecated_field_biochemical_recurrence CHAR(1) DEFAULT '';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='biochemical_recurrence' AND `language_label`='biochemical recurrence >= 0.2ng/ml' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='biochemical_recurrence' AND `language_label`='biochemical recurrence >= 0.2ng/ml' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='biochemical_recurrence' AND `language_label`='biochemical recurrence >= 0.2ng/ml' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Surgery for métastases

SELECT DISTINCT surgery_site 'Surgery Sites for metastases - Check if something could be migrated into field TreatmentMaster.treatment_site'
FROM event_masters EventMaster
INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE EventMaster.deleted <> 1 AND surgery_site IS NOt NULL AND surgery_site NOT LIKE '';

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
SET @tx_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'treatment');

INSERT INTO treatment_masters (treatment_control_id, start_date, start_date_accuracy, 
notes, 
participant_id, procure_created_by_bank, created, created_by, modified, modified_by)
(SELECT DISTINCT @tx_control_id, surgery_date, surgery_date_accuracy, 
CONCAT("Surgery for Metastases. Site '", IFNULL(IF(surgery_site = '', null, surgery_site), 'unknown'),"'. (Created by migration process from 'Visit/Contact' form based on 'Surgery for Metastases' field)."),
participant_id, procure_created_by_bank, @modified, @modified_by, @modified, @modified_by 
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND (surgery_for_metastases = 'y' OR (surgery_date IS NOT NULL AND surgery_date NOT LIKE '')));
INSERT INTO procure_txd_treatments (treatment_master_id, treatment_type)
(SELECT id, 'surgery' 
FROM treatment_masters  
WHERE treatment_control_id = @tx_control_id AND created = @modified AND created_by = @modified_by AND notes LIKE "%Created by migration process from 'Visit/Contact' form based on 'Surgery for Metastases' field%");
INSERT INTO treatment_masters_revs (id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
version_created, modified_by)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
modified, modified_by FROM treatment_masters WHERE created = @modified AND created_by = @modified_by AND notes LIKE "%Created by migration process from 'Visit/Contact' form based on 'Surgery for Metastases' field%");
INSERT INTO procure_txd_treatments_revs (treatment_type, dosage, treatment_master_id, procure_deprecated_field_drug_id, treatment_site, treatment_precision, treatment_combination, treatment_line, duration, surgery_type, version_created)
(SELECT treatment_type, dosage, treatment_master_id, procure_deprecated_field_drug_id, treatment_site, treatment_precision, treatment_combination, treatment_line, duration, surgery_type, modified
FROM treatment_masters INNEr JOIN procure_txd_treatments ON id= treatment_master_id
WHERE created = @modified AND created_by = @modified_by AND notes LIKE "%Created by migration process from 'Visit/Contact' form based on 'Surgery for Metastases' field%");
SELECT DISTINCT Participant.participant_identifier AS "Participant with site of surgery for metastases but no date and no field 'Sugery for Metastases' set to yes. No data will be migrated. To correct.", surgery_site
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE EventMaster.deleted <> 1 AND surgery_for_metastases != 'y' AND (surgery_date IS NULL OR surgery_date LIKE '') 
AND surgery_site IS NOt NULL AND surgery_site NOT LIKE '';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_for_metastases' AND `language_label`='surgery for metastases' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_site' AND `language_label`='site' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_for_metastases' AND `language_label`='surgery for metastases' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_site' AND `language_label`='site' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_for_metastases' AND `language_label`='surgery for metastases' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_site' AND `language_label`='site' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='surgery_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_ed_visits
   CHANGE surgery_for_metastases procure_deprecated_field_surgery_for_metastases char(1) DEFAULT '',
   CHANGE surgery_site procure_deprecated_field_surgery_site varchar(250) DEFAULT NULL,
   CHANGE surgery_date procure_deprecated_field_surgery_date date DEFAULT NULL;
ALTER TABLE procure_ed_visits_revs
   CHANGE surgery_for_metastases procure_deprecated_field_surgery_for_metastases char(1) DEFAULT '',
   CHANGE surgery_site procure_deprecated_field_surgery_site varchar(250) DEFAULT NULL,
   CHANGE surgery_date procure_deprecated_field_surgery_date date DEFAULT NULL;

-- Progression

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
SET @ev_control_id = (SELECT id FROM event_controls WHERE event_type = 'prostate cancer - clinical exam');
ALTER TABLE event_masters ADD COLUMN tmp_progression varchar(250);
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'bone metastases', @ev_control_id, participant_id,
"Created by migration process from 'Visit/Contact' form based on 'Clinical Recurrence' field.", 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_bones = '1');
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'liver metastases', @ev_control_id, participant_id,
"Created by migration process from 'Visit/Contact' form based on 'Clinical Recurrence' field.", 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_liver = '1');
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'lung metastases', @ev_control_id, participant_id,
"Created by migration process from 'Visit/Contact' form based on 'Clinical Recurrence' field.", 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_lungs = '1');
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'pelvic lymph nodes', @ev_control_id, participant_id,
"Regional tumor progression. Created by migration process from 'Visit/Contact' form based on 'Clinical Recurrence' field.", 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence_type = 'regional');
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'local tumor progression', @ev_control_id, participant_id,
"Local tumor progression. Created by migration process from 'Visit/Contact' form based on 'Clinical Recurrence' field.", 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence_type = 'local');
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'progressions comorbidity to define', @ev_control_id, participant_id,
"Metastasis undefined. Created by migration process from 'Visit/Contact' form based on 'Clinical Recurrence' field.", 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND (clinical_recurrence_site_others = '1' 
OR (clinical_recurrence_type = 'distant' AND clinical_recurrence_site_bones = '0' AND clinical_recurrence_site_liver = '0' AND clinical_recurrence_site_lungs = '0')));
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'progressions comorbidity to define', @ev_control_id, participant_id,
"Recurrence undefined. Created by migration process from 'Visit/Contact' form based on 'Clinical Recurrence' field.", 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence = 'y'
AND (clinical_recurrence_type = '' OR clinical_recurrence_type IS NULL)
AND clinical_recurrence_site_bones = '0' AND clinical_recurrence_site_liver = '0' AND clinical_recurrence_site_lungs = '0' AND clinical_recurrence_site_others = '0');
INSERT INTO procure_ed_prostate_cancer_clinical_exams (`event_master_id`, `type`, `results`, `progression_comorbidity`)
(SELECT id, 'clinical exam to define', 'positive', tmp_progression FROM event_masters 
WHERE event_control_id = @ev_control_id AND tmp_progression IS NOT NULL AND tmp_progression NOT LIKE '' AND created = @modified);
INSERT INTO event_masters_revs (id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
version_created, modified_by)
(SELECT id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
modified, modified_by 
FROM event_masters WHERE event_control_id = @ev_control_id AND tmp_progression IS NOT NULL AND tmp_progression NOT LIKE '' AND created = @modified);
INSERT INTO procure_ed_prostate_cancer_clinical_exams_revs (type, event_master_id, results, type_precision, progression_comorbidity, version_created)
(SELECT type, event_master_id, results, type_precision, progression_comorbidity, modified
FROM event_masters INNER JOIN procure_ed_prostate_cancer_clinical_exams ON id = event_master_id
WHERE event_control_id = @ev_control_id AND tmp_progression IS NOT NULL AND tmp_progression NOT LIKE '' AND created = @modified);
ALTER TABLE event_masters DROP COLUMN tmp_progression;
ALTER TABLE procure_ed_visits
  CHANGE clinical_recurrence procure_deprecated_field_clinical_recurrence char(1) DEFAULT '',
  CHANGE clinical_recurrence_type procure_deprecated_field_clinical_recurrence_type varchar(50),
  CHANGE clinical_recurrence_site_bones procure_deprecated_field_clinical_recurrence_site_bones tinyint(1) DEFAULT '0',
  CHANGE clinical_recurrence_site_liver procure_deprecated_field_clinical_recurrence_site_liver tinyint(1) DEFAULT '0',
  CHANGE clinical_recurrence_site_lungs procure_deprecated_field_clinical_recurrence_site_lungs tinyint(1) DEFAULT '0',
  CHANGE clinical_recurrence_site_others procure_deprecated_field_clinical_recurrence_site_others tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_visits_revs
  CHANGE clinical_recurrence procure_deprecated_field_clinical_recurrence char(1) DEFAULT '',
  CHANGE clinical_recurrence_type procure_deprecated_field_clinical_recurrence_type varchar(50),
  CHANGE clinical_recurrence_site_bones procure_deprecated_field_clinical_recurrence_site_bones tinyint(1) DEFAULT '0',
  CHANGE clinical_recurrence_site_liver procure_deprecated_field_clinical_recurrence_site_liver tinyint(1) DEFAULT '0',
  CHANGE clinical_recurrence_site_lungs procure_deprecated_field_clinical_recurrence_site_lungs tinyint(1) DEFAULT '0',
  CHANGE clinical_recurrence_site_others procure_deprecated_field_clinical_recurrence_site_others tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence' AND `language_label`='clinical recurrence' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_types') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_bones' AND `language_label`='bone metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_liver' AND `language_label`='liver metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_lungs' AND `language_label`='lung metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_others' AND `language_label`='other metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence' AND `language_label`='clinical recurrence' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_types') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_bones' AND `language_label`='bone metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_liver' AND `language_label`='liver metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_lungs' AND `language_label`='lung metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_others' AND `language_label`='other metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence' AND `language_label`='clinical recurrence' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_types') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_bones' AND `language_label`='bone metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_liver' AND `language_label`='liver metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_lungs' AND `language_label`='lung metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='clinical_recurrence_site_others' AND `language_label`='other metastasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

 -- Rename controls, detail_form_alias AND detail_tablename
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
UPDATE event_controls
SET event_type = 'laboratory', 
detail_form_alias = 'procure_ed_laboratories', 
detail_tablename = 'procure_ed_laboratories'
WHERE event_type = 'prostate cancer - laboratory';
UPDATE structures SET alias = 'procure_ed_laboratories' WHERE alias = 'procure_ed_prostate_cancer_laboratory';
ALTER TABLE procure_ed_prostate_cancer_laboratory 
  RENAME TO procure_ed_laboratories;
ALTER TABLE procure_ed_prostate_cancer_laboratory_revs 
  RENAME TO procure_ed_laboratories_revs;
UPDATE structure_fields SET tablename = 'procure_ed_laboratories' WHERE tablename = 'procure_ed_prostate_cancer_laboratory';
INSERT IGNORE INTO i18n (id,en,fr)  VALUES ('laboratory', 'Laboratory', 'Laboratoire');

UPDATE event_controls
SET event_type = 'clinical exam', 
detail_form_alias = 'procure_ed_clinical_exams', 
detail_tablename = 'procure_ed_clinical_exams'
WHERE event_type = 'prostate cancer - clinical exam';
UPDATE structures SET alias = 'procure_ed_clinical_exams' WHERE alias = 'procure_ed_prostate_cancer_clinical_exams';
ALTER TABLE procure_ed_prostate_cancer_clinical_exams 
  RENAME TO procure_ed_clinical_exams;
ALTER TABLE procure_ed_prostate_cancer_clinical_exams_revs 
  RENAME TO procure_ed_clinical_exams_revs;
UPDATE structure_fields SET tablename = 'procure_ed_clinical_exams' WHERE tablename = 'procure_ed_prostate_cancer_clinical_exams';
INSERT IGNORE INTO i18n (id,en,fr)  VALUES ('clinical exam', 'Clinical Exam', 'Examen clinique');

UPDATE event_controls
SET event_type = 'clinical note', 
detail_form_alias = 'procure_ed_clinical_notes', 
detail_tablename = 'procure_ed_clinical_notes'
WHERE event_type = 'prostate cancer - clinical note';
UPDATE structures SET alias = 'procure_ed_clinical_notes' WHERE alias = 'procure_ed_prostate_cancer_clinical_notes';
ALTER TABLE procure_ed_prostate_cancer_clinical_notes 
  RENAME TO procure_ed_clinical_notes;
ALTER TABLE procure_ed_prostate_cancer_clinical_notes_revs 
  RENAME TO procure_ed_clinical_notes_revs;
UPDATE structure_fields SET tablename = 'procure_ed_clinical_notes' WHERE tablename = 'procure_ed_prostate_cancer_clinical_notes';
INSERT IGNORE INTO i18n (id,en,fr)  VALUES ('clinical note', 'Clinical Note', 'Note clinique');

-- procure medication worksheet
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--  to visit

UPDATE structure_formats SET `display_order`='110' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='100' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='refusing_treatments' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'medication_for_prostate_cancer', 'yes_no',  NULL , '0', '', '', '', 'medication for prostate cancer', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'medication_for_benign_prostatic_hyperplasia', 'yes_no',  NULL , '0', '', '', '', 'medication for benign prostatic hyperplasia', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'medication_for_prostatitis', 'yes_no',  NULL , '0', '', '', '', 'medication for prostatitis', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'prescribed_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'prescribed drugs for other diseases', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'list_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'list of drugs for other diseases', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'photocopy_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'photocopy of drugs for other diseases', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'dosages_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'dosages of drugs for other diseases', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_visits', 'open_sale_drugs', 'yes_no',  NULL , '0', '', '', '', 'open sale drugs', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='medication_for_prostate_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for prostate cancer' AND `language_tag`=''), '1', '30', 'prostate medication', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='medication_for_benign_prostatic_hyperplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for benign prostatic hyperplasia' AND `language_tag`=''), '1', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='medication_for_prostatitis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for prostatitis' AND `language_tag`=''), '1', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='prescribed_drugs_for_other_diseases' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prescribed drugs for other diseases' AND `language_tag`=''), '2', '51', 'prescribed medication for other diseases', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='list_of_drugs_for_other_diseases' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='list of drugs for other diseases' AND `language_tag`=''), '2', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='photocopy_of_drugs_for_other_diseases' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='photocopy of drugs for other diseases' AND `language_tag`=''), '2', '53', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='dosages_of_drugs_for_other_diseases' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dosages of drugs for other diseases' AND `language_tag`=''), '2', '54', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_visits'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='open_sale_drugs' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='open sale drugs' AND `language_tag`=''), '2', '60', 'medications and supplements on open sale', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='prescribed_drugs_for_other_diseases' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='list_of_drugs_for_other_diseases' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='photocopy_of_drugs_for_other_diseases' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='dosages_of_drugs_for_other_diseases' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE procure_ed_visits 
   ADD COLUMN `medication_for_prostate_cancer` char(1) DEFAULT '',
   ADD COLUMN `medication_for_benign_prostatic_hyperplasia` char(1) DEFAULT '',
   ADD COLUMN `medication_for_prostatitis` char(1) DEFAULT '',
   ADD COLUMN `prescribed_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `list_of_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `photocopy_of_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `dosages_of_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `open_sale_drugs` char(1) DEFAULT '';
ALTER TABLE procure_ed_visits_revs
   ADD COLUMN `medication_for_prostate_cancer` char(1) DEFAULT '',
   ADD COLUMN `medication_for_benign_prostatic_hyperplasia` char(1) DEFAULT '',
   ADD COLUMN `medication_for_prostatitis` char(1) DEFAULT '',
   ADD COLUMN `prescribed_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `list_of_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `photocopy_of_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `dosages_of_drugs_for_other_diseases` char(1) DEFAULT '',
   ADD COLUMN `open_sale_drugs` char(1) DEFAULT '';
UPDATE treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
SET TreatmentMaster.notes = CONCAT("Medication information migrated from 'F1a - Medication Worksheet'. ", notes)
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.notes IS NOT NULL;
UPDATE treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
SET TreatmentMaster.notes = "Medication information migrated from 'F1a - Medication Worksheet'."
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.notes IS NULL;

ALTER TABLE event_masters ADD COLUMN tmp_migrated_id int(11) DEFAULT NULL;
ALTER TABLE treatment_masters ADD COLUMN tmp_migrated_id int(11) DEFAULT NULL;
SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
SET @ev_control_id = (SELECT id FROM event_controls WHERE event_type = 'visit/contact');

UPDATE treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail, event_masters EventMaster, procure_ed_visits EventDetail
SET EventMaster.modified = @modified,
EventMaster.modified_by = @modified_by,
EventMaster.tmp_migrated_id = '-1',
TreatmentMaster.tmp_migrated_id = '-1',
EventMaster.event_summary = CONCAT(TreatmentMaster.notes, ' ', EventMaster.event_summary),
EventDetail.medication_for_prostate_cancer = TreatmentDetail.medication_for_prostate_cancer,
EventDetail.medication_for_benign_prostatic_hyperplasia = TreatmentDetail.medication_for_benign_prostatic_hyperplasia,
EventDetail.medication_for_prostatitis = TreatmentDetail.medication_for_prostatitis,
EventDetail.prescribed_drugs_for_other_diseases = TreatmentDetail.prescribed_drugs_for_other_diseases,
EventDetail.list_of_drugs_for_other_diseases = TreatmentDetail.list_of_drugs_for_other_diseases,
EventDetail.photocopy_of_drugs_for_other_diseases = TreatmentDetail.photocopy_of_drugs_for_other_diseases,
EventDetail.dosages_of_drugs_for_other_diseases = TreatmentDetail.dosages_of_drugs_for_other_diseases,
EventDetail.open_sale_drugs = TreatmentDetail.open_sale_drugs
WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND EventMaster.deleted <> 1 AND EventMaster.id = EventDetail.event_master_id
AND TreatmentMaster.participant_id = EventMaster.participant_id
AND TreatmentMaster.start_date = EventMaster.event_date
AND TreatmentMaster.start_date_accuracy = EventMaster.event_date_accuracy
AND EventMaster.event_summary IS NOT NULL;
UPDATE treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail, event_masters EventMaster, procure_ed_visits EventDetail
SET EventMaster.modified = @modified,
EventMaster.modified_by = @modified_by,
EventMaster.tmp_migrated_id = '-1',
TreatmentMaster.tmp_migrated_id = '-1',
EventMaster.event_summary = TreatmentMaster.notes,
EventDetail.medication_for_prostate_cancer = TreatmentDetail.medication_for_prostate_cancer,
EventDetail.medication_for_benign_prostatic_hyperplasia = TreatmentDetail.medication_for_benign_prostatic_hyperplasia,
EventDetail.medication_for_prostatitis = TreatmentDetail.medication_for_prostatitis,
EventDetail.prescribed_drugs_for_other_diseases = TreatmentDetail.prescribed_drugs_for_other_diseases,
EventDetail.list_of_drugs_for_other_diseases = TreatmentDetail.list_of_drugs_for_other_diseases,
EventDetail.photocopy_of_drugs_for_other_diseases = TreatmentDetail.photocopy_of_drugs_for_other_diseases,
EventDetail.dosages_of_drugs_for_other_diseases = TreatmentDetail.dosages_of_drugs_for_other_diseases,
EventDetail.open_sale_drugs = TreatmentDetail.open_sale_drugs
WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND EventMaster.deleted <> 1 AND EventMaster.id = EventDetail.event_master_id
AND TreatmentMaster.participant_id = EventMaster.participant_id
AND TreatmentMaster.start_date = EventMaster.event_date
AND TreatmentMaster.start_date_accuracy = EventMaster.event_date_accuracy
AND EventMaster.event_summary IS NULL;
INSERT INTO event_masters (participant_id, event_control_id, event_date, event_date_accuracy, procure_created_by_bank, event_summary, 
modified, created, created_by, modified_by, tmp_migrated_id) 
(SELECT TreatmentMaster.participant_id, @ev_control_id, TreatmentMaster.start_date, TreatmentMaster.start_date_accuracy, procure_created_by_bank, TreatmentMaster.notes,
@modified, @modified, @modified_by, @modified_by, TreatmentMaster.id
FROM treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.tmp_migrated_id IS NULL);
INSERT INTO procure_ed_visits (event_master_id, medication_for_prostate_cancer, medication_for_benign_prostatic_hyperplasia, medication_for_prostatitis, prescribed_drugs_for_other_diseases,
list_of_drugs_for_other_diseases, photocopy_of_drugs_for_other_diseases, dosages_of_drugs_for_other_diseases, open_sale_drugs)
(SELECT EventMaster.id, medication_for_prostate_cancer, medication_for_benign_prostatic_hyperplasia, medication_for_prostatitis, prescribed_drugs_for_other_diseases,
list_of_drugs_for_other_diseases, photocopy_of_drugs_for_other_diseases, dosages_of_drugs_for_other_diseases, open_sale_drugs
FROM treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail, event_masters EventMaster
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.id = EventMaster.tmp_migrated_id 
AND EventMaster.tmp_migrated_id IS NOT NULL AND EventMaster.tmp_migrated_id != '-1');
INSERT INTO event_masters_revs (id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
version_created, modified_by)
(SELECT id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, 
date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, 
modified, modified_by 
FROM event_masters WHERE tmp_migrated_id IS NOT NULL AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_ed_visits_revs (procure_deprecated_field_patient_identity_verified, procure_deprecated_field_biochemical_recurrence, procure_deprecated_field_clinical_recurrence, procure_deprecated_field_clinical_recurrence_type, 
procure_deprecated_field_surgery_for_metastases, procure_deprecated_field_surgery_site, procure_deprecated_field_surgery_date, surgery_date_accuracy, event_master_id, procure_deprecated_field_clinical_recurrence_site_bones, 
procure_deprecated_field_clinical_recurrence_site_liver, procure_deprecated_field_clinical_recurrence_site_lungs, procure_deprecated_field_clinical_recurrence_site_others, refusing_treatments, method, 
medication_for_prostate_cancer, medication_for_benign_prostatic_hyperplasia, medication_for_prostatitis, prescribed_drugs_for_other_diseases, list_of_drugs_for_other_diseases, photocopy_of_drugs_for_other_diseases, 
dosages_of_drugs_for_other_diseases, open_sale_drugs, version_created)
(SELECT procure_deprecated_field_patient_identity_verified, procure_deprecated_field_biochemical_recurrence, procure_deprecated_field_clinical_recurrence, procure_deprecated_field_clinical_recurrence_type, 
procure_deprecated_field_surgery_for_metastases, procure_deprecated_field_surgery_site, procure_deprecated_field_surgery_date, surgery_date_accuracy, event_master_id, procure_deprecated_field_clinical_recurrence_site_bones, 
procure_deprecated_field_clinical_recurrence_site_liver, procure_deprecated_field_clinical_recurrence_site_lungs, procure_deprecated_field_clinical_recurrence_site_others, refusing_treatments, method, 
medication_for_prostate_cancer, medication_for_benign_prostatic_hyperplasia, medication_for_prostatitis, prescribed_drugs_for_other_diseases, list_of_drugs_for_other_diseases, photocopy_of_drugs_for_other_diseases, 
dosages_of_drugs_for_other_diseases, open_sale_drugs, modified
FROM event_masters INNER JOIN procure_ed_visits ON id = event_master_id 
WHERE tmp_migrated_id IS NOT NULL AND modified = @modified AND modified_by = @modified_by);
ALTER TABLE event_masters DROP COLUMN tmp_migrated_id;
ALTER TABLE treatment_masters DROP COLUMN tmp_migrated_id;

-- Prostate hyperplasia

SELECT Participant.participant_identifier AS "Participant with 'prostate hyperplasia' place, comments and date but flag 'yes/no' different than 'yes'. No data will be created by migration process. Please review patient clinical history.", TreatmentMaster.id AS 'TreatmentMaster id record', benign_hyperplasia_place_and_date AS 'Place and date', benign_hyperplasia_notes AS notes
FROM participants Participant, treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND Participant.id = TreatmentMaster.participant_id
AND benign_hyperplasia != 'y'
AND ((benign_hyperplasia_place_and_date IS NOT NULL AND benign_hyperplasia_place_and_date NOt LIKE '')
OR (benign_hyperplasia_notes IS NOT NULL AND benign_hyperplasia_notes NOt LIKE ''));

UPDATE treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
SET benign_hyperplasia_notes = CONCAT("Created from 'Medication worksheet' by migration process. ", IFNULL(CONCAT('Place & Date : [', benign_hyperplasia_place_and_date, ']'), ''), ' ', IFNULL(benign_hyperplasia_notes, ''))
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND benign_hyperplasia = 'y';

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
SET @tx_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'treatment');

ALTER TABLE treatment_masters ADD COLUMN tmp_benign_hyperplasia tinyint(1) DEFAULT '0';
  
INSERT INTO treatment_masters (treatment_control_id, notes, participant_id, procure_created_by_bank, 
created, created_by, modified, modified_by, tmp_benign_hyperplasia)  
(SELECT DISTINCT @tx_control_id, benign_hyperplasia_notes, TreatmentMaster.participant_id, procure_created_by_bank, 
@modified, @modified_by, @modified, @modified_by, '1'
FROM treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND benign_hyperplasia = 'y');
INSERT INTO procure_txd_treatments (treatment_type, surgery_type, treatment_site, treatment_master_id) 
(SELECT 'surgery', 'prostatic hyperplasia surgery', 'prostate gland', id FROM treatment_masters  WHERE tmp_benign_hyperplasia = '1' AND modified = @modified);
INSERT INTO treatment_masters_revs (id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
version_created, modified_by)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
modified, modified_by FROM treatment_masters WHERE created = @modified AND created_by = @modified_by AND tmp_benign_hyperplasia = '1');
INSERT INTO procure_txd_treatments_revs(treatment_type,dosage,treatment_master_id,procure_deprecated_field_drug_id,treatment_site,treatment_precision,treatment_combination,
treatment_line,duration,surgery_type,
version_created)
(SELECT modified, treatment_type,dosage,treatment_master_id,procure_deprecated_field_drug_id,treatment_site,treatment_precision,treatment_combination,
treatment_line,duration,surgery_type
FROM treatment_masters INNER JOIN procure_txd_treatments ON id = treatment_master_id AND created = @modified AND created_by = @modified_by AND tmp_benign_hyperplasia = '1');

ALTER TABLE treatment_masters DROP COLUMN tmp_benign_hyperplasia;

UPDATE treatment_masters SET deleted = 1, modified = @modified, modified_by = @modified_by WHERE treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'procure medication worksheet'); 
INSERT INTO treatment_masters_revs (id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
version_created, modified_by)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
modified, modified_by
FROM treatment_masters INNER JOIN procure_txd_medications on id = treatment_master_id
WHERE deleted = 1 AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_medications_revs (patient_identity_verified,medication_for_prostate_cancer,
medication_for_benign_prostatic_hyperplasia,medication_for_prostatitis,benign_hyperplasia,benign_hyperplasia_place_and_date,benign_hyperplasia_notes,
prescribed_drugs_for_other_diseases,list_of_drugs_for_other_diseases,photocopy_of_drugs_for_other_diseases,dosages_of_drugs_for_other_diseases,open_sale_drugs,treatment_master_id,
version_created)
(SELECT patient_identity_verified,medication_for_prostate_cancer,
medication_for_benign_prostatic_hyperplasia,medication_for_prostatitis,benign_hyperplasia,benign_hyperplasia_place_and_date,benign_hyperplasia_notes,
prescribed_drugs_for_other_diseases,list_of_drugs_for_other_diseases,photocopy_of_drugs_for_other_diseases,dosages_of_drugs_for_other_diseases,open_sale_drugs,treatment_master_id,
modified
FROM treatment_masters INNER JOIN procure_txd_medications on id = treatment_master_id
WHERE deleted = 1 AND modified = @modified AND modified_by = @modified_by);
UPDATE treatment_controls SET flag_active = 0 WHERE tx_method = 'procure medication worksheet';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_medications');
DELETE FROM structures WHERE alias='procure_txd_medications';
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `tablename`='procure_txd_medications');
DELETE FROM structure_fields WHERE `tablename`='procure_txd_medications';
ALTER TABLE procure_txd_medications RENAME TO procure_deprecated_table_txd_medications;
ALTER TABLE procure_txd_medications_revs RENAME TO procure_deprecated_table_txd_medications_revs;

-- End of process of treatment and event clean up
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE event_controls SET databrowser_label = event_type WHERE flag_active = 1;
UPDATE treatment_controls SET databrowser_label = tx_method WHERE flag_active = 1;

INSERT INTO i18n (id,en,fr)
VALUES
('visit data entry step', 'Visit data entry step', 'Étape de saisie de données de visite'),
('skip visit data entry step', 'Next step (skip data no entry)', 'Prochaine étape (sans saisie de données)'),
('visit data entry done', 'Data Entry Done', 'Saisie de données terminée');

-- Structure Value Domain Clean Up
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_value_domains SET domain_name = 'procure_treatment_types' WHERE domain_name = 'procure_followup_treatment_types';

--
-- Clinical exam
--

-- procure_clinical_exam_results

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Exam - Results (PROCURE values only)\')" WHERE domain_name = 'procure_clinical_exam_results';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Clinical Exam - Results (PROCURE values only)', 1, 50, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Exam - Results (PROCURE values only)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
(SELECT value, en, fr, '1', @control_id
FROM structure_value_domains domain
INNER JOIN structure_value_domains_permissible_values link ON domain.id = link.structure_value_domain_id
INNER JOIN structure_permissible_values val ON val.id =link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = language_alias
WHERE link.flag_active = 1
AND domain_name = 'procure_clinical_exam_results'); 
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_clinical_exam_results");

-- procure_clinical_exam_types

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Exam - Types (PROCURE values only)\')" WHERE domain_name = 'procure_clinical_exam_types';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Clinical Exam - Types (PROCURE values only)', 1, 50, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Exam - Types (PROCURE values only)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
(SELECT value, en, fr, '1', @control_id
FROM structure_value_domains domain
INNER JOIN structure_value_domains_permissible_values link ON domain.id = link.structure_value_domain_id
INNER JOIN structure_permissible_values val ON val.id =link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = language_alias
WHERE link.flag_active = 1
AND domain_name = 'procure_clinical_exam_types'); 
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_clinical_exam_types");

-- procure_clinical_exam_type_precisions
-- procure_progressions_comorbidities

UPDATE structure_permissible_values_custom_controls SET name = 'Clinical Exam Precisions (PROCURE values only)' WHERE name = 'Clinical Exam Precisions';
UPDATE structure_permissible_values_custom_controls SET name = 'Progressions & Comorbidities (PROCURE values only)' WHERE name = 'Progressions & Comorbidities';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Exam Precisions (PROCURE values only)\')" 
WHERE domain_name = 'procure_clinical_exam_type_precisions';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Progressions & Comorbidities (PROCURE values only)\')" 
WHERE domain_name = 'procure_progressions_comorbidities';

--
-- Treatment
--

UPDATE structure_permissible_values_custom_controls SET name = 'Surgery Types (PROCURE values only)' WHERE name = 'Surgery Types';
UPDATE structure_permissible_values_custom_controls SET name = 'Treatment Sites (PROCURE values only)' WHERE name = 'Treatment Sites';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Surgery Types (PROCURE values only)\')" 
WHERE domain_name = 'procure_surgery_type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Sites (PROCURE values only)\')" 
WHERE domain_name = 'procure_treatment_site';

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Precisions (PROCURE values only)\')" WHERE domain_name = 'procure_treatment_precision';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Treatment Precisions (PROCURE values only)', 1, 50, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Precisions (PROCURE values only)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
(SELECT value, en, fr, '1', @control_id
FROM structure_value_domains domain
INNER JOIN structure_value_domains_permissible_values link ON domain.id = link.structure_value_domain_id
INNER JOIN structure_permissible_values val ON val.id =link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = language_alias
WHERE link.flag_active = 1
AND domain_name = 'procure_treatment_precision'); 
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_treatment_precision");

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Types (PROCURE values only)\')" WHERE domain_name = 'procure_treatment_types';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Treatment Types (PROCURE values only)', 1, 50, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Types (PROCURE values only)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
(SELECT value, en, fr, '1', @control_id
FROM structure_value_domains domain
INNER JOIN structure_value_domains_permissible_values link ON domain.id = link.structure_value_domain_id
INNER JOIN structure_permissible_values val ON val.id =link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = language_alias
WHERE link.flag_active = 1
AND domain_name = 'procure_treatment_types'); 
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_treatment_types");

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inventory Management
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Collection
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET type = 'input', setting = 'size=4,class=range', structure_value_domain = null WHERE field = 'procure_visit';
INSERT INTO i18n (id,en,fr) VALUES ('wrong procure collection visit format', 'Wrong collection visit format', 'Le format de la visite n''est pas supporté');

-- identity confirmation

ALTER TABLE collections CHANGE procure_patient_identity_verified procure_deprecated_field_procure_patient_identity_verified tinyint(1) DEFAULT '0';
ALTER TABLE collections_revs CHANGE procure_patient_identity_verified procure_deprecated_field_procure_patient_identity_verified tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model` IN ('ViewCollection', 'Collection') AND `field`='procure_patient_identity_verified');
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model` IN ('ViewCollection', 'Collection') AND `field`='procure_patient_identity_verified';

-- replace pbmc by buffy coat then use pbmc

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(216, 217, 218);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(65);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(70);

SELECT 'Check no difference exist in sample_controls and aliquot_controls for pbmc and buffy coat - Detail tables field should be identical' AS 'WARNING';
SELECT * from sample_controls WHERE sample_type in ('buffy coat', 'pbmc');
SELECT * FROM aliquot_controls WHERE sample_control_id IN (select id from sample_controls WHERE sample_type in ('buffy coat', 'pbmc'));

INSERT INTO sd_der_buffy_coats (sample_master_id) (SELECT sample_master_id FROM sd_der_pbmcs);
DELETE FROM sd_der_pbmcs;
INSERT INTO sd_der_buffy_coats_revs (sample_master_id, version_created) (SELECT sample_master_id, version_created FROM sd_der_pbmcs_revs);
DELETE FROM sd_der_pbmcs_revs;
UPDATE sample_masters 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
UPDATE sample_masters_revs 
SET sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat')
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
UPDATE aliquot_masters 
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
UPDATE aliquot_masters_revs
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
UPDATE sample_masters SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'pbmc';
UPDATE sample_masters_revs SET parent_sample_type = 'buffy coat' WHERE parent_sample_type = 'pbmc';

REPLACE INTO i18n (id,en,fr)
VALUES
('pbmc', 'PBMC', 'PBMC');

-- Collection tempalte

SET @template_id = (SELECT id FROM templates WHERE name = 'Blood/Sang');
SET @sample_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
SET @aliquot_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');

DELETE FROM template_nodes 
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube')
AND quantity = 3;

DELETE FROM template_nodes 
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'whatman paper');

UPDATE template_nodes
SET quantity = '2'
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'serum' AND aliquot_type = 'tube');

UPDATE template_nodes
SET quantity = '6'
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'plasma' AND aliquot_type = 'tube');

SET @bcf_control_id = (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'buffy coat' );
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
(SELECT parent_id, @template_id, @sample_datamart_structure_id, @bcf_control_id, '1'
FROM template_nodes
WHERE template_id = @template_id 
AND datamart_structure_id = @sample_datamart_structure_id 
AND control_id = (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'pbmc'));

SET @bcf_aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube');
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
(SELECT id, @template_id, @aliquot_datamart_structure_id, @bcf_aliquot_control_id, '2'
FROM template_nodes
WHERE template_id = @template_id 
AND datamart_structure_id = @sample_datamart_structure_id 
AND control_id = @bcf_control_id);

SET @template_id = (SELECT id FROM templates WHERE name = 'Urine');
SET @sample_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
SET @aliquot_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');

DELETE FROM template_nodes 
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'urine' AND aliquot_type = 'cup');

UPDATE template_nodes
SET quantity = '4'
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'centrifuged urine' AND aliquot_type = 'tube');

-- View

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Generated', '', 'procure_generated_sample_types', 'input',  NULL , '0', '', '', '', 'samples', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='procure_generated_sample_types' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='samples' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Sample
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET @keep_field_id = (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type = 'datetime' LIMIT 0,1);
SET @remove_field_id = (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type = 'datetime' LIMIT 1,1);
UPDATE structure_formats SET structure_field_id = @keep_field_id WHERE structure_field_id = @remove_field_id;
DELETE FROM structure_fields WHERE id = @remove_field_id;

INSERT INTO structures(`alias`) VALUES ('procure_centrifugations');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_centrifugations'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '500', '', '0', '1', 'centrifugation date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('procure_extractions');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_extractions'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '500', '', '0', '1', 'extraction date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('procure_creations');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_creations'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '500', '', '0', '1', 'creation date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('procure_amplifications');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_amplifications'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '500', '', '0', '1', 'amplification date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_centrifugations') WHERE sample_type IN ('pbmc', 'plasma', 'serum', 'buffy coat', 'centrifuged urine');
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_extractions') WHERE sample_type IN ('dna', 'rna');
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_amplifications') WHERE sample_type IN ('amplified rna ');
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_creations') WHERE sample_type IN ('cdna');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('centrifugation date', 'Centrifugation Date', 'Date de centrifugation'),
('extraction date', 'Extraction date', 'Date d''extraction'),
('amplification date', 'Amplification Date', 'Date d''amplification');

-- Blood

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='procure_refrigeration_time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_without_incident' AND `language_label`='without incident' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_inverted_8_10_times' AND `language_label`='tubes_inverted 8 10 times' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_correclty_stored' AND `language_label`='procure blood tubes correclty stored' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='procure_tubes_correclty_stored_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_without_incident' AND `language_label`='without incident' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_inverted_8_10_times' AND `language_label`='tubes_inverted 8 10 times' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_correclty_stored' AND `language_label`='procure blood tubes correclty stored' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='procure_tubes_correclty_stored_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_without_incident' AND `language_label`='without incident' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_inverted_8_10_times' AND `language_label`='tubes_inverted 8 10 times' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_correclty_stored' AND `language_label`='procure blood tubes correclty stored' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='procure_tubes_correclty_stored_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE sd_spe_bloods 
  CHANGE procure_collection_without_incident procure_deprecated_field_collection_without_incident tinyint(1) DEFAULT '0',
  CHANGE procure_tubes_inverted_8_10_times procure_deprecated_field_tubes_inverted_8_10_times tinyint(1) DEFAULT '0',
  CHANGE procure_tubes_correclty_stored procure_deprecated_field_tubes_correclty_stored tinyint(1) DEFAULT '0';
ALTER TABLE sd_spe_bloods_revs 
  CHANGE procure_collection_without_incident procure_deprecated_field_collection_without_incident tinyint(1) DEFAULT '0',
  CHANGE procure_tubes_inverted_8_10_times procure_deprecated_field_tubes_inverted_8_10_times tinyint(1) DEFAULT '0',
  CHANGE procure_tubes_correclty_stored procure_deprecated_field_tubes_correclty_stored tinyint(1) DEFAULT '0';

-- Urine

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_concentrated' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_tag`='for a volume of ml' WHERE model='SampleDetail' AND tablename='sd_der_urine_cents' AND field='procure_pellet_volume_ml' AND `type`='float' AND structure_value_domain  IS NULL ;
REPLACE INTO i18n (id,en,fr) VALUES ('approximatif pellet volume ml', 'Approximate volume (ml) of pellet', 'Volume (ml) approximatif du culot');
INSERT INTO i18n (id,en,fr) VALUES ('for a volume of ml', 'For a volume (ml) of', 'Pour un volume (ml) de');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_processed_at_reception' AND `language_label`='processed at reception' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_conserved_at_4' AND `language_label`='conserved at 4' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_time_at_4' AND `language_label`='' AND `language_tag`='time at 4' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_aspect_after_refrigeration' AND `language_label`='urine aspect after refrigeration' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='urine_aspect') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_other_aspect_after_refrigeration' AND `language_label`='' AND `language_tag`='other precision' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_aspect_after_centrifugation' AND `language_label`='urine aspect after centrifugation' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_urine_aspect_after_centrifugation') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_other_aspect_after_centrifugation' AND `language_label`='' AND `language_tag`='other precision' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_processed_at_reception' AND `language_label`='processed at reception' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_conserved_at_4' AND `language_label`='conserved at 4' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_time_at_4' AND `language_label`='' AND `language_tag`='time at 4' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_aspect_after_refrigeration' AND `language_label`='urine aspect after refrigeration' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='urine_aspect') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_other_aspect_after_refrigeration' AND `language_label`='' AND `language_tag`='other precision' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_aspect_after_centrifugation' AND `language_label`='urine aspect after centrifugation' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_urine_aspect_after_centrifugation') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_other_aspect_after_centrifugation' AND `language_label`='' AND `language_tag`='other precision' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_processed_at_reception' AND `language_label`='processed at reception' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_conserved_at_4' AND `language_label`='conserved at 4' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_time_at_4' AND `language_label`='' AND `language_tag`='time at 4' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_aspect_after_refrigeration' AND `language_label`='urine aspect after refrigeration' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='urine_aspect') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_other_aspect_after_refrigeration' AND `language_label`='' AND `language_tag`='other precision' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_aspect_after_centrifugation' AND `language_label`='urine aspect after centrifugation' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_urine_aspect_after_centrifugation') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_other_aspect_after_centrifugation' AND `language_label`='' AND `language_tag`='other precision' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE sd_der_urine_cents
		CHANGE procure_processed_at_reception procure_deprecated_field_processed_at_reception tinyint(1) DEFAULT '0',
		CHANGE procure_conserved_at_4 procure_deprecated_field_conserved_at_4 tinyint(1) DEFAULT '0',
		CHANGE procure_time_at_4 procure_deprecated_field_time_at_4 int(6),
		CHANGE procure_aspect_after_refrigeration procure_deprecated_field_aspect_after_refrigeration  varchar(50),
		CHANGE procure_other_aspect_after_refrigeration procure_deprecated_field_other_aspect_after_refrigeration varchar(250),
		CHANGE procure_aspect_after_centrifugation procure_deprecated_field_aspect_after_centrifugation varchar(50),
		CHANGE procure_other_aspect_after_centrifugation procure_deprecated_field_other_aspect_after_centrifugation varchar(250);
ALTER TABLE sd_der_urine_cents_revs
		CHANGE procure_processed_at_reception procure_deprecated_field_processed_at_reception tinyint(1) DEFAULT '0',
		CHANGE procure_conserved_at_4 procure_deprecated_field_conserved_at_4 tinyint(1) DEFAULT '0',
		CHANGE procure_time_at_4 procure_deprecated_field_time_at_4 int(6),
		CHANGE procure_aspect_after_refrigeration procure_deprecated_field_aspect_after_refrigeration  varchar(50),
		CHANGE procure_other_aspect_after_refrigeration procure_deprecated_field_other_aspect_after_refrigeration varchar(250),
		CHANGE procure_aspect_after_centrifugation procure_deprecated_field_aspect_after_centrifugation varchar(50),
		CHANGE procure_other_aspect_after_centrifugation procure_deprecated_field_other_aspect_after_centrifugation varchar(250);

-- Aliquot
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('initial storage date', 'Storage Date', 'Date d''entreposage');
UPDATE storage_controls SET check_conflicts = 2 WHERE flag_active = 1 AND check_conflicts = 1; 

ALTER TABLE ad_tubes CHANGE procure_expiration_date procure_deprecated_field_expiration_date varchar(50);
ALTER TABLE ad_tubes_revs CHANGE procure_expiration_date procure_deprecated_field_expiration_date varchar(50);
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_aliquot_expiration_date');
DELETE FROM structures WHERE alias='procure_aliquot_expiration_date';
DELETE FROM structure_fields WHERE field = 'procure_expiration_date';
UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, ',procure_aliquot_expiration_date', '');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_cell_tubes' AND `field`='concentration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_concentration_unit') AND `flag_confidential`='0');

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
UPDATE aliquot_masters AliquotMaster, sd_spe_bloods SampleDetail, sample_masters SampleMaster
SET AliquotMaster.modified = @modified, AliquotMaster.modified_by = @modified_by, AliquotMaster.deleted = 1
WHERE AliquotMaster.deleted <> 1
AND AliquotMaster.aliquot_control_id IN (
	SELECT AlCt.id 
	FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id 
	WHERE sample_type = 'blood' AND aliquot_type = 'tube' AND AlCT.detail_tablename = 'ad_tubes'
) AND AliquotMaster.sample_master_id = SampleMaster.id 
AND SampleMaster.deleted <> 1
AND SampleDetail.sample_master_id = SampleMaster.id
AND SampleDetail.blood_type IN ('serum', 'k2-EDTA ')
AND AliquotMaster.in_stock = 'no'
AND AliquotMaster.id NOT IN (
	SELECT DISTINCT aliquot_master_id FROM aliquot_internal_uses WHERE deleted <> 1
	UNION ALL
	SELECT DISTINCT aliquot_master_id FROM source_aliquots WHERE deleted <> 1
	UNION ALL
	SELECT DISTINCT aliquot_master_id FROM quality_ctrls WHERE deleted <> 1
	UNION ALL
	SELECT DISTINCT aliquot_master_id FROM order_items WHERE deleted <> 1
	UNION ALL
	SELECT DISTINCT parent_aliquot_master_id FROM realiquotings WHERE deleted <> 1
	UNION ALL
	SELECT DISTINCT child_aliquot_master_id FROM realiquotings WHERE deleted <> 1
);
INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, 
study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, 
procure_created_by_bank,
modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, 
study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, 
procure_created_by_bank,
modified_by, modified
FROM aliquot_masters WHERE deleted = 1 AND modified = @modified AND modified_by = @modified_by
AND aliquot_control_id IN (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube' AND AlCT.detail_tablename = 'ad_tubes'));
INSERT INTO ad_tubes_revs (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, 
procure_deprecated_field_expiration_date, procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop,
version_created)
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, 
procure_deprecated_field_expiration_date, procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop,
modified
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE deleted = 1 AND modified = @modified AND modified_by = @modified_by
AND aliquot_control_id IN (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCT ON AlCT.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube' AND AlCT.detail_tablename = 'ad_tubes'));
 
 -- Urine

ALTER TABLE aliquot_controls MODIFY  `aliquot_type` enum('cup','block','cell gel matrix','core','slide','tube','whatman paper','envelope') NOT NULL COMMENT 'Generic name.';
UPDATE aliquot_controls SET aliquot_type = 'cup' WHERE sample_control_id = (select id from sample_controls WHERE sample_type = 'urine');
UPDATE aliquot_controls AL, sample_controls SC SET AL.databrowser_label = CONCAT(sample_type, '|', aliquot_type) WHERE sample_control_id = SC.id;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- New Request : 2016-12-22
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('clinical record update step', 'Clinical Record Update Step', 'Étape de mise à jour du dossier clinique'),
('update clinical record', 'Update Clinical Record', 'Mettre à jour dossier clinique'),
('skip go to %s', 'Skip - Go To %s', 'Passer - Prochaien étape : %s'),
('add procure clinical information', 'Add Specific Information', 'Ajouter information spécifique');

UPDATE structure_formats SET `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='surgery_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_surgery_type') AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=6' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='dosage' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='size=6' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='duration' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages/%';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Message Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('next visit' ,'Next Visit', 'Prochaine Visite', '1', @control_id);
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'ad_der_cell_tubes_incl_ml_vol', 'ad_der_tubes_incl_ml_vol') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat');

UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_pbmc_tube') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
INSERT INTO structures(`alias`) VALUES ('procure_pbmc_tube');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'procure_time_at_minus_80_hr', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time at -80 (hr)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_pbmc_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_time_at_minus_80_hr'), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE ad_tubes ADD COLUMN procure_time_at_minus_80_hr int(5) DEFAULT NULL;
ALTER TABLE ad_tubes_revs ADD COLUMN procure_time_at_minus_80_hr int(5) DEFAULT NULL;
INSERT INTO i18n (id,en,fr) VALUES ('time at -80 (hr)', 'time at -80c (hr)', 'Temps à -80c (hr)');

REPLACE INTO i18n (id,en,fr) 
VALUES 
('photocopy of drugs for other diseases',
'A photocopy of this list is atached to the patient worksheet',
'Une copie de cette liste est jointe à la fiche du patient');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Report
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

A faire...

-- Participant Identifiers

REPLACE INTO i18n (id,en,fr) VALUES ('list all identifiers of selected participants', 'List all identifiers of selected participants', 'Liste tous les identifiants de participants sélectionnés');

-- PROCURE - In Stock Aliquots Summary

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'procure aliquots summary';

-- PROCURE - Aliquots Transfer File Creation
-- And be able to load data

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '20', '', '0', '1', 'storage', '0', '', '1', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '21', '', '0', '1', 'position', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0');

TODO

PROCURE - Wrong Aliquot Identifiers Formats
PROCURE - Biochemical Relapses Detection
PROCURE - Diagnosis & Treatments Summary
PROCURE - Patients Followup Summary	Display


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

TODO PROCESSING SITE

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
