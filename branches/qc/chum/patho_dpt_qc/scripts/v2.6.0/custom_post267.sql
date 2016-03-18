
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Sources');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('appendix', 'Appendix', 'Appendice', '1', @control_id, NOW(), NOW(), 1, 1),
('tonsil', 'Tonsil', 'Amygdale', '1', @control_id, NOW(), NOW(), 1, 1),
('pancreas', 'Pancreas', 'Pancréas', '1', @control_id, NOW(), NOW(), 1, 1),
('liver', 'Liver', 'Foie', '1', @control_id, NOW(), NOW(), 1, 1),
('brain', 'Brain', 'Cerveau', '1', @control_id, NOW(), NOW(), 1, 1),
('skeletal muscles', 'Skeletal muscle', 'Muscles squelettiques', '1', @control_id, NOW(), NOW(), 1, 1),
('skin', 'Skin', 'Peau', '1', @control_id, NOW(), NOW(), 1, 1),
('melanoma', 'Melanoma', 'Mélanome', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('lung', 'Lung', 'Poumon', '1', @control_id, NOW(), NOW(), 1, 1),
('thyroid', 'Thyroid', 'Thyroïde', '1', @control_id, NOW(), NOW(), 1, 1),
('prostate', 'Prostate', 'Prostate', '1', @control_id, NOW(), NOW(), 1, 1),
('placenta', 'Placenta', 'Placenta', '1', @control_id, NOW(), NOW(), 1, 1),
('thymus', 'Thymus', 'Thymus', '1', @control_id, NOW(), NOW(), 1, 1),
('bone marrow', 'Bone marrow', 'Moelle osseuse', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('colon', 'Colon', 'Colon', '1', @control_id, NOW(), NOW(), 1, 1),
('Hodgkin''s lymphoma', 'Hodgkin''s lymphoma', 'Lymphome Hodgkinien', '1', @control_id, NOW(), NOW(), 1, 1),
('Anaplastic lymphoma CD30', 'Anaplastic lymphoma CD30', 'Lymphome anaplasique CD30', '1', @control_id, NOW(), NOW(), 1, 1),
('kidney', 'Kidney', 'Rein', '1', @control_id, NOW(), NOW(), 1, 1),
('breast', 'Breast', 'Sein', '1', @control_id, NOW(), NOW(), 1, 1),
('stomach', 'Stomach', 'Estomac', '1', @control_id, NOW(), NOW(), 1, 1);

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaSlide', 'TmaBLock'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaSlide', 'TmaBLock'));

UPDATE datamart_structure_functions SET flag_active = 0
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('TmaSlide', 'TmaBLock'))
OR label IN ('create tma slide');

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'))
AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'));

UPDATE versions SET branch_build_number = '6452' WHERE version_number = '2.6.7';
