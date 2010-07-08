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
(null, (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='sequence_number'), 'custom,/(^[0-9]*$)|(^[ABCabc]$)/', '1', '0', '', 'sequence should be an integer or equal to character A,B or C', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

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

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label'), 'notEmpty', '0', '0', '', 'aliquot label is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aliquot label is required', 'global', 'Aliquot label is required!', 'étiquette de l''aliquot est requis!');

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
('tmp storage solution', 'global', 'Storage Solution', 'Solution d''Entreposage');

-- add specimen tissus tubes

ALTER TABLE `structure_fields`
  DROP KEY `unique_fields`;
  
ALTER TABLE `structure_fields`
	ADD UNIQUE KEY `unique_fields` (`field`,`model`,`tablename`, `structure_value_domain`);

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'ad_spec_tissue_tubes', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_tissue_storage_solution', 'open', '', NULL);

SET @qc_tissue_storage_solution = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_tissue_storage_solution');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('none', 'none'),
('DMSO + FBS','DMSO + FBS'), 
('OCT','oct solution'), 
('isopentane','isopentane'), 
('isopentane + OCT','isopentane + oct'), 
('RNA later', 'RNA later'),
('paraffin', 'paraffin'),
('culture medium', 'culture medium');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "1", "1"),
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="DMSO + FBS" AND language_alias="DMSO + FBS"), "2", "1"),
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="OCT" AND language_alias="oct solution"), "3", "1"),
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="isopentane" AND language_alias="isopentane"), "4", "1"),
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="isopentane + OCT" AND language_alias="isopentane + oct"), "5", "1"),
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="RNA later" AND language_alias="RNA later"), "5", "1"),
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="paraffin" AND language_alias="paraffin"), "5", "1"),
(@qc_tissue_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="culture medium" AND language_alias="culture medium"), "8", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_tissue_storage_method', 'open', '', NULL);

SET @qc_tissue_storage_method = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_tissue_storage_method');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('flash freeze','flash freeze'), 
('none','none');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_tissue_storage_method, (SELECT id FROM structure_permissible_values WHERE value="flash freeze" AND language_alias="flash freeze"), "1", "1"),
(@qc_tissue_storage_method, (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "2", "1");
	
INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_storage_method', 'tmp storage method', '', 'select', '', '', @qc_tissue_storage_method, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_storage_solution', 'tmp storage solution', '', 'select', '', '', @qc_tissue_storage_solution, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_id = (SELECT id FROM structures WHERE alias LIKE 'ad_spec_tissue_tubes');

INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'),@structure_id, '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type'),@structure_id, '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label'),@structure_id, '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode'),@structure_id, '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock'),@structure_id, '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail'),@structure_id, '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='Generated' AND `tablename`=' ' AND `field`='aliquot_use_counter'),@structure_id, '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='FunctionManagement' AND `tablename`=' ' AND `field`='recorded_storage_selection_label'),@structure_id, '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label'),@structure_id, '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_master_id'),@structure_id, '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code'),@structure_id, '0', '21', '', '1', '', '1', 'code', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x'),@structure_id, '0', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y'),@structure_id, '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime'),@structure_id, '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='stored_by'),@structure_id, '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature'),@structure_id, '0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit'),@structure_id, '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id'),@structure_id, '0', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id'),@structure_id, '0', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes'),@structure_id, '0', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`=' ' AND `field`='used_blood_volume'),@structure_id, '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`=' ' AND `field`='used_blood_volume_unit'),@structure_id, '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Core' AND `model`='FunctionManagement' AND `tablename`=' ' AND `field`='CopyCtrl'),@structure_id, '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),

