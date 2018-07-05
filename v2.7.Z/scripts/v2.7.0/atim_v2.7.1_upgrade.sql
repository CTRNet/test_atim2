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
	(NULL, 
	(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='confirm_password' AND `type`='password' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='core_confirmpassword' AND `language_tag`='')
	, 'notBlank', '', 'password is required'),
	(NULL, 
	(SELECT id FROM structure_fields WHERE `model`='Generated' AND `field`='field1' AND `type`='input' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='')
	, 'notBlank', '', 'password is required');
	
-- -------------------------------------------------------------------------------------
--	The warning for CSV file
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES 	
	("csv file warning", "Please validate the export has correctly been completed checking no error message exists at the end of the file", "Veuillez valider que l'exportation a été correctement complétée en vérifiant qu'il n'y a pas de message d'erreur à la fin du fichier");

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES 	
	("csv file warning", "Please validate the export has correctly been completed checking no error message exists at the end of the file", "Veuillez valider que l'exportation a été correctement complétée en vérifiant qu'il n'y a pas de message d'erreur à la fin du fichier"),
	("download %s", "Download %s", "Télécharger %s"),
	("default_values", "Default values", "Des valeurs par defaux"),
	("file does not exist", "The file does not exist.", "Le fichier n'existe pas.");
	
-- -------------------------------------------------------------------------------------
--	The warning about max_input_vars
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES 	
	('PHP "max_input_vars" is <= than atim databrowser_and_report_results_display_limit', 
	'The PHP "max_input_vars" defined into the "php.ini" file is less than the "databrowser_and_report_results_display_limit" defined into the ATiM "core.php" file. Configuration will generate problems whenever you display more options than "max_input_vars". Please update either the "php.ini" file or the "core.php" file.',
	'La variable PHP "max_input_vars" définie dans le fichier "php.ini" est inférieure au "databrowser_and_report_results_display_limit" défini dans le fichier ATiM "core.php". La configuration génèrera des problèmes lorsque vous afficherez plus de valeurs que "max_input_vars". Veuillez mettre à jour le fichier "php.ini" ou le fichier "core.php".'),
    ('warning_PHP upload_max_filesize is <= than atim maxUploadFileSize, problem in uploading',
    'The PHP "upload_max_filesize" defined into the "php.ini" file is less than the "maxUploadFileSize" defined into the ATiM "core.php" file. Configuration will generate problems when user will download big files. Please update either the "php.ini" file or the "core.php" file.',
	'La variable PHP "upload_max_filesize" définie dans le fichier "php.ini" est inférieure au "maxUploadFileSize" défini dans le fichier ATiM "core.php". La configuration génèrera des problèmes lorsque l''utilisateur téléchargera de gros fichiers. Veuillez mettre à jour le fichier "php.ini" ou le fichier "core.php".'),
    ('warning_PHP post_max_size is <= than upload_max_filesize, problem in uploading',
    'The PHP "post_max_size" defined into the "php.ini" file is less than the "upload_max_filesize" defined into the "php.ini" file. Configuration will generate problems when user will download big files. Please update either the "php.ini" file or the "core.php" file.',
	'La variable PHP "post_max_size" définie dans le fichier "php.ini" est inférieure au "upload_max_filesize" défini dans le fichier "php.ini". La configuration génèrera des problèmes lorsque l''utilisateur téléchargera de gros fichiers. Veuillez mettre à jour le fichier "php.ini" ou le fichier "core.php".');

-- -------------------------------------------------------------------------------------
--	File size error message
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES(
	"the file size should be less than %d bytes", 
	"The file size should be less than %d bytes", 
	"La taille de fichier dois être moins que %d octets");

-- -------------------------------------------------------------------------------------
--	upload directory permission incorrect
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES(
	'the permission of "upload" directory is not correct.', 
	'The permission of "upload" directory is not correct.', 
	'L\'autorisation du répertoire "upload" n\'est pas correcte.');

