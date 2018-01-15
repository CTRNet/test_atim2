-- to run after custom_post_251.sql & /v261_procure_icm_split/New_Prostate_TissuBlock_Import.php
-- use to delete all data not flagged as procure

SELECT 'SCRIPT TO DELETE ALL RECORDS NOT LINKED TO PROCURE' as message;

SET @procure_study_summary_id = (SELECT id FROM study_summaries WHERE title = 'PROCURE');

SELECT 'ICM Database Data beofre DB split' AS '-----------------------------------------------------------------'
UNION ALL
SELECT '-----------------------------------------------------------------' AS '-----------------------------------------------------------------';
SELECT count(*) as 'ICM: nbr participants with code-barre or consent PROCURE or aliquot PROCURE'
FROM participants 
WHERE deleted <> 1 AND id IN (
  SELECT DISTINCT participant_id 
  FROM collections col 
  INNER JOIN aliquot_masters am ON am.collection_id = col.id AND col.id AND am.deleted <> 1 
  INNER JOIN study_summaries st ON st.id = am.study_summary_id AND st.title = 'PROCURE'
  UNION ALL
  SELECT participant_id FROM consent_masters cm INNER JOIN consent_controls cc ON cc.id = cm.consent_control_id WHERE cc.controls_type = 'procure' AND cm.deleted <> 1
  UNION ALL
  SELECT participant_id FROM misc_identifiers mi INNEr JOIN misc_identifier_controls mc ON mc.id = mi.misc_identifier_control_id WHERE mc.misc_identifier_name = 'code-barre' AND mi.deleted <> 1
);
SELECT '-----------------------------------------------------------------' AS '-----------------------------------------------------------------';
SELECT count(*) 'ICM: nbr of aliquots', sample_type, aliquot_type, am.deleted 
FROM aliquot_masters am
INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id
INNER JOIN sample_controls sm ON sm.id = ac.sample_control_id
INNER JOIN study_summaries st ON st.id = am.study_summary_id
WHERE st.title = 'PROCURE'
GROUP BY sample_type, aliquot_type, deleted 
ORDER BY sample_type, aliquot_type, deleted;
SELECT '-----------------------------------------------------------------' AS '-----------------------------------------------------------------';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- INVENTORY
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT IF(COUNT(*) = 0, "No error on study versus bank", "A PROCURE aliquot is included into a non-prostate collection") AS msg 
FROM aliquot_masters 
WHERE study_summary_id = (SELECT id FROM study_summaries WHERE title = 'PROCURE')
AND collection_id NOT IN (SELECT collections.id FROM collections INNER JOIN banks ON banks.id = collections.bank_id AND banks.name = 'prostate')
AND deleted <> 1;

ALTER TABLE collections ADD COLUMN tmp_procure_collection char(1)  NOT NULL DEFAULT '0';
UPDATE collections SET tmp_procure_collection = '1' WHERE id IN (SELECT collection_id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);

-- ALIQUOT CLEAN UP ----------------------------------------------------------

DELETE FROM aliquot_internal_uses WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM aliquot_internal_uses_revs WHERE id NOT IN (SELECT id FROM aliquot_internal_uses);
DELETE FROM source_aliquots WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM source_aliquots_revs WHERE id NOT IN (SELECT id FROM source_aliquots);
DELETE FROM quality_ctrls WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM quality_ctrls_revs WHERE id NOT IN (SELECT id FROM quality_ctrls);
DELETE FROM order_items WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM order_items_revs WHERE id NOT IN (SELECT id FROM order_items);
SELECT IF(COUNT(*) = 0, 'No aliquot review errors', 'Please check table aliquot_review_masters') AS msg FROM aliquot_review_masters;
-- DELETE FROM aliquot_review_masters WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);

SELECT IF(COUNT(*) = 0, "No error on realiquoting table", "Error on realiquoting table") AS msg 
FROM realiquotings AS Realiquoting
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
WHERE (AliquotMaster.id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id) OR AliquotMasterChild.id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id))
AND AliquotMaster.study_summary_id != AliquotMasterChild.study_summary_id;

