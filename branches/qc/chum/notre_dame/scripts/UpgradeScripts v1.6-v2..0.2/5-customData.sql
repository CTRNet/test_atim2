
##########################################################################
# CLINICAL ANNOTATION
##########################################################################

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
'4', '1', 'sardo data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sardo_medical_record_number'), 
'4', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_sardo_import_date'), 
'4', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '0', '0', '0', '1');

INSERT INTO i18n (`id`, `page_id`, `en`, `fr`) 
VALUES
('participant code', '', 'Participant Code', 'Code du participant'),
('last visit date', '', 'Last Cisit Date', 'Date dernière visite'),
('sardo data', '', 'SARDO Data', 'Données SARDO'),
('sardo numero dossier', '', 'SARDO patient number', 'SARDO numéro dossier'),
('', '', '', ''),

 	global 	Code 	Code




# CONSENT ----------------------------------------------------------------

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('cd_icm_generics', '', '', '1', '1', '0', '1');

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
(null, 'qc_consent_type', 'open', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("FRSQ - Network", "FRSQ - Network");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("chum - kidney", "chum - kidney");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("CHUM - Prostate", "CHUM - Prostate");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("FRSQ", "FRSQ");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PROCURE", "PROCURE");

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="FRSQ - Network" AND language_alias="FRSQ - Network"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="chum - kidney" AND language_alias="chum - kidney"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="CHUM - Prostate" AND language_alias="CHUM - Prostate"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="FRSQ" AND language_alias="FRSQ"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="PROCURE" AND language_alias="PROCURE4"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="unknwon" AND language_alias="unknwon"), "6", "1");

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
(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_version_date', 'consent version', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_global_consent_version"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'invitation_date', 'invitation date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_type', 'consent type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_language', 'consent language', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_language"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),

(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'biological_material_use', 'biological material use', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'use_of_blood', 'use of blood', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'use_of_urine', 'use of urine', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'urine_blood_use_for_followup', 'urine blood use for followup', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_followup', 'stop followup', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_followup_date', 'stop followup date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'contact_for_additional_data', 'contact for additional data', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'allow_questionnaire', 'allow questionnaire', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_questionnaire', 'stop questionnaire', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'stop_questionnaire_date', 'stop questionnaire date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'research_other_disease', 'research other disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'inform_discovery_on_other_disease', 'inform discovery on other disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'ConsentDetail', 'cd_icm_generics', 'inform_significant_discovery', 'inform significant discovery', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="yesno"), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

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
'1', '2', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_language'), 
'1', '3', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
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
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied'), 
'1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='biological_material_use'), 
'2', '1', 'consent data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_blood'), 
'2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_urine'), 
'2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='urine_blood_use_for_followup'), 
'2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
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
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='contact_for_additional_data'), 
'2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='allow_questionnaire'), 
'2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
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
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='research_other_disease'), 
'2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_discovery_on_other_disease'), 
'2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_significant_discovery'), 
'2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='cd_icm_generics'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes'), 
'2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1');








 	






 	 	 	 	 	
 	 	
 	
 	
 	
 	










cd_icm_generics
##########################################################################
# INVENTORY
##########################################################################

# COLLECTION -------------------------------------------------------------
