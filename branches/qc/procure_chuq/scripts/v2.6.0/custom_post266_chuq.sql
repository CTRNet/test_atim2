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








































UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '62??' WHERE version_number = '2.6.6';