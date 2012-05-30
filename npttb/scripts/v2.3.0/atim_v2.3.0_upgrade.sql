-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.0', NOW(), '3248');

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
("previously defined", "Previously defined", "Défini précédemment"),
("the storage [%s] already contained something at position [%s, %s]", 
 "The storage [%s] already contained something at position [%s, %s]",
 "L'entreposage [%s] contenait déjà quelque chose à la position [%s, %s]"),
("hour_sign", "h", "h"),
("paste on all lines of all sections", "Paste on all lines of all sections", "Coller sur toutes les lignes de toutes les sections"),
("the linked consent status is [%s]", "The linked consent status is [%s]", "Le statut du consentement lié est [%s]"),
("no consent is linked to the current participant collection", 
 "No consent is linked to the current participant collection",
 "Aucun consentement n'est lié à la présente collection de participant"),
("default study", "Default study", "Étude par défaut"),
("help default study", 
 "Study that is selected by default when adding order lines.",
 "Étude qui est sélectionnée par défaut lorsque des lignes de commandes sont ajoutées."),
("permissions have been regenerated", "Permissions have been regenerated", "Les permissions ont été regénérées"),
("aliquot used", "Aliquot used", "Aliquot utilisé"),
("no aliquot has been defined as sample tested aliquot",
 "No aliquot has been defined as sample tested aliquot",
 "Aucun aliquot de l'échantillon n'a été défini comme testé"),
("aliquots without volume", "Aliquots without volume", "Aliquots sans volume"),
("aliquots with volume", "Aliquots with volume", "Aliquots avec volume"),
("create quality control", "Create quality control", "Créer un contrôle de qualité"),
("this aliquot has no recorded volume", "This aliquot has no recorded volume", "Cet aliquot n'a aucun volume enregistré"), 
("the inputed volume was automatically removed", "The inputed volume was automatically removed", "La valeur de volume entrée a été automatiquement retirée"),
("quality control creation process", "Quality control creation process", "Processus de création de contrôle de qualité"),
("used aliquot", "Used aliquot", "Aliquot utilisé"),
("aliquot(s) without a proper consent",
 "Aliquot(s) without a proper consent",
 "Aliquot(s) sans consentement approprié"),
("this list contains aliquot(s) without a proper consent",
 "This list contains aliquot(s) without a proper consent",
 "Cette liste contient un ou des aliquots sans consentement approprié"),
("create internal uses", "Create internal uses", "Créer des utilisations internes"),
("next", "Next", "Suivant"),
("use as input", "Use as input", "Utiliser comme entrée"),
("you cannot realiquot those elements",
 "You cannot realiquot those elements",
 "Vous ne pouvez pas réaliquoter ces éléments"),
("add lab book", "Add lab book", "Ajouter un cahier de laboratoire"),
("health insurance card", "Health insurance card", "Cate d'assurance maladie"),
("no period has been defined", "No period has been defined", "Aucune période n'a été définie"),
("aliquot barcode", "Aliquot barcode", "Code à barres de l'aliquot"),
("you have set more than one element in storage [%s] at position [%s, %s]",
 "You have set more than one element in storage [%s] at position [%s, %s]",
 "Vous avez défini plus d'un élément dans l'entreposage [%s] à la position [%s, %s]"),
("aliquot used volume", "Aliquot used volume", "Volume utilisé de l'aliquot");

UPDATE i18n SET fr='Code à barres' WHERE id='barcode';
UPDATE i18n SET fr='Le code à barres est requis' WHERE id='barcode is required';
UPDATE i18n SET fr='Le code à barres est requis et doit exister!' WHERE id='barcode is required and should exist';
UPDATE i18n SET fr='Le code à barres doit être unique!' WHERE id='barcode must be unique';
UPDATE i18n SET fr='La taille du code à barres est limitée!' WHERE id='barcode size is limited';
UPDATE i18n SET fr='Veuillez contrôler les code à barres suivants:' WHERE id='please check following barcodes';
UPDATE i18n SET fr="L'aliquot avec le code à barres [%s] a atteint un volume inférieur à 0." WHERE id='the aliquot with barcode [%s] has reached a volume bellow 0';
UPDATE i18n SET fr='Le code à barres [%s] a déjà été enregistré!' WHERE id='the barcode [%s] has already been recorded';
UPDATE i18n SET fr='Vous ne pouvez enregistrer le code à barres [%s] deux fois!' WHERE id='you can not record barcode [%s] twice';

DELETE FROM i18n WHERE id='no perido has been defined';


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
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'MiscIdentifierControl', 'misc_identifier_controls', 'misc_identifier_name', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') , '0', '', '', '', 'name', ''), 
('Clinicalannotation', 'MiscIdentifierControl', 'misc_identifier_controls', 'misc_identifier_name_abbrev', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') , '0', '', '', '', 'identifier abrv', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name_abbrev' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'MiscIdentifierControl', 'misc_identifiers_controls', 'misc_identifier_name_abbrev', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') , '0', '', '', '', 'identifier abrv', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifiers_controls' AND `field`='misc_identifier_name_abbrev' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `flag_confidential`='0');

ALTER TABLE storage_controls 
 ADD COLUMN check_conficts TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '0=no, 1=warn, anything else=error';
 
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='users') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='password' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='users') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`=' ' AND `field`='field1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE event_masters
 DROP COLUMN disease_site,
 DROP COLUMN event_group,
 DROP COLUMN event_type;
ALTER TABLE event_masters_revs
 DROP COLUMN disease_site,
 DROP COLUMN event_group,
 DROP COLUMN event_type;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventControl', 'event_masters', 'disease_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') , '0', '', '', '', 'event_form_type', ''), 
('Clinicalannotation', 'EventControl', 'event_masters', 'event_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') , '0', '', '', '', '', '-');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');

UPDATE datamart_structures SET index_link='/clinicalannotation/event_masters/detail/%%EventControl.event_group%%/%%EventMaster.participant_id%%/%%EventMaster.id%%/' WHERE id=14;

ALTER TABLE banks
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
ALTER TABLE banks_revs
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
 
ALTER TABLE datamart_browsing_results MODIFY parent_node_id INT UNSIGNED DEFAULT NULL;
ALTER TABLE datamart_browsing_results_revs MODIFY parent_node_id INT UNSIGNED DEFAULT NULL;

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field LIKE '%_accuracy%' AND structure_value_domain != (SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy'));
DELETE FROM structure_fields WHERE field LIKE '%_accuracy%' AND structure_value_domain != (SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy');

UPDATE structure_fields SET  `setting`='accuracy' WHERE model='Participant' AND tablename='participants' AND field='date_of_death' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='accuracy' WHERE model='Participant' AND tablename='participants' AND field='date_of_birth' AND `type`='date' AND structure_value_domain  IS NULL ;

ALTER TABLE participants
 CHANGE dod_date_accuracy date_of_death_accuracy CHAR(1) NOT NULL DEFAULT '',
 CHANGE dob_date_accuracy date_of_birth_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
 CHANGE dod_date_accuracy date_of_death_accuracy CHAR(1) NOT NULL DEFAULT '',
 CHANGE dob_date_accuracy date_of_birth_accuracy CHAR(1) NOT NULL DEFAULT '';
 
-- -----------------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tmp_aliquot_controls` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	
	`sample_control_id` int(11) DEFAULT NULL,  
	`old_aliquot_control_id` int(11) DEFAULT NULL,   
	`old_sample_to_aliquot_control_id` int(11) DEFAULT NULL,   
	`flag_active` tinyint(1) NOT NULL DEFAULT '1', 
  	
	`aliquot_type` enum('block','cell gel matrix','core','slide','tube','whatman paper') NOT NULL COMMENT 'Generic name.',
	`aliquot_type_precision` varchar(30) DEFAULT NULL COMMENT 'Use to differentiate two aliquot controls having the same aliquot_type in case they can be used for the same sample type. (Ex: tissue tube (5ml) and tissue tube (cryogenic)).',
	`form_alias` varchar(255) NOT NULL,
	`detail_tablename` varchar(255) NOT NULL,
	`volume_unit` varchar(20) DEFAULT NULL,
	`comment` varchar(255) DEFAULT NULL,
	`display_order` int(11) NOT NULL DEFAULT '0',
	`databrowser_label` varchar(50) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO tmp_aliquot_controls (sample_control_id,old_aliquot_control_id,old_sample_to_aliquot_control_id,flag_active,
aliquot_type,aliquot_type_precision,form_alias,detail_tablename,volume_unit,comment,display_order,databrowser_label)
(SELECT s2ac.sample_control_id, ac.id, s2ac.id, s2ac.flag_active, 
ac.aliquot_type, ac.aliquot_type_precision, ac.form_alias, ac.detail_tablename, ac.volume_unit, ac.comment, ac.display_order, ac.databrowser_label
FROM sample_to_aliquot_controls AS s2ac 
INNER JOIN aliquot_controls AS ac ON s2ac.aliquot_control_id = ac.id);

CREATE TABLE IF NOT EXISTS `tmp_realiquoting_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_aliquot_control_id` int(11) DEFAULT NULL,
  `child_aliquot_control_id` int(11) DEFAULT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `lab_book_control_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1  AUTO_INCREMENT=1 ;

INSERT INTO tmp_realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active, lab_book_control_id)
(SELECT parent.id, child.id, rc.flag_active, rc.lab_book_control_id
FROM tmp_aliquot_controls AS parent
INNER JOIN realiquoting_controls AS rc ON parent.old_sample_to_aliquot_control_id = rc.parent_sample_to_aliquot_control_id
INNER JOIN tmp_aliquot_controls AS child ON child.old_sample_to_aliquot_control_id = rc.child_sample_to_aliquot_control_id);

ALTER TABLE aliquot_masters DROP FOREIGN KEY FK_aliquot_masters_aliquot_controls;

UPDATE tmp_aliquot_controls tmp, sample_masters samp, aliquot_masters al
SET al.aliquot_control_id = tmp.id
WHERE al.sample_master_id = samp.id 
AND tmp.sample_control_id = samp.sample_control_id
AND tmp.old_aliquot_control_id = al.aliquot_control_id;

UPDATE aliquot_masters a, aliquot_masters_revs ar
SET ar.aliquot_control_id = a.aliquot_control_id
WHERE a.id = ar.id;

UPDATE tmp_aliquot_controls tmp, order_lines ol
SET ol.aliquot_control_id = tmp.id
WHERE tmp.sample_control_id = ol.sample_control_id
AND tmp.old_aliquot_control_id = ol.aliquot_control_id;

UPDATE order_lines o, order_lines_revs ors
SET ors.aliquot_control_id = o.aliquot_control_id
WHERE o.id = ors.id;

DROP TABLE realiquoting_controls;
DROP TABLE sample_to_aliquot_controls;
DROP TABLE aliquot_controls;

CREATE TABLE IF NOT EXISTS `aliquot_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_control_id` int(11) DEFAULT NULL, 
  `aliquot_type` enum('block','cell gel matrix','core','slide','tube','whatman paper') NOT NULL COMMENT 'Generic name.',
  `aliquot_type_precision` varchar(30) DEFAULT NULL COMMENT 'Use to differentiate two aliquot controls having the same aliquot_type in case they can be used for the same sample type. (Ex: tissue tube (5ml) and tissue tube (cryogenic)).',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `volume_unit` varchar(20) DEFAULT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `comment` varchar(255) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO aliquot_controls (id, sample_control_id,aliquot_type,aliquot_type_precision,form_alias,detail_tablename,volume_unit,flag_active,comment,display_order,databrowser_label)
(SELECT id, sample_control_id,aliquot_type,aliquot_type_precision,form_alias,detail_tablename,volume_unit,flag_active,comment,display_order,databrowser_label FROM tmp_aliquot_controls);

ALTER TABLE `aliquot_controls`
  ADD CONSTRAINT `FK_aliquot_controls_sample_controls` FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`);

