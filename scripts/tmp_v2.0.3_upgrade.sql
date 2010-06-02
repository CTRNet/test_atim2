-- Version: v2.0.3
-- Description: This SQL script is an upgrade for ATiM v2.0.2. to 2.0.3. and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.3', `date_installed` = CURDATE(), `build_number` = ''
WHERE `versions`.`id` =1;

