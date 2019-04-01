-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.1
--
-- For more information:
--    ./app/scripts/v2.7.1/ReadMe.txt
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
--	Issue #3359: The pwd reset form has fields with different look and feel.
-- -------------------------------------------------------------------------------------

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, 
(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='confirm_password' AND `type`='password' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='core_confirmpassword' AND `language_tag`='')
, 'notBlank', '', 'password is required'),
(NULL, 
(SELECT id FROM structure_fields WHERE `model`='Generated' AND `field`='field1' AND `type`='input' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='')
, 'notBlank', '', 'password is required');

-- -------------------------------------------------------------------------------------
--	The warning for LOG directory
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES 	(
'the permission of "log" directory is not correct.', 
'The permissions on "log" directory are not correct.',
'Les autorisations sur le répertoire de "log" ne sont pas correctes.');
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
("default_values", "Default values", "Valeurs par defaux"),
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
"La taille de fichier dois être inférieure à %d octets");

-- -------------------------------------------------------------------------------------
--	upload directory permission incorrect
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES(
'the permission of "upload" directory is not correct.', 
'The permissions on "upload" directory are not correct.', 
"Les autorisations sur le répertoire de téléchargement ne sont pas correctes.");

-- -------------------------------------------------------------------------------------
--	Storage layout
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES
('for now listed storage is not supported', 
"The 'Load aliquots from CSV' is not supported for storage with 'Coordinates managed by users' in the current release of ATiM.",
"Le 'chargement des aliquots à partir d'un CSV' n'est pas supporté pour les entreposages dont les 'coordonnées sont géreés par les utilisteurs' dans la version actuelle d'ATiM."),
('aliquot does not exist', 'Aliquot does not exist', 'L''aliquot n\'existe pas'),
('aliquot is not in stock', 'Aliquot is not in stock', 'L''aliquot n\'est pas en stock'),
('this aliquot is registered in another place. label: %s, x: %s, y: %s', 
'The current position of the aliquot is different than the defined position in the file: Storage [%s] & position %s - %s.', 
"La position actuelle de l'aliquot est différente de la position définie dans le fichier: Entreposage [%s] & position %s - %s."),
('more than one aliquot have the same barcode', 'More than one aliquot have the same barcode', 'Plus d''un aliquot a le même code à barres'),
('the aliquots list', 'The list of aliquots', 'La liste des aliquots'),
('line %s', 'Line %s', 'Ligne %s'),
('load csv', 'Load CSV', 'Charger CSV'),
('clear the loaded and scanned barcode', 'Clear the loaded or scanned aliquots', 'Effacer les aliquots téléchargés ou scannés'),
('this aliquot is registered in another place', 'This aliquot is registered in another storage/position', 'Cet aliquot est enregistré dans un autre entreposage/position'),
('the y dimension out of range <= %s', 'The Y dimension is out of range > %s', "La dimension Y est hors de l'intervalle > %s"),
('the x dimension out of range <= %s', 'The X dimension is out of range > %s', "La dimension X est hors de l'intervalle > %s"),
('duplicate barcode in csv file', 'Duplicated barcode in CSV file', 'Codes à barres dupliqués dans le fichier CSV'),
('should have Y column', 'Column Y missing. Please check your CSV separator.', 'Colonne Y manquante. Veuillez vérifier votre séparateur CSV.'),
('should have barcode column', 'Barcodes column missing', 'Colonne des codes à barres manquante'),
('should have X column',  'Column X missing. Please check your CSV separator.', 'Colonne X manquante. Veuillez vérifier votre séparateur CSV.'),
('error in csv header file', 'Error in CSV header file', 'Erreur dans les en-têtes du fichier CSV'),
('error in opening %s', 'Error in opening file %s', "Erreur d'ouverture du fichier%s"),
('error in x dimension: %s', 'Error in X dimension: %s', 'Erreur de dimension X: %s'),
('error in y dimension: %s', 'Error in Y dimension: %s', 'Erreur de dimension Y: %s'),
('error in opening csv file', 'Error in opening CSV file', "Erreur lors de l'ouverture du fichier CSV"),
('load the cores positions and barcodes by csv file', 
'Load the blocks barcodes and cores positions from CSV file', 
'Charger codes à barres des blocs et positions des cores à partir du CSV'),
('load aliquots by csv', 'Load aliquot postions from CSV', 'Charger les positions d''aliquots du CSV'),
('load the aliquots positions and barcodes by csv file', 'Load the aliquots positions from CSV file', 'Charger les positions des aliquots et les codes à barres par fichier CSV'),
('load the cores positions and block barcodes by csv file', 
'Load the blocks barcodes then create cores and set cores positions from CSV file', 
'Charger les codes à barres des blocs, créeation des cores et définition de la position des cores à paritr d''un fichier CSV'),
('load blocks by csv', 'Load blocks from CSV', 'Charger les blocs du CSV'),
('the x dimension should be alphabetical', 'The X dimension should be alphabetical', 'La dimension X doit être alphabétique'),
('the x dimension should be numeric', 'The X dimension should be numeric', 'La dimension X doit être numérique'),
('the y dimension should be alphabetical', 'The Y dimension should be alphabetical', 'La dimension Y devrait être alphabétique'),
('the y dimension should be numeric', 'The Y dimension should be numeric', 'La dimension Y devrait être numérique'),
('should not have y dimension', 'Should not have the Y dimension.', 'Ne devrait pas avoir de dimension Y.'),
('load cores by csv', 'Load cores from CSV', 'Charger les cores du CSV'),
('undo positions load and barcodes scanned', "Undo positions load and barcodes scanned", "Annuler chargement des positions et codes à barres scannés");

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES
('aliquot validation summary', "Aliquot(s) Validation Summary", "Résumé de la validation des aliquots"),
('add to layout', "Add to Layout", "Ajouter au plan"),
('number of aliquots analyzed = %d, validated = %d, warning = %d, error = %d', 
"Number of aliquots : Analyzed = %d, Validated = %d, With warning = %d, With error = %d", 
"Nombre d'aliquots: Analysés =% d, validé =% d, avec avertissement =% d, avec erreur =% d"),
('analyzed = %d\nok = %d\nwarning = %d\nerror = %d', "Analyzed = %d\nOk = %d\nWarning = %d\nError = %d", "Analysés = %d\nOk = %d\nAvertissements = %d\nErreurs = %d"),
("aliquot '%s' [%s-%s]", "Aliquot '%s' [%s-%s]", "Aliquot '%s' [%s-%s]"),
("aliquot '%s' [%s]", "Aliquot '%s' [%s]", "Aliquot '%s' [%s]");

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
('collection_protocol_template_all', "Tools.Template::getTemplatesList('all')"),
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
('collection_protocols', "Tools.CollectionProtocol::getProtocolsList('all')");
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
('reverse_y_numbering', "Incrementation", "Incrémentation"),
("no type list can be set for x or y fields in 2 dimensions storage type", "No type 'Coordinates managed by users' can be set for both coordinates of a 2 dimensions storages", "Aucun type 'Coordonnées géreés par utilisteurs' ne peut être choisi pour une coordonné d'un entreposage à deux dimensions");

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
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS Spv ON svdpv.structure_permissible_value_id=Spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="storage_coord_types" AND Spv.value="list" AND Spv.language_alias="list";
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
SET storage_type_en = Spv.en,
storage_type_fr = Spv.fr
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
INSERT IGNORE INTO i18n (id,en,fr) VALUES 	('permute_x_y', 'Permute X and Y', 'Permuter X et Y');
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
('CD138', 'CD138', 'CD138'),
('cd138 cells', 'CD138 Cells', 'Cellules CD138');

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
-- Issue #3483: Create an aliquot shipment Code & Be able to edit order items in 
-- batch to complete Shipment Code
-- -------------------------------------------------------------------------------------

