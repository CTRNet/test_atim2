-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.fb
--
-- For more information:
--    ./app/scripts/v2.7.0/ReadMe.txt
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
--	The dictionary
-- -------------------------------------------------------------------------------------

INSERT IGNORE INTO 
    i18n (id,en,fr)
VALUES 	
    ('form builder', 'Form Builder', 'Constructeur de Formulaire'),
    ('form builder description', 'A tool to create the custom fields.', 'Un outil pour créer les champs personnalisés.'),
    ('consent control description', 'The consent control keeps the participant consent information.', 'Le contrôle de consentement conserve les informations de consentement du participant.'),
    ('form builder index alias', 'The form builder index fields.', "Les champs d\'index du constructeur de formulaire."),
    ('consent type', "Consent type", "Type de consentement"),
    ('databrowser label', "Databrowser label", "Étiquette de Databrowser"),
    ('databrowser label help', "The name that will be appeared in search DataBrowser.", "Le nom qui apparaîtra dans la recherche DataBrowser."),
    ('flag active', "Active", "Active"),
    ('french label', "The French label", "l'étiquette en français"),
    ('english label', "The English label", "l'étiquette en anglais"),
    ('data browser label french', "This label will be shown in the French version of the website.", "Cette étiquette va être montrée dans la version français de site web"),
    ('data browser label english', "This label will be shown in the English version of the website.", "Cette étiquette va être montrée dans la version anglais de site web"),
    ('do you want to update the labels?', "Do you want to update the English and French labels?", "Voulez-vous mettre à jour les étiquettes en anglais et en français?"),
    ('the labels are already exist and unchangeable', "The labels are already exist and unchangeable.", "Les étiquettes existent déjà et non modifiables."),
    ('the french label fills automatic', "The French label fills automatic.", "Le label français se remplit automatiquement."),
    ('the english label fills automatic', "The English label fills automatic.", "Le label anglais se remplit automatiquement.");

--    ('', "", ""),

INSERT IGNORE INTO 
    i18n (id,en,fr)
VALUES 	
	('flag_confidential', 'Confidential', 'Confidentiel'),
	('language_label', 'Field label', 'Étiquette de champ'),
	('language_help', 'Help message', "Message d'aide"),
	('field type', 'Field type', 'Type de champ'),
	('flag_add', 'Add', 'Création'),
	('flag_edit', 'Edit', 'Modification'),
	('flag_search', 'Search', 'Recherche'),
	('flag_index', 'Index', 'Index'),
	('flag_detail', 'Detail', 'Détail'),
	('display_column', 'Position', 'Position'),
	('display_order', 'Row number', 'Numéro de ligne'),
-- 	('control information', '', ''),
	('click to add the validation rules', 'Click to add the validation rules.', 'Cliquez pour ajouter les règles de validation.'),
	('language_heading', 'Heading title', 'Titre de rubrique'),
	('checkbox', 'Checkbox', 'Case à cocher'),
	('date', 'Date', 'Date'),
	('datetime', 'Date / Time', 'Date / Heure'),
	('float', 'Decimal number', 'Nombre décimal'),
	('input', 'Text box', 'Boite de texte'),
	('integer-type', 'Integer', 'Entier'),
	('integer_positive', 'Integer positive', 'Entier positif'),
	('select', 'List', 'Liste'),
	('textarea', 'Text area', 'Zone de texte'),
	('time', 'Time', 'Temps'),
	('click to add/modify list', 'Click to add / modify the list', 'Cliquez pour ajouter / modifier la liste'),
	('check the validations rules after changing the data type', 'Please check the validations rules, because the data type has been changed.', 'Veuillez vérifier les règles de validation, car le type de données a été modifié.'),
	('should complete both or none of them', 'Should complete both or none of them.', "Devrait compléter les deux ou aucun d'entre eux."),
	('validateIcdo3TopoCode', 'ICD-o-3 Topo', 'ICD-o-3 Topo'),
	('validateIcdo3MorphoCode', 'ICD-o-3 Morpho', 'ICD-o-3 Morpho'),
	('validateIcd10WhoCode', 'ICD-10', 'ICD-10'),
	('icd_0_3_topography_categories', 'ICD-O-3 Topo Categoris', 'ICD-O-3 Topo Catégories'),
	('yes_no', 'Yes/No', 'Oui/Non');


-- 	('', '', ''),
-- -------------------------------------------------------------------------------------
--	Add FB to administrator Menu
-- -------------------------------------------------------------------------------------

