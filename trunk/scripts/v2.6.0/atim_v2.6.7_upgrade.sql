-- -----------------------------------------------------------------------------------------------------------------------------------
-- Fix bug on sgbd with 
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_masters MODIFY storage_coord_x varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters MODIFY storage_coord_y varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters_revs MODIFY storage_coord_x varchar(11) DEFAULT NULL;
ALTER TABLE aliquot_masters_revs MODIFY storage_coord_y varchar(11) DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.6.7', NOW(),'????','n/a');