((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_storage_method' AND structure_value_domain = @qc_tissue_storage_method),@structure_id,'1','81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_storage_solution'  AND structure_value_domain = @qc_tissue_storage_solution),@structure_id,'1','82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tmp storage method', 'global', 'Storage Method', 'Méthode d''Entreposage');

-- add block

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_gleason_grade_values', 'open', '', NULL);

SET @qc_gleason_grade_values = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_gleason_grade_values');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('1','1'), 
('2','2'), 
('3','3'), 
('4','4'), 
('5','5');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_gleason_grade_values, (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
(@qc_gleason_grade_values, (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
(@qc_gleason_grade_values, (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
(@qc_gleason_grade_values, (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1"),
(@qc_gleason_grade_values, (SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "5", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_tissue_primary_desc', 'open', '', NULL);

SET @qc_tissue_primary_desc = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_tissue_primary_desc');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('normal','normal'), 
('tumor','normal'), 
('hyperplasia','hyperplasia'), 
('stroma','stroma'), 
('PIN','PIN'), 
('HBP','HBP'), 
('prostatitis','prostatitis'); 

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_tissue_primary_desc, (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="normal"), "1", "1"),
(@qc_tissue_primary_desc, (SELECT id FROM structure_permissible_values WHERE value="tumor" AND language_alias="tumor"), "2", "1"),
(@qc_tissue_primary_desc, (SELECT id FROM structure_permissible_values WHERE value="hyperplasia" AND language_alias="hyperplasia"), "3", "1"),
(@qc_tissue_primary_desc, (SELECT id FROM structure_permissible_values WHERE value="stroma" AND language_alias="stroma"), "4", "1"),
(@qc_tissue_primary_desc, (SELECT id FROM structure_permissible_values WHERE value="PIN" AND language_alias="PIN"), "5", "1"),
(@qc_tissue_primary_desc, (SELECT id FROM structure_permissible_values WHERE value="HBP" AND language_alias="HBP"), "6", "1"),
(@qc_tissue_primary_desc, (SELECT id FROM structure_permissible_values WHERE value="prostatitis" AND language_alias="prostatitis"), "7", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'sample_position_code', 'position code', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'path_report_code', 'path report code', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_gleason_primary_grade', 'tmp gleason score', 'primary grade', 'select', '', '', @qc_gleason_grade_values, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_gleason_secondary_grade', '', 'secondary grade', 'select', '', '', @qc_gleason_grade_values, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_tissue_primary_desc', 'tmp tissue description', 'primary', 'select', '', '', @qc_tissue_primary_desc, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_tissue_secondary_desc', '', 'secondary', 'select', '', '', @qc_tissue_primary_desc, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_id = (SELECT id FROM structures WHERE alias LIKE 'ad_spec_tiss_blocks');

INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='sample_position_code'),@structure_id,'1','81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='path_report_code'),@structure_id,'1','82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_gleason_primary_grade'),@structure_id,'1','85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_gleason_secondary_grade'),@structure_id,'1','86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_tissue_primary_desc'),@structure_id,'1','88', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_tissue_secondary_desc'),@structure_id,'1','89', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('HBP', 'global', 'HBP', 'HBP'),
('hyperplasia', 'global', 'Hyperplasia', 'Hyperplasie'),
('isopentane + oct', 'global', 'Isopentane + OCT', 'Isopentane + OCT'),
('path report code', 'global', 'Path Report Code', 'Code de rapport de pathologie'),
('PIN', 'global', 'PIN', 'PIN'),
('position code', 'global', 'Position Code', 'Code de position'),
('primary grade', 'global', 'Primary Grade', 'Grade primaire'),
('prostatitis', 'global', 'Prostatitis', 'prostatite'),
('secondary grade', 'global', 'Secondary Grade', 'Grade secondaire'),
('stroma', 'global', 'Stroma', 'Stroma'),
('tmp gleason score', 'global', 'Gleason Score', 'Grade de Gleason'),
('tmp tissue description', 'global', 'Tissue Description', 'Description du tissu');

-- add cell culture tubes

INSERT INTO `structures` (`id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'ad_cell_culture_tubes', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_id = (SELECT id FROM structures WHERE alias LIKE 'ad_cell_culture_tubes');

DELETE FROM structure_formats WHERE structure_id = @structure_id;
INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type'), @structure_id, '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='GeneratedParentSample' AND `field`='sample_type'), @structure_id, '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), @structure_id, '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type'), @structure_id, '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label'), @structure_id, '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode'), @structure_id, '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock'), @structure_id, '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail'), @structure_id, '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),

((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='Generated' AND `field`='aliquot_use_counter'), @structure_id, '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout'  AND `model`='FunctionManagement' AND `field`='recorded_storage_selection_label'), @structure_id, '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout'  AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label'), @structure_id, '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_master_id'), @structure_id, '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout'  AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code'), @structure_id, '0', '21', '', '1', '', '1', 'code', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x'), @structure_id, '0', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y'), @structure_id, '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),

((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime'), @structure_id, '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='stored_by'), @structure_id, '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout'  AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature'), @structure_id, '0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Storagelayout'  AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit'), @structure_id, '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id'), @structure_id, '0', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id'), @structure_id, '0', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes'), @structure_id, '0', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='Generated' AND `field`='creat_to_stor_spent_time_msg'), @structure_id, '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotDetail' AND `field`='lot_number'), @structure_id, '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume'), @structure_id, '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit'), @structure_id, '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume'), @structure_id, '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit'), @structure_id, '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Core'  AND `model`='FunctionManagement' AND `field`='CopyCtrl'), @structure_id, '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_cell_storage_solution', 'open', '', NULL);

SET @qc_cell_storage_solution = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_cell_storage_solution');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('DMSO','DMSO'), -- 1", "1"),
('serum','serum'), -- 2", "1"),
('DMSO + serum','DMSO + serum'), -- 3", "1"),
('trizol','trizol'), -- 4", "1"),
('unknown','unknown'), -- 0", "1"),
('cell culture medium','cell culture medium'); -- 5", "1"),

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_cell_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="" AND language_alias=""), "1", "1"),

(@qc_cell_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="DMSO" AND language_alias="DMSO"), "1", "1"),
(@qc_cell_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "2", "1"),
(@qc_cell_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="DMSO + serum" AND language_alias="DMSO + serum"), "3", "1"),
(@qc_cell_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="trizol" AND language_alias="trizol"), "4", "1"),
(@qc_cell_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1"),
(@qc_cell_storage_solution, (SELECT id FROM structure_permissible_values WHERE value="cell culture medium" AND language_alias="cell culture medium"), "5", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'cell_passage_number', 'cell passage number ', '', 'input', 'size=6', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'AliquotDetail', '', 'tmp_storage_solution', 'tmp storage solution', '', 'select', '', '', @qc_cell_storage_solution, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement'  AND `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_passage_number'), 'custom,/(^[0-9]*[-][0-9]+$)|(^[0-9]*$)/', '1', '0', '', 'cell passage number should be a positif integer or an interval', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cell culture medium', 'global', 'Cell Culture Medium', 'Milieu de culture'),
('cell passage number', 'global', 'Cell Passage number', 'Nombre de passages cellulaires'),
('cell passage number should be a positif integer or an interval', 'global', 'Cell Passage number should be a positive integer or an interval (ex: ''3-6'')!', 'Nombre de passages cellulaires doit être un entier positif ou un intervalle (ex: ''3-6'')!'),
('DMSO', 'global', 'DMSO', 'DMSO'),
('DMSO + serum', 'global', 'DMSO + Serum', 'DMSO + Sérum'),
('serum', 'global', 'Serum', 'Sérum'),
('tmp storage solution', 'global', 'Storage Solution', 'Solution d''Entreposage'),
('trizol', 'global', 'Trizol', 'Trizol');

SET @structure_id = (SELECT id FROM structures WHERE alias LIKE 'ad_cell_culture_tubes');

INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_passage_number'),@structure_id,'1','81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='AliquotDetail' AND `tablename`='' AND `field`='tmp_storage_solution'  AND structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_cell_storage_solution')),@structure_id,'1','82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

-- Update use code for realiquoted aliquot

UPDATE aliquot_uses, realiquotings, aliquot_masters AS child
SET aliquot_uses.use_code = child.barcode
WHERE aliquot_uses.id = realiquotings.aliquot_use_id
AND child.id = realiquotings.child_aliquot_master_id
AND aliquot_uses.use_definition = 'realiquoted to';

-- Update Quality control data

SET @quality_control_unit = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'quality_control_unit');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('230/280','230/280');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@quality_control_unit, (SELECT id FROM structure_permissible_values WHERE value="230/280" AND language_alias="230/280"), "1", "1");

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('230/280', 'global', '230/280', '230/280');

UPDATE structure_value_domains_permissible_values SET display_order = '2' WHERE language_alias LIKE '260/230';
UPDATE structure_value_domains_permissible_values SET display_order = '3' WHERE language_alias LIKE '260/268';
UPDATE structure_value_domains_permissible_values SET display_order = '4' WHERE language_alias LIKE '260/280';
UPDATE structure_value_domains_permissible_values SET display_order = '5' WHERE language_alias LIKE '28/18';
UPDATE structure_value_domains_permissible_values SET display_order = '10' WHERE language_alias LIKE 'RIN';
UPDATE structure_value_domains_permissible_values SET display_order = '11' WHERE language_alias LIKE 'n/a';

SET @custom_laboratory_qc_tool = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'custom_laboratory_qc_tool');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('beckman','beckman'),
('bioanalyzer 1','bioanalyzer 1'),
('nanodrop','nanodrop'),
('pharmacia','pharmacia');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = @custom_laboratory_qc_tool;
INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@custom_laboratory_qc_tool, (SELECT id FROM structure_permissible_values WHERE value="beckman" AND language_alias="beckman"), "1", "1"),
(@custom_laboratory_qc_tool, (SELECT id FROM structure_permissible_values WHERE value="bioanalyzer 1" AND language_alias="bioanalyzer 1"), "2", "1"),
(@custom_laboratory_qc_tool, (SELECT id FROM structure_permissible_values WHERE value="nanodrop" AND language_alias="nanodrop"), "3", "1"),
(@custom_laboratory_qc_tool, (SELECT id FROM structure_permissible_values WHERE value="pharmacia" AND language_alias="pharmacia"), "4", "1");

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('beckman', 'global', 'Beckman', 'Beckman'),
('bioanalyzer 1', 'global', 'BioAnalyzer 1', 'BioAnalyzer 1'),
('nanodrop', 'global', 'Nanodrop', 'Nanodrop'),
('pharmacia', 'global', 'Pharmacia', 'Pharmacia');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_chip_model', 'open', '', NULL);

SET @qc_chip_model = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_chip_model');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('nano','nano'), -- 0", "1"),
('pico','pico'); -- 5", "1"),

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_chip_model, (SELECT id FROM structure_permissible_values WHERE value="nano" AND language_alias="nano"), "1", "1"),
(@qc_chip_model, (SELECT id FROM structure_permissible_values WHERE value="pico" AND language_alias="pico"), "2", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'QualityCtrl', '', 'position_into_run', 'position into run', '', 'input', 'size=6', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'QualityCtrl', '', 'chip_model', 'chip model', '', 'select', '', '', @qc_chip_model, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_id = (SELECT id FROM structures WHERE alias IN ('QualityCtrls'));
INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='QualityCtrl' AND `field`='position_into_run'),@structure_id,'0','12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='QualityCtrl' AND `field`='chip_model'),@structure_id,'0','13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('chip model', 'global', 'Chip Model', 'Model de puce'),
('nano', 'global', 'Nano', 'Nano'),
('position into run', 'global', 'Position', 'Position'),
('pico', 'global', 'Pico', 'Pico');

SET @use_id = (SELECT id FROM `aliquot_uses` WHERE `aliquot_master_id` = '32556' AND `use_definition` LIKE 'quality control' AND `used_volume` IS NULL);
DELETE FROM `quality_ctrl_tested_aliquots` WHERE `aliquot_use_id` = @use_id;
DELETE FROM `aliquot_uses` WHERE `id` = @use_id;

-- add order missing field

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_order_type', 'open', '', NULL);

SET @qc_order_type = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_order_type');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('other','other'), -- 5", "1"),
('microarray','microarray'); -- 5", "1"),

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_order_type, (SELECT id FROM structure_permissible_values WHERE value="microarray" AND language_alias="microarray"), "1", "1"),
(@qc_order_type, (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "1", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Order', 'Order', '', 'microarray_chip', 'microarray chip', '', 'input', 'size=6', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Order', 'Order', '', 'type', 'type', '', 'select', '', '', @qc_order_type, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_id = (SELECT id FROM structures WHERE alias IN ('Orders'));
INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Order' AND `model`='Order' AND `field`='type'),@structure_id,'1','4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0'),
((SELECT id FROM structure_fields WHERE `plugin`='Order' AND `model`='Order' AND `field`='microarray_chip'),@structure_id,'1','4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('microarray chip', 'global', 'Chip', 'Puce'),
('microarray', 'global', 'Microarray', 'Bio-puce');

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Order', 'OrderItem', 'order_items', 'shipping_name', 'shipping name', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @field_id = LAST_INSERT_ID();
SET @structure_id = (SELECT id FROM structures WHERE alias IN ('orderitems'));
INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((@field_id),@structure_id,'0','1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('shipping name', 'global', 'Shipping Name', 'Nom d''envoi');

UPDATE order_items SET aliquot_use_id = NULL WHERE aliquot_use_id = '0'; 

-- Study tool update

UPDATE structure_formats format, structures strct
SET format.flag_add ='0', format.flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0', 
flag_search ='0', flag_search_readonly ='0', 
flag_datagrid ='0', flag_datagrid_readonly ='0',
flag_index ='0',  flag_detail ='0'
WHERE format.structure_id = strct.id
AND strct.alias = 'studysummaries'
AND format.structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `field` IN ('title', 'start_date', 'end_date', 'summary')); 

-- update tool menu

UPDATE menus set flag_active = '0' WHERE parent_id = 'tool_CAN_100';
UPDATE menus set flag_active = '1' WHERE id = 'tool_CAN_104';

UPDATE menus set flag_active = '0' WHERE use_link LIKE '/sop/%';
UPDATE menus set flag_active = '0' WHERE use_link LIKE '/rtbform/%';
UPDATE menus set flag_active = '0' WHERE use_link LIKE '/protocol/%';
UPDATE menus set flag_active = '0' WHERE use_link LIKE '/material/%';
UPDATE menus set flag_active = '0' WHERE use_link LIKE '/drug/%';

-- Clean up storage

UPDATE storage_controls
SET form_alias = 'std_tma_blocks'
WHERE form_alias = 'std_tmas';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('box100', '', 'Box100 10x10', 'Boîte100 10x10'),
('box27', '', 'Box27 3x9', 'Boîte27 3x9'),
('box49', '', 'Box49 7x7', 'Boîte49 7x7'),
('rack20', '', 'Rack20 4x5', 'Râtelier20 4x5'),
('rack', '', 'Rack', 'Râtelier');

UPDATE `storage_controls` SET `display_x_size` = '3',
`display_y_size` = '9',
`horizontal_increment` = '0' WHERE `storage_controls`.`storage_type` = 'box27' ;

-- Add tissue nature

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'qc_tissue_nature', 'open', '', NULL);

SET @qc_tissue_nature = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_tissue_nature');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('benign','benign'),
('malignant','malignant'),
('metastatic','metastatic'),
('normal','normal'),
('unknown','unknown');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
(@qc_tissue_nature, (SELECT id FROM structure_permissible_values WHERE value="benign" AND language_alias="benign"), "1", "1"),
(@qc_tissue_nature, (SELECT id FROM structure_permissible_values WHERE value="malignant" AND language_alias="malignant"), "2", "1"),
(@qc_tissue_nature, (SELECT id FROM structure_permissible_values WHERE value="metastatic" AND language_alias="metastatic"), "3", "1"),
(@qc_tissue_nature, (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="normal"), "4", "1"),
(@qc_tissue_nature, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "5", "1");

INSERT INTO structure_fields (id, public_identifier, plugin, model, tablename, field, language_label, language_tag, `type`, setting, `default`, structure_value_domain, language_help, validation_control, value_domain_control, field_control, created, created_by, modified, modified_by) 
VALUES
(null, '', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'tissue_nature', 'tissue nature', '', 'select', '', '', @qc_tissue_nature, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

SET @structure_id = (SELECT id FROM structures WHERE alias IN ('sd_spe_tissues'));
INSERT INTO `structure_formats` (`structure_field_id`, `structure_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES
((SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='SampleDetail' AND `field`='tissue_nature'),@structure_id,'1','42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '0', '2010-02-12 00:00', '0');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('benign', 'global', 'Benign', 'Bénin'),
('malignant', 'global', 'Malignant', 'Malin'),
('metastatic', 'global', 'Metastatic', 'Métastases'),
('normal', 'global', 'Normal', 'Normal'),
('tissue nature', 'global', 'Nature', 'Nature'),
('unknown', 'global', 'Unknown', 'Inconnu');

-- Change tissue fields to read only

UPDATE structure_formats format, structures strct
SET format.flag_add ='0', format.flag_add_readonly ='0', 
flag_edit ='0', flag_edit_readonly ='0'
WHERE format.structure_id = strct.id
AND strct.alias = 'sd_spe_tissues'
AND format.structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Inventorymanagement' AND `model`='SampleDetail' AND `field` IN ('tissue_laterality', 'tissue_source')); 

-- Clean up lab_type_laterality_match

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id IN (SELECT id FROM `structure_value_domains` WHERE domain_name = 'qc_labo_tissue_laterality');
UPDATE structure_value_domains SET source = 'Inventorymanagement.LabTypeLateralityMatch::getLaboLaterality' WHERE domain_name = 'qc_labo_tissue_laterality';

ALTER TABLE `lab_type_laterality_match`
	ADD UNIQUE KEY `unique_records` (`selected_type_code`,`selected_labo_laterality`,`sample_type_matching`);

UPDATE sd_spe_tissues SET tissue_nature = 'unknown' WHERE tissue_nature = 'unknwon';
UPDATE sd_spe_tissues SET tissue_source = 'unknown' WHERE tissue_source = 'unknwon';
UPDATE sd_spe_tissues SET tissue_laterality = 'unknown' WHERE tissue_laterality = 'unknwon';
UPDATE sd_spe_tissues SET labo_laterality = 'unknown' WHERE labo_laterality = 'unknwon';

UPDATE specimen_details SET type_code = 'unknown' WHERE type_code = 'unknwon';
UPDATE specimen_details SET sequence_number = 'unknown' WHERE sequence_number = 'unknwon';

UPDATE lab_type_laterality_match SET selected_type_code = 'unknown' WHERE selected_type_code = 'unknwon';
UPDATE lab_type_laterality_match SET selected_labo_laterality = 'unknown' WHERE selected_labo_laterality = 'unknwon';
UPDATE lab_type_laterality_match SET sample_type_matching = 'unknown' WHERE sample_type_matching = 'unknwon';
UPDATE lab_type_laterality_match SET tissue_source_matching = 'unknown' WHERE tissue_source_matching = 'unknwon';
UPDATE lab_type_laterality_match SET nature_matching = 'unknown' WHERE nature_matching = 'unknwon';
UPDATE lab_type_laterality_match SET laterality_matching = 'unknown' WHERE laterality_matching = 'unknwon';

UPDATE aliquot_masters SET aliquot_label = REPLACE(aliquot_label,'unknwon','unknown');
UPDATE sample_masters SET sample_label = REPLACE(sample_label,'unknwon','unknown');

UPDATE lab_type_laterality_match SET nature_matching = 'benign' WHERE nature_matching = 'begnin';
UPDATE sd_spe_tissues SET tissue_nature = 'benign' WHERE tissue_nature = 'begnin';

UPDATE structure_value_domains SET source = 'Inventorymanagement.LabTypeLateralityMatch::getTissueSourcePermissibleValues' WHERE domain_name = 'tissue_source_list';

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('breast', 'global', 'Breast', 'Sein'),
('hypopharynx', 'global', 'Hypopharynx', 'Hypopharynx'),
('larynx', 'global', 'Larynx', 'Larynx'),
('nasopharynx', 'global', 'Nasopharynx', 'Nasopharynx'),
('oral cavity', 'global', 'Oral Cavity', 'Cavité orale'),
('oropharynx', 'global', 'Oropharynx', 'Oropharynx'),
('other', 'global', 'Other', 'Autre'),
('ovary', 'global', 'Ovary', 'Ovaire'),
('prostate', 'global', 'Prostate', 'Prostate'),
('peritoneum', '', 'Peritoneum', 'Peritoneum'),


('fallopian tube', 'global', 'Fallopian Tube', 'Trompe de Fallope'),
('uterus', 'global', 'Uterus', 'Utérus'),
('other (metastasis)', 'global', 'Other (metastasis)', 'Other (métastase)'),
('omentum', 'global', 'Omentum', 'Épiploon'),

('unknown', 'global', 'Unknown', 'Inconnu');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('the selected type code and labo laterality combination is not supported', 'global', 'The selected ''type code'' and ''labo laterality'' combination is not supported for the sample type ''Tissue''!', 'La combinaison ''code du type'' et ''latéralité'' sélectionnée n''est pas supportée pour le type de l''échantillon ''Tissu''!'),
('the selected type code does not match sample type', 'global', 'The selected type code can not be attached to the sample type!', 'Le code du type ne peut être utilisé pour le type de l''échantillon!');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM `structure_fields` WHERE field = 'aliquot_label' AND model = 'AliquotMaster'), 'maxLength,60', '0', '0', '', 'label size is limited', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('label size is limited', '', 'The label size is limited!', 'La taille du label est limitée!');

UPDATE structures, structure_formats, structure_fields
SET flag_add = '0', flag_datagrid = '0'
WHERE structures.id = structure_formats.structure_id
AND structure_formats.structure_field_id = structure_fields.id
AND alias LIKE 'ad_%'
AND field = 'barcode' 
AND model = 'AliquotMaster';

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('qc_err_inv_barcode_generation_error', 1, 'system error', 'qc_err_inv_barcode_generation_error', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('qc_err_inv_barcode_generation_error', '', 'The system is unable to generate aliquot barcodes! Please contact your system administrator!', 'La système ne peut créer les barcodes des aliquots! Veuillez contacter l''administrateur de votre système!');

-- Move DB fields to match 2.0.2A

ALTER TABLE `ad_tubes` MODIFY COLUMN `lot_number` varchar(30) DEFAULT NULL AFTER `aliquot_master_id`;
ALTER TABLE `aliquot_controls` MODIFY COLUMN `form_alias` varchar(255) NOT NULL AFTER `flag_active`;
ALTER TABLE `aliquot_controls` MODIFY COLUMN `detail_tablename` varchar(255) NOT NULL AFTER `form_alias`;
DROP TABLE `ed_allsolid_lab_pathology`;
DROP TABLE `ed_allsolid_lab_pathology_revs`;
ALTER TABLE `event_controls` MODIFY COLUMN `form_alias` varchar(255) NOT NULL AFTER `flag_active`;
ALTER TABLE `event_controls` MODIFY COLUMN `detail_tablename` varchar(255) NOT NULL AFTER `form_alias`;
ALTER TABLE `aliquot_controls` MODIFY COLUMN `detail_tablename` varchar(255) NOT NULL AFTER `form_alias`;
ALTER TABLE `family_histories` MODIFY COLUMN `participant_id` int(11) DEFAULT NULL AFTER `age_at_dx_accuracy`;
ALTER TABLE `misc_identifiers` MODIFY COLUMN `participant_id` int(11) DEFAULT NULL AFTER `notes`;
ALTER TABLE `misc_identifier_controls` MODIFY COLUMN `display_order` int(11) NOT NULL DEFAULT '0' AFTER `flag_active`;
ALTER TABLE `participants` MODIFY COLUMN `middle_name` varchar(50) DEFAULT NULL AFTER `first_name`;
ALTER TABLE `participant_contacts` MODIFY COLUMN `phone` varchar(30) NOT NULL DEFAULT '' AFTER `mail_code`;
ALTER TABLE `participant_contacts_revs` MODIFY COLUMN `phone` varchar(30) NOT NULL DEFAULT '' AFTER `mail_code`;
ALTER TABLE `participant_messages` MODIFY COLUMN `participant_id` int(11) DEFAULT NULL AFTER `expiry_date`;
ALTER TABLE `quality_ctrls` MODIFY COLUMN `sample_master_id` int(11) DEFAULT NULL AFTER `qc_code`;
ALTER TABLE `quality_ctrls` MODIFY COLUMN `date` date DEFAULT NULL AFTER `run_by`;
ALTER TABLE `quality_ctrl_tested_aliquots` MODIFY COLUMN `aliquot_master_id` int(11) DEFAULT NULL AFTER `quality_ctrl_id`;
ALTER TABLE `quality_ctrl_tested_aliquots` MODIFY COLUMN `aliquot_use_id` int(11) DEFAULT NULL AFTER `aliquot_master_id`;
ALTER TABLE `sample_controls` MODIFY COLUMN `form_alias` varchar(255) NOT NULL AFTER `flag_active`;
ALTER TABLE `sample_controls` MODIFY COLUMN `detail_tablename` varchar(255) NOT NULL AFTER `form_alias`;
ALTER TABLE `sd_der_amp_rnas` MODIFY COLUMN  `sample_master_id` int(11) DEFAULT NULL AFTER `id`;
ALTER TABLE `storage_controls` MODIFY COLUMN `form_alias` varchar(255) NOT NULL AFTER `flag_active`;
ALTER TABLE `storage_controls` MODIFY COLUMN `detail_tablename` varchar(255) NOT NULL AFTER `form_alias_for_children_pos`;
ALTER TABLE `storage_masters` MODIFY COLUMN `short_label` varchar(15) DEFAULT NULL AFTER `barcode`;
ALTER TABLE `storage_masters_revs` MODIFY COLUMN `short_label` varchar(15) DEFAULT NULL AFTER `barcode`;

-- Add Missing FK

ALTER TABLE `ed_all_lifestyle_smoking`
  ADD CONSTRAINT `ed_all_lifestyle_smoking_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

ALTER TABLE `ed_all_protocol_followup`
  ADD CONSTRAINT `ed_all_protocol_followup_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

ALTER TABLE `ed_all_study_research`
  ADD CONSTRAINT `ed_all_study_research_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

ALTER TABLE `ed_breast_lab_pathology`
  ADD CONSTRAINT `ed_breast_lab_pathology_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

ALTER TABLE `ed_breast_screening_mammogram`
  ADD CONSTRAINT `ed_breast_screening_mammogram_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_aliquot_uses` FOREIGN KEY (`aliquot_use_id`) REFERENCES `aliquot_uses` (`id`);
  
ALTER TABLE `cd_icm_generics`
  ADD CONSTRAINT `cd_icm_generics_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);
  
ALTER TABLE `dxd_sardos`
  ADD CONSTRAINT `dxd_sardos_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
  
ALTER TABLE `ed_all_procure_lifestyle`
  ADD CONSTRAINT `ed_all_procure_lifestyle_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
  
ALTER TABLE `sd_der_of_cells`
  ADD CONSTRAINT `FK_sd_der_of_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
ALTER TABLE `sd_der_of_sups`
  ADD CONSTRAINT `FK_sd_der_of_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
ALTER TABLE `sd_spe_other_fluids`
  ADD CONSTRAINT `FK_sd_spe_other_fluids_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

ALTER TABLE `participant_contacts` DROP FOREIGN KEY `participant_contacts_ibfk_1`;
  
ALTER TABLE `structure_fields` DROP KEY `unique_fields`;  

UPDATE structure_fields SET tablename = CONCAT('tmp_',id) WHERE  `field` LIKE 'tmp_storage_solution';

ALTER TABLE `structure_fields`
ADD UNIQUE KEY `unique_fields` (`field`,`model`,`tablename`);

-- Reset users

TRUNCATE acos;
TRUNCATE users;
TRUNCATE groups;
TRUNCATE aros_acos;
TRUNCATE aros;

INSERT INTO `aros` VALUES (1,NULL,'Group',1,'Group::1',1,8),(2,NULL,'Group',2,'Group::2',9,12),(3,NULL,'Group',3,'Group::3',13,16),(4,1,'User',1,'User::1',2,3),(5,1,'User',2,NULL,4,5),(6,2,'User',3,NULL,10,11),(7,3,'User',4,NULL,14,15),(8,NULL,'Group',4,'Group::4',17,30),(9,8,'User',5,NULL,18,19),(10,8,'User',6,NULL,20,21),(11,NULL,'Group',5,'Group::5',31,38),(12,11,'User',7,NULL,32,33),(13,11,'User',8,NULL,34,35),(14,NULL,'Group',6,'Group::6',39,44),(15,14,'User',9,NULL,40,41),(16,8,'User',10,NULL,22,23),(17,8,'User',11,NULL,24,25),(18,14,'User',12,NULL,42,43),(19,8,'User',13,NULL,26,27),(20,11,'User',14,NULL,36,37),(21,8,'User',15,NULL,28,29),(22,1,'User',16,NULL,6,7),(23,NULL,'Group',7,'Group::7',45,48),(24,23,'User',17,NULL,46,47),(25,NULL,'Group',8,'Group::8',49,54),(26,25,'User',18,NULL,50,51),(27,25,'User',19,NULL,52,53);
INSERT INTO `aros_acos` VALUES (1,1,1,'1','1','1','1'),(2,2,1,'1','1','1','1'),(3,3,1,'1','1','1','1'),(4,2,72,'-1','-1','-1','-1'),(5,2,166,'-1','-1','-1','-1'),(6,2,182,'-1','-1','-1','-1'),(7,2,207,'-1','-1','-1','-1'),(8,2,216,'-1','-1','-1','-1'),(9,2,278,'-1','-1','-1','-1'),(10,2,287,'-1','-1','-1','-1'),(11,2,321,'-1','-1','-1','-1'),(12,2,336,'-1','-1','-1','-1'),(13,2,345,'-1','-1','-1','-1'),(14,2,353,'-1','-1','-1','-1'),(15,2,366,'-1','-1','-1','-1'),(16,2,405,'-1','-1','-1','-1'),(17,3,2,'-1','-1','-1','-1'),(18,3,207,'-1','-1','-1','-1'),(19,3,278,'-1','-1','-1','-1'),(20,3,321,'-1','-1','-1','-1'),(21,3,336,'-1','-1','-1','-1'),(22,3,345,'-1','-1','-1','-1'),(23,3,353,'-1','-1','-1','-1'),(24,8,1,'1','1','1','1'),(25,8,2,'-1','-1','-1','-1'),(26,8,207,'-1','-1','-1','-1'),(27,8,278,'-1','-1','-1','-1'),(28,8,321,'-1','-1','-1','-1'),(29,8,336,'-1','-1','-1','-1'),(30,8,345,'-1','-1','-1','-1'),(31,8,353,'-1','-1','-1','-1'),(32,11,1,'1','1','1','1'),(33,11,2,'-1','-1','-1','-1'),(34,11,207,'-1','-1','-1','-1'),(35,11,278,'-1','-1','-1','-1'),(36,11,321,'-1','-1','-1','-1'),(37,11,336,'-1','-1','-1','-1'),(38,11,345,'-1','-1','-1','-1'),(39,11,353,'-1','-1','-1','-1'),(40,14,1,'-1','-1','-1','-1'),(41,23,1,'1','1','1','1'),(42,23,2,'-1','-1','-1','-1'),(43,23,207,'-1','-1','-1','-1'),(44,23,278,'-1','-1','-1','-1'),(45,23,321,'-1','-1','-1','-1'),(46,23,336,'-1','-1','-1','-1'),(47,23,345,'1','1','1','1'),(48,23,353,'-1','-1','-1','-1'),(49,25,1,'1','1','1','1'),(50,25,2,'-1','-1','-1','-1'),(51,25,207,'-1','-1','-1','-1'),(52,25,278,'-1','-1','-1','-1'),(53,25,321,'-1','-1','-1','-1'),(54,25,336,'-1','-1','-1','-1'),(55,25,345,'-1','-1','-1','-1'),(56,25,353,'-1','-1','-1','-1');
INSERT INTO `groups` VALUES 
(1,'Syst. Admin.',NULL,'2009-02-18 13:05:46','2009-02-18 13:05:46'),
(2,'Users Admin.',NULL,'2009-02-18 13:05:52','2009-04-06 12:58:21'),
(3,'Users Breast/Sein',2,'2009-02-18 13:05:59','2009-04-06 12:58:31'),
(4,'Users Ovarian/Ovaire',3,'2010-07-08 14:50:34','2010-07-08 14:50:34'),
(5,'Users Prostate',4,'2010-07-08 14:52:24','2010-07-08 14:52:24'),
(6,'Migration',NULL,'2010-07-08 14:54:09','2010-07-08 14:54:09'),
(7,'Users Head&Neck/Tête&cou',5,'2010-07-08 15:00:44','2010-07-08 15:00:44'),
(8,'Users Kidney/Rein',6,'2010-07-08 15:02:11','2010-07-08 15:02:11');
INSERT INTO `users` VALUES 
(1,'NicoFr','Nicolas','Luc','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',1,0,'2009-02-18 13:06:38','2010-07-08 14:42:09'),
(2,'NicoEn','Nicolas','Luc','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',1,0,'2010-07-08 14:47:02','2010-07-08 14:47:02'),
(3,'AdminManon','Manon','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',2,0,'2010-07-08 14:48:26','2010-07-08 14:48:26'),
(4,'UrszulaK','Urszula','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',3,0,'2010-07-08 14:49:57','2010-07-08 14:49:57'),
(5,'Manon','Manon','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',4,0,'2010-07-08 14:51:27','2010-07-08 14:51:27'),
(6,'LiseP','Lise','','925ed6ea3ce580968b42aa5373c06fe1ceb02acd','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',4,0,'2010-07-08 14:51:59','2010-07-08 15:17:13'),
(7,'AuroreP','Aurore','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',5,0,'2010-07-08 14:53:11','2010-07-08 14:53:11'),
(8,'ChantaleA','Chantale','','a4e3f973d60b334f92e990bcff2d0695c8df8120','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',5,0,'2010-07-08 14:53:33','2010-07-08 15:14:29'),
(9,'Migration','Migration','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',6,0,'2010-07-08 14:54:56','2010-07-08 14:54:56'),
(10,'JennK','Jennifer','','4067d37b7a9c896e83ea0c087758a6d958217e10','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',4,0,'2010-07-08 14:55:35','2010-07-08 15:18:21'),
(11,'Liliane','Liliane','','db2f9c6ad7e7487584bee200bb0c21a4657d01d3','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',4,0,'2010-07-08 14:55:54','2010-07-08 15:23:34'),
(12,'SardoMigration','SardoMigration','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',6,0,'2010-07-08 14:56:25','2010-07-08 14:56:25'),
(13,'GuilC-Ov','Guillaume','','1dda8b78791639efd7a799956fee1af606f50fbb','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',4,0,'2010-07-08 14:57:03','2010-07-08 15:26:24'),
(14,'TeodoraY','Teodora','','f7d34417d5d918004975b9b9a254d327a1d63585','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',5,0,'2010-07-08 14:57:43','2010-07-08 15:11:01'),
(15,'Karine','Karine','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',4,0,'2010-07-08 14:58:19','2010-07-08 14:58:19'),
(16,'MichEn','F.M.','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',1,0,'2010-07-08 14:59:16','2010-07-08 14:59:16'),
(17,'ApostolosC','Apostolos','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',7,0,'2010-07-08 15:01:52','2010-07-08 15:01:52'),
(18,'cfduchat','Carl Frédéric','','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',8,0,'2010-07-08 15:03:15','2010-07-08 15:03:15'),
(19,'Jean-Baptiste','Jean-Baptiste','Lattouf','ddeaa159a89375256a02d1cfbd9a1946ad01a979','','','','','',NULL,'','','','','','','','en','0000-00-00 00:00:00',8,0,'2010-07-08 15:03:54','2010-07-08 15:03:54');




