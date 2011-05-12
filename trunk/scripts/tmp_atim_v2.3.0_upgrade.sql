-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.0 alpha', NOW(), '> 2840');

ALTER TABLE structure_permissible_values_customs
 ADD COLUMN display_order TINYINT UNSIGNED DEFAULT 0 AFTER fr;
ALTER TABLE structure_permissible_values_customs_revs
 ADD COLUMN display_order TINYINT UNSIGNED DEFAULT 0 AFTER fr;
 
REPLACE INTO i18n (id, en, fr) VALUES
("you cannot configure an empty list", "You cannot configure an empty list", "Vous ne pouvez pas configurer une liste vide"),
("alphabetical ordering", "Alphabetical ordering", "Ordonnancement alphabétique"),
("dropdown_config_desc", 
 "To have the list ordered alphabetically with the displayed values, check the \"Alphabetcical ordering\" option. Otherwise, uncheck it and use the cursor to drag the lines in the order you want the options to be displayed.",
 "Pour que la liste soit ordinnée alphabétiquement par les valeurs affichées, cochez l'option \"Ordonnancement alphabétique\". Sinon, décochez la et utilisez le curseur pour déplacer les lignes dans l'ordre d'affichage que vous voulez."),
("configure", "Configure", "Configurer"),
("server_client_time_discrepency", 
 "There is a time discrapency between the server and your computer. Verify that your computer time and date are accurate. It they are, contact the administrator.",
 "Il y a un écart entre l'heure et la date de votre serveur et de votre ordinateur. Vérifiez que votre heure et votre date sont correctement définis. S'ils le sont, contactez l'administrateur."),
("initiate browsing", "Initiate browsing", "Initier la navigation"),
("from batchset", "From batchset", "À partir d'un lot de données"),
('credits_title', 'Credits', 'Auteurs'),
('online wiki', 'Online Wiki', "Wiki en ligne (en anglais)"),
('core_customize', 'Customize', 'Personnaliser'),
("passwords minimal length", 
 "Passwords must have a minimal length of 6 characters", 
 "Les mots de passe doivent avoir une longueur minimale de 6 caractères"),
("permissible_values_custom_use_as_input",
 "If checked, the value can be used as input. If not, the value can only be used for search and data look ups.",
 "Si sélectionné, la valeur peut être utilisée comme entrée. Sinon, la valeur peut seulement être utilisée pour les recherches et pour le pairage des données."),
("defined", "Defined", "Défini"),
("previously defined", "Previously defined", "Défini précédemment");

DROP TABLE datamart_batch_processes;

-- Updating some ATiM core fields from checkbox to yes_no type
UPDATE structure_fields SET type='yes_no' WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='is_problematic';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Inventorymanagement' AND model='AliquotReviewMaster' AND field='basis_of_specimen_review';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND field='path_tnm_descriptor_m';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND field='path_tnm_descriptor_r';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND field='path_tnm_descriptor_y';

ALTER TABLE sample_masters
 MODIFY is_problematic CHAR(1) DEFAULT '';
UPDATE sample_masters SET is_problematic='' WHERE is_problematic='0';
UPDATE sample_masters SET is_problematic='y' WHERE is_problematic='1';
ALTER TABLE sample_masters_revs
 MODIFY is_problematic CHAR(1) DEFAULT '';
UPDATE sample_masters_revs SET is_problematic='' WHERE is_problematic='0';
UPDATE sample_masters_revs SET is_problematic='y' WHERE is_problematic='1';

ALTER TABLE aliquot_review_masters
 MODIFY basis_of_specimen_review CHAR(1) DEFAULT '';
UPDATE aliquot_review_masters SET basis_of_specimen_review='' WHERE basis_of_specimen_review='0';  
UPDATE aliquot_review_masters SET basis_of_specimen_review='y' WHERE basis_of_specimen_review='1';  
ALTER TABLE aliquot_review_masters_revs
 MODIFY basis_of_specimen_review CHAR(1) DEFAULT '';
UPDATE aliquot_review_masters_revs SET basis_of_specimen_review='' WHERE basis_of_specimen_review='0';  
UPDATE aliquot_review_masters_revs SET basis_of_specimen_review='y' WHERE basis_of_specimen_review='1';

ALTER TABLE diagnosis_masters
 MODIFY path_tnm_descriptor_m CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_r CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_y CHAR(1) DEFAULT '';
UPDATE diagnosis_masters SET path_tnm_descriptor_m='' WHERE path_tnm_descriptor_m='0';
UPDATE diagnosis_masters SET path_tnm_descriptor_m='y' WHERE path_tnm_descriptor_m='1';
UPDATE diagnosis_masters SET path_tnm_descriptor_r='' WHERE path_tnm_descriptor_r='0';
UPDATE diagnosis_masters SET path_tnm_descriptor_r='y' WHERE path_tnm_descriptor_r='1';
UPDATE diagnosis_masters SET path_tnm_descriptor_y='' WHERE path_tnm_descriptor_y='0';
UPDATE diagnosis_masters SET path_tnm_descriptor_y='y' WHERE path_tnm_descriptor_y='1';
ALTER TABLE diagnosis_masters_revs
 MODIFY path_tnm_descriptor_m CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_r CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_y CHAR(1) DEFAULT '';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_m='' WHERE path_tnm_descriptor_m='0';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_m='y' WHERE path_tnm_descriptor_m='1';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_r='' WHERE path_tnm_descriptor_r='0';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_r='y' WHERE path_tnm_descriptor_r='1';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_y='' WHERE path_tnm_descriptor_y='0';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_y='y' WHERE path_tnm_descriptor_y='1';

-- password minimal length
INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE model='User' AND field='password'), 'minLength,6', '', 'password must have a minimal length of 6 characters'),
((SELECT id FROM structure_fields WHERE model='User' AND field='password'), 'notEmpty', '', 'password is required');

-- custom values display modes
ALTER TABLE structure_permissible_values_customs
 ADD COLUMN use_as_input BOOLEAN NOT NULL DEFAULT TRUE AFTER display_order;
ALTER TABLE structure_permissible_values_customs_revs
 ADD COLUMN use_as_input BOOLEAN NOT NULL DEFAULT TRUE AFTER display_order;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'StructurePermissibleValuesCustom', 'structure_permissible_values_customs', 'use_as_input', 'checkbox',  NULL , '0', '', '', 'permissible_values_custom_use_as_input', 'use as input', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdown_values'), (SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='use_as_input' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='permissible_values_custom_use_as_input' AND `language_label`='use as input' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='administrate_dropdown_values') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='administrate_dropdown_values') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='en' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='administrate_dropdown_values') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='fr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE structure_value_domains_permissible_values
 ADD COLUMN use_as_input BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE misc_identifiers
 DROP COLUMN identifier_name,
 DROP COLUMN identifier_abrv;
ALTER TABLE misc_identifiers_revs
 DROP COLUMN identifier_name,
 DROP COLUMN identifier_abrv;