-- -------------------------------------------------------------------------------------
--	Storage layout
-- -------------------------------------------------------------------------------------
INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES
	('aliquot does not exist', 'Aliquot does not exist', 'Aliquote n\'existe pas'),
	('aliquot is not in stock', 'Aliquot is not in stock', 'Aliquote n\'est pas en stock'),
	('this aliquot is registered in another place. label: %s, x: %s, y: %s', 'This aliquot is registered in another place. label: %s, x: %s, y: %s', 'Cette aliquote est enregistrée dans un autre endroit. étiquette: %s, x: %s, y: %s'),
	('more than one aliquot have the same barcode', 'More than one aliquot have the same barcode', 'Plus d\'une aliquote a le même code à barres'),
	('the aliquots list', 'The list of aliquots', 'La liste des aliquotes'),
	('line %s', 'Line %s', 'Ligne %s'),
	('load csv', 'Load CSV', 'Charger CSV'),
	('clear the loaded and scanned barcode', 'Clear the loaded and scanned barcode', 'Effacez le code à barres chargé et numérisé'),
	('this aliquot is registered in another place', 'This aliquot is registered in another place', 'Cette aliquote est enregistrée dans un autre endroit'),
	('the y dimension out of range <= %s', 'The Y dimension out of range <= %s', 'La dimension Y hors de portée <=%s'),
	('the x dimension out of range <= %s', 'The X dimension out of range <= %s', 'La dimension X hors de portée <=%s'),
	('duplicate barcode in csv file', 'Duplicated barcode in CSV file', 'Dupliquer le code à barres dans le fichier CSV'),
	('should have Y column', 'Should have Y column', 'Devrait avoir une colonne Y'),
	('should have barcode column', 'Should have barcode column', 'Devrait avoir une colonne de code à barres'),
	('should have X column', 'Should have X column', 'Devrait avoir une colonne X'),
	('error in csv header file', 'Error in CSV header file', 'Erreur dans le fichier d\'en-tête CSV'),
	('error in opening %s', 'Error in opening %s', 'Erreur d\'ouverture %s'),
	('error in x dimension: %s', 'Error in X dimension: %s', 'Erreur en dimension X: %s'),
	('error in y dimension: %s', 'Error in Y dimension: %s', 'Erreur en dimension Y: %s'),
	('the x dimension should be a-z or 1-26', 'The X dimension should be A-Z or 1-26', 'La dimension X doit être A-Z ou 1-26'),
	('the y dimension should be a-z or 1-26', 'The Y dimension should be A-Z or 1-26', 'La dimension Y doit être A-Z ou 1-26'),
	('error in opening csv file', 'Error in opening CSV file', 'Erreur lors de l\'ouverture du fichier CSV');
-- -------------------------------------------------------------------------------------
--	Created sample type TIL (tumor infiltrating lymphocyte)
-- -------------------------------------------------------------------------------------

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'tumor infiltrating lymphocyte', 'derivative', 'sd_der_tils,sd_undetailed_derivatives,derivatives', 'sd_der_tils', 0, 'tumor infiltrating lymphocyte');
CREATE TABLE IF NOT EXISTS `sd_der_tils` (
  `sample_master_id` int(11) NOT NULL,
  `generation_method` varchar(250) NULL,
  `additive` varchar(250) NULL,
  KEY `FK_sd_der_tils_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `sd_der_tils_revs` (
  `sample_master_id` int(11) NOT NULL,
  `generation_method` varchar(250) NULL,
  `additive` varchar(250) NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `sd_der_tils`
  ADD CONSTRAINT `FK_sd_der_tils_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('til_generation_methods', "StructurePermissibleValuesCustom::getCustomDropdown('TIL Generation Methods')"),
('til_generation_additives', "StructurePermissibleValuesCustom::getCustomDropdown('TIL Generation Additives')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('TIL Generation Methods', 0, 250, 'inventory'),
('TIL Generation Additives', 0, 250, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TIL Generation Methods');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("cell culture", "Cell Culture", "Culture cellulaire", '1', @control_id, NOW(), NOW(), 1, 1), 
("digestion", "Digestion", "Digestion", '1', @control_id, NOW(), NOW(), 1, 1), 
("digestion & cell culture", "Digestion & Cell Culture", "Digestion & Culture cellulaire", '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TIL Generation Additives');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("IL-2", "IL-2", "IL-2", '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structures(`alias`) VALUES ('sd_der_tils');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_tils', 'generation_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='til_generation_methods') , '0', '', '', '', 'generation method', ''), 
('InventoryManagement', 'SampleDetail', 'sd_der_tils', 'additive', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='til_generation_additives') , '0', '', '', '', 'additive', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_tils'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_tils' AND `field`='generation_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='til_generation_methods')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='generation method' AND `language_tag`=''), '1', '445', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_tils'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_tils' AND `field`='additive' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='til_generation_additives')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additive' AND `language_tag`=''), '1', '446', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('tumor infiltrating lymphocyte', 'TIL', 'TIL'),
('generation method', 'Generation Method', 'Méthode de génération'),
('additive', 'Additive', 'Additif');
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), 0, NULL);
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'cell culture'), 0, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate'), 0, NULL);
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tumor infiltrating lymphocyte'), 'tube', '', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml specific for cells', 0, 'tumor infiltrating lymphocyte|tube');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(null, (SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'tumor infiltrating lymphocyte'), 
(SELECT aliquot_controls.id FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = sample_control_id AND sample_type = 'tumor infiltrating lymphocyte'), 0, NULL);

-- -------------------------------------------------------------------------------------
--	Load search data & clear form
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES
	('previous search', 'Previous', 'Précédente'),
	('reset search', 'Reset', 'Réinitialiser');

