-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'UHN - Main', 'UHN - Principal');
UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE users SET flag_active = '1' WHERE id = 1;

-- xxxx
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '9999' WHERE version_number = '2.7.0';

