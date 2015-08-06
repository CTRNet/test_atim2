-- ------------------------------------------------------
-- ATiM v2.6.6 Upgrade Script
-- version: 2.6.6
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('content','Content','Contenu');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lines','Lines','Lignes');
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update system table deleting unused fields (created, etc) or changing unnecessary fields default value
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_reports 
  DROP COLUMN created, 
  DROP COLUMN created_by, 
  DROP COLUMN modified, 
  DROP COLUMN modified_by;
ALTER TABLE pages 
  DROP COLUMN created, 
  DROP COLUMN created_by, 
  DROP COLUMN modified, 
  DROP COLUMN modified_by;
ALTER TABLE structure_validations
 MODIFY `language_message` text DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #: ...
-- -----------------------------------------------------------------------------------------------------------------------------------

























-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.6', NOW(),'???','n/a');