DELETE FROM realiquotings WHERE parent_aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM realiquotings WHERE child_aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM realiquotings_revs WHERE id NOT IN (SELECT id FROM realiquotings);

DELETE FROM ad_tubes WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_tubes_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_tubes);
DELETE FROM ad_blocks WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_blocks_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_blocks);
DELETE FROM ad_tissue_slides WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_tissue_slides_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_tissue_slides);
DELETE FROM ad_whatman_papers WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_whatman_papers_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_whatman_papers);
DELETE FROM ad_cell_slides WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_cell_slides_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_cell_slides);
DELETE FROM ad_tissue_cores WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_tissue_cores_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_tissue_cores);
DELETE FROM ad_gel_matrices WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_gel_matrices_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_gel_matrices);
DELETE FROM ad_cell_cores WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_cell_cores_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_cell_cores);

SET @aliquot_total = (SELECT count(*) FROM aliquot_masters WHERE deleted != 1);
SET @aliquot_deleted = (SELECT count(*) FROM aliquot_masters WHERE deleted != 1 AND (study_summary_id != @procure_study_summary_id OR study_summary_id IS NULL));
SELECT CONCAT(@aliquot_deleted, '/' , @aliquot_total, ' have been deleted') AS aliquot_deletion_message;

DELETE FROM aliquot_masters WHERE study_summary_id != @procure_study_summary_id OR study_summary_id IS NULL;
   DELETE FROM aliquot_masters_revs WHERE id NOT IN (SELECT id FROM aliquot_masters);
UPDATE aliquot_masters SET study_summary_id = NULL;
UPDATE aliquot_masters_revs SET study_summary_id = NULL;

-- SAMPLE CLEAN UP -----------------------------------------------------------

SELECT IF(COUNT(*) = 0, 'No specimen review errors', 'Please check table specimen_review_masters') AS msg FROM specimen_review_masters;

DELETE FROM quality_ctrls WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM quality_ctrls_revs WHERE id NOT IN (SELECT id FROM quality_ctrls);

DELETE FROM sd_spe_ascites WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_ascites_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_ascites);
DELETE FROM sd_spe_bloods WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_bloods_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_bloods);
DELETE FROM sd_spe_tissues WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_tissues_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_tissues);
DELETE FROM sd_spe_urines WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_urines_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_urines);
DELETE FROM sd_der_ascite_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_ascite_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_ascite_cells);
DELETE FROM sd_der_ascite_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_ascite_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_ascite_sups);
DELETE FROM sd_der_blood_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_blood_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_blood_cells);
DELETE FROM sd_der_pbmcs WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_pbmcs_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pbmcs);
DELETE FROM sd_der_plasmas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_plasmas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_plasmas);
DELETE FROM sd_der_serums WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_serums_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_serums);
DELETE FROM sd_der_cell_cultures WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_cell_cultures_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cell_cultures);
DELETE FROM sd_der_dnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_dnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_dnas);
DELETE FROM sd_der_rnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_rnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_rnas);
DELETE FROM sd_der_urine_cons WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_urine_cons_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_urine_cons);
DELETE FROM sd_der_urine_cents WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_urine_cents_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_urine_cents);
DELETE FROM sd_der_amp_rnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_amp_rnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_amp_rnas);
DELETE FROM sd_der_b_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_b_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_b_cells);
DELETE FROM sd_der_cdnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_cdnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cdnas);
DELETE FROM sd_der_tiss_lysates WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_tiss_lysates_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_tiss_lysates);
DELETE FROM sd_der_tiss_susps WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_tiss_susps_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_tiss_susps);
DELETE FROM sd_spe_peritoneal_washes WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_peritoneal_washes_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_peritoneal_washes);
DELETE FROM sd_spe_cystic_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_cystic_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_cystic_fluids);
DELETE FROM sd_spe_other_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_other_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_other_fluids);
DELETE FROM sd_der_pw_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_pw_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pw_cells);
DELETE FROM sd_der_pw_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_pw_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pw_sups);
DELETE FROM sd_der_cystic_fl_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_cystic_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cystic_fl_cells);
DELETE FROM sd_der_cystic_fl_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_cystic_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cystic_fl_sups);
DELETE FROM sd_der_of_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_of_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_of_cells);
DELETE FROM sd_der_of_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_of_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_of_sups);
DELETE FROM sd_spe_pericardial_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_pericardial_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_pericardial_fluids);
DELETE FROM sd_spe_pleural_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_pleural_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_pleural_fluids);
DELETE FROM sd_der_pericardial_fl_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_pericardial_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pericardial_fl_cells);
DELETE FROM sd_der_pericardial_fl_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_pericardial_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pericardial_fl_sups);
DELETE FROM sd_der_pleural_fl_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_pleural_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pleural_fl_cells);
DELETE FROM sd_der_pleural_fl_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_pleural_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pleural_fl_sups);
DELETE FROM sd_der_cell_lysates WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_cell_lysates_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cell_lysates);
DELETE FROM sd_der_proteins WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_proteins_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_proteins);
DELETE FROM sd_spe_bone_marrows WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_spe_bone_marrows_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_bone_marrows);
DELETE FROM sd_der_bone_marrow_susps WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_bone_marrow_susps_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_bone_marrow_susps);
DELETE FROM sd_der_no_b_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM sd_der_no_b_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_no_b_cells);

