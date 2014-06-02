-- to run after custom_post_251.sql & /v261_procure_icm_split/New_Prostate_TissuBlock_Import.php
-- use to delete all procure data

SELECT 'SCRIPT TO DELETE ALL PROCURE RECORDS' as message;

SET @procure_study_summary_id = (SELECT id FROM study_summaries WHERE title = 'PROCURE');

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

ALTER TABLE collections ADD COLUMN tmp_procure_collection char(1) NOT NULL DEFAULT '0';
UPDATE collections SET tmp_procure_collection = '1' WHERE id IN (SELECT collection_id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);

-- ALIQUOT CLEAN UP ----------------------------------------------------------

DELETE FROM aliquot_internal_uses WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM aliquot_internal_uses_revs WHERE id NOT IN (SELECT id FROM aliquot_internal_uses);
DELETE FROM source_aliquots WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM source_aliquots_revs WHERE id NOT IN (SELECT id FROM source_aliquots);
DELETE FROM quality_ctrls WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM quality_ctrls_revs WHERE id NOT IN (SELECT id FROM quality_ctrls);
DELETE FROM order_items WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM order_items_revs WHERE id NOT IN (SELECT id FROM order_items);
SELECT IF(COUNT(*) = 0, 'No aliquot review errors', 'Please check table aliquot_review_masters') AS msg FROM aliquot_review_masters;
-- DELETE FROM aliquot_review_masters WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);

SELECT IF(COUNT(*) = 0, "No error on realiquoting table", "Error on realiquoting table") AS msg 
FROM realiquotings AS Realiquoting
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
WHERE (AliquotMaster.id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id) OR AliquotMasterChild.id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id))
AND AliquotMaster.study_summary_id != AliquotMasterChild.study_summary_id;

DELETE FROM realiquotings WHERE parent_aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM realiquotings WHERE child_aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM realiquotings_revs WHERE id NOT IN (SELECT id FROM realiquotings);

DELETE FROM ad_tubes WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_tubes_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_tubes);
DELETE FROM ad_blocks WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_blocks_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_blocks);
DELETE FROM ad_tissue_slides WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_tissue_slides_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_tissue_slides);
DELETE FROM ad_whatman_papers WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_whatman_papers_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_whatman_papers);
DELETE FROM ad_cell_slides WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_cell_slides_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_cell_slides);
DELETE FROM ad_tissue_cores WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_tissue_cores_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_tissue_cores);
DELETE FROM ad_gel_matrices WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_gel_matrices_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_gel_matrices);
DELETE FROM ad_cell_cores WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
   DELETE FROM ad_cell_cores_revs WHERE aliquot_master_id NOT IN (SELECT aliquot_master_id FROM ad_cell_cores);

SET @aliquot_total = (SELECT count(*) FROM aliquot_masters WHERE deleted != 1);
SET @aliquot_deleted = (SELECT count(*) FROM aliquot_masters WHERE deleted != 1 AND study_summary_id = @procure_study_summary_id);
SELECT CONCAT(@aliquot_deleted, '/' , @aliquot_total, ' have been deleted') AS aliquot_deletion_message;

DELETE FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id;
   DELETE FROM aliquot_masters_revs WHERE id NOT IN (SELECT id FROM aliquot_masters);

-- SAMPLE CLEAN UP -----------------------------------------------------------

SELECT IF(COUNT(*) = 0, 'No specimen review errors', 'Please check table specimen_review_masters') AS msg FROM specimen_review_masters;

-- collections to delete
UPDATE collections SET tmp_procure_collection = '2' WHERE tmp_procure_collection = '1' AND id NOT IN (SELECT collection_id FROM aliquot_masters);

DELETE FROM quality_ctrls WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM quality_ctrls_revs WHERE id NOT IN (SELECT id FROM quality_ctrls);

