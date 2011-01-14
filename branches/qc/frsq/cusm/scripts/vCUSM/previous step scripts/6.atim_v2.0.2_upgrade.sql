-- Version: v2.0.2
-- Description: This SQL script is an upgrade for ATiM v2.0.1. to 2.0.2. and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.2', `date_installed` = CURDATE(), `build_number` = '1423'
WHERE `versions`.`id` =1;

-- Delete all structures without associated fields
DELETE FROM `structures` WHERE id NOT IN
(
	SELECT structure_id
	FROM structure_formats
);

-- Add empty structure
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('empty', '', '', '1', '1', '0', '1');

-- Eventum 848
DELETE FROM i18n WHERE id IN ('1', '2', '3', '4', '5');

-- eventum 803 - active flags
ALTER TABLE `aliquot_controls` CHANGE `status` `status` VARCHAR( 20 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'inactive';
UPDATE aliquot_controls SET `status`='0' WHERE `status`!='active';
UPDATE aliquot_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE `aliquot_controls` CHANGE `status` `flag_active` BOOLEAN NOT NULL DEFAULT '1';

UPDATE consent_controls SET `status`='0' WHERE `status`!='active';
UPDATE consent_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE consent_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE diagnosis_controls SET `status`='0' WHERE `status`!='active';
UPDATE diagnosis_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE diagnosis_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE event_controls SET `status`='0' WHERE `status`!='active' && `status`!='yes';
UPDATE event_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE event_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE misc_identifier_controls SET `status`='0' WHERE `status`!='active';
UPDATE misc_identifier_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE misc_identifier_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE parent_to_derivative_sample_controls SET `status`='0' WHERE `status`!='active';
UPDATE parent_to_derivative_sample_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE parent_to_derivative_sample_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

ALTER TABLE protocol_controls ADD flag_active BOOLEAN NOT NULL DEFAULT '1';

ALTER TABLE `realiquoting_controls`  CHANGE `status` `status` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';
UPDATE realiquoting_controls SET `status`='0' WHERE `status`!='active';
UPDATE realiquoting_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE realiquoting_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE sample_controls SET `status`='0' WHERE `status`!='active';
UPDATE sample_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE sample_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

ALTER TABLE `sample_to_aliquot_controls`  CHANGE `status` `status` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';
UPDATE sample_to_aliquot_controls SET `status`='0' WHERE `status`!='active';
UPDATE sample_to_aliquot_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE sample_to_aliquot_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE storage_controls SET `status`='0' WHERE `status`!='active';
UPDATE storage_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE storage_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE tx_controls SET `status`='0' WHERE `status`!='active';
UPDATE tx_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE tx_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

ALTER TABLE `structure_value_domains_permissible_values`  CHANGE `active` `active` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';
UPDATE structure_value_domains_permissible_values SET `active`='0' WHERE `active`!='yes';
UPDATE structure_value_domains_permissible_values SET `active`='1' WHERE `active`!='0';
ALTER TABLE structure_value_domains_permissible_values CHANGE `active` flag_active BOOLEAN NOT NULL DEFAULT '1'; 

UPDATE menus SET `active`='0' WHERE `active`!='active' AND `active`!='yes' AND `active`!='1';
UPDATE menus SET `active`='1' WHERE `active`!='0';
ALTER TABLE menus CHANGE `active` flag_active BOOLEAN NOT NULL DEFAULT '1';

CREATE TABLE missing_translations(
	id varchar(255) NOT NULL UNIQUE PRIMARY KEY 
)Engine=InnoDb;

 -- Eventum 785
ALTER TABLE `pages` ADD COLUMN `use_link` VARCHAR(255) NOT NULL  AFTER `language_body`;

-- Remove old ID fields from the validations table. Missed from v2.0.1 update.
ALTER TABLE `structure_validations`
  DROP `old_id`,
  DROP `structure_field_old_id`;

-- Replace old ICD-10 coding tool with new select list
UPDATE `structure_fields` 
SET `type` = 'select', `setting` = '', `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'icd10')
WHERE `plugin` = 'Clinicalannotation'
   AND `model` = 'FamilyHistory'
   AND `tablename` = 'family_histories'
   AND `field` = 'primary_icd10_code';

UPDATE `structure_fields` 
SET `type` = 'select', `setting` = '', `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'icd10')
WHERE `plugin` = 'Clinicalannotation'
   AND `model` = 'DiagnosisMaster'
   AND `tablename` = 'diagnosis_masters'
   AND `field` = 'primary_icd10_code';
   
