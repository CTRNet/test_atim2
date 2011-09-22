-- run post 2.3.5 install.

UPDATE structure_formats 
SET structure_field_id = (SELECT id FROM structure_fields WHERE language_tag LIKE '' AND field = 'major_hepatectomy_3_segments_or_more') 
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE language_label  LIKE '' AND field = 'major_hepatectomy_3_segments_or_more');

UPDATE structure_formats 
SET structure_field_id = (SELECT id FROM structure_fields WHERE language_tag LIKE '' AND field = 'minor_hepatectomy_less_than_3_segments') 
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE language_label  LIKE '' AND field = 'minor_hepatectomy_less_than_3_segments');

DROP TABLE qc_gastro_qc_scores;
DROP TABLE qc_gastro_qc_scores_revs;

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_gastro_qc_scores');
DELETE FROM structures WHERE alias='qc_gastro_qc_scores';
DELETE FROM structure_fields WHERE tablename = 'qc_gastro_qc_scores';

UPDATE specimen_review_controls SET flag_active = 0;
UPDATE aliquot_review_controls SET flag_active = 0;

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model LIKE 'SpecimenReviewMaster')
OR id2 = (SELECT id FROM datamart_structures WHERE model LIKE 'SpecimenReviewMaster');

