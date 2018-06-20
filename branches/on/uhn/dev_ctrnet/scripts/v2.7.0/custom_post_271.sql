-- -----------------------------------------------------------------------------------------------------------------------------------
--
-- UHN - Initial Customization
--
-- -----------------------------------------------------------------------------------------------------------------------------------
--   Download scripts in following order:
--           - atim_v2.7.0_full_installation.sql
--           - atim_v2.7.1_upgrade.sql
--           - custom_post_271.sql
--    
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Set Up ATiM Install Name
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Set core install name

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'UHN - Main', 'UHN - Principal');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Manage Default Users
--   Delete all users except the first one
--   WARNING: The 'administrator' user have to be managed when the application will be migrated in PROD
-- -----------------------------------------------------------------------------------------------------------------------------------

update groups set flag_show_confidential = 1 where id = 1;
update users set flag_active = 1, force_password_reset = 0, password_modified = NOW(), password = '81a717c1def10e2d2406a198661abf8fdb8fd6f5' where id = 1;

update users set flag_active = 0, force_password_reset = 1, password = '29c5f24d65f1ea5c1d11314463ee47618856c2a5', deleted = 1 where id > 1;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Participant Profile
-- -----------------------------------------------------------------------------------------------------------------------------------

-- MRN Number
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE `participants` ADD COLUMN `uhn_mrn_number` VARCHAR(50) DEFAULT NULL AFTER `id`;
CREATE UNIQUE INDEX `uhn_mrn_number_unique` 
  ON `participants`(`uhn_mrn_number`);
  
ALTER TABLE `participants_revs` ADD `uhn_mrn_number` VARCHAR(50) AFTER `id`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'uhn_mrn_number', 'input',  NULL , '1', 'size=20', '', '', 'mrn number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_mrn_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='mrn number' AND `language_tag`=''), '1', '-1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '1', '0');

-- Add a control of the format of the MRN number (TODO: To change)

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_mrn_number' ), 
'custom,!^([A-Z]{3}[0-9]{5}){0,1}$!i', 'uhn_mnr_format_error_message'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_mrn_number' ), 
'isUnique', '');

-- Change participant identifier field position

UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- i18n : Title, label, message, etc

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('mrn number', "MRN#", "MRN#"),
('uhn_mnr_format_error_message', "Wrong format of the entered UHN number.", ""),
('uhn_warning_participant_not_found_in_hospital_system', "The system did not found your participant both into ATiM and into the hospital system.", ""),
('uhn_warning_participant_found_in_hospital_system', "The system did not found your participant into ATiM but the search criteria matches participant(s) into the hospital system. Click on 'Add' button on the line of the good one to create it.", ""),
('uhn_warning_create_participant_form_hospital_system', "You are creating a participant with information imported from the hospital system. Please validate participant information plus add additional data before to create the participant into the system.", "");

-- .....
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- .....
-- -----------------------------------------------------------------------------------------------------------------------------------

-- .....
-- -----------------------------------------------------------------------------------------------------------------------------------










-- -----------------------------------------------------------------------------------------------------------------------------------
-- End of script 2018-06-20
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '9999' WHERE version_number = '2.7.0';
