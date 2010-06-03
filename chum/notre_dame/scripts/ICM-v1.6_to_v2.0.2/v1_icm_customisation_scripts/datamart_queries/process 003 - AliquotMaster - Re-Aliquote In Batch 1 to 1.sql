DELETE FROM `datamart_batch_processes` 
WHERE `id` = 3;

INSERT INTO `datamart_batch_processes` 
( `id` , `name` , `model` , `url` )
VALUES (
3 , 'Re-Aliquote In Batch (1 to 1)', 'AliquotMaster', '/inventorymanagement/aliquot_masters/realiquoteInBatchFstStep/');

