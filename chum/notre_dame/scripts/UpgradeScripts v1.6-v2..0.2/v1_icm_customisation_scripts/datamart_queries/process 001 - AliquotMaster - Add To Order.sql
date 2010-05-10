DELETE FROM `datamart_batch_processes` 
WHERE `id` = 1;

INSERT INTO `datamart_batch_processes` 
( `id` , `name` , `model` , `url` )
VALUES (
1 , 'Add To Order', 'AliquotMaster', '/order/orders/process_add_aliquots/');