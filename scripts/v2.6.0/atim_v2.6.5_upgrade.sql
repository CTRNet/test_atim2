-- ------------------------------------------------------
-- ATiM v2.6.5 Upgrade Script
-- version: 2.6.5
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

ALTER TABLE groups MODIFY deleted tinyint(3) unsigned NOT NULL DEFAULT '0';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3220: Unable to export report in CSV when the number of records is > databrowser_and_report_results_display_limit
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lines','Lines','Lignes');






-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

update versions set permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.5', NOW(),'xxxx','n/a');
