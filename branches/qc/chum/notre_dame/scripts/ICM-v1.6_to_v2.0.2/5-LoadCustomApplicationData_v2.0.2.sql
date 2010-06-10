UPDATE users SET password = '81a717c1def10e2d2406a198661abf8fdb8fd6f5';

##########################################################################
# ADMINISTRATE
##########################################################################

UPDATE `groups` SET `bank_id` = 1 WHERE `id` = 1;
UPDATE `groups` SET `bank_id` = 1 WHERE `id` = 2;
UPDATE `groups` SET `bank_id` = 1 WHERE `id` = 3;
UPDATE `groups` SET `bank_id` = 2 WHERE `id` = 4;
UPDATE `groups` SET `bank_id` = 3 WHERE `id` = 5;
UPDATE `groups` SET `bank_id` = 4 WHERE `id` = 6;
UPDATE `groups` SET `bank_id` = 1 WHERE `id` = 7;
UPDATE `groups` SET `bank_id` = 5 WHERE `id` = 8;
UPDATE `groups` SET `bank_id` = 6 WHERE `id` = 9;

##########################################################################
# CLINICAL ANNOTATION
##########################################################################

UPDATE `menus` SET use_summary = '' 
WHERE use_link LIKE '/clinicalannotation%'
AND use_summary != 'Clinicalannotation.Participant::summary';

# PROFILE ----------------------------------------------------------------

UPDATE structure_fields field
SET field.language_label = 'participant code'
WHERE field.plugin = 'Clinicalannotation'
AND field.model = 'Participant'
AND field.tablename = 'participants'
AND field.field = 'participant_identifier'
AND field.language_label = 'participant identifier'; 	

UPDATE structure_fields field, structure_formats format, structures strct
SET format.flag_add ='0', format.flag_add_readonly ='0', 
flag_edit ='1', flag_edit_readonly ='1', 
flag_search ='1', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0', 
flag_index ='1', 
flag_detail ='1' 
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'participants'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'Participant'
AND field.tablename = 'participants'
AND field.field = 'participant_identifier'; 

UPDATE structure_fields field, structure_formats format, structures strct
SET format.flag_add ='0', format.flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0', 
flag_index ='0', 
flag_detail ='0' 
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'participants'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'Participant'
AND field.tablename = 'participants'
AND field.field IN  ('title', 'middle_name', 'race', 'marital_status',
'secondary_cod_icd10_code', 'cod_confirmation_source'); 

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'last_visit_date', 'last visit date', '', 'date', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'lvd_date_accuracy', '', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'datetime_accuracy_indicator'), 'help_date accuracy', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'sardo_participant_id', 'sardo participant id', '', 'input', 'size=20', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'sardo_medical_record_number', 'sardo medical record number', '', 'input', 'size=20', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'last_sardo_import_date', 'last import date', '', 'date', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_visit_date'), 
'3', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='lvd_date_accuracy'), 
'3', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sardo_participant_id'), 
'4', '10', 'sardo data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sardo_medical_record_number'), 
'4', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '1', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_sardo_import_date'), 
'4', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '0', '1');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) 
VALUES
('participant code', '', 'Participant Code', 'Code du participant'),
('last visit date', '', 'Last Visit Date', 'Date dernière visite'),
('sardo data', '', 'SARDO Data', 'Données SARDO'),
('sardo numero dossier', '', 'SARDO patient number', 'SARDO numéro dossier'),
('sardo participant id', '', 'SARDO Patient NO', 'SARDO Patient NO'),
('sardo medical record number', '', 'SARDO Medical Record Number', 'SARDO Numéro d''hôpital'),
('last import date', '', 'Last Import Date', 'Date dernier import');

ALTER TABLE participants
     ADD is_anonymous varchar(10) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci AFTER middle_name,
     ADD anonymous_reason varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER is_anonymous,
     ADD anonymous_precision varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER anonymous_reason;

ALTER TABLE participants_revs
     ADD is_anonymous varchar(10) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci AFTER middle_name,
     ADD anonymous_reason varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER is_anonymous,
     ADD anonymous_precision varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER anonymous_reason;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_anonymous_reason', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("consent refused", "consent refused");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("consent missing", "consent missing");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other center participant", "other center participant");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_anonymous_reason"),
(SELECT id FROM structure_permissible_values WHERE value="consent missing" AND language_alias="consent missing"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_anonymous_reason"),
(SELECT id FROM structure_permissible_values WHERE value="consent refused" AND language_alias="consent refused"), "20", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_anonymous_reason"),
(SELECT id FROM structure_permissible_values WHERE value="other center participant" AND language_alias="other center participant"), "30", "1");
     
INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'is_anonymous', 'is anonymous', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yes_no_checkbox"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'anonymous_reason', 'anonymous reason', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_anonymous_reason"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'Participant', 'participants', 'anonymous_precision', 'anonymous precision', '', 'input', 'size=20', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='is_anonymous'), 
'4', '1', 'anonymous data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='anonymous_reason'), 
'4', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='anonymous_precision'), 
'4', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) 
VALUES
('consent missing', '', 'Consent Missing', 'Consentement manquant'),
('consent refused', '', 'Consent Refused', 'Consentement refusé'),
('other center participant', '', 'Other Center Participant', 'Participant autre banque'),