UPDATE `structure_fields` 
SET `type` = 'select', `setting` = '', `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'icd10')
WHERE `plugin` = 'Clinicalannotation'
   AND `model` = 'Participant'
   AND `tablename` = 'participants'
   AND `field` = 'secondary_cod_icd10_code';
   
-- Update the structure_field unique key
ALTER TABLE structure_fields 
 DROP KEY `unique_fields`,
 ADD UNIQUE KEY `unique_fields` (`plugin`,`model`,`tablename`,`field`, `structure_value_domain`);

-- i18n text fields update
ALTER TABLE i18n
 CHANGE `en` `en` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
 CHANGE `fr` `fr` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;
 
-- Fix english translation for diagnosis   
UPDATE `i18n` 
SET `en` = 'Diagnosis' 
WHERE `id` = 'diagnosis';

-- add missing translation
INSERT IGNORE INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
('Prev', 'global', 'Prev', 'Préc'),
('Next', 'global', 'Next', 'Suiv'),
('Details', 'global', 'Details', 'Détails'),
('event', 'global', 'Event', 'Événement'),
('decimal separator', '', 'Decimal separator', 'Séparateur de décimales'),
("error_must_be_integer", "", "Error - Integer value expected", "Erreur - Valeur entière attendue"),
("error_must_be_positive_integer", "", "Error - Positive integer value expected", "Erreur - Valeur entière positive attendue"),
("error_must_be_float", "", "Error - Float value expected", "Erreur - Valeur flottante attendue"),
("error_must_be_positive_float", "", "Error - Positive float value expected", "Erreur - Valeur flottante positive attendue");


REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('jan', '', 'Jan', 'Jan'),
('feb', '', 'Feb', 'Fév'),
('mar', '', 'Mar', 'Mars'),
('apr', '', 'Apr', 'Avr'),
('may', '', 'May', 'Mai'),
('May', 'global', 'May', 'Mai'),
('jun', '', 'Jun', 'Jun'),
('jul', '', 'Jul', 'Jul'),
('aug', '', 'Aug', 'Aoû'),
('sep', '', 'Sep', 'Sep'),
('oct', '', 'Oct', 'Oct'),
('nov', '', 'Nov', 'Nov'),
('dec', '', 'Dec', 'Déc'),
('locked', '', 'Locked', 'Bloqué'),
('define_date_format', '', 'Date Format', 'Format de date'),
('define_csv_separator', '', 'CSV Separator', 'Séparateur de CSV'),
('define_show_summary', '', 'Show Summary', 'Voir les sommaires'),
('help visible', '', 'Help Visible', 'Aide visible'),
('language', '', 'Language', 'Lanque'),
('English', '', 'English', 'Anglais'),
('French', '', 'French', 'Français'),
('core_pagination', '', 'pagination', 'pagination'),
('Login', '', 'Login', 'Connection'),
 ('about_body', '', 'The Canadian Tumour Repository Network (CTRNet) is a translational cancer research resource, funded by Canadian Institutes of Health Research, that furthers Canadian health research by linking cancer researchers with provincial tumour banks.', 'Le réseau canadien de banques de tumeurs (RCBT) est une ressource en recherche translationnelle en cancer, subventionnée par les Instituts de recherche en santé du Canada, qui aide la recherche en santé au Canada en reliant entre eux les chercheurs en onc'),
 ('aliquot_in_stock_help', '', 'Status of an aliquot: <br> - ''Yes & Available'' => Aliquot exists physically into the bank and is available without restriction. <br> - ''Yes & Not Available'' => Aliquot exists physically into the bank but a restriction exists (reserved for and order, a stu', 'Statut d''un aliquot : <br> - ''Oui & Disponible'' => Aliquot présent physiquement dans la banque et disponible sans restriction. <br> - ''Oui & Non disponible'' => Aliquot présent physiquement dans la banque mais une restriction existe (réservé pour une étude'),
 ('credits_body', '', 'ATiM is an open-source project development by leading tumour banks across Canada. For more information on our development team, questions, comments or suggestions please visit our website at http://www.ctrnet.ca', 'ATiM est un logiciel développé par les plus importantes banques de tumeurs à travers le Canada. Pour de plus amples informations sur notre équipe de développement, des questions, commentaires ou suggestions, veuillez consulter notre site web à http://www.'),
 ('help_dx method', '', 'The most definitive diagnostic procedure before radiotherapy (to primary site) and/or chemotherapy is given, by which a malignancy is diagnosed within 3 months of the earliest known encounter with the health care system for (an investigation relating to) ', 'La procédure du meilleur diagnostic définitif avant la radiothérapie (au site primaire) et/ou chimiothérapie, par lequel la malignité est diagnostiquée dans les 3 mois de la première rencontre connue à l''intérieur du système de santé (investigation relati'),
 ('inv_collection_type_defintion', 'global', 'Allow to define a collection either as a bank participant collection (''Participant Collection'') or as a collection that will never be attached to a participant (''Independent Collection'').<br>In the second case, the collection will never be displayed in the the clinical annotation module form used to link a participant to an available collection.', 'Permet de d&eacute;finir une collection comme une collection d''un participant d''une banque (''Collection de participant'') ou comme une collection qui ne sera jamais li&eacute;e &agrave; un participant (''Collection ind&eacute;pendante'').<br>Dans ce second cas, la collection ne sera jamais affich&eacute;e dans la page du module d''annotation clinique permettant de lier une collection au participant.'),
 ('login_help', 'global', 'For demonstration purposes, there are two logins available.\r\n\r\nThe first is "endemo" as both username and password. This user has a default setting of english.\r\n\r\nThe second is "frdemo" as both username and password. This user has a default setting of french.\r\n\r\nAll text, including english, is accessed from language datatables. All text to be displayed in a HELPER, VIEW, or LAYOUT should be entered as aliases in all other datatables. A TRANSLATION helper/function calls that alias, and displays the correct language text or the same alias with a mistranlation indication.', ''),
 ('Query error', '', 'Query error', 'Erreur de requête'),
 ('An error occured on a database query. Send the following lines to support.', '', 'An error occured on a database query. Send the following lines to support.', "Une erreur s'est produite avec une requête à la base de données. Envoyez les lignes suivantes au support."),
 ('or', '', 'or', 'où'),
 ('show advanced controls', '', 'Show advanced controls', 'Afficher les contrôles avancés'),
 ('moved within storage', '', 'Moved within storage', "Déplacé à l'intérieur de l'entreposage"),
 ('new storage', '', 'New storage', 'Nouvel entreposage'),
 ('temperature unchanged', '', "Temperature unchanged", "Température inchangée"),
 ('new temperature', '', 'New temperature', "Nouvelle température"),
 ('storage temperature changed', '', "Storage temperature changed", "La température de l'entreposage a changée"),
 ('storage history', "", "Storage history", "Historique de l'entreposage"),
 ('year', '', 'Year', 'Année'),
 ("month", "", "Month", "Mois"),
 ("day", "", "Day", "Jour"),
 ("hour", "", "Hour", "Heure"),
 ("minutes", "", "Minutes", "Minutes"),
 ("invalid order line", "", "Invalid order line", "Ligne de commande invalide");
 
INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
 ('err_query', '1', 'Query error', 'An error occured on a database query. Send the following lines to support.', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
ALTER TABLE `configs` ADD `define_decimal_separator` ENUM( ',', '.' ) NOT NULL DEFAULT '.' AFTER `define_pagination_amount`;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('decimal_separator', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES(".", ".");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="decimal_separator"),  (SELECT id FROM structure_permissible_values WHERE value="." AND language_alias="."), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES(",", ",");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="decimal_separator"),  (SELECT id FROM structure_permissible_values WHERE value="," AND language_alias=","), "2", "1");
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Clinicalannotation', 'Config', 'configs', 'define_decimal_separator', 'decimal separator', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='decimal_separator') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='preferences'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_decimal_separator' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='decimal_separator')  ), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');


-- storage suggest
UPDATE `structure_fields` SET `type` = 'autocomplete', `setting` = 'url=/storagelayout/storage_masters/autocompleteLabel' WHERE model='FunctionManagement' AND field='recorded_storage_selection_label';

-- custom_aliquot_storage_history
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('custom_aliquot_storage_history', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Inventorymanagement', 'custom', 'custom', 'date', 'date', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open'), ('', 'Inventorymanagement', 'custom', '', 'event', 'event', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='custom_aliquot_storage_history'), (SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='custom' AND `field`='date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='custom_aliquot_storage_history'), (SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='event' AND `structure_value_domain`  IS NULL  ), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- 24 hour support config
ALTER TABLE `configs` ADD `define_time_format` ENUM( '12', '24' ) NOT NULL DEFAULT '24' AFTER `define_date_format`;
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('time_format', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("12", "12");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="time_format"),  (SELECT id FROM structure_permissible_values WHERE value="12" AND language_alias="12"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("24", "24");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="time_format"),  (SELECT id FROM structure_permissible_values WHERE value="24" AND language_alias="24"), "2", "1");
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Administrate', 'Config', 'configs', 'define_time_format', 'time format', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='time_format') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='preferences'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_time_format' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='time_format')  ), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET display_column='1', display_order='1', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE structure_id=(SELECT id FROM structures WHERE alias='preferences') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_date_format' AND `language_label`='define_date_format' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='MDY' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='define_date_format')  AND `language_help`='' );

-- datetime input type + advanced controls
ALTER TABLE `configs`
 ADD `define_datetime_input_type` ENUM( 'dropdown', 'textual' ) NOT NULL DEFAULT 'dropdown' AFTER `define_decimal_separator`,
 ADD `define_show_advanced_controls` VARCHAR(255) NOT NULL DEFAULT '1' AFTER `define_datetime_input_type`;  
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('datetime_input_type', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("dropdown", "dropdown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="datetime_input_type"),  (SELECT id FROM structure_permissible_values WHERE value="dropdown" AND language_alias="dropdown"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("textual", "textual");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="datetime_input_type"),  (SELECT id FROM structure_permissible_values WHERE value="textual" AND language_alias="textual"), "2", "1");
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Administrate', 'Config', 'configs', 'define_datetime_input_type', 'datetime input type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_input_type') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='preferences'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_datetime_input_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_input_type')  ), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Administrate', 'Config', 'configs', 'define_show_advanced_controls', 'show advanced controls', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='preferences'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_show_advanced_controls' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Fixed incorrect table name spellings
UPDATE `structure_fields` SET `tablename` = 'misc_identifiers'
WHERE `tablename` = 'misc_identifier';

UPDATE `structure_fields`
SET `tablename` = 'txe_chemos'
WHERE `model` = 'TreatmentExtend' AND `field` = 'dose';
  
UPDATE `structure_fields` SET `tablename` = 'txe_chemos'
WHERE `model` = 'TreatmentExtend' AND `field` = 'drug_id';
  
UPDATE `structure_fields` SET `tablename` = 'txe_chemos'
WHERE `model` = 'TreatmentExtend' AND `field` = 'method';

-- Clean up/add FK linked to Protocols, drugs, treatments

ALTER TABLE `pe_chemos`
  ADD CONSTRAINT `FK_pe_chemos_protocol_masters`
  FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);

ALTER TABLE `pd_chemos`
  ADD CONSTRAINT `FK_pd_chemos_protocol_masters`
  FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);

ALTER TABLE `tx_masters` 
  CHANGE `protocol_id` `protocol_master_id` int(11) DEFAULT NULL;

ALTER TABLE `tx_masters_revs` 
  CHANGE `protocol_id` `protocol_master_id` int(11) DEFAULT NULL;
	
ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_protocol_masters`
  FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
  
