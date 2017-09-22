
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Databrowser
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SpecimenReviewMaster ViewSample
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
-- OrderItem TmaSlide
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
-- AliquotReviewMaster ViewAliquot
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
-- AliquotReviewMaster SpecimenReviewMaster
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster');
-- ViewAliquot StudySummary
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str 
SET fct.flag_active = '1' 
WHERE fct.datamart_structure_id = str.id AND str.model = 'SpecimenReviewMaster' AND label = 'number of elements per participant';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' 
WHERE fct.datamart_structure_id = str.id AND str.model = 'AliquotReviewMaster' AND label = 'number of elements per participant';

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'report_ctrnet_catalogue_name';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Actions
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' 
WHERE fct.datamart_structure_id = str.id 
AND str.model = 'TmaSlide' AND label = 'add tma slide use';

UPDATE datamart_structure_functions fct, datamart_structures str 
SET fct.flag_active = '0' 
WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlideUse' AND label = 'edit';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Users
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE users SET  flag_active = 0 WHERE group_id != 1;
SET @password = (SELECT password from users where username = 'NicoEn');
UPDATE users SET password = @password, deleted = 1 WHERE group_id != 1 OR flag_active = 0;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inventory Revision
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Collection

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='1');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Versions
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE `versions` SET branch_build_number = '6875' WHERE version_number = '2.7.0';