DELETE FROM specimen_details WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM specimen_details_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM specimen_details);
DELETE FROM derivative_details WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection != '1');
   DELETE FROM derivative_details_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM derivative_details);

UPDATE sample_masters SET initial_specimen_sample_id = null WHERE collection_id IN (SELECT DISTINCT id FROM collections WHERE tmp_procure_collection != '1');
UPDATE sample_masters SET parent_id = null WHERE collection_id IN (SELECT DISTINCT id FROM collections WHERE tmp_procure_collection != '1');
DELETE FROM sample_masters WHERE collection_id IN (SELECT DISTINCT id FROM collections WHERE tmp_procure_collection != '1');
   DELETE FROM sample_masters_revs WHERE id NOT IN (SELECT id FROM sample_masters);

-- COLLECTIONS ---------------------------------------------------------------

SET @collections_total = (SELECT count(*) FROM collections WHERE deleted != 1);
SET @collections_deleted = (SELECT count(*) FROM collections WHERE deleted != 1 AND tmp_procure_collection != '1');
SELECT CONCAT(@collections_deleted, '/' , @collections_total, ' have been deleted') AS collection_deletion_message;

DELETE FROM collections WHERE tmp_procure_collection != '1';
   DELETE FROM collections_revs WHERE id NOT IN (SELECT id FROM collections);

ALTER TABLE collections DROP COLUMN tmp_procure_collection;

SELECT 'empty collection' as msg, acquisition_label, id FROM collections WHERE deleted <> 1 AND id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters WHERE deleted <> 1);

-- CONTROL