INSERT INTO 
    `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`)
VALUES
    ('core_CAN_41_10', 'core_CAN_41', '0', '8', 'form builder', 'form builder description', '/Administrate/FormBuilders/index', '', '1', '1');

-- -------------------------------------------------------------------------------------
--	Create the form_builders table which keep the list of models can be customized
-- -------------------------------------------------------------------------------------

CREATE TABLE `form_builders` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `plugin` varchar(255) COLLATE 'latin1_swedish_ci' NOT NULL,
  `model` varchar(255) COLLATE 'latin1_swedish_ci' NOT NULL,
  `master` varchar(255) COLLATE 'latin1_swedish_ci' NULL,
  `table` varchar(255) COLLATE 'latin1_swedish_ci' NOT NULL,
  `alias` varchar(255) COLLATE 'latin1_swedish_ci' NOT NULL,
  `default_alias` varchar(255) COLLATE 'latin1_swedish_ci' NOT NULL,
  `note` text COLLATE 'latin1_swedish_ci' NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int(11) NOT NULL DEFAULT '0'
) ENGINE='InnoDB' COLLATE 'latin1_swedish_ci';

-- -------------------------------------------------------------------------------------
--	initializing the form_builders table
-- -------------------------------------------------------------------------------------
INSERT INTO `form_builders` (`plugin`, `model`, `master`, `table`, `alias`, `default_alias`, `note`, `flag_active`)
VALUES ('ClinicalAnnotation', 'ConsentControl', 'ConsentMaster', 'consent_controls', 'form_builder_consent', 'consent_masters', 'consent control description', '1'),
       ('ClinicalAnnotation', 'DiagnosisControl', 'DiagnosisMaster', 'diagnosis_controls', 'form_builder_diagnosis', 'diagnosismasters', 'diagnosis control description', '1');

-- -------------------------------------------------------------------------------------
--	Create form_builder_index alias
-- -------------------------------------------------------------------------------------
INSERT INTO structures(`alias`) VALUES ('form_builder_index');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('Administrate', 'FormBuilder', 'form_builders', 'model', 'input',  NULL , '0', '', '', '', 'model', ''),
('Administrate', 'FormBuilder', 'form_builders', 'note', 'textarea',  NULL , '0', '', '', '', 'note', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE `alias`='form_builder_index'), (SELECT id FROM structure_fields WHERE `model`='FormBuilder' AND `tablename`='form_builders' AND `field`='model' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='model' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE `alias`='form_builder_index'), (SELECT id FROM structure_fields WHERE `model`='FormBuilder' AND `tablename`='form_builders' AND `field`='note' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='note' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- -------------------------------------------------------------------------------------
--	Create form_builder_consent alias
-- -------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('form_builder_consent');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('ClinicalAnnotation', 'ConsentControl', 'consent_controls', 'controls_type', 'input',  NULL , '0', 'class=control-name', '', '', 'consent type', ''), 
('ClinicalAnnotation', 'ConsentControl', 'consent_controls', 'databrowser_label', 'input',  NULL , '0', '', '', 'databrowser label help', 'databrowser label', ''), 
('ClinicalAnnotation', 'ConsentControl', 'consent_controls', 'flag_active', 'checkbox',  NULL , '0', '', '', 'help_flag_active', 'flag active', ''),
('ClinicalAnnotation', 'ConsentControl', 'consent_controls', 'display_order', 'integer',  NULL , '0', '', '', '', 'display order', ''),
('ClinicalAnnotation', 'ConsentControl', 'i18n', 'databrowser_label_en', 'input',  NULL , '0', 'class=english-label', '', 'data browser label english', 'english label', ''), 
('ClinicalAnnotation', 'ConsentControl', 'i18n', 'databrowser_label_fr', 'input',  NULL , '0', 'class=french-label', '', 'data browser label french', 'french label', '');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='controls_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=control-name' AND `default`='' AND `language_help`='' AND `language_label`='consent type' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='databrowser_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='databrowser label help' AND `language_label`='databrowser label' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='flag_active' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_flag_active' AND `language_label`='flag active' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='display_order' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='display order' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='i18n' AND `field`='databrowser_label_en' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=english-label' AND `default`='' AND `language_help`='data browser label english' AND `language_label`='english label' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='i18n' AND `field`='databrowser_label_fr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=french-label' AND `default`='' AND `language_help`='data browser label french' AND `language_label`='french label' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_validations (`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT id FROM structure_fields WHERE `tablename`='consent_controls' AND `field`='controls_type'), 'notBlank', 'consent type is required'),
((SELECT id FROM structure_fields WHERE `tablename`='consent_controls' AND `field`='controls_type'), 'isUnique', 'consent type should be unique');

-- -------------------------------------------------------------------------------------
--	Value domain field type
-- -------------------------------------------------------------------------------------
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("form_builder_type_list", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("checkbox", "checkbox");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="checkbox" AND language_alias="checkbox"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("date", "date");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="date" AND language_alias="date"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("datetime", "datetime");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="datetime" AND language_alias="datetime"), "4", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("float", "float");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="float" AND language_alias="float"), "6", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("input", "input");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="input" AND language_alias="input"), "9", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("integer", "integer-type");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="integer" AND language_alias="integer-type"), "11", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("select", "select");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="select" AND language_alias="select"), "14", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("textarea", "textarea");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="textarea" AND language_alias="textarea"), "15", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("time", "time");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="time" AND language_alias="time"), "16", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("yes_no", "yes_no");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="yes_no" AND language_alias="yes_no"), "17", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("validateIcd10WhoCode", "validateIcd10WhoCode");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="validateIcd10WhoCode" AND language_alias="validateIcd10WhoCode"), "18", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("validateIcdo3MorphoCode", "validateIcdo3MorphoCode");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="validateIcdo3MorphoCode" AND language_alias="validateIcdo3MorphoCode"), "19", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("validateIcdo3TopoCode", "validateIcdo3TopoCode");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="validateIcdo3TopoCode" AND language_alias="validateIcdo3TopoCode"), "20", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("icd_0_3_topography_categories", "icd_0_3_topography_categories");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="form_builder_type_list"), (SELECT id FROM structure_permissible_values WHERE value="icd_0_3_topography_categories" AND language_alias="icd_0_3_topography_categories"), "21", "1");



