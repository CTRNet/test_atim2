-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.5', NOW(), '3515');

ALTER TABLE groups
 ADD deleted BOOLEAN NOT NULL DEFAULT 0;

SELECT '****************' as msg
UNION
SELECT IF((SELECT COUNT(*) FROM users WHERE group_id NOT IN(SELECT id FROM groups)) > 0, 'You have users referencing non existing groups. You need to fix them before running the next query.', 'You db is ok. You can run the next query.') AS msg
UNION 
SELECT "ALTER TABLE users 
 ADD FOREIGN KEY (group_id) REFERENCES groups(id);" AS msg
UNION ALL
SELECT '****************' as msg;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'User', 'users', 'flag_active', 'checkbox',  NULL , '0', '', '', '', 'active', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='users'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='flag_active' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='active' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

REPLACE INTO i18n (id, en, fr) VALUES
("you cannot deactivate yourself", "You cannot deactivate yourself.", "Vous ne pouvez pas vous désactiver.");