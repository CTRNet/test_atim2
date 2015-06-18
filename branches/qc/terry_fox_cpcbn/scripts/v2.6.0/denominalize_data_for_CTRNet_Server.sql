-- ----------------------------------------------------------------------------------
-- Denominalize data to set up the ATiM CPCBN copy installe on the CTRNet server
-- to be accessible from everywhere
-- ----------------------------------------------------------------------------------
 
-- Banks & Groups


UPDATE banks SET name = CONCAT('Bank #',id);
UPDATE banks_revs SET name = CONCAT('Bank #',id);

UPDATE groups SET name = CONCAT('Group #',id) WHERE id > 3;

-- Participants

UPDATE participants SET date_of_birth = NULL, date_of_birth_accuracy = '';
UPDATE participants_revs SET date_of_birth = NULL, date_of_birth_accuracy = '';

UPDATE participants SET date_of_death = CONCAT(SUBSTRING(date_of_death, 1, 8),'01'), date_of_death_accuracy = 'd' WHERE date_of_death IS NOT NULL;
UPDATE participants_revs SET date_of_death = CONCAT(SUBSTRING(date_of_death, 1, 8),'01'), date_of_death_accuracy = 'd' WHERE date_of_death IS NOT NULL;

UPDATE participants SET qc_tf_suspected_date_of_death = CONCAT(SUBSTRING(qc_tf_suspected_date_of_death, 1, 8),'01'), qc_tf_suspected_date_of_death_accuracy = 'd' WHERE qc_tf_suspected_date_of_death_accuracy IS NOT NULL;
UPDATE participants_revs SET qc_tf_suspected_date_of_death = CONCAT(SUBSTRING(qc_tf_suspected_date_of_death, 1, 8),'01'), qc_tf_suspected_date_of_death_accuracy = 'd' WHERE qc_tf_suspected_date_of_death_accuracy IS NOT NULL;

UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'CHUM', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'CHUQ', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'CUSM', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'HDQ', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'McGill', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'MUHC', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'UHN', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'Toronto', '{bank}');
UPDATE participants SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'VPC', '{bank}');

UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'CHUM', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'CHUQ', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'CUSM', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'HDQ', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'McGill', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'MUHC', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'UHN', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'Toronto', '{bank}');
UPDATE participants_revs SET qc_tf_bank_participant_identifier = REPLACE(qc_tf_bank_participant_identifier, 'VPC', '{bank}');

-- Collections & Samples & Aliquots

UPDATE collections SET collection_site = null;
UPDATE collections_revs SET collection_site = null;

UPDATE sample_masters SET qc_tf_tma_sample_control_bank_id = null;
UPDATE sample_masters_revs SET qc_tf_tma_sample_control_bank_id = null;

UPDATE aliquot_masters SET aliquot_label = '';
UPDATE aliquot_masters_revs SET aliquot_label = '';

-- Storages

UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'CHUM', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'CHUQ', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'CUSM', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'HDQ', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'McGill', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'MUHC', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'UHN', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'Toronto', '{bank}');
UPDATE storage_masters SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'VPC', '{bank}');

UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'CHUM', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'CHUQ', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'CUSM', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'HDQ', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'McGill', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'MUHC', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'UHN', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'Toronto', '{bank}');
UPDATE storage_masters SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'VPC', '{bank}');

UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'CHUM', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'CHUQ', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'CUSM', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'HDQ', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'McGill', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'MUHC', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'UHN', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'Toronto', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_name = REPLACE(qc_tf_tma_name, 'VPC', '{bank}');

UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'CHUM', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'CHUQ', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'CUSM', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'HDQ', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'McGill', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'MUHC', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'UHN', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'Toronto', '{bank}');
UPDATE storage_masters_revs SET qc_tf_tma_label_site = REPLACE(qc_tf_tma_label_site, 'VPC', '{bank}');

-- System

UPDATE versions SET permissions_regenerated = 0;

TRUNCATE TABLE datamart_browsing_indexes;
DELETE FROM datamart_browsing_results;

TRUNCATE user_login_attempts;

UPDATE users SET `first_name` = id, `last_name`= id, `email` = null, `department`= null, `job_title`= null, `institution`= null, `laboratory`= null, 
`street`= null, `city`= null, `region`= null, `country`= null, `mail_code`= null, `phone_work`= null, `phone_home`= null;
UPDATE users_revs SET `first_name` = id, `last_name`= id, `email` = null, `department`= null, `job_title`= null, `institution`= null, `laboratory`= null, 
`street`= null, `city`= null, `region`= null, `country`= null, `mail_code`= null, `phone_work`= null, `phone_home`= null;