UPDATE structure_fields 
SET `field`='protocol_master_id'
WHERE `tablename`='tx_masters' AND `field`='protocol_id';
  
ALTER TABLE `txe_chemos`
  ADD CONSTRAINT `FK_txe_chemos_drugs`
  FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`); 

ALTER TABLE `pe_chemos`
  ADD CONSTRAINT `FK_pe_chemos_drugs`
  FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`); 
  
ALTER TABLE `txd_chemos`
  ADD CONSTRAINT `FK_txd_chemos_tx_masters`
  FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);
  
ALTER TABLE `txd_radiations`
  ADD CONSTRAINT `FK_txd_radiations_tx_masters`
  FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);  
  
ALTER TABLE `txd_surgeries`
  ADD CONSTRAINT `FK_txd_surgeries_tx_masters`
  FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);
  
ALTER TABLE `txe_chemos`
  ADD CONSTRAINT `FK_txe_chemos_tx_masters`
  FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);

ALTER TABLE `txe_radiations`
  ADD CONSTRAINT `FK_txe_radiations_tx_masters`
  FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);

ALTER TABLE `txe_surgeries`
  ADD CONSTRAINT `FK_txe_surgeries_tx_masters`
  FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);
  
INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_drug_system_error', 1, 'system error', 'a system error has been detected', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('err_drug_no_data', 1, 'data not found', 'no data exists for the specified id', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields where plugin = 'Drug' AND model = 'Drug' AND tablename = 'drugs' AND field = 'generic_name'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('drug is defined as a component of at least one participant chemotherapy', '', 
'The drug is defined as a component of at least one participant chemotherapy!' , 
'Le médicament est défini comme étant le composant d''au moins une chimiothérapie de participant!'),
('drug is defined as a component of at least one chemotherapy protocol', '', 
'The drug is defined as a component of at least one chemotherapy protocol!' , 
'Le médicament est défini comme étant le composant d''au moins un protocole de chimiothérapie!'),
('protocol is defined as protocol of at least one participant treatment', '', 
'The protocol is defined as protocol of at least one participant treatment!' ,
'Le protocole est définie comme étant le protocole d''au moins un traitement de participant!'),
('at least one drug is defined as protocol component', '', 
'At least one drug is defined as protocol component!' ,'Au moins un médicament est défini comme étant un composant du protocole!'),
('at least one drug is defined as treatment component', '', 
'At least one drug is defined as treatment component!' ,'Au moins un médicament est défini comme étant un composant du traitement!'),
('groups', '', 'Groups', 'Groupes'),
("banks", "", "Banks", "Banques"),
("permissions", "", "Permissions", "Permissions"),
("preferences", "", "Preferences", "Prférences"),
("user logs", "", "User logs", "Journaux utilisateurs"),
("messages", "", "Messages", "Messages"),
("announcement", "", "Announcement", "Annonces"),
("import from associated protocol", "", "Import from associated protocol", "Importer à partir du protocole associé"),
("drugs from the associated protocol were imported", "", "Drugs from the associated protocol were imported", "Les drogues associées au protocole ont été importées"),
("there is no protocol associated with this treatment", "", "There is no protocol associated with this treatment", "Il n'y a pas de protocole associé à ce traitement"),
("there is no drug defined in the associated protocol", "", "There is no drug defined in the associated protocol", "Il n'y a pas de drogue définie avec le traitement associé"),
("this name is already in use", "", "This name is already in use", "Ce nom est déjà utilisé"),
("bank", "", "Bank", "Banque"),
("no additional data has to be defined for this type of treatment", "", "No additional data has to be defined for this type of treatment", "Pas de données additionnelles pour ce type de traitement"),
("pagination", "", "Pagination", "Pagination"),
("time format", "", "Time format", "Format de l'heure"),
("datetime input type", "", "Datetime input time", "Foramat des champs dates et heures"),
("dropdown", "", "Dropdown", "Menu déroulant"),
("textual", "", "Textual", "Textuel"),
("remove from batch set", "", "Remove from batch set", "Retirer de l'ensemble de données"),
("export as CSV file (comma-separated values)", "", "Export as CSV file (Comma-separated values)", "Exporter comme fichier CSV (Comma-separated values)"); 


INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_pro_system_error', 1, 'system error', 'a system error has been detected', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('err_pro_no_data', 1, 'data not found', 'no data exists for the specified id', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields where plugin = 'Protocol' AND model = 'ProtocolExtend' AND tablename = 'pe_chemos' AND field = 'drug_id'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
(null, (SELECT id FROM structure_fields where plugin = 'Clinicalannotation' AND model = 'TreatmentExtend' AND tablename = 'txe_chemos' AND field = 'drug_id'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

-- pagination fix
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Administrate', 'Config', 'configs', 'define_pagination_amount', 'pagination', '', 'select', '', '5', (SELECT id FROM structure_value_domains WHERE domain_name='pagination') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='preferences'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_pagination_amount' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pagination')  ), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');
DELETE FROM structure_formats WHERE `structure_id`='4' AND `structure_field_id`='94' AND `display_column`='1' AND `display_order`='12' AND `language_heading`='' AND `flag_override_label`='0' AND `language_label`='' AND `flag_override_tag`='0' AND `language_tag`='' AND `flag_override_help`='0' AND `language_help`='' AND `flag_override_type`='0' AND `type`='' AND `flag_override_setting`='0' AND `setting`='' AND `flag_override_default`='0' AND `default`='' AND `flag_add`='1' AND `flag_add_readonly`='0' AND `flag_edit`='1' AND `flag_edit_readonly`='0' AND `flag_search`='0' AND `flag_search_readonly`='0' AND `flag_datagrid`='0' AND `flag_datagrid_readonly`='0' AND `flag_index`='0' AND `flag_detail`='1' AND `created`='0000-00-00 00:00:00' AND `created_by`='0' AND `modified`='2010-02-12 00:00:00' AND `modified_by`='0' ;
ALTER TABLE `users` DROP `pagination`;

-- bank restructuring
ALTER TABLE `groups` DROP `bank_id`;
ALTER TABLE `groups` 
  ADD `bank_id` INT DEFAULT NULL AFTER  `name`,
  ADD FOREIGN KEY (`bank_id`) REFERENCES `banks`(`id`);
DELETE FROM menus WHERE use_link LIKE '%bank%';

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('core_CAN_41', 'core_CAN_33', 1, 1, 'core_administrate', 'administration description', '/administrate/groups', '', '', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1', 'core_CAN_41', 0, 1, 'groups', '', '/administrate/groups/index', '', '', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_1', 'core_CAN_41_1', 0, 1, 'details', '', '/administrate/groups/detail/%%Group.id%%/', '', 'Group::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_2', 'core_CAN_41_1', 0, 2, 'permissions', '', '/administrate/permissions/tree/%%Group.id%%/', '', 'Group::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_3', 'core_CAN_41_1', 0, 3, 'users', '', '/administrate/users/listall/%%Group.id%%/', '', 'Group::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_3_1', 'core_CAN_41_1_3', 0, 1, 'profile', '', '/administrate/users/detail/%%Group.id%%/%%User.id%%/', '', 'User::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_3_2', 'core_CAN_41_1_3', 0, 2, 'preferences', '', '/administrate/preferences/index/%%Group.id%%/%%User.id%%/', '', 'User::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_3_3', 'core_CAN_41_1_3', 0, 3, 'password', '', '/administrate/passwords/index/%%Group.id%%/%%User.id%%/', '', 'User::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_3_4', 'core_CAN_41_1_3', 0, 4, 'user logs', '', '/administrate/user_logs/index/%%Group.id%%/%%User.id%%/', '', 'User::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_1_3_5', 'core_CAN_41_1_3', 0, 5, 'messages', '', '/administrate/announcements/index/%%Group.id%%/%%User.id%%/', '', 'User::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_2', 'core_CAN_41', 0, 2, 'banks', '', '/administrate/banks/index', '', '', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_2_1', 'core_CAN_41_2', 0, 1, 'detail', '', '/administrate/banks/detail/%%Bank.id%%/', '', 'Bank::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('core_CAN_41_2_2', 'core_CAN_41_2', 0, 2, 'announcements', '', '/administrate/announcements/index/%%Bank.id%%/', '', 'Bank::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('banks', '', '', 'Administrate.Bank::getBankPermissibleValues');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', '', 'Group', 'groups', 'bank_id', 'bank', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='groups'), (SELECT id FROM structure_fields WHERE `model`='Group' AND `tablename`='groups' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  ), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '0', '0', '1', '1');

-- drugs dropdown
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('drugs', '', '', 'Drug.Drug::getDrugPermissibleValues');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Protocol', 'ProtocolExtend', 'pe_chemos', 'drug_id', 'drug', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='drugs') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='pe_chemos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtend' AND `tablename`='pe_chemos' AND `field`='drug_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drugs')  ), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');
DELETE FROM structure_formats WHERE `structure_id`='125' AND `structure_field_id`='572' AND `display_column`='1' AND `display_order`='1' AND `language_heading`='' AND `flag_override_label`='0' AND `language_label`='' AND `flag_override_tag`='0' AND `language_tag`='' AND `flag_override_help`='0' AND `language_help`='' AND `flag_override_type`='0' AND `type`='' AND `flag_override_setting`='0' AND `setting`='' AND `flag_override_default`='0' AND `default`='' AND `flag_add`='1' AND `flag_add_readonly`='0' AND `flag_edit`='1' AND `flag_edit_readonly`='0' AND `flag_search`='0' AND `flag_search_readonly`='0' AND `flag_datagrid`='1' AND `flag_datagrid_readonly`='0' AND `flag_index`='1' AND `flag_detail`='1' AND `created`='0000-00-00 00:00:00' AND `created_by`='0' AND `modified`='2010-02-12 00:00:00' AND `modified_by`='0' ;

