-- ------------------------------------------------------
-- ATiM v2.6.1 Upgrade Script
-- version: 2.6.1
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#3026: Participant.last_modification update and date accuracy 
-- Create additional check
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT '----------------------------------------------------------------------------------------------------------------' AS 'TODO: Test on profiled date accuracies'
UNION ALL
SELECT 'Please review participant profile dates accuracies for participants listed below (nothing to do if section below empty)' AS  'TODO: Test on profiled date accuracies'
UNION ALL
SELECT 'Test is based to the issue #3026' AS  'TODO: Test on profiled date accuracies'
UNION ALL
SELECT 'Please add reviewed fields if custom dates have been created in participant table' AS  'TODO: Test on profiled date accuracies'
UNION ALL
SELECT '----------------------------------------------------------------------------------------------------------------' AS 'TODO: Test on profiled date accuracies';
SELECT DISTINCT p.id AS participant_id, 
p.participant_identifier, 
'date_of_birth' AS studied_field,
p.date_of_birth AS date, 
p.date_of_birth_accuracy AS date_accuracy, 
p_revs.date_of_birth_accuracy AS date_accuracy_in_revs  
FROM participants p
INNER JOIN participants_revs p_revs ON p.id = p_revs.id
WHERE p.date_of_birth IS NOT NULL AND p.date_of_birth_accuracy = 'c'
AND p.date_of_birth = p_revs.date_of_birth
AND p_revs.date_of_birth_accuracy NOT IN ('', 'c')
UNION ALL
SELECT DISTINCT p.id AS participant_id, 
p.participant_identifier, 
'date_of_death' AS studied_field,
p.date_of_death AS date, 
p.date_of_death_accuracy AS date_accuracy, 
p_revs.date_of_death_accuracy AS date_accuracy_in_revs  
FROM participants p
INNER JOIN participants_revs p_revs ON p.id = p_revs.id
WHERE p.date_of_death IS NOT NULL AND p.date_of_death_accuracy = 'c'
AND p.date_of_death = p_revs.date_of_death
AND p_revs.date_of_death_accuracy NOT IN ('', 'c')
UNION ALL
SELECT DISTINCT p.id AS participant_id, 
p.participant_identifier, 
'last_chart_checked_date' AS studied_field,
p.last_chart_checked_date AS date, 
p.last_chart_checked_date_accuracy AS date_accuracy, 
p_revs.last_chart_checked_date_accuracy AS date_accuracy_in_revs  
FROM participants p
INNER JOIN participants_revs p_revs ON p.id = p_revs.id
WHERE p.last_chart_checked_date IS NOT NULL AND p.last_chart_checked_date_accuracy = 'c'
AND p.last_chart_checked_date = p_revs.last_chart_checked_date
AND p_revs.last_chart_checked_date_accuracy NOT IN ('', 'c');
SELECT '----------------------------------------------------------------------------------------------------------------' AS 'END: Test on profiled date accuracies';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Size Of structure_permissible_values_customs.value
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE structure_permissible_values_customs MODIFY `value` varchar(250) NOT NULL;
ALTER TABLE structure_permissible_values_customs_revs MODIFY `value` varchar(250) NOT NULL;
SELECT IF(COUNT(*) = 0,
"Nothing to do", 
"Please set your own statement to alter structure_permissible_values_customs.value size."
) AS 'Control of structure_permissible_values_customs.value size (1)' 
FROM (SELECT LENGTH(value) AS lg FROM structure_permissible_values_customs) AS res WHERE res.lg > 250;
SELECT IF(COUNT(*) = 0,
"Nothing to do", 
"Please set your own statement to alter structure_permissible_values_customs.value size."
) AS 'Control of structure_permissible_values_customs.value size (2)' 
FROM  structure_permissible_values_custom_controls WHERE LENGTH(name) > 250;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add rebuild lft rght for storage_masters
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr) VALUES ('rebuilt lft rght for storage_masters','Rebuilt lft & rght for storage_masters', 'Les valeurs lft & rght de storage_masters ont été regénérées');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.1', NOW(),'5695','n/a');
