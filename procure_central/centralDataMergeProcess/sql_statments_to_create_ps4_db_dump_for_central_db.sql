-- Participants
-- ..................................................................................................................
-- Delete first name, last name and notes
-- Replace any date of birth by 'year_of_birth-01-01'

UPDATE participants SET first_name = 'confid.', last_name = 'confid.', notes = '';
UPDATE participants SET date_of_birth = CONCAT(SUBSTR(date_of_birth, 1, 4),'-01-01');
UPDATE participants SET date_of_birth_accuracy = 'm' WHERE date_of_birth_accuracy IN ('c','d');

UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'chum', 'ps1');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'CHUM', 'ps1');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'chuq', 'ps2');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'CHUQ', 'ps2');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'muhc', 'ps3');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'MUHC', 'ps3');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'cusm', 'ps3');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'CUSM', 'ps3');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'chus', 'ps4');
UPDATE participants SET procure_patient_withdrawn_reason = REPLACE(procure_patient_withdrawn_reason, 'CHUS', 'ps4');

-- Participant Indetifiers (RAMQ, Hospital Numbers, etc)
-- ..................................................................................................................
-- Keep only the study participant identifiers

DELETE FROM misc_identifiers WHERE misc_identifier_control_id NOT IN (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name IN ('participant study number'));
UPDATE misc_identifier_controls SET misc_identifier_name = id WHERE misc_identifier_name NOT IN ('participant study number');

-- Event & Treatment
-- ..................................................................................................................
-- Manage notes with banks names

UPDATE event_masters SET event_summary = REPLACE(event_summary, 'chum', 'ps1');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CHUM', 'ps1');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'chuq', 'ps2');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CHUQ', 'ps2');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'muhc', 'ps3');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'MUHC', 'ps3');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'cusm', 'ps3');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CUSM', 'ps3');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'chus', 'ps4');
UPDATE event_masters SET event_summary = REPLACE(event_summary, 'CHUS', 'ps4');

UPDATE treatment_masters SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE treatment_masters SET notes = REPLACE(notes, 'CHUM', 'ps1');
UPDATE treatment_masters SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE treatment_masters SET notes = REPLACE(notes, 'CHUQ', 'ps2');
UPDATE treatment_masters SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE treatment_masters SET notes = REPLACE(notes, 'MUHC', 'ps3');
UPDATE treatment_masters SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE treatment_masters SET notes = REPLACE(notes, 'CUSM', 'ps3');
UPDATE treatment_masters SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE treatment_masters SET notes = REPLACE(notes, 'CHUS', 'ps4');

-- Pathology Report
-- ..................................................................................................................
-- Remove pathology number

UPDATE procure_ed_lab_pathologies SET path_number = 'confid.';
UPDATE sd_spe_tissues SET procure_report_number = 'confid.';

-- Collection
-- ..................................................................................................................

UPDATE collections SET collection_notes = REPLACE(collection_notes, 'chum', 'ps1');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'CHUM', 'ps1');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'chuq', 'ps2');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'CHUQ', 'ps2');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'muhc', 'ps3');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'MUHC', 'ps3');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'cusm', 'ps3');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'CUSM', 'ps3');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'chus', 'ps4');
UPDATE collections SET collection_notes = REPLACE(collection_notes, 'CHUS', 'ps4');

-- Sample
-- ..................................................................................................................

UPDATE sample_masters SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE sample_masters SET notes = REPLACE(notes, 'CHUM', 'ps1');
UPDATE sample_masters SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE sample_masters SET notes = REPLACE(notes, 'CHUQ', 'ps2');
UPDATE sample_masters SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'MUHC', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'CUSM', 'ps3');
UPDATE sample_masters SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE sample_masters SET notes = REPLACE(notes, 'CHUS', 'ps4');