CREATE TABLE IF NOT EXISTS `realiquoting_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_aliquot_control_id` int(11) DEFAULT NULL,
  `child_aliquot_control_id` int(11) DEFAULT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `lab_book_control_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO realiquoting_controls (id, parent_aliquot_control_id, child_aliquot_control_id, flag_active, lab_book_control_id)
(SELECT id, parent_aliquot_control_id, child_aliquot_control_id, flag_active, lab_book_control_id FROM tmp_realiquoting_controls);

ALTER TABLE `realiquoting_controls`
  ADD CONSTRAINT `FK_realiquoting_controls_parent_aliquot_controls` FOREIGN KEY (`parent_aliquot_control_id`) REFERENCES `aliquot_controls` (`id`),
  ADD CONSTRAINT `FK_realiquoting_controls_child_aliquot_controls` FOREIGN KEY (`child_aliquot_control_id`) REFERENCES `aliquot_controls` (`id`);

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT `FK_aliquot_masters_aliquot_controls` FOREIGN KEY (`aliquot_control_id`) REFERENCES `aliquot_controls` (`id`);

ALTER TABLE `order_lines`
  ADD CONSTRAINT `FK_order_lines_aliquot_controls` FOREIGN KEY (`aliquot_control_id`) REFERENCES `aliquot_controls` (`id`);

DROP TABLE tmp_realiquoting_controls;
DROP TABLE tmp_aliquot_controls;

UPDATE structure_value_domains SET `source` = 'Inventorymanagement.AliquotControl::getSampleAliquotTypesPermissibleValues'
WHERE source = 'Inventorymanagement.SampleToAliquotControl::getSampleAliquotTypesPermissibleValues';

UPDATE aliquot_controls
SET aliquot_type_precision = REPLACE(aliquot_type_precision,'derivative tube ','');
UPDATE aliquot_controls
SET aliquot_type_precision = REPLACE(aliquot_type_precision,'specimen tube ','');
UPDATE aliquot_controls
SET aliquot_type_precision = ''
WHERE aliquot_type_precision IN ('specimen tube','cells','tissue');

INSERT INTO i18n (id,en,fr) VALUES ('(ml)','(ml)','(ml)'),('(ul + conc)','(Ul + Conc)','(Ul + Conc)');

SET @structure_id = (SELECT id FROM structures WHERE alias='aliquot_masters');
SET @structure_field_id = (SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'created');
SET @max_display_order = (SELECT MAX(display_order) FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_%') AND structure_field_id = @structure_field_id);
INSERT INTO structure_formats (structure_id, structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, `type`, flag_override_setting, setting, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary)
(SELECT DISTINCT @structure_id, @structure_field_id, `display_column`, @max_display_order, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`
FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_%') AND structure_field_id = @structure_field_id);
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_%') AND structure_field_id = @structure_field_id;

DELETE FROM structure_formats WHERE structure_id IN(SELECT id FROM structures WHERE alias IN('sd_spe_ascites', 'sd_spe_bloods', 'sd_spe_tissues', 'sd_spe_urines', 'sd_spe_peritoneal_washes', 'sd_spe_cystic_fluids', 'sd_spe_pericardial_fluids', 'sd_spe_pleural_fluids'))
AND (structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SpecimenDetail' AND field='reception_by' AND tablename='')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SpecimenDetail' AND field='reception_datetime' AND tablename='')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='Generated' AND field='coll_to_rec_spent_time_msg' AND tablename='')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sample_code' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sample_type' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='notes' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sample_category' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='is_problematic' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sop_master_id' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SpecimenDetail' AND field='supplier_dept' AND tablename=''));

DELETE FROM structure_formats WHERE structure_id IN(SELECT id FROM structures WHERE alias IN('sd_undetailed_derivatives', 'sd_der_plasmas', 'sd_der_serums', 'sd_der_cell_cultures'))
AND (structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sample_code' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sample_type' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='notes' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sample_category' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='is_problematic' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='sop_master_id' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='parent_id' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='DerivativeDetail' AND field='creation_site' AND tablename='')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='DerivativeDetail' AND field='creation_by' AND tablename='')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='DerivativeDetail' AND field='creation_datetime' AND tablename='')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='Generated' AND field='coll_to_creation_spent_time_msg' AND tablename='')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='initial_specimen_sample_type' AND tablename='sample_masters')
OR structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='parent_sample_type' AND tablename=''));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category')  AND `flag_confidential`='0'), '0', '300', '', '1', 'category', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '200', '', '1', 'sample code', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '500', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '600', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sop' AND `language_tag`=''), '0', '400', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `flag_confidential`='0');


INSERT INTO structures(`alias`) VALUES ('specimens');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenDetail', 'specimen_details', 'supplier_dept', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') , '0', '', '', '', 'supplier dept', ''), 
('Inventorymanagement', 'SpecimenDetail', 'specimen_details', 'reception_by', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'reception by', ''), 
('Inventorymanagement', 'SpecimenDetail', 'specimen_details', 'reception_datetime', 'datetime',  NULL , '0', '', '', 'custom_laboratory_staff', 'reception date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='supplier dept' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception by' AND `language_tag`=''), '1', '200', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='custom_laboratory_staff' AND `language_label`='reception date' AND `language_tag`=''), '1', '300', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '400', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE sample_controls SET form_alias=CONCAT(form_alias, ',specimens') WHERE sample_category='specimen';
UPDATE structure_formats SET display_order=(display_order + 400) WHERE structure_id IN(SELECT id FROM structures WHERE alias IN('sd_spe_ascites', 'sd_spe_bloods', 'sd_spe_tissues', 'sd_spe_urines', 'sd_spe_peritoneal_washes', 'sd_spe_cystic_fluids', 'sd_spe_pericardial_fluids', 'sd_spe_pleural_fluids'));

INSERT INTO structures(`alias`) VALUES ('derivatives');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleMaster', 'sample_masters', 'parent_sample_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sample_type') , '0', '', '', 'generated_parent_sample_sample_type_help', 'parent sample type', ''), 
('Inventorymanagement', 'DerivativeDetail', 'derivative_details', 'creation_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') , '0', '', '', '', 'creation site', ''), 
('Inventorymanagement', 'DerivativeDetail', 'derivative_details', 'creation_datetime', 'datetime',  NULL , '0', 'accuracy', '', '', 'creation date', ''), 
('Inventorymanagement', 'DerivativeDetail', 'derivative_details', 'creation_by', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'created by', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_sample_parent_id_defintion' AND `language_label`='parent sample code' AND `language_tag`=''), '0', '350', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='initial specimen type' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='generated_parent_sample_sample_type_help' AND `language_label`='parent sample type' AND `language_tag`=''), '0', '350', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation site' AND `language_tag`=''), '1', '300', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='accuracy' AND `default`='' AND `language_help`='' AND `language_label`='creation date' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by' AND `language_tag`=''), '1', '200', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '400', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE sample_controls SET form_alias=CONCAT(form_alias, ',derivatives') WHERE sample_category='derivative';

-- Add aliquot_label

ALTER TABLE aliquot_masters
 ADD COLUMN aliquot_label VARCHAR(60) NOT NULL DEFAULT '' AFTER barcode;
ALTER TABLE aliquot_masters_revs
 ADD COLUMN aliquot_label VARCHAR(60) NOT NULL DEFAULT '' AFTER barcode;

INSERT INTO structure_fields(plugin, model, tablename, field, language_label, language_tag, `type`, `setting`, `default`, structure_value_domain, language_help) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_label', 'aliquot label', '', 'input', '', '',  NULL , '');
INSERT INTO structure_fields(plugin, model, tablename, field, language_label, language_tag, `type`, `setting`, `default`, structure_value_domain, language_help) VALUES
('Inventorymanagement', 'ViewAliquot', '', 'aliquot_label', 'aliquot label', '', 'input', '', '',  NULL , '');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('aliquot label', 'Label', 'Étiquette');

SET @structure_field_id = (SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'aliquot_label');
INSERT INTO structure_formats(structure_id, structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, `type`, flag_override_setting, `setting`, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary) 
SELECT 
sf.structure_id, @structure_field_id, sf.display_column, (sf.display_order +1), '', sf.flag_override_label, sf.language_label, sf.flag_override_tag, sf.language_tag, sf.flag_override_help, sf.language_help, sf.flag_override_type, sf.type, sf.flag_override_setting, sf.setting, sf.flag_override_default, sf.default, 
sf.flag_add, sf.flag_add_readonly, sf.flag_edit, sf.flag_edit_readonly, sf.flag_search, sf.flag_search_readonly, sf.flag_addgrid, sf.flag_addgrid_readonly, sf.flag_editgrid, sf.flag_editgrid_readonly, sf.flag_batchedit, sf.flag_batchedit_readonly, sf.flag_index, sf.flag_detail, sf.flag_summary
FROM structure_formats AS sf 
INNER JOIN structure_fields AS bc_field ON bc_field.id = sf.structure_field_id 
INNER JOIN structures AS str ON str.id = sf.structure_id
WHERE  bc_field.model = 'AliquotMaster' AND bc_field.field = 'barcode' 
AND str.alias NOT IN ('lab_book_realiquotings_summary');

UPDATE structure_formats sf, structures str, structure_fields sfield
 SET sf.flag_add = '0' 
 WHERE sfield.id = sf.structure_field_id AND str.id = sf.structure_id
 AND str.alias IN ('orderitems') AND sfield.field = 'aliquot_label';

