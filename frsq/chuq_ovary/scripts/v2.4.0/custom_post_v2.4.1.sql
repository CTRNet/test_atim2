SET @id = (SELECT id FROM `datamart_structures` WHERE `model` LIKE 'TreatmentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = @id OR id2 = @id;

UPDATE sample_masters samp, sample_masters parent, sample_controls parentctrl
SET samp.parent_sample_type = parentctrl.sample_type
WHERE samp.parent_id = parent.id
AND parent.sample_control_id = parentctrl.id
AND samp.parent_id IS NOT NULL;

UPDATE sample_masters_revs samp, sample_masters parent, sample_controls parentctrl
SET samp.parent_sample_type = parentctrl.sample_type
WHERE samp.parent_id = parent.id
AND parent.sample_control_id = parentctrl.id
AND samp.parent_id IS NOT NULL;

SELECT '*******************' as msg_parent_type_update
UNION
SELECT 'Check sample parent types are correctly updated!' as msg_parent_type_update;

SELECT distinct samp.parent_sample_type as main_parent_sample_type, parentctrl.sample_type as real_parent_sample_type
FROM sample_masters as samp 
LEFT JOIN sample_masters as parent ON samp.parent_id = parent.id
LEFT JOIN sample_controls as parentctrl ON parent.sample_control_id = parentctrl.id;

SELECT distinct samp.parent_sample_type as revs_parent_sample_type, parentctrl.sample_type as real_parent_sample_type
FROM sample_masters_revs as samp 
LEFT JOIN sample_masters as parent ON samp.parent_id = parent.id
LEFT JOIN sample_controls as parentctrl ON parent.sample_control_id = parentctrl.id;

UPDATE sample_controls SET form_alias = 'sample_masters,sd_undetailed_derivatives,derivatives' WHERE form_alias = 'sample_masters,sd_undetailed_derivatives,derivatives,';
