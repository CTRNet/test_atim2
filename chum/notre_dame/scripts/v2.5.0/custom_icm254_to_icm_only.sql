-- to run after custom254.sql
-- use to delete all procure data

SELECT 'SCRIPT TO DELETE ALL PROCURE RECORDS' as message;

SET @procure_study_summary_id = (SELECT id FROM study_summaries WHERE title = 'PROCURE');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- INVENTORY
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

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

DELETE FROM quality_ctrls WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM quality_ctrls_revs WHERE id NOT IN (SELECT id FROM quality_ctrls);

SELECT IF(COUNT(*) = 0, 'No specimen review errors', 'Please check table specimen_review_masters') AS msg FROM specimen_review_masters;

DELETE FROM sd_spe_ascites WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_ascites_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_ascites);
DELETE FROM sd_spe_bloods WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_bloods_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_bloods);
DELETE FROM sd_spe_tissues WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_tissues_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_tissues);
DELETE FROM sd_spe_urines WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_urines_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_urines);
DELETE FROM sd_der_ascite_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_ascite_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_ascite_cells);
DELETE FROM sd_der_ascite_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_ascite_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_ascite_sups);
DELETE FROM sd_der_blood_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_blood_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_blood_cells);
DELETE FROM sd_der_pbmcs WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_pbmcs_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pbmcs);
DELETE FROM sd_der_plasmas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_plasmas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_plasmas);
DELETE FROM sd_der_serums WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_serums_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_serums);
DELETE FROM sd_der_cell_cultures WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_cell_cultures_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cell_cultures);
DELETE FROM sd_der_dnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_dnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_dnas);
DELETE FROM sd_der_rnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_rnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_rnas);
DELETE FROM sd_der_urine_cons WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_urine_cons_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_urine_cons);
DELETE FROM sd_der_urine_cents WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_urine_cents_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_urine_cents);
DELETE FROM sd_der_amp_rnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_amp_rnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_amp_rnas);
DELETE FROM sd_der_b_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_b_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_b_cells);
DELETE FROM sd_der_cdnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_cdnas_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cdnas);
DELETE FROM sd_der_tiss_lysates WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_tiss_lysates_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_tiss_lysates);
DELETE FROM sd_der_tiss_susps WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_tiss_susps_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_tiss_susps);
DELETE FROM sd_spe_peritoneal_washes WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_peritoneal_washes_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_peritoneal_washes);
DELETE FROM sd_spe_cystic_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_cystic_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_cystic_fluids);
DELETE FROM sd_spe_other_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_other_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_other_fluids);
DELETE FROM sd_der_pw_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_pw_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pw_cells);
DELETE FROM sd_der_pw_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_pw_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pw_sups);
DELETE FROM sd_der_cystic_fl_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_cystic_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cystic_fl_cells);
DELETE FROM sd_der_cystic_fl_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_cystic_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cystic_fl_sups);
DELETE FROM sd_der_of_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_of_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_of_cells);
DELETE FROM sd_der_of_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_of_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_of_sups);
DELETE FROM sd_spe_pericardial_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_pericardial_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_pericardial_fluids);
DELETE FROM sd_spe_pleural_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_pleural_fluids_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_pleural_fluids);
DELETE FROM sd_der_pericardial_fl_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_pericardial_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pericardial_fl_cells);
DELETE FROM sd_der_pericardial_fl_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_pericardial_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pericardial_fl_sups);
DELETE FROM sd_der_pleural_fl_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_pleural_fl_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pleural_fl_cells);
DELETE FROM sd_der_pleural_fl_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_pleural_fl_sups_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_pleural_fl_sups);
DELETE FROM sd_der_cell_lysates WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_cell_lysates_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_cell_lysates);
DELETE FROM sd_der_proteins WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_proteins_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_proteins);
DELETE FROM sd_spe_bone_marrows WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_spe_bone_marrows_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_spe_bone_marrows);
DELETE FROM sd_der_bone_marrow_susps WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_bone_marrow_susps_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_bone_marrow_susps);
DELETE FROM sd_der_no_b_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM sd_der_no_b_cells_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM sd_der_no_b_cells);

DELETE FROM specimen_details WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM specimen_details_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM specimen_details);
DELETE FROM derivative_details WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
   DELETE FROM derivative_details_revs WHERE sample_master_id NOT IN (SELECT sample_master_id FROM derivative_details);

UPDATE sample_masters SET initial_specimen_sample_id = null WHERE collection_id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters);
UPDATE sample_masters SET parent_id = null WHERE collection_id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters);
DELETE FROM sample_masters WHERE collection_id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters);
   DELETE FROM sample_masters_revs WHERE id NOT IN (SELECT id FROM sample_masters);

-- COLLECTIONS ---------------------------------------------------------------

SET @collections_total = (SELECT count(*) FROM collections WHERE deleted != 1);
SET @collections_deleted = (SELECT count(*) FROM collections WHERE deleted != 1 AND id NOT IN (SELECT collection_id FROM sample_masters));
SELECT CONCAT(@collections_deleted, '/' , @collections_total, ' have been deleted') AS collection_deletion_message;