SET @structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewAliquot' AND field = 'aliquot_label');
INSERT INTO structure_formats(structure_id, structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, `type`, flag_override_setting, `setting`, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary) 
(SELECT 
sf.structure_id, @structure_field_id, sf.display_column, (sf.display_order +1), '', sf.flag_override_label, sf.language_label, sf.flag_override_tag, sf.language_tag, sf.flag_override_help, sf.language_help, sf.flag_override_type, sf.type, sf.flag_override_setting, sf.setting, sf.flag_override_default, sf.default, 
sf.flag_add, sf.flag_add_readonly, sf.flag_edit, sf.flag_edit_readonly, sf.flag_search, sf.flag_search_readonly, sf.flag_addgrid, sf.flag_addgrid_readonly, sf.flag_editgrid, sf.flag_editgrid_readonly, sf.flag_batchedit, sf.flag_batchedit_readonly, sf.flag_index, sf.flag_detail, sf.flag_summary
FROM structure_formats AS sf 
INNER JOIN structure_fields AS bc_field ON bc_field.id = sf.structure_field_id 
WHERE  bc_field.model = 'ViewAliquot' AND bc_field.field = 'barcode');

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_label,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

-- Uncomment following line to hidde label

-- UPDATE structure_formats sf, structures str, structure_fields sfield
-- SET flag_add = '0', flag_add_readonly = '0', flag_edit = '0', flag_edit_readonly = '0', flag_search = '0', flag_search_readonly = '0', flag_addgrid = '0', flag_addgrid_readonly = '0', flag_editgrid = '0', flag_editgrid_readonly = '0', flag_batchedit = '0', flag_batchedit_readonly = '0', flag_index = '0', flag_detail = '0', flag_summary= '0'  
-- WHERE sfield.id = sf.structure_field_id AND str.id = sf.structure_id
-- AND sfield.field = 'aliquot_label';

INSERT INTO `external_links` (`id`, `name`, `link`) VALUES
(null, 'inventory_elements_defintions', 'http://www.ctrnet.ca/mediawiki/index.php/ATiM_Inventory_Elements');

INSERT INTO i18n (id,en,fr) VALUES
('more information about the types of samples and aliquots are available %s here',
"Information about the types of samples and aliquots is available <a href='%s' target='blank'>here</a>.",
"L'information sur les types d'échantillons et d'aliquots est disponible <a href='%s' target='blank'>ici</a>.");


ALTER TABLE orders 
 DROP FOREIGN KEY FK_orders_study_summaries,
 CHANGE study_summary_id default_study_summary_id INT DEFAULT NULL,
 ADD FOREIGN KEY (`default_study_summary_id`) REFERENCES `study_summaries` (`id`);
ALTER TABLE orders_revs
 CHANGE study_summary_id default_study_summary_id INT DEFAULT NULL;
 
UPDATE structure_fields SET  `field`='default_study_summary_id',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') ,  `language_help`='help default study',  `language_label`='default study' WHERE model='Order' AND tablename='orders' AND field='study_summary_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list');

ALTER TABLE order_lines
 ADD COLUMN study_summary_id INT DEFAULT NULL AFTER order_id,
 ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
ALTER TABLE order_lines_revs
 ADD COLUMN study_summary_id INT DEFAULT NULL AFTER order_id;
UPDATE order_lines AS ol
INNER JOIN orders AS o ON o.id=ol.order_id
SET ol.study_summary_id=o.default_study_summary_id;

CREATE TABLE tmp_version_id(SELECT MAX(version_id) AS version_id FROM order_lines_revs GROUP BY id);
UPDATE order_lines_revs AS olr
INNER JOIN order_lines AS ol ON olr.id=ol.id
SET olr.study_summary_id=ol.study_summary_id
WHERE version_id IN(SELECT version_id FROM tmp_version_id); 
DROP TABLE tmp_version_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderLine', 'order_lines', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='orderlines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

ALTER TABLE versions ADD COLUMN permissions_regenerated BOOLEAN DEFAULT FALSE AFTER build_number;

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
(1, 'create derivative', '/inventorymanagement/sample_masters/batchDerivativeInit/', 1);

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type='input');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='aliquot_sources' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('sourcealiquots_volume');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sourcealiquots_volume'), (SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='aliquot_sources' AND `field`='used_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='used volume' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='sourcealiquots_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='sourcealiquots_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '10', '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '1');

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SourceAliquot' AND `tablename`='aliquot_sources' AND `field`='used_volume' AND `language_label`='used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `language_label`='current volume' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('qctestedaliquots_volume');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qctestedaliquots_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qctestedaliquots_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '10', '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='qctestedaliquots_volume'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrlTestedAliquot' AND `tablename`='quality_ctrl_tested_aliquots' AND `field`='used_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='used volume' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1');

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `language_label`='current volume' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='QualityCtrlTestedAliquot' AND `tablename`='quality_ctrl_tested_aliquots' AND `field`='used_volume' AND `language_label`='used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

ALTER TABLE quality_ctrls
 ADD COLUMN aliquot_master_id INT DEFAULT NULL AFTER notes,
 ADD COLUMN used_volume DECIMAL(10,5) DEFAULT NULL AFTER aliquot_master_id,
 ADD FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters(id);
ALTER TABLE quality_ctrls_revs
 ADD COLUMN aliquot_master_id INT DEFAULT NULL AFTER notes,
 ADD COLUMN used_volume DECIMAL(10,5) DEFAULT NULL AFTER aliquot_master_id;

-- delete deleted tested aliquots
DELETE FROM quality_ctrl_tested_aliquots WHERE deleted=1;

-- join update qc_controls
UPDATE quality_ctrls AS qc
INNER JOIN quality_ctrl_tested_aliquots AS qcta ON qcta.quality_ctrl_id=qc.id
SET qc.aliquot_master_id=qcta.aliquot_master_id, qc.used_volume=qcta.used_volume, qc.modified=NOW(), qc.modified_by=1;

-- delete already joined qc_tested_aliquots
CREATE TABLE tmp(
SELECT quality_ctrl_tested_aliquots.id FROM quality_ctrl_tested_aliquots
INNER JOIN quality_ctrls ON quality_ctrls.id= quality_ctrl_tested_aliquots.quality_ctrl_id
GROUP BY quality_ctrl_tested_aliquots.quality_ctrl_id);
DELETE FROM quality_ctrl_tested_aliquots WHERE id IN(SELECT id FROM tmp);
DROP TABLE tmp;

-- create tmp table with remaining entries to create
CREATE TABLE tmp(SELECT quality_ctrls.qc_code, quality_ctrls.sample_master_id, quality_ctrls.type, quality_ctrls.qc_type_precision, quality_ctrls.tool, 
quality_ctrls.run_id, quality_ctrls.run_by, quality_ctrls.date, quality_ctrls.score, quality_ctrls.unit, quality_ctrls.conclusion, quality_ctrls.notes, 
quality_ctrl_tested_aliquots.created, quality_ctrl_tested_aliquots.created_by, quality_ctrl_tested_aliquots.modified, quality_ctrl_tested_aliquots.modified_by, quality_ctrl_tested_aliquots.deleted,
quality_ctrl_tested_aliquots.aliquot_master_id, quality_ctrl_tested_aliquots.used_volume FROM quality_ctrl_tested_aliquots INNER JOIN quality_ctrls ON quality_ctrls.id= quality_ctrl_tested_aliquots.quality_ctrl_id);

-- insert remaining entries
INSERT INTO quality_ctrls(qc_code, sample_master_id, type, qc_type_precision, tool, run_id, run_by, date, score, unit, conclusion, notes,
aliquot_master_id, used_volume, created, created_by, modified, modified_by, deleted)
(SELECT NULL, sample_master_id, type, qc_type_precision, tool, run_id, run_by, date, score, unit, conclusion, notes,
aliquot_master_id, used_volume, created, created_by, NOW(), 1, deleted FROM tmp);
DROP TABLE tmp;

-- update qc_code with default formulae
UPDATE quality_ctrls SET qc_code=CONCAT('QC - ', id) WHERE qc_code IS NULL;

-- create revs for modified/new entries
INSERT INTO quality_ctrls_revs(id, qc_code, sample_master_id, type, qc_type_precision, tool, run_id, run_by, date, score, unit, conclusion, notes,
aliquot_master_id, used_volume, created, created_by, modified, modified_by, deleted, version_created)
(SELECT id, qc_code, sample_master_id, type, qc_type_precision, tool, run_id, run_by, date, score, unit, conclusion, notes,
aliquot_master_id, used_volume, created, created_by, modified, modified_by, deleted, modified FROM quality_ctrls WHERE aliquot_master_id IS NOT NULL);


INSERT INTO quality_ctrls_revs(id, qc_code, sample_master_id, type, qc_type_precision, tool, run_id, run_by, date, score, unit, conclusion, notes,
aliquot_master_id, used_volume, created, created_by, modified, modified_by, deleted, version_created)
(SELECT qc1.id, qc1.qc_code, qc1.sample_master_id, qc1.type, qc1.qc_type_precision, qc1.tool, qc1.run_id, qc1.run_by, 
qc1.date, qc1.score, qc1.unit, qc1.conclusion, qc1.notes, 
qcta.aliquot_master_id, qcta.used_volume, qc1.created, qc1.created_by, qcta.modified, qcta.modified_by, qcta.deleted, qcta.modified
FROM quality_ctrl_tested_aliquots_revs AS qcta
LEFT JOIN quality_ctrls_revs AS qc1 ON qcta.quality_ctrl_id=qc1.id AND qcta.modified >= qc1.modified
LEFT JOIN quality_ctrls_revs AS qc2 ON qcta.quality_ctrl_id=qc2.id AND qcta.modified >= qc2.modified AND qc1.modified <	 qc2.modified
WHERE qc2.id IS NULL);

