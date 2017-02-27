
-- Ask correction on TreatmentDetail.treatment_type

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Sites (PROCURE values only)');
SELECT "Please change the site of the following treatments with updated list values" AS MSG;
SELECT Participant.participant_identifier, TreatmentMaster.start_date, TreatmentDetail.treatment_type, TreatmentDetail.treatment_site
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON TreatmentMaster.participant_id = Participant.id
INNER JOIN procure_txd_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_site NOT IN (SELECT value FROM structure_permissible_values_customs WHERE control_id = @control_id)
AND TreatmentDetail.treatment_site IS NOT NULL AND TreatmentDetail.treatment_site NOT LIKE '';

UPDATE procure_ed_prostate_cancer_diagnosis SET histologic_grade_gleason_total = REPLACE(histologic_grade_gleason_total, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis SET histologic_grade_primary_pattern =REPLACE(histologic_grade_primary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis SET histologic_grade_secondary_pattern =REPLACE(histologic_grade_secondary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis SET highest_gleason_score_observed =REPLACE(highest_gleason_score_observed, '.', '');

UPDATE procure_ed_prostate_cancer_diagnosis_revs SET histologic_grade_gleason_total = REPLACE(histologic_grade_gleason_total, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis_revs SET histologic_grade_primary_pattern =REPLACE(histologic_grade_primary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis_revs SET histologic_grade_secondary_pattern =REPLACE(histologic_grade_secondary_pattern, '.', '');
UPDATE procure_ed_prostate_cancer_diagnosis_revs SET highest_gleason_score_observed =REPLACE(highest_gleason_score_observed, '.', '');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
UPDATE structure_permissible_values_customs SET use_as_input = 0 WHERE control_id = @control_id AND value IN ('sent to chum', 'received from chum');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('sent to pathologic department','Sent To Pathologic Department (CRCHUM)','Envoyé au département de pathologie (CRCHUM)',  '1', @control_id, NOW(), NOW(), 1, 1),
('received from pathologic department','Received From Pathologic Department (CRCHUM)','Recu du département de pathologie (CRCHUM)',  '1', @control_id, NOW(), NOW(), 1, 1);

-- Version

UPDATE versions SET site_branch_build_number = '6662' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;
