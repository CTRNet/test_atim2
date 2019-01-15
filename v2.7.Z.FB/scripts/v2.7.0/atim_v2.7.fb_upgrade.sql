-- -------------------------------------------------------------------------------------
-- ATiM Database Upgrade Script
-- Version: 2.7.fb
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

--    ('', "", "");
-- -------------------------------------------------------------------------------------
--	The warning for Memory allocation
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
  `flag_active` tinyint(1) NOT NULL DEFAULT '1'
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
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='controls_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='consent type' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='databrowser_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='databrowser label help' AND `language_label`='databrowser label' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='flag_active' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_flag_active' AND `language_label`='flag active' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE `alias`='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='consent_controls' AND `field`='display_order' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='display order' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='i18n' AND `field`='databrowser_label_en' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=english-label' AND `default`='' AND `language_help`='data browser label english' AND `language_label`='english label' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='form_builder_consent'), (SELECT id FROM structure_fields WHERE `model`='ConsentControl' AND `tablename`='i18n' AND `field`='databrowser_label_fr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='class=french-label' AND `default`='' AND `language_help`='data browser label french' AND `language_label`='french label' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_validations (`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT id FROM structure_fields WHERE `tablename`='consent_controls' AND `field`='controls_type'), 'notBlank', 'consent type is required'),
((SELECT id FROM structure_fields WHERE `tablename`='consent_controls' AND `field`='controls_type'), 'isUnique', 'consent type should be unique');




-- -------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES
('2.7.2', NOW(),'XXXX','n/a');


UPDATE versions SET trunk_build_number = 'YYYY' WHERE version_number = '2.7.1';
