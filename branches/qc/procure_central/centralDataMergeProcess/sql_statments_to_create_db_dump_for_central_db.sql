-- Participants

-- Delete first name and last name
-- Replace any date of birth by 'year_of_birth-01-01'

UPDATE participants SET first_name = 'confid.', last_name = 'confid.', notes = '';
UPDATE participants SET date_of_birth = CONCAT(SUBSTR(date_of_birth, 1, 4),'-01-01');
UPDATE participants SET date_of_birth_accuracy = 'm' WHERE date_of_birth_accuracy IN ('c','d');

UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'chum', 'ps1');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'chuq', 'ps2');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'cusm', 'ps3');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'muhc', 'ps3');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'chus', 'ps4');

-- Keep only the study participant identifiers

DELETE FROM misc_identifiers WHERE misc_identifier_control_id NOT IN (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name IN ('participant study number'));
UPDATE misc_identifier_controls SET misc_identifier_name = id WHERE misc_identifier_name NOT IN ('participant study number');

-- Remove pathology number

UPDATE procure_ed_lab_pathologies SET path_number = 'confid.';
UPDATE sd_spe_tissues SET procure_report_number = 'confid.';

CREATE TABLE atim_procure_dump_information (created datetime NOT NULL);;
INSERT INTO atim_procure_dump_information (created) (SELECT NOW() FROM aliquot_controls LIMIT 0 ,1);

-- Replace aliquot use and event type having bank names

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');

UPDATE structure_permissible_values_customs SET value = 'sent to ps1', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to chum';
UPDATE structure_permissible_values_customs SET value = 'received from ps1', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from chum';

UPDATE structure_permissible_values_customs SET value = 'sent to ps2', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to chuq';
UPDATE structure_permissible_values_customs SET value = 'received from ps2', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from chuq';

UPDATE structure_permissible_values_customs SET value = 'sent to ps3', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to muhc';
UPDATE structure_permissible_values_customs SET value = 'received from ps3', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from muhc';

UPDATE structure_permissible_values_customs SET value = 'sent to ps4', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to chus';
UPDATE structure_permissible_values_customs SET value = 'received from ps4', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from chus';
received from chum
-- study

ALTER TABLE `study_summaries`
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chum` `procure_site_ethics_committee_convenience_ps1` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chus` `procure_site_ethics_committee_convenience_ps4` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chuq` `procure_site_ethics_committee_convenience_ps2` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_cusm` `procure_site_ethics_committee_convenience_ps3` char(1) DEFAULT '';
  
-- ------------------------------------------------------------------------------------------------------------------------
-- CHUM specific PS1
-- ------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_', 'ps1_');
UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_', 'ps1_');
UPDATE sample_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_', 'ps1_');

UPDATE structure_value_domains SET domain_name = REPLACE(domain_name, 'qc_nd_', 'ps1_'); 

UPDATE event_masters SET event_summary = REPLACE(event_summary, 'chum', 'ps1');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CHUM', 'ps1');
UPDATE sample_masters SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE sample_masters SET notes = REPLACE(notes, 'CHUM', 'ps1');
UPDATE storage_masters SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE storage_masters SET notes = REPLACE(notes, 'CHUM', 'ps1');

ALTER TABLE ad_blocks 
    DROP COLUMN qc_nd_gleason_primary_grade, 
    DROP COLUMN qc_nd_gleason_secondary_grade, 
    DROP COLUMN qc_nd_tissue_primary_desc,
    DROP COLUMN qc_nd_tissue_secondary_desc, 
    DROP COLUMN qc_nd_tumor_presence,
    DROP COLUMN qc_nd_sample_position_code; 
ALTER TABLE ad_tubes 
    DROP COLUMN qc_nd_storage_solution, 
    DROP COLUMN qc_nd_purification_method; 
ALTER TABLE aliquot_masters
    DROP COLUMN qc_nd_stored_by; 
ALTER TABLE aliquot_masters_revs 
    DROP COLUMN qc_nd_stored_by; 
ALTER TABLE participants 
    DROP COLUMN qc_nd_last_contact; 
ALTER TABLE procure_ed_lab_pathologies 
    DROP COLUMN qc_nd_margins_extensive_apex; 
ALTER TABLE sd_der_dnas 
    DROP COLUMN qc_nd_extraction_method; 
ALTER TABLE sd_der_rnas 
    DROP COLUMN qc_nd_extraction_method; 
ALTER TABLE sd_der_urine_cents 
    DROP COLUMN qc_nd_pellet_presence;
