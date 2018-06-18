-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Set core install name

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'UHN - Main', 'UHN - Principal');

-- Manage default users

update groups set flag_show_confidential = 1 where id = 1;
update users set flag_active = 1, force_password_reset = 0, password_modified = NOW(), password = '81a717c1def10e2d2406a198661abf8fdb8fd6f5' where id = 1;

update users set flag_active = 0, force_password_reset = 1, password = '29c5f24d65f1ea5c1d11314463ee47618856c2a5', deleted = 1 where id > 1;

-- xxxx
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '9999' WHERE version_number = '2.7.0';

