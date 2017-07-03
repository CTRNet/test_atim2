
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
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('prostate cancer - laboratory', 'Laboratory', 'Laboratoire');

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
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('psa - total ng/ml', 'PSA - Total (ng/ml)', 'APS - Total (ng/ml)');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_prostate_cancer_laboratory', 'testosterone_nmoll', 'float_positive',  NULL , '0', 'size=5', '', '', 'testosterone - nmol/l', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_prostate_cancer_laboratory'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_laboratory' AND `field`='testosterone_nmoll' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='testosterone - nmol/l' AND `language_tag`=''), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('testosterone - nmol/l', 'Testosterone (nmol/l)', 'Téstostérone (nmol/l)');
DELETE FROM structure_validations WHERE structure_field_id = (SELECT id from structure_fields WHERE field = 'psa_total_ngml');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('at least a psa or testosterone value should be set', 'At least a psa or testosterone value should be set', 'Au moins une valeur d''APS ou de téstostérone doit être saisie');

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
INSERT IGNORE INTO i18n (id,en,fr)
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
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('fdg','fdg');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('fdg', 'FDG', 'FDG');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_exam_types"), (SELECT id FROM structure_permissible_values WHERE value="fdg" AND language_alias="fdg"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_followup_exam_type_precisions", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Exam Precisions\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Clinical Exam Precisions', 1, 100, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Exam Precisions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('abdomen / pelvis' ,'Abdomen/Pelvis', 'Abdomen/Bassin', '1', @control_id, NOW(), '1', NOW(), '1'),
('bladder', 'Bladder', 'Vessie', '1', @control_id, NOW(), '1', NOW(), '1'),
('bone' ,'Bone', 'Os', '1', @control_id, NOW(), '1', NOW(), '1'),
('chest' ,'Chest', 'Poitrine', '1', @control_id, NOW(), '1', NOW(), '1'),
('spine' ,'Spine', 'Colonne vertébrale', '1', @control_id, NOW(), '1', NOW(), '1');
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
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('progressions comorbidity to define', 'Progression/Comorbidity (To Define)', 'Progression/comorbidité (À définir)', '1', @control_id, NOW(), '1', NOW(), '1'),
('local tumor progression', 'Local tumor progression', 'Progression locale de la tumeur', '1', @control_id, NOW(), '1', NOW(), '1'),
("bone metastases", "Bone metastases", "Métastases osseuses", '1', @control_id, NOW(), '1', NOW(), '1'),
("hydronephrosis", "Hydronephrosis", "Hydronephrose", '1', @control_id, NOW(), '1', NOW(), '1'),
("liver metastases", "Liver metastases", "Métastases hépatiques", '1', @control_id, NOW(), '1', NOW(), '1'),
("lung metastases", "Lung metastases", "Métastases pulmonaires", '1', @control_id, NOW(), '1', NOW(), '1'),
("pelvic lymph nodes", "Pelvic lymph nodes", "Nodules lymphatiques pelviens", '1', @control_id, NOW(), '1', NOW(), '1'),
("retroperitoneal lymph nodes", "Retroperitoneal lymph nodes", "Glandes rétropéritonéales", '1', @control_id, NOW(), '1', NOW(), '1'),
("spinal cord compression", "Spinal cord compression", "Compression de la moelle épinière", '1', @control_id, NOW(), '1', NOW(), '1'),
("spine metastases", "Spine metastases", "Métastases de la colonne vertébrale", '1', @control_id, NOW(), '1', NOW(), '1'),
("thoracic lymph nodes", "Thoracic lymph nodes", "Noeuds lymphatiques thoraciques", '1', @control_id, NOW(), '1', NOW(), '1');
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
INSERT IGNORE INTO i18n (id,en,fr)
VALUES ('prostate cancer - clinical exam', 'Clinical Exam', 'Examen clinique');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Exam Precisions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
("prostate", "Prostate", "Prostate", '1', @control_id, NOW(), '1', NOW(), '1');

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
INSERT IGNORE INTO i18n (id,en,fr)
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
SELECT Participant.participant_identifier AS "### WARNING ### : Participant with field 'Did the patient have biopsies before (pre-surgery biopsy)' set to 'yes' in 'F1b - Diagnostic Information Worksheet' but no date set. No biospy will be created by migration process based on this information. Please review patient clinical history.", EventMaster.id AS 'EventMaster id record'
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

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with 'Date' equals to the 'Date of biopsy prior to surgery ', a site equals to 'Prostate' and 'Result' value equals to 'Positive' based on the 'Date of biopsy prior to surgery ' field (not empty) in 'F1 -  Diagnostic Information Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND (EventDetail.biopsy_pre_surgery_date IS NOT NULL)
AND EventMaster.id NOT IN (
	SELECT DxBiopsyRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.biopsy_pre_surgery_date, EventDetail.biopsy_pre_surgery_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND (EventDetail.biopsy_pre_surgery_date IS NOT NULL)
	) DxBiopsyRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_clinical_exams EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.type = 'biopsy'
		AND EventDetail.results = 'positive'
		AND (EventMaster.event_date IS NOT NULL)
	) ExamBiopsyRec
	WHERE DxBiopsyRec.participant_id = ExamBiopsyRec.participant_id
	AND DxBiopsyRec.biopsy_pre_surgery_date = ExamBiopsyRec.event_date
	AND DxBiopsyRec.biopsy_pre_surgery_date_accuracy = ExamBiopsyRec.event_date_accuracy
);
INSERT INTO event_masters (participant_id, event_control_id, event_date, event_date_accuracy, procure_created_by_bank, event_summary, 
modified, created, created_by, modified_by, tmp_procure_migration) 
(SELECT DISTINCT EventMaster.participant_id, @clinical_exam_event_control_id, EventDetail.biopsy_pre_surgery_date, EventDetail.biopsy_pre_surgery_date_accuracy, procure_created_by_bank, 
CONCAT("Created by migration process (v268) from 'Diagnosis' form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Date of biopsy prior to surgery' field."),
@modified, @modified, @modified_by, @modified_by, '2'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND (EventDetail.biopsy_pre_surgery_date IS NOT NULL)
AND EventMaster.id NOT IN (
	SELECT DxBiopsyRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.biopsy_pre_surgery_date, EventDetail.biopsy_pre_surgery_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND (EventDetail.biopsy_pre_surgery_date IS NOT NULL)
	) DxBiopsyRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_clinical_exams EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.type = 'biopsy'
		AND EventDetail.results = 'positive'
		AND (EventMaster.event_date IS NOT NULL)
	) ExamBiopsyRec
	WHERE DxBiopsyRec.participant_id = ExamBiopsyRec.participant_id
	AND DxBiopsyRec.biopsy_pre_surgery_date = ExamBiopsyRec.event_date
	AND DxBiopsyRec.biopsy_pre_surgery_date_accuracy = ExamBiopsyRec.event_date_accuracy
));
INSERT INTO procure_ed_prostate_cancer_clinical_exams (type, type_precision, results, event_master_id)
(SELECT 'biopsy', 'prostate', 'positive', id FROM event_masters WHERE tmp_procure_migration = '2' AND created = @modified AND created_by = @modified_by);

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with 'Date' equals to the 'Biopsy Date', a site equals to 'Prostate' and an empty 'Result' value based on the 'Biopsy ( before pre-surgery biopsy): Date' field (not empty) in 'F1 -  Diagnostic Information Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND (EventDetail.biopsy_date IS NOT NULL)
AND EventMaster.id NOT IN (
	SELECT DxBiopsyRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.biopsy_date, EventDetail.biopsy_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND (EventDetail.biopsy_date IS NOT NULL)
	) DxBiopsyRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_clinical_exams EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.type = 'biopsy'
		AND (EventMaster.event_date IS NOT NULL)
	) ExamBiopsyRec
	WHERE DxBiopsyRec.participant_id = ExamBiopsyRec.participant_id
	AND DxBiopsyRec.biopsy_date = ExamBiopsyRec.event_date
	AND DxBiopsyRec.biopsy_date_accuracy = ExamBiopsyRec.event_date_accuracy
);
INSERT INTO event_masters (participant_id, event_control_id, event_date, event_date_accuracy, procure_created_by_bank, event_summary, 
modified, created, created_by, modified_by, tmp_procure_migration) 
(SELECT DISTINCT EventMaster.participant_id, @clinical_exam_event_control_id, EventDetail.biopsy_date, EventDetail.biopsy_date_accuracy, procure_created_by_bank,
CONCAT("Created by migration process (v268) from 'Diagnosis' form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Biopsy : Date' field."),
@modified, @modified, @modified_by, @modified_by, '1'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND (EventDetail.biopsy_date IS NOT NULL)
AND EventMaster.id NOT IN (
	SELECT DxBiopsyRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.biopsy_date, EventDetail.biopsy_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND (EventDetail.biopsy_date IS NOT NULL)
	) DxBiopsyRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_clinical_exams EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.type = 'biopsy'
		AND (EventMaster.event_date IS NOT NULL)
	) ExamBiopsyRec
	WHERE DxBiopsyRec.participant_id = ExamBiopsyRec.participant_id
	AND DxBiopsyRec.biopsy_date = ExamBiopsyRec.event_date
	AND DxBiopsyRec.biopsy_date_accuracy = ExamBiopsyRec.event_date_accuracy
));
INSERT INTO procure_ed_prostate_cancer_clinical_exams (type, type_precision, results, event_master_id)
(SELECT 'biopsy', 'prostate', '', id FROM event_masters WHERE tmp_procure_migration = '1' AND created = @modified AND created_by = @modified_by);

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
SELECT Participant.participant_identifier AS '### WARNING### : Participant with PSA pre surgery information but either date or value is missing to be migrated. The PSA wont be created by migration process. Please review patient clinical history.',
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
OR ((EventDetail.aps_pre_surgery_date IS NOT NULL)
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
procure_created_by_bank,
CONCAT("Created by migration process (v268) from 'Diagnosis' form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'PSA' field."),
@modified, @modified, @modified_by, @modified_by, '1'
FROM event_masters EventMaster
INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
WHERE EventMaster.deleted <> 1
AND EventDetail.aps_pre_surgery_date IS NOT NULL
AND ((EventDetail.aps_pre_surgery_total_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_total_ng_ml NOT LIKE '') OR (EventDetail.aps_pre_surgery_free_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_free_ng_ml NOT LIKE ''))
AND EventMaster.id NOT IN (
	SELECT DxPsaRec.event_master_id
	FROM (
		SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventDetail.aps_pre_surgery_date, EventDetail.aps_pre_surgery_date_accuracy, EventDetail.aps_pre_surgery_total_ng_ml
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_diagnosis EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventDetail.aps_pre_surgery_date IS NOT NULL
		AND ((EventDetail.aps_pre_surgery_total_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_total_ng_ml NOT LIKE '') OR (EventDetail.aps_pre_surgery_free_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_free_ng_ml NOT LIKE ''))
	) DxPsaRec,
	(
		SELECT EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy, psa_total_ngml
		FROM event_masters EventMaster
		INNER JOIN procure_ed_prostate_cancer_laboratory EventDetail ON EventMaster.id = EventDetail.event_master_id
		WHERE EventMaster.deleted <> 1
		AND EventMaster.event_date IS NOT NULL
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
	AND EventDetail.aps_pre_surgery_date IS NOT NULL
	AND EventDetail.aps_pre_surgery_total_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_total_ng_ml NOT LIKE '' AND EventDetail.aps_pre_surgery_free_ng_ml IS NOT NULL AND EventDetail.aps_pre_surgery_free_ng_ml NOT LIKE ''
) DxPsaRec,
(
	SELECT EventMaster.id as event_master_id, EventMaster.participant_id, EventMaster.event_date, EventMaster.event_date_accuracy, psa_total_ngml
	FROM event_masters EventMaster
	INNER JOIN procure_ed_prostate_cancer_laboratory EventDetail ON EventMaster.id = EventDetail.event_master_id
	WHERE EventMaster.deleted <> 1
	AND EventMaster.event_date IS NOT NULL
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
INSERT IGNORE INTO i18n (id,en,fr)
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
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('hospitalization' ,'Hospitalization', 'Hospitalisation', '1', @control_id, NOW(), '1', NOW(), '1');
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
INSERT IGNORE INTO i18n (id,en,fr)
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
INSERT IGNORE INTO i18n (id,en,fr)
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
INSERT IGNORE INTO i18n (id,en,fr)
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
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('transurethral resection of prostate' ,'Transurethral resection of prostate', 'Résection transurethral de la prostate', '1', @control_id, NOW(), '1', NOW(), '1'),
('transurethral resection of bladder lesion' ,'Transurethral resection of bladder lesion', 'Résection transurethral des lésions de la vessie', '1', @control_id, NOW(), '1', NOW(), '1'),
('cystoscopy double J placement' ,'Cystoscopy double J placement', '', '1', @control_id, NOW(), '1', NOW(), '1'),
('radical cystoprostatectomy', 'Radical cystoprostatectomy', 'Cysto-prostatectomie radicale', '1', @control_id, NOW(), '1', NOW(), '1'),
('prostatectomy', 'Prostatectomy', 'Prostatectomie', '1', @control_id, NOW(), '1', NOW(), '1'),
('prostatectomy aborted', 'Prostatectomy (Aborted)', 'Prostatectomie (Abandonnée)', '1', @control_id, NOW(), '1', NOW(), '1'),
('prostatic hyperplasia surgery', 'Prostatic Hyperplasia surgery', 'Chirurgie de l''hyperplasie prostatique', '1', @control_id, NOW(), '1', NOW(), '1');
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
SELECT `value` AS "### WARNING ### : Values of custom drop down list 'Treatment Site' not supported by procure. Values of field procure_txd_treatments.treatment_site to clean up after migration." 
FROM structure_permissible_values_customs 
WHERE control_id = @control_id AND value != 'prostate bed'
AND value NOT IN (SELECT DISTINCT lower(`en_sub_title`) FROM `coding_icd_o_3_topography` WHERE en_sub_title != 'unknown primary site');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value != 'prostate bed';
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
(SELECT DISTINCT lower(`en_sub_title`), `en_sub_title`, `fr_sub_title`, '1', @control_id, NOW(), '1', NOW(), '1' FROM `coding_icd_o_3_topography` WHERE en_sub_title != 'unknown primary site');

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
INSERT IGNORE INTO i18n (id,en,fr)
VALUES ('visit/contact', 'Visit / Contact', 'Visite / Contact');

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Patient confirmation

ALTER TABLE procure_ed_visits CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_visits_revs CHANGE patient_identity_verified procure_deprecated_field_patient_identity_verified tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_visits') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_visits' AND `field`='patient_identity_verified' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Biochemical Recurrence

SELECT DISTINCT Participant.participant_identifier AS "### WARNING ### : Participant with 'Biochemical Recurrence (>=0.2ng/ml)' set to yes in a 'F1 - Follow-up Worksheet' but no 'PSA' value was defined as 'BCR'. Information won't be migrated. To validate and correct after migration."
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

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
SET @tx_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'treatment');

SELECT DISTINCT surgery_site "Values of field 'Surgery for metastases : Site' from 'F1 - Follow-up Worksheet'. Value will be migrated into the notes of a created 'Treatment' record with 'Date' equals to 'Surgery for Metastases : Date', a 'Type' equals to 'Surgery' and an empty value for field 'Site'. Check if 'Site' could be populated by migration scritp."
FROM event_masters EventMaster
INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE EventMaster.deleted <> 1 AND surgery_site IS NOT NULL AND surgery_site NOT LIKE '';

SELECT CONCAT("Created ", count(*)," 'Treatment' records with 'Treatment Date' equals 'Surgery for Metastases : Date', a type equals to 'Surgery' and site information in notes (site to complete after migration) based on the 'Surgery for Metastases' fields ('Surgery for Metastases' set to yes and/or 'Date' not empty and/or 'Site' not empty) in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND (surgery_for_metastases = 'y' OR (surgery_date IS NOT NULL) OR (surgery_site IS NOT NULL AND surgery_site NOT LIKE ''));

SELECT Participant.participant_identifier '### WARNING ### : Participant with surgery for metastases defined but some information is missing. Please validate and complete after mifration if required', 
surgery_for_metastases 'Suregery For Metastases Value', surgery_date 'Surgery Date', surgery_site 'Surgery Site'
FROM participants Participant
INNER JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id
INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE EventMaster.deleted <> 1 
AND (surgery_for_metastases = 'y' OR (surgery_date IS NOT NULL) OR (surgery_site IS NOT NULL AND surgery_site NOT LIKE ''))
AND (surgery_for_metastases IS NULL OR surgery_for_metastases != 'y' OR surgery_date IS NULL OR surgery_date LIKE '' OR surgery_site IS NULL OR surgery_site LIKE '');

INSERT INTO treatment_masters (treatment_control_id, start_date, start_date_accuracy, 
notes, 
participant_id, procure_created_by_bank, created, created_by, modified, modified_by)
(SELECT DISTINCT @tx_control_id, surgery_date, surgery_date_accuracy, 
CONCAT("Surgery for Metastases. Site '", IFNULL(IF(surgery_site = '', null, surgery_site), 'unknown'),"'. (Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Surgery for Metastases' fields)."),
participant_id, procure_created_by_bank, @modified, @modified_by, @modified, @modified_by 
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND (surgery_for_metastases = 'y' OR (surgery_date IS NOT NULL) OR (surgery_site IS NOT NULL AND surgery_site NOT LIKE '')));
INSERT INTO procure_txd_treatments (treatment_master_id, treatment_type)
(SELECT id, 'surgery' 
FROM treatment_masters  
WHERE treatment_control_id = @tx_control_id AND created = @modified AND created_by = @modified_by AND notes LIKE "%Created by migration process (v268) from previous ATiM Version form%based on 'Surgery for Metastases' field%");
INSERT INTO treatment_masters_revs (id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
version_created, modified_by)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
modified, modified_by FROM treatment_masters WHERE created = @modified AND created_by = @modified_by AND notes LIKE "%Created by migration process (v268) from previous ATiM Version form%based on 'Surgery for Metastases' field%");
INSERT INTO procure_txd_treatments_revs (treatment_type, dosage, treatment_master_id, procure_deprecated_field_drug_id, treatment_site, treatment_precision, treatment_combination, treatment_line, duration, surgery_type, version_created)
(SELECT treatment_type, dosage, treatment_master_id, procure_deprecated_field_drug_id, treatment_site, treatment_precision, treatment_combination, treatment_line, duration, surgery_type, modified
FROM treatment_masters INNEr JOIN procure_txd_treatments ON id= treatment_master_id
WHERE created = @modified AND created_by = @modified_by AND notes LIKE "%Created by migration process (v268) from previous ATiM Version form%based on 'Surgery for Metastases' field%");
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

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with no 'Exam Date', a type 'To Define', a result 'Positive' and a 'Bone Metastases' progression based on the 'Bone Metastasis' field set to yes in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_bones = '1';
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'bone metastases', @ev_control_id, participant_id,
CONCAT("Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Clinical Recurrence : Bone Metastasis' field."), 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_bones = '1');

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with no 'Exam Date', a type 'To Define', a result 'Positive' and a 'Liver Metastases' progression based on the 'Liver Metastasis' field set to yes in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_liver = '1';
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'liver metastases', @ev_control_id, participant_id,
CONCAT("Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Clinical Recurrence : Liver Metastasis' field."), 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_liver = '1');

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with no 'Exam Date', a type 'To Define', a result 'Positive' and a 'Lung Metastases' progression based on the 'Lung Metastasis' field set to yes in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_lungs = '1';
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'lung metastases', @ev_control_id, participant_id,
CONCAT("Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Clinical Recurrence : Lung Metastasis' field."), 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 AND clinical_recurrence_site_lungs = '1');

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with no 'Exam Date', a type 'To Define', a result 'Positive' and a progression to 'Pelvic Lymph Nodes' based on the 'Clinical Recurrence Type' field set to 'regional' in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence_type = 'regional';
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'pelvic lymph nodes', @ev_control_id, participant_id,
CONCAT("Regional tumor progression. Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Clinical Recurrence : Type' field equals to 'regional'."), 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence_type = 'regional');

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with no 'Exam Date', a type 'To Define', a result 'Positive' and a 'Local' progression based on the 'Clinical Recurrence Type' field set to 'local' in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence_type = 'local';
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'local tumor progression', @ev_control_id, participant_id,
CONCAT("Local tumor progression. Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Clinical Recurrence : Type' field equals to 'local'."), 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence_type = 'local');

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with no 'Exam Date', a type 'To Define', a result 'Positive' and a progression value equals to 'To Define' based on the 'Clinical Recurrence Type' field set to 'distant' or a 'Others Metastasis' field set to yes with no additional information in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND (clinical_recurrence_site_others = '1' 
OR (clinical_recurrence_type = 'distant' AND clinical_recurrence_site_bones = '0' AND clinical_recurrence_site_liver = '0' AND clinical_recurrence_site_lungs = '0'));
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'progressions comorbidity to define', @ev_control_id, participant_id,
CONCAT("Metastasis undefined. Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Clinical Recurrence : Others Metastasis' field."), 
procure_created_by_bank, @modified, @modified, @modified_by, @modified_by
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND (clinical_recurrence_site_others = '1' 
OR (clinical_recurrence_type = 'distant' AND clinical_recurrence_site_bones = '0' AND clinical_recurrence_site_liver = '0' AND clinical_recurrence_site_lungs = '0')));

