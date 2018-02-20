
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

UPDATE versions SET site_branch_build_number = '6667' WHERE version_number = '2.6.8';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE users SET username = 'NicoEn', flag_active = '1' WHERE id = 1;
UPDATE versions SET site_branch_build_number = '6745' WHERE version_number = '2.6.8';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- procure_last_contact & qc_nd_last_contact

UPDATE participants SET procure_last_contact = qc_nd_last_contact, procure_last_contact_accuracy = 'c' WHERE qc_nd_last_contact IS NOt NULL;
UPDATE participants_revs SET procure_last_contact = qc_nd_last_contact, procure_last_contact_accuracy = 'c' WHERE qc_nd_last_contact IS NOt NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_last_contact' AND `language_label`='last contact' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_last_contact' AND `language_label`='last contact' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_last_contact' AND `language_label`='last contact' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE participants CHANGE qc_nd_last_contact procure_deprecated_field_qc_nd_last_contact date DEFAULT NULL;
ALTER TABLE participants_revs CHANGE qc_nd_last_contact procure_deprecated_field_qc_nd_last_contact date;

INSERT INTO i18n (id,en,fr)
(SELECT CONCAT('p.chum - ', i18n.id),CONCAT(en, ' [CHUM Field]'), CONCAT(fr, ' [Champ CHUM]') 
FROM structure_fields SF, i18n 
WHERE (field LIKE 'qc_nd%' OR tablename LIKE 'qc_nd%')
AND language_label = i18n.id
AND language_label NOT LIKE '');
UPDATE structure_fields 
SET language_label = CONCAT('p.chum - ', language_label)
WHERE (field LIKE 'qc_nd%' OR tablename LIKE 'qc_nd%')
AND language_label NOT LIKE '';

INSERT IGNORE INTO i18n (id,en,fr)
(SELECT CONCAT('p.chum - ', i18n.id),CONCAT(en, ' [CHUM Field]'), CONCAT(fr, ' [Champ CHUM]') 
FROM structure_fields SF, i18n 
WHERE (field LIKE 'qc_nd%' OR tablename LIKE 'qc_nd%')
AND language_tag = i18n.id
AND language_tag NOT LIKE '');
UPDATE structure_fields 
SET language_tag = CONCAT('p.chum - ', language_tag)
WHERE (field LIKE 'qc_nd%' OR tablename LIKE 'qc_nd%')
AND language_tag NOT LIKE '' AND language_tag NOT LIKE 'p.chum - %';

UPDATE versions SET site_branch_build_number = '6996' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

UPDATE versions SET site_branch_build_number = '7016' WHERE version_number = '2.6.8';