-- -------------------------------------------------------------------------------------
--	Issue #3424: Replace '<br>' characters in message.
-- -------------------------------------------------------------------------------------
UPDATE i18n
SET 
	en = REPLACE (en, '<br><br>', '<br>'),
	fr = REPLACE (fr, '<br><br>', '<br>')
WHERE 
	en LIKE '%<br><br>%' OR
	fr LIKE '%<br><br>%';

-- -------------------------------------------------------------------------------------
--	issue #3473: There is a type 'adtetime' in structure_fields table
-- -------------------------------------------------------------------------------------

UPDATE structure_fields
SET `type`='datetime'
where `type`='adtetime';

-- -------------------------------------------------------------------------------------
--	Issue #3484: Define the default number of created tubes when user 
--  is realiquoting aliquot(s) or creating aliquot(s) from sample
-- -------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('aliquot_nb_definition');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'aliquots_nbr_per_parent', 'integer',  NULL , '0', 'size=2', '', '', 'number of created aliquots per parent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_nb_definition'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='aliquots_nbr_per_parent' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=2' AND `default`='' AND `language_help`='' AND `language_label`='number of created aliquots per parent' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('number of created aliquots per parent', 'Children Aliquots Number per Parent', 'Nombre aliquots enfants par parent'),
('nbr of children by default can not be bigger than 20', 'The number of children aliquots by default can not be bigger than 20!', "Le nombre d'aliquots enfants par défaut ne peut pas être supérieur à 20!");

-- -------------------------------------------------------------------------------------
--	Collection Template & protocol
--     - Add option to set default values for a collection template node
-- -------------------------------------------------------------------------------------

-- Template default values + last activation date

ALTER TABLE template_nodes
   ADD COLUMN default_values TEXT DEFAULT null;

ALTER TABLE templates ADD COLUMN `last_activation_date` date DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tool', 'Template', 'templates', 'last_activation_date', 'date',  NULL , '0', '', '', '', 'last activation', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='last_activation_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last activation' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='last_activation_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("default_values", "Default Values", "Valeurs par defaut");
	
-- Add collection protocols

UPDATE menus 
SET use_link = '/Tools/Template/listProtocolsAndTemplates',
language_title = 'collection protocols and templates',
language_description = 'collection_protocol_template_description'
WHERE id = 'collection_template';

DROP TABLE IF EXISTS `collection_protocols`;
CREATE TABLE `collection_protocols` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `flag_system` tinyint(1) DEFAULT '0' COMMENT 'if true, cannot be edited in ATiM',
  `name` varchar(50) NOT NULL DEFAULT '',
  `owner` varchar(10) NOT NULL DEFAULT 'user',
  `visibility` varchar(10) NOT NULL DEFAULT 'user',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `owning_entity_id` int(11) NOT NULL,
  `visible_entity_id` int(11) NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `last_activation_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  
INSERT INTO structures(`alias`) VALUES ('collection_protocol');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tool', 'CollectionProtocol', 'collection_protocols', 'name', 'input',  NULL , '0', '', '', '', 'name', ''), 
('Tool', 'CollectionProtocol', 'collection_protocols', 'owner', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sharing') , '0', '', 'user', '', 'owner', ''), 
('Tool', 'CollectionProtocol', 'collection_protocols', 'visibility', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sharing') , '0', '', 'user', '', 'visibility', ''), 
('Tool', 'CollectionProtocol', 'collection_protocols', 'flag_active', 'checkbox',  NULL , '0', '', '1', '', 'active', ''), 
('Tool', 'CollectionProtocol', 'collection_protocols', 'last_activation_date', 'date',  NULL , '0', '', '', '', 'last activation', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collection_protocol'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='owner' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sharing')  AND `flag_confidential`='0' AND `setting`='' AND `default`='user' AND `language_help`='' AND `language_label`='owner' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='visibility' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sharing')  AND `flag_confidential`='0' AND `setting`='' AND `default`='user' AND `language_help`='' AND `language_label`='visibility' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='flag_active' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='1' AND `language_help`='' AND `language_label`='active' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='last_activation_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last activation' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collection_protocol');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='name' AND `type`='input'), 'isUnique', '', ''),
(NULL, (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='name' AND `type`='input'), 'notBlank', '', ''),
(NULL, (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='owner' AND `type`='select'), 'notBlank', '', ''),
(NULL, (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='visibility' AND `type`='select'), 'notBlank', '', '');

DROP TABLE IF EXISTS `collection_protocol_visits`;
CREATE TABLE `collection_protocol_visits` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `collection_protocol_id` int(11) unsigned DEFAULT null,
  `template_id` int(10) unsigned DEFAULT null,
  `name` varchar(50) NOT NULL DEFAULT '',
  `default_values` TEXT DEFAULT null,
  `time_from_first_visit` int(10) DEFAULT NULL,
  `time_from_first_visit_unit` varchar(10) DEFAULT NULL,
  `first_visit` tinyint(1) DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `collection_protocol_visits`
  ADD CONSTRAINT `FK_protocol_visits_collection_protocols` FOREIGN KEY (`collection_protocol_id`) REFERENCES `collection_protocols` (`id`);
ALTER TABLE `collection_protocol_visits`
  ADD CONSTRAINT `FK_collection_protocol_visits_templates` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`);
  
