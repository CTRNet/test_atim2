-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Delete studies
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_internal_uses SET study_summary_id = NULL;
UPDATE aliquot_internal_uses_revs SET study_summary_id = NULL;
UPDATE aliquot_masters SET study_summary_id = NULL;
UPDATE aliquot_masters_revs SET study_summary_id = NULL;

SELECT title as 'Deleted Studies' from study_summaries WHERE deleted <> 1;
DELETE FROM study_summaries;
DELETE FROM study_summaries_revs;

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- ALiquot Internal Uses
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Quality Control PROCURE (returned) & Quality Control PROCURE (sent)

SELECT "Replaced 'Quality Control PROCURE (returned)' and 'Quality Control PROCURE (sent)' by 'Sent To Processing Site' and 'Received From Processing Site'" AS '### MESSAGE ###';

UPDATE aliquot_internal_uses
SET use_details = CONCAT(use_code, ' ',use_details)
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses
SET use_details = use_code
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NULL;
UPDATE aliquot_internal_uses
SET  use_code = 'Quality Control'
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses
SET  type = 'received from processing site'
WHERE type IN ('quality control procure (returned))');
UPDATE aliquot_internal_uses
SET  type = 'sent to processing site'
WHERE type IN ('quality control procure (sentt)');

UPDATE aliquot_internal_uses_revs
SET use_details = CONCAT(use_code, ' ',use_details)
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses_revs
SET use_details = use_code
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NULL;
UPDATE aliquot_internal_uses_revs
SET  use_code = 'Quality Control'
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses_revs
SET  type = 'received from processing site'
WHERE type IN ('quality control procure (returned))');
UPDATE aliquot_internal_uses_revs
SET  type = 'sent to processing site'
WHERE type IN ('quality control procure (sentt)');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value  IN ('quality control procure (returned))', 'quality control procure (sentt)');

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Update created by
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE participants SET procure_last_modification_by_bank = '1';
UPDATE participants_revs SET procure_last_modification_by_bank = '1';
UPDATE consent_masters SET procure_created_by_bank = '1';
UPDATE consent_masters_revs SET procure_created_by_bank = '1';
UPDATE event_masters SET procure_created_by_bank = '1';
UPDATE event_masters_revs SET procure_created_by_bank = '1';
UPDATE treatment_masters SET procure_created_by_bank = '1';
UPDATE treatment_masters_revs SET procure_created_by_bank = '1';

UPDATE collections SET procure_collected_by_bank = '1';
UPDATE collections_revs SET procure_collected_by_bank = '1';
UPDATE sample_masters SET procure_created_by_bank = '1';
UPDATE sample_masters_revs SET procure_created_by_bank = '1';
UPDATE aliquot_masters SET procure_created_by_bank = '1';
UPDATE aliquot_masters_revs SET procure_created_by_bank = '1';
UPDATE aliquot_internal_uses SET procure_created_by_bank = '1';
UPDATE aliquot_internal_uses_revs SET procure_created_by_bank = '1';
UPDATE quality_ctrls SET procure_created_by_bank = '1';
UPDATE quality_ctrls_revs SET procure_created_by_bank = '1';

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Concentrated Urine Migration
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_concentrated' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE sd_der_urine_cents SET procure_concentrated = qc_nd_concentrated;
UPDATE sd_der_urine_cents_revs SET procure_concentrated = qc_nd_concentrated;
ALTER TABLE sd_der_urine_cents DROP COLUMN qc_nd_concentrated;
ALTER TABLE sd_der_urine_cents_revs DROP COLUMN qc_nd_concentrated;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_concentrated' AND `language_label`='concentrated' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_concentrated' AND `language_label`='concentrated' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_concentrated' AND `language_label`='concentrated' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');












































UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '62??' WHERE version_number = '2.6.5';
