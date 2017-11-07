-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.1
--
-- For more information:
--    ./app/scripts£v2.7.0/ReadMe.txt
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
--	Issue #3359: The pwd reset form has fields with different look and feel.
-- -------------------------------------------------------------------------------------
INSERT 
INTO 
	`structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
	(NULL, '898', 'notBlank', '', 'password is required');
	

-- -------------------------------------------------------------------------------------
--	The warning for CSV file
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES 	
	("csv file warning", "Please validate the export has correctly been completed checking no error message exists at the end of the file", "Veuillez valider que l'exportation a été correctement complétée en vérifiant qu'il n'y a pas de message d'erreur à la fin du fichier");

-- -------------------------------------------------------------------------------------
-- Add user_api_keys for saving api_keys
-- -------------------------------------------------------------------------------------
CREATE TABLE `user_api_keys` (
	`id` INT NOT NULL AUTO_INCREMENT , 
    `user_id` INT NOT NULL , 
	`created_by` int(10) unsigned DEFAULT NULL,
	`modified_by` int(10) unsigned DEFAULT NULL,
    `api_key` VARBINARY(64) NOT NULL , 
	`created` datetime DEFAULT NULL,
	`modified` datetime DEFAULT NULL,
	`flag_active` TINYINT(1) NULL DEFAULT '0',
	`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',	
    PRIMARY KEY (`id`),
	KEY `user_id_index` (`user_id`),
	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
	
) ENGINE = InnoDB COMMENT = 'This tables is used for saving the api keys';
-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'xxxx','n/a');
