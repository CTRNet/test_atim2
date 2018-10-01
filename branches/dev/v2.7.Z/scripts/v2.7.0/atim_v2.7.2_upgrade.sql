-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.2
--
-- For more information:
--    ./app/scripts/v2.7.2/ReadMe.txt
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

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.2', NOW(),'XXXX','n/a');


UPDATE versions SET trunk_build_number = 'YYYY' WHERE version_number = '2.7.1';
