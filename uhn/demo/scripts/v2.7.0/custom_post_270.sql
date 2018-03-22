-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'UHN - Demo', 'UHN - Demo');
UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE users SET flag_active = '1', `force_password_reset` = '0' WHERE id = 1;



-- xxxx
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '9999' WHERE version_number = '2.7.0';