-- unique groups
ALTER TABLE groups ADD UNIQUE KEY (`name`);

ALTER TABLE `tx_controls` ADD `allow_administration` BOOLEAN NOT NULL;
UPDATE tx_controls SET allow_administration=true WHERE tx_method='chemotherapy';

-- Update protocol master form

UPDATE structure_formats 
SET display_order = '10'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'protocol_masters' AND field = 'name');

UPDATE structure_formats 
SET display_order = '11'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'protocol_masters' AND field = 'arm');

UPDATE structure_formats 
SET display_order = '1',
flag_edit_readonly = '1'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'protocol_masters' AND field = 'code');

UPDATE structure_formats 
SET flag_datagrid = '0',
flag_datagrid_readonly = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'protocol_masters');

UPDATE structure_formats 
SET flag_search = '0',
flag_search_readonly = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'protocol_masters' AND field IN ('notes'));

UPDATE `structure_validations`
SET structure_field_id = (SELECT id FROM structure_fields WHERE plugin = 'Protocol' AND model = 'ProtocolExtend'
AND tablename = 'pe_chemos' AND field = 'drug_id' AND structure_value_domain IS NOT NULL)
WHERE `structure_field_id`
IN (SELECT id FROM structure_fields WHERE plugin = 'Protocol' AND model = 'ProtocolExtend'
AND tablename = 'pe_chemos' AND field = 'drug_id' AND structure_value_domain IS NULL);

DELETE FROM structure_fields
WHERE plugin = 'Protocol'
AND model = 'ProtocolExtend'
AND tablename = 'pe_chemos'
AND field = 'drug_id'
AND structure_value_domain IS NULL;

DELETE FROM `structure_value_domains_permissible_values`
WHERE `structure_value_domain_id` IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'protocol type');

UPDATE `structure_value_domains` 
SET source = 'Protocol.ProtocolControl::getProtocolTypePermissibleValues'
WHERE `domain_name` LIKE 'protocol type';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'protocol tumour group', 'open', '', 'Protocol.ProtocolControl::getProtocolTumourGroupPermissibleValues');

SET @protocol_tumour_group_domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @protocol_tumour_group_domain_id
WHERE plugin = 'Protocol' AND model = 'ProtocolMaster' AND tablename = 'protocol_masters' AND field = 'tumour_group';

UPDATE `structure_fields` SET `public_identifier` = 'DE-17'
WHERE `field` = 'participant_identifier' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-18'
WHERE `field` = 'notes' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-3'
WHERE `field` = 'date_of_birth' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-7'
WHERE `field` = 'secondary_cod_icd10_code' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-8'
WHERE `field` = 'title' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-9'
WHERE `field` = 'first_name' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-6'
WHERE `field` = 'cod_icd10_code' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-5'
WHERE `field` = 'date_of_death' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-4'
WHERE `field` = 'dob_date_accuracy' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-4'
WHERE `field` = 'dod_date_accuracy' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-2'
WHERE `field` = 'last_chart_checked_date' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-16'
WHERE `field` = 'vital_status' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-15'
WHERE `field` = 'sex' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-14'
WHERE `field` = 'race' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-13'
WHERE `field` = 'marital_status' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-12'
WHERE `field` = 'language_preferred' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-11'
WHERE `field` = 'last_name' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-1'
WHERE `field` = 'cod_confirmation_source' AND `tablename` = 'participants' AND `model` = 'Participant';

