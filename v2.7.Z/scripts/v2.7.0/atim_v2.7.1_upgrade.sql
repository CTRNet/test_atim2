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
    'The PHP "post_max_size" defined into the "php.ini" file is less than the "upload_max_filesize" defined into the ATiM "core.php" file. Configuration will generate problems when user will download big files. Please update either the "php.ini" file or the "core.php" file.',
	'La variable PHP "post_max_size" définie dans le fichier "php.ini" est inférieure au "upload_max_filesize" défini dans le fichier ATiM "core.php". La configuration génèrera des problèmes lorsque l''utilisateur téléchargera de gros fichiers. Veuillez mettre à jour le fichier "php.ini" ou le fichier "core.php".');

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
	
-- Add collection prootocols

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
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'time_from_first_visit', 'integer_positive',  NULL , '0', '', '', '', 'time', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'time_from_first_visit_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='time_from_first_visit_unit') , '0', '', '', '', '', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'default_values', 'input',  NULL , '0', '', '', '', 'default values', ''), 
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'id', 'hidden',  NULL , '0', 'size=5', '', '', 'collection_protocol_visit_id', ''),
('Tools', 'CollectionProtocolVisit', 'collection_protocol_visits', 'first_visit', 'checkbox',  NULL , '0', '', '', '', 'first visit', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='title' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='collection_protocol_visit'), (SELECT id FROM structure_fields WHERE `model`='CollectionProtocolVisit' AND `tablename`='collection_protocol_visits' AND `field`='template_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocol_template')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='template' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
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
('template is part of a collection protocol visit', 'The template is part of a collection protocol visit', "Le template fait partie d'une visite de protocole de collection"),
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
