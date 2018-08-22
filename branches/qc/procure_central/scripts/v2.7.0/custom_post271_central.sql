INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('committee_convenience_ps1', 'PS1', 'PS1'),
('committee_convenience_ps2', 'PS2', 'PS2'),
('committee_convenience_ps3', 'PS3', 'PS3'),
('committee_convenience_ps4', 'PS4', 'PS4');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '73xxx' WHERE version_number = '2.7.1';