ALTER TABLE procure_ed_lab_pathologies 
    DROP COLUMN qc_nd_surgeon;

ALTER TABLE procure_cd_sigantures
  CHANGE COLUMN `qc_nd_biological_material_use` `ps1_biological_material_use` varchar(50) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_use_of_urine` `ps1_use_of_urine` varchar(50) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_use_of_blood` `ps1_use_of_blood` varchar(50) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_research_other_disease` `ps1_research_other_disease` varchar(50) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_urine_blood_use_for_followup` `ps1_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_stop_followup` `ps1_stop_followup` varchar(10) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_stop_followup_date` `ps1_stop_followup_date` date DEFAULT NULL,
  CHANGE COLUMN `qc_nd_allow_questionnaire` `ps1_allow_questionnaire` varchar(10) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_stop_questionnaire` `ps1_stop_questionnaire` varchar(10) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_stop_questionnaire_date` `ps1_stop_questionnaire_date` date DEFAULT NULL,
  CHANGE COLUMN `qc_nd_contact_for_additional_data` `ps1_contact_for_additional_data` varchar(10) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_inform_significant_discovery` `ps1_inform_significant_discovery` varchar(50) DEFAULT NULL,
  CHANGE COLUMN `qc_nd_inform_discovery_on_other_disease` `ps1_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL;

-- ------------------------------------------------------------------------------------------------------------------------
-- CHUQ specific PS2
-- ------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'procure_chuq_', 'ps2_');
UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'procure_chuq_', 'ps2_');
UPDATE sample_controls SET detail_form_alias = REPLACE(detail_form_alias, 'procure_chuq_', 'ps2_');

UPDATE structure_value_domains SET domain_name = REPLACE(domain_name, 'procure_chuq_', 'ps2_'); 

UPDATE event_masters SET event_summary = REPLACE(event_summary, 'chuq', 'ps2');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CHUQ', 'ps2');
UPDATE sample_masters SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE sample_masters SET notes = REPLACE(notes, 'CHUQ', 'ps2');
UPDATE storage_masters SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE storage_masters SET notes = REPLACE(notes, 'CHUQ', 'ps2');

ALTER TABLE ad_tubes
    DROP COLUMN procure_chuq_micro_rna;
ALTER TABLE participants
    DROP COLUMN procure_chuq_cause_of_death_details,
    DROP COLUMN procure_chuq_deprecated_last_contact_date,
    DROP COLUMN procure_chuq_deprecated_last_contact_date_accuracy,
    DROP COLUMN procure_chuq_deprecated_stop_followup,
    DROP COLUMN procure_chuq_stop_followup_date,
    DROP COLUMN procure_chuq_stop_followup_date_accuracy;
ALTER TABLE procure_ed_laboratories
    DROP COLUMN procure_chuq_minimum;
ALTER TABLE procure_ed_other_tumor_diagnosis
    DROP COLUMN event_master_id,
    DROP COLUMN tumor_site,
    DROP COLUMN procure_chuq_deprecated_icd10_code;
ALTER TABLE procure_ed_questionnaires
    DROP COLUMN procure_chuq_deprecated_complete_at_recovery;
ALTER TABLE procure_txd_treatments
    DROP COLUMN procure_chuq_protocol,
    DROP COLUMN procure_chuq_deprecated_surgeon,
    DROP COLUMN procure_chuq_deprecated_laparotomy,
    DROP COLUMN procure_chuq_deprecated_laparoscopy;
ALTER TABLE quality_ctrls
    DROP COLUMN procure_chuq_deprecated_visual_quality;
ALTER TABLE sd_der_rnas
    DROP COLUMN procure_chuq_deprecated_extraction_number,
    DROP COLUMN procure_chuq_deprecated_dnase_duration_mn,
    DROP COLUMN procure_chuq_extraction_method;
ALTER TABLE sd_der_urine_cents
    DROP COLUMN procure_chuq_deprecated_concentration_ratio,
    DROP COLUMN procure_chuq_deprecated_pellet;
ALTER TABLE sd_spe_tissues
    DROP COLUMN procure_chuq_collected_prostate_slice_weight_gr;
  
ALTER TABLE procure_cd_sigantures
  CHANGE COLUMN `procure_chuq_tissue` `ps2_tissue` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_blood` `ps2_blood` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_urine` `ps2_urine` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_followup` `ps2_followup` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_questionnaire` `ps2_questionnaire` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_contact_for_additional_data` `ps2_contact_for_additional_data` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_inform_significant_discovery` `ps2_inform_significant_discovery` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_contact_in_case_of_death` `ps2_contact_in_case_of_death` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_witness` `ps2_witness` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chuq_complete` `ps2_complete` char(1) DEFAULT '';  
  