INSERT INTO structures(`alias`) VALUES ('collection_protocol_visit');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('collection_protocol_template_all', "Tools.Template::getTemplatesList('template all')"),
('collection_protocol_template', "Tools.Template::getTemplatesList"),
("time_from_first_visit_unit", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("day", "day"),('week','week');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="time_from_first_visit_unit"), 
(SELECT id FROM structure_permissible_values WHERE value="day" AND language_alias="day"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="time_from_first_visit_unit"), 
(SELECT id FROM structure_permissible_values WHERE value="week" AND language_alias="week"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="time_from_first_visit_unit"), 
(SELECT id FROM structure_permissible_values WHERE value="month" AND language_alias="month"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="time_from_first_visit_unit"), 
(SELECT id FROM structure_permissible_values WHERE value="year" AND language_alias="year"), "4", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'name', 'input',  NULL , '0', 'size=20', '', '', 'title', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'template_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='collection_protocol_template') , '0', '', '', '', 'template', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'template_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='collection_protocol_template_all') , '0', '', '', '', 'template', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'time_from_first_visit', 'integer_positive',  NULL , '0', '', '', '', 'time', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'time_from_first_visit_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='time_from_first_visit_unit') , '0', '', '', '', '', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'default_values', 'input',  NULL , '0', '', '', '', 'default values', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'id', 'hidden',  NULL , '0', 'size=5', '', '', 'collection_protocol_visit_id', ''),
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'first_visit', 'checkbox',  NULL , '0', '', '', '', 'first visit', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='title' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='template_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocol_template')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='template' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='template_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocol_template_all')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='template' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='time_from_first_visit' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='time' AND `language_tag`=''), '0', '3', 'time from first visit', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='time_from_first_visit_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='time_from_first_visit_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='default_values' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='default values' AND `language_tag`=''), '0', '5', 'collection default values', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '2', '5000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collection_protocol_visit_id' AND `language_tag`=''), '0', '6000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='first_visit' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first visit' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='name'), 'notBlank', '', '');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('unusable_collection_protocol_template', "At least one template is unusable (inactivated template or you don't have permission to use it)", "Au moins un modèle est inutilisable (modèle inactivé ou vous n'êtes pas autorisé à l'utiliser)"),
('unusable template', 'Unusable Template', 'Modèle inutilisable'),
('week', 'Week', 'Semaine'),
('collection protocol is linked to a collection - data can not be deleted', 'The collection protocol is linked to a collection. The protocol can not be deleted.', "Le protocole de collection est lié à une collection. Le protocole ne peut pas être supprimé."),
('template is already linked to a collection - data can not be deleted', 'The template is linked to a collection. The propriétaire can not be deleted.', "Le modèle est lié à une collection. Le modèle ne peut pas être supprimé."),
('template is part of a collection protocol visit - data can not be deleted', 'The template is part of a collections protocol visit. The propriétaire can not be deleted.', "Le modèle fait partie d'une visite de protocole de collections. Le modèle ne peut pas être supprimé."),
('you do not own that protocol', 'You do not own that protocol', "Vous n'êtes pas propriétaire de ce protocole"),
('collection default values', 'Collection Default Values', 'Valeurs par défaut de collection'),
('set default values', 'Set Default Values', 'Saisir valeurs par défaut'),
('one visit and only one should be flagged as first one', 'One and only one visit should be flagged as first one!', "Une et seulement une visite doite être définie commme le première visite!"),
('first visit', '1st Visit', '1ère visite'),
('a time unit should be defined', 'A time unit should be defined', 'Une unté de temps doit être définie'),
('time from first visit', 'Time from 1st Visit', 'Temps depuis la 1ère visite'),
('visits', 'Visits', 'Visites'),
('last activation', 'Last Activation', 'Dernière activation'),
('collection protocols and templates', 'Collection Protocols & Templates', 'Protocoles & modèles de collection'),
('collection_protocol_template_description', 
"Creation of collections protocols and templates allowing users to quickly create collection content without the need to browse the menus after the creation of each element of a new collection (specimen, derivative, aliquot) plus design a set of 'collection events' (visits) a participant has to participate.", 
"Création de protocoles et modèles de collections permettant aux utilisateurs de créer rapidement le contenu d'une collection sans devoir naviguer au travers des menus après la création de chaque élément d'une nouvelle collection (spécimen, dérivé, aliquot) et de définir un ensemble d'évenements de collection ou de visites auquels le participant doit participer."),
('collections protocols', 'Collections Protocols', 'Protocoles de collections'),
('collection templates', 'Collection Templates', 'Modèles de collection'),
('templates', 'Templates', 'Modèles'),
('template', 'Template', 'Modèle');