DROP TABLE quality_ctrl_tested_aliquots;
DROP TABLE quality_ctrl_tested_aliquots_revs;

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
(1, 'create quality control', '/inventorymanagement/quality_ctrls/add/', 1),
(5, 'create quality control', '/inventorymanagement/quality_ctrls/add/', 1);

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='tool' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_qc_tool') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='score' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='conclusion' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_type_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '0', '10000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qualityctrls_volume');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'QualityCtrl', 'quality_ctrls', 'used_volume', 'float_positive',  NULL , '0', 'size=5', '', '', 'used volume', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls_volume'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='used_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='used volume' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '1');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_type', 'input',  NULL , '0', '', '', '', 'aliquot type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type='autocomplete'), '0', '30', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `language_heading`='quality control' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `language_heading`='used aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' and type='autocomplete');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('qualityctrls_volume_for_detail');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotControl', 'aliquot_controls', 'volume_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls_volume_for_detail'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls_volume_for_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('aliquotmasters_volume');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotmasters_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '30', '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '25', '', '0', '', '0', '', '0', '', '1', 'float', '1', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE	 ad_bags_revs                                  	SET version_created=modified;
UPDATE	 ad_blocks_revs                                	SET version_created=modified;
UPDATE	 ad_cell_cores_revs                            	SET version_created=modified;
UPDATE	 ad_cell_slides_revs                           	SET version_created=modified;
UPDATE	 ad_gel_matrices_revs                          	SET version_created=modified;
UPDATE	 ad_tissue_cores_revs                          	SET version_created=modified;
UPDATE	 ad_tissue_slides_revs                         	SET version_created=modified;
UPDATE	 ad_tubes_revs                                 	SET version_created=modified;
UPDATE	 ad_whatman_papers_revs                        	SET version_created=modified;
UPDATE	 aliquot_internal_uses_revs                    	SET version_created=modified;
UPDATE	 aliquot_masters_revs                          	SET version_created=modified;
UPDATE	 aliquot_review_masters_revs                   	SET version_created=modified;
UPDATE	 ar_breast_tissue_slides_revs                  	SET version_created=modified;
UPDATE	 banks_revs                                    	SET version_created=modified;
UPDATE	 cd_nationals_revs                             	SET version_created=modified;
UPDATE	 clinical_collection_links_revs                	SET version_created=modified;
UPDATE	 coding_adverse_events_revs                    	SET version_created=modified;
UPDATE	 collections_revs                              	SET version_created=modified;
UPDATE	 consent_masters_revs                          	SET version_created=modified;
UPDATE	 datamart_browsing_indexes_revs                	SET version_created=modified;
UPDATE	 datamart_browsing_results_revs                	SET version_created=modified;
UPDATE	 derivative_details_revs                       	SET version_created=modified;
UPDATE	 diagnosis_masters_revs                        	SET version_created=modified;
UPDATE	 drugs_revs                                    	SET version_created=modified;
UPDATE	 dxd_bloods_revs                               	SET version_created=modified;
UPDATE	 dxd_cap_report_ampullas_revs                  	SET version_created=modified;
UPDATE	 dxd_cap_report_colon_biopsies_revs            	SET version_created=modified;
UPDATE	 dxd_cap_report_colon_rectum_resections_revs   	SET version_created=modified;
UPDATE	 dxd_cap_report_distalexbileducts_revs         	SET version_created=modified;
UPDATE	 dxd_cap_report_gallbladders_revs              	SET version_created=modified;
UPDATE	 dxd_cap_report_hepatocellular_carcinomas_revs 	SET version_created=modified;
UPDATE	 dxd_cap_report_intrahepbileducts_revs         	SET version_created=modified;
UPDATE	 dxd_cap_report_pancreasendos_revs             	SET version_created=modified;
UPDATE	 dxd_cap_report_pancreasexos_revs              	SET version_created=modified;
UPDATE	 dxd_cap_report_perihilarbileducts_revs        	SET version_created=modified;
UPDATE	 dxd_cap_report_smintestines_revs              	SET version_created=modified;
UPDATE	 dxd_tissues_revs                              	SET version_created=modified;
UPDATE	 ed_all_adverse_events_adverse_events_revs     	SET version_created=modified;
UPDATE	 ed_all_clinical_followups_revs                	SET version_created=modified;
UPDATE	 ed_all_clinical_presentations_revs            	SET version_created=modified;
UPDATE	 ed_all_lifestyle_smokings_revs                	SET version_created=modified;
UPDATE	 ed_all_protocol_followups_revs                	SET version_created=modified;
UPDATE	 ed_all_study_researches_revs                  	SET version_created=modified;
UPDATE	 ed_breast_lab_pathologies_revs                	SET version_created=modified;
UPDATE	 ed_breast_screening_mammograms_revs           	SET version_created=modified;
UPDATE	 event_masters_revs                            	SET version_created=modified;
UPDATE	 family_histories_revs                         	SET version_created=modified;
UPDATE	 lab_book_masters_revs                         	SET version_created=modified;
UPDATE	 lbd_dna_extractions_revs                      	SET version_created=modified;
UPDATE	 lbd_slide_creations_revs                      	SET version_created=modified;
UPDATE	 materials_revs                                	SET version_created=modified;
UPDATE	 misc_identifiers_revs                         	SET version_created=modified;
UPDATE	 order_items_revs                              	SET version_created=modified;
UPDATE	 order_lines_revs                              	SET version_created=modified;
UPDATE	 orders_revs                                   	SET version_created=modified;
UPDATE	 participant_contacts_revs                     	SET version_created=modified;
UPDATE	 participant_messages_revs                     	SET version_created=modified;
UPDATE	 participants_revs                             	SET version_created=modified;
UPDATE	 pd_chemos_revs                                	SET version_created=modified;
UPDATE	 pd_surgeries_revs                             	SET version_created=modified;
UPDATE	 pe_chemos_revs                                	SET version_created=modified;
UPDATE	 protocol_masters_revs                         	SET version_created=modified;
UPDATE	 quality_ctrls_revs                            	SET version_created=modified;
UPDATE	 realiquotings_revs                            	SET version_created=modified;
UPDATE	 reproductive_histories_revs                   	SET version_created=modified;
UPDATE	 rtbforms_revs                                 	SET version_created=modified;
UPDATE	 sample_masters_revs                           	SET version_created=modified;
UPDATE	 sd_der_amp_rnas_revs                          	SET version_created=modified;
UPDATE	 sd_der_ascite_cells_revs                      	SET version_created=modified;
UPDATE	 sd_der_ascite_sups_revs                       	SET version_created=modified;
UPDATE	 sd_der_b_cells_revs                           	SET version_created=modified;
UPDATE	 sd_der_blood_cells_revs                       	SET version_created=modified;
UPDATE	 sd_der_cdnas_revs                             	SET version_created=modified;
UPDATE	 sd_der_cell_cultures_revs                     	SET version_created=modified;
UPDATE	 sd_der_cell_lysates_revs                      	SET version_created=modified;
UPDATE	 sd_der_cystic_fl_cells_revs                   	SET version_created=modified;
UPDATE	 sd_der_cystic_fl_sups_revs                    	SET version_created=modified;
UPDATE	 sd_der_dnas_revs                              	SET version_created=modified;
UPDATE	 sd_der_pbmcs_revs                             	SET version_created=modified;
UPDATE	 sd_der_pericardial_fl_cells_revs              	SET version_created=modified;
UPDATE	 sd_der_pericardial_fl_sups_revs               	SET version_created=modified;
UPDATE	 sd_der_plasmas_revs                           	SET version_created=modified;
UPDATE	 sd_der_pleural_fl_cells_revs                  	SET version_created=modified;
UPDATE	 sd_der_pleural_fl_sups_revs                   	SET version_created=modified;
UPDATE	 sd_der_proteins_revs                          	SET version_created=modified;
UPDATE	 sd_der_pw_cells_revs                          	SET version_created=modified;
UPDATE	 sd_der_pw_sups_revs                           	SET version_created=modified;
UPDATE	 sd_der_rnas_revs                              	SET version_created=modified;
UPDATE	 sd_der_serums_revs                            	SET version_created=modified;
UPDATE	 sd_der_tiss_lysates_revs                      	SET version_created=modified;
UPDATE	 sd_der_tiss_susps_revs                        	SET version_created=modified;
UPDATE	 sd_der_urine_cents_revs                       	SET version_created=modified;
UPDATE	 sd_der_urine_cons_revs                        	SET version_created=modified;
UPDATE	 sd_spe_ascites_revs                           	SET version_created=modified;
UPDATE	 sd_spe_bloods_revs                            	SET version_created=modified;
UPDATE	 sd_spe_cystic_fluids_revs                     	SET version_created=modified;
UPDATE	 sd_spe_pericardial_fluids_revs                	SET version_created=modified;
UPDATE	 sd_spe_peritoneal_washes_revs                 	SET version_created=modified;
UPDATE	 sd_spe_pleural_fluids_revs                    	SET version_created=modified;
UPDATE	 sd_spe_tissues_revs                           	SET version_created=modified;
UPDATE	 sd_spe_urines_revs                            	SET version_created=modified;
UPDATE	 shelves_revs                                  	SET version_created=modified;
UPDATE	 shipments_revs                                	SET version_created=modified;
UPDATE	 sop_masters_revs                              	SET version_created=modified;
UPDATE	 sopd_general_alls_revs                        	SET version_created=modified;
UPDATE	 sopd_inventory_alls_revs                      	SET version_created=modified;
UPDATE	 sope_general_all_revs                         	SET version_created=modified;
UPDATE	 sope_inventory_all_revs                       	SET version_created=modified;
UPDATE	 source_aliquots_revs                          	SET version_created=modified;
UPDATE	 specimen_details_revs                         	SET version_created=modified;
UPDATE	 specimen_review_masters_revs                  	SET version_created=modified;
UPDATE	 spr_breast_cancer_types_revs                  	SET version_created=modified;
UPDATE	 std_boxs_revs                                 	SET version_created=modified;
UPDATE	 std_cupboards_revs                            	SET version_created=modified;
UPDATE	 std_freezers_revs                             	SET version_created=modified;
UPDATE	 std_fridges_revs                              	SET version_created=modified;
UPDATE	 std_incubators_revs                           	SET version_created=modified;
UPDATE	 std_nitro_locates_revs                        	SET version_created=modified;
UPDATE	 std_racks_revs                                	SET version_created=modified;
UPDATE	 std_rooms_revs                                	SET version_created=modified;
UPDATE	 std_shelfs_revs                               	SET version_created=modified;
UPDATE	 std_tma_blocks_revs                           	SET version_created=modified;
UPDATE	 storage_coordinates_revs                      	SET version_created=modified;
UPDATE	 storage_masters_revs                          	SET version_created=modified;
UPDATE	 structure_permissible_values_customs_revs     	SET version_created=modified;
UPDATE	 study_contacts_revs                           	SET version_created=modified;
UPDATE	 study_ethics_boards_revs                      	SET version_created=modified;
UPDATE	 study_fundings_revs                           	SET version_created=modified;
UPDATE	 study_investigators_revs                      	SET version_created=modified;
UPDATE	 study_related_revs                            	SET version_created=modified;
UPDATE	 study_results_revs                            	SET version_created=modified;
UPDATE	 study_reviews_revs                            	SET version_created=modified;
UPDATE	 study_summaries_revs                          	SET version_created=modified;
UPDATE	 tma_slides_revs                               	SET version_created=modified;
UPDATE	 tx_masters_revs                               	SET version_created=modified;
UPDATE	 txd_chemos_revs                               	SET version_created=modified;
UPDATE	 txd_radiations_revs                           	SET version_created=modified;
UPDATE	 txd_surgeries_revs                            	SET version_created=modified;
UPDATE	 txe_chemos_revs                               	SET version_created=modified;
UPDATE	 txe_radiations_revs                           	SET version_created=modified;
UPDATE	 txe_surgeries_revs                            	SET version_created=modified;