-- ------------------------------------------------------------------------------------------------------------------------
-- CUSM specific PS3
-- ------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'cusm_', 'ps3_');
UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'cusm_', 'ps3_');
UPDATE sample_controls SET detail_form_alias = REPLACE(detail_form_alias, 'cusm_', 'ps3_');

UPDATE structure_value_domains SET domain_name = REPLACE(domain_name, 'cusm_', 'ps3_'); 

UPDATE event_masters SET event_summary = REPLACE(event_summary, 'muhc', 'ps3');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'MUCH', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'MUCH', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'MUCH', 'ps3');

UPDATE event_masters SET event_summary = REPLACE(event_summary, 'cusm', 'ps3');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CUSM', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'CUSM', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'CUSM', 'ps3');
  
ALTER TABLE procure_ed_lab_pathologies
    DROP COLUMN cusm_deprecated_marg_ext_seminal_vesicles_right,
    DROP COLUMN cusm_deprecated_marg_ext_seminal_vesicles_left,
    DROP COLUMN cusm_deprecated_e_p_ext_apex_right_anterior,
    DROP COLUMN cusm_deprecated_e_p_ext_apex_left_anterior,
    DROP COLUMN cusm_deprecated_e_p_ext_apex_right_posterior,
    DROP COLUMN cusm_deprecated_e_p_ext_apex_left_posterior,
    DROP COLUMN cusm_deprecated_e_p_ext_base_right_anterior,
    DROP COLUMN cusm_deprecated_e_p_ext_base_left_anterior,
    DROP COLUMN cusm_deprecated_e_p_ext_base_right_posterior,
    DROP COLUMN cusm_deprecated_e_p_ext_base_left_posterior,
    DROP COLUMN cusm_deprecated_e_p_ext_seminal_vesicles_right,
    DROP COLUMN cusm_deprecated_e_p_ext_seminal_vesicles_left;
ALTER TABLE procure_txd_treatments
    DROP COLUMN procure_cusm_protocol` varchar(50) DEFAULT NULL; 
 
-- ------------------------------------------------------------------------------------------------------------------------
-- CHUS specific PS4
-- ------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'chus_', 'ps4_');
UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'chus_', 'ps4_');
UPDATE sample_controls SET detail_form_alias = REPLACE(detail_form_alias, 'chus_', 'ps4_');

UPDATE structure_value_domains SET domain_name = REPLACE(domain_name, 'chus_', 'ps4_'); 

UPDATE event_masters SET event_summary = REPLACE(event_summary, 'chus', 'ps4');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CHUS', 'ps4');
UPDATE sample_masters SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE sample_masters SET notes = REPLACE(notes, 'CHUS', 'ps4');
UPDATE storage_masters SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE storage_masters SET notes = REPLACE(notes, 'CHUS', 'ps4');
  
ALTER TABLE ad_blocks
    DROP COLUMN procure_chus_classification_precision,
    DROP COLUMN procure_chus_origin_of_slice_precision;  
ALTER TABLE collections
    DROP COLUMN procure_chus_collection_specimen_sample_control_id;

  KEY `FK_procure_chus_sample_masters_sample_controls` (`procure_chus_collection_specimen_sample_control_id`),
  CONSTRAINT `FK_procure_chus_sample_masters_sample_controls` FOREIGN KEY (`procure_chus_collection_specimen_sample_control_id`) REFERENCES `sample_controls` (`id`)

ALTER TABLE procure_ed_lab_pathologies
    DROP COLUMN chus_histology_acinar_adenocarcinoma,
    DROP COLUMN chus_histology_adenosquamous_carcinoma,
    DROP COLUMN chus_histology_mucinous_adenocarcinoma,
    DROP COLUMN chus_histology_other,
    DROP COLUMN chus_histology_prostatic_ductal_adenocarcinoma,
    DROP COLUMN chus_histology_sarcomatoid_carcinoma,
    DROP COLUMN chus_histology_signet_ring_cell_carcinoma,
    DROP COLUMN chus_histology_small_cell_carcinoma;  
  
ALTER TABLE procure_cd_sigantures
  CHANGE COLUMN `procure_chus_contact_for_more_info` `ps4_contact_for_more_info` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_contact_if_scientific_discovery` `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_study_on_other_diseases` `ps4_study_on_other_diseases` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_contact_if_discovery_on_other_diseases` `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
  CHANGE COLUMN `procure_chus_other_contacts_in_case_of_death` `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '';