SELECT CONCAT("Created ", count(*)," 'Clinical Exam' records with no 'Exam Date', a type 'To Define', a result 'Positive' and a progression value equals to 'To Define' based on the 'Clinical Recurrence' field set to 'yes' with no additional information in 'F1 - Follow-up Worksheet'") AS '###MESSAGE###'
FROM event_masters EventMaster INNER JOIN procure_ed_visits EventDetail ON EventMaster.id = EventDetail.event_master_id 
WHERE deleted <> 1 
AND clinical_recurrence = 'y'
AND (clinical_recurrence_type = '' OR clinical_recurrence_type IS NULL)
AND clinical_recurrence_site_bones = '0' AND clinical_recurrence_site_liver = '0' AND clinical_recurrence_site_lungs = '0' AND clinical_recurrence_site_others = '0';
INSERT INTO event_masters (tmp_progression, event_control_id, participant_id,  
event_summary, 
procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT 'progressions comorbidity to define', @ev_control_id, participant_id,
CONCAT("Recurrence undefined. Created by migration process (v268) from previous ATiM Version form '", EventMaster.procure_deprecated_field_procure_form_identification,"'", IF((IFNULL(event_date, '') = ''), '', CONCAT(' (visite on ', event_date, ')')), " based on 'Clinical Recurrence : Yes/No' field."), 
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

SELECT Participant.participant_identifier AS "### WARNING ### : Participant with data for either field 'Benign hyperplasia: place and date' or 'Comments' but the answer to 'Did the patient have surgery for benign prostatoc hyperplasia' is different than 'yes' in form 'F1a - Medication Worksheet'. No data will be created by the migration process. Please review data.", 
TreatmentMaster.id AS 'TreatmentMaster id record', benign_hyperplasia_place_and_date AS 'Benign hyperplasia : Place and date', benign_hyperplasia_notes AS 'Benign hyperplasia : notes'
FROM participants Participant, treatment_masters TreatmentMaster, procure_txd_medications TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND Participant.id = TreatmentMaster.participant_id
AND benign_hyperplasia != 'y'
AND ((benign_hyperplasia_place_and_date IS NOT NULL)
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
(SELECT treatment_type,dosage,treatment_master_id,procure_deprecated_field_drug_id,treatment_site,treatment_precision,treatment_combination,
treatment_line,duration,surgery_type,
modified
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

INSERT IGNORE INTO i18n (id,en,fr)
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
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
(SELECT value, en, fr, '1', @control_id, NOW(), '1', NOW(), '1'
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
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
(SELECT value, en, fr, '1', @control_id, NOW(), '1', NOW(), '1'
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
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
(SELECT value, en, fr, '1', @control_id, NOW(), '1', NOW(), '1'
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
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
(SELECT value, en, fr, '1', @control_id, NOW(), '1', NOW(), '1'
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
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('wrong procure collection visit format', 'Wrong collection visit format', 'Le format de la visite n''est pas supporté');

-- identity confirmation

ALTER TABLE collections CHANGE procure_patient_identity_verified procure_deprecated_field_procure_patient_identity_verified tinyint(1) DEFAULT '0';
ALTER TABLE collections_revs CHANGE procure_patient_identity_verified procure_deprecated_field_procure_patient_identity_verified tinyint(1) DEFAULT '0';
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model` IN ('ViewCollection', 'Collection') AND `field`='procure_patient_identity_verified');
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model` IN ('ViewCollection', 'Collection') AND `field`='procure_patient_identity_verified';

-- replace pbmc by buffy coat then use pbmc

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(216, 217, 218);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(65);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(70);

SELECT 'Check no difference exist in sample_controls and aliquot_controls for pbmc and buffy coat - Detail tables field should be identical' AS '### TODO ###';
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
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
UPDATE aliquot_masters_revs
SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube');
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
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube')
AND quantity = 3;

DELETE FROM template_nodes 
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'whatman paper');

UPDATE template_nodes
SET quantity = '2'
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'serum' AND aliquot_type = 'tube');

UPDATE template_nodes
SET quantity = '5'
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'plasma' AND aliquot_type = 'tube');

SET @bcf_control_id = (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'buffy coat' );
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
(SELECT parent_id, @template_id, @sample_datamart_structure_id, @bcf_control_id, '1'
FROM template_nodes
WHERE template_id = @template_id 
AND datamart_structure_id = @sample_datamart_structure_id 
AND control_id = (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'pbmc'));

SET @bcf_aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube');
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
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'urine' AND aliquot_type = 'cup');

UPDATE template_nodes
SET quantity = '4'
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'centrifuged urine' AND aliquot_type = 'tube');

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
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('for a volume of ml', 'For a volume (ml) of', 'Pour un volume (ml) de');

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
	FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id 
	WHERE sample_type = 'blood' AND aliquot_type = 'tube' AND AlCt.detail_tablename = 'ad_tubes'
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
AND aliquot_control_id IN (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube' AND AlCt.detail_tablename = 'ad_tubes'));
INSERT INTO ad_tubes_revs (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, 
procure_deprecated_field_expiration_date, procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop,
version_created)
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, 
procure_deprecated_field_expiration_date, procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop,
modified
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE deleted = 1 AND modified = @modified AND modified_by = @modified_by
AND aliquot_control_id IN (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube' AND AlCt.detail_tablename = 'ad_tubes'));
 
 -- Urine

ALTER TABLE aliquot_controls MODIFY  `aliquot_type` enum('cup','block','cell gel matrix','core','slide','tube','whatman paper','envelope') NOT NULL COMMENT 'Generic name.';
UPDATE aliquot_controls SET aliquot_type = 'cup' WHERE sample_control_id = (select id from sample_controls WHERE sample_type = 'urine');
UPDATE aliquot_controls AL, sample_controls SC SET AL.databrowser_label = CONCAT(sample_type, '|', aliquot_type) WHERE sample_control_id = SC.id;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- New Request : 2016-12-22
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('clinical record update step', 'Clinical File Update Step', 'Étape de mise à jour du dossier clinique'),
('update clinical record', 'Update Clinical File', 'Mettre à jour dossier clinique'),
('skip go to %s', 'Skip - Go To %s', 'Passer - Prochaien étape : %s'),
('add procure clinical information', 'Add Specific Information', 'Ajouter information spécifique');

UPDATE structure_formats SET `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='surgery_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_surgery_type') AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=6' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='dosage' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='size=6' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='duration' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages/%';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Message Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('next visit' ,'Next Visit', 'Prochaine Visite', '1', @control_id, NOW(), '1', NOW(), '1');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'ad_der_cell_tubes_incl_ml_vol', 'ad_der_tubes_incl_ml_vol') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'buffy coat');

UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_pbmc_tube') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
INSERT INTO structures(`alias`) VALUES ('procure_pbmc_tube');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'procure_time_at_minus_80_days', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time at -80 (days)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_pbmc_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_time_at_minus_80_days'), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE ad_tubes ADD COLUMN procure_time_at_minus_80_days int(5) DEFAULT NULL;
ALTER TABLE ad_tubes_revs ADD COLUMN procure_time_at_minus_80_days int(5) DEFAULT NULL;
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('time at -80 (days)', 'Time At -80c (Days)', 'Temps à -80c (jours)');

REPLACE INTO i18n (id,en,fr) 
VALUES 
('photocopy of drugs for other diseases',
'A photocopy of this list is atached to the patient worksheet',
'Une copie de cette liste est jointe à la fiche du patient');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 20170120
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Collection tempalte : Urine cup

SET @template_id = (SELECT id FROM templates WHERE name = 'Urine');
SET @aliquot_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');

DELETE FROM template_nodes 
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'urine' AND aliquot_type = 'cup');

-- Centrifuged Urine : Field 'For a volume (ml) of'

ALTER TABLE sd_der_urine_cents CHANGE procure_pellet_volume_ml procure_deprecated_field_procure_pellet_volume_ml decimal(10,5);
ALTER TABLE sd_der_urine_cents_revs CHANGE procure_pellet_volume_ml procure_deprecated_field_procure_pellet_volume_ml decimal(10,5);
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_pellet_volume_ml' AND `language_label`='' AND `language_tag`='for a volume of ml' AND `type`='float' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_pellet_volume_ml' AND `language_label`='' AND `language_tag`='for a volume of ml' AND `type`='float' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_pellet_volume_ml' AND `language_label`='' AND `language_tag`='for a volume of ml' AND `type`='float' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Tissue Review

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE model='SpecimenReviewMaster' AND tablename='specimen_review_masters' AND field='review_date' AND `type`='date' AND structure_value_domain  IS NULL), 'notEmpty'),
((SELECT id FROM structure_fields WHERE model='SpecimenReviewMaster' AND tablename='specimen_review_masters' AND field='review_status' AND `type`='select'), 'notEmpty');
UPDATE structure_fields SET `default`='done' WHERE model='SpecimenReviewMaster' AND tablename='specimen_review_masters' AND field='review_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status');
ALTER TABLE procure_ar_tissue_slides
  ADD COLUMN tissue_type VARCHAR(20),
  ADD COLUMN tumor_size_mm decimal(6,1) NULL,
  ADD COLUMN tumor_pct decimal(6,1) NULL;
ALTER TABLE procure_ar_tissue_slides_revs
  ADD COLUMN tissue_type VARCHAR(20),
  ADD COLUMN tumor_size_mm decimal(6,1) NULL,
  ADD COLUMN tumor_pct decimal(6,1) NULL; 
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_slide_tissue_type", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Slide Review : Tissue Type\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Slide Review : Tissue Type', 1, 20, 'inventory - specimen review');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Slide Review : Tissue Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('tumor' ,'Tumor', 'Tumeur', '1', @control_id, NOW(), '1', NOW(), '1'),
('normal' ,'Normal', 'Normal', '1', @control_id, NOW(), '1', NOW(), '1');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'procure_ar_tissue_slides', 'tissue_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_slide_tissue_type') , '0', '', '', '', 'type', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'procure_ar_tissue_slides', 'tumor_size_mm', 'float_positive',  NULL , '0', '', '', '', 'tumor size (mm)', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'procure_ar_tissue_slides', 'tumor_pct', 'float_positive',  NULL , '0', '', '', '', 'tumor pct', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tissue_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_slide_tissue_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tumor_size_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm)' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tumor_pct' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor pct' AND `language_tag`=''), '0', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('tumor size (mm)', 'Tumor Size (mm)', 'Taille tumeur (mm)'),
('tumor pct', 'Tumor &#37;', '&#37; tumeur');  

-- Clinical Relapse

ALTER TABLE procure_ed_clinical_exams 
  ADD COLUMN clinical_relapse CHAR(1) DEFAULT '';
ALTER TABLE procure_ed_clinical_exams_revs 
  ADD COLUMN clinical_relapse CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_exams', 'clinical relapse', 'yes_no',  NULL , '0', '', '', '', 'clinical relapse', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_clinical_exams'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_exams' AND `field`='clinical relapse' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical relapse' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('clinical relapse', 'Clinical Relapse', 'Récidive clinique');

-- 'vital status mismatch'

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('changed vital status to deceased', 'Changed vital status to deceased', 'Changement du statut vital à  décédé');

-- Storage control test

SELECT storage_type, coord_x_size, coord_y_size, 'Sizes should be bigger than 1' FROM storage_controls WHERE (coord_x_size IS NOT NULL AND coord_x_size < 2) OR (coord_y_size IS NOT NULL AND coord_y_size < 2);  

-- Hide Nail specimen type

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(220);

-- Update paxgen tube weight from derivative creation form

INSERT INTO structures(`alias`) VALUES ('procure_tube_weight_for_derivative_creation');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_tube_weight_for_derivative_creation'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_tube_weight_gr' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='tube weight gr' AND `language_tag`=''), '0', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='initial tube weight gr' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_tube_weight_for_derivative_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_tube_weight_gr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('initial tube weight gr','Initial Weight of tube (gr)','Poids initial du tube (gr)');

-- Missing translations

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('error', 'Error', 'Erreur'),
('an error has been detected - the clinical file update process has been finished prematurely', 
"An error has been detected. The 'Clinical File Update' process has been finished prematurely.", 
"Une erreur a été détectée. Le processus de mise à jour du 'dossier clinique' a été terminé prématurément."),
("the 'last chart checked date' is currently set to '%s'", "The 'last chart checked date' is currently '%s'.", "La date de la 'dernière révision de données' est actuellement '%s'."),
('set last chart checked date to the current date', "Set by default the new 'Last Chart Checked' date to the current date.", "La date de la 'dernière révision de données' a été mise à la date d'aujourd'hui par défaut."),
('set last chart checked date to the date of the visit of the form you compelted today', "Set by default the 'Last Chart Checked' to the date of the visit of the form you compelted today.", 
 "La date de la 'dernière révision de données' a été mise par défaut à la date du formulaire de visitde que vous avez complété aujourd'hui.");

-- PSA Free

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_laboratories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_laboratories' AND `field`='psa_free_ngml' AND `language_label`='psa - free ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_laboratories' AND `field`='psa_free_ngml' AND `language_label`='psa - free ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_laboratories' AND `field`='psa_free_ngml' AND `language_label`='psa - free ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
ALTER TABLE procure_ed_laboratories CHANGE psa_free_ngml procure_deprecated_field_psa_free_ngml decimal(10,2) DEFAULT NULL;
ALTER TABLE procure_ed_laboratories_revs CHANGE psa_free_ngml procure_deprecated_field_psa_free_ngml decimal(10,2) DEFAULT NULL;

-- survival date

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Note Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('survival date' ,'Survival Date (Date a non specific information validates the participant is alive)', 'Date de survie (Date à laquelle une information non spécifique valide que le participant est en vie)', '1', @control_id, NOW(), '1', NOW(), '1');

-- Clinical Exam Site

UPDATE structure_fields SET field='site_precision', `language_tag`='site' WHERE model='EventDetail' AND tablename='procure_ed_clinical_exams' AND field='type_precision' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_clinical_exam_type_precisions');
UPDATE structure_value_domains SET domain_name='procure_clinical_exam_type_sites' WHERE domain_name='procure_clinical_exam_type_precisions'; 
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Exam - Sites (PROCURE values only)\')" WHERE domain_name = 'procure_clinical_exam_type_sites';
UPDATE structure_permissible_values_custom_controls SET name = 'Clinical Exam - Sites (PROCURE values only)' WHERE name = 'Clinical Exam Precisions (PROCURE values only)';
UPDATE structure_value_domains SET domain_name='procure_clinical_exam_sites' WHERE domain_name='procure_clinical_exam_type_sites'; 
ALTER TABLE procure_ed_clinical_exams CHANGE type_precision site_precision varchar(100) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_exams_revs CHANGE type_precision site_precision varchar(100) DEFAULT NULL;

-- Add search on treatment notes

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Report

UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 0 
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('TmaSlide', 'TmaSlideUse');

UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 1
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('ParticipantMessage', 'ParticipantContact')
AND datamart_structure_functions.label = 'number of elements per participant';

-- PROCURE - In Stock Aliquots Summary

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'procure aliquots summary';
UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 0
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('Participant')
AND datamart_structure_functions.label = 'procure aliquots summary';

-- PROCURE - Aliquots Transfer File Creation

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '20', '', '0', '1', 'storage', '0', '', '1', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '21', '', '0', '1', 'position', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Participant Identifiers

REPLACE INTO i18n (id,en,fr) VALUES ('list all identifiers of selected participants', 'List all identifiers of selected participants', 'Liste tous les identifiants de participants sélectionnés');

-- 'clinical relapse'

UPDATE structure_fields SET field = 'clinical_relapse' WHERE field = 'clinical relapse';

-- Report field update

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_total_ng_ml' AND `language_label`='total ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_free_ng_ml' AND `language_label`='free ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_total_ng_ml' AND `language_label`='total ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_free_ng_ml' AND `language_label`='free ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_total_ng_ml' AND `language_label`='total ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_free_ng_ml' AND `language_label`='free ng/ml' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_prostate_cancer_diagnosis' AND `field`='aps_pre_surgery_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

-- Report sortable field

UPDATE structure_fields 
SET  sortable = '1'
WHERE plugin = 'Datamart' 
AND model='0' 
AND tablename=''
AND id IN (SELECT structure_field_id FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('procure_next_followup_report_result', 'procure_diagnosis_and_treatments_report_result', 'procure_bcr_detection_result')));

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'procure followup summary';
UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 0
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('Participant')
AND datamart_structure_functions.label = 'procure followup summary';

-- Migration report

SELECT Participant.participant_identifier '### TODO ### : Participant with clinical exam build from Follow-up form data that should be compelted', 
event_date, EventDetail.type, EventDetail.site_precision, EventDetail.results, EventDetail.progression_comorbidity, event_summary
FROM participants Participant
INNER JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id
INNER JOIN procure_ed_clinical_exams EventDetail ON EventDetail.event_master_id = EventMaster.id
WHERE EventMaster.deleted <> 1
AND (EventDetail.type like 'clinical exam to define' OR EventDetail.progression_comorbidity LIKE 'progressions comorbidity to define');

--

-- UPDATE structure_formats 
-- SET `flag_add_readonly`=`flag_add`, `flag_edit_readonly`=`flag_edit`, `flag_addgrid_readonly`= `flag_addgrid`, `flag_editgrid_readonly`=`flag_editgrid`, 
-- `flag_batchedit_readonly`=`flag_batchedit`='1'
-- WHERE structure_field_id IN (SELECT id FROM structure_fields 
-- WHERE `field` LIKE 'qc_nd_%' OR `field` LIKE 'procure_chuq_%' 
-- OR `field` LIKE 'procure_chus_%' OR `field` LIKE 'chus_%' OR `field` LIKE 'procure_cusm_%' OR `field` LIKE 'cusm_%');

INSERT IGNORE INTO i18n (id,en,fr)
(select CONCAT(language_label, ' (#ChusField)'), CONCAT(i18n.en, ' (#ChusData)'), CONCAT(i18n.fr, ' (#DonnéeChus)')
FROM structure_fields 
LEFT JOIN i18n ON i18n.id = language_label
WHERE language_label IS NOT NULL AND language_label NOT LIKE '' AND (`field` LIKE 'procure_chus_%' OR `field` LIKE 'chus_%'));
UPDATE structure_fields
SET language_label = CONCAT(language_label, ' (#ChusField)')
WHERE language_label IS NOT NULL AND language_label NOT LIKE '' AND language_label NOT LIKE '%(#ChusField)' 
AND (`field` LIKE 'procure_chus_%' OR `field` LIKE 'chus_%');

INSERT IGNORE INTO i18n (id,en,fr)
(select CONCAT(language_tag, ' (#ChusField)'), CONCAT(i18n.en, ' (#ChusData)'), CONCAT(i18n.fr, ' (#DonnéeChus)')
FROM structure_fields 
LEFT JOIN i18n ON i18n.id = language_tag
WHERE language_tag IS NOT NULL AND language_tag NOT LIKE '' AND (`field` LIKE 'procure_chus_%' OR `field` LIKE 'chus_%'));
UPDATE structure_fields
SET language_tag = CONCAT(language_tag, ' (#ChusField)')
WHERE language_tag IS NOT NULL AND language_tag NOT LIKE '' AND language_tag NOT LIKE '%(#ChusField)' 
AND (`field` LIKE 'procure_chus_%' OR `field` LIKE 'chus_%');

--

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @template_id = (SELECT id FROM templates WHERE name = 'Blood/Sang');
SET @aliquot_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE template_nodes
SET quantity = '1'
WHERE template_id = @template_id 
AND datamart_structure_id = @aliquot_datamart_structure_id 
AND control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('procure warning for storage of pbmc',
'The storage information should be the storage at lower than a temperature lower than minus 150°C.',
"L'information d'entreposage doit être l'entreposage à une température inférieure à moins 150°C."),
('procure warning for date of pbmc initial storage',
"The initial storage date is the date the PBMC tube has been stored at a temperature lower than minus 150°C (either into a freezer or a nitrogen container) for the first time.", 
"La date initiale d'entreposage est la date à laquelle le tube de PBMC a été entreposé pour la première fois à une température inférieure à moins 150°C (dans un congélateur ou dans un récipient d'azote liquide).");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'procure_date_at_minus_80', 'date',  NULL , '0', '', '', '', 'date at -80', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_pbmc_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_date_at_minus_80' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date at -80' AND `language_tag`=''), '1', '69', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='',  `language_tag`='time (days)' WHERE model='AliquotDetail' AND tablename='ad_tubes' AND field='procure_time_at_minus_80_days' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
INSERT IGNORE i18n (id,en,fr)
VALUES
('time (days)', "Time (Days)", "Temps (jours)"),
('date at -80', 'Date at -80°C', 'Date à -80°C');
ALTER TABLE ad_tubes
  ADD COLUMN `procure_date_at_minus_80` date DEFAULT NULL,
  ADD COLUMN `procure_date_at_minus_80_accuracy` char(1) NOT NULL DEFAULT '';
ALTER TABLE ad_tubes_revs
  ADD COLUMN `procure_date_at_minus_80` date DEFAULT NULL,
  ADD COLUMN `procure_date_at_minus_80_accuracy` char(1) NOT NULL DEFAULT '';

ALTER TABLE ad_tissue_slides
  ADD COLUMN `procure_stain` varchar(60) DEFAULT NULL;
ALTER TABLE ad_tissue_slides_revs
  ADD COLUMN `procure_stain` varchar(60) DEFAULT NULL;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE ad_tissue_slides SET procure_stain = lower(immunochemistry);
UPDATE ad_tissue_slides SET immunochemistry = '';
UPDATE ad_tissue_slides_revs SET procure_stain = lower(immunochemistry);
UPDATE ad_tissue_slides_revs SET immunochemistry = '';
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_tissue_slide_stains", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Slide Stains\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Slide Stains', 1, 60, 'inventory');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'procure_stain', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_tissue_slide_stains') , '0', '', '', '', 'stain', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='procure_stain' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_tissue_slide_stains')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stain' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('stain', 'Stain', 'Marquage/Teinture');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Slide Stains');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('h&e' ,'H&E', 'H&E', '1', @control_id, NOW(), '1', NOW(), '1');
UPDATE ad_tissue_slides SET procure_stain = 'h&e' WHERE procure_stain = 'h & e';
UPDATE ad_tissue_slides_revs SET procure_stain = 'h&e' WHERE procure_stain = 'h & e';
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by)  
(SELECT DISTINCT procure_stain, '', '', '1', @control_id, NOW(), '1', NOW(), '1' FROM ad_tissue_slides WHERE procure_stain != 'h&e');

ALTER TABLE procure_ar_tissue_slides
  ADD COLUMN tumor_size_length_mm decimal(6,1) NULL,
  ADD COLUMN tumor_size_width_mm decimal(6,1) NULL,
  DROP COLUMN tumor_size_mm;
ALTER TABLE procure_ar_tissue_slides_revs
  ADD COLUMN tumor_size_length_mm decimal(6,1) NULL,
  ADD COLUMN tumor_size_width_mm decimal(6,1) NULL,
  DROP COLUMN tumor_size_mm;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'procure_ar_tissue_slides', 'tumor_size_length_mm', 'float_positive',  NULL , '0', 'size=3', '', '', 'tumor size (mm)', 'length'), 
('InventoryManagement', 'AliquotReviewDetail', 'procure_ar_tissue_slides', 'tumor_size_width_mm', 'float_positive',  NULL , '0', 'size=3', '', '', '', 'width');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tumor_size_length_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm)' AND `language_tag`='length'), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tumor_size_width_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='width'), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ar_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tumor_size_mm' AND `language_label`='tumor size (mm)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tumor_size_mm' AND `language_label`='tumor size (mm)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='tumor_size_mm' AND `language_label`='tumor size (mm)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='treatment_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Message Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('next hormonotherpay' ,'Next Hormonotherpay', 'Prochaine hormonothérapie', '1', @control_id, NOW(), '1', NOW(), '1'),
('next chemotherapy' ,'Next Chemotherpay', 'Prochaine chimiothérapie', '1', @control_id, NOW(), '1', NOW(), '1');

UPDATE misc_identifier_controls SET flag_active = 1 WHERE misc_identifier_name = 'participant study number';
UPDATE menus SET flag_active = '1' WHERE id IN ('clin_CAN_33', 'tool_CAN_100', 'tool_CAN_104', 'tool_CAN_105.2');

UPDATE menus SET flag_active = '1' WHERE use_link LIKE '/Order/%';

ALTER TABLE order_items ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE order_items_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

ALTER TABLE orders ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE orders_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Order', 'orders', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orders'), (SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

ALTER TABLE shipments ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE shipments_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Shipment', 'shipments', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shipments'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

ALTER TABLE study_summaries ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE study_summaries_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

ALTER TABLE tma_slides ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE tma_slides_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_transferred_aliquots_description' AND `language_label`='aliquot description' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_transferred_aliquots_descriptions_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_transferred_aliquots_description' AND `language_label`='aliquot description' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_transferred_aliquots_descriptions_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');
DELETE FROM structures WHERE alias='procure_transferred_aliquots_details';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details_file');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_transferred_aliquots_details_file' AND `language_label`='list of transferred aliquots' AND `language_tag`='' AND `type`='file' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='procure_transferred_aliquots_details_file' AND `language_label`='list of transferred aliquots' AND `language_tag`='' AND `type`='file' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='0');
DELETE FROM structures WHERE alias='procure_transferred_aliquots_details_file';

DELETE FROM datamart_structure_functions WHERE label = 'create aliquots transfer file';
DELETE FROM datamart_reports WHERE name = 'procure aliquots transfer file creation';

SET @template_id = (SELECT id FROM templates WHERE name = 'Blood/Sang');
SET @sample_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
SET @aliquot_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE template_nodes SET parent_id = null WHERE template_id = @template_id ;
DELETE FROM template_nodes WHERE template_id = @template_id ;
-- Blood & Serum
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(null, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'blood' ), '1');
SET @blood_template_node_id = (SELECT LAST_INSERT_ID());
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_template_node_id, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'serum'), '1');
SET @blood_derivative_template_node_id = (SELECT LAST_INSERT_ID());
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_derivative_template_node_id, @template_id, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'serum' AND aliquot_type = 'tube'), '2');
-- Blood (paxgene)
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(null, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'blood' ), '1');
SET @blood_template_node_id = (SELECT LAST_INSERT_ID());
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_template_node_id, @template_id, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'blood' AND aliquot_type = 'tube'), '1');
-- Blood plamsa / buffy coat / pbmc
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(null, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'blood' ), '1');
SET @blood_template_node_id = (SELECT LAST_INSERT_ID());
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_template_node_id, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'plasma'), '1');
SET @blood_derivative_template_node_id = (SELECT LAST_INSERT_ID());
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_derivative_template_node_id, @template_id, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'plasma' AND aliquot_type = 'tube'), '5');
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_template_node_id, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'buffy coat'), '1');
SET @blood_derivative_template_node_id = (SELECT LAST_INSERT_ID());
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_derivative_template_node_id, @template_id, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube'), '2');
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_template_node_id, @template_id, @sample_datamart_structure_id, (SELECT SpCt.id FROM sample_controls SpCt WHERE sample_type = 'pbmc'), '1');
SET @blood_derivative_template_node_id = (SELECT LAST_INSERT_ID());
INSERT INTO `template_nodes` (`parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`)
VALUES
(@blood_derivative_template_node_id, @template_id, @aliquot_datamart_structure_id, (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube'), '3');

ALTER TABLE tma_slides
  ADD COLUMN `procure_stain` varchar(60) DEFAULT NULL;
ALTER TABLE tma_slides_revs
  ADD COLUMN `procure_stain` varchar(60) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_tma_slide_stains", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'TMA Slide Stains\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('TMA Slide Stains', 1, 60, 'storage');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TMA Slide Stains');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('h&e' ,'H&E', 'H&E', '1', @control_id, NOW(), '1', NOW(), '1');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'procure_stain', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_tma_slide_stains') , '0', '', '', '', 'stain', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='procure_stain' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_tma_slide_stains')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stain' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('sent to muhc','Sent To MUHC','Envoyé au CUSM',  '1', @control_id, NOW(), NOW(), 1, 1),
('received from muhc','Received From MUHC','Recu du CUSM',  '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('sent to chuq','Sent To CHUQ','Envoyé au CHUQ',  '1', @control_id, NOW(), NOW(), 1, 1),
('received from chuq','Received From CHUQ','Recu du CHUQ',  '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('sent to chum','Sent To CHUM','Envoyé au CHUM',  '1', @control_id, NOW(), NOW(), 1, 1),
('received from chum','Received From CHUM','Recu du CHUM',  '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('sent to chus','Sent To CHUS','Envoyé au CHUS',  '1', @control_id, NOW(), NOW(), 1, 1),
('received from chus','Received From CHUS','Recu du CHUS',  '1', @control_id, NOW(), NOW(), 1, 1);

SELECT "Hidde value 'sent to {bank}' and 'received from {bank}' in the 'aliquot use and event types' cutsom list where {bank} is the name of the current {bank} you are migrating code" AS '### TODO ###';

ALTER TABLE aliquot_review_masters ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE aliquot_review_masters_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewMaster', 'aliquot_review_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_review_masters'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

update aliquot_review_controls set aliquot_type_restriction = 'slide,block' WHERE review_type = 'procure tissue slide review';

SELECT COUNT(*) AS '### TODO ### : Number of aliquot_review_masters records with procure_created_by_bank value to sert.' FROM aliquot_review_masters WHERE deleted <> 1 AND (procure_created_by_bank = '' OR procure_created_by_bank IS NULL);
SELECT COUNT(*) AS '### TODO ### : Number of order_items records with procure_created_by_bank value to sert.' FROM order_items WHERE deleted <> 1 AND (procure_created_by_bank = '' OR procure_created_by_bank IS NULL);
SELECT COUNT(*) AS '### TODO ### : Number of orders records with procure_created_by_bank value to sert.' FROM orders WHERE deleted <> 1 AND (procure_created_by_bank = '' OR procure_created_by_bank IS NULL);
SELECT COUNT(*) AS '### TODO ### : Number of shipments records with procure_created_by_bank value to sert.' FROM shipments WHERE deleted <> 1 AND (procure_created_by_bank = '' OR procure_created_by_bank IS NULL);
SELECT COUNT(*) AS '### TODO ### : Number of study_summaries records with procure_created_by_bank value to sert.' FROM study_summaries WHERE deleted <> 1 AND (procure_created_by_bank = '' OR procure_created_by_bank IS NULL);
SELECT COUNT(*) AS '### TODO ### : Number of tma_slides records with procure_created_by_bank value to sert.' FROM tma_slides WHERE deleted <> 1 AND (procure_created_by_bank = '' OR procure_created_by_bank IS NULL);

UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='miscidentifiers_study'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_misc_identifier_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='study_summary_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_internal_use_study_summary_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Study/StudySummaries/autocompleteStudy' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Shipment');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Order');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'Shipment') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Order');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'Order') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 1
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('ViewAliquot')
AND datamart_structure_functions.label = 'add to order';
UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 1
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('OrderItem')
AND datamart_structure_functions.label = 'defined as returned';
UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 1
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('OrderItem')
AND datamart_structure_functions.label = 'edit';
UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 1
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('TmaSlide')
AND datamart_structure_functions.label = 'edit';
UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 1
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('TmaSlide')
AND datamart_structure_functions.label = 'add to order';
UPDATE datamart_structure_functions, datamart_structures
SET datamart_structure_functions.flag_active = 1
WHERE datamart_structure_id = datamart_structures.id
AND datamart_structures.model IN ('TmaBlock')
AND datamart_structure_functions.label = 'create tma slide';

UPDATE versions SET branch_build_number = '6661' WHERE version_number = '2.6.8';
UPDATE versions SET site_branch_build_number = '?' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2017-03-13
-- Fixed bug on drug type and treatment type check
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE drugs SET type = CONCAT(type, ' medication') WHERE type in ('other diseases');
UPDATE versions SET branch_build_number = '6666' WHERE version_number = '2.6.8';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2017-03-27
-- Added message 'whatman paper should not be created anymore'
-- Added tissue core
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET @aliquot_control_id = (SELECT ac.id FROM sample_controls sc INNER JOIN aliquot_controls ac ON ac.sample_control_id = sc.id WHERE sample_type = 'tissue' AND aliquot_type = 'core');
UPDATE aliquot_controls SET flag_active=true WHERE id = @aliquot_control_id;
UPDATE realiquoting_controls SET flag_active=true WHERE child_aliquot_control_id = @aliquot_control_id;

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('whatman paper should not be created anymore', 'Whatman paper should not be created anymore', 'Le papier whatman ne devrait plus être créé');

UPDATE drugs SET type = CONCAT(type, ' medication') WHERE type in ('other diseases');
UPDATE versions SET branch_build_number = '6680' WHERE version_number = '2.6.8';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2017-??-??
-- Update realiquoting_datetime to fix bug happened on procurecentral
-- Query should be executed on all server
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE realiquotings SET realiquoting_datetime = NULL WHERE CAST(realiquoting_datetime AS CHAR(20)) = '0000-00-00 00:00:00';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6710', site_branch_build_number = '?' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NEW UPDATE 2017-06-15
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CRPC

SELECT "Please validate Annotation Note Type 'CRPC' exists on the local installation (to do if section above is empty)" as '###MESSAGE###'
UNION ALL
SELECT 'CRPC value still created on the local version of ATiM' as '###MESSAGE###' FROM structure_permissible_values_customs WHERE value = 'CRPC' AND control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Note Types');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_CRPC', 'yes_no',  NULL , '0', '', '', '', 'CRPC', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_CRPC' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='CRPC' AND `language_tag`=''), '0', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO i18n (id,en,fr) VALUE ('CRPC', 'CRPC', 'CRPC');

UPDATE structure_formats SET `display_order`='44', `language_heading`='CRPC' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_CRPC' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Follow-up report

UPDATE structure_fields SET sortable = 0 WHERE field LIKE 'procure_next_followup_%';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_next_followup_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-17' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `language_label`='participant identifier' AND `language_tag`='' AND `type`='input' AND `setting`='size=20,class=range file' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_participant identifier' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
UPDATE structure_fields SET `type`='input' WHERE model='0' AND tablename='' AND field='procure_next_followup_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET `type`='input' WHERE model='0' AND tablename='' AND field='procure_next_followup_finish_date' AND `type`='date' AND structure_value_domain  IS NULL ;
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('visit date', 'Visit Date', 'Date de visite'),
('blood collection', 'Blood Collection', 'Collection de sang'),
('urine collection', 'Urine Collection', 'Collection de''urine'),
('followup date', 'Followup Date', 'Date de suivi'),
('collected by', 'Collected by', 'Collecté(e) par'),
('yellow', 'Yellow', 'Jaune'),
('blood collection', 'Blood Collection', 'Collection de sang'),
('purple', 'Purple', 'Mauve'),
('brown', 'Brown', 'Marron');

-- Dx & Tx Report

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_first_clinical_recurrence_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_clinical_exam_sites') , '0', '', '', '', '', 'site');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_first_clinical_recurrence_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_clinical_exam_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='site'), '0', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('procure_first_clinical_recurrence_test_help', "First 'Clinical Exam' flagged as clinical relapse into the system after prostatectomy.", "Premier 'Examen clinique' défini comme 'Récidive clinique' après la prostatectomie.");
UPDATE structure_fields SET language_label = 'clinical relapse', language_help = 'procure_first_clinical_recurrence_test_help' WHERE field = 'procure_first_clinical_recurrence_date';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_first_positive_exam_date', 'date',  NULL , '0', '', '', '', 'first positive exam', ''), 
('Datamart', '0', '', 'procure_first_positive_exam_test', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_clinical_exam_types') , '0', '', '', '', '', 'exam'), 
('Datamart', '0', '', 'procure_first_positive_exam_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_clinical_exam_sites') , '0', '', '', '', '', 'site');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_first_positive_exam_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first positive exam' AND `language_tag`=''), '0', '78', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_first_positive_exam_test' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_clinical_exam_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='exam'), '0', '79', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_first_positive_exam_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_clinical_exam_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='site'), '0', '80', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET language_help = 'procure_first_positive_exam_test_help' WHERE field = 'procure_first_positive_exam_test';
INSERT INTO i18n (id,en,fr) VALUES ('procure_first_positive_exam_test_help', "First 'Clinical Exam' flagged as positive into the system after prostatectomy.", "Premier 'Examen clinique' défini comme positif après la prostatectomie.");
INSERT INTO i18n (id,en,fr) values ('first positive exam', 'First Positive Exam', '1er examen positif');

-- Dx & Tx Report

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `associated_datamart_structure_id`, `limit_access_from_datamart_structrue_function`) 
VALUES
(null, 'procure bank activity report', 'procure bank activity report description', 'procure_report_criteria_and_result', 'procure_bank_activity_report', 'detail', 'procureBankActivityReport', 1, null, 0);
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('procure bank activity report', 'PROCURE - Bank Activity Report', 'PROCURE - Rapport d''activités de banque'),
('procure bank activity report description', 
'Number of new records into ATiM for different types of data (Participant visit, Sample Collection, RNa extraction, etc) for a period of time.', 
'Nombre de nouveaux enregistrements dans ATiM pour différents types de données (visite de participants, collections d''échantillons, extraction d''ARN, etc.) pour une période donnée.');

INSERT INTO structures(`alias`) VALUES ('procure_bank_activity_report');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_nbr_of_participants_with_collection_and_visit', 'integer',  NULL , '0', 'size=3', '', '', 'encountered patients', ''), 
('Datamart', '0', '', 'procure_nbr_of_participants_with_collection', 'integer',  NULL , '0', 'size=3', '', '', 'encountered patients with collection', ''), 
('Datamart', '0', '', 'procure_nbr_of_participants_with_visit_only', 'integer',  NULL , '0', 'size=3', '', '', 'encountered patients with collection with no collection', ''), 
('Datamart', '0', '', 'procure_nbr_of_participants_with_collection_post_bcr', 'integer',  NULL , '0', 'size=3', '', '', 'encountered patients with collection post bcr', ''), 
('Datamart', '0', '', 'procure_nbr_of_participants_with_collection_pre_bcr', 'integer',  NULL , '0', 'size=3', '', '', 'encountered patients with collection pre bcr', ''), 
('Datamart', '0', '', 'procure_nbr_of_participants_with_pbmc_extraction', 'integer',  NULL , '0', 'size=3', '', '', 'patients whose pbmc has been extracted', ''), 
('Datamart', '0', '', 'procure_nbr_of_participants_with_rna_extraction', 'integer',  NULL , '0', 'size=3', '', '', 'patients whose rna has been extracted', ''), 
('Datamart', '0', '', 'procure_nbr_of_participants_with_clinical_data_update', 'integer',  NULL , '0', 'size=3', '', '', 'patients whose clinical data have been updated', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_collection_and_visit'), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_collection'), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_visit_only'), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_collection_post_bcr'), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_collection_pre_bcr'), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_pbmc_extraction'), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_rna_extraction'), '0', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_participants_with_clinical_data_update'), '0', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('encountered patients', 'Encountered patients', "Patients recontrés"),
('encountered patients with collection', 'Encountered patients with collection', "Patients recontrés avec collection"),
('encountered patients with collection with no collection', 'Encountered patients with collection with no collection', "Patients recontrés sans collection"),
('encountered patients with collection post bcr', 'Encountered patients with collection post bcr', "Patients recontrés avec collection post 'BCR'"),
('encountered patients with collection pre bcr', 'Encountered patients with collection pre bcr', "Patients recontrés avec collection pré 'BCR'"),
('patients whose pbmc has been extracted', 'Patients whose pbmc has been extracted', "Patients dont le pbmc a été extrait"),
('patients whose rna has been extracted', 'Patients whose rna has been extracted', "Patients dont l'ARN a été extrait"),
('patients whose clinical data have been updated', 'Patients whose clinical data have been updated', "Patients dont les données cliniques ont été mises à jour");

-- SOP

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sop' AND `language_tag`=''), '0', '400', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/Sop/SopMasters/%';
UPDATE sop_controls SET flag_active = 0;
INSERT INTO `sop_controls` (`id`, `sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(0, 'inventory', 'procure', 'sopd_inventory_alls', 'sopd_inventory_all', '', '', 0, NULL, 0, NULL, 0, 1);
UPDATE structure_fields SET  `type`='input',  `structure_value_domain`= NULL ,  `setting`='size=5' WHERE model='SopMaster' AND tablename='sop_masters' AND field='version' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_sop_verisons');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
SELECT CONCAT(username, '[', IFNULL(first_name, ''), ' ', IFNULL(last_name, ''), ']') "###MESSAGE### Following user will be repalced by 'system' user for any datamigration, etc" from users where id = 2;
UPDATE users set flag_active = 0, username = 'system', last_name = '', first_name = '', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 2;
SET @created_by = (SELECT id FROM users where username = 'system');
SET @created = (SELECT NOW() FROM users where username = 'system'); 
INSERT INTO sop_masters(`code`, `version`, `status`, `sop_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Prot. PBMC', '001', 'activated', (SELECT id FROM sop_controls WHERE type = 'procure'), @created, @created, @created_by, @created_by);
INSERT INTO sopd_inventory_alls (`sop_master_id`) (SELECT id FROM sop_masters WHERE code = 'Prot. PBMC');
INSERT INTO sop_masters_revs(`code`, `version`, `status`, `sop_control_id`, `modified_by`, `id`, `version_created`) 
(SELECT `code`, `version`, `status`, `sop_control_id`, `modified_by`, `id`, `modified` FROM sop_masters WHERE code = 'Prot. PBMC');
INSERT INTO sopd_inventory_alls_revs (`sop_master_id`, version_created) (SELECT id, modified FROM sop_masters WHERE code = 'Prot. PBMC');
UPDATE sample_masters 
SET sop_master_id = (SELECT id FROM sop_masters WHERE code = 'Prot. PBMC'), modified =  @created, modified_by = @created_by
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc')
AND deleted <> 1;
INSERT INTO sample_masters_revs(id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, 
parent_sample_type, sop_master_id, product_code, is_problematic, notes, procure_created_by_bank, modified_by, version_created)
(SELECT id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, 
parent_sample_type, sop_master_id, product_code, is_problematic, notes, procure_created_by_bank, modified_by, modified
FROM sample_masters WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc')
AND modified =  @created AND modified_by = @created_by);
INSERT INTO derivative_details_revs (sample_master_id, creation_site, creation_by, creation_datetime, lab_book_master_id, sync_with_lab_book, version_created, creation_datetime_accuracy)
(SELECT sample_master_id, creation_site, creation_by, creation_datetime, lab_book_master_id, sync_with_lab_book, modified, creation_datetime_accuracy
FROM derivative_details INNER JOIN sample_masters ON id = sample_master_id
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc')
AND modified =  @created AND modified_by = @created_by);
INSERT INTO sd_der_pbmcs_revs (sample_master_id, version_created)
(SELECT sample_master_id, modified
FROM sd_der_pbmcs INNER JOIN sample_masters ON id = sample_master_id
WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc')
AND modified =  @created AND modified_by = @created_by);
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('time past (months)', 'Time past (months)', 'Temps écoulé (mois)'),
('last testosterone - nmol/l', 'Last Testosterone (nmol/l)', 'Dernière Téstostérone (nmol/l)');

-- Treatment

UPDATE structure_fields SET  `language_label`='dose' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='dosage' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='frequency' WHERE model='TreatmentDetail' AND tablename='procure_txd_treatments' AND field='duration' AND `type`='input' AND structure_value_domain  IS NULL ;

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Types (PROCURE values only)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('immunotherapy' ,'Immunotherapy', 'Immunothérapie', '1', @control_id, NOW(), '1', NOW(), '1');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('immunotherapy','immunotherapy');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type"), 
(SELECT id FROM structure_permissible_values WHERE value="immunotherapy" AND language_alias="immunotherapy"), "1", "1");
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('immunotherapy' ,'Immunotherapy', 'Immunothérapie');

-- ....

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='notes' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- PBMC

UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_sd_pbmcs') WHERE sample_type = 'pbmc';
ALTER TABLE sd_der_pbmcs ADD COLUMN procure_blood_volume_used_ml decimal(10,5) DEFAULT NULL;
ALTER TABLE sd_der_pbmcs_revs ADD COLUMN procure_blood_volume_used_ml decimal(10,5) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('procure_sd_pbmcs');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_pbmcs', 'procure_blood_volume_used_ml', 'float_positive',  NULL , '0', 'size=5', '', '', 'blood volume used ml', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_sd_pbmcs'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_pbmcs' AND `field`='procure_blood_volume_used_ml' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='blood volume used ml' AND `language_tag`=''), '2', '500', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUEs ('blood volume used ml', 'Blood Volume Used (ml)', 'Volume Sang Utilisé (ml)');
UPDATE structure_formats SET `display_column`='0', `display_order`='698', `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_pbmc_tube') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_time_at_minus_80_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='697' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_pbmc_tube') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_date_at_minus_80' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr)
VALUES
('date at -80', 'Date at -80°C (Temporary Storage)', 'Date -80°C (Entreposage temporaire)');
INSERT INTO i18n (id,en,fr)
VALUES
('storage dates precisions do not allow system to calculate the days at -80',
'Storage dates precisions do not allow system to calculate the days at -80°C',
"Les précisions des dates d'entreposage ne permettent pas au système de calculer les jours à -80°C");

SET @aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc'));
SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users where username = 'system'); 
UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail
SET AliquotDetail.procure_time_at_minus_80_days = DATEDIFF(AliquotMaster.storage_datetime, AliquotDetail.procure_date_at_minus_80),
AliquotMaster.modified = @modified,
AliquotMaster.modified_by = @modified_by
WHERE AliquotMaster.id = AliquotDetail.aliquot_master_id
AND AliquotMaster.aliquot_control_id = @aliquot_control_id
AND AliquotMaster.storage_datetime_accuracy IN ('c', '', 'h', 'i')
AND AliquotDetail.procure_date_at_minus_80_accuracy = 'c'
AND AliquotDetail.procure_date_at_minus_80 <= AliquotMaster.storage_datetime
AND (AliquotDetail.procure_time_at_minus_80_days IS NULL OR AliquotDetail.procure_time_at_minus_80_days != DATEDIFF(AliquotMaster.storage_datetime, AliquotDetail.procure_date_at_minus_80))
AND AliquotMaster.deleted <> 1;
INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, 
study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, 
procure_created_by_bank,
modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, 
study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, 
procure_created_by_bank,
modified_by, modified
FROM aliquot_masters WHERE modified = @modified AND modified_by = @modified_by AND aliquot_control_id = @aliquot_control_id);
INSERT INTO ad_tubes_revs (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, 
procure_deprecated_field_expiration_date, procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop,
procure_time_at_minus_80_days, procure_date_at_minus_80, procure_date_at_minus_80_accuracy,
version_created)
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, 
procure_deprecated_field_expiration_date, procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop,
procure_time_at_minus_80_days, procure_date_at_minus_80, procure_date_at_minus_80_accuracy,
modified
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE modified = @modified AND modified_by = @modified_by AND aliquot_control_id = @aliquot_control_id);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Versions....
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6739', site_branch_build_number = '????' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Versions....
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6743', site_branch_build_number = '????' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;


-- Claire veut changer un type de drug.
-- Importer le site de lucie sur central. Voire pourquoi si on cherche bcr sur central.... on a un site sans sans le flag du site 'PS...' comme PS1, PS2, etc.
-- Voir si on peut nettoyer les données des sites. Ex: Clinical Exam les champs positif, clinical replase peuvent etre compltetes a partir des notes;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- -1- Path review batch entry
--
--   From an excel file, create a path review entry for many samples and many collections.
--
-- -2- Merge data of processing site and cusm
--   
--   Keep sample as processing site samples.
--
-- -3- Use ICD03 topo code for any value of tissue site
--   
--   See email sent to Valerie on 2017-02-24 with the list of values (ICD-O-3 Topo (International classification) && Clinical Exam - Sites (PROCURE Defintion)
--     &&  Treatment Sites (PROCURE Defintion) && Other Tumor Site (PROCURE Defintion based on ICD-O-/ Topo))
-- 
-- -4- Mettre champ du site dans le label (ex: Protocol (Ch. CUSM)
-- 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
