-- ----------------------------------------------------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.2
--
-- For more information:
--    ./app/scripts/v2.7.0/ReadMe.txt
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ----------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------
--	The warning for Memory allocation
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	(
'the memory allocated to your query is low or undefined.', 
'The memory allocated to your query is low or undefined from your system data. Please contact your system administrator to optimize your tool.',
'La mémoire allouée à vos requêtes est basse ou non définie à partir de vos données systèmes. Veuillez contacter votre administrateur du système pour optimiser votre outil.'
);

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Check if the diagnosisMaster is related to the correct participant
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	(
'the diagnosis is not related to the participant', 
'The diagnosis is not related to the participant.',
'Le diagnostic n\'est pas lié au participant.'
);

-- ----------------------------------------------------------------------------------------------------------------------------------
--  In CCL, check if the annotation can be add
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	(
'the annotation #%s is not for clinical collection link', 
'The annotation #%s is not for Clinical Collection Link.',
'L\'annotation #%s ne concerne pas le lien de collecte clinique.'
);

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Add link for value domain help message
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('for customising the <b>%s</b> list click <b>%s</b>', 'For customising the "<b>%s</b>" list click <b>%s</b>', 'Pour personnaliser la "<b>%s</b>" liste, cliquez <b>%s</b>'),
    ('here', 'here', 'ici');

-- ----------------------------------------------------------------------------------------------------------------------------------
--	List validation error message
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('the value is not part of the list [%s]', 'The value is not part of the list [%s].', 'La valeur ne fait pas partie de la liste [%s].');

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Issue #3609 : Change the pop-up layout of Manage contacts
--  Contacts information in order
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('contacts information', 'Contacts information.', 'Informations des contacts.');

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Issue #3676 : Race to ethnicity
-- ----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM i18n
WHERE id in ('race', 'help_race');

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('help_race', "The participant's self declared ethnic origination.", "L'origine ethnique, telle que déclarée par le participant lui-même."),
    ('race', 'Ethnicity', 'Éthnique');

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Issue #3644 : Missing password_format_error_msg_[1234] messages
-- ----------------------------------------------------------------------------------------------------------------------------------

DELETE FROM i18n
WHERE id in ('passwords minimal length', 'password_format_error_msg_1', 'password_format_error_msg_2', 'password_format_error_msg_3');

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('passwords minimal length', 'Passwords must have a minimal length of 8 characters.', 'Les mots de passe doivent avoir une longueur minimale de 8 caractères.'),
    ('password_format_error_msg_1', 'Passwords must have a minimum length of 8 characters and contain lowercase letters.', 'Les mots de passe doivent avoir une longueur minimale de 8 caractères et être composés de lettres minuscules.'),
    ('password_format_error_msg_2', 'Passwords must have a minimum length of 8 characters and contain lowercase letters and numbers.', 'Les mots de passe doivent avoir une longueur minimale de 8 caractères et être composés de lettres majuscules, de lettres minuscules.'),
    ('password_format_error_msg_3', 'Passwords must have a minimum length of 8 characters and contain uppercase letters, lowercase letters and numbers.', 'Les mots de passe doivent avoir une longueur minimale de 8 caractères et être composés de lettres majuscules, de lettres minuscules et de chiffres.'),
    ('password_format_error_msg_4', 'Passwords must have a minimum length of 8 characters and contain uppercase letters, lowercase letters, numbers and special characters.', 'Les mots de passe doivent avoir une longueur minimale de 8 caractères et être composés de lettres majuscules, de lettres minuscules, de chiffres et de caractères spéciaux.');

-- ----------------------------------------------------------------------------------------------------------------------------------
--  Issue#3615 : Delete old records in user_logs table (or other table if exists)
--	Save old recoreds of user_logs into a file
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
("the log directory does not exist: %s", "The log directory does not exist: %s.", "Le répertoire du journal n'existe pas: %s."),
("unable to create the backup file for users log", "Unable to create the backup file for users log.", "Impossible de créer le fichier de sauvegarde pour le journal des utilisateurs.");

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Issue#3585: Change the Active icon according to the status
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
('activate', 'Activate', 'Activer'),
('deactivate', 'Deactivate', 'Désactiver');

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Issue#3689: newVersionSetup(): Configure ATiM when a misc identifier control is defined as 'linkable' to study
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
("structures 'miscidentifiers', 'miscidentifiers_for_participant_search' and 'datamart_browsing_controls' have been updated to let people to create 'Study Participant Identifier' and search on this field.",
"The structures 'miscidentifiers', 'miscidentifiers_for_participant_search' and the data of the table 'datamart_browsing_controls' have been updated to let people to create 'Participant Study Identifier' and search on data.",
"Les structures 'miscidentifiers', 'miscidentifiers_for_participant_search' et les données de la table 'datamart_browsing_controls' ont été mises à jour pour permettre aux utilisateurs de créer un 'Identifiant d'étude du participant' et d'effectuer une recherche sur cette donnée.");

-- ----------------------------------------------------------------------------------------------------------------------------------
--	Study Consent
--     - Add control to the  consent 'Study' field to make it mandatory.
--     - Add consent 'Study' field to consent masters.
--     - Add flag to consent controls to define fields that could be linked to study
-- ----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_consent_study_summary_id'), 'notBlank', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), 
(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 
'1', '2', '', '0', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------
-- Issue#3690: newVersionSetup(): Configure ATiM when a consent control is defined as 'linkable' to study
-- ----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE consent_controls ADD COLUMN flag_link_to_study tinyint(1) DEFAULT '0';

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
("structure 'consent_masters' and 'datamart_browsing_controls' have been updated to let people to create 'Study Consent' and search on this field.",
"The structure 'consent_masters' and data of the table 'datamart_browsing_controls' have been updated to let people to create 'Study Consent' and search on this field.",
"La structure 'consent_masters' et les données de la table 'datamart_browsing_controls' ont été mises à jour pour permettre aux utilisateurs de créer un consentement d'étude et de daire une recherche sur cette donnée.");

-- ----------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------


UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.2', NOW(),'TODEFINE','n/a');
