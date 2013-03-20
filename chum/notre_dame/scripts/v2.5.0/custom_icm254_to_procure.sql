-- to run after custom254.sql
-- use to delete all procure data

SET @procure_study_summary_id = (SELECT id FROM study_summaries WHERE title = 'PROCURE');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- INVENTORY
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- ALIQUOT CLEAN UP ----------------------------------------------------------

DELETE FROM aliquot_internal_uses WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM source_aliquots WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM quality_ctrls WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM order_items WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
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

DELETE FROM ad_tubes WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM ad_blocks WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM ad_tissue_slides WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM ad_whatman_papers WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM ad_cell_slides WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM ad_tissue_cores WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM ad_gel_matrices WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);
DELETE FROM ad_cell_cores WHERE aliquot_master_id NOT IN (SELECT id FROM aliquot_masters WHERE study_summary_id = @procure_study_summary_id);

DELETE FROM aliquot_masters WHERE study_summary_id != @procure_study_summary_id OR study_summary_id IS NULL;

-- SAMPLE CLEAN UP -----------------------------------------------------------

DELETE FROM quality_ctrls WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);

SELECT IF(COUNT(*) = 0, 'No specimen review errors', 'Please check table specimen_review_masters') AS msg FROM specimen_review_masters;

DELETE FROM sd_spe_ascites WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_bloods WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_tissues WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_urines WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_ascite_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_ascite_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_blood_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_pbmcs WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_plasmas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_serums WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_cell_cultures WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_dnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_rnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_urine_cons WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_urine_cents WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_amp_rnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_b_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_cdnas WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_tiss_lysates WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_tiss_susps WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_peritoneal_washes WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_cystic_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_other_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_pw_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_pw_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_cystic_fl_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_cystic_fl_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_of_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_of_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_pericardial_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_pleural_fluids WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_pericardial_fl_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_pericardial_fl_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_pleural_fl_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_pleural_fl_sups WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_cell_lysates WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_proteins WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_spe_bone_marrows WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_bone_marrow_susps WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM sd_der_no_b_cells WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);

DELETE FROM specimen_details WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);
DELETE FROM derivative_details WHERE sample_master_id NOT IN (SELECT DISTINCT SampleMaster.id FROM sample_masters SampleMaster INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.collection_id = AliquotMaster.collection_id);

UPDATE sample_masters SET initial_specimen_sample_id = null WHERE collection_id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters);
UPDATE sample_masters SET parent_id = null WHERE collection_id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters);
DELETE FROM sample_masters WHERE collection_id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters);

-- COLLECTIONS ---------------------------------------------------------------

DELETE FROM collections WHERE id NOT IN (SELECT collection_id FROM sample_masters);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- PARTICIPANT
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- TREATMENT -----------------------------------------------------------------

SELECT IF(COUNT(*) = 0, 'No treatment errors', 'Please check treatments') AS msg FROM treatment_masters;

-- EVENT ---------------------------------------------------------------------

DELETE FROM qc_nd_ed_all_procure_lifestyles WHERE event_master_id NOT IN (SELECT EventMaster.id FROM event_masters EventMaster INNER JOIN collections Collection ON Collection.participant_id = EventMaster.participant_id);
DELETE FROM event_masters WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);

-- MISC IDENTFIERS -----------------------------------------------------------

DELETE FROM misc_identifiers WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);

-- CONSENTS ------------------------------------------------------------------

DELETE FROM cd_icm_generics WHERE consent_master_id NOT IN (SELECT ConsentMaster.id FROM consent_masters ConsentMaster INNER JOIN collections Collection ON Collection.participant_id = ConsentMaster.participant_id);
DELETE FROM qc_nd_cd_generals WHERE consent_master_id NOT IN (SELECT ConsentMaster.id FROM consent_masters ConsentMaster INNER JOIN collections Collection ON Collection.participant_id = ConsentMaster.participant_id);
DELETE FROM consent_masters WHERE participant_id NOT IN (SELECT participant_id FROM collections WHERE participant_id IS NOT NULL);

-- MESSAGES -----------------------------------------------------------

DELETE FROM participant_messages WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);

-- REPRODUCTIVE HISTORY -----------------------------------------------------------

DELETE FROM reproductive_histories WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);

-- REPRODUCTIVE HISTORY -----------------------------------------------------------

DELETE FROM reproductive_histories WHERE participant_id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);

-- PARTICIPANT  -----------------------------------------------------------

DELETE FROM participants WHERE id NOT IN (SELECT DISTINCT participant_id FROM collections WHERE participant_id IS NOT NULL);




















UPDATE versions SET permissions_regenerated = 0;