('anonymous data', '', 'Anonymous Data', 'Pécision / Anonyme'),
('is anonymous', '', 'Is Anonymous', 'Anonyme'),
('anonymous reason', '', 'Reason', 'Raison'),
('anonymous precision', '', 'Precision', 'Précision');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
(null, (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

UPDATE participants
SET first_name = 'n/a',
last_name = 'n/a',
is_anonymous = '1',
anonymous_reason = 'consent refused'
WHERE first_name like 'Consentement' AND last_name LIKE 'Refus%';

UPDATE participants
SET 
is_anonymous = '1',
anonymous_reason = 'other center participant',
anonymous_precision = concat(first_name, ' ', last_name),
first_name = 'n/a',
last_name = 'n/a'
WHERE first_name like 'MDEIE';

UPDATE participants
SET first_name = 'n/a'
WHERE first_name LIKE '';

UPDATE participants
SET first_name = 'n/a'
WHERE first_name IS NULL;

UPDATE participants
SET last_name = 'n/a'
WHERE last_name LIKE '';

UPDATE participants
SET last_name = 'n/a'
WHERE last_name IS NULL;

UPDATE participants
SET is_anonymous = '0'
WHERE is_anonymous != '1' OR is_anonymous IS NULL;

# IDENTIFIERS ------------------------------------------------------------

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) 
VALUES
('breast bank no lab', '', '''No Labo'' of Breast Bank', '''No Labo'' de la banque Sein'),
('code-barre', '', 'Code-barre', 'Code à barres'),
('head and neck bank no lab', '', '''No Labo'' of Head & Neck Bank', '''No Labo'' de la banque Tête & Cou'),
('hotel-dieu id nbr', '', 'Hôtel-Dieu Medical Record Number', 'Numéro de dossier ''Hôtel-Dieu'''),
('kidney bank no lab', '', '''No Labo'' of Kidney Bank', '''No Labo'' de la banque Rein'),
('notre-dame id nbr', '', 'Notre-Dame Medical Record Number', 'Numéro de dossier ''Notre-Dame'''),
('old bank no lab', '', '''No Labo'' of Old Bank', 'Ancien ''No Labo'' de banque '),
('other center id nbr', '', 'Other Center Participant Number', 'Numéro participant autre banque'),
('ovary bank no lab', '', '''No Labo'' of Ovary Bank', '''No Labo'' de la banque Ovaire'),
('prostate bank no lab', '', '''No Labo'' of Prostate Bank', '''No Labo'' de la banque Prostate'),
('ramq nbr', '', 'RAMQ', 'RAMQ'),
('participant patho identifier', '', 'Patho Identifier', 'Identifiant de pathologie'),  
('saint-luc id nbr', '', 'Saint-Luc Medical Record Number', 'Numéro de dossier ''Saint-Luc''');

UPDATE structure_fields field, structure_formats format, structures strct
SET format.flag_add ='0', format.flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0', 
flag_index ='0', 
flag_detail ='0' 
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias LIKE '%miscidentifiers%'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'Participant'
AND field.tablename = 'participants'
AND field.field IN  ('title', 'middle_name'); 

UPDATE structure_fields field, structure_formats format, structures strct
SET format.flag_search ='1', format.flag_override_label = '1', format.language_label = 'first name'
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias LIKE 'miscidentifierssummary'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'Participant'
AND field.tablename = 'participants'
AND field.field IN  ('first_name'); 

UPDATE structure_fields field, structure_formats format, structures strct
SET flag_search ='1', format.flag_override_label = '1', format.language_label = 'last name'
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias LIKE 'miscidentifierssummary'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'Participant'
AND field.tablename = 'participants'
AND field.field IN  ('last_name'); 

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='miscidentifierssummary'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='is_anonymous'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='miscidentifierssummary'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth'), 
'0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

UPDATE misc_identifier_controls SET flag_once_per_participant = '1' WHERE 	misc_identifier_name NOT IN ('other center id nbr', 'participant patho identifier');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('this identifier has already been created for your participant', '', 'This identifier has already been created for your participant!', 'Cet identification a déjà été créée pour ce participant!'),
('ramq format error', '', 'The format of the RAMQ is invalid!', 'Le format de la RAMQ est invalide!');

# CONSENT ----------------------------------------------------------------

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('cd_icm_generics', '', '', '1', '1', '0', '1');

UPDATE consent_controls SET controls_type = 'frsq - network' WHERE controls_type = 'FRSQ - Network';
UPDATE consent_controls SET controls_type = 'chum - prostate' WHERE controls_type = 'CHUM - Prostate';
UPDATE consent_controls SET controls_type = 'frsq' WHERE controls_type = 'FRSQ';
UPDATE consent_controls SET controls_type = 'procure' WHERE controls_type = 'PROCURE';

UPDATE consent_masters SET consent_type = 'frsq - network' WHERE consent_type = 'FRSQ - Network';
UPDATE consent_masters SET consent_type = 'chum - prostate' WHERE consent_type = 'CHUM - Prostate';
UPDATE consent_masters SET consent_type = 'frsq' WHERE consent_type = 'FRSQ';
UPDATE consent_masters SET consent_type = 'procure' WHERE consent_type = 'PROCURE';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_consent_type', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("frsq - network", "frsq - network");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("chum - kidney", "chum - kidney");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("chum - prostate", "chum - prostate");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("frsq", "frsq");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("procure", "procure");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="frsq - network" AND language_alias="frsq - network"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="chum - kidney" AND language_alias="chum - kidney"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="chum - prostate" AND language_alias="chum - prostate"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="frsq" AND language_alias="frsq"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="procure" AND language_alias="procure4"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="unknwon" AND language_alias="unknwon"), "6", "1");

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('frsq - network', '', 'FRSQ - Network', 'FRSQ - Réseau'),
('chum - kidney', '', 'CHUM - Kidney', 'CHUM - Rein'),
('chum - prostate', '', 'CHUM - Prostate', 'CHUM - Prostate'),
('frsq', '', 'FRSQ', 'FRSQ'),
('procure', '', 'PROCURE', 'PROCURE');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_global_consent_version', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2010-03-04", "2010-03-04");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2009-11-04", "2009-11-04");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-10-02", "2008-10-02");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-09-24", "2008-09-24");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-06-26", "2008-06-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-06-23", "2008-06-23");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-03-23", "2008-03-23");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-05-04", "2008-05-04");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-04-05", "2008-04-05");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2008-03-26", "2008-03-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-10-25", "2007-10-25");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-06-05", "2007-06-05");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-05-23", "2007-05-23");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-05-15", "2007-05-15");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-05-05", "2007-05-05");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-05-04", "2007-05-04");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-04-04", "2007-04-04");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2007-03-12", "2007-03-12");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-08-05", "2006-08-05");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-06-09", "2006-06-09");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-05-26", "2006-05-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-05-08", "2006-05-08");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-05-07", "2006-05-07");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-05-06", "2006-05-06");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-02-26", "2006-02-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-02-09", "2006-02-09");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-02-01", "2006-02-01");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2006-01-10", "2006-01-10");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-10-27", "2005-10-27");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-10-25", "2005-10-25");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-07-27", "2005-07-27");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-06-26", "2005-06-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-05-26", "2005-05-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-03-26", "2005-03-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-01-26", "2005-01-26");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2005-01-05", "2005-01-05");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2004-12-14", "2004-12-14");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2004-09-14", "2004-09-14");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2004-07-15", "2004-07-15");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2004-03-01", "2004-03-01");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2003-12-03", "2003-12-03");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2002-09-13", "2002-09-13");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2002-04-08", "2002-04-08");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2001-03-30", "2001-03-30");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2000-04-20", "2000-04-20");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2010-03-04" AND language_alias="2010-03-04"), "101", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2009-11-04" AND language_alias="2009-11-04"), "102", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-10-02" AND language_alias="2008-10-02"), "103", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-09-24" AND language_alias="2008-09-24"), "104", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-06-26" AND language_alias="2008-06-26"), "105", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-06-23" AND language_alias="2008-06-23"), "106", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-03-23" AND language_alias="2008-03-23"), "107", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-05-04" AND language_alias="2008-05-04"), "108", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-04-05" AND language_alias="2008-04-05"), "109", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2008-03-26" AND language_alias="2008-03-26"), "110", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-10-25" AND language_alias="2007-10-25"), "111", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-06-05" AND language_alias="2007-06-05"), "112", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-05-23" AND language_alias="2007-05-23"), "113", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-05-15" AND language_alias="2007-05-15"), "114", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-05-05" AND language_alias="2007-05-05"), "115", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-05-04" AND language_alias="2007-05-04"), "116", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-04-04" AND language_alias="2007-04-04"), "117", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2007-03-12" AND language_alias="2007-03-12"), "118", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-08-05" AND language_alias="2006-08-05"), "119", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-06-09" AND language_alias="2006-06-09"), "120", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-05-26" AND language_alias="2006-05-26"), "121", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-05-08" AND language_alias="2006-05-08"), "122", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-05-07" AND language_alias="2006-05-07"), "123", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-05-06" AND language_alias="2006-05-06"), "124", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-02-26" AND language_alias="2006-02-26"), "125", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-02-09" AND language_alias="2006-02-09"), "126", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-02-01" AND language_alias="2006-02-01"), "127", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2006-01-10" AND language_alias="2006-01-10"), "128", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-10-27" AND language_alias="2005-10-27"), "129", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-10-25" AND language_alias="2005-10-25"), "130", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-07-27" AND language_alias="2005-07-27"), "131", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-06-26" AND language_alias="2005-06-26"), "132", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-05-26" AND language_alias="2005-05-26"), "133", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-03-26" AND language_alias="2005-03-26"), "134", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-01-26" AND language_alias="2005-01-26"), "135", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2005-01-05" AND language_alias="2005-01-05"), "136", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2004-12-14" AND language_alias="2004-12-14"), "137", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2004-09-14" AND language_alias="2004-09-14"), "138", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2004-07-15" AND language_alias="2004-07-15"), "139", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2004-03-01" AND language_alias="2004-03-01"), "140", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2003-12-03" AND language_alias="2003-12-03"), "141", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2002-09-13" AND language_alias="2002-09-13"), "142", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2002-04-08" AND language_alias="2002-04-08"), "143", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2001-03-30" AND language_alias="2001-03-30"), "144", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"),  (SELECT id FROM structure_permissible_values WHERE value="2000-04-20" AND language_alias="2000-04-20"), "145", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_consent_language', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("en", "en");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("fr", "fr");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_language"),  (SELECT id FROM structure_permissible_values WHERE value="fr" AND language_alias="fr"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_language"),  (SELECT id FROM structure_permissible_values WHERE value="en" AND language_alias="en"), "2", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_type', 'consent type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_version_date', 'consent version date', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_language', 'consent language', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_language"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'invitation_date', 'invitation date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'biological_material_use', 'biological material use', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'use_of_urine', 'use of urine', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'use_of_blood', 'use of blood', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'urine_blood_use_for_followup', 'urine blood use for followup', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_followup', 'stop followup', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_followup_date', 'stop followup date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'contact_for_additional_data', 'contact for additional data', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'allow_questionnaire', 'allow questionnaire', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_questionnaire', 'stop questionnaire', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_questionnaire_date', 'stop questionnaire date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'inform_significant_discovery', 'inform significant discovery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'research_other_disease', 'research other disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'inform_discovery_on_other_disease', 'inform discovery on other disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_type'), 
'1', '1', 'consent version', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_version_date'), 
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_language'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='invitation_date'), 
'1', '10', 'consent status', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status'), 
'1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date'), 
'1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date'), 
'1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied'), 
'1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='cd_icm_generics'),
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes'), 
'1', '17', 'additional information', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='biological_material_use'), 
'2', '1', 'agreements', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_urine'), 
'2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_blood'), 
'2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='research_other_disease'), 
'2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='urine_blood_use_for_followup'), 
'2', '10', 'followup', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_followup'), 
'2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_followup_date'), 
'2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='allow_questionnaire'), 
'2', '30', 'questionnaire', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_questionnaire'), 
'2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_questionnaire_date'), 
'2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='contact_for_additional_data'), 
'2', '39', 'contact agreement', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_significant_discovery'), 
'2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_discovery_on_other_disease'), 
'2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('fr', '', 'Fr', 'Fr'),
('en', '', 'Eng', 'Ang'),

('consent version', '', 'Version', 'Version'),
('consent type', '', 'Consent', 'Consentement'),
('consent version date', '', 'Version Date', 'Version/Date'),
('consent language', '', 'Language', 'Langue'),

('invitation date', '', 'Invitation Date', 'Date de délivrance'),

('additional information', '', 'Additional Information', 'Information additionnelle'),

('agreements', '', 'Agreements', 'Autorisations'),
('biological material use', '', 'Biological Material Use', 'Utilisation du materiel biologique'),
('use of urine', '', 'Use of Urine', 'Utilisation de l''urine'),
('use of blood', '', 'se of Blood', 'Utilisation du sange'),
('research other disease', '', 'Research On Other Disease', 'Recherche sur autre maladie'),

('followup', '', 'Followup', 'Suivi'),
('urine blood use for followup', '', 'Urine/Blood Use For Followup', 'Utilisation urine/sang pour suivi'),
('stop followup', '', 'Stop Followup', 'Arrêt du suivi'),
('stop followup date', '', 'Stop Date', 'Date d''arrêt'),

('questionnaire', '', 'Questionnaire', 'Questionnaire'),
('allow questionnaire', '', 'Allow Questionnaire', 'Autorise questionnaire'),
('stop questionnaire', '', 'Stop Questionnaire', 'Arrêt du questionnaire'),
('stop questionnaire date', '', 'Stop Date', 'Date d''arrêt'),

('contact agreement', '', 'Contact Agreement', 'Autorisation de contact'),
('contact for additional data', '', 'Contact for additional data', 'Contact pour données suplémentaires'),
('inform significant discovery', '', 'Inform of disease significant discovery', 'Informer des découvertes importantes sur la maladie'),
('inform discovery on other disease', '', 'Inform discovery on other disease', 'Informer des découvertes sur autre maladie');

# DIAGNOSIS --------------------------------------------------------------

UPDATE diagnosis_controls SET controls_type = 'sardo diagnosis' WHERE controls_type = 'sardo';

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dxd_sardos', '', '', '1', '1', '0', '1');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_sardos', 'sardo_morpho_desc', 'morphology description', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_sardos', 'icd_o_grade', 'icd-o grade', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_sardos', 'grade', 'grade', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_sardos', 'stade_figo', 'figo', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_sardos', 'laterality', 'laterality', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_sardos', 'sardo_diagnosis_id', 'sardo diagnosis id', '', 'input', 'size=20', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_sardos', 'last_sardo_import_date', 'last import date', '', 'date', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_identifier'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'), 
'0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy'), 
'0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx'), 
'0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_accuracy'), 
'0', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months'), 
'0', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes'), 
'0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code'), 
'1', '40', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology'), 
'1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_sardos' AND `field`='sardo_morpho_desc'), 
'1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_sardos' AND `field`='laterality'), 
'1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_sardos' AND `field`='icd_o_grade'), 
'1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_sardos' AND `field`='grade'), 
'1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_sardos' AND `field`='stade_figo'), 
'1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage'), 
'1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage'), 
'1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage'), 
'1', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary'), 
'1', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage'), 
'1', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage'), 
'1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage'), 
'1', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary'), 
'1', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_sardos' AND `field`='sardo_diagnosis_id'), 
'2', '60', 'sardo data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dxd_sardos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_sardos' AND `field`='last_sardo_import_date'), 
'2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'); 

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('sardo diagnosis', '', 'SARDO Diagnosis', 'Diagnostic SARDO'),
('morphology description', '', 'Description', 'Description'),
('figo', '', 'Figo', 'Figo'),
('sardo diagnosis id', '', 'SARDO Diagnosis Number', 'SARDO Numéro diagnostic'),
('icd-o grade', '', 'ICD-O Grade', 'Grade ICD-O'),
('diagnosis identifier', '', 'Diagnosis Code', 'Code su diagnostic');

