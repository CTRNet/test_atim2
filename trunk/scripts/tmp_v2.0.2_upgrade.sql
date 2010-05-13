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
 ('advanced controls', '', 'Advanced controls', 'Contrôles avancés'),
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
 ("minutes", "", "Minutes", "Minutes");
 
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

-- datetime input type
ALTER TABLE `configs` ADD `define_datetime_input_type` ENUM( 'dropdown', 'textual' ) NOT NULL DEFAULT 'dropdown' AFTER `define_decimal_separator`;  
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('datetime_input_type', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("dropdown", "dropdown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="datetime_input_type"),  (SELECT id FROM structure_permissible_values WHERE value="dropdown" AND language_alias="dropdown"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("textual", "textual");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="datetime_input_type"),  (SELECT id FROM structure_permissible_values WHERE value="textual" AND language_alias="textual"), "2", "1");
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'Administrate', 'Config', 'configs', 'define_datetime_input_type', 'datetime input type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_input_type') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='preferences'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_datetime_input_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_input_type')  ), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

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