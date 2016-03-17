UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '?' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;