# TREATMENT --------------------------------------------------------------

# EVENT ------------------------------------------------------------------

UPDATE menus SET flag_active = '0' WHERE parent_id = 'clin_CAN_4' AND language_title != 'lifestyle';
UPDATE menus SET use_link = '/clinicalannotation/event_masters/listall/lifestyle/%%Participant.id%%' WHERE id = 'clin_CAN_4';

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('ed_all_procure_lifestyle', '', '', '1', '1', '0', '1');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_procure_lifestyle_status', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("received", "received");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("delivered", "delivered");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("to deliver", "to deliver");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_procure_lifestyle_status"),  (SELECT id FROM structure_permissible_values WHERE value="to deliver" AND language_alias="to deliver"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_procure_lifestyle_status"),  (SELECT id FROM structure_permissible_values WHERE value="delivered" AND language_alias="delivered"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_procure_lifestyle_status"),  (SELECT id FROM structure_permissible_values WHERE value="received" AND language_alias="received"), "3", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'ed_all_procure_lifestyle', 'procure_lifestyle_status', 'status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_procure_lifestyle_status"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ed_all_procure_lifestyle', 'completed', 'completed', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='ed_all_procure_lifestyle'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='ed_all_procure_lifestyle'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),

((SELECT id FROM structures WHERE alias='ed_all_procure_lifestyle'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_procure_lifestyle' AND `field`='procure_lifestyle_status'), 
'0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ed_all_procure_lifestyle'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'), 
'0', '11', '', '1', 'status date', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ed_all_procure_lifestyle'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_procure_lifestyle' AND `field`='completed'), 
'0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ed_all_procure_lifestyle'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary'), 
'0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('received', '', 'Received', 'Reçu'),
('delivered', '', 'Delivered', 'Délivré'),
('to deliver', '', 'To Deliver', 'A délivrer');
 	
# FAMILYHISTORIES --------------------------------------------------------
	
INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'FamilyHistory', 'family_histories', 'sardo_diagnosis_id', 'sardo diagnosis id', '', 'input', 'size=20', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'FamilyHistory', 'family_histories', 'last_sardo_import_date', 'last import date', '', 'date', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

UPDATE structure_formats format, structures strct
SET format.flag_add ='0', format.flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0'
WHERE format.structure_id = strct.id
AND strct.alias = 'familyhistories'; 
 	
UPDATE structure_fields field, structure_formats format, structures strct
SET flag_index ='0', 
flag_detail ='0' 
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'familyhistories'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'FamilyHistory'
AND field.tablename = 'family_histories'
AND field.field IN  ('previous_primary_code', 'previous_primary_code_system', 'age_at_dx', 'age_at_dx_accuracy'); 

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), 
(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='sardo_diagnosis_id'), 
'2', '20', 'sardo data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='familyhistories'), 
(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='last_sardo_import_date'),
'2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1');

UPDATE structure_fields field, structure_formats format, structures strct
SET language_heading = 'coding'
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'familyhistories'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'FamilyHistory'
AND field.tablename = 'family_histories'
AND field.field IN  ('primary_icd10_code');

UPDATE structure_fields field, structure_formats format, structures strct
SET language_heading = 'relationship'
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'familyhistories'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'FamilyHistory'
AND field.tablename = 'family_histories'
AND field.field IN  ('family_domain');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('relationship', '', 'Relationship', 'Lien de parenté');

# REPRODUCTIVEHISTORIES --------------------------------------------------

UPDATE structure_fields field, structure_formats format, structures strct
SET format.flag_add ='0', format.flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0',
flag_index ='0', 
flag_detail ='0' 
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'reproductivehistories'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'ReproductiveHistory'
AND field.tablename = 'reproductive_histories'
AND field.field NOT IN  ('date_captured', 'lnmp_date', 'lnmp_accuracy', 'menopause_status', 
'age_at_menopause', 'menopause_age_accuracy'); 

UPDATE structure_fields field, structure_formats format, structures strct
SET display_column = '2', display_order = '99'
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'reproductivehistories'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'ReproductiveHistory'
AND field.tablename = 'reproductive_histories'
AND field.field IN ('date_captured');

# MESSAGES ---------------------------------------------------------------

UPDATE structures SET flag_add_columns = '1', flag_edit_columns = '1'
WHERE alias = 'participantmessages';

UPDATE structure_fields field, structure_formats format, structures strct
SET display_column = '2'
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'participantmessages'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'ParticipantMessage'
AND field.tablename = 'participant_messages'
AND field.field IN ('date_requested', 'due_date', 'expiry_date');

UPDATE structure_fields field, structure_formats format, structures strct
SET  format.flag_override_type = '1', format.type = 'datetime'
WHERE format.structure_id = strct.id
AND field.id = format.structure_field_id
AND strct.alias = 'participantmessages'
AND field.plugin = 'Clinicalannotation'
AND field.model = 'ParticipantMessage'
AND field.tablename = 'participant_messages'
AND field.field IN ('due_date');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_participant_message_status', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("completed", "completed");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("pending", "pending");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("in process", "in process");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_participant_message_status"),  (SELECT id FROM structure_permissible_values WHERE value="pending" AND language_alias="pending"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_participant_message_status"),  (SELECT id FROM structure_permissible_values WHERE value="in process" AND language_alias="in process"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_participant_message_status"),  (SELECT id FROM structure_permissible_values WHERE value="completed" AND language_alias="completed"), "3", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Clinicalannotation', 'ParticipantMessage', 'participant_messages', 'status', 'status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_participant_message_status"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='participantmessages'), 
(SELECT id FROM structure_fields WHERE `model`='ParticipantMessage' AND `tablename`='participant_messages' AND `field`='status'), 
'2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

# PARTICIPANT COLLECTIONS ------------------------------------------------
# CONTACTS ---------------------------------------------------------------
# CHRONOLOGY -------------------------------------------------------------

##########################################################################
# INVENTORY
##########################################################################

# COLLECTION -------------------------------------------------------------

-- collection site

SET @custom_collection_site_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="custom_collection_site");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("CHUQ", "CHUQ"),
("CHUS", "CHUS"),
("FIDES external clinic", "FIDES external clinic"),
("notre dame hospital", "notre dame hospital"),
("saint luc hospital", "saint luc hospital"),
("hotel dieu hospital", "hotel dieu hospital");

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = @custom_collection_site_domain_id;
INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@custom_collection_site_domain_id,  (SELECT id FROM structure_permissible_values WHERE value="CHUQ" AND language_alias="CHUQ"), "1", "1"),
(@custom_collection_site_domain_id,  (SELECT id FROM structure_permissible_values WHERE value="CHUS" AND language_alias="CHUS"), "2", "1"),
(@custom_collection_site_domain_id,  (SELECT id FROM structure_permissible_values WHERE value="FIDES external clinic" AND language_alias="FIDES external clinic"), "3", "1"),
(@custom_collection_site_domain_id,  (SELECT id FROM structure_permissible_values WHERE value="notre dame hospital" AND language_alias="notre dame hospital"), "4", "1"),
(@custom_collection_site_domain_id,  (SELECT id FROM structure_permissible_values WHERE value="saint luc hospital" AND language_alias="saint luc hospital"), "5", "1"),
(@custom_collection_site_domain_id,  (SELECT id FROM structure_permissible_values WHERE value="hotel dieu hospital" AND language_alias="hotel dieu hospital"), "6", "1");

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) 
VALUES
('CHUQ', 'CHUQ', 'CHUQ'),
('CHUS', 'CHUS', 'CHUS'),
('FIDES external clinic', 'FIDES - External Clinic', 'FIDES - Clinique externe'),
('notre dame hospital', 'Notre-Dame Hospital', 'Hôpital Notre-Dame'),
('saint luc hospital', 'Saint-Luc Hospital', 'Hôpital Saint-Luc'),
('hotel dieu hospital', 'Hôtel-Dieu Hospital', 'Hôpital Hôtel-Dieu');

-- Visit

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_visit_label', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("V01", "V01"),
("V02", "V02"),
("V03", "V03"),
("V04", "V04"),
("V05", "V05");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label"),  (SELECT id FROM structure_permissible_values WHERE value="V01" AND language_alias="V01"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label"),  (SELECT id FROM structure_permissible_values WHERE value="V02" AND language_alias="V02"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label"),  (SELECT id FROM structure_permissible_values WHERE value="V03" AND language_alias="V03"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label"),  (SELECT id FROM structure_permissible_values WHERE value="V04" AND language_alias="V04"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label"),  (SELECT id FROM structure_permissible_values WHERE value="V05" AND language_alias="V05"), "5", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'Collection', 'collections', 'visit_label', 'visit', '', 'select', '', '', ((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label")), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewCollection', '', 'visit_label', 'visit', '', 'select', '', '', ((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label")), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='collections'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='collection_tree_view'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label'), 
'1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='visit_label'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '1');

INSERT  IGNORE INTO `i18n` (`id`, `en`, `fr`) 
VALUES
('visit', 'Visit', 'Visite'),
("V01", "V01", "V01"),
("V02", "V02", "V02"),
("V03", "V03", "V03"),
("V04", "V04", "V04"),
("V05", "V05", "V05");

-- SOP hidden

UPDATE structure_fields field, structure_formats format
SET flag_add ='0', flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0',
flag_index ='0', 
flag_detail ='0' 
WHERE field.id = format.structure_field_id
AND field.plugin LIKE 'Inventorymanagement'
AND field.model LIKE '%Collection%'
AND field.field LIKE 'sop_master_id'; 

-- collection_datetime_accuracy into view

UPDATE structure_fields field, structure_formats format, structures
SET flag_add ='0', flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0',
flag_index ='0', 
flag_detail ='1' 
WHERE field.id = format.structure_field_id
AND structures.id = format.structure_id
AND structures.alias LIKE 'view_collection'
AND field.field LIKE 'collection_datetime_accuracy'; 

-- No Lab

