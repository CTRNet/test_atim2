-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0030');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0030', 'participants_consents_data_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0030');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* 'MiscIdentifer', 'name' */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-34', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-34', 1, 0, '', 1, 'identification type', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'MiscIdentifer', 'identifier_value' */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-35', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-35', 1, 1, '', 1, 'identification value', 0, '', 0, '', 0, '', 1, 'tool=csv', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Participant', 'first_name' */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-1', 1, 11, '', 1, 'participant', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_name' */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-2', 1, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0116', 1, 111, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0118', 1, 112, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0117', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0117', 1, 113, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Consent form_version */  	
('CAN-024-001-000-999-0030_CAN-999-999-000-999-53', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-53', 1, 20, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent consent_type */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0022', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0022', 1, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Consent date (invitation) */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-52', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-52', 1, 31, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent consent_status */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-57', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-57', 1, 32, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent status_date */
('CAN-024-001-000-999-0030_CAN-046-003-000-999-1', 'CAN-024-001-000-999-0030', 'CAN-046-003-000-999-1', 1, 33, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Consent biological_material_use */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-60', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-60', 1, 41, '', 1, 'use of biological material', 1, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent use_of_urine */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-62', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-62', 1, 42, '', 1, 'use of urine', 1, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent use_of_blood */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-61', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-61', 1, 43, '', 1, 'use of blood', 1, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Consent urine_blood_use_for_followup */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0024', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0024', 1, 44, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent stop_followup */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0093', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0093', 1, 45, '', 1, 'stop followup', 1, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent stop_followup_date */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0094', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0094', 1, 46, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent contact_for_additional_data */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0025', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0025', 1, 47, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent allow_questionnaire */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0026', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0026', 1, 48, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent stop_questionnaire */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0095', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0095', 1, 49, '', 1, 'stop questionnaire', 1, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent stop_questionnaire_date */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0096', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0096', 1, 50, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent inform_significant_discovery */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-64', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-64', 1, 51, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent research_other_disease */
('CAN-024-001-000-999-0030_CAN-999-999-000-999-63', 'CAN-024-001-000-999-0030', 'CAN-999-999-000-999-63', 1, 52, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Consent inform_discovery_on_other_disease */
('CAN-024-001-000-999-0030_CAN-024-001-000-999-0027', 'CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0027', 1, 53, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
/* Kidney */
('CAN-024-001-000-999-0030_CANM1-00001', 'CAN-024-001-000-999-0030', 'CANM1-00001', 1, 114, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Old */
('CAN-024-001-000-999-0030_CANM1-00002', 'CAN-024-001-000-999-0030', 'CANM1-00002', 1, 115, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 301;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('301', '<b>QR.Cli-PartCons.0301</b>: <u>List Participants Consents Data / Liste les donn&eacute;es des consentements de participants</u><br>
List consents of a set of participants. (<I><FONT COLOR="#FF0000">Only participant having at least one identifier will be studied!</FONT></I>) / Liste les consentements d''un ensemble de participants. (<I><FONT COLOR="#FF0000">Seuls les participants ayant au moins un identifiant seront &eacute;tudi&eacute;s!</FONT></I>)<br>
<FONT COLOR="#347C17"><B><U>CONSENT</U></B> - <U>IDENTIFIER</U> - PARTICIPANT - NOLABO<I>par</I> / <B><U>CONSENTEMENT</U></B> - <U>IDENTIFIANT</U> - PARTICIPANT - NOLABO<I>par</I></FONT>',  
'Consent', 
'participants_consents_data_search', 'participants_consents_data_search', 
'plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT Consent.id, Participant.id, Participant.first_name, Participant.last_name, OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value, Consent.form_version, Consent.date, Consent.consent_status, Consent.status_date, Consent.reason_denied, Consent.biological_material_use, Consent.use_of_urine, Consent.use_of_blood, Consent.urine_blood_use_for_followup, Consent.stop_followup, Consent.stop_followup_date, Consent.contact_for_additional_data, Consent.allow_questionnaire, Consent.stop_questionnaire, Consent.stop_questionnaire_date, Consent.inform_significant_discovery, Consent.research_other_disease, Consent.inform_discovery_on_other_disease, KidneyIdentifiers.identifier_value, OldIdentifiers.identifier_value FROM consents AS Consent INNER JOIN participants AS Participant ON Consent.participant_id = Participant.id INNER JOIN misc_identifiers AS MiscIdentifier ON Participant.id = MiscIdentifier.participant_id LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" LEFT JOIN misc_identifiers AS KidneyIdentifiers ON Participant.id = KidneyIdentifiers.participant_id AND KidneyIdentifiers.name LIKE "kidney bank no lab" LEFT JOIN misc_identifiers AS OldIdentifiers ON Participant.id = OldIdentifiers.participant_id AND OldIdentifiers.name LIKE "old bank no lab" WHERE TRUE AND Consent.consent_type = "@@Consent.consent_type@@" AND Consent.consent_status = "@@Consent.consent_status@@" AND Consent.status_date >= "@@Consent.status_date_start@@" AND Consent.status_date <= "@@Consent.status_date_end@@" AND (MiscIdentifier.name = "@@MiscIdentifier.name@@" OR MiscIdentifier.name = "old bank no lab") AND MiscIdentifier.identifier_value IN (@@MiscIdentifier.identifier_value@@) ORDER BY Consent.status_date;',
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --



