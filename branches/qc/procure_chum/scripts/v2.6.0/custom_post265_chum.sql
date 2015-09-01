-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Delete studies
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_internal_uses SET study_summary_id = NULL;
UPDATE aliquot_internal_uses_revs SET study_summary_id = NULL;
UPDATE aliquot_masters SET study_summary_id = NULL;
UPDATE aliquot_masters_revs SET study_summary_id = NULL;

SELECT title as 'Deleted Studies' from study_summaries WHERE deleted <> 1;
DELETE FROM study_summaries;
DELETE FROM study_summaries_revs;

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- ALiquot Internal Uses
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Quality Control PROCURE (returned) & Quality Control PROCURE (sent)

SELECT "Replaced 'Quality Control PROCURE (returned)' and 'Quality Control PROCURE (sent)' by 'Sent To Processing Site' and 'Received From Processing Site'" AS '### MESSAGE ###';

UPDATE aliquot_internal_uses
SET use_details = CONCAT(use_code, ' ',use_details)
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses
SET use_details = use_code
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NULL;
UPDATE aliquot_internal_uses
SET  use_code = 'Quality Control'
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses
SET  type = 'received from processing site'
WHERE type IN ('quality control procure (returned))');
UPDATE aliquot_internal_uses
SET  type = 'sent to processing site'
WHERE type IN ('quality control procure (sentt)');

UPDATE aliquot_internal_uses_revs
SET use_details = CONCAT(use_code, ' ',use_details)
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses_revs
SET use_details = use_code
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)') 
AND use_code NOT IN ('Quality Control', ' Quality Control')
AND use_details IS NULL;
UPDATE aliquot_internal_uses_revs
SET  use_code = 'Quality Control'
WHERE type IN ('quality control procure (returned))', 'quality control procure (sentt)')
AND use_details IS NOT NULL;
UPDATE aliquot_internal_uses_revs
SET  type = 'received from processing site'
WHERE type IN ('quality control procure (returned))');
UPDATE aliquot_internal_uses_revs
SET  type = 'sent to processing site'
WHERE type IN ('quality control procure (sentt)');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value  IN ('quality control procure (returned))', 'quality control procure (sentt)');

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------------------




















































UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '62??' WHERE version_number = '2.6.5';