-- Add collection protocols at collection and view collection level

ALTER TABLE collections
  ADD COLUMN collection_protocol_id int(11) unsigned DEFAULT null;
ALTER TABLE collections_revs
  ADD COLUMN collection_protocol_id int(11) unsigned DEFAULT null;
ALTER TABLE `collections`
  ADD CONSTRAINT `FK_collection_protocols_collections` FOREIGN KEY (`collection_protocol_id`) REFERENCES `collection_protocols` (`id`);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("collection visit '%s' has not been created (from protocol)", "The collection '%s' has not been created (from protocol)", "La collection '% s' n'a pas été créée (à partir du protocole)"),
('new collection protocol', "New Collection Protocol", 'Nouveau protocole de collection');

ALTER TABLE collections
  ADD COLUMN template_id int(10) unsigned DEFAULT null;
ALTER TABLE collections_revs
  ADD COLUMN template_id int(10) unsigned DEFAULT null;
ALTER TABLE `collections`
  ADD CONSTRAINT `FK_collection_templates` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('collection_protocols', "Tools.CollectionProtocol::getProtocolsList('protocol all')");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'collection_protocol_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') , '0', '', '', '', 'protocol', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '0', '-5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'collection_protocol_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') , '0', '', '', '', 'protocol', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id'), '1', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('col_copy_protocol_opt');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("col_copy_protocol_opt", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("protocol only", "protocol only"),("protocol and template", "protocol and template");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_protocol_opt"), (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_protocol_opt"), (SELECT id FROM structure_permissible_values WHERE value="protocol only" AND language_alias="protocol only"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_protocol_opt"), (SELECT id FROM structure_permissible_values WHERE value="protocol and template" AND language_alias="protocol and template"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', 'FunctionManagement', '', 'col_copy_protocol_opt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='col_copy_protocol_opt') , '0', '', 'protocol and template', '', 'protocol copy option', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='col_copy_protocol_opt'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_protocol_opt'), '0', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_protocol_opt'), 'notBlank', '', '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("you don't have permissions to use the template defined by the protocol", "You don't have permissions to use the template defined by the protocol", "Vous n'avez pas la permission d'utiliser le modèle défini par le protocole"),
('participant collection link', 'Participant Collection (Link)', 'Collection du participant (lien)'),
("you don't have permission to use the protocol but this one will be linked to the collections", "You do not have permission to use the protocol but however it will be linked to the collection(s)", "Vous n'avez pas la permission d'utiliser le protocole mais il sera cependant lié aux collection(s)"),
("you don't have permission to use the protocol", "you don't have permission to use the protocol", "Vous n'avez pas la permission d'utiliser le protocol"),
('protocol copy option', 'Protocol Copy Option', 'Option de copie du protocole'),
("protocol only", "Protocol Only", "Protocole seulement"),
("protocol and template", "Protocole & Template", "Protocole & Modèle");

-- Activate protocol feature

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------
-- Issue #3511: class AnnouncementsController conflict
-- -------------------------------------------------------------------------------------

UPDATE menus SET use_link = REPLACE(use_link, '/Customize/Announcements/', '/Customize/UserAnnouncements/');

-- -------------------------------------------------------------------------------------
-- Issue #3592: Upgrade the Manage storage types tool
-- -------------------------------------------------------------------------------------

ALTER TABLE storage_controls 
  MODIFY `display_x_size` tinyint(3) unsigned DEFAULT null AFTER coord_x_size,
  MODIFY `reverse_x_numbering` char(1) DEFAULT null AFTER display_x_size,
  MODIFY `horizontal_increment` char(1) DEFAULT null AFTER storage_type,
  MODIFY `display_y_size` tinyint(3) unsigned DEFAULT null AFTER coord_y_size,
  MODIFY `reverse_y_numbering` char(1) DEFAULT null AFTER display_y_size,
  ADD COLUMN number_of_positions int(6) DEFAULT NULL AFTER storage_type,
  MODIFY check_conflicts tinyint(3) unsigned DEFAULT null;
  
ALTER TABLE storage_controls 
  MODIFY `display_x_size` tinyint(3) unsigned DEFAULT null AFTER coord_x_size,
  MODIFY `reverse_x_numbering` char(1) DEFAULT null AFTER display_x_size,
  MODIFY `horizontal_increment` char(1) DEFAULT null AFTER storage_type,
  MODIFY `display_y_size` tinyint(3) unsigned DEFAULT null AFTER coord_y_size,
  MODIFY `reverse_y_numbering` char(1) DEFAULT null AFTER display_y_size,
  MODIFY check_conflicts tinyint(3) unsigned DEFAULT null;
 
-- Update storage_controls values
-- -------------------------------------------------------------------------------------

-- no dimention
UPDATE storage_controls 
SET horizontal_increment = null,
coord_x_title = null, 
coord_x_type = null, 
coord_x_size = null, 
display_x_size = null,
reverse_x_numbering = null, 
coord_y_title = null, 
coord_y_type = null, 
coord_y_size = null,  
display_y_size = null,  
reverse_y_numbering = null,
is_tma_block = 0,
check_conflicts = null
WHERE coord_x_title IS NULL;

-- 1 dimension - list
UPDATE storage_controls 
SET coord_x_size = null, 
display_x_size = null,
reverse_x_numbering = null, 
horizontal_increment = null,
coord_y_title = null, 
coord_y_type = null, 
coord_y_size = null,  
display_y_size = null,  
reverse_y_numbering = null,
is_tma_block = 0
WHERE coord_x_type = 'list';

-- 1 dimension - not a list
UPDATE storage_controls 
SET coord_x_size = display_x_size*display_y_size, 
number_of_positions = display_x_size*display_y_size,
coord_y_title = null, 
coord_y_type = null, 
coord_y_size = null,
is_tma_block = 0
WHERE coord_x_title IS NOT NULL AND coord_y_title IS NULL AND coord_x_type != 'list';

-- 2 dimensions or tma
UPDATE storage_controls 
SET display_x_size = coord_x_size,  
display_y_size = coord_y_size, 
number_of_positions = coord_x_size * coord_y_size,
horizontal_increment = null
WHERE is_tma_block = 1 
OR coord_y_title IS NOT NULL;

-- Fields Management
-- -------------------------------------------------------------------------------------

-- delete coord_x_size & coord_y_size
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'storage_control%') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `language_label`='coord_x_size' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'storage_control%') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size' AND `language_label`='coord_y_size' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `language_label`='coord_x_size' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size' AND `language_label`='coord_x_size' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_size' AND `language_label`='coord_x_size' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1';
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_y_size' AND `language_label`='coord_x_size' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1';
  
