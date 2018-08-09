REPLACE INTO i18n (id,en, fr) VALUES ('specify percentage', 'Specify percentage', 'Précisez le pourcentage');


-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3277: Impossible to set user password
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='admin_user_password_for_change') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='admin_user_password_for_change' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='admin_user_password_for_change'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='new_password' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='core_newpassword' AND `language_tag`=''), '1', '1', 'user password', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='admin_user_password_for_change'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='confirm_password' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='core_confirmpassword' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structures set alias = 'password_update_by_administartor' WHERE alias = 'admin_user_password_for_change';
INSERT INTO i18n (id,en,fr) VALUES ('user password', 'User Password', 'Mote de passe de l''utilisateur');

UPDATE structures set alias = 'password_update_by_user' WHERE alias = 'password';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='password_update_by_user'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='old_password' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='old password' AND `language_tag`=''), '1', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='old_password_for_change');
DELETE FROM structures WHERE alias='old_password_for_change';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3326: Order Line : Sort on product type generate an error
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE structure_fields ADD COLUMN sortable tinyint(1) DEFAULT '1';
DROP TABLE IF EXISTS `view_structure_formats_simplified`;
DROP VIEW IF EXISTS `view_structure_formats_simplified`;
CREATE VIEW `view_structure_formats_simplified` AS 
select `str`.`alias` AS `structure_alias`,
`sfo`.`id` AS `structure_format_id`,
`sfi`.`id` AS `structure_field_id`,
`sfo`.`structure_id` AS `structure_id`,
`sfi`.`plugin` AS `plugin`,
`sfi`.`model` AS `model`,
`sfi`.`tablename` AS `tablename`,
`sfi`.`field` AS `field`,
`sfi`.`structure_value_domain` AS `structure_value_domain`,
`svd`.`domain_name` AS `structure_value_domain_name`,
`sfi`.`flag_confidential` AS `flag_confidential`,
if((`sfo`.`flag_override_label` = '1'),`sfo`.`language_label`,`sfi`.`language_label`) AS `language_label`,
if((`sfo`.`flag_override_tag` = '1'),`sfo`.`language_tag`,`sfi`.`language_tag`) AS `language_tag`,
if((`sfo`.`flag_override_help` = '1'),`sfo`.`language_help`,`sfi`.`language_help`) AS `language_help`,
if((`sfo`.`flag_override_type` = '1'),`sfo`.`type`,`sfi`.`type`) AS `type`,
if((`sfo`.`flag_override_setting` = '1'),`sfo`.`setting`,`sfi`.`setting`) AS `setting`,
if((`sfo`.`flag_override_default` = '1'),`sfo`.`default`,`sfi`.`default`) AS `default`,
sfi.sortable,
`sfo`.`flag_add` AS `flag_add`,`sfo`.`flag_add_readonly` AS `flag_add_readonly`,
`sfo`.`flag_edit` AS `flag_edit`,`sfo`.`flag_edit_readonly` AS `flag_edit_readonly`,
`sfo`.`flag_search` AS `flag_search`,`sfo`.`flag_search_readonly` AS `flag_search_readonly`,
`sfo`.`flag_addgrid` AS `flag_addgrid`,`sfo`.`flag_addgrid_readonly` AS `flag_addgrid_readonly`,
`sfo`.`flag_editgrid` AS `flag_editgrid`,`sfo`.`flag_editgrid_readonly` AS `flag_editgrid_readonly`,
`sfo`.`flag_batchedit` AS `flag_batchedit`,`sfo`.`flag_batchedit_readonly` AS `flag_batchedit_readonly`,
`sfo`.`flag_index` AS `flag_index`,`sfo`.`flag_detail` AS `flag_detail`,`sfo`.`flag_summary` AS `flag_summary`,
`sfo`.`flag_float` AS `flag_float`,
`sfo`.`display_column` AS `display_column`,
`sfo`.`display_order` AS `display_order`,
`sfo`.`language_heading` AS `language_heading`,
`sfo`.`margin` AS `margin` 
from (((`structure_formats` `sfo` join `structure_fields` `sfi` on((`sfo`.`structure_field_id` = `sfi`.`id`))) join `structures` `str` on((`str`.`id` = `sfo`.`structure_id`))) left join `structure_value_domains` `svd` on((`svd`.`id` = `sfi`.`structure_value_domain`)));
UPDATE structure_fields SET sortable = '0' WHERE model IN ('0', 'FunctionManagement', 'Generated', 'GeneratedParentAliquot', 'GeneratedParentSample');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3341: Password Reset Issue
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE users ADD COLUMN force_password_reset tinyint(1) DEFAULT '1';
ALTER TABLE users_revs ADD COLUMN force_password_reset tinyint(1) DEFAULT '1';
UPDATE users SET force_password_reset = 0 WHERE flag_active = 1;
UPDATE users_revs SET force_password_reset = 0 WHERE flag_active = 1;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'User', 'users', 'force_password_reset', 'checkbox',  NULL , '0', '', '1', 'force_password_reset_help', 'force password reset', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='users'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='force_password_reset' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='1' AND `language_help`='force_password_reset_help' AND `language_label`='force password reset' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('force_password_reset_help', 'Force user to reset his password at next login', 'Forcer l''utilisateur Ã  rÃ©initialiser son mot de passe Ã  la prochaine connexion'),
('force password reset', 'Password Reset Required', 'RÃ©initialisation mot de passe requis');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='password_update_by_administartor'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='force_password_reset' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='1' AND `language_help`='force_password_reset_help' AND `language_label`='force password reset' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE i18n SET id = 'login failed - invalid username or password or disabled user' WHERE id = 'Login failed. Invalid username or password or disabled user.';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('too many failed login attempts - connection to atim disabled temporarily', 'Too many failed login attempts. Your connection to ATiM has been disabled temporarily.', 'Trop de tentatives de connexion. Votre connexion Ã  ATiM a Ã©tÃ© dÃ©sactivÃ©e temporairement.'),
('your username has been disabled - contact your administartor', 'Your username to ATiM has been disabled. Please contact your ATiM administartor to activate it.', 'Votre compte utilisateurM a Ã©tÃ© dÃ©sactivÃ©. Contcatez l''administartor d''ATiM pour le rÃ©activer.');
REPLACE INTO i18n (id,en,fr) VALUES (
'your password has expired. please change your password for security reason.',
'Your password has expired. Please change your password for security reasons.', 
'Votre mot de passe a expirÃ©. Veuillez changer votre mot de passe pour des raisons de sÃ©curitÃ©.');
UPDATE structure_formats SET `display_order`= (`display_order` - 1) WHERE structure_id=(SELECT id FROM structures WHERE alias='users') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('username', 'password'));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Remove fields 'Active' and 'Password Reset Required' in users form when displyed in Customize tool
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('users_form_for_admin');
SET @control_id = (SELECT id FROM structures WHERE alias='users_form_for_admin');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
(SELECT @control_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`
FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='users') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field` IN ('flag_active', 'force_password_reset')));
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='users') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field` IN ('flag_active', 'force_password_reset'));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Reset Password
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE users
   ADD COLUMN forgotten_password_reset_question_1 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_answer_1 VARCHAR(250) DEFAULT NULL,
   ADD COLUMN forgotten_password_reset_question_2 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_answer_2 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_question_3 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_answer_3 VARCHAR(250) DEFAULT NULL; 
ALTER TABLE users_revs
   ADD COLUMN forgotten_password_reset_question_1 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_answer_1 VARCHAR(250) DEFAULT NULL,
   ADD COLUMN forgotten_password_reset_question_2 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_answer_2 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_question_3 VARCHAR(250) DEFAULT NULL, 
   ADD COLUMN forgotten_password_reset_answer_3 VARCHAR(250) DEFAULT NULL; 
INSERT INTO structures(`alias`) VALUES ('forgotten_password_reset_questions');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('forgotten_password_reset_questions', "StructurePermissibleValuesCustom::getCustomDropdown('Password Reset Questions')");
ALTER TABLE structure_permissible_values_custom_controls MODIFY values_max_length INT(4) DEFAULT '5';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Password Reset Questions', 1, 500, 'administration');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Password Reset Questions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("which phone number do you remember most from your childhood?", "Which phone number do you remember most from your childhood?", "Quel numÃ©ro de tÃ©lÃ©phone vous souvenez-vous le plus de votre enfance?", '1', @control_id, NOW(), NOW(), 1, 1), 
("what primary school did you attend?", "What primary school did you attend?", "Ã€ quel Ã©cole primaire Ãªtes-vous allÃ©?", '1', @control_id, NOW(), NOW(), 1, 1), 
("what is your mother's first name and maiden name?", "What is your mother's first name and maiden name?", "Quel est le prÃ©nom et le nom de jeune fille de votre mÃ¨re?", '1', @control_id, NOW(), NOW(), 1, 1), 
("what is your health card number?", "What is your health card number?", "Quel est votre numÃ©ro de carte d'assurance santÃ©?", '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'User', 'users', 'forgotten_password_reset_question_1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='forgotten_password_reset_questions') , '0', '', '', '', 'question 1', ''), 
('Administrate', 'User', 'users', 'forgotten_password_reset_answer_1', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='forgotten_password_reset_questions') , '0', '', '', '', '', ''),
('Administrate', 'User', 'users', 'forgotten_password_reset_question_2', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='forgotten_password_reset_questions') , '0', '', '', '', 'question 2', ''), 
('Administrate', 'User', 'users', 'forgotten_password_reset_answer_2', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='forgotten_password_reset_questions') , '0', '', '', '', '', ''),
('Administrate', 'User', 'users', 'forgotten_password_reset_question_3', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='forgotten_password_reset_questions') , '0', '', '', '', 'question 3', ''), 
('Administrate', 'User', 'users', 'forgotten_password_reset_answer_3', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='forgotten_password_reset_questions') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='forgotten_password_reset_questions'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_question_1'), '2', '100', 'forgotten password reset questions', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset_questions'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_answer_1'), '2', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='forgotten_password_reset_questions'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_question_2'), '2', '105', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset_questions'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_answer_2'), '2', '106', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='forgotten_password_reset_questions'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_question_3'), '2', '110', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset_questions'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_answer_3'), '2', '111', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message)
(SELECT structure_field_id, 'notEmpty', '' FROM structure_formats WHERE `structure_id`=(SELECT id FROM structures WHERE alias='forgotten_password_reset_questions'));
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('reset password', 'Reset Password', 'RÃ©initialiser mot de passe'),
('forgotten password reset questions', 'Password Reset Questions', 'Questions - RÃ©initialisation mot de passe'),
('question 1', 'Question #1', 'Question #1'),
('question 2', 'Question #2', 'Question #2'),
('question 3', 'Question #3', 'Question #3'),
('invalid username or disabled user', "Invalid username or disabled user.","Nom d'utilisateur invalide ou ustilisateur dÃ©sactivÃ©."),
('the question has been modified. please enter a new answer.', 'The question has been modified. Please enter a new answer.', "La question a Ã©tÃ© modifiÃ©e. Veuillez saisir une nouvelle rÃ©ponse."),
('a question can not be used twice.', 'Same question can not be used twice.', "La mÃªme question ne peut Ãªtre ustilisÃ©e deux fois."),
('a same answer can not be written twice.', 'An answer can not be written twice.', "La rÃ©ponse ne peut Ãªtre saisie deux fois."),
('the length of the answer should be bigger than 10.', 'The length of the answer should be bigger than 10.', "La longueur de la rÃ©ponse doit Ãªtre superieure Ã  10."),
('user questions to reset forgotten password are not completed - update your profile with the customize tool', 
"The questions to reset password (in case of forgetfulness) are not completed. Please complete questions in your profile (see 'Customize' icon).", 
"Les questions pour la rÃ©-initialisation du mot de passe (en cas d'oubli) ne sont pas complÃ©tÃ©es. Veuillez remplir les questions dans votre profil (voir icÃ´ne 'Personnaliser').");
UPDATE structure_fields SET `language_label`='forgotten_password_reset answer', language_help = 'forgotten_password_reset_answer_help', setting = 'size=50' WHERE `model`='User' AND `tablename`='users' AND `field` LIKE 'forgotten_password_reset_answer_%';

INSERT INTO structures(`alias`) VALUES ('forgotten_password_reset');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='username'), '2', '50', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_question_1'), '2', '100', 'forgotten password reset questions', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_answer_1'), '2', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_question_2'), '2', '105', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_answer_2'), '2', '106', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_question_3'), '2', '110', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='forgotten_password_reset_answer_3'), '2', '111', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUE
('forgotten_password_reset_answer_help', 'Answers will be encrypted in database.', 'Les rÃ©ponses seront encryptÃ©es en base de donnÃ©es.'),
('forgotten_password_reset answer', 'Answer', 'RÃ©ponse'),
('click here to see them', 'Click here to see them', 'Cliquez ici pour les afficher'),
('at least one error exists in the questions you answered - password can not be reset', 
'At least one error exists in the questions you answered. Password can not be reset.', 
"Il y a au moins une erreur dans les questions auxquelles vous avez rÃ©pondu. Le mot de passe ne peut pas Ãªtre rÃ©initialisÃ©."),
('click here to update','Click here to update','Cliquez ici pour mettre les donnÃ©es Ã  jour');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='new_password' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='core_newpassword' AND `language_tag`=''), '2', '150', 'reset password', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='confirm_password' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='core_confirmpassword' AND `language_tag`=''), '2', '150', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('other_user_login_to_forgotten_password_reset');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', '0', '', 'other_user_check_username', 'input',  NULL , '0', 'size=20', '', '', 'username', ''), 
('Administrate', '0', '', 'other_user_check_password', 'password',  NULL , '0', 'size=20', '', '', 'password', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='other_user_login_to_forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='other_user_check_username' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='username' AND `language_tag`=''), '2', '125', 'other user control', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='other_user_login_to_forgotten_password_reset'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='other_user_check_password' AND `type`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='password' AND `language_tag`=''), '2', '126', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message)
(SELECT structure_field_id, 'notEmpty', '' FROM structure_formats WHERE `structure_id`=(SELECT id FROM structures WHERE alias='other_user_login_to_forgotten_password_reset'));

INSERT IGNORE INTO i18n (id,en,fr)
VALUE
('step %s', 'Step %s', 'Ã‰tape %s'),
('password should be different than the %s previous one', 'Password should be different than the %s previous one', 'Le mot de passe doit Ãªtre diffÃ©rent des %s prÃ©cÃ©dents mots de passe'),
('please enter you username', 'Please enter you username', 'Veuillez saisir votre nom d''utilisateur'),
('please conplete the security questions', 'Please conplete the security questions', 'Veuillez complÃ©ter les questions de sÃ©curitÃ©s'),
('other user control', 'Other User Control', 'ContrÃ´le autre utilisateur');

INSERT INTO structures(`alias`) VALUES ('username');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='username'), (SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='username' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='login_help' AND `language_label`='username' AND `language_tag`=''), '1', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3360: User 'Account Status' field value does not match list value in edit mode
-- -----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='preferences_lock');
DELETE FROM structures WHERE alias='preferences_lock';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3365 : Annoucements : Unable to create annoucements for a bank or a user
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET use_link = '/Administrate/Announcements/index/user/%%Group.id%%/%%User.id%%/' WHERE use_link = '/Administrate/Announcements/index/%%Group.id%%/%%User.id%%/';
UPDATE menus SET use_link = '/Administrate/Announcements/index/bank/%%Bank.id%%/' WHERE use_link = '/Administrate/Announcements/index/%%Bank.id%%/';
UPDATE menus SET use_summary = 'Administrate.User::summary' WHERE use_link = '/Administrate/Announcements/index/user/%%Group.id%%/%%User.id%%/';
UPDATE menus SET use_summary = 'Administrate.Bank::summary' WHERE use_link = '/Administrate/Announcements/index/bank/%%Bank.id%%/';
ALTER TABLE `announcements` 
  MODIFY `date` date DEFAULT NULL,
  MODIFY `date_start` date DEFAULT NULL,
  MODIFY `date_end` date DEFAULT NULL;
DROP TABLE IF EXISTS `announcements_revs`;
CREATE TABLE `announcements_revs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `bank_id` int(11) DEFAULT '0',
  `date` date DEFAULT NULL,
  `date_accuracy` char(1) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_start_accuracy` char(1) NOT NULL DEFAULT '',
  `date_end` date DEFAULT NULL,
  `date_end_accuracy` char(1) NOT NULL DEFAULT '',
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
UPDATE structure_fields SET tablename = 'announcements' WHERE tablename = 'annoucements';
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='body' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='date_start' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='date_end' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='body' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='date_start' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='announcements') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Announcement' AND `tablename`='announcements' AND `field`='date_end' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE menus SET flag_active = '1' WHERE use_link = '/Administrate/Announcements/index/user/%%Group.id%%/%%User.id%%/';
INSERT INTO i18n (id,en,fr) VALUES ('you have %s due annoucements', 'You have %s annoucements.', 'Vous avez %s annonces');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Changed the labels of the list of the 'Check Conflict' field used when setting the data of a new storage type 
-- (Tool : Manage storage types)
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("0", "storage_check_conflicts_none"),("1", "storage_check_conflicts_warning"),("2", "storage_check_conflicts_error");
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="storage_check_conflicts");
INSERT IGNORE INTO structure_value_domains_permissible_values 
(structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="storage_check_conflicts"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="storage_check_conflicts_none"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="storage_check_conflicts"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="storage_check_conflicts_warning"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="storage_check_conflicts"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="storage_check_conflicts_error"), "3", "1");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('storage_check_conflicts_none', 'No control for items stored in the same position', 'Aucun contrÃ´le sur les items entreposÃ©s Ã  la mÃªme position'),
('storage_check_conflicts_warning', 'Items stored in the same position generate warning', 'Items entreposÃ©s Ã  la mÃªme position gÃ©nÃ¨rent un avertissement'),
('storage_check_conflicts_error', 'Items stored in the same position generate error', 'Items entreposÃ©s Ã  la mÃªme position gÃ©nÃ¨rent une erreur');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Added mail code to study investigator address
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE study_investigators
  ADD COLUMN mail_code VARCHAR(10) DEFAULT NULL;
ALTER TABLE study_investigators_revs
  ADD COLUMN mail_code VARCHAR(10) DEFAULT NULL; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudyInvestigator', 'study_investigators', 'mail_code', 'input',  NULL , '0', 'size=7', '', '', 'mail_code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studyinvestigators'), (SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='mail_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=7' AND `default`='' AND `language_help`='' AND `language_label`='mail_code' AND `language_tag`=''), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#3367: The Order line type 'TMA Slide' is missing in the order items list
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_and_lines'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='product_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_line_product_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='product type' AND `language_tag`=''), '0', '36', 'line', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_and_lines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_and_lines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='aliquot_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add missing category to custom drop down list
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("administration", "administration");
INSERT IGNORE INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="permissible_values_custom_categories"), (SELECT id FROM structure_permissible_values WHERE value="administration" AND language_alias="administration"), "", "1");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 'Missing translations
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('news', 'News', 'ActualitÃ©s'),
('minute', 'Minute', 'Minute');