ALTER TABLE	 ad_bags_revs                                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_blocks_revs                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_cell_cores_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_cell_slides_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_gel_matrices_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_tissue_cores_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_tissue_slides_revs                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_tubes_revs                                 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ad_whatman_papers_revs                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 aliquot_internal_uses_revs                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 aliquot_masters_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 aliquot_review_masters_revs                   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ar_breast_tissue_slides_revs                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 banks_revs                                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 cd_nationals_revs                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 clinical_collection_links_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 coding_adverse_events_revs                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 collections_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 consent_masters_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 datamart_browsing_indexes_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 datamart_browsing_results_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 derivative_details_revs                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 diagnosis_masters_revs                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 drugs_revs                                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_bloods_revs                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_ampullas_revs                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_colon_biopsies_revs            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_colon_rectum_resections_revs   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_distalexbileducts_revs         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_gallbladders_revs              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_hepatocellular_carcinomas_revs 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_intrahepbileducts_revs         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_pancreasendos_revs             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_pancreasexos_revs              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_perihilarbileducts_revs        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_cap_report_smintestines_revs              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 dxd_tissues_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_all_adverse_events_adverse_events_revs     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_all_clinical_followups_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_all_clinical_presentations_revs            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_all_lifestyle_smokings_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_all_protocol_followups_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_all_study_researches_revs                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_breast_lab_pathologies_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 ed_breast_screening_mammograms_revs           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 event_masters_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 family_histories_revs                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 lab_book_masters_revs                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 lbd_dna_extractions_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 lbd_slide_creations_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 materials_revs                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 misc_identifiers_revs                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 order_items_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 order_lines_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 orders_revs                                   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 participant_contacts_revs                     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 participant_messages_revs                     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 participants_revs                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 pd_chemos_revs                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 pd_surgeries_revs                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 pe_chemos_revs                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 protocol_masters_revs                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 quality_ctrls_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 realiquotings_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 reproductive_histories_revs                   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 rtbforms_revs                                 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sample_masters_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_amp_rnas_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_ascite_cells_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_ascite_sups_revs                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_b_cells_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_blood_cells_revs                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_cdnas_revs                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_cell_cultures_revs                     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_cell_lysates_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_cystic_fl_cells_revs                   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_cystic_fl_sups_revs                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_dnas_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_pbmcs_revs                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_pericardial_fl_cells_revs              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_pericardial_fl_sups_revs               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_plasmas_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_pleural_fl_cells_revs                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_pleural_fl_sups_revs                   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_proteins_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_pw_cells_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_pw_sups_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_rnas_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_serums_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_tiss_lysates_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_tiss_susps_revs                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_urine_cents_revs                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_der_urine_cons_revs                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_ascites_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_bloods_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_cystic_fluids_revs                     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_pericardial_fluids_revs                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_peritoneal_washes_revs                 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_pleural_fluids_revs                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_tissues_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sd_spe_urines_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 shelves_revs                                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 shipments_revs                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sop_masters_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sopd_general_alls_revs                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sopd_inventory_alls_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sope_general_all_revs                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 sope_inventory_all_revs                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 source_aliquots_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 specimen_details_revs                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 specimen_review_masters_revs                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 spr_breast_cancer_types_revs                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_boxs_revs                                 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_cupboards_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_freezers_revs                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_fridges_revs                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_incubators_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_nitro_locates_revs                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_racks_revs                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_rooms_revs                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_shelfs_revs                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 std_tma_blocks_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 storage_coordinates_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 storage_masters_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 structure_permissible_values_customs_revs     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_contacts_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_ethics_boards_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_fundings_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_investigators_revs                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_related_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_results_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_reviews_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 study_summaries_revs                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 tma_slides_revs                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 tx_masters_revs                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 txd_chemos_revs                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 txd_radiations_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 txd_surgeries_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 txe_chemos_revs                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 txe_radiations_revs                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;
ALTER TABLE	 txe_surgeries_revs                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN deleted, DROP COLUMN deleted_date, DROP COLUMN modified;

ALTER TABLE	 ad_bags                                  	DROP COLUMN deleted_date;
ALTER TABLE	 ad_blocks                                	DROP COLUMN deleted_date;
ALTER TABLE	 ad_cell_cores                            	DROP COLUMN deleted_date;
ALTER TABLE	 ad_cell_slides                           	DROP COLUMN deleted_date;
ALTER TABLE	 ad_gel_matrices                          	DROP COLUMN deleted_date;
ALTER TABLE	 ad_tissue_cores                          	DROP COLUMN deleted_date;
ALTER TABLE	 ad_tissue_slides                         	DROP COLUMN deleted_date;
ALTER TABLE	 ad_tubes                                 	DROP COLUMN deleted_date;
ALTER TABLE	 ad_whatman_papers                        	DROP COLUMN deleted_date;
ALTER TABLE	 aliquot_internal_uses                    	DROP COLUMN deleted_date;
ALTER TABLE	 aliquot_masters                          	DROP COLUMN deleted_date;
ALTER TABLE	 aliquot_review_masters                   	DROP COLUMN deleted_date;
ALTER TABLE	 announcements                            	DROP COLUMN deleted_date;
ALTER TABLE	 ar_breast_tissue_slides                  	DROP COLUMN deleted_date;
ALTER TABLE	 banks                                    	DROP COLUMN deleted_date;
ALTER TABLE	 cd_nationals                             	DROP COLUMN deleted_date;
ALTER TABLE	 clinical_collection_links                	DROP COLUMN deleted_date;
ALTER TABLE	 coding_adverse_events                    	DROP COLUMN deleted_date;
ALTER TABLE	 collections                              	DROP COLUMN deleted_date;
ALTER TABLE	 consent_masters                          	DROP COLUMN deleted_date;
ALTER TABLE	 datamart_browsing_indexes                	DROP COLUMN deleted_date;
ALTER TABLE	 datamart_browsing_results                	DROP COLUMN deleted_date;
ALTER TABLE	 derivative_details                       	DROP COLUMN deleted_date;
ALTER TABLE	 diagnosis_masters                        	DROP COLUMN deleted_date;
ALTER TABLE	 drugs                                    	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_bloods                               	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_ampullas                  	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_colon_biopsies            	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_colon_rectum_resections   	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_distalexbileducts         	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_gallbladders              	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_hepatocellular_carcinomas 	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_intrahepbileducts         	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_pancreasendos             	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_pancreasexos              	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_perihilarbileducts        	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_cap_report_smintestines              	DROP COLUMN deleted_date;
ALTER TABLE	 dxd_tissues                              	DROP COLUMN deleted_date;
ALTER TABLE	 ed_all_adverse_events_adverse_events     	DROP COLUMN deleted_date;
ALTER TABLE	 ed_all_clinical_followups                	DROP COLUMN deleted_date;
ALTER TABLE	 ed_all_clinical_presentations            	DROP COLUMN deleted_date;
ALTER TABLE	 ed_all_lifestyle_smokings                	DROP COLUMN deleted_date;
ALTER TABLE	 ed_all_protocol_followups                	DROP COLUMN deleted_date;
ALTER TABLE	 ed_all_study_researches                  	DROP COLUMN deleted_date;
ALTER TABLE	 ed_breast_lab_pathologies                	DROP COLUMN deleted_date;
ALTER TABLE	 ed_breast_screening_mammograms           	DROP COLUMN deleted_date;
ALTER TABLE	 event_masters                            	DROP COLUMN deleted_date;
ALTER TABLE	 family_histories                         	DROP COLUMN deleted_date;
ALTER TABLE	 lab_book_masters                         	DROP COLUMN deleted_date;
ALTER TABLE	 lbd_dna_extractions                      	DROP COLUMN deleted_date;
ALTER TABLE	 lbd_slide_creations                      	DROP COLUMN deleted_date;
ALTER TABLE	 materials                                	DROP COLUMN deleted_date;
ALTER TABLE	 misc_identifiers                         	DROP COLUMN deleted_date;
ALTER TABLE	 order_items                              	DROP COLUMN deleted_date;
ALTER TABLE	 order_lines                              	DROP COLUMN deleted_date;
ALTER TABLE	 orders                                   	DROP COLUMN deleted_date;
ALTER TABLE	 participant_contacts                     	DROP COLUMN deleted_date;
ALTER TABLE	 participant_messages                     	DROP COLUMN deleted_date;
ALTER TABLE	 participants                             	DROP COLUMN deleted_date;
ALTER TABLE	 pd_chemos                                	DROP COLUMN deleted_date;
ALTER TABLE	 pd_surgeries                             	DROP COLUMN deleted_date;
ALTER TABLE	 pe_chemos                                	DROP COLUMN deleted_date;
ALTER TABLE	 protocol_masters                         	DROP COLUMN deleted_date;
ALTER TABLE	 quality_ctrls                            	DROP COLUMN deleted_date;
ALTER TABLE	 realiquotings                            	DROP COLUMN deleted_date;
ALTER TABLE	 reproductive_histories                   	DROP COLUMN deleted_date;
ALTER TABLE	 rtbforms                                 	DROP COLUMN deleted_date;
ALTER TABLE	 sample_masters                           	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_amp_rnas                          	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_ascite_cells                      	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_ascite_sups                       	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_b_cells                           	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_blood_cells                       	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_cdnas                             	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_cell_cultures                     	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_cell_lysates                      	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_cystic_fl_cells                   	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_cystic_fl_sups                    	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_dnas                              	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_pbmcs                             	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_pericardial_fl_cells              	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_pericardial_fl_sups               	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_plasmas                           	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_pleural_fl_cells                  	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_pleural_fl_sups                   	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_proteins                          	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_pw_cells                          	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_pw_sups                           	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_rnas                              	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_serums                            	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_tiss_lysates                      	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_tiss_susps                        	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_urine_cents                       	DROP COLUMN deleted_date;
ALTER TABLE	 sd_der_urine_cons                        	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_ascites                           	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_bloods                            	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_cystic_fluids                     	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_pericardial_fluids                	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_peritoneal_washes                 	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_pleural_fluids                    	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_tissues                           	DROP COLUMN deleted_date;
ALTER TABLE	 sd_spe_urines                            	DROP COLUMN deleted_date;
ALTER TABLE	 shelves                                  	DROP COLUMN deleted_date;
ALTER TABLE	 shipments                                	DROP COLUMN deleted_date;
ALTER TABLE	 sop_masters                              	DROP COLUMN deleted_date;
ALTER TABLE	 sopd_general_alls                        	DROP COLUMN deleted_date;
ALTER TABLE	 sopd_inventory_alls                      	DROP COLUMN deleted_date;
ALTER TABLE	 sope_general_all                         	DROP COLUMN deleted_date;
ALTER TABLE	 sope_inventory_all                       	DROP COLUMN deleted_date;
ALTER TABLE	 source_aliquots                          	DROP COLUMN deleted_date;
ALTER TABLE	 specimen_details                         	DROP COLUMN deleted_date;
ALTER TABLE	 specimen_review_masters                  	DROP COLUMN deleted_date;
ALTER TABLE	 spr_breast_cancer_types                  	DROP COLUMN deleted_date;
ALTER TABLE	 std_boxs                                 	DROP COLUMN deleted_date;
ALTER TABLE	 std_cupboards                            	DROP COLUMN deleted_date;
ALTER TABLE	 std_freezers                             	DROP COLUMN deleted_date;
ALTER TABLE	 std_fridges                              	DROP COLUMN deleted_date;
ALTER TABLE	 std_incubators                           	DROP COLUMN deleted_date;
ALTER TABLE	 std_nitro_locates                        	DROP COLUMN deleted_date;
ALTER TABLE	 std_racks                                	DROP COLUMN deleted_date;
ALTER TABLE	 std_rooms                                	DROP COLUMN deleted_date;
ALTER TABLE	 std_shelfs                               	DROP COLUMN deleted_date;
ALTER TABLE	 std_tma_blocks                           	DROP COLUMN deleted_date;
ALTER TABLE	 storage_coordinates                      	DROP COLUMN deleted_date;
ALTER TABLE	 storage_masters                          	DROP COLUMN deleted_date;
ALTER TABLE	 structure_permissible_values_customs     	DROP COLUMN deleted_date;
ALTER TABLE	 study_contacts                           	DROP COLUMN deleted_date;
ALTER TABLE	 study_ethics_boards                      	DROP COLUMN deleted_date;
ALTER TABLE	 study_fundings                           	DROP COLUMN deleted_date;
ALTER TABLE	 study_investigators                      	DROP COLUMN deleted_date;
ALTER TABLE	 study_related                            	DROP COLUMN deleted_date;
ALTER TABLE	 study_results                            	DROP COLUMN deleted_date;
ALTER TABLE	 study_reviews                            	DROP COLUMN deleted_date;
ALTER TABLE	 study_summaries                          	DROP COLUMN deleted_date;
ALTER TABLE	 tma_slides                               	DROP COLUMN deleted_date;
ALTER TABLE	 tx_masters                               	DROP COLUMN deleted_date;
ALTER TABLE	 txd_chemos                               	DROP COLUMN deleted_date;
ALTER TABLE	 txd_radiations                           	DROP COLUMN deleted_date;
ALTER TABLE	 txd_surgeries                            	DROP COLUMN deleted_date;
ALTER TABLE	 txe_chemos                               	DROP COLUMN deleted_date;
ALTER TABLE	 txe_radiations                           	DROP COLUMN deleted_date;
ALTER TABLE	 txe_surgeries                            	DROP COLUMN deleted_date;
ALTER TABLE	 users                                    	DROP COLUMN deleted_date;