-- Add order_item_shipping_label

ALTER TABLE order_items ADD COLUMN order_item_shipping_label VARCHAR(150) DEFAULT NULL;
ALTER TABLE order_items_revs ADD COLUMN order_item_shipping_label VARCHAR(150) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'order_item_shipping_label', 'input',  NULL , '0', 'size=20', '', '', 'item shipping label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='order_item_shipping_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='item shipping label' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('item shipping label', 'Shipping Label (Item)', 'Étiquette d''envoi (Article)');

-- Clean up i18n 

REPLACE INTO i18n (id,en,fr)
VALUES
('shipment details', 'Shipment Details', "Détails de l'envoi"),
('shipping code', 'Shipping Code', "Code d'envoi"),
('Shipping Date', 'Shipping Date', "Date d'envoi");

-- Delete structure orderitems_returned

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems_returned');
DELETE FROM structures WHERE alias='orderitems_returned';

UPDATE structure_formats SET `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='datetime_shipped' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_returned' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reason_returned' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_status') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='aliquot_master_id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='tma_slide_id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('fields defined for returned items can not be completed for items with status different than shipped & returned',
"The fields defined for returned items can not be completed for items with status different than 'Shipped & Returned'",
"Les champs définis pour les articles retournés ne peuvent pas être complétés pour les articles dont le statut est différent de 'Enovyé & Retourné'."),
('edit returned items', "Edit 'Returned' Items", "Modifier articles 'retournés'"),
('edit shipped items', "Edit 'Shipped' Items", "Modifier articles 'envoyés'"),
('edit pending items', "Edit 'Pending' Items", "Modifier articles 'en attente'"),
('edit all items', "Edit 'All' Items", "Modifier tous les articles");

-- -------------------------------------------------------------------------------------
--	missing i18n translations
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES
('test', 'Test', 'Test'),
('you do not own that protocol','You do not own that protocol',"Vous n'êtes pas propiétaire du protocole"),
('data can not be changed', 'Data can not be changed', "Les données ne peuvent pas être modifiées"),
('click on submit button of the main form to record the default values', 
"Please don't forget to click on submit button of the main form to record any default value entered or updated",
"Veuillez ne pas oublier de cliquer sur le bouton 'Envoyer' du formulaire principal pour enregistrer toute valeur par défaut saisie ou mise à jour"),
('click on submit button of the main form to save the loaded records', 
"Please don't forget to click on submit button of the main form to record any aliquot entered or updated",
"Veuillez ne pas oublier de cliquer sur le bouton 'Envoyer' du formulaire principal pour enregistrer toute aliquot saisie ou mise à jour"),
('edit modified order items to remove any information about the return', 'Please edit modified order items to remove any information about the return.', "Veuillez modifier les éléments de commande modifiés pour supprimer toute information sur le retour."),
('copy for new storage control', 'Copy for New Type', 'Copier pour nouveau type'),
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

-- -------------------------------------------------------------------------------------
--	Issue #3607: No data to select returned items
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
i18n (id,en,fr)
VALUES
('order items data update will be limited to the item defined as returned',
'The update of the order items data will be limited to the items selected to be defined as returned',
"La mise à jour des données des articles de commande sera limitée aux articles sélectionnés pour être définis comme retournés");
	
-- -------------------------------------------------------------------------------------
--	Issue #3614: Unbale to edit protocol created by another user - Validate and change 
--    rules to use or edit a collection template or protocol
--    Review protocol owner/use/etc
--    Add created by
-- -------------------------------------------------------------------------------------

-- Add bank level to sharing value domain

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS Spv ON Spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='sharing' AND Spv.id=(SELECT id FROM structure_permissible_values WHERE value="bank" AND language_alias="bank");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS Spv ON Spv.id=svdpv.structure_permissible_value_id SET `display_order`="4" WHERE svd.domain_name='sharing' AND Spv.id=(SELECT id FROM structure_permissible_values WHERE value="all" AND language_alias="all");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("group", "group");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="sharing"), (SELECT id FROM structure_permissible_values WHERE value="group" AND language_alias="group"), "2", "1");

-- Add user id and group id to tables templates and collection_protocols;
-- Remove owning_entity_id, visible_entity_id, created_by

ALTER TABLE templates
   ADD COLUMN `user_id` int(11) NOT NULL AFTER owner,
   ADD COLUMN `group_id` int(11) NOT NULL AFTER user_id;
UPDATE templates, users
SET user_id = users.id,
templates.group_id = users.group_id
WHERE templates.created_by = users.id;
ALTER TABLE templates
   ADD CONSTRAINT `templates_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
   ADD CONSTRAINT `templates_groups` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`);
ALTER TABLE templates
   DROP COLUMN owning_entity_id,
   DROP COLUMN visible_entity_id,
   DROP COLUMN created_by;

ALTER TABLE collection_protocols
   ADD COLUMN `user_id` int(11) NOT NULL AFTER owner,
   ADD COLUMN `group_id` int(11) NOT NULL AFTER user_id;
UPDATE collection_protocols, users
SET user_id = users.id,
collection_protocols.group_id = users.group_id
WHERE collection_protocols.created_by = users.id;
ALTER TABLE collection_protocols
   ADD CONSTRAINT `collection_protocols_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
   ADD CONSTRAINT `collection_protocols_groups` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`);
ALTER TABLE collection_protocols
	DROP COLUMN owning_entity_id,
	DROP COLUMN visible_entity_id,
	DROP COLUMN created_by;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tool', 'CollectionProtocol', 'collection_protocols', 'user_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='users_list') , '0', '', '', '', 'created by', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collection_protocol'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocol' AND `tablename`='collection_protocols' AND `field`='user_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='users_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tool', 'Template', 'templates', 'user_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='users_list') , '0', '', '', '', 'created by', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='user_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='users_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- -------------------------------------------------------------------------------------
--	Issue #3617: Apply same owner rules than 'Collection Templates & Protocols' 
--     to 'Batchsets' and 'Saved Browsing Steps'
-- -------------------------------------------------------------------------------------

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="4" WHERE svd.domain_name='batch_sets_sharing_status' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="all" AND language_alias="public");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("bank", "share with the bank");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="batch_sets_sharing_status"), (SELECT id FROM structure_permissible_values WHERE value="bank" AND language_alias="share with the bank"), "3", "1");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('share with the bank', 'Share With The Bank', 'Partager avec la banque'),
('at least one batchset is locked', "At least one batchset is locked. Please click on 'Detail' to unlock the batchset.", "Au moins un lot de données est bloqué. Veuillez cliquer sur 'Détail' pour le débloquer'.");
REPLACE INTO i18n (id,en,fr)
VALUES
('this batchset is locked', "This batchset is locked. Please click on 'Detail' to unlock the batchset.", "Ce lot de données est bloqué. Veuillez cliquer sur 'Détail' pour le débloquer'.");

-- -------------------------------------------------------------------------------------
--	Issue #3618: Missing Steps in 'Saved Browsing Steps' detail form
-- -------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='datamart_saved_browsing') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------
--	Re-design menus for Addministartion Bank and Group
-- -------------------------------------------------------------------------------------

UPDATE menus SET use_link = '/Administrate/Versions/detail/' WHERE id = 'core_CAN_41';
UPDATE menus SET language_title = 'merge participants/collections', display_order = (display_order+1) WHERE id = 'core_CAN_41_6';
SET @bank_display_order = (SELECT display_order FROM menus WHERE id = 'core_CAN_41_2');
SET @group_display_order = (SELECT display_order FROM menus WHERE id = 'core_CAN_41_1');
UPDATE menus SET display_order = @bank_display_order WHERE id = 'core_CAN_41_1';
UPDATE menus SET display_order = @group_display_order WHERE id = 'core_CAN_41_2';
UPDATE structure_fields SET  `language_label`='group' WHERE model='Group' AND tablename='groups' AND field='name' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE menus SET use_summary = 'Administrate.Bank::summary' WHERE use_summary = 'Bank::summary';
UPDATE menus SET flag_active = 0 WHERE id = 'core_CAN_41_2_2';
UPDATE menus SET flag_active = 0 WHERE id = 'core_CAN_41_1_3';
UPDATE menus SET parent_id = 'core_CAN_41_1_1' WHERE parent_id = 'core_CAN_41_1_3';
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('add user', 'Add User', 'Créer utilisateur'),
('add announcement', 'Add Announcement', 'Créer annonce'),
('merge participants/collections', 'Merge Participants/Collections', 'Fusion de participants/collections');
UPDATE structure_fields SET  `language_label`='new group' WHERE model='Group' AND tablename='groups' AND field='id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='group_select');
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Administrate/AdminUsers/changeGroup%';

-- -------------------------------------------------------------------------------------
--	Fix the bug for review_code that can be null.
-- -------------------------------------------------------------------------------------
ALTER TABLE `aliquot_review_masters` CHANGE `review_code` `review_code` VARCHAR(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL;
ALTER TABLE `aliquot_review_masters_revs` CHANGE `review_code` `review_code` VARCHAR(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL;

-- ----------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'7297','n/a');

-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('template init error please contact your administrator', 'An error exists in the field definition. Please contact your administrator.', "Une erreur existe dans la définition du champ. Veuillez contacter votre administrateur.");

UPDATE versions SET trunk_build_number = '7370' WHERE version_number = '2.7.1';