-- -------------------------------------------------------------------------------------
--	Form builder control alias 
-- -------------------------------------------------------------------------------------
INSERT INTO structures(`alias`) VALUES ('form_builder_structure');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'StructureField', 'structure_fields', 'language_label', 'input',  NULL , '0', 'class=pasteDisabled', '', 'language_label_help', 'language_label', ''),
('Administrate', 'StructureField', 'structure_fields', 'flag_confidential', 'checkbox',  NULL , '0', 'class=pasteDisabled', '', 'flag_confidential_help', 'flag_confidential', ''), 
('Administrate', 'StructureField', 'structure_fields', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='form_builder_type_list') , '0', 'class=fb_type_select,class=pasteDisabled', '', '', 'field type', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'flag_add', 'checkbox',  NULL , '0', '', '', 'flag_add_help', 'flag_add', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'flag_edit', 'checkbox',  NULL , '0', '', '', 'flag_edit_help', 'flag_edit', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'flag_search', 'checkbox',  NULL , '0', '', '', 'flag_search_help', 'flag_search', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'flag_index', 'checkbox',  NULL , '0', '', '', 'flag_index_help', 'flag_index', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'flag_detail', 'checkbox',  NULL , '0', '', '', 'flag_detail_help', 'flag_detail', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'display_column', 'integer_positive',  NULL , '0', 'class=pasteDisabled', '1', 'display_column_help', 'display_column', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'display_order', 'integer_positive',  NULL , '0', 'class=pasteDisabled', '1', 'display_order_help', 'display_order', ''), 
('Administrate', 'StructureFormat', 'structure_formats', 'language_heading', 'input',  NULL , '0', 'class=pasteDisabled', '', 'language_heading_help', 'language_heading', ''),
('Core', 'FunctionManagement', '', 'is_structure_value_domain', 'button',  NULL , '0', 'class=fb_is_structure_value_domain_input', '', 'is_structure_value_domain_help', 'is_structure_value_domain', ''),
('Core', 'FunctionManagement', '', 'fb_has_validation', 'button',  NULL , '0', 'class=fb_has_validation', '', 'has_validation_help', 'has_validation', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureField' AND `tablename`='structure_fields' AND `field`='flag_confidential' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=pasteDisabled' AND `default`='' AND `language_help`='flag_confidential_help' AND `language_label`='flag_confidential' AND `language_tag`=''), '1', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureField' AND `tablename`='structure_fields' AND `field`='language_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=pasteDisabled' AND `default`='' AND `language_help`='language_label_help' AND `language_label`='language_label' AND `language_tag`='' AND `setting`='class=pasteDisabled'), '1', '10', 'general information', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '1'),
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureField' AND `tablename`='structure_fields' AND `field`='language_help' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '30', '', '0', '1', 'language_help', '1', '', '0', '', '1', 'textarea', '1', 'class=pasteDisabled', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureField' AND `tablename`='structure_fields' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='form_builder_type_list')  AND `flag_confidential`='0' AND `setting`='class=fb_type_select,class=pasteDisabled' AND `default`='' AND `language_help`='' AND `language_label`='field type' AND `language_tag`=''), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='flag_add' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='flag_add_help' AND `language_label`='flag_add' AND `language_tag`=''), '1', '50', 'forms type', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='flag_edit' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='flag_edit_help' AND `language_label`='flag_edit' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='flag_search' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='flag_search_help' AND `language_label`='flag_search' AND `language_tag`=''), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='flag_index' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='flag_index_help' AND `language_label`='flag_index' AND `language_tag`=''), '1', '80', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='flag_detail' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='flag_detail_help' AND `language_label`='flag_detail' AND `language_tag`=''), '1', '90', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='display_column' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=pasteDisabled' AND `default`='1' AND `language_help`='display_column_help' AND `language_label`='display_column' AND `language_tag`=''), '1', '110', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='display_order' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=pasteDisabled' AND `default`='1' AND `language_help`='display_order_help' AND `language_label`='display_order' AND `language_tag`=''), '1', '120', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='StructureFormat' AND `tablename`='structure_formats' AND `field`='language_heading' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=pasteDisabled' AND `default`='' AND `language_help`='language_heading_help' AND `language_label`='language_heading' AND `language_tag`=''), '1', '100', 'layout format', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '1', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='is_structure_value_domain' AND `type`='button' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=fb_is_structure_value_domain_input' AND `default`='' AND `language_help`='is_structure_value_domain_help' AND `language_label`='is_structure_value_domain' AND `language_tag`=''), '1', '45', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='form_builder_structure'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='fb_has_validation' AND `type`='button' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=fb_has_validation' AND `default`='' AND `language_help`='has_validation_help' AND `language_label`='has_validation' AND `language_tag`=''), '1', '130', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0');


