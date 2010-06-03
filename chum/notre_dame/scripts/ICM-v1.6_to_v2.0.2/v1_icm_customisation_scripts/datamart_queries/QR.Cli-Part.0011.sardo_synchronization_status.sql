-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0043');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0043', 'sardo_synchronization_status_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0043');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, 
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* 'Participant', 'created' */
('CAN-024-001-000-999-0043_CAN-024-001-000-999-0141', 'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0141', 1, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Participant', 'tb_number' */
('CAN-024-001-000-999-0043_CAN-999-999-000-999-26', 'CAN-024-001-000-999-0043', 'CAN-999-999-000-999-26', 1, 1, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'first_name' */
('CAN-024-001-000-999-0043_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0043', 'CAN-999-999-000-999-1', 1, 2, '', 1, 'participant', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_name' */
('CAN-024-001-000-999-0043_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0043', 'CAN-999-999-000-999-2', 1, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Participant', 'sardo_participant_id' */
('CAN-024-001-000-999-0043_CAN-024-001-000-999-0020 ', 'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0020 ', 1, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'sardo_numero_dossier' */
('CAN-024-001-000-999-0043_CAN-024-001-000-999-0100', 'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0100', 1, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_sardo_import_date' */
('CAN-024-001-000-999-0043_CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0021', 1, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0043_CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0116', 1, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0043_CAN-024-001-000-999-0117', 'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0117', 1, 43, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0043_CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0118', 1, 42, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 11;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('11', 
'<b>QR.Cli-Part.0011</b>: <u> ATiM-SARDO Data Synchronization / Synchronization des donn&eacute;es ATiM-SARDO</u><br>
List participants and the status of the ATiM-SARDO data synchronization. / Liste les participants et les statuts des synchronizations entre ATiM et SARDO.<br>
<FONT COLOR="#347C17"><B><U>PARTICIPANT</U></B> / <B><U>PARTICIPANT</U></B></FONT>', 
'Participant', 
'sardo_synchronization_status_search', 'sardo_synchronization_status_search', 
'plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT Participant.id, Participant.tb_number, Participant.first_name, Participant.last_name, Participant.sardo_participant_id, Participant.sardo_numero_dossier, Participant.last_sardo_import_date,  OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value FROM participants AS Participant LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" WHERE TRUE AND Participant.created >= "@@Participant.created_start@@" AND Participant.created <= "@@Participant.created_end@@" ORDER BY Participant.first_name, Participant.last_name, Participant.id;',
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --


