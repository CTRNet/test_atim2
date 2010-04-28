-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0041');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0041', 'bank_participants_identifiers_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0041');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, 
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* 'MiscIdentifier', 'name': bank */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0108', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0108', 1, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'MiscIdentifer', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-999-999-000-999-35', 'CAN-024-001-000-999-0041', 'CAN-999-999-000-999-35', 1, 11, '', 1, 'nolabos shortlist', 0, '', 0, '', 0, '', 1, 'tool=csv', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Participant', 'tb_number' */
('CAN-024-001-000-999-0041_CAN-999-999-000-999-26', 'CAN-024-001-000-999-0041', 'CAN-999-999-000-999-26', 1, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'first_name' */
('CAN-024-001-000-999-0041_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0041', 'CAN-999-999-000-999-1', 1, 1, '', 1, 'participant', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_name' */
('CAN-024-001-000-999-0041_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0041', 'CAN-999-999-000-999-2', 1, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'sardo_participant_id' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0020', 1, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'sardo_numero_dossier' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0100', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0100', 1, 4, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0116', 1, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0117', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0117', 1, 43, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0118', 1, 42, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'HdIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0119', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0119', 1, 45, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'NdIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0120', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0120', 1, 46, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'SlIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0121', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0121', 1, 47, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'RamqIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0041_CAN-024-001-000-999-0122', 'CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0122', 1, 44, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Kidney */
('CAN-024-001-000-999-0041_CANM1-00001', 'CAN-024-001-000-999-0041', 'CANM1-00001', 1, 48, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Old */
('CAN-024-001-000-999-0041_CANM1-00002', 'CAN-024-001-000-999-0041', 'CANM1-00002', 1, 49, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 901;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('901', 
'<b>QR.Cli-PartIdent.0901</b>: <u> Bank Participant Identifiers / Identifiants des participants d''une banque</u><br>
List bank participant identifiers. (<I><FONT COLOR="#FF0000">Only participant having at least one identifier will be studied!</FONT></I>) / Liste les identifiants des participants d''une banque. (<I><FONT COLOR="#FF0000">Seuls les participants ayant au moins un identifiant seront &eacute;tudi&eacute;s!</FONT></I>)<br>
<FONT COLOR="#347C17"><B><U>IDENTIFIER</U></B> - PARTICIPANT / <B><U>IDENTIFIANT</U></B> - PARTICIPANT</FONT>', 
'Participant', 
'bank_participants_identifiers_search', 'bank_participants_identifiers_search', 
'plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT Participant.id, Participant.tb_number, Participant.first_name, Participant.last_name, Participant.sardo_participant_id, Participant.sardo_numero_dossier, OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value, HdIdentifiers.identifier_value, NdIdentifiers.identifier_value, SlIdentifiers.identifier_value, RamqIdentifiers.identifier_value, KidneyIdentifiers.identifier_value, OldIdentifiers.identifier_value FROM participants AS Participant INNER JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" LEFT JOIN misc_identifiers AS NdIdentifiers ON Participant.id = NdIdentifiers.participant_id AND NdIdentifiers.name LIKE "notre-dame id nbr" LEFT JOIN misc_identifiers AS HdIdentifiers ON Participant.id = HdIdentifiers.participant_id AND HdIdentifiers.name LIKE "hotel-dieu id nbr" LEFT JOIN misc_identifiers AS SlIdentifiers ON Participant.id = SlIdentifiers.participant_id AND SlIdentifiers.name LIKE "saint-luc id nbr" LEFT JOIN misc_identifiers AS RamqIdentifiers ON Participant.id = RamqIdentifiers.participant_id AND RamqIdentifiers.name LIKE "ramq nbr" LEFT JOIN misc_identifiers AS KidneyIdentifiers ON Participant.id = KidneyIdentifiers.participant_id AND KidneyIdentifiers.name LIKE "kidney bank no lab" LEFT JOIN misc_identifiers AS OldIdentifiers ON Participant.id = OldIdentifiers.participant_id AND OldIdentifiers.name LIKE "old bank no lab" WHERE TRUE AND (MiscIdentifier.name = "@@MiscIdentifier.name@@" OR MiscIdentifier.name = "old bank no lab") AND MiscIdentifier.identifier_value IN (@@MiscIdentifier.identifier_value@@) ORDER BY Participant.first_name, Participant.last_name, Participant.id;',
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN (
'nolabos shortlist'
);

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('nolabos shortlist', 'global', 'NoLabos Shortlist', 'Liste restreinte de NoLabos');

