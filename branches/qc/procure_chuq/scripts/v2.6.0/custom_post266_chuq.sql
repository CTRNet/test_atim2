-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Created By Bank / Collected By Bank
-- ------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE participants SET procure_last_modification_by_bank = '2';
UPDATE participants_revs SET procure_last_modification_by_bank = '2';
UPDATE consent_masters SET procure_created_by_bank = '2';
UPDATE consent_masters_revs SET procure_created_by_bank = '2';
UPDATE event_masters SET procure_created_by_bank = '2';
UPDATE event_masters_revs SET procure_created_by_bank = '2';
UPDATE treatment_masters SET procure_created_by_bank = '2';
UPDATE treatment_masters_revs SET procure_created_by_bank = '2';

UPDATE collections SET procure_collected_by_bank = '2';
UPDATE collections_revs SET procure_collected_by_bank = '2';
UPDATE sample_masters SET procure_created_by_bank = '2';
UPDATE sample_masters_revs SET procure_created_by_bank = '2';
UPDATE aliquot_masters SET procure_created_by_bank = '2';
UPDATE aliquot_masters_revs SET procure_created_by_bank = '2';
UPDATE aliquot_internal_uses SET procure_created_by_bank = '2';
UPDATE aliquot_internal_uses_revs SET procure_created_by_bank = '2';
UPDATE quality_ctrls SET procure_created_by_bank = '2';
UPDATE quality_ctrls_revs SET procure_created_by_bank = '2';

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Other Tumor Dx : ICD10 code
-- ------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE procure_ed_followup_worksheet_other_tumor_diagnosis ADD COLUMN procure_chuq_icd10_code varchar(10) DEFAULT NULL;
ALTER TABLE procure_ed_followup_worksheet_other_tumor_diagnosis_revs ADD COLUMN procure_chuq_icd10_code varchar(10) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_followup_worksheet_other_tumor_diagnosis', 'procure_chuq_icd10_code', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who', '', 'help_primary code', 'disease code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_other_tumor_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_followup_worksheet_other_tumor_diagnosis' AND `field`='procure_chuq_icd10_code'), '1', '50', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Add Consent Data
-- ------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE procure_cd_sigantures
  ADD COLUMN procure_chuq_tissue char(1) DEFAULT '',
  ADD COLUMN procure_chuq_blood char(1) DEFAULT '',
  ADD COLUMN procure_chuq_urine char(1) DEFAULT '',
  ADD COLUMN procure_chuq_followup char(1) DEFAULT '',
  ADD COLUMN procure_chuq_questionnaire char(1) DEFAULT '',
  ADD COLUMN procure_chuq_contact_for_additional_data char(1) DEFAULT '',
  ADD COLUMN procure_chuq_inform_significant_discovery char(1) DEFAULT '',
  ADD COLUMN procure_chuq_contact_in_case_of_death char(1) DEFAULT '',
  ADD COLUMN procure_chuq_witness char(1) DEFAULT '',
  ADD COLUMN procure_chuq_complete char(1) DEFAULT '';
ALTER TABLE procure_cd_sigantures_revs
  ADD COLUMN procure_chuq_tissue char(1) DEFAULT '',
  ADD COLUMN procure_chuq_blood char(1) DEFAULT '',
  ADD COLUMN procure_chuq_urine char(1) DEFAULT '',
  ADD COLUMN procure_chuq_followup char(1) DEFAULT '',
  ADD COLUMN procure_chuq_questionnaire char(1) DEFAULT '',
  ADD COLUMN procure_chuq_contact_for_additional_data char(1) DEFAULT '',
  ADD COLUMN procure_chuq_inform_significant_discovery char(1) DEFAULT '',
  ADD COLUMN procure_chuq_contact_in_case_of_death char(1) DEFAULT '',
  ADD COLUMN procure_chuq_witness char(1) DEFAULT '',
  ADD COLUMN procure_chuq_complete char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_tissue', 'yes_no',  NULL , '0', '', '', '', 'tissue', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_blood', 'yes_no',  NULL , '0', '', '', '', 'blood', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_urine', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_followup', 'yes_no',  NULL , '0', '', '', '', 'followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_contact_for_additional_data', 'yes_no',  NULL , '0', '', '', '', 'contact for additional data', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_inform_significant_discovery', 'yes_no',  NULL , '0', '', '', '', 'inform significant discovery', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_contact_in_case_of_death', 'yes_no',  NULL , '0', '', '', '', 'contact in case of death', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_witness', 'yes_no',  NULL , '0', '', '', '', 'witness', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chuq_complete', 'yes_no',  NULL , '0', '', '', '', 'complete', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_tissue' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue' AND `language_tag`=''), '2', '20', 'details', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_blood' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blood' AND `language_tag`=''), '2', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_urine' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='urine' AND `language_tag`=''), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_followup' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup' AND `language_tag`=''), '2', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_questionnaire' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='questionnaire' AND `language_tag`=''), '2', '24', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_contact_for_additional_data' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact for additional data' AND `language_tag`=''), '2', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_inform_significant_discovery' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inform significant discovery' AND `language_tag`=''), '2', '26', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_contact_in_case_of_death' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact in case of death' AND `language_tag`=''), '2', '27', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_witness' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='witness' AND `language_tag`=''), '2', '28', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='procure_chuq_complete' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complete' AND `language_tag`=''), '2', '29', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('questionnaire', 'Questionnaire', 'questionnaire'), 	    
