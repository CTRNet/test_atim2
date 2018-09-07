-- -------------------------------------------------------------------------------------
-- MODIFIED SCRIPT FOR ATiM CENTRAL
-- -------------------------------------------------------------------------------------
--
-- To execute after atim_procure_central_full_installation_v271_revs_7299_7339_7345.sql
-- 
-- @author Nicolas Luc
-- @date 2018-09-07
-- -------------------------------------------------------------------------------------
 
UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'7297','n/a');

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'7299','n/a');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('template init error please contact your administrator', 'An error exists in the field definition. Please contact your administrator.', "Une erreur existe dans la définition du champ. Veuillez contacter votre administrateur.");

UPDATE versions SET trunk_build_number = '7393' WHERE version_number = '2.7.1';