DELETE FROM collections WHERE id NOT IN (SELECT collection_id FROM sample_masters);
   DELETE FROM collections_revs WHERE id NOT IN (SELECT id FROM collections);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- PARTICIPANT
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- TREATMENT -----------------------------------------------------------------

SELECT IF(COUNT(*) = 0, 'No treatment errors', 'Please check treatments') AS msg FROM treatment_masters;

-- EVENT ---------------------------------------------------------------------

DELETE FROM qc_nd_ed_all_procure_lifestyles;;
   DELETE FROM qc_nd_ed_all_procure_lifestyles_revs;
DELETE FROM event_masters;
   DELETE FROM event_masters_revs;

-- MISC IDENTFIERS -----------------------------------------------------------

DELETE FROM misc_identifiers WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);
   DELETE FROM misc_identifiers_revs WHERE id NOT IN (SELECT id FROM misc_identifiers);

-- CONSENTS ------------------------------------------------------------------

DELETE FROM cd_icm_generics WHERE consent_master_id NOT IN (SELECT ConsentMaster.id FROM consent_masters ConsentMaster INNER JOIN collections Collection ON Collection.participant_id = ConsentMaster.participant_id);
   DELETE FROM cd_icm_generics_revs WHERE consent_master_id NOT IN (SELECT consent_master_id FROM cd_icm_generics);
DELETE FROM qc_nd_cd_generals WHERE consent_master_id NOT IN (SELECT ConsentMaster.id FROM consent_masters ConsentMaster INNER JOIN collections Collection ON Collection.participant_id = ConsentMaster.participant_id);
   DELETE FROM qc_nd_cd_generals_revs WHERE consent_master_id NOT IN (SELECT consent_master_id FROM qc_nd_cd_generals);
DELETE FROM consent_masters WHERE participant_id NOT IN (SELECT participant_id FROM collections WHERE participant_id IS NOT NULL);
   DELETE FROM consent_masters_revs WHERE id NOT IN (SELECT id FROM consent_masters);

-- MESSAGES -----------------------------------------------------------

DELETE FROM participant_messages WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);
   DELETE FROM participant_messages_revs WHERE id NOT IN (SELECT id FROM participant_messages);

-- REPRODUCTIVE HISTORY -----------------------------------------------------------

DELETE FROM reproductive_histories WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);
   DELETE FROM reproductive_histories_revs WHERE id NOT IN (SELECT id FROM reproductive_histories);


-- PARTICIPANT  -----------------------------------------------------------

SET @participants_total = (SELECT count(*) FROM participants WHERE deleted != 1);
SET @participants_deleted = (SELECT count(*) FROM participants WHERE deleted != 1 AND id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL));
SELECT CONCAT(@participants_deleted, '/' , @participants_total, ' have been deleted') AS participant_deletion_message;

DELETE FROM participants WHERE id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);
   DELETE FROM participants_revs WHERE id NOT IN (SELECT id FROM participants);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- OTHER
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- order

DELETE FROM shipments WHERE id NOT IN (SELECT shipment_id FROM order_items);
   DELETE FROM shipments_revs WHERE id NOT IN (SELECT id FROM shipments);
DELETE FROM order_lines WHERE id NOT IN (SELECT order_line_id FROM order_items);
   DELETE FROM order_lines_revs WHERE id NOT IN (SELECT id FROM order_lines);
DELETE FROM orders WHERE id NOT IN (SELECT order_id FROM shipments) AND id NOT IN (SELECT order_id FROM order_lines);
   DELETE FROM orders_revs WHERE id NOT IN (SELECT id FROM orders);

-- study

CREATE TABLE studies_for_deletion(
  study_summary_id INT NOT NULL
);
INSERT INTO studies_for_deletion (study_summary_id) (SELECT DISTINCT study_summary_id FROM aliquot_masters);
INSERT INTO studies_for_deletion (study_summary_id) (SELECT DISTINCT study_summary_id FROM order_lines) ;
INSERT INTO studies_for_deletion (study_summary_id) (SELECT DISTINCT default_study_summary_id FROM orders) ;
INSERT INTO studies_for_deletion (study_summary_id) (SELECT DISTINCT study_summary_id FROM aliquot_internal_uses);
DELETE FROM study_summaries WHERE id NOT IN (SELECT DISTINCT study_summary_id FROM studies_for_deletion);
   DELETE FROM study_summaries_revs WHERE id NOT IN (SELECT id FROM study_summaries);
DROP TABLE studies_for_deletion;

-- storage

CREATE TABLE storage_masters_for_deletion(
 storage_master_id INT NOT NULL
);
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

CREATE TABLE storage_masters_for_deletion(
 storage_master_id INT NOT NULL
);
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

CREATE TABLE storage_masters_for_deletion(
 storage_master_id INT NOT NULL
);
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

CREATE TABLE storage_masters_for_deletion(
 storage_master_id INT NOT NULL
);
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

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