-- Add number of positions
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageCtrl', 'storage_controls', 'number_of_positions', 'integer',  NULL , '0', 'size=3', '', '', 'number_of_positions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_controls'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='number_of_positions' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='number_of_positions' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
 
-- Change reverse numbering from check box to directions options 
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES ("reverse_x_numbering", "", "", NULL), ("reverse_y_numbering", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0", "left to right"),
("1", "right to left"),
("0", "top to bottom"),
("1", "bottom to top");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="reverse_x_numbering"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="left to right"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="reverse_x_numbering"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="right to left"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="reverse_y_numbering"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="top to bottom"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="reverse_y_numbering"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="bottom to top"), "2", "1");
UPDATE structure_fields SET type = 'select', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='reverse_x_numbering') WHERE field = 'reverse_x_numbering' AND model = 'StorageCtrl';
UPDATE structure_fields SET type = 'select', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='reverse_y_numbering') WHERE field = 'reverse_y_numbering' AND model = 'StorageCtrl';

-- 1d structure - Change header and more
UPDATE structure_formats SET `language_heading`='storage_coord_y' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_1d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_y_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='coordinate' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_1d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='coord_x_title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_coordinate_title') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage_coord_x' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_1d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_x_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- 2d structure and tma - Add ddisplay_%_size
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_x_size'), '0', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_tma'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_y_size'), '0', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_x_size'), '0', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_2d'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='display_y_size'), '0', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- Field display_%_size
UPDATE structure_fields SET `type`='integer_positive' WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field` LIKE 'display_%_size';
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) 
(SELECT id,'custom,/^[^0]/', '', 'value can not be equal to zero' FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field` LIKE 'display_%_size');

