UPDATE datamart_structure_functions fct, datamart_structures str 
SET fct.flag_active = 0 
WHERE fct.datamart_structure_id = str.id AND str.model IN ('TmaBlock', 'TmaSlide');

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaBlock', 'TmaSlide')) 
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaBlock', 'TmaSlide'));

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '?' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;
