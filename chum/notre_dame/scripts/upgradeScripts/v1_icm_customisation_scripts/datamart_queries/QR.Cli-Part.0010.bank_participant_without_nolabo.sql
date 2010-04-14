-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0042');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0042', 'bank_participants_without_nolabo_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
-- FORM FIELDS --


DELETE FROM `form_fields`
WHERE `id` IN ('CAN-024-001-000-999-0141');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, 
`language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0141', 'Participant', 'created', 'participant creation date', '', 'datetime', '', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0042');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, 
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* 'Participant', 'created' */
('CAN-024-001-000-999-0042_CAN-024-001-000-999-0141', 'CAN-024-001-000-999-0042', 'CAN-024-001-000-999-0141', 1, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Participant', 'tb_number' */
('CAN-024-001-000-999-0042_CAN-999-999-000-999-26', 'CAN-024-001-000-999-0042', 'CAN-999-999-000-999-26', 1, 1, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'first_name' */
('CAN-024-001-000-999-0042_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0042', 'CAN-999-999-000-999-1', 1, 2, '', 1, 'participant', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_name' */
('CAN-024-001-000-999-0042_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0042', 'CAN-999-999-000-999-2', 1, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 10;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('10', 
'<b>QR.Cli-Part.0010</b>: <u> Unidentified Participants / Participants non-idenifi&eacute;s</u><br>
List participant being not identified by a NoLabo. / Liste des participants non identifi&eacute;s par un NoLabo. <br>
<FONT COLOR="#347C17"><B><U>PARTICIPANT</U></B> / <B><U>PARTICIPANT</U></B></FONT>', 
'Participant', 
'bank_participants_without_nolabo_search', 'bank_participants_without_nolabo_search', 
'plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT Participant.id, Participant.tb_number, Participant.first_name, Participant.last_name FROM participants AS Participant WHERE TRUE AND Participant.created >= "@@Participant.created_start@@" AND Participant.created <= "@@Participant.created_end@@" AND Participant.id NOT IN (SELECT DISTINCT MiscIdentifier.participant_id FROM misc_identifiers AS MiscIdentifier WHERE MiscIdentifier.name LIKE "%bank no lab" ) ORDER BY Participant.first_name, Participant.last_name, Participant.id;',
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('participant creation date');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('participant creation date', 'global', 'Participant Creation Date ''NoLabos''', 'Date de cr&eacute;ation des participants');