ALTER TABLE banks
	ADD misc_identifier_control_id int(11) NULL DEFAULT NULL AFTER description;
	
ALTER TABLE `banks`
  ADD CONSTRAINT `FK_banks_misc_identifier_controls` FOREIGN KEY (`misc_identifier_control_id`) REFERENCES `misc_identifier_controls` (`id`);

SET @bank = 'Ovarian/Ovaire';
SET @identifier = 'ovary bank no lab';
UPDATE banks SET misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = @identifier) 
WHERE name = @bank;

SET @bank = 'Breast/Sein';
SET @identifier = 'breast bank no lab';
UPDATE banks SET misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = @identifier) 
WHERE name = @bank;

SET @bank = 'Kidney/Rein';
SET @identifier = 'kidney bank no lab';
UPDATE banks SET misc_identifier_control_id = (SELECT id FROM misc_identifier_controls 
WHERE misc_identifier_name = @identifier) WHERE name = @bank;

SET @identifier = 'head and neck bank no lab';
UPDATE banks SET misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = @identifier) 
WHERE name LIKE 'Head&Neck%';

SET @bank = 'Prostate';
SET @identifier = 'prostate bank no lab';
UPDATE banks SET misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = @identifier) 
WHERE name = @bank;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_identifier_name_list_from_id', 'open', '', 'Clinicalannotation.MiscIdentifierControl::getMisIdentPermissibleValuesFromId');

SET @domain_id = LAST_INSERT_ID();

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Administrate', 'Bank', 'banks', 'misc_identifier_control_id', 'bank identifier type', '', 'select', '', '', @domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @field_id = LAST_INSERT_ID();

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='banks'), 
@field_id, 
'0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1');

INSERT INTO `i18n` (`id`, `en`, `fr`) 
VALUES
('bank identifier type', '''No Labo'' Type', 'Type de ''No Labo''');

DROP VIEW IF EXISTS view_collections;
CREATE VIEW view_collections AS 
SELECT 
col.id AS collection_id, 
col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id, 

part.participant_identifier, 
ident.identifier_name,
ident.identifier_value,

col.acquisition_label, 
col.collection_site, 
col.visit_label, 
col.collection_datetime, 
col.collection_datetime_accuracy, 
col.collection_property, 
col.collection_notes, 
col.deleted,

banks.name AS bank_name

