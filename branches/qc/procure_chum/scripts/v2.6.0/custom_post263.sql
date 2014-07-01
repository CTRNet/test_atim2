
UPDATE versions SET branch_build_number = '5801' WHERE version_number = '2.6.3';
ALTER TABLE versions ADD COLUMN `site_branch_build_number` varchar(45) DEFAULT '';
