-- -------------------------------------------------------------------------------------
-- MODIFIED SCRIPT FOR ATiM CENTRAL
-- -------------------------------------------------------------------------------------
--
-- To execute after 
--    - atim_procure_central_full_installation_v271_revs_7299_7339_7345.sql
--    - atim_v2.7.1_upgrade.sql
--
-- @author Nicolas Luc
-- @date 2018-09-07
-- -------------------------------------------------------------------------------------
 
 -- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7339' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Anonymize local database fields 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- study_summaries
-- ---------------

--  Renmoved unusefull queries on study_summaries

UPDATE structure_fields SET language_label = 'committee_convenience_ps1' WHERE field = 'procure_site_ethics_committee_convenience_ps1';
UPDATE structure_fields SET language_label = 'committee_convenience_ps4' WHERE field = 'procure_site_ethics_committee_convenience_ps4';
UPDATE structure_fields SET language_label = 'committee_convenience_ps2' WHERE field = 'procure_site_ethics_committee_convenience_ps2';
UPDATE structure_fields SET language_label = 'committee_convenience_ps3' WHERE field = 'procure_site_ethics_committee_convenience_ps3';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('committee_convenience_ps1', 'PS1', 'PS1'),
('committee_convenience_ps2', 'PS2', 'PS2'),
('committee_convenience_ps3', 'PS3', 'PS3'),
('committee_convenience_ps4', 'PS4', 'PS4');

-- procure_cd_sigantures & consent_controls
-- ----------------------------------------
-- Uncomment line that could not be applied on local installation

-- Linked to PS1 fields

--  Renmoved unusefull queries on study_summaries

-- Linked to PS2 fields

--  Renmoved unusefull queries on study_summaries
  
-- Linked to PS4 fields

--  Renmoved unusefull queries on study_summaries

UPDATE versions SET branch_build_number = '7347' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7389' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7403' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7411' WHERE version_number = '2.7.1';