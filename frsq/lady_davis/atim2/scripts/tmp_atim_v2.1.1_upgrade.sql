-- Version: v2.1.1
-- Description: This SQL script is an upgrade for ATiM v2.1.0 to 2.1.1 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.1.1', `date_installed` = CURDATE(), `build_number` = ''
WHERE `versions`.`id` =1;

TRUNCATE `acos`;

-- Fix issue 1178: Mismatch between main tables and revs tables

ALTER TABLE diagnosis_masters_revs
  MODIFY `path_mstage` varchar(15) DEFAULT NULL;