ALTER TABLE	 ad_bags                                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_blocks                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_cell_cores                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_cell_slides                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_gel_matrices                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_tissue_cores                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_tissue_slides                         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_tubes                                 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_whatman_papers                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 cd_nationals                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_bloods                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_ampullas                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_colon_biopsies            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_colon_rectum_resections   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_distalexbileducts         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_gallbladders              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_hepatocellular_carcinomas 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_intrahepbileducts         	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_pancreasendos             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_pancreasexos              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_perihilarbileducts        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_smintestines              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 dxd_tissues                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_all_adverse_events_adverse_events     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_all_clinical_followups                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_all_clinical_presentations            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_all_lifestyle_smokings                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_all_protocol_followups                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_all_study_researches                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_breast_lab_pathologies                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ed_breast_screening_mammograms           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 lbd_dna_extractions                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 lbd_slide_creations                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 pd_chemos                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 pd_surgeries                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_amp_rnas                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_ascite_cells                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_ascite_sups                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_b_cells                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_blood_cells                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cdnas                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cell_cultures                     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cell_lysates                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cystic_fl_cells                   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cystic_fl_sups                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_dnas                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pbmcs                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pericardial_fl_cells              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pericardial_fl_sups               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_plasmas                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pleural_fl_cells                  	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pleural_fl_sups                   	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_proteins                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pw_cells                          	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pw_sups                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_rnas                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_serums                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_tiss_lysates                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_tiss_susps                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_urine_cents                       	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_der_urine_cons                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_ascites                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_bloods                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_cystic_fluids                     	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_pericardial_fluids                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_peritoneal_washes                 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_pleural_fluids                    	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_tissues                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_urines                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sopd_general_alls                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 sopd_inventory_alls                      	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_boxs                                 	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_cupboards                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_freezers                             	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_fridges                              	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_incubators                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_nitro_locates                        	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_racks                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_rooms                                	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_shelfs                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 std_tma_blocks                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 txd_chemos                               	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 txd_radiations                           	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 txd_surgeries                            	DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by;
ALTER TABLE	 ad_bags_revs                                 	DROP COLUMN modified_by;
ALTER TABLE	 ad_blocks_revs                               	DROP COLUMN modified_by;
ALTER TABLE	 ad_cell_cores_revs                           	DROP COLUMN modified_by;
ALTER TABLE	 ad_cell_slides_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 ad_gel_matrices_revs                         	DROP COLUMN modified_by;
ALTER TABLE	 ad_tissue_cores_revs                         	DROP COLUMN modified_by;
ALTER TABLE	 ad_tissue_slides_revs                        	DROP COLUMN modified_by;
ALTER TABLE	 ad_tubes_revs                                	DROP COLUMN modified_by;
ALTER TABLE	 ad_whatman_papers_revs                       	DROP COLUMN modified_by;
ALTER TABLE	 cd_nationals_revs                            	DROP COLUMN modified_by;
ALTER TABLE	 dxd_bloods_revs                              	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_ampullas_revs                 	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_colon_biopsies_revs           	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_colon_rectum_resections_revs  	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_distalexbileducts_revs        	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_gallbladders_revs             	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_hepatocellular_carcinomas_revs	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_intrahepbileducts_revs        	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_pancreasendos_revs            	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_pancreasexos_revs             	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_perihilarbileducts_revs       	DROP COLUMN modified_by;
ALTER TABLE	 dxd_cap_report_smintestines_revs             	DROP COLUMN modified_by;
ALTER TABLE	 dxd_tissues_revs                             	DROP COLUMN modified_by;
ALTER TABLE	 ed_all_adverse_events_adverse_events_revs    	DROP COLUMN modified_by;
ALTER TABLE	 ed_all_clinical_followups_revs               	DROP COLUMN modified_by;
ALTER TABLE	 ed_all_clinical_presentations_revs           	DROP COLUMN modified_by;
ALTER TABLE	 ed_all_lifestyle_smokings_revs               	DROP COLUMN modified_by;
ALTER TABLE	 ed_all_protocol_followups_revs               	DROP COLUMN modified_by;
ALTER TABLE	 ed_all_study_researches_revs                 	DROP COLUMN modified_by;
ALTER TABLE	 ed_breast_lab_pathologies_revs               	DROP COLUMN modified_by;
ALTER TABLE	 ed_breast_screening_mammograms_revs          	DROP COLUMN modified_by;
ALTER TABLE	 lbd_dna_extractions_revs                     	DROP COLUMN modified_by;
ALTER TABLE	 lbd_slide_creations_revs                     	DROP COLUMN modified_by;
ALTER TABLE	 pd_chemos_revs                               	DROP COLUMN modified_by;
ALTER TABLE	 pd_surgeries_revs                            	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_amp_rnas_revs                         	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_ascite_cells_revs                     	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_ascite_sups_revs                      	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_b_cells_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_blood_cells_revs                      	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cdnas_revs                            	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cell_cultures_revs                    	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cell_lysates_revs                     	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cystic_fl_cells_revs                  	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_cystic_fl_sups_revs                   	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_dnas_revs                             	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pbmcs_revs                            	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pericardial_fl_cells_revs             	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pericardial_fl_sups_revs              	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_plasmas_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pleural_fl_cells_revs                 	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pleural_fl_sups_revs                  	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_proteins_revs                         	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pw_cells_revs                         	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_pw_sups_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_rnas_revs                             	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_serums_revs                           	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_tiss_lysates_revs                     	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_tiss_susps_revs                       	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_urine_cents_revs                      	DROP COLUMN modified_by;
ALTER TABLE	 sd_der_urine_cons_revs                       	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_ascites_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_bloods_revs                           	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_cystic_fluids_revs                    	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_pericardial_fluids_revs               	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_peritoneal_washes_revs                	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_pleural_fluids_revs                   	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_tissues_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 sd_spe_urines_revs                           	DROP COLUMN modified_by;
ALTER TABLE	 sopd_general_alls_revs                       	DROP COLUMN modified_by;
ALTER TABLE	 sopd_inventory_alls_revs                     	DROP COLUMN modified_by;
ALTER TABLE	 std_boxs_revs                                	DROP COLUMN modified_by;
ALTER TABLE	 std_cupboards_revs                           	DROP COLUMN modified_by;
ALTER TABLE	 std_freezers_revs                            	DROP COLUMN modified_by;
ALTER TABLE	 std_fridges_revs                             	DROP COLUMN modified_by;
ALTER TABLE	 std_incubators_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 std_nitro_locates_revs                       	DROP COLUMN modified_by;
ALTER TABLE	 std_racks_revs                               	DROP COLUMN modified_by;
ALTER TABLE	 std_rooms_revs                               	DROP COLUMN modified_by;
ALTER TABLE	 std_shelfs_revs                              	DROP COLUMN modified_by;
ALTER TABLE	 std_tma_blocks_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 txd_chemos_revs                              	DROP COLUMN modified_by;
ALTER TABLE	 txd_radiations_revs                          	DROP COLUMN modified_by;
ALTER TABLE	 txd_surgeries_revs                           	DROP COLUMN modified_by;


ALTER TABLE ad_tubes
 ADD COLUMN hemolysis_signs VARCHAR(10) NOT NULL DEFAULT '' AFTER cell_count_unit;
ALTER TABLE ad_tubes_revs
 ADD COLUMN hemolysis_signs VARCHAR(10) NOT NULL DEFAULT '' AFTER cell_count_unit;
UPDATE ad_tubes 
INNER JOIN aliquot_masters ON aliquot_masters.id=ad_tubes.aliquot_master_id
INNER JOIN sample_masters ON aliquot_masters.sample_master_id=sample_masters.id AND sample_masters.sample_control_id=9
INNER JOIN sd_der_plasmas ON sample_masters.id=sd_der_plasmas.sample_master_id
SET ad_tubes.hemolysis_signs=sd_der_plasmas.hemolysis_signs;
UPDATE ad_tubes 
INNER JOIN aliquot_masters ON aliquot_masters.id=ad_tubes.aliquot_master_id
INNER JOIN sample_masters ON aliquot_masters.sample_master_id=sample_masters.id AND sample_masters.sample_control_id=10
INNER JOIN sd_der_serums ON sample_masters.id=sd_der_serums.sample_master_id
SET ad_tubes.hemolysis_signs=sd_der_serums.hemolysis_signs;

CREATE TABLE tmp(SELECT max(version_id) FROM ad_tubes_revs GROUP BY id); 
UPDATE ad_tubes_revs
INNER JOIN ad_tubes ON ad_tubes_revs.id=ad_tubes.id
SET ad_tubes_revs.hemolysis_signs=ad_tubes.hemolysis_signs
WHERE ad_tubes_revs.version_id IN(SELECT * FROM tmp);
DROP TABLE tmp;

