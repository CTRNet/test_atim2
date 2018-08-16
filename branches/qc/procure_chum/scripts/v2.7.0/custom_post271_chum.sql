-- -----------------------------------------------------------------------------------------------------------------------------------
-- Mirgation from v268 to v271
--
-- mysql -u root procurechum --default-character-set=utf8 < atim_v2.7.0_upgrade.sql
-- mysql -u root procurechum --default-character-set=utf8 < custom_pre271.sql
-- mysql -u root procurechum --default-character-set=utf8 < atim_v2.7.1_upgrade.sql
-- mysql -u root procurechum --default-character-set=utf8 < custom_post271.sql
-- mysql -u root procurechum --default-character-set=utf8 < custom_post271_chum.sql
--
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '7325' WHERE version_number = '2.7.1';