DELETE FROM sd_spe_ascites WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_ascites_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_ascites);
DELETE FROM sd_spe_bloods WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_bloods_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_bloods);
DELETE FROM sd_spe_tissues WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_tissues_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_tissues);
DELETE FROM sd_spe_urines WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_urines_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_urines);
DELETE FROM sd_der_ascite_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_ascite_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_ascite_cells);
DELETE FROM sd_der_ascite_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_ascite_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_ascite_sups);
DELETE FROM sd_der_blood_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_blood_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_blood_cells);
DELETE FROM sd_der_pbmcs WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_pbmcs_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pbmcs);
DELETE FROM sd_der_plasmas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_plasmas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_plasmas);
DELETE FROM sd_der_serums WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_serums_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_serums);
DELETE FROM sd_der_cell_cultures WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_cell_cultures_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cell_cultures);
DELETE FROM sd_der_dnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_dnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_dnas);
DELETE FROM sd_der_rnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_rnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_rnas);
DELETE FROM sd_der_urine_cons WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_urine_cons_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_urine_cons);
DELETE FROM sd_der_urine_cents WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_urine_cents_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_urine_cents);
DELETE FROM sd_der_amp_rnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_amp_rnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_amp_rnas);
DELETE FROM sd_der_b_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_b_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_b_cells);
DELETE FROM sd_der_cdnas WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_cdnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cdnas);
DELETE FROM sd_der_tiss_lysates WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_tiss_lysates_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_tiss_lysates);
DELETE FROM sd_der_tiss_susps WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_tiss_susps_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_tiss_susps);
DELETE FROM sd_spe_peritoneal_washes WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_peritoneal_washes_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_peritoneal_washes);
DELETE FROM sd_spe_cystic_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_cystic_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_cystic_fluids);
DELETE FROM sd_spe_other_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_other_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_other_fluids);
DELETE FROM sd_der_pw_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_pw_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pw_cells);
DELETE FROM sd_der_pw_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_pw_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pw_sups);
DELETE FROM sd_der_cystic_fl_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_cystic_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cystic_fl_cells);
DELETE FROM sd_der_cystic_fl_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_cystic_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cystic_fl_sups);
DELETE FROM sd_der_of_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_of_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_of_cells);
DELETE FROM sd_der_of_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_of_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_of_sups);
DELETE FROM sd_spe_pericardial_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_pericardial_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_pericardial_fluids);
DELETE FROM sd_spe_pleural_fluids WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_pleural_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_pleural_fluids);
DELETE FROM sd_der_pericardial_fl_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_pericardial_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pericardial_fl_cells);
DELETE FROM sd_der_pericardial_fl_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_pericardial_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pericardial_fl_sups);
DELETE FROM sd_der_pleural_fl_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_pleural_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pleural_fl_cells);
DELETE FROM sd_der_pleural_fl_sups WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_pleural_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pleural_fl_sups);
DELETE FROM sd_der_cell_lysates WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_cell_lysates_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cell_lysates);
DELETE FROM sd_der_proteins WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_proteins_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_proteins);
DELETE FROM sd_spe_bone_marrows WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_spe_bone_marrows_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_bone_marrows);
DELETE FROM sd_der_bone_marrow_susps WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_bone_marrow_susps_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_bone_marrow_susps);
DELETE FROM sd_der_no_b_cells WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM sd_der_no_b_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_no_b_cells);

DELETE FROM specimen_details WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM specimen_details_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM specimen_details);
DELETE FROM derivative_details WHERE sample_master_id IN (SELECT sm.id FROM sample_masters sm INNER JOIN collections col ON col.id = sm.collection_id WHERE col.tmp_procure_collection = '2');
   DELETE FROM derivative_details_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM derivative_details);

UPDATE sample_masters SET initial_specimen_sample_id = null WHERE collection_id IN (SELECT DISTINCT id FROM collections WHERE tmp_procure_collection = '2');
UPDATE sample_masters SET parent_id = null WHERE collection_id IN (SELECT DISTINCT id FROM collections WHERE tmp_procure_collection = '2');
DELETE FROM sample_masters WHERE collection_id IN (SELECT DISTINCT id FROM collections WHERE tmp_procure_collection = '2');
   DELETE FROM sample_masters_revs WHERE id NOT IN (SELECT id FROM sample_masters);

-- COLLECTIONS ---------------------------------------------------------------

SET @collections_total = (SELECT count(*) FROM collections WHERE deleted != 1);
SET @collections_deleted = (SELECT count(*) FROM collections WHERE deleted != 1 AND tmp_procure_collection = '2');
SELECT CONCAT(@collections_deleted, '/' , @collections_total, ' have been deleted') AS collection_deletion_message;

DELETE FROM collections WHERE tmp_procure_collection = '2';
   DELETE FROM collections_revs WHERE id NOT IN (SELECT id FROM collections);

ALTER TABLE collections DROP COLUMN tmp_procure_collection;

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

SELECT IF(COUNT(*) = 0, "No participant with either PROCURE or Prostate consent and no collection", "At least one participant with either PROCURE or Prostate consent and no collection") AS msg 
FROM participants p
INNER JOIN consent_masters cs ON cs.participant_id = p.id AND cs.deleted <> 1
WHERE p.id NOT IN (SELECT DISTINCT participant_id FROM collections)
AND cs.consent_control_id IN (3, 5);

DELETE FROM qc_nd_ed_all_procure_lifestyles;;
   DELETE FROM qc_nd_ed_all_procure_lifestyles_revs;
DELETE FROM event_masters;
   DELETE FROM event_masters_revs;

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

-- study

SELECT 'object linked to procure study' AS issue, 'aliquot_masters' AS tablename, CONCAT('aliquot_master_id = ',id) AS id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id
UNION ALL
SELECT 'object linked to procure study' AS issue, 'order_lines' AS tablename, CONCAT('order_id = ',order_id) AS id FROM order_lines WHERE study_summary_id = @procure_study_summary_id
UNION ALL
SELECT 'object linked to procure study' AS issue, 'orders' AS tablename, CONCAT('order_id = ',id) AS id FROM orders WHERE default_study_summary_id = @procure_study_summary_id
UNION ALL
SELECT 'object linked to procure study' AS issue, 'aliquot_internal_uses' AS tablename, CONCAT('aliquot_master_id = ',aliquot_master_id) AS id FROM aliquot_internal_uses WHERE study_summary_id = @procure_study_summary_id;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', "<FONT color='red'>ICM - Test</FONT>", "<FONT color='red'>ICM - Test</FONT>");