UPDATE `structure_fields` SET `public_identifier` = 'DE-10'
WHERE `field` = 'middle_name' AND `tablename` = 'participants' AND `model` = 'Participant';

-- Update consent identifiers

UPDATE `structure_fields` SET `public_identifier` = 'DE-18'
WHERE `field` = 'notes' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-65'
WHERE `field` = 'date_of_referral' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-48'
WHERE `field` = 'facility' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-78'
WHERE `field` = 'translator_indicator' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-79'
WHERE `field` = 'translator_signature' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-77'
WHERE `field` = 'consent_person' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-76'
WHERE `field` = 'operation_date' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-75'
WHERE `field` = 'surgeon' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-74'
WHERE `field` = 'reason_denied' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-73'
WHERE `field` = 'consent_method' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-72'
WHERE `field` = 'status_date' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-66'
WHERE `field` = 'route_of_referral' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-67'
WHERE `field` = 'date_first_contact' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-68'
WHERE `field` = 'consent_signed_date' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-69'
WHERE `field` = 'form_version' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-70'
WHERE `field` = 'consent_status' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

UPDATE `structure_fields` SET `public_identifier` = 'DE-71'
WHERE `field` = 'process_status' AND `tablename` = 'consent_masters' AND `model` = 'ConsentMaster';

-- Update family history identifiers
UPDATE `structure_fields` SET `public_identifier` = 'DE-20'
WHERE `field` = 'family_domain' AND `tablename` = 'family_histories' AND `model` = 'FamilyHistory';

UPDATE `structure_fields` SET `public_identifier` = 'DE-21'
WHERE `field` = 'relation' AND `tablename` = 'family_histories' AND `model` = 'FamilyHistory';

UPDATE `structure_fields` SET `public_identifier` = 'DE-22'
WHERE `field` = 'primary_icd10_code' AND `tablename` = 'family_histories' AND `model` = 'FamilyHistory';

UPDATE `structure_fields` SET `public_identifier` = 'DE-23'
WHERE `field` = 'previous_primary_code' AND `tablename` = 'family_histories' AND `model` = 'FamilyHistory';

UPDATE `structure_fields` SET `public_identifier` = 'DE-24'
WHERE `field` = 'previous_primary_code_system' AND `tablename` = 'family_histories' AND `model` = 'FamilyHistory';

UPDATE `structure_fields` SET `public_identifier` = 'DE-19'
WHERE `field` = 'age_at_dx' AND `tablename` = 'family_histories' AND `model` = 'FamilyHistory';

UPDATE `structure_fields` SET `public_identifier` = 'DE-25'
WHERE `field` = 'age_at_dx_accuracy' AND `tablename` = 'family_histories' AND `model` = 'FamilyHistory';

-- Update misc identifiers
UPDATE `structure_fields` SET `public_identifier` = 'DE-117'
WHERE `field` = 'identifier_name' AND `tablename` = 'misc_identifiers' AND `model` = 'MiscIdentifier';

UPDATE `structure_fields` SET `public_identifier` = 'DE-118'
WHERE `field` = 'identifier_abrv' AND `tablename` = 'misc_identifiers' AND `model` = 'MiscIdentifier';

UPDATE `structure_fields` SET `public_identifier` = 'DE-18'
WHERE `field` = 'notes' AND `tablename` = 'misc_identifiers' AND `model` = 'MiscIdentifier';

UPDATE `structure_fields` SET `public_identifier` = 'DE-120'
WHERE `field` = 'effective_date' AND `tablename` = 'misc_identifiers' AND `model` = 'MiscIdentifier';

UPDATE `structure_fields` SET `public_identifier` = 'DE-121'
WHERE `field` = 'expiry_date' AND `tablename` = 'misc_identifiers' AND `model` = 'MiscIdentifier';

UPDATE `structure_fields` SET `public_identifier` = 'DE-119'
WHERE `field` = 'identifier_value' AND `tablename` = 'misc_identifiers' AND `model` = 'MiscIdentifier';

ALTER TABLE `structure_fields` DROP INDEX `unique_fields`;

ALTER TABLE `structure_fields`
	CHANGE `plugin` `plugin` VARCHAR( 150 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
	CHANGE `model` `model` VARCHAR( 150 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
	CHANGE `tablename` `tablename` VARCHAR( 150 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
	CHANGE `field` `field` VARCHAR( 150 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';

ALTER TABLE `structure_fields` ADD UNIQUE `unique_fields` (`field`, `model` , `tablename`);

-- Use model funtion to populate storage fields value domain

DELETE FROM `structure_value_domains_permissible_values`
WHERE `structure_value_domain_id` IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'storage_type');

UPDATE `structure_value_domains` 
SET source = 'StorageLayout.StorageControl::getStorageTypePermissibleValues'
WHERE `domain_name` LIKE 'storage_type';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'parent_storages', 'open', '', 'StorageLayout.StorageMaster::getParentStoragePermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id
WHERE plugin = 'Storagelayout'
AND model = 'StorageMaster'
AND tablename = 'storage_masters'
AND field = 'parent_id';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'tma_sop_list', 'open', '', 'Sop.SopMaster::getTmaBlockSopPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id ,
tablename = 'std_tma_blocks'
WHERE plugin = 'Storagelayout'
AND model = 'StorageDetail'
AND field = 'sop_master_id';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'tma_slide_sop_list', 'open', '', 'Sop.SopMaster::getTmaSlideSopPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Storagelayout'
AND model = 'TmaSlide'
AND field = 'sop_master_id';
 	 	 	
-- Use model funtion to populate order fields value domain

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'study_list', 'open', '', 'Study.StudySummary::getStudyPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Order'
AND model = 'Order'
AND field = 'study_summary_id';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'aliquot_type_list', 'open', '', 'Inventorymanagement.AliquotControl::getAliquotTypePermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Order'
AND model = 'OrderLine'
AND field = 'aliquot_control_id';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'sample_type_list', 'open', '', 'Inventorymanagement.SampleControl::getSampleTypePermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Order'
AND model = 'OrderLine'
AND field = 'sample_control_id';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'sample_aliquot_type_list', 'open', '', 'Inventorymanagement.SampleToAliquotControl::getSampleAliquotTypesPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Order'
AND model = 'FunctionManagement'
AND field = 'sample_aliquot_control_id';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'shipment_list', 'open', '', 'Order.Shipment::getShipmentPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Order'
AND model = 'OrderItem'
AND field = 'shipment_id';

SET @domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'banks');

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Inventorymanagement'
AND field = 'bank_id';

-- Missing language aliases
DELETE FROM `i18n` WHERE `id` IN 
('newpassword', 'confirmpassword');
INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
('newpassword', '', 'New Password', 'Nouveau mot de passe'),
('confirmpassword', '', 'Confirm Password', 'Confirmez le mot de passe');

-- Use model funtion to populate inventory fields value domain

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'collection_sop_list', 'open', '', 'Sop.SopMaster::getCollectionSopPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Inventorymanagement'
AND model = 'Collection'
AND field = 'sop_master_id';

UPDATE structure_fields
SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'collection_sop_list') 
WHERE plugin = 'Inventorymanagement'
AND model = 'ViewCollection'
AND field = 'sop_master_id';

DELETE FROM `structure_value_domains_permissible_values`
WHERE `structure_value_domain_id` IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'sample_type');