SELECT count(*) AS sample_with_no_details_1 from sample_masters WHERE id NOT IN (SELECT sample_master_id FROM specimen_details UNION ALL SELECT sample_master_id FROM derivative_details);
SELECT count(*) AS sample_with_no_details_2 from sample_masters WHERE id NOT IN (
SELECT sample_master_id FROM sd_der_amp_rnas UNION ALL
SELECT sample_master_id FROM sd_der_ascite_cells UNION ALL
SELECT sample_master_id FROM sd_der_ascite_sups UNION ALL
SELECT sample_master_id FROM sd_der_b_cells UNION ALL
SELECT sample_master_id FROM sd_der_blood_cells UNION ALL
SELECT sample_master_id FROM sd_der_bone_marrow_susps UNION ALL
SELECT sample_master_id FROM sd_der_cdnas UNION ALL
SELECT sample_master_id FROM sd_der_cell_cultures UNION ALL
SELECT sample_master_id FROM sd_der_cell_lysates UNION ALL
SELECT sample_master_id FROM sd_der_csf_cells UNION ALL
SELECT sample_master_id FROM sd_der_csf_sups UNION ALL
SELECT sample_master_id FROM sd_der_cystic_fl_cells UNION ALL
SELECT sample_master_id FROM sd_der_cystic_fl_sups UNION ALL
SELECT sample_master_id FROM sd_der_dnas UNION ALL
SELECT sample_master_id FROM sd_der_no_b_cells UNION ALL
SELECT sample_master_id FROM sd_der_of_cells UNION ALL
SELECT sample_master_id FROM sd_der_of_sups UNION ALL
SELECT sample_master_id FROM sd_der_pbmcs UNION ALL
SELECT sample_master_id FROM sd_der_pericardial_fl_cells UNION ALL
SELECT sample_master_id FROM sd_der_pericardial_fl_sups UNION ALL
SELECT sample_master_id FROM sd_der_plasmas UNION ALL
SELECT sample_master_id FROM sd_der_pleural_fl_cells UNION ALL
SELECT sample_master_id FROM sd_der_pleural_fl_sups UNION ALL
SELECT sample_master_id FROM sd_der_proteins UNION ALL
SELECT sample_master_id FROM sd_der_purified_rnas UNION ALL
SELECT sample_master_id FROM sd_der_pw_cells UNION ALL
SELECT sample_master_id FROM sd_der_pw_sups UNION ALL
SELECT sample_master_id FROM sd_der_rnas UNION ALL
SELECT sample_master_id FROM sd_der_serums UNION ALL
SELECT sample_master_id FROM sd_der_tiss_lysates UNION ALL
SELECT sample_master_id FROM sd_der_tiss_susps UNION ALL
SELECT sample_master_id FROM sd_der_urine_cents UNION ALL
SELECT sample_master_id FROM sd_der_urine_cons UNION ALL
SELECT sample_master_id FROM sd_spe_ascites UNION ALL
SELECT sample_master_id FROM sd_spe_bloods UNION ALL
SELECT sample_master_id FROM sd_spe_bone_marrows UNION ALL
SELECT sample_master_id FROM sd_spe_csfs UNION ALL
SELECT sample_master_id FROM sd_spe_cystic_fluids UNION ALL
SELECT sample_master_id FROM sd_spe_other_fluids UNION ALL
SELECT sample_master_id FROM sd_spe_pericardial_fluids UNION ALL
SELECT sample_master_id FROM sd_spe_peritoneal_washes UNION ALL
SELECT sample_master_id FROM sd_spe_pleural_fluids UNION ALL
SELECT sample_master_id FROM sd_spe_salivas UNION ALL
SELECT sample_master_id FROM sd_spe_tissues UNION ALL
SELECT sample_master_id FROM sd_spe_urines);

SELECT count(*) as aliquot_with_no_details FROM aliquot_masters WHERE id NOT IN (
SELECT aliquot_master_id FROM ad_bags UNION ALL
SELECT aliquot_master_id FROM ad_blocks UNION ALL
SELECT aliquot_master_id FROM ad_cell_cores UNION ALL
SELECT aliquot_master_id FROM ad_cell_slides UNION ALL
SELECT aliquot_master_id FROM ad_gel_matrices UNION ALL
SELECT aliquot_master_id FROM ad_tissue_cores UNION ALL
SELECT aliquot_master_id FROM ad_tissue_slides UNION ALL
SELECT aliquot_master_id FROM ad_tubes UNION ALL
SELECT aliquot_master_id FROM ad_whatman_papers);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- PARTICIPANT
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE participants ADD COLUMN tmp_procure_participant char(1) DEFAULT '0';
UPDATE participants SET tmp_procure_participant = '1' WHERE id IN (SELECT participant_id FROM collections);
UPDATE participants SET tmp_procure_participant = '1' WHERE id IN (
  SELECT participant_id FROM consent_masters cm INNER JOIN consent_controls cc ON cc.id = cm.consent_control_id WHERE cc.controls_type = 'procure' AND cm.deleted <> 1
  UNION ALL
  SELECT participant_id FROM misc_identifiers mi INNEr JOIN misc_identifier_controls mc ON mc.id = mi.misc_identifier_control_id WHERE mc.misc_identifier_name = 'code-barre' AND mi.deleted <> 1
);


