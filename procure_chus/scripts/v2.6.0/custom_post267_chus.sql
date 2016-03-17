UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ParticipantContact', 'ParticipantMessage')) 
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ParticipantContact', 'ParticipantMessage'));

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '?' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;
