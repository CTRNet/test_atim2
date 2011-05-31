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
("paste on all lines of all sections", "Paste on all lines of all sections", "Coller sur toutes les lignes de toutes les sections");

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

UPDATE tmp_aliquot_controls tmp, order_lines ol
SET ol.aliquot_control_id = tmp.id
WHERE tmp.sample_control_id = ol.sample_control_id
AND tmp.old_aliquot_control_id = ol.aliquot_control_id;

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
	 
SELECT REPLACE(aliquot_type_precision,'derivative tube ','') from aliquot_controls;

GO