UPDATE participants SET tmp_procure_participant = '0' WHERE id IN (
	SELECT participant_id FROM misc_identifiers mi INNEr JOIN misc_identifier_controls mc ON mc.id = mi.misc_identifier_control_id WHERE mc.misc_identifier_name = 'prostate bank no lab' AND mi.deleted <> 1
	AND mi.identifier_value IN (500425,500587,500604,500684,500696,500849,500864,500893,500983)
);

SELECT '500425,500587,500604,500684,500696,500849,500864,500893,500983' AS 'Check Following NoLabos have not been migrated to PROCURE and no aliquot exists into PROCURE DB';
  
-- TREATMENT -----------------------------------------------------------------

SELECT IF(COUNT(*) = 0, 'No treatment errors', 'Please check treatments') AS msg FROM treatment_masters;

-- EVENT ---------------------------------------------------------------------

DELETE FROM qc_nd_ed_all_procure_lifestyles WHERE event_master_id NOT IN (SELECT EventMaster.id FROM event_masters EventMaster INNER JOIN participants Participant ON Participant.tmp_procure_participant = '1' AND Participant.id = EventMaster.participant_id);
   DELETE FROM qc_nd_ed_all_procure_lifestyles_revs WHERE event_master_id NOT IN (SELECT event_master_id FROM qc_nd_ed_all_procure_lifestyles);
DELETE FROM event_masters WHERE participant_id NOT IN (SELECT DISTINCT id FROM participants WHERE tmp_procure_participant = '1');
   DELETE FROM event_masters_revs WHERE id NOT IN (SELECT id FROM event_masters);

-- MISC IDENTFIERS -----------------------------------------------------------

DELETE FROM misc_identifiers WHERE participant_id NOT IN (SELECT DISTINCT id FROM participants WHERE tmp_procure_participant = '1');
DELETE FROM misc_identifiers WHERE misc_identifier_control_id IN (1,2,3,4);
   DELETE FROM misc_identifiers_revs WHERE id NOT IN (SELECT id FROM misc_identifiers);

-- CONSENTS ------------------------------------------------------------------

DELETE FROM cd_icm_generics WHERE consent_master_id NOT IN (SELECT ConsentMaster.id FROM consent_masters ConsentMaster INNER JOIN participants Participant ON Participant.tmp_procure_participant = '1' AND Participant.id = ConsentMaster.participant_id);
DELETE FROM cd_icm_generics WHERE consent_master_id NOT IN ( SELECT id FROM consent_masters WHERE consent_control_id IN (3,5));
    DELETE FROM cd_icm_generics_revs WHERE consent_master_id NOT IN (SELECT consent_master_id FROM cd_icm_generics);
DELETE FROM qc_nd_cd_generals WHERE consent_master_id NOT IN (SELECT ConsentMaster.id FROM consent_masters ConsentMaster INNER JOIN participants Participant ON Participant.tmp_procure_participant = '1' AND Participant.id = ConsentMaster.participant_id);
DELETE FROM qc_nd_cd_generals WHERE consent_master_id NOT IN ( SELECT id FROM consent_masters WHERE consent_control_id IN (3,5));
   DELETE FROM qc_nd_cd_generals_revs WHERE consent_master_id NOT IN (SELECT consent_master_id FROM qc_nd_cd_generals);
DELETE FROM consent_masters WHERE participant_id NOT IN (SELECT DISTINCT id FROM participants WHERE tmp_procure_participant = '1') OR consent_control_id NOT IN (3,5);
   DELETE FROM consent_masters_revs WHERE id NOT IN (SELECT id FROM consent_masters);    
DELETE FROM consent_controls WHERE id NOT IN (3,5);
select participant_id AS 'participant linked to prostate consent' FROM consent_masters WHERE consent_control_id = 3 AND deleted <> 1;

