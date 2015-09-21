
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Update created by
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE participants SET procure_last_modification_by_bank = '4';
UPDATE participants_revs SET procure_last_modification_by_bank = '4';
UPDATE consent_masters SET procure_created_by_bank = '4';
UPDATE consent_masters_revs SET procure_created_by_bank = '4';
UPDATE event_masters SET procure_created_by_bank = '4';
UPDATE event_masters_revs SET procure_created_by_bank = '4';
UPDATE treatment_masters SET procure_created_by_bank = '4';
UPDATE treatment_masters_revs SET procure_created_by_bank = '4';

UPDATE collections SET procure_collected_by_bank = '4';
UPDATE collections_revs SET procure_collected_by_bank = '4';
UPDATE sample_masters SET procure_created_by_bank = '4';
UPDATE sample_masters_revs SET procure_created_by_bank = '4';
UPDATE aliquot_masters SET procure_created_by_bank = '4';
UPDATE aliquot_masters_revs SET procure_created_by_bank = '4';
UPDATE aliquot_internal_uses SET procure_created_by_bank = '4';
UPDATE aliquot_internal_uses_revs SET procure_created_by_bank = '4';
UPDATE quality_ctrls SET procure_created_by_bank = '4';
UPDATE quality_ctrls_revs SET procure_created_by_bank = '4';

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Concentrated Urine Clean Up
-- -----------------------------------------------------------------------------------------------------------------------------------------------

SET @conc_urine_ctr_id = (SELECT id FROM sample_controls WHERE sample_type = 'concentrated urine');
SET @cent_urine_ctr_id = (SELECT id FROM sample_controls WHERE sample_type = 'centrifuged urine');
INSERT INTO sd_der_urine_cents (sample_master_id, procure_concentrated) (SELECT sample_master_id, 'y' FROM  sd_der_urine_cons INNER JOIN sample_masters ON id = sample_master_id AND sample_control_id = @conc_urine_ctr_id);
INSERT INTO sd_der_urine_cents_revs (sample_master_id, version_created, procure_concentrated) (SELECT sample_master_id, version_created, 'y' FROM  sd_der_urine_cons_revs INNER JOIN sample_masters ON id = sample_master_id AND sample_control_id = @conc_urine_ctr_id);
UPDATE sample_masters SET sample_control_id = @cent_urine_ctr_id WHERE sample_control_id = @conc_urine_ctr_id;
UPDATE sample_masters_revs SET sample_control_id = @cent_urine_ctr_id WHERE sample_control_id = @conc_urine_ctr_id;
UPDATE sample_masters SET parent_sample_type = 'centrifuged urine' WHERE parent_sample_type = 'concentrated urine';
UPDATE sample_masters_revs SET parent_sample_type = 'centrifuged urine' WHERE parent_sample_type = 'concentrated urine';
DELETE FROM sd_der_urine_cons;
DELETE FROM sd_der_urine_cons_revs;
SET @conc_urine_tube_ctr_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'tube' AND sample_control_id = @conc_urine_ctr_id);
SET @cent_urine_tube_ctr_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'tube' AND sample_control_id = @cent_urine_ctr_id);
UPDATE aliquot_masters SET aliquot_control_id =  @cent_urine_tube_ctr_id WHERE aliquot_control_id =  @conc_urine_tube_ctr_id;
UPDATE aliquot_masters_revs SET aliquot_control_id =  @cent_urine_tube_ctr_id WHERE aliquot_control_id =  @conc_urine_tube_ctr_id;
UPDATE aliquot_controls SET flag_active = 0 WHERE id =  @conc_urine_tube_ctr_id;
UPDATE parent_to_derivative_sample_controls SET flag_active = 0 WHERE derivative_sample_control_id = @conc_urine_ctr_id;












Verifier avec benoit si on doit ajouter le numero de patho au block et slide. pour l'instant ce numero est dans le label.
Verifier comment cela se passe pour l'export.



























UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '62??' WHERE version_number = '2.6.5';
