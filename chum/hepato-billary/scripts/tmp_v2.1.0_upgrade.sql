-- Version: v2.1.0
-- Description: This SQL script is an upgrade for ATiM v2.0.2A to 2.1.0 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.1.0 (Alpha)', `date_installed` = CURDATE(), `build_number` = ''
WHERE `versions`.`id` =1;