-- MESSAGES -----------------------------------------------------------

DELETE FROM participant_messages WHERE participant_id NOT IN (SELECT DISTINCT id FROM participants WHERE tmp_procure_participant = '1');
   DELETE FROM participant_messages_revs WHERE id NOT IN (SELECT id FROM participant_messages);

-- CONTACTS -----------------------------------------------------------

DELETE FROM participant_contacts WHERE participant_id NOT IN (SELECT DISTINCT id FROM participants WHERE tmp_procure_participant = '1');
   DELETE FROM participant_contacts_revs WHERE id NOT IN (SELECT id FROM participant_messages);
   
-- REPRODUCTIVE HISTORY -----------------------------------------------------------

DELETE FROM reproductive_histories WHERE participant_id NOT IN (SELECT DISTINCT id FROM participants WHERE tmp_procure_participant = '1');
   DELETE FROM reproductive_histories_revs WHERE id NOT IN (SELECT id FROM reproductive_histories);

-- PARTICIPANT  -----------------------------------------------------------

SET @participants_total = (SELECT count(*) FROM participants WHERE deleted != 1);
SET @participants_deleted = (SELECT count(*) FROM participants WHERE deleted != 1 AND tmp_procure_participant != '1');
SELECT CONCAT(@participants_deleted, '/' , @participants_total, ' have been deleted') AS participant_deletion_message;

DELETE FROM participants WHERE tmp_procure_participant != '1';
   DELETE FROM participants_revs WHERE id NOT IN (SELECT id FROM participants);

ALTER TABLE participants DROP COLUMN tmp_procure_participant;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- OTHER
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- storage

CREATE TABLE storage_masters_for_deletion(storage_master_id INT NOT NULL);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct storage_master_id FROM aliquot_masters);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct parent_id FROM storage_masters WHERE parent_id IS NOT NULL);
DELETE FROM std_rooms WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_cupboards WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_nitro_locates WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_incubators WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_fridges WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_freezers WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_boxs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_racks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_shelfs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_tma_blocks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM storage_masters WHERE id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DROP TABLE storage_masters_for_deletion;

CREATE TABLE storage_masters_for_deletion(storage_master_id INT NOT NULL);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct storage_master_id FROM aliquot_masters);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct parent_id FROM storage_masters WHERE parent_id IS NOT NULL);
DELETE FROM std_rooms WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_cupboards WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_nitro_locates WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_incubators WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_fridges WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_freezers WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_boxs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_racks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_shelfs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_tma_blocks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM storage_masters WHERE id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DROP TABLE storage_masters_for_deletion;

CREATE TABLE storage_masters_for_deletion(storage_master_id INT NOT NULL);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct storage_master_id FROM aliquot_masters);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct parent_id FROM storage_masters WHERE parent_id IS NOT NULL);
DELETE FROM std_rooms WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_cupboards WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_nitro_locates WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_incubators WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_fridges WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_freezers WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_boxs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_racks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_shelfs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_tma_blocks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM storage_masters WHERE id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DROP TABLE storage_masters_for_deletion;

CREATE TABLE storage_masters_for_deletion(storage_master_id INT NOT NULL);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct storage_master_id FROM aliquot_masters);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct parent_id FROM storage_masters WHERE parent_id IS NOT NULL);
DELETE FROM std_rooms WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_cupboards WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_nitro_locates WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_incubators WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_fridges WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_freezers WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_boxs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_racks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_shelfs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_tma_blocks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM storage_masters WHERE id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DROP TABLE storage_masters_for_deletion;

CREATE TABLE storage_masters_for_deletion(storage_master_id INT NOT NULL);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct storage_master_id FROM aliquot_masters);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct parent_id FROM storage_masters WHERE parent_id IS NOT NULL);
DELETE FROM std_rooms WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_cupboards WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_nitro_locates WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_incubators WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_fridges WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_freezers WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_boxs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_racks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_shelfs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM std_tma_blocks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DELETE FROM storage_masters WHERE id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
DROP TABLE storage_masters_for_deletion;

