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
("previously defined", "Previously defined", "Défini précédemment"),
("the storage [%s] already contained something at position [%s, %s]", 
 "The storage [%s] already contained something at position [%s, %s]",
 "L'entreposage [%s] contenait déjà quelque chose à la position [%s, %s]"),
("hour_sign", "h", "h"),
("paste on all lines of all sections", "Paste on all lines of all sections", "Coller sur toutes les lignes de toutes les sections"),
("the linked consent status is [%s]", "The linked consent status is [%s]", "Le statut du consentement lié est [%s]"),
("no consent is linked to the current participant collection", 
 "No consent is linked to the current participant collection",
 "Aucun consentement n'est lié à la présente collection de participant"); 

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

CREATE TABLE tmp_accuracy_fields (SELECT substr(field, 1, length(field) - 9) AS field, tablename FROM structure_fields WHERE field LIKE '%_accuracy');
UPDATE structure_fields AS sf  
 INNER JOIN tmp_accuracy_fields AS taf ON taf.field=sf.field AND taf.tablename=sf.tablename
 SET sf.setting=CONCAT(setting, ',accuracy') 
 WHERE setting!=''; 
UPDATE structure_fields AS sf
 INNER JOIN tmp_accuracy_fields AS taf ON taf.field=sf.field AND taf.tablename=sf.tablename
 SET setting='accuracy' 
 WHERE setting=''; 
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field LIKE '%_accuracy%');
DELETE FROM structure_fields WHERE field LIKE '%_accuracy%';
DROP TABLE tmp_accuracy_fields;

UPDATE structure_fields SET  `setting`='accuracy' WHERE model='Participant' AND tablename='participants' AND field='date_of_death' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='accuracy' WHERE model='Participant' AND tablename='participants' AND field='date_of_birth' AND `type`='date' AND structure_value_domain  IS NULL ;

ALTER TABLE participants
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
"More information about the types of samples and aliquots are available <a href='%s' target='blank'>here</a>.",
"Plus d'informations sur les types d''échantillons et d''aliquots sont disponibles <a href='%s' target='blank'>ici</a>.");



