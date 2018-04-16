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

-- -------------------------------------------------------------------------------------
--	File size error message
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES(
	"the file size should be less than %d bytes", 
	"The file size should be less than %d bytes", 
	"La taille de fichier dois être mois que %d octets");

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
-- is realiquoting aliquot(s) or creating aliquot(s) from sample
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
--	missing i18n translations
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
	i18n (id,en,fr)
VALUES
	('file', 'File', 'Fichier'),
	('open file', 'Open File', 'Ouvrir fichier');

-- ----------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.1', NOW(),'xxxx','n/a');
