-- Version: v2.0.2
-- Description: This SQL script is an upgrade for ATiM v2.0.0 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.2', `date_installed` = '2010-04-12', `build_number` = ''
WHERE `versions`.`id` =1;

-- Eventum 848
DELETE FROM i18n WHERE id IN ('1', '2', '3', '4', '5');