FROM collections AS col
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
WHERE col.deleted != 1;

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('bank no lab', '', 'Bank ''No Labo''', '''No Labo'' de la banque');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'ViewCollection', '', 'identifier_value', 'bank no lab', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='identifier_value'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '1');

# SAMPLE -----------------------------------------------------------------

SET @domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_specimen_supplier_dept');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = @domain_id;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('biological sample taking center', 'biological sample taking center'),
('clinic', 'clinic'),
('breast clinic', 'breast clinic'),
('external clinic', 'external clinic'),
('gynaecology/oncology clinic', 'gynaecology/oncology clinic'),
('family cancer center', 'family cancer center'),
('preoperative checkup', 'preoperative checkup'),
('operating room', 'operating room'),
('pathology dept', 'pathology dept'),
('other', 'other');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='biological sample taking center' AND language_alias='biological sample taking center'), "1", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='clinic' AND language_alias='clinic'), "2", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='breast clinic' AND language_alias='breast clinic'), "3", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='external clinic' AND language_alias='external clinic'), "4", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='gynaecology/oncology clinic' AND language_alias='gynaecology/oncology clinic'), "5", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='family cancer center' AND language_alias='family cancer center'), "6", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='preoperative checkup' AND language_alias='preoperative checkup'), "7", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='operating room' AND language_alias='operating room'), "8", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='pathology dept' AND language_alias='pathology dept'), "9", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='day surgery' AND language_alias='day surgery'), "10", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='other' AND language_alias='other'), "11", "1");

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('biological sample taking center', 'global', 'Biological Sample Taking Center', 'Centre de prélèvement'),
('breast clinic', 'global', 'Breast Clinic', 'Clinique du sein'),
('clinic', 'global', 'Clinic', 'Clinique'),
('external clinic', 'global', 'External Clinic', 'Clinique externe'),
('family cancer center', 'global', 'Family Cancer Center', 'Clinique des cancers familiaux'),
('gynaecology/oncology clinic', 'global', 'Gynaec/Onco Clinic', 'Clinique Gyneco/Onco'),
('operating room', 'global', 'Operating Room', 'Salle d''opération'),
('pathology dept', 'global', 'Pathology', 'Pathologie'),
('preoperative checkup', 'global', 'Preoperative Checkup', 'Bilan préopératoire');

SET @domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_laboratory_staff');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = @domain_id;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('aurore pierrard', 'aurore pierrard'),
('cecile grange', 'cecile grange'),
('chantale auger', 'chantale auger'),
('christine abaji', 'christine abaji'),
('emilio, johanne et phil', 'emilio, johanne et phil'),
('guillaume cardin', 'guillaume cardin'),
('hafida lounis', 'hafida lounis'),
('isabelle letourneau', 'isabelle letourneau'),
('jason madore', 'jason madore'),
('jennifer kendall dupont', 'jennifer kendall dupont'),
('jessica godin ethier', 'jessica godin ethier'),
('josh levin', 'josh levin'),
('julie desgagnes', 'julie desgagnes'),
('karine normandin', 'karine normandin'),
('katia caceres', 'katia caceres'),
('kevin gu', 'kevin gu'),
('labo externe', 'labo externe'),
('liliane meunier', 'liliane meunier'),
('lise portelance', 'lise portelance'),
('louise champoux', 'louise champoux'),
('magdalena zietarska', 'magdalena zietarska'),
('manon de ladurantaye', 'manon de ladurantaye'),
('marie-andree forget', 'marie-andree forget'),
('marie-josee milot', 'marie-josee milot'),
('marie-line puiffe', 'marie-line puiffe'),
('marise roy', 'marise roy'),
('matthew starek', 'matthew starek'),
('mona alam', 'mona alam'),
('nathalie delvoye', 'nathalie delvoye'),
('pathologie', 'pathologie'),
('patrick kibangou bondza', 'patrick kibangou bondza'),
('stephanie lepage', 'stephanie lepage'),
('teodora yaneva', 'teodora yaneva'),
('urszula krzemien', 'urszula krzemien'),
('valerie forest', 'valerie forest'),
('veronique barres', 'veronique barres'),
('veronique ouellet', 'veronique ouellet'),
('yuan chang', 'yuan chang'),
('unknown', 'unknown'),
('other', 'other');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='aurore pierrard' AND language_alias='aurore pierrard'), "0", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='cecile grange' AND language_alias='cecile grange'), "1", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='chantale auger' AND language_alias='chantale auger'), "2", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='christine abaji' AND language_alias='christine abaji'), "3", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='emilio, johanne et phil' AND language_alias='emilio, johanne et phil'), "4", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='guillaume cardin' AND language_alias='guillaume cardin'), "5", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='hafida lounis' AND language_alias='hafida lounis'), "6", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='isabelle letourneau' AND language_alias='isabelle letourneau'), "7", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='jason madore' AND language_alias='jason madore'), "8", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='jennifer kendall dupont' AND language_alias='jennifer kendall dupont'), "9", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='jessica godin ethier' AND language_alias='jessica godin ethier'), "20", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='josh levin' AND language_alias='josh levin'), "21", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='julie desgagnes' AND language_alias='julie desgagnes'), "22", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='karine normandin' AND language_alias='karine normandin'), "23", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='katia caceres' AND language_alias='katia caceres'), "24", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='kevin gu' AND language_alias='kevin gu'), "25", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='labo externe' AND language_alias='labo externe'), "26", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='liliane meunier' AND language_alias='liliane meunier'), "27", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='lise portelance' AND language_alias='lise portelance'), "28", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='louise champoux' AND language_alias='louise champoux'), "29", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='magdalena zietarska' AND language_alias='magdalena zietarska'), "40", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='manon de ladurantaye' AND language_alias='manon de ladurantaye'), "41", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='marie-andree forget' AND language_alias='marie-andree forget'), "42", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='marie-josee milot' AND language_alias='marie-josee milot'), "43", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='marie-line puiffe' AND language_alias='marie-line puiffe'), "44", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='marise roy' AND language_alias='marise roy'), "45", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='matthew starek' AND language_alias='matthew starek'), "46", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='mona alam' AND language_alias='mona alam'), "47", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='nathalie delvoye' AND language_alias='nathalie delvoye'), "48", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='pathologie' AND language_alias='pathologie'), "49", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='patrick kibangou bondza' AND language_alias='patrick kibangou bondza'), "50", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='stephanie lepage' AND language_alias='stephanie lepage'), "60", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='teodora yaneva' AND language_alias='teodora yaneva'), "61", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='urszula krzemien' AND language_alias='urszula krzemien'), "62", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='valerie forest' AND language_alias='valerie forest'), "63", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='veronique barres' AND language_alias='veronique barres'), "64", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='veronique ouellet' AND language_alias='veronique ouellet'), "65", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='yuan chang' AND language_alias='yuan chang'), "66", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='unknown' AND language_alias='unknown'), "80", "1"),
(@domain_id,  (SELECT id FROM structure_permissible_values WHERE value='other' AND language_alias='other'), "81", "1");

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aurore pierrard', 'global', 'Aurore Pierrard', 'Aurore Pierrard'),
('cecile grange', '', 'Cécile Grange', 'Cécile Grange'),
('other', 'global', 'Other', 'Autre'),
('chantale auger', 'global', 'Chantale Auger', 'Chantale Auger'),
('christine abaji', 'global', 'Christine Abaji', 'Christine Abaji'),
('emilio, johanne et phil', 'global', 'émilio, Johanne et Phil', 'émilio, Johanne et Phil'),
('guillaume cardin', 'global', 'Guillaume Cardin', 'Guillaume Cardin'),
('hafida lounis', 'global', 'Hafida Lounis', 'Hafida Lounis'),
('unknown', 'global', 'Unknown', 'Inconnu'),
('isabelle letourneau', 'global', 'Isabelle Létourneau', 'Isabelle Létourneau'),
('jason madore', 'global', 'Jason Madore', 'Jason Madore'),
('jennifer kendall dupont', 'global', 'Jennifer Kendall Dupont', 'Jennifer Kendall Dupont'),
('jessica godin ethier', 'global', 'Jessica Godin Ethier', 'Jessica Godin Ethier'),
('josh levin', 'global', 'Josh Levin', 'Josh Levin'),
('julie desgagnes', 'global', 'Julie Desgagnés', 'Julie Desgagnés'),
('karine normandin', 'global', 'Karine Normandin', 'Karine Normandin'),
('katia caceres', 'global', 'Katia Caceres', 'Katia Caceres'),
('kevin gu', 'global', 'Kevin Gu', 'Kevin Gu'),
('labo externe', 'global', 'Labo externe', 'Labo externe'),
('liliane meunier', 'global', 'Liliane Meunier', 'Liliane Meunier'),
('lise portelance', 'global', 'Lise Portelance', 'Lise Portelance'),
('louise champoux', 'global', 'Louise Champoux', 'Louise Champoux'),
('magdalena zietarska', 'global', 'Magdalena Zietarska', 'Magdalena Zietarska'),
('manon de ladurantaye', 'global', 'Manon de Ladurantaye', 'Manon de Ladurantaye'),
('marie-andree forget', 'global', 'Marie-Andrée Forget', 'Marie-Andrée Forget'),
('marie-josee milot', 'global', 'Marie-Josée Milot', 'Marie-Josée Milot'),
('marie-line puiffe', 'global', 'Marie-Line Puiffe', 'Marie-Line Puiffe'),
('marise roy', 'global', 'Marise Roy', 'Marise Roy'),
('matthew starek', 'global', 'Matthew Starek', 'Matthew Starek'),
('mona alam', 'global', 'Mona Alam', 'Mona Alam'),
('nathalie delvoye', 'global', 'Nathalie Delvoye', 'Nathalie Delvoye'),
('pathologie', 'global', 'Pathologie', 'Pathologie'),
('patrick kibangou bondza', 'global', 'Patrick Kibangou Bondza', 'Patrick Kibangou Bondza'),
('stephanie lepage', 'global', 'Stéphanie Lepage', 'Stéphanie Lepage'),
('teodora yaneva', 'global', 'Teodora Yaneva', 'Teodora Yaneva'),
('urszula krzemien', 'global', 'Urszula Krzemien', 'Urszula Krzemien'),
('valerie forest', 'global', 'Valérie Forest', 'Valérie Forest'),
('veronique barres', 'global', 'Véronique Barrès', 'Véronique Barrès'),
('veronique ouellet', 'global', 'Véronique Ouellet', 'Véronique Ouellet'),
('yuan chang', 'global', 'Yuan Chang', 'Yuan Chang');

UPDATE aliquot_masters SET stored_by = 'other' WHERE stored_by = 'autre';
UPDATE aliquot_masters SET stored_by = 'unknown' WHERE stored_by = 'inconnue';

UPDATE specimen_details SET reception_by = 'other' WHERE reception_by = 'autre';
UPDATE specimen_details SET reception_by = 'unknown' WHERE reception_by = 'inconnue';

UPDATE derivative_details SET creation_by = 'other' WHERE creation_by = 'autre';
UPDATE derivative_details SET creation_by = 'unknown' WHERE creation_by = 'inconnue';

UPDATE aliquot_uses SET used_by = 'other' WHERE used_by = 'autre';
UPDATE aliquot_uses SET used_by = 'unknown' WHERE used_by = 'inconnue';

UPDATE order_items SET added_by = 'other' WHERE added_by = 'autre';
UPDATE order_items SET added_by = 'unknown' WHERE added_by = 'inconnue';

UPDATE shipments SET shipped_by = 'other' WHERE shipped_by = 'autre';
UPDATE shipments SET shipped_by = 'unknown' WHERE shipped_by = 'inconnue';

UPDATE quality_ctrls SET run_by  = 'other' WHERE run_by  = 'autre';
UPDATE quality_ctrls SET run_by  = 'unknown' WHERE run_by  = 'inconnue';

-- SOP

-- SOP hidden

UPDATE structure_fields field, structure_formats format
SET flag_add ='0', flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0',
flag_index ='0', 
flag_detail ='0' 
WHERE field.id = format.structure_field_id
AND field.plugin LIKE 'Inventorymanagement'
AND field.model LIKE '%SampleMaster%'
AND field.field LIKE 'sop_master_id'; 

-- Visit Label & No Labo

DROP VIEW IF EXISTS view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
col.id AS collection_id, 
col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 
ident.identifier_name,
ident.identifier_value,

col.acquisition_label, 
col.visit_label,

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,
samp.sample_code,
samp.sample_label,
samp.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
WHERE samp.deleted != 1;

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'ViewSample', '', 'identifier_value', 'bank no lab', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewSample', '', 'visit_label', 'visit', '', 'select', '', '', ((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label")), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='identifier_value'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='visit_label'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

-- SAMPLE LABEL

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleMaster', 'sample_masters', 'sample_label', 'sample label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewSample', '', 'sample_label', 'sample label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('sample label', 'global', 'Sample Label', 'Identifiant de l''échantillon');

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_der_plasmas'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_der_serums'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_ascites'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_cystic_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_pericardial_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_peritoneal_washes'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_pleural_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_urines'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_undetailed_derivatives'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_undetailed_specimens'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='view_sample_joined_to_parent'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_label'), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Specimen Detail Fields

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_labo_type_code', 'open', '', 'Inventorymanagement.LabTypeLateralityMatch::getLaboTypeCodes');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SpecimenDetail', '', 'type_code', 'labo type code', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_labo_type_code'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SpecimenDetail', '', 'sequence_number', 'sequence number', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 'custom,/(^[\\d]*$)|(^[ABCabc]$)/', '0', '0', '', 'sequence should be an integer or equal to character A,B or C', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('labo type code', 'global', 'Type Code (Labo Defintion)', 'Code du type (Définition du labo)'),	
('sequence number', '', 'Sequence number', 'Numéro de séquence'),
('sequence should be an integer or equal to character A,B or C', 'global', 'The sequence number should be a positive integer or equal to character A,B or C!', 'Le numéro de séquence doit être un entier positif ou la lettre A,B ou C!');

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_ascites'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_ascites'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_spe_bloods'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_spe_cystic_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_cystic_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_spe_pericardial_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_pericardial_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_spe_peritoneal_washes'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_peritoneal_washes'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_spe_pleural_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_pleural_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_spe_urines'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_urines'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='sd_undetailed_specimens'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 
'1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_undetailed_specimens'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 
'1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

UPDATE lab_type_laterality_match SET selected_type_code = 'unknown' WHERE  selected_type_code = 'unknwon';
UPDATE specimen_details SET type_code = 'unknown' WHERE  type_code = 'unknwon';

-- blood type

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('gel SST', '', 'Gel SST', 'Gel SST');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("gel SST", "gel SST");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"),  (SELECT id FROM structure_permissible_values WHERE value="gel SST" AND language_alias="gel SST"), "3", "1");

UPDATE structure_value_domains_permissible_values SET flag_active = '0'
WHERE structure_value_domain_id IN (SELECT id FROM structure_value_domains WHERE domain_name="blood_type")
AND language_alias LIKE 'gel CSA';

-- pbmc details form

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'sd_der_pbmcs', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_blood_cell_storage_solution', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("DMSO + serum", "DMSO + serum");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_blood_cell_storage_solution"),  
(SELECT id FROM structure_permissible_values WHERE value="DMSO + serum" AND language_alias="DMSO + serum"), "3", "1");

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id IN (SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("Labo Christopoulos", "Labo Christopoulos"),
("Labo Dr Maugard", "Labo Dr Maugard"),
("Labo Dr Mes-Masson", "Labo Dr Mes-Masson"),
("Labo Dr Santos", "Labo Dr Santos"),
("Labo Sein", "Labo Sein"),
("Labo Dr Tonin", "Labo Dr Tonin"),
("other", "other"),
("unknown", "unknown");

UPDATE derivative_details SET creation_site = 'Labo Christopoulos' WHERE creation_site = 'labo christopoulos';

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="Labo Christopoulos" AND language_alias="Labo Christopoulos"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="Labo Dr Maugard" AND language_alias="Labo Dr Maugard"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="Labo Dr Mes-Masson" AND language_alias="Labo Dr Mes-Masson"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="Labo Dr Santos" AND language_alias="Labo Dr Santos"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="Labo Sein" AND language_alias="Labo Sein"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="Labo Dr Tonin" AND language_alias="Labo Dr Tonin"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="custom_laboratory_site"),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "18", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_pbmcs', 'tmp_solution', 'tmp blood cell solution', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_blood_cell_storage_solution'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias='sd_der_pbmcs');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type'), 
0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_type'), 
0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 
0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category'), 
0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id'), 
0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id'), 
0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic'), 
0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes'), 
0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime'), 
1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime_accuracy'), 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by'), 
1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site'), 
1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg'), 
1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),

((SELECT id FROM structures WHERE alias='sd_der_pbmcs'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_pbmcs' AND `field`='tmp_solution'), 
1, 40, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tmp blood cell solution','','Solution','Solution'),
('DMSO + serum','','DMSO + Serum','DMSO + Sérum');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('Labo Christopoulos', 'global', 'Labo Christopoulos', 'Labo Christopoulos'),
('Labo Dr Maugard', 'global', 'Labo Dr Maugard', 'Labo Dr Maugard'),
('Labo Dr Mes-Masson', 'global', 'Labo Dr Mes-Masson', 'Labo Dr Mes-Masson'),
('Labo Dr Santos', 'global', 'Labo Dr Santos', 'Labo Dr Santos'),
('Labo Dr Tonin', 'global', 'Labo Dr Tonin', 'Labo Dr Tonin'),
('Labo Sein', 'global', 'Labo Sein', 'Labo Sein');

-- pbmc details form

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'sd_der_blood_cells', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_blood_cells', 'tmp_solution', 'tmp blood cell solution', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_blood_cell_storage_solution'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias='sd_der_blood_cells');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type'), 
0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_type'), 
0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 
0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category'), 
0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id'), 
0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id'), 
0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic'), 
0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes'), 
0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime'), 
1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime_accuracy'), 
1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by'), 
1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site'), 
1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg'), 
1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),

((SELECT id FROM structures WHERE alias='sd_der_blood_cells'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_blood_cells' AND `field`='tmp_solution'), 
1, 40, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

-- Tissue

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_labo_tissue_laterality', 'open', '', NULL);

SET @qc_labo_tissue_laterality_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('D', 'lab laterality D'),	-- 3
('EP', 'lab laterality EP'),	-- 6
('G', 'lab laterality G'),	-- 9
('M', 'lab laterality M'),	-- 12
('PT', 'lab laterality PT'),	-- 15
('TR', 'lab laterality TR'),	-- 18
('TRD', 'lab laterality TRD'),	-- 21
('TRG', 'lab laterality TRG'),	-- 24
('UniLat NS', 'lab laterality UniLat NS'),	-- 27
('unknown', 'unknown');	-- 50

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="D" AND language_alias="lab laterality D"), "3", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="EP" AND language_alias="lab laterality EP"), "6", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="G" AND language_alias="lab laterality G"), "9", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="M" AND language_alias="lab laterality M"), "12", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="PT" AND language_alias="lab laterality PT"), "15", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="TR" AND language_alias="lab laterality TR"), "18", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="TRD" AND language_alias="lab laterality TRD"), "21", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="TRG" AND language_alias="lab laterality TRG"), "24", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="UniLat NS" AND language_alias="lab laterality UniLat NS"), "27", "1"),
(@qc_labo_tissue_laterality_domain_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "50", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'labo_laterality', 'labo tissue laterality', '', 'select', '', '', @qc_labo_tissue_laterality_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('lab laterality D', 'global', 'D', 'D'),
('lab laterality EP', 'global', 'EP', 'EP'),
('lab laterality G', 'global', 'G', 'G'),
('lab laterality M', 'global', 'M', 'M'),
('lab laterality PT', 'global', 'PT', 'PT'),
('lab laterality TR', 'global', 'TR', 'TR'),
('lab laterality TRD', 'global', 'TRD', 'TRD'),
('lab laterality TRG', 'global', 'TRG', 'TRG'),
('lab laterality UniLat NS', 'global', 'UniLateral unspecified', 'UniLatéral non spécifié');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('labo tissue laterality', 'global', 'Laterality (Labo Defintion)', 'Latéralité (Définition du labo)');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'tmp_buffer_use', 'tmp buffer use', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'yesno'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tmp buffer use', 'global', 'Bufferer Use', 'Utilisation de Tampon');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'tmp_on_ice', 'tmp on ice', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'yesno'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tmp on ice', 'global', 'On Ice', 'Sur Glace');

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_spe_tissues'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='labo_laterality'), 
1, 36, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_tissues'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tmp_buffer_use'), 
1, 60, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_tissues'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tmp_on_ice'), 
1, 61, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

-- cell culture

UPDATE sd_der_cell_cultures SET culture_status = 'active' WHERE culture_status = 'in culture';
UPDATE sd_der_cell_cultures SET culture_status_reason = 'thrown' WHERE culture_status_reason = 'threw';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('thrown', 'thrown');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'cell_culture_status_reason'), 
(SELECT id FROM structure_permissible_values WHERE value="thrown" AND language_alias="thrown"), "3", "1");

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('thrown', 'global', 'Thrown', 'Jeté');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_cell_collection_method', 'open', '', NULL);

SET @qc_cell_collection_method_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('unknown','unknown'),
('centrifugation','centrifugation'),
('collagenase','collagenase'),
('mechanic','mechanic'),
('tissue section','tissue section'),
('scratching','scratching'),
('trypsin','trypsin'),
('scissors','scissors'),
('clone','clone'),
('spheroides','spheroides');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="centrifugation" AND language_alias="centrifugation"), "2", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="collagenase" AND language_alias="collagenase"), "3", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="mechanic" AND language_alias="mechanic"), "5", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="tissue section" AND language_alias="tissue section"), "6", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="scratching" AND language_alias="scratching"), "7", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trypsin" AND language_alias="trypsin"), "8", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="scissors" AND language_alias="scissors"), "9", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="clone" AND language_alias="clone"), "10", "1"),
(@qc_cell_collection_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="spheroides" AND language_alias="spheroides"), "11", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_cell_cultures', 'tmp_collection_method', 'tmp collection method', '', 'select', '', '', @qc_cell_collection_method_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_culture_hormone', 'open', '', NULL);

SET @qc_culture_hormone_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('unknown','unknown'),
('egf+bpe+insulin+hydrocortisone','egf+bpe+insulin+hydrocortisone'),
('b-estradiol','b-estradiol'),
('progesterone','progesterone'),
('b-estradiol+progesterone','b-estradiol+progesterone');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_culture_hormone_domain_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1"),
(@qc_culture_hormone_domain_id, (SELECT id FROM structure_permissible_values WHERE value="egf+bpe+insulin+hydrocortisone" AND language_alias="egf+bpe+insulin+hydrocortisone"), "2", "1"),
(@qc_culture_hormone_domain_id, (SELECT id FROM structure_permissible_values WHERE value="b-estradiol" AND language_alias="b-estradiol"), "3", "1"),
(@qc_culture_hormone_domain_id, (SELECT id FROM structure_permissible_values WHERE value="progesterone" AND language_alias="progesterone"), "4", "1"),
(@qc_culture_hormone_domain_id, (SELECT id FROM structure_permissible_values WHERE value="b-estradiol+progesterone" AND language_alias="b-estradiol+progesterone"), "5", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_cell_cultures', 'tmp_hormon', 'tmp hormon', '', 'select', '', '', @qc_culture_hormone_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('b-estradiol', 'global', 'B-estradiol', 'B-estradiol'),
('b-estradiol+progesterone', 'global', 'B-estradiol+Progesterone', 'B-estradiol+Progestérone'),
('centrifugation', 'global', 'Centrifugation', 'Centrifugation'),
('clone', 'global', 'Clone', 'Clone'),
('collagenase', 'global', 'Collagenase', 'Collagénase'),
('egf+bpe+insulin+hydrocortisone', 'global', 'EGF+BPE+Insulin+Hydrocortisone', 'EGF+BPE+Insuline+Hydrocortisone'),
('mechanic', 'global', 'Mechanic', 'Mécanique'),
('progesterone', 'global', 'Progesterone', 'Progestérone'),
('scissors', 'global', 'Scissors', 'Ciseaux'),
('scratching', 'global', 'Scratching', 'Grattage'),
('spheroides', 'global', 'Spheroides', 'Sphéro&iuml;des'),
('tissue section', 'global', 'Tissue Section', 'Bouts de tissu'),
('tmp collection method', 'global', 'Collection Method', 'Méthode de prélèvement'),
('tmp hormon', 'global', 'Hormon', 'Hormone'),
('trypsin', 'global', 'Trypsin', 'Trypsine'),
('unknown', 'global', 'Unknown', 'Inconnu');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_culture_solution', 'open', '', NULL);

SET @qc_culture_solution_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('unknown','unknown'), -- 1", "1"),
('OSE','OSE'), -- 2", "1"),
('DMEM','DMEM'), -- 3", "1"),
('CSF-C100(CHO)','CSF-C100(CHO)'); -- 4", "1"),

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_culture_solution_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1"),
(@qc_culture_solution_id, (SELECT id FROM structure_permissible_values WHERE value="OSE" AND language_alias="OSE"), "2", "1"),
(@qc_culture_solution_id, (SELECT id FROM structure_permissible_values WHERE value="DMEM" AND language_alias="DMEM"), "3", "1"),
(@qc_culture_solution_id, (SELECT id FROM structure_permissible_values WHERE value="CSF-C100(CHO)" AND language_alias="CSF-C100(CHO)"), "4", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_cell_cultures', 'tmp_solution', 'tmp culture solution', '', 'select', '', '', @qc_culture_solution_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('CSF-C100(CHO)', 'global', 'CSF-C100(CHO)', 'CSF-C100(CHO)'),
('DMEM', 'global', 'DMEM', 'DMEM'),
('OSE', 'global', 'OSE', 'OSE'),
('tmp culture solution', 'global', 'Culture Solution', 'Milieu de Culture');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_cell_cultures', 'tmp_percentage_of_oxygen', 'tmp percentage of oxygen', '', 'float_positive', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_cell_cultures', 'tmp_percentage_of_serum', 'tmp percentage of serum', '', 'float_positive', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_cell_cultures' AND `field`='tmp_collection_method'), 
1, 60, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_cell_cultures' AND `field`='tmp_hormon'), 
1, 61, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_cell_cultures' AND `field`='tmp_solution'), 
1, 62, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_cell_cultures' AND `field`='tmp_percentage_of_oxygen'), 
1, 63, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_cell_cultures' AND `field`='tmp_percentage_of_serum'), 
1, 64, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tmp percentage of oxygen', 'global', 'Oxygen Percentage', 'Pourcentage d''oxygène'),
('tmp percentage of serum', 'global', 'Serum Percentage', 'Pourcentage de Sérum');

-- dna

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'sd_der_dnas', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_source_storage_solution', 'open', '', NULL);

SET @qc_source_storage_solution_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('OCT','oct solution'), -- 5", "1"),
('isopentane','isopentane'), -- 6", "1"),
('isopentane + OCT','isopentane + oct'), -- 7", "1"),
('none','none'), -- 0", "1"),
('RNA later','RNA later'), -- 8", "1"),
('paraffin','paraffin'), -- 9", "1"),
('culture medium','culture medium'), -- 10", "1"),
('DMSO','DMSO'), -- 1", "1"),
('serum','serum'), -- 2", "1"),
('DMSO + serum','DMSO + serum'), -- 3", "1"),
('trizol','trizol'), -- 4", "1"),
('unknown','unknown'), -- 0", "1"),
('cell culture medium','cell culture medium'); -- 5", "1"),

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="OCT" AND language_alias="oct solution"), "5", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="isopentane" AND language_alias="isopentane"), "6", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="isopentane + OCT" AND language_alias="isopentane + oct"), "7", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "0", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="RNA later" AND language_alias="RNA later"), "8", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="paraffin" AND language_alias="paraffin"), "9", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="culture medium" AND language_alias="culture medium"), "10", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="DMSO" AND language_alias="DMSO"), "1", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "2", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="DMSO + serum" AND language_alias="DMSO + serum"), "3", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol" AND language_alias="trizol"), "4", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "0", "1"),
(@qc_source_storage_solution_domain_id, (SELECT id FROM structure_permissible_values WHERE value="cell culture medium" AND language_alias="cell culture medium"), "5", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_source_storage_method', 'open', '', NULL);

SET @qc_source_storage_method_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('flash freeze','flash freeze'),
('none','none');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_source_storage_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="flash freeze" AND language_alias="flash freeze"), "1", "1"),
(@qc_source_storage_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "2", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_dna_extraction_method', 'open', '', NULL);

SET @qc_dna_extraction_method_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('phenol Chloroform','phenol Chloroform'), -- 1", "1"),
('flexigene DNA kit','flexigene DNA kit'), -- 2", "1"),
('trizol and scissors','trizol and scissors'), -- 5", "1"),
('trizol and homogenizer','trizol and homogenizer'), -- 6", "1"),
('trizol','trizol'); -- ), "3", "1");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_dna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="phenol Chloroform" AND language_alias="phenol Chloroform"), "1", "1"),
(@qc_dna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="flexigene DNA kit" AND language_alias="flexigene DNA kit"), "2", "1"),
(@qc_dna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol and scissors" AND language_alias="trizol and scissors"), "5", "1"),
(@qc_dna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol and homogenizer" AND language_alias="trizol and homogenizer"), "6", "1"),
(@qc_dna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol" AND language_alias="trizol"), "3", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_dnas', 'source_cell_passage_number', 'source cell passage number', '', 'integer', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_dnas', 'source_temperature', 'source storage temperature', '', 'float', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_dnas', 'source_temp_unit', '', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'temperature_unit_code'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_dnas', 'tmp_source_milieu', 'tmp source storage solution', '', 'select', '', '', @qc_source_storage_solution_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_dnas', 'tmp_source_storage_method', 'tmp source storage method', '', 'select', '', '', @qc_source_storage_method_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_dnas', 'tmp_extraction_method', 'tmp dna extraction method', '', 'select', '', '', @qc_dna_extraction_method_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias='sd_der_dnas');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type'), 
0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_type'), 
0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 
0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', 
'0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category'), 
0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id'), 
0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id'), 
0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic'), 
0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes'), 
0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime'), 
1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime_accuracy'), 
1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by'), 
1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site'), 
1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg'), 
1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),

((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='source_cell_passage_number'), 
1, 40, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='source_temperature'), 
1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='source_temp_unit'), 
1, 42, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='tmp_source_milieu'), 
1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='tmp_source_storage_method'), 
1, 44, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_dnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='tmp_extraction_method'), 
1, 45, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('culture medium', 'global', 'Culture medium', 'Milieu de culture'),
('DMSO + FBS', 'global', 'DMSO + FBS', 'DMSO + FBS'),
('flash freeze', 'global', 'Flash Freeze', 'Flash Freeze'),
('flexigene DNA kit', 'global', 'Flexigene DNA Kit', 'Kit ''Flexigene DNA'''),
('isopentane', 'global', 'Isopentane', 'Isopentane'),
('isopentane + oct', 'global', 'Isopentane + OCT', 'Isopentane + OCT'),
('none', 'global', 'None', ''),
('oct', 'global', 'Oct', 'Oct'),
('paraffin', 'global', 'Paraffin', 'Paraffine'),
('phenol Chloroform', 'global', 'Phenol Chloroform', 'Phénol/Chloroforme'),
('RNA later', 'global', 'RNA later', 'RNA later'),
('source cell passage number', 'global', 'Source Cell Passage Number', 'Nomber de passages cellulaires de la source'),
('source storage temperature', 'global', 'Source Storage Temperature', 'Température d''entreposage de la Source'),
('tmp dna extraction method', 'global', 'DNA Extraction Method', 'Méthode d''Extraction de l''ADN'),
('tmp source storage method', 'global', 'Source Storage Method', 'Méthode d''Entreposage de la Source'),
('tmp source storage solution', 'global', 'Source Storage Medium', 'Milieu d''Entreposage de la Source'),
('trizol', 'global', 'Trizol', 'Trizol'),
('trizol and homogenizer', 'global', 'Trizol and homogenizer', ''),
('trizol and scissors', 'global', 'Trizol and scissors', '');

