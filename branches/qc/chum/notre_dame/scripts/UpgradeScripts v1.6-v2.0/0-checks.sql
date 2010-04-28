-- check #1 : Test unused aliquot_control_ids that will be deleted
SELECT * FROM aliquot_masters WHERE aliquot_control_id IN ('3', '7', '9');
-- -> res = empty.

-- check #1 : Test unused aliquot_masters fields that will be dropped
SELECT distinct received, received_datetime, received_from, received_id FROM `aliquot_masters` WHERE 1
-- -> All NULL.
