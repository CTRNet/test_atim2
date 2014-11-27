-- ------------------------------------------------------
-- ATiM v2.6.4 Upgrade Script
-- version: 2.6.4
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3114: Use of Manage reusable identifiers generates bug
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET use_link = '/Administrate/ReusableMiscIdentifiers/index' WHERE use_link = '/Administrate/MiscIdentifiers/index';
INSERT INTO i18n (id,en,fr) VALUES ('manage', 'Manage', 'Gérer');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue: Change datamart_browsing_results id_csv to allow system to keep more than 10000 records
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_browsing_results MODIFY  id_csv longtext NOT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.4', NOW(),'???','n/a');