INSERT IGNORE  INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cell culture medium', 'global', 'Cell Culture Medium', 'Milieu de culture'),
('DMSO', 'global', 'DMSO', 'DMSO'),
('DMSO + serum', 'global', 'DMSO + Serum', 'DMSO + Sérum'),
('serum', 'global', 'Serum', 'Sérum'),
('trizol', 'global', 'Trizol', 'Trizol');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cell culture medium', 'global', 'Cell Culture Medium', 'Milieu de culture'),
('culture medium', 'global', 'Culture medium', 'Milieu de culture');

-- rna

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'sd_der_rnas', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_rna_extraction_method', 'open', '', NULL);

SET @qc_rna_extraction_method_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('paxgene blood RNA kit','paxgene blood RNA kit'), -- 1", "1"),
('trizol','trizol'), -- 3", "1"),
('trizol and quiagen cleanup','trizol and quiagen cleanup'), -- 4", "1"),
('trizol and scissors','trizol and scissors'), -- 5", "1"),
('trizol and homogenizer','trizol and homogenizer'), -- 6", "1"),
('quiagen rneasy kit','quiagen rneasy kit'); -- 2", "1"),

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_rna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="paxgene blood RNA kit" AND language_alias="paxgene blood RNA kit"), "1", "1"),
(@qc_rna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol" AND language_alias="trizol"), "3", "1"),
(@qc_rna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol and quiagen cleanup" AND language_alias="trizol and quiagen cleanup"), "4", "1"),
(@qc_rna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol and scissors" AND language_alias="trizol and scissors"), "5", "1"),
(@qc_rna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="trizol and homogenizer" AND language_alias="trizol and homogenizer"), "6", "1"),
(@qc_rna_extraction_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="quiagen rneasy kit" AND language_alias="quiagen rneasy kit"), "2", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_rnas', 'source_cell_passage_number', 'source cell passage number', '', 'integer', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_rnas', 'source_temperature', 'source storage temperature', '', 'float', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_rnas', 'source_temp_unit', '', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'temperature_unit_code'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_rnas', 'tmp_source_milieu', 'tmp source storage solution', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_source_storage_solution'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_rnas', 'tmp_source_storage_method', 'tmp source storage method', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_source_storage_method'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_rnas', 'tmp_extraction_method', 'tmp rna extraction method', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_rna_extraction_method'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias='sd_der_rnas');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type'), 
0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_type'), 
0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 
0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', 
'0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category'), 
0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id'), 
0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id'), 
0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic'), 
0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes'), 
0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime'), 
1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime_accuracy'), 
1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by'), 
1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site'), 
1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg'), 
1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),