UPDATE ad_tubes SET hemolysis_signs='y' WHERE hemolysis_signs='yes';
UPDATE ad_tubes_revs SET hemolysis_signs='y' WHERE hemolysis_signs='yes';
UPDATE ad_tubes SET hemolysis_signs='n' WHERE hemolysis_signs='no';
UPDATE ad_tubes_revs SET hemolysis_signs='n' WHERE hemolysis_signs='no';

ALTER TABLE sd_der_plasmas DROP COLUMN hemolysis_signs;
ALTER TABLE sd_der_plasmas_revs DROP COLUMN hemolysis_signs;
ALTER TABLE sd_der_serums DROP COLUMN hemolysis_signs;
ALTER TABLE sd_der_serums_revs DROP COLUMN hemolysis_signs;

INSERT INTO structures(`alias`) VALUES ('ad_hemolysis');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'hemolysis_signs', 'yes_no',  NULL , '0', '', '', '', 'hemolysis signs', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_hemolysis'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='hemolysis_signs' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hemolysis signs' AND `language_tag`=''), '1', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

UPDATE aliquot_controls SET form_alias=CONCAT(form_alias, ',ad_hemolysis') WHERE aliquot_type='tube' AND sample_control_id IN(9, 10);

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_serums') AND structure_field_id=(SELECT id FROM structure_fields WHERE field='hemolysis_signs' AND model='SampleDetail');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE field='hemolysis_signs' AND model='SampleDetail');

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `language_label`='current volume' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('aliquotinternaluses_volume');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='used volume' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SourceAliquot' AND `tablename`='aliquot_sources' AND `field`='used_volume' AND `language_label`='used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '1', '10000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
(1, 'create internal uses', '/inventorymanagement/aliquot_masters/addAliquotInternalUse/', 1);

INSERT INTO structures(`alias`) VALUES ('source_aliquots_volume');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SourceAliquot', 'source_aliquots', 'used_volume', 'float',  NULL , '0', '', '', '', 'used volume', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='source_aliquots_volume'), (SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='used volume' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0');

-- Build new invetory types + relationships

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'ascite cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'cystic fluid cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'pericardial fluid cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'peritoneal wash cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'pleural fluid cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell culture');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'bone marrow', 'BM', 'specimen', 'sample_masters,specimens', 'sd_spe_bone_marrows', 0, 'bone marrow'),
(null, 'bone marrow suspension', 'BM-SUSP', 'derivative', 'sample_masters,sd_undetailed_derivatives,derivative_lab_book,derivatives', 'sd_der_bone_marrow_susps', 0, 'bone marrow suspension'),
(null, 'no-b cell', 'No-BC', 'derivative', 'sample_masters,sd_undetailed_derivatives,derivative_lab_book,derivatives', 'sd_der_no_b_cells', 0, 'no-b cell');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow suspension');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow suspension');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell culture');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'dna');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'rna');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'no-b cell');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'b cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell culture');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'dna');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'rna');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'no-b cell');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell lysate');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'cell culture');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'dna');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'rna');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'no-b cell'), 'tube', '', 'aliquot_masters,ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml specific for cells', 0, 'tube');
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow suspension'), 'tube', '', 'aliquot_masters,ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml specific for cells', 0, 'tube');

INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow'), 'tube', '(ml)', 'aliquot_masters,ad_spec_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Specimen tube requiring volume in ml', 0, 'tube');

SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (null, @children_id, '0');

CREATE TABLE IF NOT EXISTS `sd_der_no_b_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_sd_der_no_b_cells_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `sd_der_no_b_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE IF NOT EXISTS `sd_der_bone_marrow_susps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_sd_der_bone_marrow_susps_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE IF NOT EXISTS `sd_der_bone_marrow_susps_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE IF NOT EXISTS `sd_spe_bone_marrows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_sd_spe_bone_marrows_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `sd_spe_bone_marrows_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_no_b_cells`
  ADD CONSTRAINT `FK_sd_der_no_b_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

ALTER TABLE `sd_der_bone_marrow_susps`
  ADD CONSTRAINT `FK_sd_der_bone_marrow_susps_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

ALTER TABLE `sd_spe_bone_marrows`
  ADD CONSTRAINT `FK_sd_spe_bone_marrows_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('sd_spe_bone_marrows');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='collected volume' AND `language_tag`=''), '1', '442', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unit'), '1', '443', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');

SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue suspension');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'no-b cell');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue suspension');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'b cell');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');
SET @parent_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue');
SET @children_id = (SELECT id FROM sample_controls WHERE sample_type = 'protein');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES (@parent_id, @children_id, '0');

SET @id = (SELECT id FROM aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'no-b cell'));
INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(@id, @id, 0, NULL);

SET @id = (SELECT id FROM aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow'));
INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(@id, @id, 0, NULL);
SET @id = (SELECT id FROM aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow suspension'));
INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(@id, @id, 0, NULL);

INSERT INTO i18n (id,en,fr) VALUES 
('no-b cell', 'No-B Cells', 'Cellules non-B'),
('bone marrow','Bone Marrow','Moelle osseuse'),
('bone marrow suspension','Bone Marrow Suspension','Suspension de moelle osseuse');

ALTER TABLE ad_tubes
 ADD COLUMN cell_viability DECIMAL(6,2) DEFAULT NULL AFTER cell_count_unit;
ALTER TABLE ad_tubes_revs
 ADD COLUMN cell_viability DECIMAL(6,2) DEFAULT NULL AFTER cell_count_unit; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'cell_viability', 'float_positive',  NULL , '0', 'size=5', '', '', 'viability (%)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cell_viability' AND `type`='float_positive' AND `structure_value_domain`  IS NULL ), '1', '79', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('viability (%)','Viability (%)','Viabilité (%)');


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'translator_indicator', 'yes_no',  NULL , '0', '', '', 'help_translator_indicator', 'translator used', ''), 
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'translator_signature', 'yes_no',  NULL , '0', '', '', 'help_translator_signature', '', 'translator signature captured');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_indicator' AND `type`='yes_no' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_indicator' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='access_medical_information') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_signature' AND `type`='yes_no' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_signature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

UPDATE consent_masters SET translator_signature='n' WHERE translator_signature='no';
UPDATE consent_masters SET translator_signature='y' WHERE translator_signature='yes';
UPDATE consent_masters SET translator_indicator='n' WHERE translator_indicator='no'; 
UPDATE consent_masters SET translator_indicator='y' WHERE translator_indicator='yes';

UPDATE sample_controls SET form_alias=REPLACE(form_alias, ',derivative_lab_book', '');

INSERT INTO structures(`alias`) VALUES ('in_stock_detail_volume');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='in_stock_detail_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='in_stock_detail_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '1', '12', '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_fields SET  `language_label`='' WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='sample_master_id' AND `type`='hidden' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='' WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='collection_id' AND `type`='hidden' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

DROP TABLE sidebars;

UPDATE structure_fields SET  `structure_value_domain`= NULL  WHERE model='AliquotReviewMaster' AND tablename='aliquot_review_masters' AND field='basis_of_specimen_review' AND `type`='yes_no' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');

ALTER TABLE user_login_attempts
 ADD COLUMN http_user_agent VARCHAR(255) DEFAULT '';
 
UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sourcealiquots_volume'), (SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='used volume' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1');

UPDATE structure_fields SET  `tablename`='sd_spe_tissues' WHERE model='SampleDetail' AND tablename='' AND field='pathology_reception_datetime' AND `type`='datetime' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `tablename`='' WHERE model='custom' AND tablename='custom' AND field='date' AND `type`='datetime' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1', `flag_override_label`='1', `language_label`='aliquot barcode' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND type='autocomplete');

ALTER TABLE tma_slides
 MODIFY storage_coord_x VARCHAR(11) NOT NULL DEFAULT '',
 MODIFY storage_coord_y VARCHAR(11) NOT NULL DEFAULT '';
ALTER TABLE tma_slides_revs
 MODIFY storage_coord_x VARCHAR(11) NOT NULL DEFAULT '',
 MODIFY storage_coord_y VARCHAR(11) NOT NULL DEFAULT '';
 
ALTER TABLE aliquot_masters
 MODIFY storage_coord_x VARCHAR(11) NOT NULL DEFAULT '',
 MODIFY storage_coord_y VARCHAR(11) NOT NULL DEFAULT '';
ALTER TABLE aliquot_masters_revs
 MODIFY storage_coord_x VARCHAR(11) NOT NULL DEFAULT '',
 MODIFY storage_coord_y VARCHAR(11) NOT NULL DEFAULT '';
 
ALTER TABLE storage_masters
 MODIFY parent_storage_coord_x VARCHAR(50) NOT NULL DEFAULT '',
 MODIFY parent_storage_coord_y VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE storage_masters_revs
 MODIFY parent_storage_coord_x VARCHAR(50) NOT NULL DEFAULT '',
 MODIFY parent_storage_coord_y VARCHAR(50) NOT NULL DEFAULT '';
 
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='aliquot used volume' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='' WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='aliquot used volume' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='aliquot used volume' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');	

UPDATE structure_fields SET  `setting`='' WHERE model='AliquotInternalUse' AND tablename='aliquot_internal_uses' AND field='use_details' AND `type`='textarea' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `tablename`='', model='custom' WHERE model='Generated' AND tablename='generated' AND field='time' AND `type`='time' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `tablename`='', model='custom' WHERE model='Generated' AND tablename='generated' AND field='event' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `tablename`='', model='custom' WHERE model='Generated' AND tablename='generated' AND field='date' AND `type`='date' AND structure_value_domain  IS NULL ;

ALTER TABLE aliquot_internal_uses ADD COLUMN use_datetime_accuracy CHAR(1) DEFAULT '' AFTER use_datetime;
ALTER TABLE aliquot_masters ADD COLUMN storage_datetime_accuracy CHAR(1) DEFAULT '' AFTER storage_datetime;
ALTER TABLE announcements 
 ADD COLUMN date_accuracy CHAR(1) DEFAULT '' AFTER date,
 ADD COLUMN date_start_accuracy CHAR(1) DEFAULT '' AFTER date_start,
 ADD COLUMN date_end_accuracy CHAR(1) DEFAULT '' AFTER date_end;
ALTER TABLE consent_masters 
 ADD COLUMN date_of_referral_accuracy CHAR(1) DEFAULT '' AFTER date_of_referral,
 ADD COLUMN date_first_contact_accuracy CHAR(1) DEFAULT '' AFTER date_first_contact,
 ADD COLUMN consent_signed_date_accuracy CHAR(1) DEFAULT '' AFTER consent_signed_date,
 ADD COLUMN status_date_accuracy CHAR(1) DEFAULT '' AFTER status_date,
 ADD COLUMN operation_date_accuracy CHAR(1) DEFAULT '' AFTER operation_date;
