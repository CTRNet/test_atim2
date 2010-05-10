-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0031');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0031', 'bank_participants_collections_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

DELETE FROM `form_fields`
WHERE `id` IN ('CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0117',
'CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0119', 'CAN-024-001-000-999-0120',
'CAN-024-001-000-999-0121', 'CAN-024-001-000-999-0122'); 

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, 
`default`, `language_help`, 
`install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0116', 'OvaryBankIdentifiers', 'identifier_value', 'ovary bank no lab', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0117', 'ProstateBankIdentifiers', 'identifier_value', 'prostate bank no lab', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0118', 'BreastBankIdentifiers', 'identifier_value', 'breast bank no lab', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0119', 'HdIdentifiers', 'identifier_value', 'hotel-dieu id nbr', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0120', 'NdIdentifiers', 'identifier_value', 'notre-dame id nbr', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0121', 'SlIdentifiers', 'identifier_value', 'saint-luc id nbr', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0122', 'RamqIdentifiers', 'identifier_value', 'ramq nbr', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0031');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, 
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* 'Collection', 'bank_participant_identifier' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0040', 1, 1, '', 0, '', 0, '', 0, '', 0, '', 1, 'tool=multiple', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Participant', 'first_name' */
('CAN-024-001-000-999-0031_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0031', 'CAN-999-999-000-999-1', 1, 31, '', 1, 'first name', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_name' */
('CAN-024-001-000-999-0031_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0031', 'CAN-999-999-000-999-2', 1, 32, '', 1, 'last name', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Collection', 'aquisition_label' */
('CAN-024-001-000-999-0031_CAN-999-999-000-999-1218', 'CAN-024-001-000-999-0031', 'CAN-999-999-000-999-1218', 1, 20, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'bank' */
('CAN-024-001-000-999-0031_CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0031', 'CAN-999-999-000-999-1001', 1, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'collection_site' */
('CAN-024-001-000-999-0031_CAN-999-999-000-999-1003', 'CAN-024-001-000-999-0031', 'CAN-999-999-000-999-1003', 1, 22, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'collection_datetime' */
('CAN-024-001-000-999-0031_CAN-999-999-000-999-1004', 'CAN-024-001-000-999-0031', 'CAN-999-999-000-999-1004', 1, 23, '', 0, '', 0, '', 0, '', 1, 'date', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0116', 1, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0117', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0117', 1, 43, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0118', 1, 42, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'HdIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0119', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0119', 1, 45, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'NdIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0120', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0120', 1, 46, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'SlIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0121', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0121', 1, 47, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'RamqIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0031_CAN-024-001-000-999-0122', 'CAN-024-001-000-999-0031', 'CAN-024-001-000-999-0122', 1, 44, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1001;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1001', 
'<b>QR.Col-Collection.1001</b>: <u>Bank Participants Collections / Collections des participants d''une banque</u><br>
Collections of participants created during a specific period for a bank. (<I><FONT COLOR="#FF0000">Only collections linked to participant will be studied!</FONT></I>) / Collections de participants cr&eacute;es durant une periode sp&eacute;cifi&eacute;e et appartenant &agrave; une banque. (<I><FONT COLOR="#FF0000">Seules les collections attach&eacute;es &agrave; un participant aseront &eacute;tudi&eacute;es!</FONT></I>)<br>
<FONT COLOR="#347C17"><B><U>COLLECTION</U></B> - PARTICIPANT - IDENTIFIER / <B><U>COLLECTION</U></B> - PARTICIPANT - IDENTIFIANT</FONT>', 
'Collection', 
'bank_participants_collections_search', 'bank_participants_collections_search', 
'plugin inventorymanagement collection detail=>/inventorymanagement/collections/detail/%%Collection.id%%/|plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT Collection.id, Participant.id, Participant.first_name, Participant.last_name,  OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value, NdIdentifiers.identifier_value, HdIdentifiers.identifier_value, SlIdentifiers.identifier_value, RamqIdentifiers.identifier_value, Collection.acquisition_label, Collection.bank_participant_identifier, Collection.bank, Collection.collection_datetime, Collection.collection_site FROM collections AS Collection INNER JOIN clinical_collection_links AS Link ON Link.collection_id = Collection.id INNER JOIN participants AS Participant ON Participant.id = Link.participant_id 
LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" LEFT JOIN misc_identifiers AS NdIdentifiers ON Participant.id = NdIdentifiers.participant_id AND NdIdentifiers.name LIKE "notre-dame id nbr" LEFT JOIN misc_identifiers AS HdIdentifiers ON Participant.id = HdIdentifiers.participant_id AND HdIdentifiers.name LIKE "hotel-dieu id nbr" LEFT JOIN misc_identifiers AS SlIdentifiers ON Participant.id = SlIdentifiers.participant_id AND SlIdentifiers.name LIKE "saint-luc id nbr" LEFT JOIN misc_identifiers AS RamqIdentifiers ON Participant.id = RamqIdentifiers.participant_id AND RamqIdentifiers.name LIKE "ramq nbr" WHERE TRUE AND Collection.bank = "@@Collection.bank@@" AND Collection.collection_site = "@@Collection.collection_site@@" AND ((Collection.collection_datetime >= "@@Collection.collection_datetime_start@@" AND Collection.collection_datetime <= "@@Collection.collection_datetime_end@@") OR (Collection.reception_datetime >= "@@Collection.collection_datetime_start@@" AND Collection.reception_datetime <= "@@Collection.collection_datetime_end@@")) ORDER BY Collection.collection_datetime;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('qc collection bank title',
'plugin clinicalannotation participant profile');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('qc collection bank title', 'global', 'Collection Bank', 'Banque de la collection'),
('plugin clinicalannotation participant profile', 'global', 'Participant Details', 'Donn&eacute;es du participant');

	