UPDATE `structure_value_domains` 
SET source = 'Inventorymanagement.SampleControl::getSampleTypePermissibleValues'
WHERE `domain_name` LIKE 'sample_type';

UPDATE `structure_value_domains` 
SET source = 'Inventorymanagement.SampleControl::getSampleTypePermissibleValuesFromId',
domain_name = 'sample_type_from_id'
WHERE `domain_name` LIKE 'sample_type_list';

DELETE FROM `structure_value_domains_permissible_values`
WHERE `structure_value_domain_id` IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'sample_type');

UPDATE `structure_value_domains` 
SET source = 'Inventorymanagement.SampleControl::getSpecimenSampleTypePermissibleValues'
WHERE `domain_name` LIKE 'specimen_sample_type';

DELETE FROM `structure_value_domains_permissible_values`
WHERE `structure_value_domain_id` IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'specimen_sample_type');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'sample_sop_list', 'open', '', 'Sop.SopMaster::getSampleSopPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Inventorymanagement'
AND model = 'SampleMaster'
AND field = 'sop_master_id';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'tissue_source_list', 'open', '', 'Inventorymanagement.SampleDetail::getTissueSourcePermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id,
tablename = 'sd_spe_tissues'
WHERE plugin = 'Inventorymanagement'
AND model = 'SampleDetail'
AND field = 'tissue_source';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'aliquot_sop_list', 'open', '', 'Sop.SopMaster::getAliquotSopPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET structure_value_domain = @domain_id 
WHERE plugin = 'Inventorymanagement'
AND model = 'AliquotMaster'
AND field = 'sop_master_id';

UPDATE structure_fields
SET structure_value_domain = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'study_list') 
WHERE plugin = 'Inventorymanagement'
AND model = 'AliquotMaster'
AND field = 'study_summary_id';

UPDATE structure_fields
SET structure_value_domain = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'study_list') 
WHERE plugin = 'Inventorymanagement'
AND model = 'AliquotUse'
AND field = 'study_summary_id';

UPDATE `structure_value_domains` 
SET source = 'Inventorymanagement.AliquotControl::getAliquotTypePermissibleValuesFromId',
domain_name = 'aliquot_type_from_id'
WHERE `domain_name` LIKE 'aliquot_type_list';

DELETE FROM `structure_value_domains_permissible_values`
WHERE `structure_value_domain_id` IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'aliquot_type');

UPDATE `structure_value_domains` 
SET source = 'Inventorymanagement.AliquotControl::getAliquotTypePermissibleValues'
WHERE `domain_name` LIKE 'aliquot_type';

-- Add correction on flag and tag for fields displayed into inventory management module

UPDATE structure_formats 
SET flag_override_label = 0,
language_label = '' 
WHERE structure_field_id IN (SELECT id FROM  `structure_fields`
WHERE `field` LIKE 'collected_volume');

UPDATE structure_fields SET language_label = 'laterality' WHERE language_label = 'Laterality';

-- Update domain name called status

UPDATE structure_value_domains
SET domain_name = 'processing_status'
WHERE domain_name = 'status 1';

UPDATE structure_value_domains
SET domain_name = 'order_item_status'
WHERE domain_name = 'status 2';

UPDATE structure_value_domains
SET domain_name = 'order_line_status'
WHERE domain_name = 'status 3';

UPDATE structure_value_domains
SET domain_name = 'chemotherapy_method'
WHERE domain_name = 'method 1';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('no aliquot has been defined as realiquoted child', '', 
'No aliquot has been defined as realiquoted child!', 
'Aucun aliquot n''a été aliquot ré-aliquoté (enfant)!');

-- Use model funtion to populate clinicalannotation fields value domain

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'identifier_name_list', 'open', '', 'Clinicalannotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET `type` = 'select',
setting = '',
structure_value_domain = @domain_id 
WHERE plugin = 'Clinicalannotation'
AND model = 'MiscIdentifier'
AND field = 'identifier_name'; 

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'identifier_abrv_list', 'open', '', 'Clinicalannotation.MiscIdentifierControl::getMiscIdentifierNameAbrevPermissibleValues');

SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET `type` = 'select',
setting = '',
structure_value_domain = @domain_id 
WHERE plugin = 'Clinicalannotation'
AND model = 'MiscIdentifier'
AND field = 'identifier_abrv';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('this identifier has already been created for this participant', 
'', 'This identifier has already been created for this participant and can not be created more than once!',
'Cet identifiant a déjà été créé pour le participant et ne peut être créé plus d''une fois');