('contact for additional data', 'Contact for Additional Data', 'Contacter pour des données supplémentaires'), 	    
('inform significant discovery', 'Inform Significant Discovery', 'Informer découverte importante'), 	    
('contact in case of death', 'Contact in Case of Death', 'Contact en cas de décès'), 	    
('witness', 'Qitness', 'Témoin'), 	    
('complete', 'Complete', 'Complèt');

-- Linked to profile

ALTER TABLE participants
  ADD COLUMN procure_chuq_stop_followup tinyint(1) DEFAULT NULL,
  ADD COLUMN procure_chuq_stop_followup_date date DEFAULT NULL,
  ADD COLUMN procure_chuq_stop_followup_date_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN procure_chuq_stop_followup tinyint(1) DEFAULT NULL,
  ADD COLUMN procure_chuq_stop_followup_date date DEFAULT NULL,
  ADD COLUMN procure_chuq_stop_followup_date_accuracy char(1) NOT NULL DEFAULT '';  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_chuq_stop_followup', 'checkbox',  NULL , '0', '', '', '', 'stop followup', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'procure_chuq_stop_followup_date', 'date',  NULL , '0', '', '', '', '', 'stop followup date');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_stop_followup'), '3', '38', 'patient withdrawn', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_stop_followup_date'), '3', '39', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_patient_withdrawn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr)
VALUES
('stop followup','Stop Followup', 'Arrêt du suivi'), 
('stop followup date','Date', 'Date');
UPDATE structure_fields SET  `language_label`='stop followup date',  `language_tag`='' WHERE model='Participant' AND tablename='participants' AND field='procure_chuq_stop_followup_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='patient withdrawn' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_patient_withdrawn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='followup' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_stop_followup' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Box 49 available
-- ------------------------------------------------------------------------------------------------------------------------------------------------

update storage_controls SET flag_active = 1 where storage_type = 'box49';

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Surgery Data
-- ------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'procure_chuq_surgeon', 'input',  NULL , '0', '', '', '', 'surgeon', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'procure_chuq_laparotomy', 'checkbox',  NULL , '0', '', '', '', 'laparotomy', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'procure_chuq_laparoscopy', 'checkbox',  NULL , '0', '', '', '', 'laparoscopy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='procure_chuq_surgeon' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgeon' AND `language_tag`=''), '1', '40', 'surgery', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='procure_chuq_laparotomy' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laparotomy' AND `language_tag`=''), '1', '41', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='procure_chuq_laparoscopy' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laparoscopy' AND `language_tag`=''), '1', '42', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('surgeon','Curgeon','Chirurgien'),
('laparotomy', 'Laparotomy', 'Laparotomie'),
('laparoscopy', 'Laparoscopy', 'Laparoscopie');
ALTER TABLE procure_txd_followup_worksheet_treatments
  ADD COLUMN procure_chuq_surgeon varchar(60) DEFAULT NULL,
  ADD COLUMN procure_chuq_laparotomy tinyint(1) DEFAULT NULL,
  ADD COLUMN procure_chuq_laparoscopy tinyint(1) DEFAULT NULL;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs
  ADD COLUMN procure_chuq_surgeon varchar(60) DEFAULT NULL,
  ADD COLUMN procure_chuq_laparotomy tinyint(1) DEFAULT NULL,
  ADD COLUMN procure_chuq_laparoscopy tinyint(1) DEFAULT NULL;
UPDATE structure_formats SET `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('no surgery data has to be associated to the selected treatment type', 'No surgery data has to be associated to the selected treatment type','Aucune donnée de chirurgie ne doit être défini pour le type du traitement sélectionné');

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove CHUQ concentrated Urine
-- ------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE sd_der_urine_cents DROP COLUMN procure_chuq_concentrated;
ALTER TABLE sd_der_urine_cents_revs DROP COLUMN procure_chuq_concentrated;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_concentrated' AND `language_label`='concentrated' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_concentrated' AND `language_label`='concentrated' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_concentrated' AND `language_label`='concentrated' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='445' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_concentration_ratio' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='444' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_concentrated' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Added New Lab staff
-- ------------------------------------------------------------------------------------------------------------------------------------------------

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff ');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('tech. patho', '', '',  '1', @control_id, NOW(), NOW(), 1, 1);





UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '62??' WHERE version_number = '2.6.6';