CREATE TABLE storage_masters_for_deletion( storage_master_id INT NOT NULL);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct storage_master_id FROM aliquot_masters);
INSERT INTO storage_masters_for_deletion (storage_master_id) (SELECT distinct parent_id FROM storage_masters WHERE parent_id IS NOT NULL);
DELETE FROM std_rooms WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_rooms_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_rooms);
DELETE FROM std_cupboards WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_cupboards_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_cupboards);
DELETE FROM std_nitro_locates WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_nitro_locates_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_nitro_locates);
DELETE FROM std_incubators WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_incubators_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_incubators);
DELETE FROM std_fridges WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_fridges_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_fridges);
DELETE FROM std_freezers WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_freezers_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_freezers);
DELETE FROM std_boxs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_boxs_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_boxs);
DELETE FROM std_racks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_racks_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_racks);
DELETE FROM std_shelfs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_shelfs_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_shelfs);
DELETE FROM std_tma_blocks WHERE storage_master_id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM std_tma_blocks_revs WHERE storage_master_id NOT IN (SELECT storage_master_id FROM std_tma_blocks);
DELETE FROM storage_masters WHERE id NOT IN (SELECT storage_master_id FROM storage_masters_for_deletion);
   DELETE FROM storage_masters_revs WHERE id NOT IN (SELECT id FROM storage_masters);
DROP TABLE storage_masters_for_deletion;

UPDATE storage_masters SET lft = NULL, rght = NULL;

-- order

SELECT IF(COUNT(*) = 0, "No error on order", "Order items exist") AS msg  FROM order_items;
TRUNCATE order_items;
TRUNCATE order_items_revs;
DELETE FROM shipments;
DELETE FROM  shipments_revs;
DELETE FROM  order_lines;
DELETE FROM  order_lines_revs;
DELETE FROM  orders;
DELETE FROM  orders_revs;

-- study

SELECT 'object linked to other study' AS issue, std.title AS study, 'aliquot_internal_uses' AS tablename, CONCAT('aliquot_master_id = ',aliquot_master_id) AS id FROM aliquot_internal_uses us INNER JOIN study_summaries std ON std.id = us.study_summary_id  WHERE study_summary_id != @procure_study_summary_id;
DELETE FROM study_summaries WHERE id NOT IN (SELECT DISTINCT study_summary_id FROM aliquot_internal_uses WHERE study_summary_id IS NOT NULL);
   DELETE FROM study_summaries_revs WHERE id NOT IN (SELECT id FROM study_summaries);

-- users

UPDATE users SET flag_active = 0, deleted = 1 WHERE group_id NOT IN (SELECT id FROM groups WHERE name IN ('Syst. Admin.','Users Prostate'));
UPDATE groups SET deleted = 1, bank_id = NULL WHERE name NOT IN ('Syst. Admin.','Users Prostate');

-- Banks

DELETE FROM banks WHERE id NOT IN (1,4);
DELETE FROM banks_revs WHERE id NOT IN (1,4);

-- Identifier Controls

DELETE FROM misc_identifier_controls WHERE id IN (1,2,3,4);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;

SELECT 'PROCURE Database Data after ICM DB split' AS '-----------------------------------------------------------------'
UNION ALL
SELECT '-----------------------------------------------------------------' AS '-----------------------------------------------------------------';
SELECT count(*) as 'PROCURE: nbr participants' FROM participants WHERE deleted <> 1;
SELECT '-----------------------------------------------------------------' AS '-----------------------------------------------------------------';
SELECT count(*) as 'PROCURE: nbr of aliquots', sample_type, aliquot_type, deleted 
FROM aliquot_masters am
INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id
INNER JOIN sample_controls sm ON sm.id = ac.sample_control_id
GROUP BY sample_type, aliquot_type, deleted 
ORDER BY sample_type, aliquot_type, deleted;
SELECT '-----------------------------------------------------------------' AS '-----------------------------------------------------------------';
