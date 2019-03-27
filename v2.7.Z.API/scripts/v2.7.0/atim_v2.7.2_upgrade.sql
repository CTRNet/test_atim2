-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.2
--
-- For more information:
--    ./app/scripts/v2.7.0/ReadMe.txt
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
--	The warning for Memory allocation
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	(
'the memory allocated to your query is low or undefined.', 
'The memory allocated to your query is low or undefined from your system data. Please contact your system administrator to optimize your tool.',
'La mémoire allouée à vos requêtes est basse ou non définie à partir de vos données systèmes. Veuillez contacter votre administrateur du système pour optimiser votre outil.'
);


-- -------------------------------------------------------------------------------------
--	Check if the diagnosisMaster is related to the correct participant
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	(
'the diagnosis is not related to the participant', 
'The diagnosis is not related to the participant.',
'Le diagnostic n\'est pas lié au participant.'
);


-- -------------------------------------------------------------------------------------
--	In CCL, check if the annotation can be add
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	(
'the annotation #%s is not for clinical collection link', 
'The annotation #%s is not for Clinical Collection Link.',
'L\'annotation #%s ne concerne pas le lien de collecte clinique.'
);



-- -------------------------------------------------------------------------------------
--	Add link for value domain help message
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('for customising the <b>%s</b> list click <b>%s</b>', 'For customising the "<b>%s</b>" list click <b>%s</b>', 'Pour personnaliser la "<b>%s</b>" liste, cliquez <b>%s</b>'),
    ('here', 'here', 'ici');


-- -------------------------------------------------------------------------------------
--	List validation error message
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('the value is not part of the list [%s]', 'The value is not part of the list [%s].', 'La valeur ne fait pas partie de la liste [%s].');


-- -------------------------------------------------------------------------------------
--	contacts information in order
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('contacts information', 'Contacts information.', 'Informations des contacts.');

-- -------------------------------------------------------------------------------------
--	Race to ethnicity
-- -------------------------------------------------------------------------------------

DELETE FROM i18n
WHERE id in ('race', 'help_race');

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	
    ('help_race', "The participant's self declared ethnic origination.", "L'origine ethnique, telle que déclarée par le participant lui-même."),
    ('race', 'Ethnicity', 'Ethnique');

-- -------------------------------------------------------------------------------------
--	password_format_error_msg_4
-- -------------------------------------------------------------------------------------

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

-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.2', NOW(),'XXXX','n/a');


UPDATE versions SET trunk_build_number = 'YYYY' WHERE version_number = '2.7.2';
