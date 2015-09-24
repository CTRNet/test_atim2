-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Created By Bank / Collected By Bank
-- ------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE participants SET procure_last_modification_by_bank = '2';
UPDATE participants_revs SET procure_last_modification_by_bank = '2';
UPDATE consent_masters SET procure_created_by_bank = '2';
UPDATE consent_masters_revs SET procure_created_by_bank = '2';
UPDATE event_masters SET procure_created_by_bank = '2';
UPDATE event_masters_revs SET procure_created_by_bank = '2';
UPDATE treatment_masters SET procure_created_by_bank = '2';
UPDATE treatment_masters_revs SET procure_created_by_bank = '2';

UPDATE collections SET procure_collected_by_bank = '2';
UPDATE collections_revs SET procure_collected_by_bank = '2';
UPDATE sample_masters SET procure_created_by_bank = '2';
UPDATE sample_masters_revs SET procure_created_by_bank = '2';
UPDATE aliquot_masters SET procure_created_by_bank = '2';
UPDATE aliquot_masters_revs SET procure_created_by_bank = '2';
UPDATE aliquot_internal_uses SET procure_created_by_bank = '2';
UPDATE aliquot_internal_uses_revs SET procure_created_by_bank = '2';
UPDATE quality_ctrls SET procure_created_by_bank = '2';
UPDATE quality_ctrls_revs SET procure_created_by_bank = '2';
































































UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '62??' WHERE version_number = '2.6.6';