-- Aliquot & Storage
-- ..................................................................................................................
-- Remove bank names from 'aliquot use and event type' 

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
UPDATE structure_permissible_values_customs SET value = 'sent to ps1', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to chum';
UPDATE structure_permissible_values_customs SET value = 'received from ps1', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from chum';
UPDATE structure_permissible_values_customs SET value = 'sent to ps2', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to chuq';
UPDATE structure_permissible_values_customs SET value = 'received from ps2', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from chuq';
UPDATE structure_permissible_values_customs SET value = 'sent to ps3', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to muhc';
UPDATE structure_permissible_values_customs SET value = 'received from ps3', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from muhc';
UPDATE structure_permissible_values_customs SET value = 'sent to ps4', en = '', fr = '' WHERE control_id = @control_id AND value = 'sent to chus';
UPDATE structure_permissible_values_customs SET value = 'received from ps4', en = '', fr = '' WHERE control_id = @control_id AND value = 'received from chus';

UPDATE aliquot_masters SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'CHUM', 'ps1');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'CHUQ', 'ps2');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'MUHC', 'ps3');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'CUSM', 'ps3');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE aliquot_masters SET notes = REPLACE(notes, 'CHUS', 'ps4');

UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'CHUM', 'ps1');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'CHUQ', 'ps2');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'MUHC', 'ps3');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'CUSM', 'ps3');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE aliquot_masters_revs SET notes = REPLACE(notes, 'CHUS', 'ps4');

UPDATE storage_masters SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE storage_masters SET notes = REPLACE(notes, 'CHUM', 'ps1');
UPDATE storage_masters SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE storage_masters SET notes = REPLACE(notes, 'CHUQ', 'ps2');
UPDATE storage_masters SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'MUHC', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'CUSM', 'ps3');
UPDATE storage_masters SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE storage_masters SET notes = REPLACE(notes, 'CHUS', 'ps4');

UPDATE storage_masters_revs SET notes = REPLACE(notes, 'chum', 'ps1');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'CHUM', 'ps1'); 
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'chuq', 'ps2');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'CHUQ', 'ps2');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'muhc', 'ps3');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'MUHC', 'ps3');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'cusm', 'ps3');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'CUSM', 'ps3');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'chus', 'ps4');
UPDATE storage_masters_revs SET notes = REPLACE(notes, 'CHUS', 'ps4'); 
  
-- Study
-- ..................................................................................................................
-- Rename study fields with banks names

ALTER TABLE `study_summaries`
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chum` `procure_site_ethics_committee_convenience_ps1` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chus` `procure_site_ethics_committee_convenience_ps4` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chuq` `procure_site_ethics_committee_convenience_ps2` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_cusm` `procure_site_ethics_committee_convenience_ps3` char(1) DEFAULT '';
  
-- ..................................................................................................................
-- Generate date of script creation
  
CREATE TABLE atim_procure_dump_information (created datetime NOT NULL);;
INSERT INTO atim_procure_dump_information (created) (SELECT NOW() FROM aliquot_controls LIMIT 0 ,1);
  
-- ------------------------------------------------------------------------------------------------------------------------
-- CHUS specific PS4
-- ------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'chus_', 'ps4_');
UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'chus_', 'ps4_');
UPDATE sample_controls SET detail_form_alias = REPLACE(detail_form_alias, 'chus_', 'ps4_');

UPDATE structure_value_domains SET domain_name = REPLACE(domain_name, 'chus_', 'ps4_');  

ALTER TABLE ad_blocks
    DROP COLUMN procure_chus_classification_precision,
    DROP COLUMN procure_chus_origin_of_slice_precision;  
ALTER TABLE ad_tubes
    DROP COLUMN procure_chus_micro_rna;
ALTER TABLE collections 
    DROP FOREIGN KEY `FK_procure_chus_sample_masters_sample_controls`;
ALTER TABLE collections 
    DROP INDEX  `FK_procure_chus_sample_masters_sample_controls`;
ALTER TABLE collections
    DROP COLUMN procure_chus_collection_specimen_sample_control_id;

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
