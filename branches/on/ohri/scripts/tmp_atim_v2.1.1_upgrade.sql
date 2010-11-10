-- Version: v2.1.1
-- Description: This SQL script is an upgrade for ATiM v2.1.0A to 2.1.1 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.1.1-Alpha', NOW(), '');

TRUNCATE `acos`; 
  