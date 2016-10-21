-- ------------------------------------------------------
-- ATiM Database Upgrade Script
-- version: 2.7.1
--
-- For more information:
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update Validation rule name
-- 2016 Feb 29
-- -----------------------------------------------------------------------------------------------------------------------------------
UPDATE structure_validations SET rule='notBlank' WHERE rule='notEmpty';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added Structure for User Password Reset
-- 2016 Oct 21
-- -----------------------------------------------------------------------------------------------------------------------------------
INSERT INTO structures(`alias`) VALUES ('reset_password_struc');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
  ((SELECT id FROM structures WHERE alias='reset_password_struc'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='username' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '0', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
  ((SELECT id FROM structures WHERE alias='reset_password_struc'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '0', '0', '', '0', '', '1', '', '1', 'input', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
  ((SELECT id FROM structures WHERE alias='reset_password_struc'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='new_password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '3', '', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=20', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
  ((SELECT id FROM structures WHERE alias='reset_password_struc'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='confirm_password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=20', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
-- Fix: Set password fields to type password
UPDATE structure_formats SET `flag_override_type`='0', `type`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='reset_password_struc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='0', `type`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='reset_password_struc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='new_password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='0', `type`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='reset_password_struc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='confirm_password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update Version number
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number)
VALUES
  ('2.7.1', NOW(),'6569','6570');
