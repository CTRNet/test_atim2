DELETE FROM `datamart_batch_processes` 
WHERE `id` = 2;

INSERT INTO `datamart_batch_processes` 
( `id` , `name` , `model` , `url` )
VALUES (
2 , 'Change Aliquot(s) Position/Status', 'AliquotMaster', '/inventorymanagement/aliquot_masters/changeAliquotsPositionStatusInBatch/');

