-- Version: v2.0.2
-- Description: This SQL script is an upgrade for ATiM v2.0.1. to 2.0.2. and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.2', `date_installed` = CURDATE(), `build_number` = ''
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
 
-- Fix english translation for diagnosis   
UPDATE `i18n` 
SET `en` = 'Diagnosis' 
WHERE `id` = 'diagnosis';

-- add missing translation
INSERT IGNORE INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
('Prev', 'global', 'Prev', 'Préc'),
('Next', 'global', 'Next', 'Suiv'),
('Details', 'global', 'Details', 'Détails'),
('event', 'global', 'Event', 'Événement');

DELETE FROM `i18n` WHERE `id` IN 
('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('jan', '', 'Jan', 'Jan'),
('feb', '', 'Feb', 'Fév'),
('mar', '', 'Mar', 'Mars'),
('apr', '', 'Apr', 'Avr'),
('may', '', 'May', 'Mai'),
('jun', '', 'Jun', 'Jun'),
('jul', '', 'Jul', 'Jul'),
('aug', '', 'Aug', 'Aoû'),
('sep', '', 'Sep', 'Sep'),
('oct', '', 'Oct', 'Oct'),
('nov', '', 'Nov', 'Nov'),
('dec', '', 'Dec', 'Déc');

DELETE FROM `i18n` WHERE `id` IN 
('locked', 'define_date_format', 'define_csv_separator', 
'define_show_summary', 'help visible', 'language', 'English', 
'French', 'core_pagination');
INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
('locked', '', 'Locked', 'Bloqué'),
('define_date_format', '', 'Date Format', 'Format de date'),
('define_csv_separator', '', 'CSV Separator', 'Séparateur de CSV'),
('define_show_summary', '', 'Show Summary', 'Voir les sommaires'),
('help visible', '', 'Help Visible', 'Aide visible'),
('language', '', 'Language', 'Lanque'),
('English', '', 'English', 'Anglais'),
('French', '', 'French', 'Français'),
('core_pagination', '', 'pagination', 'pagination');

DELETE FROM `i18n` WHERE `id` IN 
('Login');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('Login', '', 'Login', 'Connection');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('May', 'global', 'May', 'Mai'),
('decimal separator', '', 'Decimal separator', 'Séparateur de décimales'),
("error_must_be_integer", "", "Error - Integer value expected", "Erreur - Valeur entière attendue"),
("error_must_be_positive_integer", "", "Error - Positive integer value expected", "Erreur - Valeur entière positive attendue"),
("error_must_be_float", "", "Error - Float value expected", "Erreur - Valeur flottante attendue"),
("error_must_be_positive_float", "", "Error - Positive float value expected", "Erreur - Valeur flottante positive attendue");


-- i18n text fields update
ALTER TABLE i18n
 CHANGE `en` `en` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
 CHANGE `fr` `fr` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;
 
REPLACE INTO i18n (id, page_id, en, fr) VALUES 
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

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
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
'At least one drug is defined as treatment component!' ,'Au moins un médicament est défini comme étant un composant du traitement!');

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_pro_system_error', 1, 'system error', 'a system error has been detected', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('err_pro_no_data', 1, 'data not found', 'no data exists for the specified id', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields where plugin = 'Protocol' AND model = 'ProtocolExtend' AND tablename = 'pe_chemos' AND field = 'drug_id'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
(null, (SELECT id FROM structure_fields where plugin = 'Clinicalannotation' AND model = 'TreatmentExtend' AND tablename = 'txe_chemos' AND field = 'drug_id'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

TRUNCATE acos;
INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(1, NULL, NULL, NULL, 'controllers', 1, 966),
(2, 1, NULL, NULL, 'Administrate', 2, 111),
(3, 2, NULL, NULL, 'Announcements', 3, 14),
(4, 3, NULL, NULL, 'add', 4, 5),
(5, 3, NULL, NULL, 'index', 6, 7),
(6, 3, NULL, NULL, 'detail', 8, 9),
(7, 3, NULL, NULL, 'edit', 10, 11),
(8, 3, NULL, NULL, 'delete', 12, 13),
(9, 2, NULL, NULL, 'Banks', 15, 26),
(10, 9, NULL, NULL, 'add', 16, 17),
(11, 9, NULL, NULL, 'index', 18, 19),
(12, 9, NULL, NULL, 'detail', 20, 21),
(13, 9, NULL, NULL, 'edit', 22, 23),
(14, 9, NULL, NULL, 'delete', 24, 25),
(15, 2, NULL, NULL, 'Groups', 27, 38),
(16, 15, NULL, NULL, 'index', 28, 29),
(17, 15, NULL, NULL, 'detail', 30, 31),
(18, 15, NULL, NULL, 'add', 32, 33),
(19, 15, NULL, NULL, 'edit', 34, 35),
(20, 15, NULL, NULL, 'delete', 36, 37),
(21, 2, NULL, NULL, 'Menus', 39, 48),
(22, 21, NULL, NULL, 'index', 40, 41),
(23, 21, NULL, NULL, 'detail', 42, 43),
(24, 21, NULL, NULL, 'edit', 44, 45),
(25, 21, NULL, NULL, 'add', 46, 47),
(26, 2, NULL, NULL, 'Passwords', 49, 52),
(27, 26, NULL, NULL, 'index', 50, 51),
(28, 2, NULL, NULL, 'Permissions', 53, 66),
(29, 28, NULL, NULL, 'index', 54, 55),
(30, 28, NULL, NULL, 'regenerate', 56, 57),
(31, 28, NULL, NULL, 'update', 58, 59),
(32, 28, NULL, NULL, 'updatePermission', 60, 61),
(33, 28, NULL, NULL, 'tree', 62, 63),
(34, 28, NULL, NULL, 'addPermissionStateToThreadedData', 64, 65),
(35, 2, NULL, NULL, 'Preferences', 67, 72),
(36, 35, NULL, NULL, 'index', 68, 69),
(37, 35, NULL, NULL, 'edit', 70, 71),
(38, 2, NULL, NULL, 'StructureFormats', 73, 82),
(39, 38, NULL, NULL, 'listall', 74, 75),
(40, 38, NULL, NULL, 'detail', 76, 77),
(41, 38, NULL, NULL, 'edit', 78, 79),
(42, 38, NULL, NULL, 'add', 80, 81),
(43, 2, NULL, NULL, 'Structures', 83, 92),
(44, 43, NULL, NULL, 'index', 84, 85),
(45, 43, NULL, NULL, 'detail', 86, 87),
(46, 43, NULL, NULL, 'edit', 88, 89),
(47, 43, NULL, NULL, 'add', 90, 91),
(48, 2, NULL, NULL, 'UserLogs', 93, 96),
(49, 48, NULL, NULL, 'index', 94, 95),
(50, 2, NULL, NULL, 'Users', 97, 106),
(51, 50, NULL, NULL, 'listall', 98, 99),
(52, 50, NULL, NULL, 'detail', 100, 101),
(53, 50, NULL, NULL, 'add', 102, 103),
(54, 50, NULL, NULL, 'edit', 104, 105),
(55, 2, NULL, NULL, 'Versions', 107, 110),
(56, 55, NULL, NULL, 'detail', 108, 109),
(57, 1, NULL, NULL, 'App', 112, 153),
(58, 57, NULL, NULL, 'Groups', 113, 124),
(59, 58, NULL, NULL, 'index', 114, 115),
(60, 58, NULL, NULL, 'view', 116, 117),
(61, 58, NULL, NULL, 'add', 118, 119),
(62, 58, NULL, NULL, 'edit', 120, 121),
(63, 58, NULL, NULL, 'delete', 122, 123),
(64, 57, NULL, NULL, 'Menus', 125, 130),
(65, 64, NULL, NULL, 'index', 126, 127),
(66, 64, NULL, NULL, 'update', 128, 129),
(67, 57, NULL, NULL, 'Pages', 131, 134),
(68, 67, NULL, NULL, 'display', 132, 133),
(69, 57, NULL, NULL, 'Posts', 135, 146),
(70, 69, NULL, NULL, 'index', 136, 137),
(71, 69, NULL, NULL, 'view', 138, 139),
(72, 69, NULL, NULL, 'add', 140, 141),
(73, 69, NULL, NULL, 'edit', 142, 143),
(74, 69, NULL, NULL, 'delete', 144, 145),
(75, 57, NULL, NULL, 'Users', 147, 152),
(76, 75, NULL, NULL, 'login', 148, 149),
(77, 75, NULL, NULL, 'logout', 150, 151),
(78, 1, NULL, NULL, 'Clinicalannotation', 154, 371),
(79, 78, NULL, NULL, 'ClinicalCollectionLinks', 155, 168),
(80, 79, NULL, NULL, 'listall', 156, 157),
(81, 79, NULL, NULL, 'detail', 158, 159),
(82, 79, NULL, NULL, 'add', 160, 161),
(83, 79, NULL, NULL, 'edit', 162, 163),
(84, 79, NULL, NULL, 'delete', 164, 165),
(85, 79, NULL, NULL, 'allowClinicalCollectionLinkDeletion', 166, 167),
(86, 78, NULL, NULL, 'ConsentMasters', 169, 182),
(87, 86, NULL, NULL, 'listall', 170, 171),
(88, 86, NULL, NULL, 'detail', 172, 173),
(89, 86, NULL, NULL, 'add', 174, 175),
(90, 86, NULL, NULL, 'edit', 176, 177),
(91, 86, NULL, NULL, 'delete', 178, 179),
(92, 86, NULL, NULL, 'allowConsentDeletion', 180, 181),
(93, 78, NULL, NULL, 'DiagnosisMasters', 183, 198),
(94, 93, NULL, NULL, 'listall', 184, 185),
(95, 93, NULL, NULL, 'detail', 186, 187),
(96, 93, NULL, NULL, 'add', 188, 189),
(97, 93, NULL, NULL, 'edit', 190, 191),
(98, 93, NULL, NULL, 'delete', 192, 193),
(99, 93, NULL, NULL, 'allowDiagnosisDeletion', 194, 195),
(100, 93, NULL, NULL, 'buildAndSetExistingDx', 196, 197),
(101, 78, NULL, NULL, 'EventMasters', 199, 238),
(102, 101, NULL, NULL, 'listall', 200, 201),
(103, 101, NULL, NULL, 'detail', 202, 203),
(104, 101, NULL, NULL, 'add', 204, 205),
(105, 101, NULL, NULL, 'edit', 206, 207),
(106, 101, NULL, NULL, 'delete', 208, 209),
(107, 101, NULL, NULL, 'allowEventDeletion', 210, 211),
(108, 78, NULL, NULL, 'FamilyHistories', 239, 252),
(109, 108, NULL, NULL, 'listall', 240, 241),
(110, 108, NULL, NULL, 'detail', 242, 243),
(111, 108, NULL, NULL, 'add', 244, 245),
(112, 108, NULL, NULL, 'edit', 246, 247),
(113, 108, NULL, NULL, 'delete', 248, 249),
(114, 108, NULL, NULL, 'allowFamilyHistoryDeletion', 250, 251),
(115, 78, NULL, NULL, 'MiscIdentifiers', 253, 270),
(116, 115, NULL, NULL, 'index', 254, 255),
(117, 115, NULL, NULL, 'search', 256, 257),
(118, 115, NULL, NULL, 'listall', 258, 259),
(119, 115, NULL, NULL, 'detail', 260, 261),
(120, 115, NULL, NULL, 'add', 262, 263),
(121, 115, NULL, NULL, 'edit', 264, 265),
(122, 115, NULL, NULL, 'delete', 266, 267),
(123, 115, NULL, NULL, 'allowMiscIdentifierDeletion', 268, 269),
(124, 78, NULL, NULL, 'ParticipantContacts', 271, 284),
(125, 124, NULL, NULL, 'listall', 272, 273),
(126, 124, NULL, NULL, 'detail', 274, 275),
(127, 124, NULL, NULL, 'add', 276, 277),
(128, 124, NULL, NULL, 'edit', 278, 279),
(129, 124, NULL, NULL, 'delete', 280, 281),
(130, 124, NULL, NULL, 'allowParticipantContactDeletion', 282, 283),
(131, 78, NULL, NULL, 'ParticipantMessages', 285, 298),
(132, 131, NULL, NULL, 'listall', 286, 287),
(133, 131, NULL, NULL, 'detail', 288, 289),
(134, 131, NULL, NULL, 'add', 290, 291),
(135, 131, NULL, NULL, 'edit', 292, 293),
(136, 131, NULL, NULL, 'delete', 294, 295),
(137, 131, NULL, NULL, 'allowParticipantMessageDeletion', 296, 297),
(138, 78, NULL, NULL, 'Participants', 299, 316),
(139, 138, NULL, NULL, 'index', 300, 301),
(140, 138, NULL, NULL, 'search', 302, 303),
(141, 138, NULL, NULL, 'profile', 304, 305),
(142, 138, NULL, NULL, 'add', 306, 307),
(143, 138, NULL, NULL, 'edit', 308, 309),
(144, 138, NULL, NULL, 'delete', 310, 311),
(145, 138, NULL, NULL, 'allowParticipantDeletion', 312, 313),
(146, 138, NULL, NULL, 'chronology', 314, 315),
(147, 78, NULL, NULL, 'ProductMasters', 317, 320),
(148, 147, NULL, NULL, 'productsTreeView', 318, 319),
(149, 78, NULL, NULL, 'ReproductiveHistories', 321, 334),
(150, 149, NULL, NULL, 'listall', 322, 323),
(151, 149, NULL, NULL, 'detail', 324, 325),
(152, 149, NULL, NULL, 'add', 326, 327),
(153, 149, NULL, NULL, 'edit', 328, 329),
(154, 149, NULL, NULL, 'delete', 330, 331),
(155, 149, NULL, NULL, 'allowReproductiveHistoryDeletion', 332, 333),
(156, 78, NULL, NULL, 'TreatmentExtends', 335, 350),
(157, 156, NULL, NULL, 'listall', 336, 337),
(158, 156, NULL, NULL, 'detail', 338, 339),
(159, 156, NULL, NULL, 'add', 340, 341),
(160, 156, NULL, NULL, 'edit', 342, 343),
(161, 156, NULL, NULL, 'delete', 344, 345),
(162, 78, NULL, NULL, 'TreatmentMasters', 351, 370),
(163, 162, NULL, NULL, 'listall', 352, 353),
(164, 162, NULL, NULL, 'detail', 354, 355),
(165, 162, NULL, NULL, 'edit', 356, 357),
(166, 162, NULL, NULL, 'add', 358, 359),
(167, 162, NULL, NULL, 'delete', 360, 361),
(168, 1, NULL, NULL, 'Codingicd10', 372, 379),
(169, 168, NULL, NULL, 'CodingIcd10s', 373, 378),
(170, 169, NULL, NULL, 'tool', 374, 375),
(171, 169, NULL, NULL, 'autoComplete', 376, 377),
(172, 1, NULL, NULL, 'Customize', 380, 403),
(173, 172, NULL, NULL, 'Announcements', 381, 386),
(174, 173, NULL, NULL, 'index', 382, 383),
(175, 173, NULL, NULL, 'detail', 384, 385),
(176, 172, NULL, NULL, 'Passwords', 387, 390),
(177, 176, NULL, NULL, 'index', 388, 389),
(178, 172, NULL, NULL, 'Preferences', 391, 396),
(179, 178, NULL, NULL, 'index', 392, 393),
(180, 178, NULL, NULL, 'edit', 394, 395),
(181, 172, NULL, NULL, 'Profiles', 397, 402),
(182, 181, NULL, NULL, 'index', 398, 399),
(183, 181, NULL, NULL, 'edit', 400, 401),
(184, 1, NULL, NULL, 'Datamart', 404, 453),
(185, 184, NULL, NULL, 'AdhocSaved', 405, 418),
(186, 185, NULL, NULL, 'index', 406, 407),
(187, 185, NULL, NULL, 'add', 408, 409),
(188, 185, NULL, NULL, 'search', 410, 411),
(189, 185, NULL, NULL, 'results', 412, 413),
(190, 185, NULL, NULL, 'edit', 414, 415),
(191, 185, NULL, NULL, 'delete', 416, 417),
(192, 184, NULL, NULL, 'Adhocs', 419, 434),
(193, 192, NULL, NULL, 'index', 420, 421),
(194, 192, NULL, NULL, 'favourite', 422, 423),
(195, 192, NULL, NULL, 'unfavourite', 424, 425),
(196, 192, NULL, NULL, 'search', 426, 427),
(197, 192, NULL, NULL, 'results', 428, 429),
(198, 192, NULL, NULL, 'process', 430, 431),
(199, 192, NULL, NULL, 'csv', 432, 433),
(200, 184, NULL, NULL, 'BatchSets', 435, 452),
(201, 200, NULL, NULL, 'index', 436, 437),
(202, 200, NULL, NULL, 'listall', 438, 439),
(203, 200, NULL, NULL, 'add', 440, 441),
(204, 200, NULL, NULL, 'edit', 442, 443),
(205, 200, NULL, NULL, 'delete', 444, 445),
(206, 200, NULL, NULL, 'process', 446, 447),
(207, 200, NULL, NULL, 'remove', 448, 449),
(208, 200, NULL, NULL, 'csv', 450, 451),
(209, 1, NULL, NULL, 'Drug', 454, 471),
(210, 209, NULL, NULL, 'Drugs', 455, 470),
(211, 210, NULL, NULL, 'index', 456, 457),
(212, 210, NULL, NULL, 'search', 458, 459),
(214, 210, NULL, NULL, 'add', 460, 461),
(215, 210, NULL, NULL, 'edit', 462, 463),
(216, 210, NULL, NULL, 'detail', 464, 465),
(217, 210, NULL, NULL, 'delete', 466, 467),
(218, 1, NULL, NULL, 'Inventorymanagement', 472, 589),
(219, 218, NULL, NULL, 'AliquotMasters', 473, 520),
(220, 219, NULL, NULL, 'index', 474, 475),
(221, 219, NULL, NULL, 'search', 476, 477),
(222, 219, NULL, NULL, 'listAll', 478, 479),
(223, 219, NULL, NULL, 'add', 480, 481),
(224, 219, NULL, NULL, 'detail', 482, 483),
(225, 219, NULL, NULL, 'edit', 484, 485),
(226, 219, NULL, NULL, 'removeAliquotFromStorage', 486, 487),
(227, 219, NULL, NULL, 'delete', 488, 489),
(228, 219, NULL, NULL, 'addAliquotUse', 490, 491),
(229, 219, NULL, NULL, 'editAliquotUse', 492, 493),
(230, 219, NULL, NULL, 'deleteAliquotUse', 494, 495),
(231, 219, NULL, NULL, 'addSourceAliquots', 496, 497),
(232, 219, NULL, NULL, 'listAllSourceAliquots', 498, 499),
(233, 219, NULL, NULL, 'defineRealiquotedChildren', 500, 501),
(234, 219, NULL, NULL, 'listAllRealiquotedParents', 502, 503),
(235, 219, NULL, NULL, 'getStudiesList', 504, 505),
(238, 219, NULL, NULL, 'getDefaultAliquotStorageDate', 506, 507),
(239, 219, NULL, NULL, 'isDuplicatedAliquotBarcode', 508, 509),
(240, 219, NULL, NULL, 'formatAliquotFieldDecimalData', 510, 511),
(241, 219, NULL, NULL, 'validateAliquotStorageData', 512, 513),
(242, 219, NULL, NULL, 'allowAliquotDeletion', 514, 515),
(243, 219, NULL, NULL, 'getDefaultRealiquotingDate', 516, 517),
(244, 219, NULL, NULL, 'formatPreselectedStoragesForDisplay', 518, 519),
(247, 218, NULL, NULL, 'Collections', 521, 536),
(248, 247, NULL, NULL, 'index', 522, 523),
(249, 247, NULL, NULL, 'search', 524, 525),
(250, 247, NULL, NULL, 'detail', 526, 527),
(251, 247, NULL, NULL, 'add', 528, 529),
(252, 247, NULL, NULL, 'edit', 530, 531),
(253, 247, NULL, NULL, 'delete', 532, 533),
(254, 247, NULL, NULL, 'allowCollectionDeletion', 534, 535),
(255, 218, NULL, NULL, 'PathCollectionReviews', 537, 538),
(256, 218, NULL, NULL, 'QualityCtrls', 539, 558),
(257, 256, NULL, NULL, 'listAll', 540, 541),
(258, 256, NULL, NULL, 'add', 542, 543),
(259, 256, NULL, NULL, 'detail', 544, 545),
(260, 256, NULL, NULL, 'edit', 546, 547),
(261, 256, NULL, NULL, 'if', 548, 549),
(262, 256, NULL, NULL, 'delete', 550, 551),
(263, 256, NULL, NULL, 'addTestedAliquots', 552, 553),
(264, 256, NULL, NULL, 'allowQcDeletion', 554, 555),
(265, 256, NULL, NULL, 'createQcCode', 556, 557),
(266, 218, NULL, NULL, 'ReviewMasters', 559, 560),
(267, 218, NULL, NULL, 'SampleMasters', 561, 588),
(268, 267, NULL, NULL, 'index', 562, 563),
(269, 267, NULL, NULL, 'search', 564, 565),
(270, 267, NULL, NULL, 'contentTreeView', 566, 567),
(271, 267, NULL, NULL, 'listAll', 568, 569),
(272, 267, NULL, NULL, 'detail', 570, 571),
(273, 267, NULL, NULL, 'add', 572, 573),
(274, 267, NULL, NULL, 'edit', 574, 575),
(275, 267, NULL, NULL, 'delete', 576, 577),
(276, 267, NULL, NULL, 'createSampleCode', 578, 579),
(277, 267, NULL, NULL, 'allowSampleDeletion', 580, 581),
(278, 267, NULL, NULL, 'getTissueSourceList', 582, 583),
(279, 267, NULL, NULL, 'formatSampleFieldDecimalData', 584, 585),
(280, 267, NULL, NULL, 'formatParentSampleDataForDisplay', 586, 587),
(281, 1, NULL, NULL, 'Material', 590, 607),
(282, 281, NULL, NULL, 'Materials', 591, 606),
(283, 282, NULL, NULL, 'index', 592, 593),
(284, 282, NULL, NULL, 'search', 594, 595),
(285, 282, NULL, NULL, 'listall', 596, 597),
(286, 282, NULL, NULL, 'add', 598, 599),
(287, 282, NULL, NULL, 'edit', 600, 601),
(288, 282, NULL, NULL, 'detail', 602, 603),
(289, 282, NULL, NULL, 'delete', 604, 605),
(290, 1, NULL, NULL, 'Order', 608, 679),
(291, 290, NULL, NULL, 'OrderItems', 609, 622),
(292, 291, NULL, NULL, 'listall', 610, 611),
(293, 291, NULL, NULL, 'add', 612, 613),
(294, 291, NULL, NULL, 'addAliquotsInBatch', 614, 615),
(295, 291, NULL, NULL, 'edit', 616, 617),
(296, 291, NULL, NULL, 'delete', 618, 619),
(297, 291, NULL, NULL, 'allowOrderItemDeletion', 620, 621),
(298, 290, NULL, NULL, 'OrderLines', 623, 638),
(299, 298, NULL, NULL, 'listall', 624, 625),
(300, 298, NULL, NULL, 'add', 626, 627),
(301, 298, NULL, NULL, 'edit', 628, 629),
(302, 298, NULL, NULL, 'detail', 630, 631),
(303, 298, NULL, NULL, 'delete', 632, 633),
(304, 298, NULL, NULL, 'generateSampleAliquotControlList', 634, 635),
(305, 298, NULL, NULL, 'allowOrderLineDeletion', 636, 637),
(306, 290, NULL, NULL, 'Orders', 639, 656),
(307, 306, NULL, NULL, 'index', 640, 641),
(308, 306, NULL, NULL, 'search', 642, 643),
(309, 306, NULL, NULL, 'add', 644, 645),
(310, 306, NULL, NULL, 'detail', 646, 647),
(311, 306, NULL, NULL, 'edit', 648, 649),
(312, 306, NULL, NULL, 'delete', 650, 651),
(313, 306, NULL, NULL, 'getStudiesList', 652, 653),
(314, 306, NULL, NULL, 'allowOrderDeletion', 654, 655),
(315, 290, NULL, NULL, 'Shipments', 657, 678),
(316, 315, NULL, NULL, 'listall', 658, 659),
(317, 315, NULL, NULL, 'add', 660, 661),
(318, 315, NULL, NULL, 'edit', 662, 663),
(319, 315, NULL, NULL, 'if', 664, 665),
(320, 315, NULL, NULL, 'detail', 666, 667),
(321, 315, NULL, NULL, 'delete', 668, 669),
(322, 315, NULL, NULL, 'addToShipment', 670, 671),
(323, 315, NULL, NULL, 'deleteFromShipment', 672, 673),
(324, 315, NULL, NULL, 'allowShipmentDeletion', 674, 675),
(325, 315, NULL, NULL, 'allowItemRemoveFromShipment', 676, 677),
(326, 1, NULL, NULL, 'Protocol', 680, 713),
(327, 326, NULL, NULL, 'ProtocolExtends', 681, 696),
(328, 327, NULL, NULL, 'listall', 682, 683),
(329, 327, NULL, NULL, 'detail', 684, 685),
(330, 327, NULL, NULL, 'add', 686, 687),
(331, 327, NULL, NULL, 'edit', 688, 689),
(332, 327, NULL, NULL, 'delete', 690, 691),
(333, 326, NULL, NULL, 'ProtocolMasters', 697, 712),
(334, 333, NULL, NULL, 'index', 698, 699),
(335, 333, NULL, NULL, 'search', 700, 701),
(337, 333, NULL, NULL, 'add', 702, 703),
(338, 333, NULL, NULL, 'detail', 704, 705),
(339, 333, NULL, NULL, 'edit', 706, 707),
(340, 333, NULL, NULL, 'delete', 708, 709),
(341, 1, NULL, NULL, 'Provider', 714, 731),
(342, 341, NULL, NULL, 'Providers', 715, 730),
(343, 342, NULL, NULL, 'index', 716, 717),
(344, 342, NULL, NULL, 'search', 718, 719),
(345, 342, NULL, NULL, 'listall', 720, 721),
(346, 342, NULL, NULL, 'add', 722, 723),
(347, 342, NULL, NULL, 'detail', 724, 725),
(348, 342, NULL, NULL, 'edit', 726, 727),
(349, 342, NULL, NULL, 'delete', 728, 729),
(350, 1, NULL, NULL, 'Rtbform', 732, 747),
(351, 350, NULL, NULL, 'Rtbforms', 733, 746),
(352, 351, NULL, NULL, 'index', 734, 735),
(353, 351, NULL, NULL, 'search', 736, 737),
(354, 351, NULL, NULL, 'profile', 738, 739),
(355, 351, NULL, NULL, 'add', 740, 741),
(356, 351, NULL, NULL, 'edit', 742, 743),
(357, 351, NULL, NULL, 'delete', 744, 745),
(358, 1, NULL, NULL, 'Sop', 748, 773),
(359, 358, NULL, NULL, 'SopExtends', 749, 760),
(360, 359, NULL, NULL, 'listall', 750, 751),
(361, 359, NULL, NULL, 'detail', 752, 753),
(362, 359, NULL, NULL, 'add', 754, 755),
(363, 359, NULL, NULL, 'edit', 756, 757),
(364, 359, NULL, NULL, 'delete', 758, 759),
(365, 358, NULL, NULL, 'SopMasters', 761, 772),
(366, 365, NULL, NULL, 'listall', 762, 763),
(367, 365, NULL, NULL, 'add', 764, 765),
(368, 365, NULL, NULL, 'detail', 766, 767),
(369, 365, NULL, NULL, 'edit', 768, 769),
(370, 365, NULL, NULL, 'delete', 770, 771),
(371, 1, NULL, NULL, 'Storagelayout', 774, 851),
(372, 371, NULL, NULL, 'StorageCoordinates', 775, 788),
(373, 372, NULL, NULL, 'listAll', 776, 777),
(374, 372, NULL, NULL, 'add', 778, 779),
(375, 372, NULL, NULL, 'delete', 780, 781),
(376, 372, NULL, NULL, 'allowStorageCoordinateDeletion', 782, 783),
(377, 372, NULL, NULL, 'isDuplicatedValue', 784, 785),
(378, 372, NULL, NULL, 'isDuplicatedOrder', 786, 787),
(379, 371, NULL, NULL, 'StorageMasters', 789, 832),
(380, 379, NULL, NULL, 'index', 790, 791),
(381, 379, NULL, NULL, 'search', 792, 793),
(382, 379, NULL, NULL, 'detail', 794, 795),
(383, 379, NULL, NULL, 'add', 796, 797),
(384, 379, NULL, NULL, 'edit', 798, 799),
(385, 379, NULL, NULL, 'editStoragePosition', 800, 801),
(386, 379, NULL, NULL, 'delete', 802, 803),
(387, 379, NULL, NULL, 'contentTreeView', 804, 805),
(388, 379, NULL, NULL, 'completeStorageContent', 806, 807),
(389, 379, NULL, NULL, 'storageLayout', 808, 809),
(390, 379, NULL, NULL, 'setStorageCoordinateValues', 810, 811),
(391, 379, NULL, NULL, 'allowStorageDeletion', 812, 813),
(392, 379, NULL, NULL, 'getStorageSelectionLabel', 814, 815),
(393, 379, NULL, NULL, 'updateChildrenStorageSelectionLabel', 816, 817),
(394, 379, NULL, NULL, 'createSelectionLabel', 818, 819),
(395, 379, NULL, NULL, 'IsDuplicatedStorageBarCode', 820, 821),
(396, 379, NULL, NULL, 'createStorageCode', 822, 823),
(397, 379, NULL, NULL, 'updateChildrenSurroundingTemperature', 824, 825),
(398, 379, NULL, NULL, 'updateAndSaveDataArray', 826, 827),
(399, 379, NULL, NULL, 'buildChildrenArray', 828, 829),
(400, 371, NULL, NULL, 'TmaSlides', 833, 850),
(401, 400, NULL, NULL, 'listAll', 834, 835),
(402, 400, NULL, NULL, 'add', 836, 837),
(403, 400, NULL, NULL, 'detail', 838, 839),
(404, 400, NULL, NULL, 'edit', 840, 841),
(405, 400, NULL, NULL, 'delete', 842, 843),
(406, 400, NULL, NULL, 'isDuplicatedTmaSlideBarcode', 844, 845),
(407, 400, NULL, NULL, 'allowTMASlideDeletion', 846, 847),
(408, 400, NULL, NULL, 'formatPreselectedStoragesForDisplay', 848, 849),
(409, 1, NULL, NULL, 'Study', 852, 965),
(410, 409, NULL, NULL, 'StudyContacts', 853, 866),
(411, 410, NULL, NULL, 'listall', 854, 855),
(412, 410, NULL, NULL, 'detail', 856, 857),
(413, 410, NULL, NULL, 'add', 858, 859),
(414, 410, NULL, NULL, 'edit', 860, 861),
(415, 410, NULL, NULL, 'delete', 862, 863),
(416, 410, NULL, NULL, 'allowStudyContactDeletion', 864, 865),
(417, 409, NULL, NULL, 'StudyEthicsBoards', 867, 880),
(418, 417, NULL, NULL, 'listall', 868, 869),
(419, 417, NULL, NULL, 'detail', 870, 871),
(420, 417, NULL, NULL, 'add', 872, 873),
(421, 417, NULL, NULL, 'edit', 874, 875),
(422, 417, NULL, NULL, 'delete', 876, 877),
(423, 417, NULL, NULL, 'allowStudyEthicsBoardDeletion', 878, 879),
(424, 409, NULL, NULL, 'StudyFundings', 881, 894),
(425, 424, NULL, NULL, 'listall', 882, 883),
(426, 424, NULL, NULL, 'detail', 884, 885),
(427, 424, NULL, NULL, 'add', 886, 887),
(428, 424, NULL, NULL, 'edit', 888, 889),
(429, 424, NULL, NULL, 'delete', 890, 891),
(430, 424, NULL, NULL, 'allowStudyFundingDeletion', 892, 893),
(431, 409, NULL, NULL, 'StudyInvestigators', 895, 908),
(432, 431, NULL, NULL, 'listall', 896, 897),
(433, 431, NULL, NULL, 'detail', 898, 899),
(434, 431, NULL, NULL, 'add', 900, 901),
(435, 431, NULL, NULL, 'edit', 902, 903),
(436, 431, NULL, NULL, 'delete', 904, 905),
(437, 431, NULL, NULL, 'allowStudyInvestigatorDeletion', 906, 907),
(438, 409, NULL, NULL, 'StudyRelated', 909, 922),
(439, 438, NULL, NULL, 'listall', 910, 911),
(440, 438, NULL, NULL, 'detail', 912, 913),
(441, 438, NULL, NULL, 'add', 914, 915),
(442, 438, NULL, NULL, 'edit', 916, 917),
(443, 438, NULL, NULL, 'delete', 918, 919),
(444, 438, NULL, NULL, 'allowStudyRelatedDeletion', 920, 921),
(445, 409, NULL, NULL, 'StudyResults', 923, 936),
(446, 445, NULL, NULL, 'listall', 924, 925),
(447, 445, NULL, NULL, 'detail', 926, 927),
(448, 445, NULL, NULL, 'add', 928, 929),
(449, 445, NULL, NULL, 'edit', 930, 931),
(450, 445, NULL, NULL, 'delete', 932, 933),
(451, 445, NULL, NULL, 'allowStudyResultDeletion', 934, 935),
(452, 409, NULL, NULL, 'StudyReviews', 937, 950),
(453, 452, NULL, NULL, 'listall', 938, 939),
(454, 452, NULL, NULL, 'detail', 940, 941),
(455, 452, NULL, NULL, 'add', 942, 943),
(456, 452, NULL, NULL, 'edit', 944, 945),
(457, 452, NULL, NULL, 'delete', 946, 947),
(458, 452, NULL, NULL, 'allowStudyReviewDeletion', 948, 949),
(459, 409, NULL, NULL, 'StudySummaries', 951, 964),
(460, 459, NULL, NULL, 'listall', 952, 953),
(461, 459, NULL, NULL, 'detail', 954, 955),
(462, 459, NULL, NULL, 'add', 956, 957),
(463, 459, NULL, NULL, 'edit', 958, 959),
(464, 459, NULL, NULL, 'delete', 960, 961),
(465, 459, NULL, NULL, 'allowStudySummaryDeletion', 962, 963),
(466, 101, NULL, NULL, 'imageryReport', 212, 213),
(467, 101, NULL, NULL, 'addBmiValue', 214, 215),
(468, 101, NULL, NULL, 'setMedicalPastHistoryPrecisions', 216, 217),
(469, 101, NULL, NULL, 'setMedicalImaginStructures', 218, 219),
(470, 101, NULL, NULL, 'completeVolumetry', 220, 221),
(471, 101, NULL, NULL, 'setScores', 222, 223),
(472, 101, NULL, NULL, 'setChildPughScore', 224, 225),
(473, 101, NULL, NULL, 'setOkudaScore', 226, 227),
(474, 101, NULL, NULL, 'setBarcelonaScore', 228, 229),
(475, 101, NULL, NULL, 'setClipScore', 230, 231),
(476, 101, NULL, NULL, 'setFongScore', 232, 233),
(477, 101, NULL, NULL, 'setGretchScore', 234, 235),
(478, 101, NULL, NULL, 'setMeldScore', 236, 237),
(479, 156, NULL, NULL, 'allowTrtExtDeletion', 346, 347),
(480, 156, NULL, NULL, 'getDrugList', 348, 349),
(481, 162, NULL, NULL, 'allowTrtDeletion', 362, 363),
(482, 162, NULL, NULL, 'getProtocolList', 364, 365),
(483, 162, NULL, NULL, 'postOperativeDetail', 366, 367),
(484, 162, NULL, NULL, 'postOperativeEdit', 368, 369),
(485, 210, NULL, NULL, 'allowDrugDeletion', 468, 469),
(486, 327, NULL, NULL, 'allowProtocolExtendDeletion', 692, 693),
(487, 327, NULL, NULL, 'getDrugList', 694, 695),
(488, 333, NULL, NULL, 'allowProtocolDeletion', 710, 711),
(489, 379, NULL, NULL, 'autocompleteLabel', 830, 831);
