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

INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(1, NULL, NULL, NULL, 'controllers', 1, 924),
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
(78, 1, NULL, NULL, 'Clinicalannotation', 154, 339),
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
(101, 78, NULL, NULL, 'EventMasters', 199, 212),
(102, 101, NULL, NULL, 'listall', 200, 201),
(103, 101, NULL, NULL, 'detail', 202, 203),
(104, 101, NULL, NULL, 'add', 204, 205),
(105, 101, NULL, NULL, 'edit', 206, 207),
(106, 101, NULL, NULL, 'delete', 208, 209),
(107, 101, NULL, NULL, 'allowEventDeletion', 210, 211),
(108, 78, NULL, NULL, 'FamilyHistories', 213, 226),
(109, 108, NULL, NULL, 'listall', 214, 215),
(110, 108, NULL, NULL, 'detail', 216, 217),
(111, 108, NULL, NULL, 'add', 218, 219),
(112, 108, NULL, NULL, 'edit', 220, 221),
(113, 108, NULL, NULL, 'delete', 222, 223),
(114, 108, NULL, NULL, 'allowFamilyHistoryDeletion', 224, 225),
(115, 78, NULL, NULL, 'MiscIdentifiers', 227, 244),
(116, 115, NULL, NULL, 'index', 228, 229),
(117, 115, NULL, NULL, 'search', 230, 231),
(118, 115, NULL, NULL, 'listall', 232, 233),
(119, 115, NULL, NULL, 'detail', 234, 235),
(120, 115, NULL, NULL, 'add', 236, 237),
(121, 115, NULL, NULL, 'edit', 238, 239),
(122, 115, NULL, NULL, 'delete', 240, 241),
(123, 115, NULL, NULL, 'allowMiscIdentifierDeletion', 242, 243),
(124, 78, NULL, NULL, 'ParticipantContacts', 245, 258),
(125, 124, NULL, NULL, 'listall', 246, 247),
(126, 124, NULL, NULL, 'detail', 248, 249),
(127, 124, NULL, NULL, 'add', 250, 251),
(128, 124, NULL, NULL, 'edit', 252, 253),
(129, 124, NULL, NULL, 'delete', 254, 255),
(130, 124, NULL, NULL, 'allowParticipantContactDeletion', 256, 257),
(131, 78, NULL, NULL, 'ParticipantMessages', 259, 272),
(132, 131, NULL, NULL, 'listall', 260, 261),
(133, 131, NULL, NULL, 'detail', 262, 263),
(134, 131, NULL, NULL, 'add', 264, 265),
(135, 131, NULL, NULL, 'edit', 266, 267),
(136, 131, NULL, NULL, 'delete', 268, 269),
(137, 131, NULL, NULL, 'allowParticipantMessageDeletion', 270, 271),
(138, 78, NULL, NULL, 'Participants', 273, 290),
(139, 138, NULL, NULL, 'index', 274, 275),
(140, 138, NULL, NULL, 'search', 276, 277),
(141, 138, NULL, NULL, 'profile', 278, 279),
(142, 138, NULL, NULL, 'add', 280, 281),
(143, 138, NULL, NULL, 'edit', 282, 283),
(144, 138, NULL, NULL, 'delete', 284, 285),
(145, 138, NULL, NULL, 'allowParticipantDeletion', 286, 287),
(146, 138, NULL, NULL, 'chronology', 288, 289),
(147, 78, NULL, NULL, 'ProductMasters', 291, 294),
(148, 147, NULL, NULL, 'productsTreeView', 292, 293),
(149, 78, NULL, NULL, 'ReproductiveHistories', 295, 308),
(150, 149, NULL, NULL, 'listall', 296, 297),
(151, 149, NULL, NULL, 'detail', 298, 299),
(152, 149, NULL, NULL, 'add', 300, 301),
(153, 149, NULL, NULL, 'edit', 302, 303),
(154, 149, NULL, NULL, 'delete', 304, 305),
(155, 149, NULL, NULL, 'allowReproductiveHistoryDeletion', 306, 307),
(156, 78, NULL, NULL, 'TreatmentExtends', 309, 324),
(157, 156, NULL, NULL, 'listall', 310, 311),
(158, 156, NULL, NULL, 'detail', 312, 313),
(159, 156, NULL, NULL, 'add', 314, 315),
(160, 156, NULL, NULL, 'edit', 316, 317),
(161, 156, NULL, NULL, 'delete', 318, 319),
(162, 78, NULL, NULL, 'TreatmentMasters', 325, 338),
(163, 162, NULL, NULL, 'listall', 326, 327),
(164, 162, NULL, NULL, 'detail', 328, 329),
(165, 162, NULL, NULL, 'edit', 330, 331),
(166, 162, NULL, NULL, 'add', 332, 333),
(167, 162, NULL, NULL, 'delete', 334, 335),
(168, 1, NULL, NULL, 'Codingicd10', 340, 347),
(169, 168, NULL, NULL, 'CodingIcd10s', 341, 346),
(170, 169, NULL, NULL, 'tool', 342, 343),
(171, 169, NULL, NULL, 'autoComplete', 344, 345),
(172, 1, NULL, NULL, 'Customize', 348, 371),
(173, 172, NULL, NULL, 'Announcements', 349, 354),
(174, 173, NULL, NULL, 'index', 350, 351),
(175, 173, NULL, NULL, 'detail', 352, 353),
(176, 172, NULL, NULL, 'Passwords', 355, 358),
(177, 176, NULL, NULL, 'index', 356, 357),
(178, 172, NULL, NULL, 'Preferences', 359, 364),
(179, 178, NULL, NULL, 'index', 360, 361),
(180, 178, NULL, NULL, 'edit', 362, 363),
(181, 172, NULL, NULL, 'Profiles', 365, 370),
(182, 181, NULL, NULL, 'index', 366, 367),
(183, 181, NULL, NULL, 'edit', 368, 369),
(184, 1, NULL, NULL, 'Datamart', 372, 421),
(185, 184, NULL, NULL, 'AdhocSaved', 373, 386),
(186, 185, NULL, NULL, 'index', 374, 375),
(187, 185, NULL, NULL, 'add', 376, 377),
(188, 185, NULL, NULL, 'search', 378, 379),
(189, 185, NULL, NULL, 'results', 380, 381),
(190, 185, NULL, NULL, 'edit', 382, 383),
(191, 185, NULL, NULL, 'delete', 384, 385),
(192, 184, NULL, NULL, 'Adhocs', 387, 402),
(193, 192, NULL, NULL, 'index', 388, 389),
(194, 192, NULL, NULL, 'favourite', 390, 391),
(195, 192, NULL, NULL, 'unfavourite', 392, 393),
(196, 192, NULL, NULL, 'search', 394, 395),
(197, 192, NULL, NULL, 'results', 396, 397),
(198, 192, NULL, NULL, 'process', 398, 399),
(199, 192, NULL, NULL, 'csv', 400, 401),
(200, 184, NULL, NULL, 'BatchSets', 403, 420),
(201, 200, NULL, NULL, 'index', 404, 405),
(202, 200, NULL, NULL, 'listall', 406, 407),
(203, 200, NULL, NULL, 'add', 408, 409),
(204, 200, NULL, NULL, 'edit', 410, 411),
(205, 200, NULL, NULL, 'delete', 412, 413),
(206, 200, NULL, NULL, 'process', 414, 415),
(207, 200, NULL, NULL, 'remove', 416, 417),
(208, 200, NULL, NULL, 'csv', 418, 419),
(209, 1, NULL, NULL, 'Drug', 422, 439),
(210, 209, NULL, NULL, 'Drugs', 423, 438),
(211, 210, NULL, NULL, 'index', 424, 425),
(212, 210, NULL, NULL, 'search', 426, 427),
(214, 210, NULL, NULL, 'add', 428, 429),
(215, 210, NULL, NULL, 'edit', 430, 431),
(216, 210, NULL, NULL, 'detail', 432, 433),
(217, 210, NULL, NULL, 'delete', 434, 435),
(218, 1, NULL, NULL, 'Inventorymanagement', 440, 553),
(219, 218, NULL, NULL, 'AliquotMasters', 441, 486),
(220, 219, NULL, NULL, 'index', 442, 443),
(221, 219, NULL, NULL, 'search', 444, 445),
(222, 219, NULL, NULL, 'listAll', 446, 447),
(223, 219, NULL, NULL, 'add', 448, 449),
(224, 219, NULL, NULL, 'detail', 450, 451),
(225, 219, NULL, NULL, 'edit', 452, 453),
(226, 219, NULL, NULL, 'removeAliquotFromStorage', 454, 455),
(227, 219, NULL, NULL, 'delete', 456, 457),
(228, 219, NULL, NULL, 'addAliquotUse', 458, 459),
(229, 219, NULL, NULL, 'editAliquotUse', 460, 461),
(230, 219, NULL, NULL, 'deleteAliquotUse', 462, 463),
(231, 219, NULL, NULL, 'addSourceAliquots', 464, 465),
(232, 219, NULL, NULL, 'listAllSourceAliquots', 466, 467),
(233, 219, NULL, NULL, 'defineRealiquotedChildren', 468, 469),
(234, 219, NULL, NULL, 'listAllRealiquotedParents', 470, 471),
(238, 219, NULL, NULL, 'getDefaultAliquotStorageDate', 472, 473),
(239, 219, NULL, NULL, 'isDuplicatedAliquotBarcode', 474, 475),
(240, 219, NULL, NULL, 'formatAliquotFieldDecimalData', 476, 477),
(241, 219, NULL, NULL, 'validateAliquotStorageData', 478, 479),
(242, 219, NULL, NULL, 'allowAliquotDeletion', 480, 481),
(243, 219, NULL, NULL, 'getDefaultRealiquotingDate', 482, 483),
(244, 219, NULL, NULL, 'formatPreselectedStoragesForDisplay', 484, 485),
(247, 218, NULL, NULL, 'Collections', 487, 502),
(248, 247, NULL, NULL, 'index', 488, 489),
(249, 247, NULL, NULL, 'search', 490, 491),
(250, 247, NULL, NULL, 'detail', 492, 493),
(251, 247, NULL, NULL, 'add', 494, 495),
(252, 247, NULL, NULL, 'edit', 496, 497),
(253, 247, NULL, NULL, 'delete', 498, 499),
(254, 247, NULL, NULL, 'allowCollectionDeletion', 500, 501),
(255, 218, NULL, NULL, 'PathCollectionReviews', 503, 504),
(256, 218, NULL, NULL, 'QualityCtrls', 505, 524),
(257, 256, NULL, NULL, 'listAll', 506, 507),
(258, 256, NULL, NULL, 'add', 508, 509),
(259, 256, NULL, NULL, 'detail', 510, 511),
(260, 256, NULL, NULL, 'edit', 512, 513),
(261, 256, NULL, NULL, 'if', 514, 515),
(262, 256, NULL, NULL, 'delete', 516, 517),
(263, 256, NULL, NULL, 'addTestedAliquots', 518, 519),
(264, 256, NULL, NULL, 'allowQcDeletion', 520, 521),
(265, 256, NULL, NULL, 'createQcCode', 522, 523),
(266, 218, NULL, NULL, 'ReviewMasters', 525, 526),
(267, 218, NULL, NULL, 'SampleMasters', 527, 552),
(268, 267, NULL, NULL, 'index', 528, 529),
(269, 267, NULL, NULL, 'search', 530, 531),
(270, 267, NULL, NULL, 'contentTreeView', 532, 533),
(271, 267, NULL, NULL, 'listAll', 534, 535),
(272, 267, NULL, NULL, 'detail', 536, 537),
(273, 267, NULL, NULL, 'add', 538, 539),
(274, 267, NULL, NULL, 'edit', 540, 541),
(275, 267, NULL, NULL, 'delete', 542, 543),
(276, 267, NULL, NULL, 'createSampleCode', 544, 545),
(277, 267, NULL, NULL, 'allowSampleDeletion', 546, 547),
(279, 267, NULL, NULL, 'formatSampleFieldDecimalData', 548, 549),
(280, 267, NULL, NULL, 'formatParentSampleDataForDisplay', 550, 551),
(281, 1, NULL, NULL, 'Material', 554, 571),
(282, 281, NULL, NULL, 'Materials', 555, 570),
(283, 282, NULL, NULL, 'index', 556, 557),
(284, 282, NULL, NULL, 'search', 558, 559),
(285, 282, NULL, NULL, 'listall', 560, 561),
(286, 282, NULL, NULL, 'add', 562, 563),
(287, 282, NULL, NULL, 'edit', 564, 565),
(288, 282, NULL, NULL, 'detail', 566, 567),
(289, 282, NULL, NULL, 'delete', 568, 569),
(290, 1, NULL, NULL, 'Order', 572, 639),
(291, 290, NULL, NULL, 'OrderItems', 573, 586),
(292, 291, NULL, NULL, 'listall', 574, 575),
(293, 291, NULL, NULL, 'add', 576, 577),
(294, 291, NULL, NULL, 'addAliquotsInBatch', 578, 579),
(295, 291, NULL, NULL, 'edit', 580, 581),
(296, 291, NULL, NULL, 'delete', 582, 583),
(297, 291, NULL, NULL, 'allowOrderItemDeletion', 584, 585),
(298, 290, NULL, NULL, 'OrderLines', 587, 600),
(299, 298, NULL, NULL, 'listall', 588, 589),
(300, 298, NULL, NULL, 'add', 590, 591),
(301, 298, NULL, NULL, 'edit', 592, 593),
(302, 298, NULL, NULL, 'detail', 594, 595),
(303, 298, NULL, NULL, 'delete', 596, 597),
(305, 298, NULL, NULL, 'allowOrderLineDeletion', 598, 599),
(306, 290, NULL, NULL, 'Orders', 601, 616),
(307, 306, NULL, NULL, 'index', 602, 603),
(308, 306, NULL, NULL, 'search', 604, 605),
(309, 306, NULL, NULL, 'add', 606, 607),
(310, 306, NULL, NULL, 'detail', 608, 609),
(311, 306, NULL, NULL, 'edit', 610, 611),
(312, 306, NULL, NULL, 'delete', 612, 613),
(314, 306, NULL, NULL, 'allowOrderDeletion', 614, 615),
(315, 290, NULL, NULL, 'Shipments', 617, 638),
(316, 315, NULL, NULL, 'listall', 618, 619),
(317, 315, NULL, NULL, 'add', 620, 621),
(318, 315, NULL, NULL, 'edit', 622, 623),
(319, 315, NULL, NULL, 'if', 624, 625),
(320, 315, NULL, NULL, 'detail', 626, 627),
(321, 315, NULL, NULL, 'delete', 628, 629),
(322, 315, NULL, NULL, 'addToShipment', 630, 631),
(323, 315, NULL, NULL, 'deleteFromShipment', 632, 633),
(324, 315, NULL, NULL, 'allowShipmentDeletion', 634, 635),
(325, 315, NULL, NULL, 'allowItemRemoveFromShipment', 636, 637),
(326, 1, NULL, NULL, 'Protocol', 640, 671),
(327, 326, NULL, NULL, 'ProtocolExtends', 641, 654),
(328, 327, NULL, NULL, 'listall', 642, 643),
(329, 327, NULL, NULL, 'detail', 644, 645),
(330, 327, NULL, NULL, 'add', 646, 647),
(331, 327, NULL, NULL, 'edit', 648, 649),
(332, 327, NULL, NULL, 'delete', 650, 651),
(333, 326, NULL, NULL, 'ProtocolMasters', 655, 670),
(334, 333, NULL, NULL, 'index', 656, 657),
(335, 333, NULL, NULL, 'search', 658, 659),
(337, 333, NULL, NULL, 'add', 660, 661),
(338, 333, NULL, NULL, 'detail', 662, 663),
(339, 333, NULL, NULL, 'edit', 664, 665),
(340, 333, NULL, NULL, 'delete', 666, 667),
(341, 1, NULL, NULL, 'Provider', 672, 689),
(342, 341, NULL, NULL, 'Providers', 673, 688),
(343, 342, NULL, NULL, 'index', 674, 675),
(344, 342, NULL, NULL, 'search', 676, 677),
(345, 342, NULL, NULL, 'listall', 678, 679),
(346, 342, NULL, NULL, 'add', 680, 681),
(347, 342, NULL, NULL, 'detail', 682, 683),
(348, 342, NULL, NULL, 'edit', 684, 685),
(349, 342, NULL, NULL, 'delete', 686, 687),
(350, 1, NULL, NULL, 'Rtbform', 690, 705),
(351, 350, NULL, NULL, 'Rtbforms', 691, 704),
(352, 351, NULL, NULL, 'index', 692, 693),
(353, 351, NULL, NULL, 'search', 694, 695),
(354, 351, NULL, NULL, 'profile', 696, 697),
(355, 351, NULL, NULL, 'add', 698, 699),
(356, 351, NULL, NULL, 'edit', 700, 701),
(357, 351, NULL, NULL, 'delete', 702, 703),
(358, 1, NULL, NULL, 'Sop', 706, 731),
(359, 358, NULL, NULL, 'SopExtends', 707, 718),
(360, 359, NULL, NULL, 'listall', 708, 709),
(361, 359, NULL, NULL, 'detail', 710, 711),
(362, 359, NULL, NULL, 'add', 712, 713),
(363, 359, NULL, NULL, 'edit', 714, 715),
(364, 359, NULL, NULL, 'delete', 716, 717),
(365, 358, NULL, NULL, 'SopMasters', 719, 730),
(366, 365, NULL, NULL, 'listall', 720, 721),
(367, 365, NULL, NULL, 'add', 722, 723),
(368, 365, NULL, NULL, 'detail', 724, 725),
(369, 365, NULL, NULL, 'edit', 726, 727),
(370, 365, NULL, NULL, 'delete', 728, 729),
(371, 1, NULL, NULL, 'Storagelayout', 732, 809),
(372, 371, NULL, NULL, 'StorageCoordinates', 733, 746),
(373, 372, NULL, NULL, 'listAll', 734, 735),
(374, 372, NULL, NULL, 'add', 736, 737),
(375, 372, NULL, NULL, 'delete', 738, 739),
(376, 372, NULL, NULL, 'allowStorageCoordinateDeletion', 740, 741),
(377, 372, NULL, NULL, 'isDuplicatedValue', 742, 743),
(378, 372, NULL, NULL, 'isDuplicatedOrder', 744, 745),
(379, 371, NULL, NULL, 'StorageMasters', 747, 790),
(380, 379, NULL, NULL, 'index', 748, 749),
(381, 379, NULL, NULL, 'search', 750, 751),
(382, 379, NULL, NULL, 'detail', 752, 753),
(383, 379, NULL, NULL, 'add', 754, 755),
(384, 379, NULL, NULL, 'edit', 756, 757),
(385, 379, NULL, NULL, 'editStoragePosition', 758, 759),
(386, 379, NULL, NULL, 'delete', 760, 761),
(387, 379, NULL, NULL, 'contentTreeView', 762, 763),
(388, 379, NULL, NULL, 'completeStorageContent', 764, 765),
(389, 379, NULL, NULL, 'storageLayout', 766, 767),
(390, 379, NULL, NULL, 'setStorageCoordinateValues', 768, 769),
(391, 379, NULL, NULL, 'allowStorageDeletion', 770, 771),
(392, 379, NULL, NULL, 'getStorageSelectionLabel', 772, 773),
(393, 379, NULL, NULL, 'updateChildrenStorageSelectionLabel', 774, 775),
(394, 379, NULL, NULL, 'createSelectionLabel', 776, 777),
(395, 379, NULL, NULL, 'IsDuplicatedStorageBarCode', 778, 779),
(396, 379, NULL, NULL, 'createStorageCode', 780, 781),
(397, 379, NULL, NULL, 'updateChildrenSurroundingTemperature', 782, 783),
(398, 379, NULL, NULL, 'updateAndSaveDataArray', 784, 785),
(399, 379, NULL, NULL, 'buildChildrenArray', 786, 787),
(400, 371, NULL, NULL, 'TmaSlides', 791, 808),
(401, 400, NULL, NULL, 'listAll', 792, 793),
(402, 400, NULL, NULL, 'add', 794, 795),
(403, 400, NULL, NULL, 'detail', 796, 797),
(404, 400, NULL, NULL, 'edit', 798, 799),
(405, 400, NULL, NULL, 'delete', 800, 801),
(406, 400, NULL, NULL, 'isDuplicatedTmaSlideBarcode', 802, 803),
(407, 400, NULL, NULL, 'allowTMASlideDeletion', 804, 805),
(408, 400, NULL, NULL, 'formatPreselectedStoragesForDisplay', 806, 807),
(409, 1, NULL, NULL, 'Study', 810, 923),
(410, 409, NULL, NULL, 'StudyContacts', 811, 824),
(411, 410, NULL, NULL, 'listall', 812, 813),
(412, 410, NULL, NULL, 'detail', 814, 815),
(413, 410, NULL, NULL, 'add', 816, 817),
(414, 410, NULL, NULL, 'edit', 818, 819),
(415, 410, NULL, NULL, 'delete', 820, 821),
(416, 410, NULL, NULL, 'allowStudyContactDeletion', 822, 823),
(417, 409, NULL, NULL, 'StudyEthicsBoards', 825, 838),
(418, 417, NULL, NULL, 'listall', 826, 827),
(419, 417, NULL, NULL, 'detail', 828, 829),
(420, 417, NULL, NULL, 'add', 830, 831),
(421, 417, NULL, NULL, 'edit', 832, 833),
(422, 417, NULL, NULL, 'delete', 834, 835),
(423, 417, NULL, NULL, 'allowStudyEthicsBoardDeletion', 836, 837),
(424, 409, NULL, NULL, 'StudyFundings', 839, 852),
(425, 424, NULL, NULL, 'listall', 840, 841),
(426, 424, NULL, NULL, 'detail', 842, 843),
(427, 424, NULL, NULL, 'add', 844, 845),
(428, 424, NULL, NULL, 'edit', 846, 847),
(429, 424, NULL, NULL, 'delete', 848, 849),
(430, 424, NULL, NULL, 'allowStudyFundingDeletion', 850, 851),
(431, 409, NULL, NULL, 'StudyInvestigators', 853, 866),
(432, 431, NULL, NULL, 'listall', 854, 855),
(433, 431, NULL, NULL, 'detail', 856, 857),
(434, 431, NULL, NULL, 'add', 858, 859),
(435, 431, NULL, NULL, 'edit', 860, 861),
(436, 431, NULL, NULL, 'delete', 862, 863),
(437, 431, NULL, NULL, 'allowStudyInvestigatorDeletion', 864, 865),
(438, 409, NULL, NULL, 'StudyRelated', 867, 880),
(439, 438, NULL, NULL, 'listall', 868, 869),
(440, 438, NULL, NULL, 'detail', 870, 871),
(441, 438, NULL, NULL, 'add', 872, 873),
(442, 438, NULL, NULL, 'edit', 874, 875),
(443, 438, NULL, NULL, 'delete', 876, 877),
(444, 438, NULL, NULL, 'allowStudyRelatedDeletion', 878, 879),
(445, 409, NULL, NULL, 'StudyResults', 881, 894),
(446, 445, NULL, NULL, 'listall', 882, 883),
(447, 445, NULL, NULL, 'detail', 884, 885),
(448, 445, NULL, NULL, 'add', 886, 887),
(449, 445, NULL, NULL, 'edit', 888, 889),
(450, 445, NULL, NULL, 'delete', 890, 891),
(451, 445, NULL, NULL, 'allowStudyResultDeletion', 892, 893),
(452, 409, NULL, NULL, 'StudyReviews', 895, 908),
(453, 452, NULL, NULL, 'listall', 896, 897),
(454, 452, NULL, NULL, 'detail', 898, 899),
(455, 452, NULL, NULL, 'add', 900, 901),
(456, 452, NULL, NULL, 'edit', 902, 903),
(457, 452, NULL, NULL, 'delete', 904, 905),
(458, 452, NULL, NULL, 'allowStudyReviewDeletion', 906, 907),
(459, 409, NULL, NULL, 'StudySummaries', 909, 922),
(460, 459, NULL, NULL, 'listall', 910, 911),
(461, 459, NULL, NULL, 'detail', 912, 913),
(462, 459, NULL, NULL, 'add', 914, 915),
(463, 459, NULL, NULL, 'edit', 916, 917),
(464, 459, NULL, NULL, 'delete', 918, 919),
(465, 459, NULL, NULL, 'allowStudySummaryDeletion', 920, 921),
(466, 156, NULL, NULL, 'allowTrtExtDeletion', 320, 321),
(467, 156, NULL, NULL, 'importFromProtocol', 322, 323),
(468, 162, NULL, NULL, 'allowTrtDeletion', 336, 337),
(469, 210, NULL, NULL, 'allowDrugDeletion', 436, 437),
(470, 327, NULL, NULL, 'allowProtocolExtendDeletion', 652, 653),
(471, 333, NULL, NULL, 'allowProtocolDeletion', 668, 669),
(472, 379, NULL, NULL, 'autocompleteLabel', 788, 789);

UPDATE menus SET language_title = 'precision' WHERE id = 'clin_CAN_80';

INSERT IGNORE INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
('precision', 'global', 'Precision', 'Précision');

TRUNCATE key_increments;