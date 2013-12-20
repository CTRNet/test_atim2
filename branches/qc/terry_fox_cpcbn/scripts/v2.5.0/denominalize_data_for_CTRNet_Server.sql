
UPDATE participants SET date_of_birth = NULL, date_of_birth_accuracy = '';
UPDATE participants_revs SET date_of_birth = NULL, date_of_birth_accuracy = '';
UPDATE participants SET date_of_death = CONCAT(SUBSTRING(date_of_death, 1, 8),'01'), date_of_death_accuracy = 'd' WHERE date_of_death IS NOT NULL;
UPDATE participants_revs SET date_of_death = CONCAT(SUBSTRING(date_of_death, 1, 8),'01'), date_of_death_accuracy = 'd' WHERE date_of_death IS NOT NULL;
UPDATE participants SET date_of_death = CONCAT(SUBSTRING(qc_tf_suspected_date_of_death, 1, 8),'01'), qc_tf_suspected_date_of_death_accuracy = 'd' WHERE qc_tf_suspected_date_of_death_accuracy IS NOT NULL;
UPDATE participants_revs SET date_of_death = CONCAT(SUBSTRING(qc_tf_suspected_date_of_death, 1, 8),'01'), qc_tf_suspected_date_of_death_accuracy = 'd' WHERE qc_tf_suspected_date_of_death_accuracy IS NOT NULL;

UPDATE banks SET name = CONCAT('Bank #',id);
UPDATE banks_revs SET name = CONCAT('Bank #',id);

UPDATE groups SET name = CONCAT('Group #',id) WHERE id > 3;

UPDATE storage_masters SET qc_tf_tma_name = CONCAT('#',id);
UPDATE storage_masters_revs SET qc_tf_tma_name = CONCAT('#',id);

UPDATE aliquot_masters SET aliquot_label = SUBSTRING(aliquot_label, 1, (LOCATE('[', aliquot_label) -2));
UPDATE aliquot_masters_Revs SET aliquot_label = SUBSTRING(aliquot_label, 1, (LOCATE('[', aliquot_label) -2));

UPDATE collections SET collection_site = null;
UPDATE collections_revs SET collection_site = null;

UPDATE versions SET permissions_regenerated = 0;

TRUNCATE TABLE datamart_browsing_indexes;
TRUNCATE TABLE datamart_browsing_indexes_revs;
DELETE FROM datamart_browsing_results;