ALTER TABLE event_masters 
 ADD COLUMN event_date_accuracy CHAR(1) DEFAULT '' AFTER event_date,
 ADD COLUMN date_required_accuracy CHAR(1) DEFAULT '' AFTER date_required,
 ADD COLUMN date_requested_accuracy CHAR(1) DEFAULT '' AFTER date_requested;
ALTER TABLE lbd_dna_extractions ADD COLUMN creation_datetime_accuracy CHAR(1) DEFAULT '' AFTER creation_datetime;
ALTER TABLE lbd_slide_creations ADD COLUMN realiquoting_datetime_accuracy CHAR(1) DEFAULT '' AFTER realiquoting_datetime;
ALTER TABLE misc_identifiers 
 ADD COLUMN effective_date_accuracy CHAR(1) DEFAULT '' AFTER effective_date,
 ADD COLUMN expiry_date_accuracy CHAR(1) DEFAULT '' AFTER expiry_date;
ALTER TABLE order_items ADD COLUMN date_added_accuracy CHAR(1) DEFAULT '' AFTER date_added;
ALTER TABLE order_lines ADD COLUMN date_required_accuracy CHAR(1) DEFAULT '' AFTER date_required;
ALTER TABLE orders 
 ADD COLUMN date_order_placed_accuracy CHAR(1) DEFAULT '' AFTER date_order_placed,
 ADD COLUMN date_order_completed_accuracy CHAR(1) DEFAULT '' AFTER date_order_completed;
ALTER TABLE participant_contacts 
 ADD COLUMN effective_date_accuracy CHAR(1) DEFAULT '' AFTER effective_date,
 ADD COLUMN expiry_date_accuracy CHAR(1) DEFAULT '' AFTER expiry_date;
ALTER TABLE participant_messages 
 ADD COLUMN date_requested_accuracy CHAR(1) DEFAULT '' AFTER date_requested,
 ADD COLUMN due_date_accuracy CHAR(1) DEFAULT '' AFTER due_date,
 ADD COLUMN expiry_date_accuracy CHAR(1) DEFAULT '' AFTER expiry_date;
ALTER TABLE participants ADD COLUMN last_chart_checked_date_accuracy CHAR(1) DEFAULT '' AFTER last_chart_checked_date;
ALTER TABLE protocol_masters 
 ADD COLUMN expiry_accuracy CHAR(1) DEFAULT '' AFTER expiry,
 ADD COLUMN activated_accuracy CHAR(1) DEFAULT '' AFTER activated;
ALTER TABLE quality_ctrls ADD COLUMN date_accuracy CHAR(1) DEFAULT '' AFTER date;
ALTER TABLE realiquotings ADD COLUMN realiquoting_datetime_accuracy CHAR(1) DEFAULT '' AFTER realiquoting_datetime;
ALTER TABLE reproductive_histories 
 ADD COLUMN date_captured_accuracy CHAR(1) DEFAULT '' AFTER date_captured,
 ADD COLUMN lnmp_date_accuracy CHAR(1) DEFAULT '' AFTER lnmp_date;
ALTER TABLE rtbforms ADD COLUMN frmCreated_accuracy CHAR(1) DEFAULT '' AFTER frmCreated;
ALTER TABLE sd_spe_tissues ADD COLUMN pathology_reception_datetime_accuracy CHAR(1) DEFAULT '' AFTER pathology_reception_datetime;
ALTER TABLE shipments 
 ADD COLUMN datetime_shipped_accuracy CHAR(1) DEFAULT '' AFTER datetime_shipped,
 ADD COLUMN datetime_received_accuracy CHAR(1) DEFAULT '' AFTER datetime_received;
ALTER TABLE sop_masters 
 ADD COLUMN expiry_date_accuracy CHAR(1) DEFAULT '' AFTER expiry_date,
 ADD COLUMN activated_date_accuracy CHAR(1) DEFAULT '' AFTER activated_date;
ALTER TABLE specimen_review_masters ADD COLUMN review_date_accuracy CHAR(1) DEFAULT '' AFTER review_date;
ALTER TABLE std_tma_blocks ADD COLUMN creation_datetime_accuracy CHAR(1) DEFAULT '' AFTER creation_datetime;
ALTER TABLE study_ethics_boards ADD COLUMN date_accuracy CHAR(1) DEFAULT '' AFTER date;
ALTER TABLE study_fundings ADD COLUMN date_accuracy CHAR(1) DEFAULT '' AFTER date;
ALTER TABLE study_investigators 
 ADD COLUMN participation_start_date_accuracy CHAR(1) DEFAULT '' AFTER participation_start_date,
 ADD COLUMN participation_end_date_accuracy CHAR(1) DEFAULT '' AFTER participation_end_date;
ALTER TABLE study_related ADD COLUMN date_posted_accuracy CHAR(1) DEFAULT '' AFTER date_posted;
ALTER TABLE study_results ADD COLUMN result_date_accuracy CHAR(1) DEFAULT '' AFTER result_date;
ALTER TABLE study_reviews ADD COLUMN date_accuracy CHAR(1) DEFAULT '' AFTER date;
ALTER TABLE study_summaries 
 ADD COLUMN start_date_accuracy CHAR(1) DEFAULT '' AFTER start_date,
 ADD COLUMN end_date_accuracy CHAR(1) DEFAULT '' AFTER end_date;
ALTER TABLE tma_slides ADD COLUMN storage_datetime_accuracy CHAR(1) DEFAULT '' AFTER storage_datetime;

DROP VIEW view_aliquot_uses;

CREATE VIEW view_aliquot_uses AS 

SELECT 
CONCAT(source.id, 1) AS id,
aliq.id AS aliquot_master_id,
'sample derivative creation' AS use_definition, 
samp.sample_code AS use_code,
'' AS use_details,
source.used_volume,
aliq.aliquot_volume_unit,
der.creation_datetime AS use_datetime,
der.creation_datetime_accuracy AS use_datetime_accuracy,
der.creation_by AS used_by,
source.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllSourceAliquots|',samp.collection_id ,'|',samp.id) AS detail_url,
samp2.id AS sample_master_id,
samp2.collection_id AS collection_id
FROM source_aliquots AS source
INNER JOIN sample_masters AS samp ON samp.id = source.sample_master_id  AND samp.deleted != 1
INNER JOIN derivative_details AS der ON samp.id = der.sample_master_id  AND der.deleted != 1
INNER JOIN aliquot_masters AS aliq ON aliq.id = source.aliquot_master_id AND aliq.deleted != 1
INNER JOIN sample_masters AS samp2 ON samp2.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE source.deleted != 1

UNION ALL

SELECT 
CONCAT(realiq.id, 2) AS id,
aliq.id AS aliquot_master_id,
'realiquoted to' AS use_definition, 
child.barcode AS use_code,
'' AS use_details,
realiq.parent_used_volume AS used_volume,
aliq.aliquot_volume_unit,
realiq.realiquoting_datetime AS use_datetime,
realiq.realiquoting_datetime_accuracy AS use_datetime_accuracy,
realiq.realiquoted_by AS used_by,
realiq.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllRealiquotedParents|',child.collection_id,'|',child.sample_master_id,'|',child.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM realiquotings AS realiq
INNER JOIN aliquot_masters AS aliq ON aliq.id = realiq.parent_aliquot_master_id AND aliq.deleted != 1
INNER JOIN aliquot_masters AS child ON child.id = realiq.child_aliquot_master_id AND child.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE realiq.deleted != 1

UNION ALL

SELECT 
CONCAT(qc.id, 3) AS id,
aliq.id AS aliquot_master_id,
'quality control' AS use_definition, 
qc.qc_code AS use_code,
'' AS use_details,
qc.used_volume,
aliq.aliquot_volume_unit,
qc.date AS use_datetime,
qc.date_accuracy AS use_datetime_accuracy,
qc.run_by AS used_by,
qc.created,
CONCAT('|inventorymanagement|quality_ctrls|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',qc.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM quality_ctrls AS qc
INNER JOIN aliquot_masters AS aliq ON aliq.id = qc.aliquot_master_id AND aliq.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE qc.deleted != 1

UNION ALL

SELECT 
CONCAT(item.id, 4) AS id,
aliq.id AS aliquot_master_id,
'aliquot shipment' AS use_definition, 
sh.shipment_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
sh.datetime_shipped AS use_datetime,
sh.datetime_shipped_accuracy AS use_datetime_accuracy,
sh.shipped_by AS used_by,
sh.created,
CONCAT('|order|shipments|detail|',sh.order_id,'|',sh.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM order_items AS item
INNER JOIN aliquot_masters AS aliq ON aliq.id = item.aliquot_master_id AND aliq.deleted != 1
INNER JOIN shipments AS sh ON sh.id = item.shipment_id AND sh.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE item.deleted != 1

UNION ALL

SELECT 
CONCAT(alr.id, 5) AS id,
aliq.id AS aliquot_master_id,
'specimen review' AS use_definition, 
spr.review_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
spr.review_date AS use_datetime,
spr.review_date_accuracy AS use_datetime_accuracy,
'' AS used_by,
alr.created,
CONCAT('|inventorymanagement|specimen_reviews|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',spr.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_review_masters AS alr
INNER JOIN aliquot_masters AS aliq ON aliq.id = alr.aliquot_master_id AND aliq.deleted != 1
INNER JOIN specimen_review_masters AS spr ON spr.id = alr.specimen_review_master_id AND spr.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE alr.deleted != 1

UNION ALL

SELECT 
CONCAT(aluse.id, 6) AS id,
aliq.id AS aliquot_master_id,
'internal use' AS use_definition, 
aluse.use_code,
aluse.use_details,
aluse.used_volume,
aliq.aliquot_volume_unit,
aluse.use_datetime,
aluse.use_datetime_accuracy,
aluse.used_by,
aluse.created,
CONCAT('|inventorymanagement|aliquot_masters|detailAliquotInternalUse|',aliq.id,'|',aluse.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_internal_uses AS aluse
INNER JOIN aliquot_masters AS aliq ON aliq.id = aluse.aliquot_master_id AND aliq.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE aluse.deleted != 1;

UPDATE structure_formats SET display_order=display_order + 10 WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND display_order > 2;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sourcealiquots'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '3', '', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sourcealiquots'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '4', '', '1', '', '1', 'position', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sourcealiquots'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '5', '', '0', '', '1', '-', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '0');

-- Disable Materials and Equipment option from Tools Menu. Also disable SOP Extend option (Materials)
UPDATE `menus` SET `flag_active`=0 WHERE `id`='mat_CAN_01';
UPDATE `menus` SET `flag_active`=0 WHERE `id`='mat_CAN_02';
UPDATE `menus` SET `flag_active`=0 WHERE `id`='sop_CAN_04';