((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='source_cell_passage_number'), 
1, 40, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='source_temperature'), 
1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='source_temp_unit'), 
1, 42, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='tmp_source_milieu'), 
1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='tmp_source_storage_method'), 
1, 44, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='tmp_extraction_method'), 
1, 45, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('paxgene blood RNA kit', 'global', 'Paxgene Blood RNA Kit', 'Kit ''Paxgene Blood RNA'''),
('quiagen rneasy kit', 'global', 'Quiagen RNeasy Kit', 'Kit ''Quiagen RNeasy Kit'''),
('trizol', 'global', 'Trizol', 'Trizol'),
('trizol and homogenizer', 'global', 'Trizol and homogenizer', ''),
('trizol and quiagen cleanup', 'global', 'Trizol and quiagen cleanup', ''),
('tmp rna extraction method', 'global', 'RNA Extraction Method', 'Méthode d''Extraction de l''ARN'),
('trizol and scissors', 'global', 'Trizol and scissors', '');

-- amplified rna

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'sd_der_amplified_rnas', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_rna_amplification_method', 'open', '', NULL);

SET @qc_rna_amplification_method_domain_id = LAST_INSERT_ID();

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('alethia-arcturus','alethia-arcturus'), 
('alethia-ramp','alethia-ramp'); 

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_rna_amplification_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="alethia-arcturus" AND language_alias="alethia-arcturus"), "1", "1"),
(@qc_rna_amplification_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="alethia-ramp" AND language_alias="alethia-ramp"), "2", "1"),
(@qc_rna_amplification_method_domain_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "3", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_amplified_rnas', 'tmp_amplification_number', 'tmp rna amplification number', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_der_amplified_rnas', 'tmp_amplification_method', 'tmp rna amplification method', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_rna_amplification_method'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias='sd_der_amplified_rnas');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type'), 
0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_type'), 
0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 
0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code'), 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', 
'0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category'), 
0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id'), 
0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id'), 
0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic'), 
0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes'), 
0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime'), 
1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime_accuracy'), 
1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by'), 
1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site'), 
1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg'), 
1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),

