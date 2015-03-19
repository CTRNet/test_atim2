-- BCCH v0.1 patch
-- For fixing issue with broken links when browsing
-- Stephen Fung 2015-03-19
-- Eventum ID:
-- JIRA ID: BB-27

-- Fixing aliquots with old sample label

UPDATE sample_masters
SET `initial_specimen_sample_id`=`id`
WHERE `id` NOT IN (SELECT `sample_master_id` FROM derivative_details);

UPDATE sample_masters_revs
SET `initial_specimen_sample_id`=`id`
WHERE `id` NOT IN (SELECT `sample_master_id` FROM derivative_details);

UPDATE view_samples
SET `initial_specimen_sample_id`=`sample_master_id`, `initial_specimen_sample_control_id`=`sample_control_id`, `initial_specimen_sample_type`=`sample_type`
WHERE `sample_master_id` NOT IN (SELECT `sample_master_id` FROM derivative_details) AND `parent_id` IS NULL;


-- Fixing derivatives with old sample label

UPDATE sample_masters
SET `initial_specimen_sample_id`=`parent_id`
WHERE `id` IN (SELECT `sample_master_id` FROM derivative_details);

UPDATE sample_masters_revs
SET `initial_specimen_sample_id`=`parent_id`
WHERE `id` IN (SELECT `sample_master_id` FROM derivative_details);

UPDATE view_samples
SET `initial_specimen_sample_id`=`parent_id`, `initial_specimen_sample_type`=`parent_sample_type`, `initial_specimen_sample_control_id`=`parent_sample_control_id`
WHERE `sample_master_id` IN (SELECT `sample_master_id` FROM derivative_details) AND `parent_id` IS NOT NULL;