-- Field horizontal_increment
UPDATE structure_formats SET `display_order`='12' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='horizontal_increment');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='horizontal_increment');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_controls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='horizontal_increment');
UPDATE structure_formats SET `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_control_1d') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='horizontal_increment');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES ("horizontal_increment", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0", "vertically"),
("1", "horizontally");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="horizontal_increment"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="vertically"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="horizontal_increment"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="horizontally"), "2", "1");
UPDATE structure_fields SET type = 'select', language_label = 'incrementation (general)', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='horizontal_increment') WHERE field = 'horizontal_increment' AND model = 'StorageCtrl';

-- i18n
-- -------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES
('a value has to be set for the display size', "Values have to be set for the 'Number of columns and/or lines'", "Des valeurs doivent être saisies pour 'Nombre de colonnes et/ou lignes'"),
('a value has to be set for the reverse numbering', "Values have to be set for the 'Incrementation' fields", "Des valeurs doivent être saisies pour les champs 'Incrémentation'"),
('no abscissa and ordinate data has to be set for a list', 'No abscissa and ordinate data has to be set for a list managed by user', "Aucune donnée d'abscisse et d'ordonnée ne doit être définie pour une liste gérée par les utilisateurs"),
('value can not be equal to zero', 'The value can not be equal to zero', "La valeur ne peut pas être égale à zéro"),
('storage_coord_x', "Abscissa/Column (X-axis)", "Abscisse/Colonne (axe des X)"),
('storage_coord_y', "Ordinate/Line (Y-axis)", "Ordonnée/Ligne (axe des Y)"),
('display_x_size', "Number of 'columns'", "Nombre de 'colonnes'"),
('display_y_size', "Number of 'lines'", " Nombre de 'lignes'"),
('incrementation (general)', "Incrementation (General)", "Incrémentation (génerale)"),
('reverse_x_numbering', "Incrementation", "Incrémentation"),
('reverse_y_numbering', "Incrementation", "Incrémentation");

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("vertically", "Vertically", "Verticalement"),
("horizontally", "Horizontally", "Horizontalement"),
('coordinate', 'Coordinate', 'Coordonnée'),
("number_of_positions", "Number of positions", "Nombre de positions"),
("top to bottom", "Top to Bottom", "Haut en bas"),
("bottom to top", "Bottom to Top", "Bas en haut"),
("left to right", "Left to Right", 'De gauche à droite'),
("right to left", "Right to Left", 'De droite à gauche');

-- Change list coordinate type to "storage coordinates managed by users" 
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("list", "storage coordinates managed by users");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="storage_coord_types"), (SELECT id FROM structure_permissible_values WHERE value="list" AND language_alias="storage coordinates managed by users"), "3", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="storage_coord_types" AND spv.value="list" AND spv.language_alias="list";
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("storage coordinates managed by users", "Coordinates managed by users", "Coordonnées géreés par utilisteurs");

-- Allow storage control deletion
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES  
('this storage type has already been used to build a storage','This storage type has already been used to build storages.','Ce type d\'entreposage a déjà été utilisé pour construire un entreposage');
ALTER TABLE storage_controls ADD COLUMN `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0';
  
-- Move storage type translations
-- from structure_permissible_values_customs to storage_controls
-- -------------------------------------------------------------------------------------
  
ALTER TABLE storage_controls
  ADD COLUMN `storage_type_en` varchar(255) DEFAULT NULL,
  ADD COLUMN `storage_type_fr` varchar(255) DEFAULT NULL;
UPDATE storage_controls Sc, structure_permissible_values_custom_controls Spc, structure_permissible_values_customs Spv  
SET storage_type_en = spv.en,
storage_type_fr = spv.fr
WHERE Spc.name = 'storage types'
AND Spc.id = Spv.control_id AND Spv.deleted <> 1
AND Spv.value = Sc.storage_type;
UPDATE structure_permissible_values_customs 
SET deleted = 1
WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'storage types');
UPDATE structure_permissible_values_custom_controls 
SET flag_active = 0
WHERE name = 'storage types';
INSERT INTO structures(`alias`) VALUES ('storage_control_translations');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageCtrl', 'storage_controls', 'storage_type_en', 'input',  NULL , '1', 'size=10', '', '', 'English', ''), 
('StorageLayout', 'StorageCtrl', 'storage_controls', 'storage_type_fr', 'input',  NULL , '1', 'size=10', '', '', 'French', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_translations'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type_en' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=10' AND `default`=''), '3', '101', 'translation', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='storage_control_translations'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type_fr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=10' AND `default`=''), '3', '102', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES  ('translation', 'Translation', 'Traduction');
SET @old_id = (SELECT id FROM structure_fields WHERE field = 'storage_type' AND type = 'select');
SET @new_id = (SELECT id FROM structure_fields WHERE field = 'storage_type' AND type = 'input');
UPDATE structure_formats 
SET structure_field_id = @new_id 
WHERE structure_field_id = @old_id AND structure_id = (SELECT id FROM structures WHERE alias = 'storage_controls');
UPDATE structure_formats 
SET structure_field_id = @new_id 
WHERE structure_field_id = @old_id AND structure_id IN (SELECT id FROM structures WHERE alias IN ('storage_control_no_d', 'storage_control_1d', 'storage_control_2d', 'storage_control_tma'));
UPDATE structure_formats 
SET `flag_edit`='1', `flag_edit_readonly`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('storage_control_no_d', 'storage_control_1d', 'storage_control_2d', 'storage_control_tma'))
AND structure_field_id=@new_id;
DELETE FROM structure_formats
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('storage_control_no_d', 'storage_control_1d', 'storage_control_2d', 'storage_control_tma'))
AND structure_field_id=@old_id;
DELETE FROM structure_fields WHERE id = @old_id;
DELETE FROM structure_value_domains WHERE source = "Administrate.StorageCtrl::getAllTranslatedStorageTypes" ;
DELETE FROM structure_formats
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type')
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('storage_control_no_d', 'storage_control_1d', 'storage_control_2d', 'storage_control_tma'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_translations'), (SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='storage_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structures SET alias = 'storage_control_type_and_translations' WHERE alias = 'storage_control_translations';

--	Issue #3370 (Storage Layout: Set X-axis in second position field and Y-axis in first position field)
-- -------------------------------------------------------------------------------------

ALTER TABLE `storage_controls` ADD `permute_x_y` tinyint(1) DEFAULT '0' COMMENT '1: In view change x and y (ex: 4-1 means 4th row, first column)' AFTER `horizontal_increment`;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageCtrl', 'storage_controls', 'permute_x_y', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'permute_x_y', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_controls'), 
(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='permute_x_y' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='permute_x_y' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='storage_control_2d'), 
(SELECT id FROM structure_fields WHERE `model`='StorageCtrl' AND `tablename`='storage_controls' AND `field`='permute_x_y' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='permute_x_y' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO 	i18n (id,en,fr) VALUES 	('permute_x_y', 'Permute X and Y', 'Permuter X et Y');
UPDATE storage_controls SET permute_x_y = '0' WHERE coord_y_type IN ('alphabetical', 'integer');

-- -------------------------------------------------------------------------------------
-- Issue #3523: Create new sample controls
-- -------------------------------------------------------------------------------------

-- Stool to protein relationship

INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) 
VALUES 
(NULL, (SELECT id FROM sample_controls WHERE sample_type = 'stool'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), '0');