-- Add unique identifier flag

ALTER TABLE `misc_identifier_controls`
	ADD `flag_once_per_participant` tinyint(1) NOT NULL DEFAULT '0';

-- Add consent type to consent master view

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'consent_type_list', 'open', '', 'Clinicalannotation.ConsentControl::getConsentTypePermissibleValuesFromId');
	
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_control_id', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id'), 
'1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Add diagnosis type to consent master view

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'diagnosis_type_list', 'open', '', 'Clinicalannotation.DiagnosisControl::getDiagnosisTypePermissibleValuesFromId');
	
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'diagnosis_control_id', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type_list') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='diagnosis_control_id'), 
'1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Add event_disease_site and type to event master view

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'event_disease_site_list', 'open', '', 'Clinicalannotation.EventControl::getEventDiseaseSitePermissibleValues');
	
SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET `type` = 'select',
setting = '',
structure_value_domain = @domain_id 
WHERE plugin = 'Clinicalannotation'
AND model = 'EventMaster'
AND field = 'disease_site';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'event_type_list', 'open', '', 'Clinicalannotation.EventControl::getEventTypePermissibleValues');
	
SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET `type` = 'select',
setting = '',
structure_value_domain = @domain_id 
WHERE plugin = 'Clinicalannotation'
AND model = 'EventMaster'
AND field = 'event_type';

-- add model function to build treatment list like type, disease, protocol

DELETE FROM `structure_value_domains_permissible_values`
WHERE `structure_value_domain_id` IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'disease site 2');

UPDATE structure_value_domains 
SET domain_name = 'tx_disease_site_list',
`source` = 'Clinicalannotation.TreatmentControl::getDiseaseSitePermissibleValues'
WHERE domain_name = 'disease site 2';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'tx_method_site_list', 'open', '', 'Clinicalannotation.TreatmentControl::getMethodPermissibleValues');
	
SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET `type` = 'select',
setting = '',
structure_value_domain = @domain_id 
WHERE plugin = 'Clinicalannotation'
AND model = 'TreatmentMaster'
AND field = 'tx_method';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES
(null, 'protocol_site_list', 'open', '', 'Protocol.ProtocolMaster::getProtocolPermissibleValuesFromId');
	
SET @domain_id = LAST_INSERT_ID();

UPDATE structure_fields
SET `type` = 'select',
setting = '',
structure_value_domain = @domain_id 
WHERE plugin = 'Clinicalannotation'
AND model = 'TreatmentMaster'
AND field = 'protocol_master_id';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site'), 
'1', '0', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats
SET `flag_override_label` = '1', `language_label` = '',
`flag_override_tag` = '1', `language_tag` = '-', `flag_edit_readonly` = '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias='treatmentmasters')
AND `structure_field_id` IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method');

UPDATE structure_fields SET `language_label` = ''
WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method';

-- add model function to build drug list for participant protocol

UPDATE structure_value_domains SET domain_name = 'drug_list'
WHERE domain_name = 'drugs';

UPDATE structure_fields
SET `type` = 'select',
setting = '',
structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'drug_list')
WHERE plugin = 'Clinicalannotation'
AND model = 'TreatmentExtend'
AND field = 'drug_id';

-- Acos
TRUNCATE acos;


UPDATE menus SET language_title = 'precision' WHERE id = 'clin_CAN_80';

INSERT IGNORE INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
('precision', 'global', 'Precision', 'Précision'),
('storage initial temperature', '', 'Storage initial temperature', "Température initiale de l'entreposage"),
('from', '', 'From', 'De');

-- Swap value dead with deceased for health_status
INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('deceased', 'deceased');

SET @value_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'health_status'), @value_id, 2, 1, 'deceased');

DELETE FROM `structure_value_domains_permissible_values` 
WHERE `structure_value_domain_id` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'health_status') AND
`structure_permissible_value_id` = (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'dead');

DELETE FROM `structure_permissible_values`
WHERE `value` = 'dead';

INSERT IGNORE INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
('deceased', 'global', 'Deceased', 'Décédé'),
("a system error has been detected", "", "A system error has been detected", "Une erreur système a été détectée"),
("DMY", "", "DMY", "JMA"),
("end", "", "End", "Fin"),
("health card nbr", "", "Health card number", "Numéro de carte santé"),
#("HD", "", "", ""),
#("HOSP", "", "", ""),
("hospital nbr", "", "Hospital number", "Numéro d'hôpital"),
("MDY", "", "MDY", "MJA"),
#("OTHER#", "", "", ""),
#("OV#", "", "", ""),
#("ovary bank no lab", "", "", ""),
("participant", "", "Participant", "Participant"),
("password verification", "", "Password verification", "Vérification du mot de passe"),
("PBMC Tube", "", "PBMC Tube", "Tube de PBMC"),
#("PR#", "", "", ""),
#("prostate bank no lab", "", "", ""),
("start", "", "Start", "Départ"),
("state", "", "State", "Étât"),
#("Watson th", "", "", ""),
("YMD", "", "YMD", "AMJ");


UPDATE participants SET vital_status='deceased' WHERE vital_status='dead';

-- Clean up storage layout display

UPDATE storage_controls SET display_x_size = '1', display_y_size = '10' WHERE storage_type = 'rack10';
UPDATE storage_controls SET display_x_size = '1', display_y_size = '24' WHERE storage_type = 'rack24';
UPDATE storage_controls SET display_x_size = '1', display_y_size = '11' WHERE storage_type = 'rack11';
UPDATE storage_controls SET display_x_size = '1', display_y_size = '9' WHERE storage_type = 'rack9';
UPDATE storage_controls SET display_x_size = '5', display_y_size = '5' WHERE storage_type = 'box25';

-- demo data script has been created at this level tmp_v2.0.2_demo_data.sql