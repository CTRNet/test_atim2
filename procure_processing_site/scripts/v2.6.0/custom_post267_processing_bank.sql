
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '%ProcureBanksDataMergeSummary%';

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster'));

UPDATE datamart_structure_functions SET flag_active = 0
WHERE datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster'));

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_barcode_errors_list') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6471' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;
