DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

UPDATE storage_controls SET coord_x_title = 'column', coord_y_title = 'row' WHERE storage_type IN ('box21 1A-3I','box169 1A-13M');

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND str.model IN ('AliquotReviewMaster', 'SpecimenReviewMaster', 'FamilyHistory', 'ReproductiveHistory');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('AliquotReviewMaster', 'SpecimenReviewMaster', 'FamilyHistory', 'ReproductiveHistory')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('AliquotReviewMaster', 'SpecimenReviewMaster', 'FamilyHistory', 'ReproductiveHistory'));

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'Tissue Source' WHERE name = 'tissue source';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis', name = 'Lymphoma Types' WHERE name = 'lymphoma types';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis', name = 'Lymphoma Progression Sites' WHERE name = 'lymphoma progression sites';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Biopsy Sites' WHERE name = 'biopsy sites';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical', name = 'Vital Status at Follow-up' WHERE name = 'vital status at follow-up';