((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_amplified_rnas' AND `field`='tmp_amplification_method'), 
1, 40, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_der_amplified_rnas'),  
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_amplified_rnas' AND `field`='tmp_amplification_number'), 
1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('alethia-arcturus', 'global', 'Alethia-Arcturus', 'Aléthia-Arcturus'),
('alethia-ramp', 'global', 'Alethia-Ramp', 'Aléthia-Ramp'),
('tmp rna amplification method', 'global', 'RNA Amplification Method', 'Méthode d''Amplification de l''ARN'),
('tmp rna amplification number', 'global', 'RNA Amplification Number', 'Numéro de l''Amplification');

-- other fluid

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'sd_spe_other_fluids', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_formats WHERE structure_id= (SELECT id FROM structures WHERE alias='sd_spe_other_fluids');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code'), 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_label'), 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category'), 0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id'), 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic'), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes'), 0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='supplier_dept'), 1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='reception_by'), 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='reception_datetime'), 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='reception_datetime_accuracy'), 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_rec_spent_time_msg'), 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='type_code'), 1, 36, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 1, 37, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume'), 1, 42, '', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
((SELECT id FROM structures WHERE alias='sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume_unit'), 1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('other fluid', '', 'Other Fluid', 'Autre liquide'),
('other fluid cell', '', 'Other Fluid Cell', 'Cellules de liquide ''autre'''),
('other fluid supernatant', '', 'Other Fluid Supernatant', 'Surnageant de liquide ''autre''');

# ALIQUOT ----------------------------------------------------------------

DELETE FROM sample_to_aliquot_controls WHERE aliquot_control_id IN (SELECT id FROM `aliquot_controls` WHERE `aliquot_type` LIKE 'bag');
DELETE FROM `aliquot_controls` WHERE `aliquot_type` LIKE 'bag';

-- Visit Label & No Labo

DROP VIEW IF EXISTS view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
samp.id AS sample_master_id,
col.id AS collection_id, 
col.bank_id, 
stor.id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 
ident.identifier_name,
ident.identifier_value,

col.acquisition_label, 
col.visit_label,

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,
samp.sample_label,

al.barcode,
al.aliquot_type,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
WHERE al.deleted != 1;
  
INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'identifier_value', 'bank no lab', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'visit_label', 'visit', '', 'select', '', '', ((SELECT id FROM structure_value_domains WHERE domain_name="qc_visit_label")), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='identifier_value'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='visit_label'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'sample_label', 'sample label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats
(`structure_id`, 
`structure_field_id`, 
`display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_label'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

-- view_aliquot_joined_to_collection.aliquot_use_counter hidden

UPDATE structure_fields field, structure_formats format, structures
SET flag_add ='0', flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0',
flag_index ='0', 
flag_detail ='0' 
WHERE field.id = format.structure_field_id
AND structures.id = format.structure_id
AND structures.alias LIKE 'view_aliquot_joined_to_collection'
AND field.field LIKE 'aliquot_use_counter'; 

-- aliquot label

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_label', 'aliquot label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_field_id = (SELECT id FROM structure_fields WHERE field LIKE 'aliquot_label');

INSERT INTO structure_formats
(structure_id, structure_field_id,display_column,display_order,language_heading,flag_override_label,language_label,flag_override_tag,language_tag,flag_override_help,language_help,flag_override_type,`type`,flag_override_setting,setting,flag_override_default,`default`,flag_add,flag_add_readonly,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail,created,created_by,modified,modified_by)
VALUES
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tubes'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tubes_incl_ml_vol'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tiss_blocks'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tiss_slides'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_whatman_papers'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_tubes_incl_ml_vol'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cell_slides'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_tubes_incl_ul_vol_and_conc'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tiss_cores'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cel_gel_matrices'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cell_cores'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cell_tubes_incl_ml_vol'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),

((SELECT id FROM structures WHERE structures.alias LIKE 'basic_aliquot_search_result'), @structure_field_id, '1','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','1','0','0','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'tma_slide_content_search'), @structure_field_id, '0','3',' ','1','tissue core','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','0','0','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'qctestedaliquots'), @structure_field_id, '0','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','1','1','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'aliquot_masters_for_collection_tree_view'), @structure_field_id, '0','2',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','0','0','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'aliquot_masters_for_storage_tree_view'), @structure_field_id, '0','2',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','0','0','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'sourcealiquots'), @structure_field_id, '0','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','1','1','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'orderitems'), @structure_field_id, '0','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','1','0','0','1','1','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'aliquotmasters'), @structure_field_id, '0','9',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','0','0','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'children_aliquots_selection'), @structure_field_id, '1','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','1','1','0','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'realiquotedparent'), @structure_field_id, '0','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','0','0','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'shippeditems'), @structure_field_id, '1','10',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0','0','0','0','0','0','1','1','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aliquot label', 'global', 'Aliquot Label', 'Étiquette de l''aliquot');

-- Add missing instock detail values

UPDATE aliquot_masters SET in_stock_detail = 'contaminated' WHERE in_stock_detail = 'contamined';

SET @_domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'aliquot_in_stock_detail');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('accident','accident'),
('destroyed','destroyed'),
('quality problem','quality problem'),
('see consent','see consent'),
('injected to mice','injected to mice');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@_domain_id, (SELECT id FROM structure_permissible_values WHERE value="accident" AND language_alias="accident"), "1", "1"),
(@_domain_id, (SELECT id FROM structure_permissible_values WHERE value="destroyed" AND language_alias="destroyed"), "1", "1"),
(@_domain_id, (SELECT id FROM structure_permissible_values WHERE value="quality problem" AND language_alias="quality problem"), "1", "1"),
(@_domain_id, (SELECT id FROM structure_permissible_values WHERE value="see consent" AND language_alias="see consent"), "1", "1"),
(@_domain_id, (SELECT id FROM structure_permissible_values WHERE value="injected to mice" AND language_alias="injected to mice"), "1", "1");

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('accident', 'global', 'Accident', 'Accident'),
('destroyed', 'global', 'Destroyed', 'Détruit'),
('injected to mice', 'global', 'Injected to Mice', 'Injété à une souris'),
('quality problem', 'global', 'Quality Problem', 'Mauvaise qualité'),
('see consent', 'global', 'See Consent', 'Voir consentement');

-- aliquot sop hidden

UPDATE structure_fields field, structure_formats format
SET flag_add ='0', flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0',
flag_index ='0', 
flag_detail ='0' 
WHERE field.id = format.structure_field_id
AND field.model LIKE 'AliquotMaster'
AND field.field LIKE 'sop_master_id'; 

-- Add stored by

SET @domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_laboratory_staff');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'stored_by', 'stored by', '', 'select', '', '', @domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_field_id = (SELECT id FROM structure_fields WHERE field LIKE 'stored_by' AND tablename LIKE 'aliquot_masters');

INSERT INTO structure_formats
(structure_id, structure_field_id,display_column,display_order,language_heading,flag_override_label,language_label,flag_override_tag,language_tag,flag_override_help,language_help,flag_override_type,`type`,flag_override_setting,setting,flag_override_default,`default`,flag_add,flag_add_readonly,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail,created,created_by,modified,modified_by)
VALUES
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tubes'), @structure_field_id,'0','26 ',' ','0 ',' ','0 ',' ','0 ',' ','0 ',' ','0 ',' ','0 ',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tubes_incl_ml_vol'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tiss_blocks'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tiss_slides'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_whatman_papers'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_tubes_incl_ml_vol'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cell_slides'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_tubes_incl_ul_vol_and_conc'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_spec_tiss_cores'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cel_gel_matrices'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cell_cores'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_cell_tubes_incl_ml_vol'), @structure_field_id,'0','26',' ','0',' ','0',' ','0',' ','0',' ','0',' ','0',' ','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('stored by', 'global', 'Stored By', 'Entreposé par');

-- add dna rna storage solution

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_dna_rna_storage_solution', 'open', '', NULL);

SET @qc_dna_rna_storage_solution = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_dna_rna_storage_solution');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('TE buffer','TE buffer'), 
('H2O','H2O'), 
('br5 (paxgene kit)','br5 (paxgene kit)');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_dna_rna_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="TE buffer" AND language_alias="TE buffer"), "1", "1"),
(@qc_dna_rna_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="H2O" AND language_alias="H2O"), "1", "1"),
(@qc_dna_rna_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="br5 (paxgene kit)" AND language_alias="br5 (paxgene kit)"), "1", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_storage_solution', 'tmp storage solution', '', 'select', '', '', @qc_dna_rna_storage_solution, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_field_id = LAST_INSERT_ID();

INSERT INTO structure_formats
(structure_id, structure_field_id,display_column,display_order,language_heading,flag_override_label,language_label,flag_override_tag,language_tag,flag_override_help,language_help,flag_override_type,`type`,flag_override_setting,setting,flag_override_default,`default`,flag_add,flag_add_readonly,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail,created,created_by,modified,modified_by)
VALUES
((SELECT id FROM structures WHERE structures.alias LIKE 'ad_der_tubes_incl_ul_vol_and_conc'), @structure_field_id,'1','80 ',' ','0 ',' ','0 ',' ','0 ',' ','0 ',' ','0 ',' ','0 ',' ','1','0','1','0','0','0','0','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('br5 (paxgene kit)', 'global', 'BR5 (Paxgene kit)', 'BR5 (kit ''Paxgene'')'),
('H2O', 'global', 'H2O', 'H2O'),
('TE buffer', 'global', 'TE Buffer', 'Tampon TE'),
('tmp storage solution', 'global', 'Storage Solution (tmp)', 'Solution d''Entreposage (tmp)');

-- add psec tiss tubes

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'sd_spe_tissue_tubes', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_id = (SELECT id FROM structures WHERE alias LIKE 'sd_spe_tissue_tubes');




AliquotDetail][tmp_storage_solution
tissue_storage_solution
<option selected="selected" value="none">None</option>
<option value="DMSO + FBS">DMSO + FBS</option>
<option value="OCT">OCT</option>
<option value="isopentane">Isopentane</option>
<option value="isopentane + OCT">Isopentane + OCT</option>
<option value="RNA later">RNA later</option>
<option value="paraffin">Paraffin</option>
<option value="culture medium">Culture medium</option>

AliquotDetail][tmp_storage_method
tissue_storage_method
<option value="flash freeze">Flash Freeze</option>
<option selected="selected" value="none">None</option>

INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'),@structure_id,'0','5','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label'),@structure_id,'0','9','0','0','0','0','0','0','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type'),@structure_id,'0','9','0','0','0','0','0','0','1','1','1','1','0','0','1','1','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode'),@structure_id,'0','10','0','0','0','0','0','0','1','0','1','1','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock'),@structure_id,'0','13','0','0','0','0','0','0','1','0','1','0','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail'),@structure_id,'0','14','0','0','0','0','0','0','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='Generated' AND `tablename`='' AND `field`='aliquot_use_counter'),@structure_id,'0','15','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label'),@structure_id,'0','20','0','0','0','0','0','0','1','0','1','0','0','0','1','0','0','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label'),@structure_id,'0','20','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_master_id'),@structure_id,'0','21','0','0','0','0','0','0','1','0','1','0','0','0','1','0','0','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code'),@structure_id,'0','21','1','1','code','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x'),@structure_id,'0','23','0','0','0','0','0','0','1','0','1','0','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y'),@structure_id,'0','24','0','0','0','0','0','0','1','0','1','0','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime'),@structure_id,'0','26','0','0','0','0','0','0','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='stored_by'),@structure_id,'0','26','0','0','0','0','0','0','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature'),@structure_id,'0','30','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit'),@structure_id,'0','31','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id'),@structure_id,'0','35','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id'),@structure_id,'0','36','0','0','0','0','0','0','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes'),@structure_id,'0','40','0','0','0','0','0','0','1','0','1','0','0','0','0','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='Generated' AND `tablename`='' AND `field`='coll_to_stor_spent_time_msg'),@structure_id,'1','60','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='Generated' AND `tablename`='' AND `field`='rec_to_stor_spent_time_msg'),@structure_id,'1','61','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type'),@structure_id,'1','70','0','0','0','0','0','0','1','0','1','0','0','0','1','0','1','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code'),@structure_id,'1','71','0','0','0','0','0','0','1','0','1','0','0','0','1','0','0','1','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0'),
((SELECT id FROM structure_fields WHERE `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl'),@structure_id,'1','100','0','0','0','0','0','0','0','0','0','0','0','0','1','1','0','0','0000-00-00 00:00:00','0','2010-02-12 00:00:00','0');