-- CD138

INSERT INTO sample_controls(sample_type, sample_category, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('cd138 cells', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_cd138s', 'cd138 cells');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id,derivative_sample_control_id , flag_active)
VALUES
((SELECT id FROM sample_controls WHERE sample_type LIKE 'bone marrow'), (SELECT id FROM sample_controls WHERE sample_type LIKE 'cd138 cells'),0);
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, detail_form_alias, detail_tablename, flag_active, databrowser_label, volume_unit)
VALUES
((SELECT id FROM sample_controls WHERE sample_type LIKE 'cd138 cells'), 'tube', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', '0', 'cd138 cells|tube', 'ml');
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active)
VALUES
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'cd138 cells|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'cd138 cells|tube'), '0');
CREATE TABLE `sd_der_cd138s` (
  `sample_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `sd_der_cd138s_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_der_cd138s`
  ADD KEY `FK_sd_der_cd138s_sample_masters` (`sample_master_id`);
ALTER TABLE `sd_der_cd138s_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `sd_der_cd138s_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `sd_der_cd138s`
  ADD CONSTRAINT `FK_sd_der_cd138s_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES  
('CD138', 'CD138', 'CD138');

-- Xeno buffy coat

INSERT INTO sample_controls(sample_type, sample_category, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('xeno-buffy coat', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_xeno_buffy_coats', 'xeno-buffy coat');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id,derivative_sample_control_id , flag_active)
VALUES
((SELECT id FROM sample_controls WHERE sample_type LIKE 'xeno-blood'), (SELECT id FROM sample_controls WHERE sample_type LIKE 'xeno-buffy coat'),0);
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, detail_form_alias, detail_tablename, flag_active, databrowser_label, volume_unit)
VALUES
((SELECT id FROM sample_controls WHERE sample_type LIKE 'xeno-buffy coat'), 'tube', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', '0', 'xeno-buffy coat|tube', 'ml');
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active)
VALUES
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-buffy coat|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-buffy coat|tube'), '0');
CREATE TABLE `sd_der_xeno_buffy_coats` (
  `sample_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `sd_der_xeno_buffy_coats_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_der_xeno_buffy_coats`
  ADD KEY `FK_sd_der_xeno_buffy_coats_sample_masters` (`sample_master_id`);
ALTER TABLE `sd_der_xeno_buffy_coats_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `sd_der_xeno_buffy_coats_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `sd_der_xeno_buffy_coats`
  ADD CONSTRAINT `FK_sd_der_xeno_buffy_coats_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES  
('xeno-buffy coat', 'Xeno-Buffy Coat', 'Xeno-Puffy Coat');

-- -------------------------------------------------------------------------------------
--	missing i18n translations
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES
	('number of data', 'Number of Data', 'Nombre de données'),
	('obtained consents', 'Obtained Consents', 'Consentements obtenus'),
	('detach the chart', 'Open in Pop-up', 'Ouvrir dans pop-up'),
	('report data table', 'Report', 'Rapport'),
	('graphics', 'Graphics', 'Graphiques'),
	('graphic', 'Graphic', 'Graphique'),
	('diagrams', 'Graphics', 'Graphiques'),
	('diagram', 'Graphic', 'Graphique'),
	('file', 'File', 'Fichier'),
	('obtained consents', 'Obtained Consents', 'Consentements obtenus'),
	('open file', 'Open File', 'Ouvrir fichier');

-- ----------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'xxxx','n/a');