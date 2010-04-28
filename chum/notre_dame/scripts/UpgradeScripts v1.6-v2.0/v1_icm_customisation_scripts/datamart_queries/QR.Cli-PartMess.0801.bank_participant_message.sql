-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0024');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0024', 'bank_participants_messages_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

DELETE FROM `form_fields`
WHERE `id` IN ('CAN-024-001-000-999-0108');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, 
`install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0108', 'MiscIdentifier', 'name', 'type of participant identifier bank specific', '', 'select', '', '', 'type of participant identifier bank specific help', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `global_lookups`
WHERE `alias` IN ('qc_bank_identifier_for_bank_query');

INSERT INTO `global_lookups` 
(`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
(NULL, 'qc_bank_identifier_for_bank_query', NULL, NULL, 'breast bank no lab', 'breast', 1, 'yes', 
NULL, NULL, NULL, NULL),
(NULL, 'qc_bank_identifier_for_bank_query', NULL, NULL, 'ovary bank no lab', 'ovary', 2, 'yes', 
NULL, NULL, NULL, NULL),
(NULL, 'qc_bank_identifier_for_bank_query', NULL, NULL, 'prostate bank no lab', 'prostate', 3, 'yes', 
NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `field_id`  IN ('CAN-024-001-000-999-0108');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0108', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_identifier_for_bank_query' AND `value` like 'breast bank no lab')),
('CAN-024-001-000-999-0108', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_identifier_for_bank_query' AND `value` like 'ovary bank no lab')),
('CAN-024-001-000-999-0108', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_identifier_for_bank_query' AND `value` like 'prostate bank no lab'));

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0024');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, 
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* 'MiscIdentifier', 'name': bank */
('CAN-024-001-000-999-0024_CAN-024-001-000-999-0108', 'CAN-024-001-000-999-0024', 'CAN-024-001-000-999-0108', 1, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Participant', 'first_name' */
('CAN-024-001-000-999-0024_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-1', 1, 1, '', 1, 'participant', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_name' */
('CAN-024-001-000-999-0024_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-2', 1, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'ParticipantMessage', 'type' */  	
('CAN-024-001-000-999-0024_CAN-999-999-000-999-1257', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-1257', 1, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ParticipantMessage', 'due_date' */  	
('CAN-024-001-000-999-0024_CAN-999-999-000-999-115', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-115', 1, 13, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ParticipantMessage', 'title' */
('CAN-024-001-000-999-0024_CAN-999-999-000-999-1258', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-1258', 1, 14, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ParticipantMessage', 'description' */
('CAN-024-001-000-999-0024_CAN-999-999-000-999-112', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-112', 1, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ParticipantMessage', 'expiry_date' */
('CAN-024-001-000-999-0024_CAN-999-999-000-999-113', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-113', 1, 16, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ParticipantMessage', 'author' */
('CAN-024-001-000-999-0024_CAN-999-999-000-999-1256', 'CAN-024-001-000-999-0024', 'CAN-999-999-000-999-1256', 1, 17, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0024_CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0024', 'CAN-024-001-000-999-0116', 1, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0024_CAN-024-001-000-999-0117', 'CAN-024-001-000-999-0024', 'CAN-024-001-000-999-0117', 1, 43, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0024_CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0024', 'CAN-024-001-000-999-0118', 1, 42, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 801;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('801', 
'<b>QR.Cli-PartMess.0801</b>: <u>Scheduled Bank Participants Messages / Messages planif&eacute;s des participants d''une bank</u><br>
List scheduled messages of bank participants during a specific period. (<I><FONT COLOR="#FF0000">Only participant having at least one identifier will be studied!</FONT></I>) / Liste les messages planifi&eacute;s des participants d''une banque durant une periode d&eacute;finie. (<I><FONT COLOR="#FF0000">Seuls les participants ayant au moins un identifiant seront &eacute;tudi&eacute;s!</FONT></I>)<br>
<FONT COLOR="#347C17"><B><U>MESSAGE</U></B> - <U>IDENTIFIER</U> - PARTICIPANT - NOLABO<I>par</I> / <B><U>MESSAGE</U></B> - <U>IDENTIFIANT</U> - PARTICIPANT - NOLABO<I>par</I></FONT>', 
'ParticipantMessage', 
'bank_participants_messages_search', 'bank_participants_messages_search', 
'plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT ParticipantMessage.id, ParticipantMessage.type, ParticipantMessage.title, ParticipantMessage.description, ParticipantMessage.due_date, ParticipantMessage.expiry_date, ParticipantMessage.author, Participant.id, Participant.first_name, Participant.last_name, OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value FROM participants AS Participant INNER JOIN participant_messages AS ParticipantMessage ON ParticipantMessage.participant_id = Participant.id INNER JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" WHERE TRUE AND ParticipantMessage.type = "@@ParticipantMessage.type@@" AND ParticipantMessage.due_date >= "@@ParticipantMessage.due_date_start@@" AND ParticipantMessage.due_date <= "@@ParticipantMessage.due_date_end@@" AND MiscIdentifier.name = "@@MiscIdentifier.name@@" AND MiscIdentifier.name LIKE "%bank no lab" ORDER BY ParticipantMessage.due_date;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('type of participant identifier bank specific', 
'type of participant identifier bank specific help');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('type of participant identifier bank specific', 'global', 'Bank of NoLabos', 'Banque des NoLabos'),
('type of participant identifier bank specific help', 'global', 'Bank owner of the studied ''NoLabos''', 'Banque propri&eacute;taire des ''NoLabos'' &eacutetudi&eacute;s');
