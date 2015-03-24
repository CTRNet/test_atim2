-- whatman paper initial storage date moved to note...

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT(AliquotMaster.notes,"\nLa date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL AND AliquotMaster.notes IS NOT NULL AND AliquotMaster.notes NOT LIKE '';

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT("La date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL AND (AliquotMaster.notes IS NULL OR AliquotMaster.notes LIKE '');

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.storage_datetime = null, AliquotMaster.storage_datetime_accuracy = null
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL;

UPDATE aliquot_masters_revs AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT(AliquotMaster.notes,"\nLa date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL AND AliquotMaster.notes IS NOT NULL AND AliquotMaster.notes NOT LIKE '';

UPDATE aliquot_masters_revs AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT("La date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL AND (AliquotMaster.notes IS NULL OR AliquotMaster.notes LIKE '');

UPDATE aliquot_masters_revs AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.storage_datetime = null, AliquotMaster.storage_datetime_accuracy = null
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Clean up procure_txd_followup_worksheet_treatments
-- -----------------------------------------------------------------------------------------------------------------------------------------------








 chemotherapy                  | capecitabine                                            |
 chemotherapy                  | carboplatine                                            |
 chemotherapy                  | chimiotherapie sai                                      |
 chemotherapy                  | chlorambucil                                            |
 chemotherapy                  | cisplatine                                              |
 chemotherapy                  | cyclophosphamide                                        |
 chemotherapy                  | docetaxel                                               |
 chemotherapy                  | docetaxel ou placebo                                    |
 chemotherapy                  | doxetacel                                               |
 chemotherapy                  | fluorouracile                                           |
 chemotherapy                  | gemcitabine                                             |
 chemotherapy                  | methotrexate                                            |
 chemotherapy                  | mitomycine                                              |
 chemotherapy                  | oxaliplatine                                            |
 chemotherapy                  | paclitaxel                                              |
 chemotherapy                  | pemetrexed                                              |
 chemotherapy                  | Protocole 5FU+ carboplatine                             |
 chemotherapy                  | sunitinib                                               |
 chemotherapy                  | Taxotère                                                |
 chemotherapy                  | temsirolimus                                            |
 
 
 

mysql> desc procure_txd_followup_worksheet_treatments;
+------------------------+--------------+------+-----+---------+-------+
| Field                  | Type         | Null | Key | Default | Extra |
+------------------------+--------------+------+-----+---------+-------+
| treatment_type         | varchar(50)  | YES  |     | NULL    |       |
| type                   | varchar(250) | YES  |     | NULL    |       |
| dosage                 | varchar(50)  | YES  |     | NULL    |       |
| treatment_master_id    | int(11)      | NO   | MUL | NULL    |       |
| drug_id                | int(11)      | YES  | MUL | NULL    |       |
| treatment_site         | varchar(100) | YES  |     | NULL    |       |
| radiotherpay_precision | varchar(50)  | YES  |     | NULL    |       |
| treatment_combination  | varchar(50)  | YES  |     | NULL    |       |
| chemotherapy_line      | varchar(3)   | YES  |     | NULL    |       |
+------------------------+--------------+------+-----+---------+-------+
9 rows in set (0.00 sec)

mysql> select distinct treatment_type, type FROM procure_txd_followup_worksheet_treatments ORDER by treatment_type;












