-- check #1 : Test unused aliquot_control_ids that will be deleted
SELECT * FROM aliquot_masters WHERE aliquot_control_id IN ('3', '7', '9');
-- -> res = empty.

-- check #2 : Test unused aliquot_masters fields that will be dropped
SELECT distinct received, received_datetime, received_from, received_id FROM `aliquot_masters` WHERE 1;
-- -> All NULL.

-- check #3 : Test unused order_lines fields that will be dropped
SELECT DISTINCT `cancer_type` , `quantity_UM` , `min_qty_UM` , `base_price` , `discount_id` , `product_id`
FROM `order_lines`;
-- -> All NULL.

-- check #4 : Test unused order_items fields that will be dropped
SELECT DISTINCT `base_price` FROM `order_items`;
-- -> All NULL.