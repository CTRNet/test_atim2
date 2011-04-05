-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.1 alpha', NOW(), '> 2838');

ALTER TABLE users 
 DROP COLUMN last_visit;