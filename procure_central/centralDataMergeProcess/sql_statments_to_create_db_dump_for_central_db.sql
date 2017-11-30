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
-- CHUM specific
-- ------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_', 'ps1_');
UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_', 'ps1_');
UPDATE sample_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_', 'ps1_');
UPDATE structure_value_domains SET domain_name = REPLACE(domain_name, 'qc_nd_', 'ps1_'); 

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


  

  