-- -------------------------------------------------------------------------------------
--	Validation rules
-- -------------------------------------------------------------------------------------

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='StructureField' AND `tablename`='structure_fields' AND `field`='language_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=pasteDisabled'),'notBlank', 'field label is required');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='StructureField' AND `tablename`='structure_fields' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='form_builder_type_list') AND `flag_confidential`='0'),'notBlank', 'field type is required');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='is_structure_value_domain' AND `type`='button' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'),'notBlank', 'value/domain is required');



-- -------------------------------------------------------------------------------------
--	Form Builder Validation alias
-- -------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('form_builder_validation');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Core', 'FunctionManagement', '', 'is_unique', 'checkbox',  NULL , '0', '', '', 'is_unique_help', 'is_unique', ''), 
('Core', 'FunctionManagement', '', 'not_blank', 'checkbox',  NULL , '0', '', '', 'not_blank_help', 'not_blank', ''), 
('Core', 'FunctionManagement', '', 'range_from', 'integer_positive',  NULL , '0', '', '', '', 'range_from', ''), 
('Core', 'FunctionManagement', '', 'range_to', 'integer_positive',  NULL , '0', '', '', 'range_help', '', 'range_to'), 
('Core', 'FunctionManagement', '', 'between_from', 'integer_positive',  NULL , '0', '', '', '', 'between_from', ''), 
('Core', 'FunctionManagement', '', 'between_to', 'integer_positive',  NULL , '0', '', '', 'between_help', '', 'between_to')
-- ,('Core', 'FunctionManagement', '', 'alpha_numeric', 'checkbox',  NULL , '0', '', '', 'alpha_numeric_help', 'alpha_numeric', '')
;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='form_builder_validation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='is_unique' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='is_unique_help' AND `language_label`='is_unique' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_validation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='not_blank' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='not_blank_help' AND `language_label`='not_blank' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_validation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='range_from' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='range_from' AND `language_tag`=''), '1', '3', 'range_heading', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_validation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='range_to' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='range_help' AND `language_label`='' AND `language_tag`='range_to'), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_validation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='between_from' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='between_from' AND `language_tag`=''), '1', '5', 'between_heading', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_validation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='between_to' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='between_help' AND `language_label`='' AND `language_tag`='between_to'), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')
-- ,((SELECT id FROM structures WHERE alias='form_builder_validation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='alpha_numeric' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='alpha_numeric_help' AND `language_label`='alpha_numeric' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')
;

INSERT IGNORE INTO 
    i18n (id,en,fr)
VALUES 	
    ('is_unique', "Unique Value", "Unique valeur"),
--    ('is_unique_help', "", ""),
    ('not_blank', "Required field", "Champs requis"),
--    ('not_blank_help', "", ""),
--    ('range_heading', "", ""),
    ('range_from', "From", "De"),
    ('range_to', "To", "À"),
--    ('range_help', "", ""),
--    ('between_heading', "", ""),
    ('between_from', "From", "De"),
    ('between_to', "To", "À"),
--    ('between_help', "", ""),
    ('alpha_numeric', "Numeric / Alphabetic", "Numérique / Alphabétique"),
    ('alpha_numeric_help', "Should contains the Numeric and the Alphabetic combination", "Devrait contenir la combinaison Numérique et Alphabétique"),
    ('validation rules', "", "");

INSERT IGNORE INTO 
    i18n (id,en,fr)
VALUES 	
	('flag_confidential_help', '', ''),
	('general information', 'Field', 'Champ'),
	('language_label_help', '', ''),
	('language_field_type_help', '', ''), 
	('flag_add_help', '', ''),
	('forms type', '', ''), 
	('flag_edit_help', '', ''),
	('flag_search_help', '', ''),
	('flag_index_help', '', ''),
	('flag_detail_help', '', ''),
	('display_column_help', '', ''),
	('display_order_help', '', ''),
	('language_heading_help', '', ''),
	('layout format', '', ''),
	('editable fields', '', ''),
	('not editable fields', '', ''),
	('has_validation_help', '', ''),
	('has_validation', '', ''),
	('is_structure_value_domain_help', '', ''),
	('is_structure_value_domain', '', ''),
	('field type [%s] is unknown', 'Field type [%s] is unknown.', 'Champ de type [%s] est inconnu.'),
	('click to add the validation rules', 'Click to add the validation rules.', 'Cliquez pour ajouter les règles de validation.'),
	('field label is required', '', ''),
	('field type is required', '', ''),
	('value/domain is required', '', ''),
	('length from %s to %s', '', ''),
	('value from %s to %s', '', ''),
	('required', '', ''),
	('unique', '', ''),
	('there is no validation rule for %s datatype', 'There is no validation rule for %s data type.', "Il n'y a pas de règle de validation pour le type de données%s."),
	('list name', '', ''),
 	('please select the list items', 'Please select the list items.', 'Veuillez sélectionner les éléments de la liste.'),
	('list_name_help', '', '');
-- 	('', '', ''),
-- 	('', '', ''),
-- 	('', '', '');


-- -------------------------------------------------------------------------------------
--	Form Builder Value Domain alias
-- -------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('form_builder_value_domain');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'StructureValueDomain', 'structure_value_domains', 'domain_name', 'autocomplete',  NULL , '0', 'url=/Administrate/FormBuilders/AutocompleteDropDownList,class=form-builder-autocomplete', '', 'list_name_help', 'list name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='form_builder_value_domain'), (SELECT id FROM structure_fields WHERE `model`='StructureValueDomain' AND `tablename`='structure_value_domains' AND `field`='domain_name' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Administrate/FormBuilders/AutocompleteDropDownList,class=form-builder-autocomplete' AND `default`='' AND `language_help`='list_name_help' AND `language_label`='list name' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0');


INSERT IGNORE INTO 
    i18n (id,en,fr)
VALUES 	
    ('value domain list', '', '');
--     ('', '', '');

--     ('', '', ''),

-- -------------------------------------------------------------------------------------
--	Add a column to Consent_controlls 
-- -------------------------------------------------------------------------------------

ALTER TABLE `consent_controls`
ADD `is_test_mode` tinyint(1) NOT NULL DEFAULT '0';



-- -------------------------------------------------------------------------------------
--	Version 
-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.2', NOW(),'XXXX','n/a');


UPDATE versions SET trunk_build_number = 'YYYY' WHERE version_number = '2.7.1';
