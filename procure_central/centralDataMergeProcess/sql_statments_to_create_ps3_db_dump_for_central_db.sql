-- Participants
-- ..................................................................................................................
-- Delete first name, last name and notes
-- Replace any date of birth by 'year_of_birth-01-01'

UPDATE participants 
SET first_name = 'confid.', 
last_name = 'confid.', notes = '';
UPDATE participants 
SET date_of_birth = CONCAT(SUBSTR(date_of_birth, 1, 4),'-01-01');
UPDATE participants 
SET date_of_birth_accuracy = 'm' WHERE date_of_birth_accuracy IN ('c','d');

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
UPDATE misc_identifier_controls 
SET misc_identifier_name = id 
WHERE misc_identifier_name NOT IN ('participant study number');

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

UPDATE procure_ed_lab_pathologies 
SET path_number = 'confid.', 
qc_nd_surgeon = 'confid.', 
pathologist_name = 'confid.';
UPDATE sd_spe_tissues 
SET procure_report_number = 'confid.', 
procure_surgeon_name = 'confid.', 
procure_pathologist_name = 'confid.';

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
  
UPDATE study_summaries SET 
procure_principal_investigator = 'confid.',
procure_organization = 'confid.',
procure_address_street = 'confid.',
procure_address_city = 'confid.',
procure_address_province = 'confid.',
procure_address_country = 'confid.',
procure_address_postal = 'confid.',
procure_phone_number = 'confid.',
procure_fax_number = 'confid.',
procure_email = 'confid.';
 
UPDATE study_fundings 
SET study_sponsor = 'confid.', 
contact = 'confid.', 
phone_number = 'confid.', 
phone_extension = 'confid.',
fax_number = 'confid.', 
fax_extension = 'confid.', 
email = 'confid.';
  
-- Shipment
-- ..................................................................................................................
-- Rename study fields with banks names

UPDATE shipments 
SET recipient = 'confid.', 
facility = 'confid.', 
delivery_street_address = 'confid.', 
delivery_city = 'confid.', 
delivery_province = 'confid.', 
delivery_postal_code = 'confid.', 
delivery_country = 'confid.', 
delivery_phone_number = 'confid.', 
delivery_department_or_door = 'confid.', 
delivery_notes = 'confid.', 
shipping_company = 'confid.', 
shipping_account_nbr = 'confid.', 
tracking = 'confid.';
  
-- ..................................................................................................................
-- Generate date of script creation
  
CREATE TABLE atim_procure_dump_information (created datetime NOT NULL);;
INSERT INTO atim_procure_dump_information (created) (SELECT NOW() FROM aliquot_controls LIMIT 0 ,1);

-- ------------------------------------------------------------------------------------------------------------------------
-- CUSM specific PS3
-- ------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET detail_form_alias = REPLACE(detail_form_alias, 'cusm_', 'ps3_');
UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'cusm_', 'ps3_');
UPDATE sample_controls SET detail_form_alias = REPLACE(detail_form_alias, 'cusm_', 'ps3_');

UPDATE structure_value_domains SET domain_name = REPLACE(domain_name, 'cusm_', 'ps3_');

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
    DROP COLUMN procure_cusm_protocol; 
