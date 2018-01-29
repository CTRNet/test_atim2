-- Participants
-- ..................................................................................................................
-- Delete first name, last name and notes
-- Replace any date of birth by 'year_of_birth-01-01'

UPDATE participants 
SET first_name = 'confid.', 
last_name = 'confid.', 
notes = 'confid.';
UPDATE participants 
SET date_of_birth = CONCAT(SUBSTR(date_of_birth, 1, 4),'-01-01');
UPDATE participants 
SET date_of_birth_accuracy = 'm' WHERE date_of_birth_accuracy IN ('c','d');

UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'chum', 'ps1');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'CHUM', 'ps1');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'chuq', 'ps2');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'CHUQ', 'ps2');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'muhc', 'ps3');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'MUHC', 'ps3');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'cusm', 'ps3');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'CUSM', 'ps3');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'chus', 'ps4');
UPDATE participants SET procure_patient_refusal_withdrawal_reason = REPLACE(procure_patient_refusal_withdrawal_reason, 'CHUS', 'ps4');

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

UPDATE collections SET collection_site = 'confid.';

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

UPDATE specimen_details SET supplier_dept = 'confid.';
UPDATE derivative_details SET creation_by = 'confid.';
UPDATE specimen_details SET reception_by = 'confid.';

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

UPDATE aliquot_internal_uses SET used_by = 'confid.';
UPDATE order_items SET date_added = null, reception_by = 'confid.';
UPDATE realiquotings SET realiquoted_by = 'confid.';
UPDATE shipments SET shipped_by = 'confid.';

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

-- List of values
-- ..................................................................................................................
-- Rename study fields with banks names

DELETE FROM structure_permissible_values_customs 
WHERE control_id NOT IN (
	SELECT id FROM structure_permissible_values_custom_controls
	WHERE name IN (
		'Aliquot Use and Event Types',
		'Clinical Exam - Results (PROCURE values only)',
		'Clinical Exam - Sites (PROCURE values only)',
		'Clinical Exam - Types (PROCURE values only)',
		'Clinical Note Types',
		'Consent Form Versions',
		'Progressions & Comorbidities (PROCURE values only)',
		'Questionnaire version date',
		'Slide Review : Tissue Type',
		'Storage Coordinate Titles',
		'Storage Types',
		'Surgery Types (PROCURE values only)',
		'Tissue Slide Stains',
		'TMA Slide Stains',
		'Treatment Precisions (PROCURE values only)',
		'Treatment Sites (PROCURE values only)',
		'Treatment Types (PROCURE values only)'
	)
);

-- ..................................................................................................................
-- Generate date of script creation
  
CREATE TABLE atim_procure_dump_information (created datetime NOT NULL);;
INSERT INTO atim_procure_dump_information (created) (SELECT NOW() FROM aliquot_controls LIMIT 0 ,1);
  
-- ------------------------------------------------------------------------------------------------------------------------
-- PS1
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
