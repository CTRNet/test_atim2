-- ------------------------------------------------------------------------------------------------
--
-- VERSION: BEFORE PROD
--
-- ------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- CTRApp - clinical annotation 
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- GENERAL: MENU
--
-- ---------------------------------------------------------------------

DELETE FROM `sidebars`
WHERE `alias` = 'clinicalannotation_participants_search';

-- ---------------------------------------------------------------------
--
-- PARTICIPANTS 
--
-- ---------------------------------------------------------------------

UPDATE `forms` 
SET `flag_add_columns` = '0',
`flag_edit_columns` = '0' 
WHERE `forms`.`id` = 'CAN-999-999-000-999-1';

DELETE FROM `forms`
WHERE `alias` LIKE 'sardo_participants';

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0021', 'sardo_participants', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

UPDATE `form_fields` 
SET `default` = 'NULL'
WHERE `form_fields`.`id` IN 
('CAN-999-999-000-999-5',	/* date_of_birth */
'CAN-999-999-000-999-22');	/* tb number */

DELETE FROM `form_fields`
WHERE `id` IN ('CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0021',
'CAN-024-001-000-999-0061', 'CAN-024-001-000-999-0067', 'CAN-024-001-000-999-0076',
'CAN-024-001-000-999-0077', 'CAN-024-001-000-999-0100');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-0020', 'Participant', 'sardo_participant_id', 'sardo participant id', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0100', 'Participant', 'sardo_numero_dossier', 'sardo numero dossier', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0021', 'Participant', 'last_sardo_import_date', 'last import date', '', 
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0061', 'Participant', 'approximative_date_of_birth', 'approximative date', '', 
'select', '', 'no', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0067', 'Participant', 'approximative_date_of_death', 'approximative death date', '', 
'select', '', 'no', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0076', 'Participant', 'last_visit_date', 'last visit date', '', 
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0077', 'Participant', 'approximative_last_visit_date', 'approximative last visit date', '', 
'select', '', 'no', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-999-999-000-999-1');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* tb number */
('CAN-999-999-000-999-1_CAN-999-999-000-999-26', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-26', 1, -1, 
'clin_demographics', 0, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* first name */
('CAN-999-999-000-999-1_CAN-999-999-000-999-1', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-1', 1, 1, 
'', 1, 'identity', 1, 'first name', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '2008-05-28 11:33:37', ''),
/* last name */
('CAN-999-999-000-999-1_CAN-999-999-000-999-2', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-2', 1, 3, 
'', 0, '', 1, 'last name', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* date_of_birth */
('CAN-999-999-000-999-1_CAN-999-999-000-999-5', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-5', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_date_of_birth */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0061', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0061', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* race */
('CAN-999-999-000-999-1_CAN-999-999-000-999-7', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-7', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sex */
('CAN-999-999-000-999-1_CAN-999-999-000-999-11', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-11', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_chart_checked_date (Participant) */
('CAN-999-999-000-999-1_CAN-999-999-000-999-528', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-528', 1, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* memo */
('CAN-999-999-000-999-1_CAN-999-999-000-999-10', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-10', 1, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* vital_status */
('CAN-999-999-000-999-1_CAN-999-999-000-999-21', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-21', 3, 1, 
'current status', 0, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* date_of_death */
('CAN-999-999-000-999-1_CAN-999-999-000-999-22', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-22', 3, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_date_of_death */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0067', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0067', 3, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_visit_date */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0076', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0076', 3, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_last_visit_date */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0077', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0077', 3, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* icd10*/
('CAN-999-999-000-999-1_CAN-999-999-000-999-24', 'CAN-999-999-000-999-1', 'CAN-999-999-000-999-24', 3, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* sardo_participant_id */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0020', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0020', 4, 31, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo_numero_dosseir */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0100', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0100', 4, 32, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_sardo_import_date */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0021', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0021', 4, 33, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0021');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* tb number */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-26', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-26', 1, -1, 
'clin_demographics', 0, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* first name */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-1', 1, 1, 
'', 1, 'identity', 1, 'first name', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '2008-05-28 11:33:37', ''),
/* last name */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-2', 1, 3, 
'', 0, '', 1, 'last name', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* date_of_birth */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-5', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-5', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_date_of_birth */
('CAN-024-001-000-999-0021_CAN-024-001-000-999-0061', 'CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0061', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* race */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-7', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-7', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sex */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-11', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-11', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_chart_checked_date (Participant) */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-528', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-528', 1, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* memo */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-10', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-10', 1, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* vital_status */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-21', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-21', 3, 1, 
'current status', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* date_of_death */
('CAN-024-001-000-999-0021_CAN-999-999-000-999-22', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-22', 3, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_date_of_death */
('CAN-024-001-000-999-0021_CAN-024-001-000-999-0067', 'CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0067', 3, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_visit_date */
('CAN-024-001-000-999-0021_CAN-024-001-000-999-0076', 'CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0076', 3, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_last_visit_date */
('CAN-024-001-000-999-0021_CAN-024-001-000-999-0077', 'CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0077', 3, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* icd10*/
('CAN-024-001-000-999-0021_CAN-999-999-000-999-24', 'CAN-024-001-000-999-0021', 'CAN-999-999-000-999-24', 3, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* sardo_participant_id */
('CAN-024-001-000-999-0021_CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0020', 4, 31, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo_numero_dosseir */
('CAN-024-001-000-999-0021_CAN-024-001-000-999-0100', 'CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0100', 4, 32, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_sardo_import_date */
('CAN-024-001-000-999-0021_CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0021', 'CAN-024-001-000-999-0021', 4, 33, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0061', 'CAN-024-001-000-999-0067',
'CAN-024-001-000-999-0077');

-- Action: INSERT
-- Comments: For consent

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0067', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0067', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0077', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0077', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

-- 
-- Table - `form_validations`
-- 

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0061', 'CAN-024-001-000-999-0067', 
'CAN-024-001-000-999-0077');

-- INSERT INTO `form_validations` 
-- ( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
-- VALUES 
-- (NULL , 'CAN-024-001-000-999-0061', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- (NULL , 'CAN-024-001-000-999-0067', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- (NULL , 'CAN-024-001-000-999-0077', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-999-999-000-999-11');	/* sex */

-- ---------------------------------------------------------------------
--
-- CONSENTS
--
-- ---------------------------------------------------------------------

UPDATE `forms` 
SET `flag_add_columns` = '0',
`flag_edit_columns` = '0' 
WHERE `forms`.`id` = 'CAN-999-999-000-999-12';

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0022', 'CAN-024-001-000-999-0023',
'CAN-024-001-000-999-0024', 'CAN-024-001-000-999-0025', 'CAN-024-001-000-999-0026', 
'CAN-024-001-000-999-0027', 'CAN-024-001-000-999-0028', 'CAN-024-001-000-999-0093',
'CAN-024-001-000-999-0094', 'CAN-024-001-000-999-0095', 'CAN-024-001-000-999-0096');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, 
`setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`)
 VALUES 
('CAN-024-001-000-999-0022', 'Consent', 'consent_type', 'consent_type', '', 'select', 
'', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0023', 'Consent', 'consent_version_date', 'consent_version_date', '', 'select', 
'', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0024', 'Consent', 'urine_blood_use_for_followup', 'allow blood and urine collection for follow-up', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0025', 'Consent', 'contact_for_additional_data', 'allow to be contacted for additional data', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0026', 'Consent', 'allow_questionnaire', 'accept to complete questionnaire', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0027', 'Consent', 'inform_discovery_on_other_disease', 'inform of discoveries on other diseases', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0028', 'Consent', 'consent_language', '', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0093', 'Consent', 'stop_followup', '', 'stop followup', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0094', 'Consent', 'stop_followup_date', '', 'stop followup date', 
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0095', 'Consent', 'stop_questionnaire', '', 'stop questionnaire', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0096', 'Consent', 'stop_questionnaire_date', '', 'stop questionnaire date', 
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `form_fields` 
SET `default` = 'no' 
WHERE `form_fields`.`id` = 'CAN-999-999-000-999-58';

-- 
-- Table - `form_formats`
-- 

UPDATE `form_formats` 
SET `display_order` = 17	
WHERE `id` IN 
('CAN-999-999-000-999-12_CAN-999-999-000-999-63');	/* research other disease */

UPDATE `form_formats` 
SET `display_order` = 16	
WHERE `id` IN 
('CAN-999-999-000-999-12_CAN-999-999-000-999-64');	/* inform significant discovery */

UPDATE `form_formats` 
SET `display_order` = 18,
`display_column` = '2'	
WHERE `id` IN 
('CAN-999-999-000-999-12_CAN-999-999-000-999-65');	/* memo */

UPDATE `form_formats` 
SET `language_heading` = 'consent status'
WHERE `id` IN
('CAN-999-999-000-999-12_CAN-999-999-000-999-52');	/* invitation date */

UPDATE `form_formats` 
SET `flag_index` = 1
WHERE `id` IN
('CAN-999-999-000-999-12_CAN-046-003-000-999-1');	/* consent status date */

UPDATE `form_formats` 
SET `language_heading` = 'consent data',
`flag_override_label` = 1, 
`language_label` = 'use of', 
`flag_override_tag` = 1, 
`language_tag` = 'biological material'
WHERE `id` IN
('CAN-999-999-000-999-12_CAN-999-999-000-999-60');	/* biological material */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit` = 0,
`display_order` = 0,
`language_heading` = 'form_version'
WHERE `id` IN
('CAN-999-999-000-999-12_CAN-999-999-000-999-53');	/* form version */

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-12_CAN-024-001-000-999-0028',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0022',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0023',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0024',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0025',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0026',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0027',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0093',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0094',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0095',
'CAN-999-999-000-999-12_CAN-024-001-000-999-0096'
);

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-999-999-000-999-12_CAN-024-001-000-999-0028', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0028', 1, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0022', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0022', 1, 0, 
'form_version', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0023', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0023', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0024', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0024', 2, 13, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0093', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0093', 2, 13, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0094', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0094', 2, 13, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0025', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0025', 2, 14, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0026', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0026', 2, 15, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0095', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0095', 2, 15, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0096', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0096', 2, 15, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CAN-024-001-000-999-0027', 'CAN-999-999-000-999-12', 'CAN-024-001-000-999-0027', 2, 18, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-12_CAN-046-003-000-999-5',	/* surgeon (Consent) */
'CAN-999-999-000-999-12_CAN-046-003-000-999-6',	/* operation_date (Consent) */
'CAN-999-999-000-999-12_CAN-046-003-000-002-29',	/* facility_other */
'CAN-999-999-000-999-12_CAN-046-003-000-999-7',	/* facility (Consent) */
'CAN-999-999-000-999-12_CAN-999-999-000-999-66',	/* recruit_route */	
'CAN-999-999-000-999-12_CAN-046-999-000-999-12 ',	/* use_of_tissue */	
'CAN-999-999-000-999-12_CAN-046-999-000-999-13',	/* contact_future_research */
'CAN-999-999-000-999-12_CAN-046-999-000-999-14');	/* access_medical_information */

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For consent

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_consent_form_type', 'qc_consent_language', 
'qc_consent_form_version_date');

-- Action: INSERT
-- Comments: For consent

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_consent_form_type', NULL , NULL , 'CHUM - Prostate', 'CHUM - Prostate', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_type', NULL , NULL , 'FRSQ', 'frsq', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_type', NULL , NULL , 'PROCURE', 'procure', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_type', NULL , NULL , 'unknwon', 'unknwon', '4', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-10-02',	'2008-10-02', '10', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-09-24',	'2008-09-24', '11', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-06-26',	'2008-06-26', '12', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-06-23',	'2008-06-23', '13', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-03-23',	'2008-03-23', '14', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-05-04',	'2008-05-04', '15', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-04-05',	'2008-04-05', '16', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2008-03-26',	'2008-03-26', '17', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-10-25',	'2007-10-25', '18', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-06-05',	'2007-06-05', '19', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-05-23',	'2007-05-23', '20', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-05-15',	'2007-05-15', '21', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-05-05',	'2007-05-05', '22', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-05-04',	'2007-05-04', '23', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-04-04',	'2007-04-04', '24', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2007-03-12',	'2007-03-12', '25', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-08-05',	'2006-08-05', '26', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-06-09',	'2006-06-09', '27', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-05-26',	'2006-05-26', '28', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-05-08',	'2006-05-08', '29', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-05-07',	'2006-05-07', '30', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-05-06',	'2006-05-06', '31', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-02-26',	'2006-02-26', '32', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-02-09',	'2006-02-09', '33', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-02-01',	'2006-02-01', '34', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2006-01-10',	'2006-01-10', '35', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-10-27',	'2005-10-27', '36', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-10-25',	'2005-10-25', '37', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-07-27',	'2005-07-27', '38', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-06-26',	'2005-06-26', '39', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-05-26',	'2005-05-26', '40', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-03-26',	'2005-03-26', '41', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-01-26',	'2005-01-26', '42', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2005-01-05',	'2005-01-05', '43', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2004-12-14',	'2004-12-14', '44', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2004-09-14',	'2004-09-14', '45', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2004-07-15',	'2004-07-15', '46', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2004-03-01',	'2004-03-01', '47', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2003-12-03',	'2003-12-03', '48', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2002-09-13',	'2002-09-13', '49', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2002-04-08',	'2002-04-08', '50', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2001-03-30',	'2001-03-30', '51', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2000-04-20',	'2000-04-20', '52', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'qc_consent_language', NULL , NULL , 'fr', 'language_fr', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_consent_language', NULL , NULL , 'en', 'language_en', '2', 'yes', NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For consent

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0022', 'CAN-024-001-000-999-0024',
'CAN-024-001-000-999-0025', 'CAN-024-001-000-999-0026', 'CAN-024-001-000-999-0027',
'CAN-024-001-000-999-0028', 'CAN-024-001-000-999-0023', 'CAN-024-001-000-999-0093',
'CAN-024-001-000-999-0095');

-- Action: INSERT
-- Comments: For consent

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0022', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_type' AND `value` like 'FRSQ')),
('CAN-024-001-000-999-0022', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_type' AND `value` like 'PROCURE')),
('CAN-024-001-000-999-0022', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_type' AND `value` like 'CHUM - Prostate')),
('CAN-024-001-000-999-0022', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_type' AND `value` like 'unknwon')),

('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-10-02')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-09-24')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-06-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-06-23')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-03-23')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-05-04')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-04-05')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2008-03-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-10-25')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-06-05')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-05-23')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-05-15')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-05-05')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-05-04')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-04-04')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2007-03-12')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-08-05')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-06-09')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-05-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-05-08')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-05-07')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-05-06')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-02-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-02-09')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-02-01')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2006-01-10')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-10-27')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-10-25')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-07-27')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-06-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-05-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-03-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-01-26')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2005-01-05')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2004-12-14')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2004-09-14')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2004-07-15')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2004-03-01')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2003-12-03')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2002-09-13')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2002-04-08')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2001-03-30')),
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2000-04-20')),

('CAN-024-001-000-999-0028', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_language' AND `value` like 'fr')),
('CAN-024-001-000-999-0028', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_language' AND `value` like 'en')),

('CAN-024-001-000-999-0024', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0024', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0025', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0025', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0026', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0026', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0093', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0093', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0095', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0095', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0027', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0027', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

-- 
-- Table - `form_validations`
-- 

-- Action: DELETE
-- Comments: For consent

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0022');

-- Action: INSERT
-- Comments: For consent

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-024-001-000-999-0022', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- DIAGNOSIS
--
-- ---------------------------------------------------------------------

UPDATE `forms` 
SET `flag_add_columns` = '0',
`flag_edit_columns` = '0' 
WHERE `forms`.`id` = 'CAN-999-999-000-999-6';

-- 
-- Table - `form_fields`
-- 

UPDATE `form_fields` 
SET `setting` = 'size=20'
WHERE `form_fields`.`id` IN 
('CAN-999-999-000-999-68');	/* dx_number */

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0030', 'CAN-024-001-000-999-0031',
'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0060', 'CAN-024-001-000-999-0062',
'CAN-024-001-000-999-0068', 'CAN-024-001-000-999-0069', 'CAN-024-001-000-999-0070',
'CAN-024-001-000-999-0101', 'CAN-024-001-000-999-0102');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, 
`setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES  
('CAN-024-001-000-999-0101', 'Diagnosis', 'grade',  'grade', '', 
'input', 'size=10', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0102', 'Diagnosis', 'stade_figo', 'stade figo', '', 
'input', 'size=10', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0030', 'Diagnosis', 'sardo_diagnosis_id', 'sardo diagnosis id', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0031', 'Diagnosis', 'last_sardo_import_date', 'last import date', '', 
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0032', 'Diagnosis', 'icd_o_grade', 'ICD-O grade', '', 
'input', 'size=10', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0060', 'Diagnosis', 'sequence_nbr', 'sequence number', '', 
'input', 'size=5', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0062', 'Diagnosis', 'approximative_dx_date', 'approximative date', '', 
'select', '', 'no', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0068', 'Diagnosis', 'survival', 'survival', '', 
'input', 'size=5', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0069', 'Diagnosis', 'survival_unit', '', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0070', 'Diagnosis', 'is_cause_of_death', 'diag is cause of death', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

UPDATE `form_formats` 
SET `display_column` = '1'
WHERE `form_id` IN ('CAN-999-999-000-999-6');

UPDATE `form_formats` 
SET `flag_edit` = '1', 
`flag_edit_readonly` = '1', 
`flag_search` = '1', 
`flag_search_readonly` = '1' ,
`flag_index` = '1', 
`flag_detail` = '1',
`display_order` = '-8' 
WHERE `id` IN ('CAN-999-999-000-999-6_CAN-999-999-000-999-68');	/* dx_number */

UPDATE `form_formats` 
SET `display_order` = '-3'
WHERE `id` IN ('CAN-999-999-000-999-6_CAN-999-999-000-999-71');	/* dx_date */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-002-11';/* laterality */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-71';/* dx_date */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-72';/* icd10_id */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-83';/* clinical_tstage */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-84';/* clinical_nstage */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-85';/* clinical_mstage */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-86';/* clinical_stage_grouping */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-87';/* path_tstage */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-88';/* path_nstage */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-89';/* path_mstage */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-024-001-000-999-0068';/* survival */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-024-001-000-999-0070';/* is_cause_of_death */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-324';/* morpho */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-90';/* path_stage_grouping */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1,
`display_order` = '-10' 
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-76';/* case number */

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-6_CAN-024-001-000-999-0030', 
'CAN-999-999-000-999-6_CAN-024-001-000-999-0031',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0032',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0060',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0062',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0068',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0069',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0070',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0101',
'CAN-999-999-000-999-6_CAN-024-001-000-999-0102');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* icd_o_grade */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0032', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0032', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'sardo_diagnosis_id' */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0030', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0030', 2, 50, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_sardo_import_date */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0031', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0031', 2, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence_nbr */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0060', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0060', 1, 26, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* grade */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0101', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0101', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* stade_figo */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0102', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0102', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_dx_date */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0062', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0062', 1, -2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* survival */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0068', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0068', 1, 27, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* survival_unit */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0069', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0069', 1, 28, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* is_cause_of_death */
('CAN-999-999-000-999-6_CAN-024-001-000-999-0070', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0070', 1, 29, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-6_CAN-999-999-000-999-73',		/* information_source (Diagnosis) */
'CAN-999-999-000-999-6_CAN-999-999-000-999-78',		/* collaborative_stage (Diagnosis) */
'CAN-999-999-000-999-6_CAN-999-999-000-999-77',		/* clinical stage */
'CAN-999-999-000-999-6_CAN-999-999-000-999-74',		/* age_at_dx */
'CAN-999-999-000-999-6_CAN-999-999-000-999-69',		/* dx_method */
'CAN-999-999-000-999-6_CAN-999-999-000-999-1221',		/* case_number */
'CAN-999-999-000-999-6_CAN-999-999-000-999-91',		/* dx_origin */	
'CAN-999-999-000-999-6_CAN-999-999-000-999-70 ',		/* dx_nature */	
'CAN-999-999-000-999-6_CAN-024-001-000-999-0060 ',		/* sequence_nbr */	
'CAN-999-999-000-999-6_CAN-999-999-000-999-79',		/* tstage (Diagnosis) */
'CAN-999-999-000-999-6_CAN-999-999-000-999-80',		/* nstage (Diagnosis) */
'CAN-999-999-000-999-6_CAN-999-999-000-999-81',		/* mstage (Diagnosis) */
'CAN-999-999-000-999-6_CAN-999-999-000-999-82');	/* stage_grouping (Diagnosis) */

UPDATE `global_lookups` 
SET `display_order` = '3' 
WHERE `global_lookups`.`alias` = 'dx_method'
AND `global_lookups`.`value` = 'imaging';

DELETE FROM `global_lookups`  
WHERE `alias` = 'dx_method'
AND `value` = 'laboratory analysis';

INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
(NULL, 'dx_method', NULL, NULL, 'laboratory analysis', 'laboratory analysis', 4, 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `global_lookups`  
WHERE `alias` = 'qc_time_unit';

INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
(NULL, 'qc_time_unit', NULL, NULL, 'month', 'month', 1, 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `lookup_id` = (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dx_method' AND `value` like 'laboratory analysis');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-69', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dx_method' AND `value` like 'laboratory analysis'));

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0062', 'CAN-024-001-000-999-0069',
'CAN-024-001-000-999-0070');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0069', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_time_unit' AND `value` like 'month')),

('CAN-024-001-000-999-0070', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0070', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-0062', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0062', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

DELETE FROM `global_lookups`  
WHERE `alias` = 'laterality' AND `value` = 'bilateral';
DELETE FROM `global_lookups`  
WHERE `alias` = 'laterality' AND `value` = 'unilateral';

INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
(NULL, 'laterality', NULL, NULL, 'bilateral', 'bilateral', 0, 'yes', NULL, NULL, NULL, NULL),
(NULL, 'laterality', NULL, NULL, 'unilateral', 'unilateral', 0, 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-002-11' 
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'laterality' AND `value` like 'bilateral');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-002-11', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'laterality' AND `value` like 'bilateral'));

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-002-11' 
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'laterality' AND `value` like 'unilateral');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-002-11', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'laterality' AND `value` like 'unilateral'));

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0062');

-- INSERT INTO `form_validations` 
-- ( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
-- VALUES 
-- (NULL , 'CAN-024-001-000-999-0062', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- FAMILY HISTORIES
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Add/update fields
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0033', 'CAN-024-001-000-999-0034',
'CAN-024-001-000-999-0063');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, 
`setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0033', 'FamilyHistory', 'sardo_diagnosis_id', 'sardo diagnosis id', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0034', 'FamilyHistory', 'last_sardo_import_date', 'last import date', '', 
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0063', 'FamilyHistory', 'approximative_dx_date', 'approximative date', '', 
'select', '', 'no', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-29';/* diagnosis date */

UPDATE `form_formats` 
SET `flag_add` = 0,
`flag_edit_readonly` = 1
WHERE `id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-31';/* icd 10 */

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-3_CAN-999-999-000-999-32',
'CAN-999-999-000-999-3_CAN-999-999-000-999-33');

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-3_CAN-024-001-000-999-0033', 
'CAN-999-999-000-999-3_CAN-024-001-000-999-0034',
'CAN-999-999-000-999-3_CAN-024-001-000-999-0063');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sardo_diagnosis_id */
('CAN-999-999-000-999-3_CAN-024-001-000-999-0033', 'CAN-999-999-000-999-3', 'CAN-024-001-000-999-0033', 2, 20, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last_sardo_import_date */
('CAN-999-999-000-999-3_CAN-024-001-000-999-0034', 'CAN-999-999-000-999-3', 'CAN-024-001-000-999-0034', 2, 21, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative_dx_date */
('CAN-999-999-000-999-3_CAN-024-001-000-999-0063', 'CAN-999-999-000-999-3', 'CAN-024-001-000-999-0063', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-3_CAN-999-999-000-999-30');

-- 
-- Table - `form_validations`
-- 

DELETE FROM `form_validations` 
WHERE `form_field_id` = 'CAN-999-999-000-999-32';
 
DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-024-001-000-999-0063';

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0063', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0063', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0063');

-- INSERT INTO `form_validations` 
-- ( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
-- VALUES 
-- (NULL , 'CAN-024-001-000-999-0063', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- REPROD HISTORY
--
-- ---------------------------------------------------------------------

-- 
-- Table - `menus`
-- 

-- UPDATE `menus`
-- SET `use_link` = '/unknown/'
-- WHERE `menus`.`parent_id` = 'clin_CAN_68'
-- OR `menus`.`language_title` IN ('reproductive history');

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-999-999-000-999-26');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-999-999-000-999-26_CAN-999-999-000-999-134', 'CAN-999-999-000-999-26', 'CAN-999-999-000-999-134', 1, 5, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-26_CAN-999-999-000-999-133', 'CAN-999-999-000-999-26', 'CAN-999-999-000-999-133', 1, 4, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-26_CAN-999-003-000-999-360', 'CAN-999-999-000-999-26', 'CAN-999-003-000-999-360', 1, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-26_CAN-999-999-000-999-150', 'CAN-999-999-000-999-26', 'CAN-999-999-000-999-150', 1, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-26_CAN-999-003-000-999-361', 'CAN-999-999-000-999-26', 'CAN-999-003-000-999-361', 1, 6, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- CONTACT
--
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0035');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, 
`setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0035', 'ParticipantContact', 'type_precision', 'type precision', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

UPDATE `form_formats` 
SET `display_order` = 0
WHERE `id` IN 
('CAN-999-999-000-999-10_CAN-999-999-000-999-39');	/* contact type */

UPDATE `form_formats` 
SET `default` = 'NULL'
WHERE `id` IN 
('CAN-999-999-000-999-10_CAN-999-999-000-999-530');	/* expir date */

UPDATE `form_formats` 
SET `flag_index` = '1' 
WHERE `id` = 'CAN-999-999-000-999-10_CAN-999-999-000-999-529';	/* effectiv date */

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-10_CAN-024-001-000-999-0035');

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For contact

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_contact_type');

-- Action: INSERT
-- Comments: For contact

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_contact_type', NULL , NULL , 'participant', 'participant', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_contact_type', NULL , NULL , 'other contact', 'other contact', '2', 'yes', NULL , NULL , NULL , NULL);

-- ---------------------------------------------------------------------
--
-- MESSAGE
--
-- ---------------------------------------------------------------------

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0081', 'CAN-024-001-000-999-0082');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0081', 'ParticipantMessage', 'sardo_note_id', 'sardo note id', '',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0082', 'ParticipantMessage', 'last_sardo_import_date', 'last import date', '',  
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `id` IN ('CAN-999-999-000-999-9_CAN-024-001-000-999-0081', 
'CAN-999-999-000-999-9_CAN-024-001-000-999-0082');

/* Due Expiry date */
UPDATE `form_formats`
SET `display_column` = 1
WHERE `id` IN ('CAN-999-999-000-999-9_CAN-999-999-000-999-113',
'CAN-999-999-000-999-9_CAN-999-999-000-999-115');

/* description */
UPDATE `form_formats`
SET `flag_index` = 1
WHERE `id` IN ('CAN-999-999-000-999-9_CAN-999-999-000-999-112');

-- ---------------------------------------------------------------------
--
-- IDENTIFICATION
--
-- ---------------------------------------------------------------------

-- 
-- Table - `forms`
-- 

DELETE FROM `forms`  
WHERE `alias` IN ('misc_identifiers_search_results')
OR `id` IN ('CAN-024-001-000-999-0007');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0007', 'misc_identifiers_search_results', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

UPDATE `form_fields` 
SET `type` = 'select',
`setting` = '',
`language_label` = 'type'
WHERE `id` IN 
('CAN-999-999-000-999-34');	/* identification name-type */

-- 
-- Table - `form_formats`
-- 

UPDATE `form_formats`
SET `display_order` = 21,
`flag_add_readonly` = 1,
`flag_edit_readonly` = 1,
`flag_search` = 1,
`flag_datagrid_readonly` = 1
WHERE `id` IN 
('CAN-999-999-000-999-8_CAN-999-999-000-999-34');	/* identification name-type */

UPDATE `form_formats`
SET `display_order` = 22,
`flag_edit_readonly` = 1,
`flag_search` = 1
WHERE `id` IN 
('CAN-999-999-000-999-8_CAN-999-999-000-999-35');	/* identification value */

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-0007_CAN-999-999-000-999-1',
'CAN-024-001-000-999-0007_CAN-999-999-000-999-2',
'CAN-024-001-000-999-0007_CAN-999-999-000-999-34',
'CAN-024-001-000-999-0007_CAN-999-999-000-999-35',
'CAN-024-001-000-999-0007_CAN-999-999-000-999-4');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0007_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0007', 'CAN-999-999-000-999-1', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0007_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0007', 'CAN-999-999-000-999-2', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0007_CAN-999-999-000-999-34', 'CAN-024-001-000-999-0007', 'CAN-999-999-000-999-34', 1, 21, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0007_CAN-999-999-000-999-35', 'CAN-024-001-000-999-0007', 'CAN-999-999-000-999-35', 1, 22, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0007_CAN-999-999-000-999-4', 'CAN-024-001-000-999-0007', 'CAN-999-999-000-999-4', 1, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For identification

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_misc_identifier_type');

-- Action: INSERT
-- Comments: For identification

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'ramq nbr', 'ramq nbr', '0', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'breast bank no lab', 'breast bank no lab', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'ovary bank no lab', 'ovary bank no lab', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'prostate bank no lab', 'prostate bank no lab', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'old bank no lab', 'old bank no lab', '4', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'hotel-dieu id nbr', 'hotel-dieu id nbr', '5', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'notre-dame id nbr', 'notre-dame id nbr', '6', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'saint-luc id nbr', 'saint-luc id nbr', '7', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'other center id nbr', 'other center id nbr', '8', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'code-barre', 'code-barre', '9', 'yes', NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For identification

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-999-999-000-999-34');

-- Action: INSERT
-- Comments: For identification

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'ramq nbr')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'breast bank no lab')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'ovary bank no lab')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'prostate bank no lab')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'old bank no lab')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'hotel-dieu id nbr')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'notre-dame id nbr')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'saint-luc id nbr')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'other center id nbr')),
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'code-barre'));

-- 
-- Table - `form_validations`
-- 

-- Action: DELETE
-- Comments: For identification

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-999-999-000-999-34');

-- Action: INSERT
-- Comments: For identification

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-999-999-000-999-34', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `part_bank_nbr_counters`
-- 

-- Action: DELETE
-- Comments: For identification

DELETE FROM `part_bank_nbr_counters`;

-- Action: INSERT
-- Comments: For identification

INSERT INTO `part_bank_nbr_counters` 
( `id` , `bank_ident_title` , `last_nbr` )
VALUES 
(NULL, 'ovary bank no lab', '4128'),
(NULL, 'breast bank no lab', '100451'),
(NULL, 'prostate bank no lab', '500855');

-- ---------------------------------------------------------------------
--
-- TREATMENT
--
-- ---------------------------------------------------------------------

-- 
-- Table - `tx_controls`
-- 

-- Action: DELETE
-- Comments: For treatment

DELETE FROM `tx_controls`;

-- Action: INSERT
-- Comments: For treatment

INSERT INTO `tx_controls` 
(`id`, `tx_group`, `disease_site`, `status`, 
`detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`) 
VALUES 
(1, 'chemotherapy', 'all', 'active', 'txd_chemos', 'txd_chemos', 'txe_chemos', 'txe_chemos'),
(2, 'radiation', 'all', 'active', 'txd_radiations', 'txd_radiations', '', ''),
(3, 'surgery', 'all', 'active', 'txd_surgeries', 'txd_surgeries', '', ''),
(4, 'drug', 'all', 'active', 'txd_drugs', 'txd_drugs', '', '');

-- 
-- Table - `forms`
-- 

DELETE FROM `forms`  
WHERE `id` IN ('CAN-024-001-000-999-0010');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0010', 'txd_drugs', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0041', 'CAN-024-001-000-999-0042', 
'CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0051', 'CAN-024-001-000-999-0052',
'CAN-024-001-000-999-0057', 'CAN-024-001-000-999-0064', 'CAN-024-001-000-999-0103',
'CAN-024-001-000-999-0104');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0051', 'TreatmentMaster', 'sardo_treatment_id', 'sardo treatment id', '',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0052', 'TreatmentMaster', 'last_sardo_import_date', 'last import date', '',  
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0064', 'TreatmentMaster', 'approximative_tx_date', 'approximative date', '', 
'select', '', 'no', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0103', 'TreatmentMaster', 'result', 'result', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0104', 'TreatmentMaster', 'therapeutic_goal', 'therapeutic goal', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

('CAN-024-001-000-999-0041', 'TreatmentDetail', 'radiation_type', 'type', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0042', 'TreatmentDetail', 'surgery_type', 'type', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0057', 'TreatmentDetail', 'ed_lab_path_report_id', 'path report', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0043', 'TreatmentDetail', 'drug_id', 'drug', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_trt_result');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_trt_result', NULL , NULL , 'positif', 'positif', '6', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_trt_result', NULL , NULL , 'negatif', 'negatif', '6', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_trt_result', NULL , NULL , 'suspect', 'suspect', '6', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_trt_result', NULL , NULL , 'uncertain', 'uncertain', '9', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0103');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0103', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'positif')),
('CAN-024-001-000-999-0103', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'negatif')),
('CAN-024-001-000-999-0103', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'suspect')),
('CAN-024-001-000-999-0103', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'uncertain'));

--
-- 
-- Table - `form_format`
-- 

-- Master

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-33_CAN-999-999-000-999-277',	/* intent */
'CAN-999-999-000-999-33_CAN-999-999-000-999-279',	/* finish date */
'CAN-999-999-000-999-33_CAN-999-999-000-999-284');	/* protocol */

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-33_CAN-024-001-000-999-0051');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sardo treatment id */
('CAN-999-999-000-999-33_CAN-024-001-000-999-0051', 'CAN-999-999-000-999-33', 'CAN-024-001-000-999-0051', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- chemos details

UPDATE `forms` 
SET `flag_add_columns` = '0',
`flag_edit_columns` = '0' 
WHERE `forms`.`id` = 'CAN-999-999-000-999-34';

UPDATE `form_formats` 
SET `flag_edit` = '1' 
WHERE `form_formats`.`id` = 'CAN-999-999-000-999-34_CAN-999-999-000-999-284';

UPDATE `form_formats` 
SET `flag_add` = '0',
`flag_edit_readonly` = '1' 
WHERE `form_formats`.`id` IN (
/* protocol_id  */
'CAN-999-999-000-999-34_CAN-999-999-000-999-284', 
/* start_date  */
'CAN-999-999-000-999-34_CAN-999-999-000-999-278',
/* finish_date */ 
'CAN-999-999-000-999-34_CAN-999-999-000-999-279'); 

UPDATE `form_formats` 
SET `flag_add` = '0',
`flag_edit` = '0' 
WHERE `form_formats`.`id` IN (
/* diag */
'CAN-999-999-000-999-34_CAN-999-999-000-999-523'); 

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-34_CAN-999-999-000-999-287', /* num_cycles  */
'CAN-999-999-000-999-34_CAN-999-999-000-999-288', /* length_cycles */
'CAN-999-999-000-999-34_CAN-999-999-000-999-289', /* completed_cycles  */
-- 'CAN-999-999-000-999-34_CAN-999-999-000-999-1224', /* disease_site */
-- 'CAN-999-999-000-999-34_CAN-999-999-000-999-276', /* group */
'CAN-999-999-000-999-34_CAN-999-999-000-999-280', /* facility */
'CAN-999-999-000-999-34_CAN-999-999-000-999-283', /* source  */
'CAN-999-999-000-999-34_CAN-999-999-000-999-277', /* tx_intent */
-- 'CAN-999-999-000-999-34_CAN-999-999-000-999-278', /* start_date  */
-- 'CAN-999-999-000-999-34_CAN-999-999-000-999-279', /* finish_date */
'CAN-999-999-000-999-34_CAN-999-999-000-999-281', /* summary */
-- 'CAN-999-999-000-999-34_CAN-999-999-000-999-284', /* protocol_id  */
'CAN-999-999-000-999-34_CAN-999-999-000-999-285', /* completed  */
'CAN-999-999-000-999-34_CAN-999-999-000-999-286'); /* response  */
-- 'CAN-999-999-000-999-34_CAN-999-999-000-999-523'); /* diagnosis_id  */

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-34_CAN-024-001-000-999-0051',
'CAN-999-999-000-999-34_CAN-024-001-000-999-0052',
'CAN-999-999-000-999-34_CAN-024-001-000-999-0064',
'CAN-999-999-000-999-34_CAN-024-001-000-999-0103',
'CAN-999-999-000-999-34_CAN-024-001-000-999-0104');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sardo treatment id */
('CAN-999-999-000-999-34_CAN-024-001-000-999-0051', 'CAN-999-999-000-999-34', 'CAN-024-001-000-999-0051', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-999-999-000-999-34_CAN-024-001-000-999-0052', 'CAN-999-999-000-999-34', 'CAN-024-001-000-999-0052', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* result */
('CAN-999-999-000-999-34_CAN-024-001-000-999-0103', 'CAN-999-999-000-999-34', 'CAN-024-001-000-999-0103', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-999-999-000-999-34_CAN-024-001-000-999-0104', 'CAN-999-999-000-999-34', 'CAN-024-001-000-999-0104', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-999-999-000-999-34_CAN-024-001-000-999-0064', 'CAN-999-999-000-999-34', 'CAN-024-001-000-999-0064', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- chemos extend

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`parent_id` = 'clin_CAN_80'
OR `menus`.`language_title` IN ('treatment extend');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-38_CAN-999-999-000-999-298',	/* dose */
'CAN-999-999-000-999-38_CAN-999-999-000-999-299',	/* frequency */
'CAN-999-999-000-999-38_CAN-999-999-000-999-312',	/* source */
'CAN-999-999-000-999-38_CAN-999-999-000-999-313',	/* method */
'CAN-999-999-000-999-38_CAN-999-999-000-999-314',	/* reduction */
'CAN-999-999-000-999-38_CAN-999-999-000-999-315',	/* number of cycles */
'CAN-999-999-000-999-38_CAN-999-999-000-999-316');	/* completed cycles */

-- radiation details

UPDATE `forms` 
SET `flag_add_columns` = '0',
`flag_edit_columns` = '0' 
WHERE `forms`.`id` = 'CAN-999-999-000-999-35';

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-35_CAN-999-999-000-999-284',	/* protocol id */
'CAN-999-999-000-999-35_CAN-999-999-000-999-280',	/* treatment facility */
'CAN-999-999-000-999-35_CAN-999-999-000-999-283',	/* information source */
'CAN-999-999-000-999-35_CAN-999-999-000-999-290',	/* radiation source */
'CAN-999-999-000-999-35_CAN-999-999-000-999-291',	/* mould */
'CAN-999-999-000-999-35_CAN-999-999-000-999-281',	/* summary */
'CAN-999-999-000-999-35_CAN-999-999-000-999-277');	/* intent */

UPDATE `form_formats` 
SET `flag_add` = '0',
`flag_edit_readonly` = '1' 
WHERE `form_formats`.`id` IN (
/* start_date  */
'CAN-999-999-000-999-35_CAN-999-999-000-999-278',
/* finish_date */ 
'CAN-999-999-000-999-35_CAN-999-999-000-999-279'); 

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-35_CAN-024-001-000-999-0041',
'CAN-999-999-000-999-35_CAN-999-999-000-999-523',
'CAN-999-999-000-999-35_CAN-024-001-000-999-0051',
'CAN-999-999-000-999-35_CAN-024-001-000-999-0052',
'CAN-999-999-000-999-35_CAN-024-001-000-999-0064',
'CAN-999-999-000-999-35_CAN-024-001-000-999-0103',
'CAN-999-999-000-999-35_CAN-024-001-000-999-0104');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* result */
('CAN-999-999-000-999-35_CAN-024-001-000-999-0103', 'CAN-999-999-000-999-35', 'CAN-024-001-000-999-0103', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-999-999-000-999-35_CAN-024-001-000-999-0104', 'CAN-999-999-000-999-35', 'CAN-024-001-000-999-0104', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* radiation type */
('CAN-999-999-000-999-35_CAN-024-001-000-999-0041', 'CAN-999-999-000-999-35', 'CAN-024-001-000-999-0041', 1, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* diagnosis */
('CAN-999-999-000-999-35_CAN-999-999-000-999-523', 'CAN-999-999-000-999-35', 'CAN-999-999-000-999-523', 1, -10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo treatment id */
('CAN-999-999-000-999-35_CAN-024-001-000-999-0051', 'CAN-999-999-000-999-35', 'CAN-024-001-000-999-0051', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-999-999-000-999-35_CAN-024-001-000-999-0052', 'CAN-999-999-000-999-35', 'CAN-024-001-000-999-0052', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-999-999-000-999-35_CAN-024-001-000-999-0064', 'CAN-999-999-000-999-35', 'CAN-024-001-000-999-0064', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- surgery details

UPDATE `forms` 
SET `flag_add_columns` = '0',
`flag_edit_columns` = '0' 
WHERE `forms`.`id` = 'CAN-999-999-000-999-36';

UPDATE `form_formats` 
SET `flag_add` = '0',
`flag_edit_readonly` = '1' 
WHERE `form_formats`.`id` IN (
/* start_date  */
'CAN-999-999-000-999-36_CAN-999-999-000-999-278',
/* finish_date */ 
'CAN-999-999-000-999-36_CAN-999-999-000-999-279');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-36_CAN-999-999-000-999-284',	/* protocol id */
'CAN-999-999-000-999-36_CAN-999-999-000-999-292',	/* path numb */
'CAN-999-999-000-999-36_CAN-999-999-000-999-280',	/* treatment facility */
'CAN-999-999-000-999-36_CAN-999-999-000-999-283',	/* information source */
'CAN-999-999-000-999-36_CAN-999-999-000-999-293',	/* primary */
'CAN-999-999-000-999-36_CAN-999-999-000-999-281',	/* summary */
'CAN-999-999-000-999-36_CAN-999-999-000-999-277',	/* intent */
'CAN-999-999-000-999-36_CAN-999-999-000-999-294');	/* surgeon */

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-36_CAN-024-001-000-999-0042',
'CAN-999-999-000-999-36_CAN-999-999-000-999-523',
'CAN-999-999-000-999-36_CAN-024-001-000-999-0051',
'CAN-999-999-000-999-36_CAN-024-001-000-999-0052',
'CAN-999-999-000-999-36_CAN-024-001-000-999-0057',
'CAN-999-999-000-999-36_CAN-024-001-000-999-0064',
'CAN-999-999-000-999-36_CAN-024-001-000-999-0103',
'CAN-999-999-000-999-36_CAN-024-001-000-999-0104');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* result */
('CAN-999-999-000-999-36_CAN-024-001-000-999-0103', 'CAN-999-999-000-999-36', 'CAN-024-001-000-999-0103', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-999-999-000-999-36_CAN-024-001-000-999-0104', 'CAN-999-999-000-999-36', 'CAN-024-001-000-999-0104', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* surgery type */
('CAN-999-999-000-999-36_CAN-024-001-000-999-0042', 'CAN-999-999-000-999-36', 'CAN-024-001-000-999-0042', 1, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* path report number */
('CAN-999-999-000-999-36_CAN-024-001-000-999-0057', 'CAN-999-999-000-999-36', 'CAN-024-001-000-999-0057', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* diagnosis */
('CAN-999-999-000-999-36_CAN-999-999-000-999-523', 'CAN-999-999-000-999-36', 'CAN-999-999-000-999-523', 1, -10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo treatment id */
('CAN-999-999-000-999-36_CAN-024-001-000-999-0051', 'CAN-999-999-000-999-36', 'CAN-024-001-000-999-0051', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-999-999-000-999-36_CAN-024-001-000-999-0052', 'CAN-999-999-000-999-36', 'CAN-024-001-000-999-0052', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-999-999-000-999-36_CAN-024-001-000-999-0064', 'CAN-999-999-000-999-36', 'CAN-024-001-000-999-0064', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- drug details

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0010');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* result */
('CAN-024-001-000-999-0010_CAN-024-001-000-999-0103', 'CAN-024-001-000-999-0010', 'CAN-024-001-000-999-0103', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-024-001-000-999-0010_CAN-024-001-000-999-0104', 'CAN-024-001-000-999-0010', 'CAN-024-001-000-999-0104', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* group */
('CAN-024-001-000-999-0010_CAN-999-999-000-999-276', 'CAN-024-001-000-999-0010', 'CAN-999-999-000-999-276', 1, 0, 
'clin_treatment', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* start date */
('CAN-024-001-000-999-0010_CAN-999-999-000-999-278', 'CAN-024-001-000-999-0010', 'CAN-999-999-000-999-278', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* finsih date */
('CAN-024-001-000-999-0010_CAN-999-999-000-999-279', 'CAN-024-001-000-999-0010', 'CAN-999-999-000-999-279', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* summary */
('CAN-024-001-000-999-0010_CAN-999-999-000-999-281', 'CAN-024-001-000-999-0010', 'CAN-999-999-000-999-281', 1, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* drug */
('CAN-024-001-000-999-0010_CAN-024-001-000-999-0043', 'CAN-024-001-000-999-0010', 'CAN-024-001-000-999-0043', 1, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* diagnosis */
('CAN-024-001-000-999-0010_CAN-999-999-000-999-523', 'CAN-024-001-000-999-0010', 'CAN-999-999-000-999-523', 1, -10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Disease site */
('CAN-024-001-000-999-0010_CAN-999-999-000-999-1224', 'CAN-024-001-000-999-0010', 'CAN-999-999-000-999-1224', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo treatment id */
('CAN-024-001-000-999-0010_CAN-024-001-000-999-0051', 'CAN-024-001-000-999-0010', 'CAN-024-001-000-999-0051', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0010_CAN-024-001-000-999-0052', 'CAN-024-001-000-999-0010', 'CAN-024-001-000-999-0052', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0010_CAN-024-001-000-999-0064', 'CAN-024-001-000-999-0010', 'CAN-024-001-000-999-0064', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`
WHERE `alias` = 'group'
AND `value`= 'drug';

INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
(NULL, 'group', NULL, NULL, 'drug', 'drug', NULL, 'yes', NULL, NULL, NULL, NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- DELETE FROM `form_fields_global_lookups` 
-- WHERE `field_id` LIKE ('CAN-024-001-000-999-0042');	/* surgery type */

-- DELETE FROM `form_fields_global_lookups` 
-- WHERE `field_id` LIKE ('CAN-024-001-000-999-0041');	/* radiation type */

DELETE FROM `form_fields_global_lookups`
WHERE `field_id` = 'CAN-999-999-000-999-276'
AND `lookup_id` = (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'group' AND `value` like 'drug');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-276', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'group' AND `value` like 'drug'));

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0064');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0064', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0064', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0064');

-- INSERT INTO `form_validations` 
-- ( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
-- VALUES 
-- (NULL , 'CAN-024-001-000-999-0064', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- ANNOTATION
--
-- ---------------------------------------------------------------------

-- 
-- Table - `menus`
-- 

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`parent_id` = 'clin_CAN_4'
AND `menus`.`language_title` IN ('screening', /*'lifestyle',*/ 
'adverse events', 'clin_study', 'protocol');

UPDATE `menus` 
SET `use_link` = '/clinicalannotation/event_masters/listall/clin_CAN_28/lab/' 
WHERE `menus`.`id` = 'clin_CAN_4';

-- 
-- Table - `event_controls`
-- 

DELETE FROM `event_controls`;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`) VALUES 
(2, 'all', 'lab', 'path report', 'active', 'ed_lab_path_report', 'ed_lab_path_report'),
(3, 'all', 'lab', 'revision report', 'active', 'ed_lab_revision_report', 'ed_lab_revision_report'),
(4, 'all', 'lab', 'lab blood report', 'active', 'ed_lab_blood_report', 'ed_lab_blood_report'),

(7, 'all', 'clinical', 'biopsy', 'active', 'ed_biopsy_clin_event', 'ed_biopsy_clin_event'),
(8, 'all', 'clinical', 'collection for cytology', 'active', 'ed_coll_for_cyto_clin_event', 'ed_coll_for_cyto_clin_event'),
(9, 'all', 'clinical', 'medical examination', 'active', 'ed_examination_clin_event', 'ed_examination_clin_event'),
(10, 'all', 'clinical', 'medical imaging', 'active', 'ed_medical_imaging_clin_event', 'ed_medical_imaging_clin_event'),

(11, 'all', 'lifestyle', 'procure', 'active', 'ed_all_procure_lifestyle', 'ed_all_procure_lifestyle');

-- 
-- Table - `forms`
-- 

DELETE FROM `forms`  
WHERE `id` IN ('CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0012', 
'CAN-024-001-000-999-0015',
'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0018',
'CAN-024-001-000-999-0019', 'CAN-024-001-000-999-0020');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0011', 'ed_lab_path_report', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0012', 'ed_lab_revision_report', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020', 'ed_lab_blood_report', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

('CAN-024-001-000-999-0019', 'ed_all_procure_lifestyle', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

('CAN-024-001-000-999-0015', 'ed_biopsy_clin_event', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0016', 'ed_coll_for_cyto_clin_event', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0017', 'ed_examination_clin_event', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0018', 'ed_medical_imaging_clin_event', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0044',
'CAN-024-001-000-999-0046', 'CAN-024-001-000-999-0048',
'CAN-024-001-000-999-0049', 'CAN-024-001-000-999-0050', 'CAN-024-001-000-999-0053',
'CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0055', 'CAN-024-001-000-999-0056',
'CAN-024-001-000-999-0058', 'CAN-024-001-000-999-0059', 'CAN-024-001-000-999-0065',
'CAN-024-001-000-999-0071', 'CAN-024-001-000-999-0072', 'CAN-024-001-000-999-0073', 
'CAN-024-001-000-999-0074', 'CAN-024-001-000-999-0075', 'CAN-024-001-000-999-0083',
'CAN-024-001-000-999-0084', 'CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0086',
'CAN-024-001-000-999-0087', 'CAN-024-001-000-999-0088', 'CAN-024-001-000-999-0089',
'CAN-024-001-000-999-0090', 'CAN-024-001-000-999-0091', 'CAN-024-001-000-999-0092',
'CAN-024-001-000-999-0105', 'CAN-024-001-000-999-0106');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0053', 'EventMaster', 'sardo_record_id', 'sardo record id', '',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0085', 'EventMaster', 'sardo_record_source', 'sardo record source', '',
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0054', 'EventMaster', 'last_sardo_import_date', 'last import date', '',  
'date', '', 'NULL', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0065', 'EventMaster', 'approximative_event_date', 'approximative date', '', 
'select', '', 'no', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0105', 'EventMaster', 'result', 'result', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0106', 'EventMaster', 'therapeutic_goal', 'therapeutic goal', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* For lab report */
('CAN-024-001-000-999-0055', 'EventDetail', 'conclusion', 'lab report conclusion', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0056', 'EventDetail', 'path_report_code', 'lab report code', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0046', 'EventDetail', 'revision_type', 'type', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

('CAN-024-001-000-999-0083', 'EventDetail', 'aps', 'aps', '', 
'input', 'size=20', '', '',
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0086', 'EventDetail', 'aps_sardo_record_id', '', 'sardo record id',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0084', 'EventDetail', 'aps_pre_op', 'aps pre-operatory', '', 
'input', 'size=20', '', '',
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0087', 'EventDetail', 'aps_pre_op_sardo_record_id', '', 'sardo record id',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0071', 'EventDetail', 'ca_125', 'ca 125', '', 
'input', 'size=20', '', '',
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0088', 'EventDetail', 'ca125_sardo_record_id', '', 'sardo record id',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0072', 'EventDetail', 'red_blood_cells', 'red blood cells', '', 
'input', 'size=20', '', '',
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0089', 'EventDetail', 'rbc_sardo_record_id', '', 'sardo record id',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0073', 'EventDetail', 'hemoglobin', 'hemoglobin', '', 
'input', 'size=20', '', '',
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0090', 'EventDetail', 'hmg_sardo_record_id', '', 'sardo record id',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0074', 'EventDetail', 'hematocrit', 'hematocrit', '', 
'input', 'size=20', '', '',
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0091', 'EventDetail', 'hmt_sardo_record_id', '', 'sardo record id',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0075', 'EventDetail', 'mean_corpusc_volume', 'mean corpuscular volume', '', 
'input', 'size=20', '', '',
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0092', 'EventDetail', 'mcv_sardo_record_id', '', 'sardo record id',
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* For lifestyle */
('CAN-024-001-000-999-0059', 'EventDetail', 'procure_lifestyle_status', 'status', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* For clinical */
('CAN-024-001-000-999-0044', 'EventDetail', 'biopsy_type', 'type', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0048', 'EventDetail', 'collection_type', 'type', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0049', 'EventDetail', 'examination_type', 'type', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0050', 'EventDetail', 'imaging_type', 'type', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0058', 'EventDetail', 'ed_lab_path_report_id', 'path report', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_path_report_conclusion', 'qc_event_type', 'qc_procure_lifestyle_status', 
'sardo_data_source');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_path_report_conclusion', NULL , NULL , 'positif', 'positif', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_path_report_conclusion', NULL , NULL , 'negatif', 'negatif', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_path_report_conclusion', NULL , NULL , 'unknown', 'unknown', '3', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'qc_event_type', NULL , NULL , 'path report', 'path report', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_event_type', NULL , NULL , 'revision report', 'revision report', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_event_type', NULL , NULL , 'lab blood report', 'lab blood report', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_event_type', NULL , NULL , 'biopsy', 'biopsy', '5', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_event_type', NULL , NULL , 'collection for cytology', 'collection for cytology', '6', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_event_type', NULL , NULL , 'medical examination', 'medical examination', '7', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_event_type', NULL , NULL , 'medical imaging', 'medical imaging', '8', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_event_type', NULL , NULL , 'procure', 'procure', '9', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'sardo_data_source', NULL , NULL , 'n/a', 'n/a', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'sardo_data_source', NULL , NULL , 'treatment', 'treatment', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'sardo_data_source', NULL , NULL , 'lab', 'lab', '2', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'qc_procure_lifestyle_status', NULL , NULL , 'to deliver', 'to deliver', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_procure_lifestyle_status', NULL , NULL , 'delivered', 'delivered', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_procure_lifestyle_status', NULL , NULL , 'received', 'received', '3', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0105');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0105', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'positif')),
('CAN-024-001-000-999-0105', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'negatif')),
('CAN-024-001-000-999-0105', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'suspect')),
('CAN-024-001-000-999-0105', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_trt_result' AND `value` like 'uncertain'));

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0055', 'CAN-999-999-000-999-228',
'CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0085');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0055', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_path_report_conclusion' AND `value` like 'positif')),
('CAN-024-001-000-999-0055', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_path_report_conclusion' AND `value` like 'negatif')),
('CAN-024-001-000-999-0055', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_path_report_conclusion' AND `value` like 'unknown')),

('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'path report')),
('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'revision report')),
('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'lab blood report')),
('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'biopsy')),
('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'collection for cytology')),
('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'medical examination')),
('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'medical imaging')),
('CAN-999-999-000-999-228', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_event_type' AND `value` like 'procure')),

('CAN-024-001-000-999-0059', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_procure_lifestyle_status' AND `value` like 'to deliver')),
('CAN-024-001-000-999-0059', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_procure_lifestyle_status' AND `value` like 'delivered')),
('CAN-024-001-000-999-0059', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_procure_lifestyle_status' AND `value` like 'received')),

('CAN-024-001-000-999-0085', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'sardo_data_source' AND `value` like 'n/a')),
('CAN-024-001-000-999-0085', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'sardo_data_source' AND `value` like 'treatment')),
('CAN-024-001-000-999-0085', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'sardo_data_source' AND `value` like 'lab')),

('CAN-024-001-000-999-0065', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0065', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

-- 
-- Table - `form_validations`
-- 

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0056', 'CAN-024-001-000-999-0065');

-- INSERT INTO `form_validations` 
-- ( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
-- VALUES 
-- (NULL , 'CAN-024-001-000-999-0056', '/.+/', 'lab path report code is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- (NULL , 'CAN-024-001-000-999-0065', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- form event master

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-11_CAN-999-999-000-999-230');

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-11_CAN-024-001-000-999-0053',
'CAN-999-999-000-999-11_CAN-024-001-000-999-0085');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sardo record id */
('CAN-999-999-000-999-11_CAN-024-001-000-999-0053', 'CAN-999-999-000-999-11', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-11_CAN-024-001-000-999-0085', 'CAN-999-999-000-999-11', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_lab_path_report

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0011');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sardo treatment id */
('CAN-024-001-000-999-0011_CAN-024-001-000-999-0053', 'CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source */
('CAN-024-001-000-999-0011_CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0011_CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0054', 2, 100, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1,  
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Diagnosis */
-- ('CAN-024-001-000-999-0011_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0011', 'CAN-999-999-000-999-522', 1, 1, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0011_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0011', 'CAN-999-999-000-999-229', 1, 2, 
'path report', 1, 'lab report date', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* code */
('CAN-024-001-000-999-0011_CAN-024-001-000-999-0056', 'CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0056', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* conclusion */
('CAN-024-001-000-999-0011_CAN-024-001-000-999-0055', 'CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0055', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
-- ('CAN-024-001-000-999-0011_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0011', 'CAN-999-999-000-999-230', 1, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0011_CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0065', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_lab_revision_report

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0012');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sardo treatment id */
('CAN-024-001-000-999-0012_CAN-024-001-000-999-0053', 'CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source */
('CAN-024-001-000-999-0012_CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0012_CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0054', 2, 100, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Diagnosis */
('CAN-024-001-000-999-0012_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0012', 'CAN-999-999-000-999-522', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0012_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0012', 'CAN-999-999-000-999-229', 1, 2, 
'revision report', 1, 'lab report date', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* code */
('CAN-024-001-000-999-0012_CAN-024-001-000-999-0056', 'CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0056', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Type */
('CAN-024-001-000-999-0012_CAN-024-001-000-999-0046', 'CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0046', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* conclusion */
('CAN-024-001-000-999-0012_CAN-024-001-000-999-0055', 'CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0055', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
-- ('CAN-024-001-000-999-0012_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0012', 'CAN-999-999-000-999-230', 1, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0012_CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0065', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_lab_blood_report

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0020');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sardo treatment id */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0053', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0054', 2, 100, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Diagnosis */
('CAN-024-001-000-999-0020_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0020', 'CAN-999-999-000-999-522', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0020_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0020', 'CAN-999-999-000-999-229', 1, 2, 
'lab blood report', 1, 'lab report date', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* code */
-- ('CAN-024-001-000-999-0020_CAN-024-001-000-999-0056', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0056', 1, 4, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
-- ('CAN-024-001-000-999-0020_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0020', 'CAN-999-999-000-999-230', 1, 20, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0065', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* aps */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0083', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0083', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0086', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0086', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aps pre op */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0084', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0084', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0087', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0087', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* ca 125 */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0071', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0071', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0088', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0088', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* red_blood_cells */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0072', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0072', 1, 8, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0089', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0089', 1, 8, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* hemoglobin */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0073', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0073', 1, 9, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0090', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0090', 1, 9, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* hematocrit */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0074', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0074', 1, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0091', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0091', 1, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* cell volum */
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0075', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0075', 1, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0020_CAN-024-001-000-999-0092', 'CAN-024-001-000-999-0020', 'CAN-024-001-000-999-0092', 1, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_all_procure_lifestyle

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0019');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* Diagnosis */
('CAN-024-001-000-999-0019_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0019', 'CAN-999-999-000-999-522', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0019_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0019', 'CAN-999-999-000-999-229', 1, 2, 
'lifestyle', 1, 'status date', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* status */
('CAN-024-001-000-999-0019_CAN-024-001-000-999-0059', 'CAN-024-001-000-999-0019', 'CAN-024-001-000-999-0059', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
('CAN-024-001-000-999-0019_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0019', 'CAN-999-999-000-999-230', 1, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_biopsy_clin_event

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0015');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* result */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0105', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0105', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0106', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0106', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo treatment id */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0053', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0054', 2, 100, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Diagnosis */
('CAN-024-001-000-999-0015_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0015', 'CAN-999-999-000-999-522', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0015_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0015', 'CAN-999-999-000-999-229', 1, 2, 
'biopsy', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Type */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0044', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0044', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
-- ('CAN-024-001-000-999-0015_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0015', 'CAN-999-999-000-999-230', 1, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* path report number */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0058', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0058', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0015_CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0015', 'CAN-024-001-000-999-0065', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_coll_for_cyto_clin_event

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0016');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* result */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0105', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0105', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0106', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0106', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo treatment id */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0053', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0054', 2, 100, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Diagnosis */
('CAN-024-001-000-999-0016_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0016', 'CAN-999-999-000-999-522', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0016_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0016', 'CAN-999-999-000-999-229', 1, 2, 
'collection for cytology', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Type */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0048', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0048', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
-- ('CAN-024-001-000-999-0016_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0016', 'CAN-999-999-000-999-230', 1, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* path report number */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0058', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0058', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0016_CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0016', 'CAN-024-001-000-999-0065', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_examination_clin_event

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0017');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* result */
('CAN-024-001-000-999-0017_CAN-024-001-000-999-0105', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0105', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-024-001-000-999-0017_CAN-024-001-000-999-0106', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0106', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo treatment id */
('CAN-024-001-000-999-0017_CAN-024-001-000-999-0053', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source */
('CAN-024-001-000-999-0017_CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0017_CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0054', 2, 100, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Diagnosis */
('CAN-024-001-000-999-0017_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0017', 'CAN-999-999-000-999-522', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0017_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0017', 'CAN-999-999-000-999-229', 1, 2, 
'medical examination', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Type */
('CAN-024-001-000-999-0017_CAN-024-001-000-999-0049', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0049', 1, 4,
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
-- ('CAN-024-001-000-999-0017_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0017', 'CAN-999-999-000-999-230', 1, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0017_CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0017', 'CAN-024-001-000-999-0065', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- form ed_medical_imaging_clin_event

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0018');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* result */
('CAN-024-001-000-999-0018_CAN-024-001-000-999-0105', 'CAN-024-001-000-999-0018', 'CAN-024-001-000-999-0105', 1, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* therapeutic goal */
('CAN-024-001-000-999-0018_CAN-024-001-000-999-0106', 'CAN-024-001-000-999-0018', 'CAN-024-001-000-999-0106', 1, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sardo treatment id */
('CAN-024-001-000-999-0018_CAN-024-001-000-999-0053', 'CAN-024-001-000-999-0018', 'CAN-024-001-000-999-0053', 2, 98, 
'sardo data', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source */
('CAN-024-001-000-999-0018_CAN-024-001-000-999-0085', 'CAN-024-001-000-999-0018', 'CAN-024-001-000-999-0085', 2, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* last sardo import date */
('CAN-024-001-000-999-0018_CAN-024-001-000-999-0054', 'CAN-024-001-000-999-0018', 'CAN-024-001-000-999-0054', 2,100, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Diagnosis */
('CAN-024-001-000-999-0018_CAN-999-999-000-999-522', 'CAN-024-001-000-999-0018', 'CAN-999-999-000-999-522', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Date */
('CAN-024-001-000-999-0018_CAN-999-999-000-999-229', 'CAN-024-001-000-999-0018', 'CAN-999-999-000-999-229', 1, 2, 
'medical imaging', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Type */
('CAN-024-001-000-999-0018_CAN-024-001-000-999-0050', 'CAN-024-001-000-999-0018', 'CAN-024-001-000-999-0050', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Summary */
-- ('CAN-024-001-000-999-0018_CAN-999-999-000-999-230', 'CAN-024-001-000-999-0018', 'CAN-999-999-000-999-230', 1, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* approximative date */
('CAN-024-001-000-999-0018_CAN-024-001-000-999-0065', 'CAN-024-001-000-999-0018', 'CAN-024-001-000-999-0065', 1, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- PARTICIPANT SAMPLE
--
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-1053_CAN-024-001-000-999-0001');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-999-999-000-999-1053_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1053', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- CTRApp - inventory management - Quebec Customization
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- GENERAL: MENU
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- GENERAL: SIDEBARS
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- COLLECTION
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For collection

UPDATE `form_fields`
SET `type` = 'select',
`setting` = ''
WHERE `id` = 'CAN-999-999-000-999-1005';	/* Collection reception_by */

-- Action: DELETE
-- Comments: For collection

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0040');

-- Action: INSERT
-- Comments: For collection

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0040', 'Collection', 'bank_participant_identifier', 'bank participant identifier', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For collection

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1000_CAN-024-001-000-999-0040',
'CAN-999-999-000-999-1001_CAN-024-001-000-999-0040'
);

-- Action: INSERT
-- Comments: For collection

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-999-999-000-999-1000_CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1000', 'CAN-024-001-000-999-0040', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1001_CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0040', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For collection

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('qc_site_list', 'qc_bank_list', 'qc_lab_people_list');

-- Action: INSERT
-- Comments: For collection

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_bank_list', NULL , NULL , 'breast', 'breast', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_bank_list',NULL , NULL , 'ovary', 'ovary', '2', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_bank_list', NULL , NULL , 'prostate', 'prostate', '3', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'qc_site_list', NULL , NULL , 'notre dame hospital', 'notre dame hospital', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_site_list', NULL , NULL , 'hotel dieu hospital', 'hotel dieu hospital', '3', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_site_list',NULL , NULL , 'saint luc hospital', 'saint luc hospital', '2', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'qc_lab_people_list',NULL , NULL , 'aurore pierrard', 'aurore pierrard', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'chantale auger', 'chantale auger', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'christine abaji', 'christine abaji', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'emilio, johanne et phil', 'emilio, johanne et phil', '4', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'hafida lounis', 'hafida lounis', '5', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'isabelle letourneau', 'isabelle letourneau', '6', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'jason madore', 'jason madore', '7', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'jennifer kendall dupont', 'jennifer kendall dupont', '8', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'jessica godin ethier', 'jessica godin ethier', '8', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'josh levin', 'josh levin', '9', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'julie desgagnes', 'julie desgagnes', '10', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'karine normandin', 'karine normandin', '11', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'kevin gu', 'kevin gu', '12', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'labo externe', 'labo externe', '13', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'liliane meunier', 'liliane meunier', '14', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'lise portelance', 'lise portelance', '15', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'louise champoux', 'louise champoux', '16', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'magdalena zietarska', 'magdalena zietarska', '17', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'manon de ladurantaye', 'manon de ladurantaye', '18', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'marie-andree forget', 'marie-andree forget', '19', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'marie-josee milot', 'marie-josee milot', '20', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'marie-line puiffe', 'marie-line puiffe', '21', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'marise roy', 'marise roy', '22', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'matthew starek', 'matthew starek', '23', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'mona alam', 'mona alam', '24', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'nathalie delvoye', 'nathalie delvoye', '25', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'pathologie', 'pathologie', '26', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'patrick kibangou bondza', 'patrick kibangou bondza', '27', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'stephanie lepage', 'stephanie lepage', '28', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'urszula krzemien', 'urszula krzemien', '29', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'valerie forest', 'valerie forest', '30', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'veronique barres', 'veronique barres', '31', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'veronique ouellet', 'veronique ouellet', '32', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'yuan chang', 'yuan chang', '33', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'autre', 'autre', '34', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_lab_people_list', NULL , NULL , 'inconnue', 'inconnue', '35', 'yes', NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For collection

DELETE FROM `form_fields_global_lookups`
WHERE `field_id`  IN ('CAN-999-999-000-999-1001', 'CAN-999-999-000-999-1002', 
'CAN-999-999-000-999-1003', 'CAN-999-999-000-999-1005', 'CAN-999-999-000-999-1223');

-- Action: INSERT
-- Comments: For collection

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1001', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'breast')),
('CAN-999-999-000-999-1001', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'ovary')),
('CAN-999-999-000-999-1001', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'prostate')),

('CAN-999-999-000-999-1002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'breast')),
('CAN-999-999-000-999-1002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'ovary')),
('CAN-999-999-000-999-1002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'prostate')),

('CAN-999-999-000-999-1223', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'breast')),
('CAN-999-999-000-999-1223', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'ovary')),
('CAN-999-999-000-999-1223', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'prostate')),

('CAN-999-999-000-999-1003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` like 'notre dame hospital')),
('CAN-999-999-000-999-1003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` like 'hotel dieu hospital')),
('CAN-999-999-000-999-1003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` like 'saint luc hospital')),

('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'inconnue')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'lise portelance')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'chantale auger')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jason madore')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jennifer kendall dupont')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'julie desgagnes')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'karine normandin')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'isabelle letourneau')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'josh levin')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'liliane meunier')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'manon de ladurantaye')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'aurore pierrard')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'magdalena zietarska')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'nathalie delvoye')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'patrick kibangou bondza')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'urszula krzemien')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'valerie forest')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique barres')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'labo externe')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'pathologie')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'christine abaji')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'Elsa ')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'emilio, johanne et phil')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'hafida lounis')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jessica godin ethier')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'kevin gu')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'louise champoux')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-andree forget')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-josee milot')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-line puiffe')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marise roy')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'matthew starek')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'mona alam')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'stephanie lepage')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique ouellet')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'yuan chang')),
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'autre'));

-- 
-- Table - `form_validations`
-- 

DELETE FROM `form_validations` WHERE `form_field_id` = 'CAN-999-999-000-999-1001';	/* collection bank */
INSERT INTO `form_validations` 
(`id`, `form_field_id`, `expression`, `message`, `created`, `created_by`, `modified`, `modifed_by`) 
VALUES 
(NULL, 'CAN-999-999-000-999-1001', '/.+/', 'bank selection is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- SAMPLE
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- SAMPLE : lab_type_laterality_match
-- ---------------------------------------------------------------------

-- 
-- Table - `lab_type_laterality_match`
-- 

-- Action: DELETE
-- Comments: For lab_type_laterality_match

DELETE FROM `lab_type_laterality_match`;

-- Action: INSERT
-- Comments: For Sample Master

INSERT INTO `lab_type_laterality_match` 
( `id` , `selected_type_code` , `selected_labo_laterality` , `sample_type_matching` , `tissue_source_matching` , `nature_matching`, `laterality_matching` )
VALUES 
(NULL , 'TOV', 'D', 'tissue', 'ovary', 'malignant', 'right'),
(NULL , 'TOV', 'G', 'tissue', 'ovary', 'malignant', 'left'),
(NULL , 'TOV', '', 'tissue', 'ovary', 'malignant', 'unknwon'),
(NULL , 'TOV', 'UniLat NS', 'tissue', 'ovary', 'malignant', 'unknwon'),
(NULL , 'TOV', 'unknown', 'tissue', 'unknown', 'malignant', ''),
(NULL , 'TOV', 'EP', 'tissue', 'omentum', 'malignant', ''),
(NULL , 'TOV', 'PT', 'tissue', 'peritoneum', 'malignant', ''),
(NULL , 'TOV', 'M', 'tissue', 'other (metastasis)', 'malignant', ''),
(NULL , 'TOV', 'TR', 'tissue', 'fallopian tube', 'malignant', ''),
(NULL , 'TOV', 'TRD', 'tissue', 'fallopian tube', 'malignant', 'right'),
(NULL , 'TOV', 'TRG', 'tissue', 'fallopian tube', 'malignant', 'left'),
(NULL , 'BOV', 'D', 'tissue', 'ovary', 'begnin', 'right'),
(NULL , 'BOV', 'G', 'tissue', 'ovary', 'begnin', 'left'),
(NULL , 'BOV', '', 'tissue', 'ovary', 'begnin', 'unknwon'),
(NULL , 'BOV', 'UniLat NS', 'tissue', 'ovary', 'begnin', 'unknwon'),
(NULL , 'BOV', 'unknown', 'tissue', 'Inconnu', 'begnin', ''),
(NULL , 'BOV', 'EP', 'tissue', 'omentum', 'begnin', ''),
(NULL , 'BOV', 'PT', 'tissue', 'peritoneum', 'begnin', ''),
(NULL , 'BOV', 'TR', 'tissue', 'fallopian tube', 'begnin', ''),
(NULL , 'BOV', 'TRD', 'tissue', 'fallopian tube', 'begnin', 'right'),
(NULL , 'BOV', 'TRG', 'tissue', 'fallopian tube', 'begnin', 'left'),
(NULL , 'NOV', 'D', 'tissue', 'ovary', 'normal', 'right'),
(NULL , 'NOV', 'G', 'tissue', 'ovary', 'normal', 'left'),
(NULL , 'NOV', '', 'tissue', 'ovary', 'normal', 'unknwon'),
(NULL , 'NOV', 'UniLat NS', 'tissue', 'ovary', 'normal', 'unknwon'),
(NULL , 'NOV', 'unknown', 'tissue', 'unknown', 'normal', ''),
(NULL , 'NOV', 'EP', 'tissue', 'omentum', 'normal', ''),
(NULL , 'NOV', 'PT', 'tissue', 'peritoneum', 'normal', ''),
(NULL , 'NOV', 'TR', 'tissue', 'fallopian tube', 'normal', ''),
(NULL , 'NOV', 'TRD', 'tissue', 'fallopian tube', 'normal', 'right'),
(NULL , 'NOV', 'TRG', 'tissue', 'fallopian tube', 'normal', 'left'),
(NULL , 'OV', '', 'ascite', '', '', ''),
(NULL , 'LK', '', 'cystic fluid', '', '', ''),
(NULL , 'LP', '', 'peritoneal wash', '', '', ''),
(NULL , 'LA', '', 'other fluid', '', '', ''),
(NULL , 'S', '', 'blood', '', '', ''),
(NULL , 'TR', '', 'tissue', 'fallopian tube', 'unknwon', ''),
(NULL , 'TR', 'D', 'tissue', 'fallopian tube', 'unknwon', 'right'),
(NULL , 'TR', 'G', 'tissue', 'fallopian tube', 'unknwon', 'left'),
(NULL , 'TR', 'M', 'tissue', 'other', 'malignant', ''),
(NULL , 'UT', '', 'tissue', 'uterus', 'unknwon', ''),
(NULL , 'UT', 'PT', 'tissue', 'peritoneum', 'malignant', ''),
(NULL , 'unknwon', '', 'tissue', 'unknown', 'unknwon', ''),
(NULL , 'unknwon', 'D', 'tissue', 'unknown', 'unknwon', 'right'),
(NULL , 'unknwon', 'G', 'tissue', 'unknown', 'unknwon', 'left'),
(NULL , 'unknwon', 'EP', 'tissue', 'omentum', 'unknwon', ''),
(NULL , 'unknwon', 'M', 'tissue', 'other', 'unknwon', ''),
(NULL , 'unknwon', 'PT', 'tissue', 'peritoneum', 'unknwon', ''),
(NULL , 'MOV', '', 'tissue', 'ovary', 'malignant', ''),
(NULL , 'MOV', 'D', 'tissue', 'ovary', 'malignant', 'right'),
(NULL , 'MOV', 'G', 'tissue', 'ovary', 'malignant', 'left'),
(NULL , 'MOV', 'EP', 'tissue', 'omentum', 'malignant', ''),
(NULL , 'MOV', 'UniLat NS', 'tissue', 'ovary', 'malignant', ''),
(NULL , 'MOV', 'PT', 'tissue', 'peritoneum', 'malignant', ''),
(NULL , 'MOV', 'M', 'tissue', 'other (metastasis)', 'malignant', ''),
(NULL , 'BR', '', 'tissue', 'breast', 'unknwon', ''),
(NULL , 'BR', 'D', 'tissue', 'breast', 'unknwon', 'right'),
(NULL , 'BR', 'G', 'tissue', 'breast', 'unknwon', 'left'),
(NULL , 'L', '', 'blood', '', '', ''),
(NULL , 'U', '', 'urine', '', '', ''),
(NULL , 'PR', '', 'tissue', 'prostate', 'unknwon', ''),
(NULL , 'T', '', 'tissue', 'breast', 'malignant', ''),
(NULL , 'T', 'D', 'tissue', 'breast', 'malignant', 'right'),
(NULL , 'T', 'G', 'tissue', 'breast', 'malignant', 'left'),
(NULL , 'N', '', 'tissue', 'breast', 'normal', ''),
(NULL , 'N', 'D', 'tissue', 'breast', 'normal', 'right'),
(NULL , 'N', 'G', 'tissue', 'breast', 'normal', 'left'),
(NULL , 'other', '', 'tissue', 'other', 'unknwon', ''),
(NULL , 'other', 'PT', 'tissue', 'peritoneum', 'unknwon', ''),
(NULL , 'other', 'M', 'tissue', 'other (metastasis)', 'unknwon', ''),
(NULL , 'other', 'TR', 'tissue', 'fallopian tube', 'unknwon', ''),
(NULL , 'other', 'EP', 'tissue', 'omentum', 'unknwon', '');

-- ---------------------------------------------------------------------
-- SAMPLE : master
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: UPDATE
-- Comments: For Sample Master

UPDATE `form_fields`
SET `default` = 'n/a'
WHERE `id` = 'CAN-999-999-000-999-1031';	/* Product Code */

UPDATE `form_fields`
SET `type` = 'select',
`setting` = ''
WHERE `id` = 'CAN-999-999-000-999-1060';	/* creation site */

-- Action: DELETE
-- Comments: For Sample Master

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0001');

-- Action: INSERT
-- Comments: For Sample Master

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0001', 'SampleMaster', 'sample_label', 'sample label', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For Sample Master

DELETE FROM `form_formats`  
WHERE `field_id` IN ('CAN-999-999-000-999-1031');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1002_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1037_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1003_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1004_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1021_CAN-024-001-000-999-0001'
);

-- Action: INSERT
-- Comments: For Sample Master

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label for sample master */
('CAN-999-999-000-999-1002_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1002', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample label for collection product aliquots list */
('CAN-999-999-000-999-1037_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1037', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample label for sample search result */
('CAN-999-999-000-999-1003_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1003', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample label for sample tree view */
('CAN-999-999-000-999-1004_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1004', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample label for aliquot search result */
('CAN-999-999-000-999-1021_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1021', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-1003_CAN-024-001-000-999-0040',
'CAN-999-999-000-999-1002_CAN-024-001-000-999-0040');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* participant bank number for sample master */
('CAN-999-999-000-999-1002_CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1002', 'CAN-024-001-000-999-0040', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* participant bank number for sample search result */
('CAN-999-999-000-999-1003_CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1003', 'CAN-024-001-000-999-0040', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For Sample Master

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('qc_derivative_creation_site', 'qc_supplier_dept');

-- Action: INSERT
-- Comments: For Sample Master

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_derivative_creation_site', NULL , NULL , 'Labo Dr Mes-Masson', 'Labo Dr Mes-Masson', '2', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_derivative_creation_site', NULL , NULL , 'Labo Dr Maugard', 'Labo Dr Maugard', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_derivative_creation_site', NULL , NULL , 'Labo Dr Santos', 'Labo Dr Santos', '3', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_derivative_creation_site', NULL , NULL , 'Labo Dr Tonin', 'Labo Dr Tonin', '5', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'qc_derivative_creation_site', NULL , NULL , 'Labo Sein', 'Labo Sein', '4', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_derivative_creation_site', NULL , NULL , 'unknown', 'unknown', '15', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'qc_supplier_dept', NULL , NULL , 'biological sample taking center', 'biological sample taking center', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'clinic', 'clinic', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'breast clinic', 'breast clinic', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'external clinic', 'external clinic', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'gynaecology/oncology clinic', 'gynaecology/oncology clinic', '4', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'family cancer center', 'family cancer center', '4', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'preoperative checkup', 'preoperative checkup', '5', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'operating room', 'operating room', '5', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'pathology dept', 'pathology dept', '6', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_supplier_dept', NULL , NULL , 'other', 'other', '7', 'yes', NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For Sample Master

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-999-999-000-999-1060', 'CAN-999-999-000-999-1032');

-- Action: INSERT
-- Comments: For Sample Master

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1060', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'Labo Dr Mes-Masson')),
('CAN-999-999-000-999-1060', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'Labo Dr Maugard')),
('CAN-999-999-000-999-1060', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'Labo Dr Santos')),
('CAN-999-999-000-999-1060', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'Labo Dr Tonin')),
('CAN-999-999-000-999-1060', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'Labo Sein')),
('CAN-999-999-000-999-1060', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'unknown')),

('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'biological sample taking center')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'clinic')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'breast clinic')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'external clinic')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'family cancer center')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'preoperative checkup')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'operating room')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'pathology dept')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'other')),
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'gynaecology/oncology clinic'));

-- ---------------------------------------------------------------------
-- SAMPLE : For undetailed specimens (fields also used by all other 
--          specimen types)
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0002', 'CAN-024-001-000-999-0003');

-- Action: INSERT
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0002', 'SpecimenDetail', 'type_code', 'labo type code', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0003', 'SpecimenDetail', 'sequence_number', 'sequence number', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1005_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1005_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1005_CAN-024-001-000-999-0003'
);

-- Action: INSERT
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1005_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1005', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1005_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1005', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1005_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1005', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('labo_sample_type_code');

-- Action: INSERT
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 

(NULL , 'labo_sample_type_code', NULL , NULL , 'BOV', 'BOV type code', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'BR', 'BR type code', '3', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'L', 'L type code', '6', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'LK', 'LK type code', '9', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'LP', 'LP type code', '12', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'LA', 'LA type code', '15', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'MOV', 'MOV type code', '18', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'N', 'N type code', '21', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'NOV', 'NOV type code', '24', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'OV', 'OV type code', '27', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'PR', 'PR type code', '30', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'S', 'S type code', '33', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'T', 'T type code', '36', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'TOV', 'TOV type code', '39', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'TR', 'TR type code', '42', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'U', 'U type code', '45', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'UT', 'UT type code', '48', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'other', 'other', '100', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_sample_type_code', NULL , NULL , 'unknown', 'unknown', '101', 'yes', NULL , NULL , NULL , NULL); 

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0002');

-- Action: INSERT
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'unknown')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'TOV')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'BOV')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'NOV')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'OV')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'S')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'TR')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'UT')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'MOV')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'BR')), 
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'L')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'LK')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'LP')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'LA')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'U')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'PR')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'T')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'N')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'other')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'unknown'));

-- 
-- Table - `form_validations`
-- 

-- Action: DELETE
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0003');

-- Action: INSERT
-- Comments: For undetailed specimens (fields also used by all other 
--           specimen types)

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-024-001-000-999-0003', '/^[\\d]*$/', 'sequence should be an integer', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For blood specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For blood specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1006_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1006_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1006_CAN-024-001-000-999-0003'
);

-- Action: INSERT
-- Comments: For blood specimens

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1006_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1006', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1006_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1006', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1006_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1006', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For ascite specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For ascite specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1007_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1007_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1007_CAN-024-001-000-999-0003'
);

-- Action: INSERT
-- Comments: For ascite specimenss

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1007_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1007', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1007_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1007', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1007_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1007', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For tissue specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For tissue specimens

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0004');

-- Action: INSERT
-- Comments: For tissue specimens

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0004', 'SampleDetail', 'labo_laterality', 'labo tissue laterality', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For tissue specimens

UPDATE `form_formats` 
SET `flag_add` = '0',
`flag_edit` = '0' 
WHERE `id` IN (
'CAN-999-999-000-999-1008_CAN-999-999-000-999-1040', 
'CAN-999-999-000-999-1008_CAN-999-999-000-999-1041', 
'CAN-999-999-000-999-1008_CAN-999-999-000-999-1043');

-- Action: DELETE
-- Comments: For tissue specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1008_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1008_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1008_CAN-024-001-000-999-0003',
'CAN-999-999-000-999-1008_CAN-024-001-000-999-0004'
);

-- Action: INSERT
-- Comments: For tissue specimens

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1008_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1008', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1008_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1008', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1008_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1008', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo tissue laterality */
('CAN-999-999-000-999-1008_CAN-024-001-000-999-0004', 'CAN-999-999-000-999-1008', 'CAN-024-001-000-999-0004', 1, 36, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For tissue specimens

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('labo_tissue_laterality');

-- Action: INSERT
-- Comments: For tissue specimens

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'D', 'lab laterality D', '3', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'EP', 'lab laterality EP', '6', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'G', 'lab laterality G', '9', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'M', 'lab laterality M', '12', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'PT', 'lab laterality PT', '15', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'TR', 'lab laterality TR', '18', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'TRD', 'lab laterality TRD', '21', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'TRG', 'lab laterality TRG', '24', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'labo_tissue_laterality', NULL , NULL , 'UniLat NS', 'lab laterality UniLat NS', '27', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'labo_tissue_laterality', NULL , NULL , 'unknown', 'unknown', '50', 'yes', NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For tissue specimens

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0004');

-- Action: INSERT
-- Comments: For tissue specimens

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'unknown')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'D')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'EP')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'G')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'M')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'PT')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'TR')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'TRD')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'TRG')),
('CAN-024-001-000-999-0004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'UniLat NS'));

-- ---------------------------------------------------------------------
-- SAMPLE : For urine specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For urine specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1009_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1009_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1009_CAN-024-001-000-999-0003'
);

-- Action: INSERT
-- Comments: For urine specimenss

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1009_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1009', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1009_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1009', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1009_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1009', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For peritoneal wash specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For peritoneal wash specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1016_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1016_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1016_CAN-024-001-000-999-0003'
);

-- Action: INSERT
-- Comments: For peritoneal wash specimens

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1016_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1016', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1016_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1016', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1016_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1016', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For cystic fluid specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For cystic fluid specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1017_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1017_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1017_CAN-024-001-000-999-0003'
);

-- Action: INSERT
-- Comments: For cystic fluid specimens

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1017_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1017', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1017_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1017', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1017_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1017', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For other fluid specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For other fluid specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1018_CAN-024-001-000-999-0001',
'CAN-999-999-000-999-1018_CAN-024-001-000-999-0002',
'CAN-999-999-000-999-1018_CAN-024-001-000-999-0003'
);

-- Action: INSERT
-- Comments: For other fluid specimens

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1018_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* labo type code */
('CAN-999-999-000-999-1018_CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0002', 1, 35, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sequence number */
('CAN-999-999-000-999-1018_CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0003', 1, 37, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For undetailed derivatives (fields also used by all other 
--          derivative types)
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For undetailed derivatives specimens

UPDATE `form_fields`
SET `type` = 'select',
`setting` = ''
WHERE `id` = 'CAN-999-999-000-999-1061';	/* 	DerivativeDetail creation_by */

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For undetailed derivatives specimens

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1010_CAN-024-001-000-999-0001'
);

-- Action: INSERT
-- Comments: For undetailed derivatives specimens

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1010_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1010', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For undetailed derivatives specimens

DELETE FROM `form_fields_global_lookups`
WHERE `field_id`  IN ('CAN-999-999-000-999-1061');

-- Action: INSERT
-- Comments: For undetailed derivatives specimens

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'inconnue')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'lise portelance')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'chantale auger')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jason madore')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'julie desgagnes')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'karine normandin')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'isabelle letourneau')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'josh levin')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'liliane meunier')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'manon de ladurantaye')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'aurore pierrard')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'magdalena zietarska')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'nathalie delvoye')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'patrick kibangou bondza')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'urszula krzemien')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'valerie forest')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique barres')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'labo externe')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'pathologie')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'christine abaji')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'Elsa ')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'emilio, johanne et phil')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'hafida lounis')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jessica godin ethier')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'kevin gu')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'louise champoux')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-andree forget')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-josee milot')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-line puiffe')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marise roy')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'matthew starek')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'mona alam')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'stephanie lepage')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique ouellet')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'yuan chang')),
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'autre'));

DELETE FROM `form_fields_global_lookups`
WHERE `field_id`  IN ('CAN-999-999-000-999-1061')
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jennifer kendall dupont');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jennifer kendall dupont'));

-- ---------------------------------------------------------------------
-- SAMPLE : For cell culture derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `derived_sample_links`
-- 

DELETE FROM `derived_sample_links` 
WHERE `id` = '119' 
AND `source_sample_control_id` = '7'  
AND `derived_sample_control_id` = '11';

INSERT INTO `derived_sample_links` ( `id` , `source_sample_control_id` , `derived_sample_control_id` , `status` )
VALUES 
/* DERIVATIVE */
/* blood cells */
('119', '7', '11', 'active');		/* cell culture */

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For cell culture derivatives

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1011_CAN-024-001-000-999-0001'
);

-- Action: INSERT
-- Comments: For cell culture derivatives

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1011_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1011', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `global_lookups` 
WHERE `alias` = 'cell_culture_status_reason'
AND `value` = 'threw';
INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
(NULL, 'cell_culture_status_reason', NULL, NULL, 'threw', 'threw', 5, 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups` 
WHERE `field_id` = 'CAN-999-999-000-999-1066'
AND `lookup_id` = (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_culture_status_reason' AND `value` like 'threw');
INSERT INTO `form_fields_global_lookups` ( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1066', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_culture_status_reason' AND `value` like 'threw'));


-- ---------------------------------------------------------------------
-- SAMPLE : For blood cell derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For blood cell derivatives

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1012_CAN-024-001-000-999-0001'
);

-- Action: INSERT
-- Comments: For blood cell derivatives

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1012_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1012', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For pbmc derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For pbmc derivatives

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1013_CAN-024-001-000-999-0001'
);

-- Action: INSERT
-- Comments: For pbmc derivatives

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1013_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1013', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For plasma derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For plasma derivatives

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1014_CAN-024-001-000-999-0001'
);

-- Action: INSERT
-- Comments: For plasma derivatives

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1014_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1014', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For serum derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For serum derivatives

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1015_CAN-024-001-000-999-0001'
);

-- Action: INSERT
-- Comments: For serum derivatives

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* sample label */
('CAN-999-999-000-999-1015_CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1015', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For B cells derivatives
-- ---------------------------------------------------------------------

UPDATE `derived_sample_links`
SET `status` = 'inactive'
WHERE `id` = '25'
AND `source_sample_control_id` = '2'
AND `derived_sample_control_id`= '18';



-- ---------------------------------------------------------------------
-- SAMPLE : For DNA derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `sample_controls`
-- 

-- Action: UPDATE
-- Comments: For DNA derivatives

UPDATE `sample_controls` 
SET `form_alias` = 'sd_der_dnas',
`detail_tablename` = 'sd_der_dnas'
WHERE `sample_type` = 'dna';

-- 
-- Table - `forms`
-- 

-- Action: DELETE
-- Comments: For DNA derivatives

DELETE FROM `forms`  
WHERE `alias` = 'sd_der_dnas'
OR `id` IN ('CAN-024-001-000-999-0001');

-- Action: INSERT
-- Comments: For DNA derivatives

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0001', 'sd_der_dnas', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For DNA derivatives

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0005', 'CAN-024-001-000-999-0006', 
'CAN-024-001-000-999-0007');

-- Action: INSERT
-- Comments: For DNA derivatives

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0005', 'SampleDetail', 'source_cell_passage_number', 'source cell passage number', '', 
'input', 'size=6', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0006', 'SampleDetail', 'source_temperature', 'source storage temperature', '', 
'input', 'size=10', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0007', 'SampleDetail', 'source_temp_unit', '', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For DNA derivatives

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1016', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1018',
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1027', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1030', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1031', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1029', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1022', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1023', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1024', 
'CAN-024-001-000-999-0001_CAN-024-001-000-999-0001', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1060', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1061', 
'CAN-024-001-000-999-0001_CAN-999-999-000-999-1062', 
'CAN-024-001-000-999-0001_CAN-024-001-000-999-0005', 
'CAN-024-001-000-999-0001_CAN-024-001-000-999-0006', 
'CAN-024-001-000-999-0001_CAN-024-001-000-999-0007');

-- Action: INSERT
-- Comments: For DNA derivatives

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* Code */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1016', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1016', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Specimen Type */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1018', 0, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* category */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1027', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1027', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Sample SOP */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1030', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1030', 0, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Product Code */ 
-- ('CAN-024-001-000-999-0001_CAN-999-999-000-999-1031', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1031', 0, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* is problematic */ 
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1029', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1029', 0, 20, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Notes */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1022', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1022', 0, 21, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* parent sample code */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1023', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1023', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* parent sample code read only */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1024', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1024', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample label */
('CAN-024-001-000-999-0001_CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Creation site */ 
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1060', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1060', 1, 30, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation by */ 
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1061', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1061', 1, 31, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation date */
('CAN-024-001-000-999-0001_CAN-999-999-000-999-1062', 'CAN-024-001-000-999-0001', 'CAN-999-999-000-999-1062', 1, 32, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source cell passage number */
('CAN-024-001-000-999-0001_CAN-024-001-000-999-0005', 'CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0005', 1, 40, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source storage temperature */
('CAN-024-001-000-999-0001_CAN-024-001-000-999-0006', 'CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0006', 1, 41, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source storage temperature unit */
('CAN-024-001-000-999-0001_CAN-024-001-000-999-0007', 'CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0007', 1, 42, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For DNA derivatives

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0007');

-- Action: INSERT
-- Comments: For DNA derivatives

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0007', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'temperature_unit_code' AND `value` like 'celsius')),
('CAN-024-001-000-999-0007', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'temperature_unit_code' AND `value` like 'fahrenheit'));

-- 
-- Table - `form_validations`
-- 

-- Action: DELETE
-- Comments: For DNA derivatives

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0006', 'CAN-024-001-000-999-0005');

-- Action: INSERT
-- Comments: For DNA derivatives

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-024-001-000-999-0006', '/^-{0,1}\\d*([\\.]\\d*)?$/', 'temperature should be a decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL , 'CAN-024-001-000-999-0005', '/^\\d*([\\.]\\d*)?$/', 'cell passage number should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For RNA derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `sample_controls`
-- 

-- Action: UPDATE
-- Comments: For RNA derivatives

UPDATE `sample_controls` 
SET `form_alias` = 'sd_der_rnas',
`detail_tablename` = 'sd_der_rnas'
WHERE `sample_type` = 'rna';

-- 
-- Table - `derived_sample_links`
-- 

DELETE FROM `derived_sample_links` 
WHERE `id` = '118' 
AND `source_sample_control_id` = '2'  
AND `derived_sample_control_id` = '13';

INSERT INTO `derived_sample_links` ( `id` , `source_sample_control_id` , `derived_sample_control_id` , `status` )
VALUES 
/* SPECIMEN */
/* blood */
('118', '2', '13', 'active');		/* rna */

-- 
-- Table - `forms`
-- 

-- Action: DELETE
-- Comments: For RNA derivatives

DELETE FROM `forms`  
WHERE `alias` = 'sd_der_rnas'
OR `id` IN ('CAN-024-001-000-999-0002');

-- Action: INSERT
-- Comments: For RNA derivatives

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0002', 'sd_der_rnas', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For RNA derivatives

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1016', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1018',
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1027', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1030', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1031', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1029', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1022', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1023', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1024', 
'CAN-024-001-000-999-0002_CAN-024-001-000-999-0001', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1060', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1061', 
'CAN-024-001-000-999-0002_CAN-999-999-000-999-1062', 
'CAN-024-001-000-999-0002_CAN-024-001-000-999-0005', 
'CAN-024-001-000-999-0002_CAN-024-001-000-999-0006', 
'CAN-024-001-000-999-0002_CAN-024-001-000-999-0007');

-- Action: INSERT
-- Comments: For RNA derivatives

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* Code */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1016', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1016', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Specimen Type */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1018', 0, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* category */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1027', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1027', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Sample SOP */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1030', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1030', 0, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Product Code */ 
-- ('CAN-024-001-000-999-0002_CAN-999-999-000-999-1031', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1031', 0, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* is problematic */ 
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1029', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1029', 0, 20, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Notes */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1022', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1022', 0, 21, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* parent sample code */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1023', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1023', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* parent sample code read only */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1024', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1024', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample label */
('CAN-024-001-000-999-0002_CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0002', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Creation site */ 
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1060', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1060', 1, 30, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation by */ 
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1061', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1061', 1, 31, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation date */
('CAN-024-001-000-999-0002_CAN-999-999-000-999-1062', 'CAN-024-001-000-999-0002', 'CAN-999-999-000-999-1062', 1, 32, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source cell passage number */
('CAN-024-001-000-999-0002_CAN-024-001-000-999-0005', 'CAN-024-001-000-999-0002', 'CAN-024-001-000-999-0005', 1, 40, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source storage temperature */
('CAN-024-001-000-999-0002_CAN-024-001-000-999-0006', 'CAN-024-001-000-999-0002', 'CAN-024-001-000-999-0006', 1, 41, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source storage temperature unit */
('CAN-024-001-000-999-0002_CAN-024-001-000-999-0007', 'CAN-024-001-000-999-0002', 'CAN-024-001-000-999-0007', 1, 42, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- ALIQUOT
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- ALIQUOT : master
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: UPDATE
-- Comments: For aliquot master

-- UPDATE `form_fields`
-- SET `default` = 'n/a'
-- WHERE `id` = 'CAN-999-999-000-999-1118';	/* Product Code */

-- Action: DELETE
-- Comments: For aliquot master

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0008', 'CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For aliquot master

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0008', 'AliquotMaster', 'aliquot_label', 'aliquot label', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0009', 'AliquotMaster', 'aliquot_label', 'aliquot label', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For aliquot master

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN (
-- 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1118',
-- 'CAN-999-999-000-999-1021_CAN-999-999-000-999-1118');

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For aliquot master

DELETE FROM `form_formats`  
WHERE `field_id` IN ('CAN-999-999-000-999-1118');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1020_CAN-024-001-000-999-0009',
'CAN-999-999-000-999-1021_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For aliquot master

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (read-only) in aliquot list */
('CAN-999-999-000-999-1020_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1020', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only)  in aliquot search result form */
('CAN-999-999-000-999-1021_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1021', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_validations`
-- 

-- Action: DELETE
-- Comments: For aliquot master

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0008');

-- Action: INSERT
-- Comments: For aliquot Master

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-024-001-000-999-0008', '/.+/', 'aliquot label is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` = 'aliquot_status_reason'
AND `value` IN ('accident', 'see consent', 'quality problem', 'injected to mice');

INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES 
(NULL, 'aliquot_status_reason', NULL, NULL, 'accident', 'accident', 0, 'yes', NULL, NULL, NULL, NULL),
(NULL, 'aliquot_status_reason', NULL, NULL, 'see consent', 'see consent', 5, 'yes', NULL, NULL, NULL, NULL),
(NULL, 'aliquot_status_reason', NULL, NULL, 'quality problem', 'quality problem', 4, 'yes', NULL, NULL, NULL, NULL),
(NULL, 'aliquot_status_reason', NULL, NULL, 'injected to mice', 'injected to mice', 6, 'yes', NULL, NULL, NULL, NULL);

UPDATE `global_lookups`
SET `display_order` = 6
WHERE `alias` = 'aliquot_status_reason'
AND `value` IN ('reserved');

UPDATE `global_lookups`
SET `display_order` = 7
WHERE `alias` = 'aliquot_status_reason'
AND `value` IN (' 	used and/or sent');

UPDATE `global_lookups`
SET `display_order` = 99
WHERE `alias` = 'aliquot_status_reason'
AND `value` IN ('other');

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `lookup_id` IN (
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'accident'),
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'see consent'), 
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'quality problem'), 
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'injected to mice'));

INSERT INTO `form_fields_global_lookups` (`field_id`, `lookup_id`) VALUES 
('CAN-999-999-000-999-1104', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'accident')),
('CAN-999-999-000-999-1104', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'see consent')), 
('CAN-999-999-000-999-1104', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'injected to mice')), 
('CAN-999-999-000-999-1104', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'quality problem'));

-- ---------------------------------------------------------------------
-- ALIQUOT : Collection Product Aliquots list 
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For Product Aliquots list

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1037_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For Product Aliquots list

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (read-only) */
('CAN-999-999-000-999-1037_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1037', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
-- ---------------------------------------------------------------------
-- ALIQUOT : For undetailled specimen aliquot
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For undetailled specimen aliquot

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1026_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For undetailled specimen aliquot

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1026_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1026_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For undetailled specimen aliquot

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1026_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1026', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1026_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1026', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For specimen tube
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For specimen tube

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1022_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For specimen tube

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1022_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1022_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For specimen tube

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1022_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1022', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1022_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1022', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For specimen tube including volume in ml
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For specimen tube including volume

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1024_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For specimen tube including volume

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1024_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1024_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For specimen tube including volume

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1024_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1024', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1024_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1024', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For specimen tissue block
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For specimen tissue block

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0011', 'CAN-024-001-000-999-0080');

-- Action: INSERT
-- Comments: For specimen tissue block

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, 
`setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-0011', 'AliquotDetail', 'sample_position_code', 'position code', '', 
'input', 'size=10', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0080', 'AliquotDetail', 'path_report_code', 'path report code', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For specimen tissue block

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1028_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For specimen tissue block

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1028_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1028_CAN-024-001-000-999-0009',
'CAN-999-999-000-999-1028_CAN-024-001-000-999-0011',
'CAN-999-999-000-999-1028_CAN-024-001-000-999-0080');

-- Action: INSERT
-- Comments: For specimen tissue block

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample position code */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-0011', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-0011', 1, 33, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* path report code code */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-0080', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-0080', 1, 32, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For tissue slide
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For tissue slide

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1029_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For tissue slide

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1029_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1029_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For tissue slide

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1029_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1029', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1029_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1029', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For tissue core
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For tissue slide

-- Action: DELETE
-- Comments: For tissue slide

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1057_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1057_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For tissue slide

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1057_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1057', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1057_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1057', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For whatman paper
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For whatman paper

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1030_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For whatman paper

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1030_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1030_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For whatman paper

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1030_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1030', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1030_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1030', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For derivative tube
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For derivative tube

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1031_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For derivative tube

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1031_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1031_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For derivative tube

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1031_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1031', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1031_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1031', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ------------------------------------------------------------------------
-- ALIQUOT : ad_der_cell_tubes_incl_ml_vol
-- ------------------------------------------------------------------------
-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For derivative tube

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1065_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1065_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For derivative tube

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1065_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1065', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1065_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1065', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- delete cell count

DELETE FROM `form_formats`
WHERE `id` IN ('CAN-999-999-000-999-1065_CAN-999-999-000-999-1239', 
'CAN-999-999-000-999-1065_CAN-999-999-000-999-1240');

-- ---------------------------------------------------------------------
-- ALIQUOT : For derivative tube including volume in ml
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For derivative tube including volume

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1032_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For derivative tube including volume

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1032_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1032_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For derivative tube including volume

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1032_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1032', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1032_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1032', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For derivative tube including volume  in ml and concentration
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For derivative tube including volume and concentration

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1033_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For derivative tube including volume and concentration

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1033_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1033_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For derivative tube including volume and concentration

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1033_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1033', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1033_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1033', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For derivative tube including volume in ul and concentration
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For derivative tube including volume and concentration

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1054_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For derivative tube including volume and concentration

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1054_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1054_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For derivative tube including volume and concentration

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1054_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1054', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1054_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1054', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For derivative cell slide
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For derivative cell slide

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-999-999-000-999-1034_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For derivative cell slide

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1034_CAN-024-001-000-999-0008',
'CAN-999-999-000-999-1034_CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For derivative cell slide

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-999-999-000-999-1034_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1034', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-999-999-000-999-1034_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1034', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For cell culture tube
-- ---------------------------------------------------------------------

-- 
-- Table - `aliquot_controls`
-- 

-- Action: DELETE
-- Comments: For cell tube including volume and cell passage number

DELETE FROM `aliquot_controls`
WHERE `id` IN ('100');

-- Action: INSERT
-- Comments: For cell tube including volume and cell passage number

INSERT INTO `aliquot_controls` ( `id` , `aliquot_type` , `status` , `form_alias` , `detail_tablename`,  `volume_unit`)
VALUES 
/* Aliquots for specimen sample */
('100', 'tube', 'active', 'ad_cell_culture_tubes', 'ad_cell_culture_tubes', 'ml');

-- 
-- Table - `sample_aliquot_control_links`
-- 

-- Action: UPDATE
-- Comments: For cell tube including volume and cell passage number

UPDATE `sample_aliquot_control_links` 
SET `aliquot_control_id` = '100'
WHERE `id` = '22';

-- 
-- Table - `forms`
-- 

-- Action: DELETE
-- Comments: For cell tube including volume and cell passage number

DELETE FROM `forms`  
WHERE `alias` = 'ad_cell_culture_tubes'
OR `id` IN ('CAN-024-001-000-999-0003');

-- Action: INSERT
-- Comments: For cell tube including volume and cell passage number

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0003', 'ad_cell_culture_tubes', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For cell tube including volume and cell passage number

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0012');

-- Action: INSERT
-- Comments: For cell tube including volume and cell passage number

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-0012', 'AliquotDetail', 'cell_passage_number', 'cell passage number', '', 
'input', 'size=6', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For cell tube including volume and cell passage number

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-024-001-000-999-0003_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For cell tube including volume and cell passage number

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-0003_CAN-024-001-000-999-0008', 
'CAN-024-001-000-999-0003_CAN-024-001-000-999-0009', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1119', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1115',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1116', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1113',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1114',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1100',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1101',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1118',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1102',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1103',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1104', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1259', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1105',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1216', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1106', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1117', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1107',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1108',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1110',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1194',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1109',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1165',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1112',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1140',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1130', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1131',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1132',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1133',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1120',
'CAN-024-001-000-999-0003_CAN-024-001-000-999-0012',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1141',
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1142', 
'CAN-024-001-000-999-0003_CAN-999-999-000-999-1143');

-- Action: INSERT
-- Comments: For cell tube including volume and cell passage number

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (for add screen) */
('CAN-024-001-000-999-0003_CAN-024-001-000-999-0008', 'CAN-024-001-000-999-0003', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-024-001-000-999-0003_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0003', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* copy previous line */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1119', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1119', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot control id - hidden field */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1115', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1115', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot type - hidden field */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1116', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1116', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection id - hidden field */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1113', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1113', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample master id - hidden field */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1114', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1114', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* barcode (for add form) */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1100', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1100', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* barcode (read only for edit form) */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1101', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* product code */
-- ('CAN-024-001-000-999-0003_CAN-999-999-000-999-1118', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1118', 0, 2, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* type */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1102', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* status */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1103', 0, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* status reason */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1104', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1104', 0, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 4, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reserve to */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1259', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1259', 0, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 4, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* use */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1105', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1105', 0, 8, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot selection label */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1216', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1216', 0, 9, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (id to select storage in 'add', 'edit' form) */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1106', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1106', 0, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 0, 0,
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (code for 'index' and 'detail' form) */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1117', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1117', 0, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* coord x */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1107', 0, 12, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* coord y */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1108', 0, 14, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage temperature */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1110', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1110', 0, 16, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage temperature unit */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1194', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1194', 0, 17, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage date */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1109', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1109', 0, 15, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot sop */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1165', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1165', 0, 19, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* notes */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1112', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1112', 0, 20, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation to storage spent time msg */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1140', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1140', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* current volume */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1130', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1130', 1, 40, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* current volume unit */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1131', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1131', 1, 41, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* initial volume */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1132', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1132', 1, 42, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* initial volume unit */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1133', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1133', 1, 43, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* tube lot number */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1120', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1120', 1, 30, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* cell passage number */
('CAN-024-001-000-999-0003_CAN-024-001-000-999-0012', 'CAN-024-001-000-999-0003', 'CAN-024-001-000-999-0012', 1, 31, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation to storage spent time days */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1141', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1141', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation to storage spent time hours */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1142', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1142', 1, 52, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation to storage spent time minutes */
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1143', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1143', 1, 53, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- 
-- Table - `form_fields_global_lookups`
-- 

-- 
-- Table - `form_validations`
--  

-- Action: DELETE
-- Comments: For cell tube including volume and cell passage number

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0012');

-- Action: INSERT
-- Comments: For cell tube including volume and cell passage number

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-024-001-000-999-0012', '/^\\d*([\\.]\\d*)?$/', 'cell passage number should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For source aliquot list
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: DELETE
-- Comments: For source aliquot list

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-0010');

-- Action: INSERT
-- Comments: For source aliquot list

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0010', 'AliquotMaster', 'aliquot_label', 'aliquot label', '', 
'input', 'size=30', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: UPDATE
-- Comments: For source aliquot list

-- UPDATE `form_formats`
-- SET `flag_add_readonly` = 1,
-- `flag_edit_readonly` = 1,
-- `flag_search_readonly` = 1,
-- `flag_datagrid_readonly` = 1
-- WHERE `id` IN ('CAN-024-001-000-999-0003_CAN-999-999-000-999-1118'); /* product code */

-- Action: DELETE
-- Comments: For source aliquot list

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1036_CAN-024-001-000-999-0009', 
'CAN-999-999-000-999-1036_CAN-024-001-000-999-0010');

-- Action: INSERT
-- Comments: For source aliquot list

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* aliquot label (read-only) */
('CAN-999-999-000-999-1036_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1036', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) for datagrid*/
('CAN-999-999-000-999-1036_CAN-024-001-000-999-0010', 'CAN-999-999-000-999-1036', 'CAN-024-001-000-999-0010', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For aliquot use list
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- QUALITY CONTROL
--
-- ---------------------------------------------------------------------

--
-- Table - `form_fields `
--

DELETE FROM `form_fields` WHERE `id` = 'CAN-024-001-000-999-0078';
INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-024-001-000-999-0078', 'QualityControl', 'chip_model', 'chip model', '', 'select', '', '', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
DELETE FROM `form_fields` WHERE `id` = 'CAN-024-001-000-999-0079';
INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-024-001-000-999-0079', 'QualityControl', 'position_into_run', '', 'position', 'input', 'size=10', '', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For quality control

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('quality_control_conclusion')
AND `value` IN ('degraded', 'partially degraded', 'very good');

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('bioanalyzer_ship_model');

-- Action: INSERT
-- Comments: For quality control

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'quality_control_conclusion', NULL , NULL , 'degraded', 'degraded', '0', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'quality_control_conclusion', NULL , NULL , 'partially degraded', 'partially degraded', '1', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'quality_control_conclusion', NULL , NULL , 'very good', 'very good', '7', 'yes',  NULL , NULL , NULL , NULL),

(NULL , 'bioanalyzer_ship_model', NULL , NULL , 'nano', 'nano', '1', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'bioanalyzer_ship_model', NULL , NULL , 'pico', 'pico', '2', 'yes',  NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For quality control

DELETE FROM `form_fields_global_lookups`
WHERE `field_id` IN ('CAN-999-999-000-999-1172')
AND `lookup_id` IN (
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_conclusion' AND `value` like 'degraded'), 
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_conclusion' AND `value` like 'partially degraded'),
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_conclusion' AND `value` like 'very good'));

DELETE FROM `form_fields_global_lookups`
WHERE `field_id` IN ('CAN-024-001-000-999-0078');

-- Action: INSERT
-- Comments: For quality control

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1172', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_conclusion' AND `value` like 'degraded')),
('CAN-999-999-000-999-1172', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_conclusion' AND `value` like 'partially degraded')),
('CAN-999-999-000-999-1172', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_conclusion' AND `value` like 'very good')),

('CAN-024-001-000-999-0078', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'bioanalyzer_ship_model' AND `value` like 'nano')),
('CAN-024-001-000-999-0078', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'bioanalyzer_ship_model' AND `value` like 'pico'));

DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-1038_CAN-024-001-000-999-0078';
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1038_CAN-024-001-000-999-0078', 'CAN-999-999-000-999-1038', 'CAN-024-001-000-999-0078', '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-1038_CAN-024-001-000-999-0079';
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1038_CAN-024-001-000-999-0079', 'CAN-999-999-000-999-1038', 'CAN-024-001-000-999-0079', '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- COLLECTION REVIEW & ALIQUOT REVIEW
--
-- ---------------------------------------------------------------------

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`id` IN ('inv_CAN_65' ,'inv_CAN_64' ,'inv_CAN_23' ,'inv_CAN_15');

-- ---------------------------------------------------------------------
--
-- CONTROLS DATA
--
-- ---------------------------------------------------------------------

/* Ascite Aliquot */

UPDATE `sample_aliquot_control_links` 
SET `status` = 'inactive'
WHERE `id` = '1'
AND`sample_control_id` = '1'
AND `aliquot_control_id` = '2';

/* peritoneal wash */

UPDATE `sample_aliquot_control_links` 
SET `status` = 'inactive'
WHERE `id` = '30'
AND`sample_control_id` = '103'
AND `aliquot_control_id` = '2';

/* cystic fluid */

UPDATE `sample_aliquot_control_links` 
SET `status` = 'inactive'
WHERE `id` = '31'
AND`sample_control_id` = '104'
AND `aliquot_control_id` = '2';

/* other fluid */

UPDATE `sample_aliquot_control_links` 
SET `status` = 'inactive'
WHERE `id` = '32'
AND`sample_control_id` = '105';

-- ---------------------------------------------------------------------
-- CTRApp - inventory management - Temporary Quebec Customization
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- SAMPLE
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- SAMPLE : For tissue specimens
-- ---------------------------------------------------------------------

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_fields`   
WHERE `id` IN ('CAN-024-001-000-999-tmp001', 'CAN-024-001-000-999-tmp002');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-tmp001', 'SampleDetail', 'tmp_buffer_use', 'tmp buffer use', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp002', 'SampleDetail', 'tmp_on_ice', 'tmp on ice', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1008_CAN-024-001-000-999-tmp001',
'CAN-999-999-000-999-1008_CAN-024-001-000-999-tmp002');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* buffer use */
('CAN-999-999-000-999-1008_CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1008', 'CAN-024-001-000-999-tmp001', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* on ice */
('CAN-999-999-000-999-1008_CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1008', 'CAN-024-001-000-999-tmp002', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp001', 'CAN-024-001-000-999-tmp002');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp001', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-tmp001', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no')),

('CAN-024-001-000-999-tmp002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-tmp002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

-- ---------------------------------------------------------------------
-- SAMPLE : For pbmc
-- ---------------------------------------------------------------------

UPDATE `sample_controls` 
SET `detail_tablename` = 'sd_der_pbmcs'
WHERE `sample_type` = 'pbmc';

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp020');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp020', 'SampleDetail', 'tmp_solution', 'tmp blood cell solution', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-1013_CAN-024-001-000-999-tmp020');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-999-999-000-999-1013_CAN-024-001-000-999-tmp020', 'CAN-999-999-000-999-1013', 'CAN-024-001-000-999-tmp020', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `global_lookups`  
WHERE `alias` IN ('blood_cell_storage_solution');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'blood_cell_storage_solution', NULL , NULL , 'DMSO + serum', 'DMSO + serum', '1', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp020');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp020', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'blood_cell_storage_solution' AND `value` like 'DMSO + serum'));

-- ---------------------------------------------------------------------
-- SAMPLE : For blood cell
-- ---------------------------------------------------------------------

UPDATE `sample_controls` 
SET `detail_tablename` = 'sd_der_blood_cells'
WHERE `sample_type` = 'blood cell';

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-1012_CAN-024-001-000-999-tmp020');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* collection_method */
('CAN-999-999-000-999-1012_CAN-024-001-000-999-tmp020', 'CAN-999-999-000-999-1012', 'CAN-024-001-000-999-tmp020', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- SAMPLE : For cell culture derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp003', 'CAN-024-001-000-999-tmp004',
'CAN-024-001-000-999-tmp005', 'CAN-024-001-000-999-tmp006', 'CAN-024-001-000-999-tmp007');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp003', 'SampleDetail', 'tmp_collection_method', 'tmp collection method', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp004', 'SampleDetail', 'tmp_hormon', 'tmp hormon', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp005', 'SampleDetail', 'tmp_solution', 'tmp culture solution', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp006', 'SampleDetail', 'tmp_percentage_of_oxygen', 'tmp percentage of oxygen', '', 
'input', 'size=10', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp007', 'SampleDetail', 'tmp_percentage_of_serum', 'tmp percentage of serum', '', 
'input', 'size=10', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp003', 
'CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp004',
'CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp005', 
'CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp006', 
'CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp007');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* collection_method */
('CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1011', 'CAN-024-001-000-999-tmp003', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* tmp_solution */
('CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp005', 'CAN-999-999-000-999-1011', 'CAN-024-001-000-999-tmp005', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* tmp_percentage_of_oxygen */
('CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp006', 'CAN-999-999-000-999-1011', 'CAN-024-001-000-999-tmp006', 1, 52, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* tmp_percentage_of_serum */
('CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp007', 'CAN-999-999-000-999-1011', 'CAN-024-001-000-999-tmp007', 1, 53, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* tmp_hormon */
('CAN-999-999-000-999-1011_CAN-024-001-000-999-tmp004', 'CAN-999-999-000-999-1011', 'CAN-024-001-000-999-tmp004', 1, 54, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('cell_collection_method', 'culture_solution', 'culture_hormone');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'cell_collection_method', NULL , NULL , 'unknown', 'unknown', '1', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'centrifugation', 'centrifugation', '2', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'collagenase', 'collagenase', '3', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'mechanic', 'mechanic', '5', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'tissue section', 'tissue section', '6', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'scratching', 'scratching', '7', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'trypsin', 'trypsin', '8', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'scissors', 'scissors', '9', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'clone', 'clone', '10', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'cell_collection_method', NULL , NULL , 'spheroides', 'spheroides', '11', 'yes',  NULL , NULL , NULL , NULL);

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'culture_solution', NULL , NULL , 'unknown', 'unknown', '1', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'culture_solution', NULL , NULL , 'OSE', 'OSE', '2', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'culture_solution', NULL , NULL , 'DMEM', 'DMEM', '3', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'culture_solution', NULL , NULL , 'CSF-C100(CHO)', 'CSF-C100(CHO)', '4', 'yes',  NULL , NULL , NULL , NULL);

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'culture_hormone', NULL , NULL , 'unknown', 'unknown', '1', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'culture_hormone', NULL , NULL , 'egf+bpe+insulin+hydrocortisone', 'egf+bpe+insulin+hydrocortisone', '2', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'culture_hormone', NULL , NULL , 'b-estradiol', 'b-estradiol', '3', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'culture_hormone', NULL , NULL , 'progesterone', 'progesterone', '4', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'culture_hormone', NULL , NULL , 'b-estradiol+progesterone', 'b-estradiol+progesterone', '5', 'yes',  NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp003', 'CAN-024-001-000-999-tmp005', 
'CAN-024-001-000-999-tmp004');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'unknown')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'centrifugation')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'collagenase')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'mechanic')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'tissue section')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'scratching')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'trypsin')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'clone')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'scissors')),
('CAN-024-001-000-999-tmp003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_collection_method' AND `value` like 'spheroides'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_solution' AND `value` like 'unknown')),
('CAN-024-001-000-999-tmp005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_solution' AND `value` like 'OSE')),
('CAN-024-001-000-999-tmp005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_solution' AND `value` like 'DMEM')),
('CAN-024-001-000-999-tmp005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_solution' AND `value` like 'CSF-C100(CHO)'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_hormone' AND `value` like 'unknown')),
('CAN-024-001-000-999-tmp004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_hormone' AND `value` like 'egf+bpe+insulin+hydrocortisone')),
('CAN-024-001-000-999-tmp004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_hormone' AND `value` like 'b-estradiol')),
('CAN-024-001-000-999-tmp004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_hormone' AND `value` like 'progesterone')),
('CAN-024-001-000-999-tmp004', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'culture_hormone' AND `value` like 'b-estradiol+progesterone'));

-- ---------------------------------------------------------------------
-- SAMPLE : For DNA derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp008', 'CAN-024-001-000-999-tmp009', 
'CAN-024-001-000-999-tmp010');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp008', 'SampleDetail', 'tmp_source_milieu', 'tmp source storage solution', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp009', 'SampleDetail', 'tmp_source_storage_method', 'tmp source storage method', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp010', 'SampleDetail', 'tmp_extraction_method', 'tmp dna extraction method', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-0001_CAN-024-001-000-999-tmp008', 
'CAN-024-001-000-999-0001_CAN-024-001-000-999-tmp009', 
'CAN-024-001-000-999-0001_CAN-024-001-000-999-tmp010');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* source storage solution */
('CAN-024-001-000-999-0001_CAN-024-001-000-999-tmp008', 'CAN-024-001-000-999-0001', 'CAN-024-001-000-999-tmp008', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source storage method */
('CAN-024-001-000-999-0001_CAN-024-001-000-999-tmp009', 'CAN-024-001-000-999-0001', 'CAN-024-001-000-999-tmp009', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* dna extraction method */
('CAN-024-001-000-999-0001_CAN-024-001-000-999-tmp010', 'CAN-024-001-000-999-0001', 'CAN-024-001-000-999-tmp010', 1, 52, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('dna_extraction_method', 'tissue_storage_method', 
'tissue_storage_solution', 'cell_storage_solution');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'dna_extraction_method', NULL , NULL , 'phenol Chloroform', 'phenol Chloroform', '1', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'dna_extraction_method', NULL , NULL , 'flexigene DNA kit', 'flexigene DNA kit', '2', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'dna_extraction_method', NULL , NULL , 'trizol and scissors', 'trizol and scissors', '5', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'dna_extraction_method', NULL , NULL , 'trizol and homogenizer', 'trizol and homogenizer', '6', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'dna_extraction_method', NULL , NULL , 'trizol', 'trizol', '3', 'yes',  NULL , NULL , NULL , NULL);

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'tissue_storage_method', NULL , NULL , 'flash freeze', 'flash freeze', '1', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'tissue_storage_method', NULL , NULL , 'none', 'none', '2', 'yes',  NULL , NULL , NULL , NULL);


INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'tissue_storage_solution', NULL , NULL , 'OCT', 'oct solution', '5', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'tissue_storage_solution', NULL , NULL , 'isopentane', 'isopentane', '6', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'tissue_storage_solution', NULL , NULL , 'isopentane + OCT', 'isopentane + oct', '7', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'tissue_storage_solution', NULL , NULL , 'none', 'none', '0', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'tissue_storage_solution', NULL , NULL , 'RNA later', 'RNA later', '8', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'tissue_storage_solution', NULL , NULL , 'paraffin', 'paraffin', '9', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'tissue_storage_solution', NULL , NULL , 'culture medium', 'culture medium', '10', 'yes', NULL , NULL , NULL , NULL);

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'cell_storage_solution', NULL , NULL , 'DMSO', 'DMSO', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'cell_storage_solution', NULL , NULL , 'serum', 'serum', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'cell_storage_solution', NULL , NULL , 'DMSO + serum', 'DMSO + serum', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'cell_storage_solution', NULL , NULL , 'trizol', 'trizol', '4', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'cell_storage_solution', NULL , NULL , 'unknown', 'unknown', '0', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'cell_storage_solution', NULL , NULL , 'cell culture medium', 'cell culture medium', '5', 'yes', NULL , NULL , NULL , NULL);
-- 
-- Table - `form_fields_global_lookups`
--  

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp010', 'CAN-024-001-000-999-tmp009');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp010', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_extraction_method' AND `value` like 'phenol Chloroform')),
('CAN-024-001-000-999-tmp010', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_extraction_method' AND `value` like 'flexigene DNA kit')),
('CAN-024-001-000-999-tmp010', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_extraction_method' AND `value` like 'trizol')),
('CAN-024-001-000-999-tmp010', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_extraction_method' AND `value` like 'trizol and homogenizer')),
('CAN-024-001-000-999-tmp010', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_extraction_method' AND `value` like 'trizol and scissors')),

('CAN-024-001-000-999-tmp009', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_method' AND `value` like 'flash freeze')),
('CAN-024-001-000-999-tmp009', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_method' AND `value` like 'none')),

('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'OCT')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'isopentane')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'isopentane + OCT')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'none')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'paraffin')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'RNA later')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'culture medium')),

('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'DMSO')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'serum')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'trizol')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'DMSO + serum')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'unknown')),
('CAN-024-001-000-999-tmp008', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'cell culture medium'));

-- ---------------------------------------------------------------------
-- SAMPLE : For RNA derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp011');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp011', 'SampleDetail', 'tmp_extraction_method', 'tmp rna extraction method', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-0002_CAN-024-001-000-999-tmp008', 
'CAN-024-001-000-999-0002_CAN-024-001-000-999-tmp009', 
'CAN-024-001-000-999-0002_CAN-024-001-000-999-tmp011');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* source storage solution */
('CAN-024-001-000-999-0002_CAN-024-001-000-999-tmp008', 'CAN-024-001-000-999-0002', 'CAN-024-001-000-999-tmp008', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source storage method */
('CAN-024-001-000-999-0002_CAN-024-001-000-999-tmp009', 'CAN-024-001-000-999-0002', 'CAN-024-001-000-999-tmp009', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* source storage method */
('CAN-024-001-000-999-0002_CAN-024-001-000-999-tmp011', 'CAN-024-001-000-999-0002', 'CAN-024-001-000-999-tmp011', 1, 52, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('rna_extraction_method');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'rna_extraction_method', NULL , NULL , 'paxgene blood RNA kit', 'paxgene blood RNA kit', '1', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'rna_extraction_method', NULL , NULL , 'trizol', 'trizol', '3', 'yes',  NULL , NULL , NULL , NULL),  
(NULL , 'rna_extraction_method', NULL , NULL , 'trizol and quiagen cleanup', 'trizol and quiagen cleanup', '4', 'yes',  NULL , NULL , NULL , NULL), 
(NULL , 'rna_extraction_method', NULL , NULL , 'trizol and scissors', 'trizol and scissors', '5', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'rna_extraction_method', NULL , NULL , 'trizol and homogenizer', 'trizol and homogenizer', '6', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'rna_extraction_method', NULL , NULL , 'quiagen rneasy kit', 'quiagen rneasy kit', '2', 'yes',  NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp011');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp011', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_extraction_method' AND `value` like 'paxgene blood RNA kit')),
('CAN-024-001-000-999-tmp011', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_extraction_method' AND `value` like 'quiagen rneasy kit')),
('CAN-024-001-000-999-tmp011', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_extraction_method' AND `value` like 'trizol and homogenizer')),
('CAN-024-001-000-999-tmp011', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_extraction_method' AND `value` like 'trizol and scissors')),
('CAN-024-001-000-999-tmp011', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_extraction_method' AND `value` like 'trizol')),
('CAN-024-001-000-999-tmp011', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_extraction_method' AND `value` like 'trizol and quiagen cleanup'));

-- ---------------------------------------------------------------------
-- SAMPLE : For amplified RNA derivatives
-- ---------------------------------------------------------------------

-- 
-- Table - `sample_controls`
-- 

-- Action: UPDATE
-- Comments: For amplified RNA derivatives

UPDATE `sample_controls` 
SET `form_alias` = 'sd_der_amplified_rnas',
`detail_tablename` = 'sd_der_amplified_rnas'
WHERE `sample_type` = 'amplified rna';

-- 
-- Table - `forms`
-- 

DELETE FROM `forms`  
WHERE `alias` = 'sd_der_amplified_rnas'
OR `id` IN ('CAN-024-001-000-999-tmp001');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp001', 'sd_der_amplified_rnas', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp012', 'CAN-024-001-000-999-tmp022');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp012', 'SampleDetail', 'tmp_amplification_method', 'tmp rna amplification method', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp022', 'SampleDetail', 'tmp_amplification_number', 'tmp rna amplification number', '', 
'input', 'size=20', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1016',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1018',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1027',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1030',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1031',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1029',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1022',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1023',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1024',
'CAN-024-001-000-999-tmp001_CAN-024-001-000-999-0001',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1060',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1061',
'CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1062',
'CAN-024-001-000-999-tmp001_CAN-024-001-000-999-tmp012',
'CAN-024-001-000-999-tmp001_CAN-024-001-000-999-tmp022');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* Code */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1016', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1016', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Type */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1018', 0, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* category */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1027', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1027', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Sample SOP */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1030', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1030', 0, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Product Code */
-- ('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1031', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1031', 0, 10, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* is problematic */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1029', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1029', 0, 20, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Notes */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1022', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1022', 0, 21, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* parent sample code */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1023', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1023', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* parent sample code read only */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1024', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1024', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample label */
('CAN-024-001-000-999-tmp001_CAN-024-001-000-999-0001', 'CAN-024-001-000-999-tmp001', 'CAN-024-001-000-999-0001', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Creation site */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1060', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1060', 1, 30, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation by */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1061', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1061', 1, 31, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* creation date */
('CAN-024-001-000-999-tmp001_CAN-999-999-000-999-1062', 'CAN-024-001-000-999-tmp001', 'CAN-999-999-000-999-1062', 1, 32, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* amplification method */
('CAN-024-001-000-999-tmp001_CAN-024-001-000-999-tmp012', 'CAN-024-001-000-999-tmp001', 'CAN-024-001-000-999-tmp012', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* amplification method */
('CAN-024-001-000-999-tmp001_CAN-024-001-000-999-tmp022', 'CAN-024-001-000-999-tmp001', 'CAN-024-001-000-999-tmp022', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('rna_amplification_method');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'rna_amplification_method', NULL , NULL , 'alethia-arcturus', 'alethia-arcturus', '1', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'rna_amplification_method', NULL , NULL , 'alethia-ramp', 'alethia-ramp', '2', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'rna_amplification_method', NULL , NULL , 'unknown', 'unknown', '3', 'yes',  NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp012');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp012', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_amplification_method' AND `value` like 'alethia-arcturus')),
('CAN-024-001-000-999-tmp012', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_amplification_method' AND `value` like 'alethia-ramp')),
('CAN-024-001-000-999-tmp012', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'rna_amplification_method' AND `value` like 'unknown'));

-- ---------------------------------------------------------------------
--
-- ALIQUOT
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- ALIQUOT : For specimen tissue block
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp013', 'CAN-024-001-000-999-tmp014',
'CAN-024-001-000-999-tmp015', 'CAN-024-001-000-999-tmp016');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`)
VALUES 
('CAN-024-001-000-999-tmp013', 'AliquotDetail', 'tmp_gleason_primary_grade', 'tmp gleason score', 'primary grade', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp014', 'AliquotDetail', 'tmp_gleason_secondary_grade', '', 'secondary grade', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp015', 'AliquotDetail', 'tmp_tissue_primary_desc', 'tmp tissue description', 'primary', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp016', 'AliquotDetail', 'tmp_tissue_secondary_desc', '', 'secondary', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp013', 
'CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp014',
'CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp015', 
'CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp016');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* primary grade */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp013', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-tmp013', 1, 60, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* secondary grade */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp014', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-tmp014', 1, 61, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* primary tissue description */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp015', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-tmp015', 1, 62, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* secondary tissue description */
('CAN-999-999-000-999-1028_CAN-024-001-000-999-tmp016', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-tmp016', 1, 63, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('gleasonscore', 'block_tissue_description');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'gleasonscore', NULL , NULL , '1', '1', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'gleasonscore', NULL , NULL , '2', '2', '2', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'gleasonscore', NULL , NULL , '3', '3', '3', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'gleasonscore', NULL , NULL , '4', '4', '4', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'gleasonscore', NULL , NULL , '5', '5', '5', 'yes', NULL , NULL , NULL , NULL),

(NULL , 'block_tissue_description', NULL , NULL , 'normal', 'normal', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'block_tissue_description', NULL , NULL , 'tumor', 'tumor', '2', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'block_tissue_description', NULL , NULL , 'hyperplasia', 'hyperplasia', '3', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'block_tissue_description', NULL , NULL , 'stroma', 'stroma', '4', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'block_tissue_description', NULL , NULL , 'PIN', 'PIN', '5', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'block_tissue_description', NULL , NULL , 'HBP', 'HBP', '6', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'block_tissue_description', NULL , NULL , 'prostatitis', 'prostatitis', '7', 'yes', NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp013', 'CAN-024-001-000-999-tmp014',
'CAN-024-001-000-999-tmp015', 'CAN-024-001-000-999-tmp016');

INSERT INTO `form_fields_global_lookups` 
(`field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp013', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '1')),
('CAN-024-001-000-999-tmp013', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '2')),
('CAN-024-001-000-999-tmp013', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '3')),
('CAN-024-001-000-999-tmp013', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '4')),
('CAN-024-001-000-999-tmp013', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '5')),

('CAN-024-001-000-999-tmp014', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '1')),
('CAN-024-001-000-999-tmp014', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '2')),
('CAN-024-001-000-999-tmp014', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '3')),
('CAN-024-001-000-999-tmp014', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '4')),
('CAN-024-001-000-999-tmp014', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'gleasonscore' AND `value` like '5')),

('CAN-024-001-000-999-tmp015', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'normal')),
('CAN-024-001-000-999-tmp015', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'tumor')),
('CAN-024-001-000-999-tmp015', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'stroma')),
('CAN-024-001-000-999-tmp015', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'hyperplasia')),
('CAN-024-001-000-999-tmp015', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'PIN')),
('CAN-024-001-000-999-tmp015', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'HBP')),
('CAN-024-001-000-999-tmp015', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'prostatitis')),

('CAN-024-001-000-999-tmp016', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'PIN')),
('CAN-024-001-000-999-tmp016', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'HBP')),
('CAN-024-001-000-999-tmp016', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'prostatitis')),
('CAN-024-001-000-999-tmp016', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'normal')),
('CAN-024-001-000-999-tmp016', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'tumor')),
('CAN-024-001-000-999-tmp016', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'stroma')),
('CAN-024-001-000-999-tmp016', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'block_tissue_description' AND `value` like 'hyperplasia'));

-- ---------------------------------------------------------------------
-- ALIQUOT : For tissue tubes
-- ---------------------------------------------------------------------

-- 
-- Table - `aliquot_controls`
-- 

DELETE FROM `aliquot_controls`
WHERE `id` = '1001';

INSERT INTO `aliquot_controls` ( `id` , `aliquot_type` , `status` , `form_alias` , `detail_tablename`,  `volume_unit`)
VALUES 
('1001', 'tube', 'active', 'ad_spec_tissue_tubes', 'ad_tissue_tubes', NULL);

-- 
-- Table - `sample_aliquot_control_links`
-- 

UPDATE `sample_aliquot_control_links`
SET `aliquot_control_id` = '1001'
WHERE `id` = '4';

-- 
-- Table - `forms`
-- 

DELETE FROM `forms`  
WHERE `alias` = 'ad_spec_tissue_tubes'
OR `id` IN ('CAN-024-001-000-999-tmp002');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp002', 'ad_spec_tissue_tubes', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp017', 'CAN-024-001-000-999-tmp018');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`)
VALUES 
('CAN-024-001-000-999-tmp017', 'AliquotDetail', 'tmp_storage_solution', 'tmp storage solution', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp018', 'AliquotDetail', 'tmp_storage_method', 'tmp storage method', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1119',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1115',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1116',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1113',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1114',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1100',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1101',
'CAN-024-001-000-999-tmp002_CAN-024-001-000-999-0008',
'CAN-024-001-000-999-tmp002_CAN-024-001-000-999-0009',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1118',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1102',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1103',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1104',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1259',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1105',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1216',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1106',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1217',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1117',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1107',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1108',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1110',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1194',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1109',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1165',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1112',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1128',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1127',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1121',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1122',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1123',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1124',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1125',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1126',
'CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1120',
'CAN-024-001-000-999-tmp002_CAN-024-001-000-999-tmp017',
'CAN-024-001-000-999-tmp002_CAN-024-001-000-999-tmp018');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* copy previous line */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1119', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1119', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot control id - hidden field */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1115', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1115', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot type - hidden field */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1116', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1116', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection id - hidden field */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1113', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1113', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample master id - hidden field */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1114', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1114', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* barcode (for add form) */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1100', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1100', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* barcode (read only for edit form) */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1101', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (for add screen) */
('CAN-024-001-000-999-tmp002_CAN-024-001-000-999-0008', 'CAN-024-001-000-999-tmp002', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-024-001-000-999-tmp002_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-tmp002', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* product code */
-- ('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1118', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1118', 0, 2, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* type */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1102', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* status */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1103', 0, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* status reason */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1104', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1104', 0, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 4, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/*reserve to */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1259', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1259', 0, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 4, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* use */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1105', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1105', 0, 8, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot selection label */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1216', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1216', 0, 9, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (id to select storage in 'add', 'edit' form) */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1106', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1106', 0, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (selection label for 'index' and 'detail' form) */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1217', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1217', 0, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (code for 'index' and 'detail' form) */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1117', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1117', 0, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* coord x */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1107', 0, 12, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	
/* coord y */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1108', 0, 14, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage temperature */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1110', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1110', 0, 16, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage temperature unit */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1194', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1194', 0, 17, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage date */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1109', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1109', 0, 15, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot sop */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1165', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1165', 0, 19, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* notes */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1112', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1112', 0, 20, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time msg */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1128', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1128', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time days */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1127', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1127', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time hours */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1121', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1121', 1, 52, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time minutes */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1122', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1122', 1, 53, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time msg */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1123', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1123', 1, 54, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time days */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1124', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1124', 1, 55, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time hours */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1125', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1125', 1, 56, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time minutes */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1126', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1126', 1, 57, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* lot number */
('CAN-024-001-000-999-tmp002_CAN-999-999-000-999-1120', 'CAN-024-001-000-999-tmp002', 'CAN-999-999-000-999-1120', 1, 30, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage solution */
('CAN-024-001-000-999-tmp002_CAN-024-001-000-999-tmp017', 'CAN-024-001-000-999-tmp002', 'CAN-024-001-000-999-tmp017', 1, 60, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage method */
('CAN-024-001-000-999-tmp002_CAN-024-001-000-999-tmp018', 'CAN-024-001-000-999-tmp002', 'CAN-024-001-000-999-tmp018', 1, 61, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp017', 'CAN-024-001-000-999-tmp018');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp018', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_method' AND `value` like 'flash freeze')),
('CAN-024-001-000-999-tmp018', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_method' AND `value` like 'none')),

('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'OCT')),
('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'isopentane')),
('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'isopentane + OCT')),
('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'none')),
('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'paraffin')),
('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'RNA later')),
('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'culture medium'));

-- ---------------------------------------------------------------------
-- ALIQUOT : For tissue bags
-- ---------------------------------------------------------------------

-- 
-- Table - `aliquot_controls`
-- 

DELETE FROM `aliquot_controls`
WHERE `id` = '1002';

INSERT INTO `aliquot_controls` ( `id` , `aliquot_type` , `status` , `form_alias` , `detail_tablename`,  `volume_unit`)
VALUES 
('1002', 'bag', 'active', 'ad_spec_tissue_bags', 'ad_tissue_bags', NULL);

-- 
-- Table - `sample_aliquot_control_links`
-- 

UPDATE `sample_aliquot_control_links`
SET `aliquot_control_id` = '1002'
WHERE `id` = '5';

-- 
-- Table - `forms`
-- 

DELETE FROM `forms`  
WHERE `alias` = 'ad_spec_tissue_bags'
OR `id` IN ('CAN-024-001-000-999-tmp003');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp003', 'ad_spec_tissue_bags', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1119',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1115',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1116',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1113',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1114',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1100',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1101',
'CAN-024-001-000-999-tmp003_CAN-024-001-000-999-0008',
'CAN-024-001-000-999-tmp003_CAN-024-001-000-999-0009',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1118',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1102',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1103',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1104',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1259',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1105',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1216',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1106',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1217',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1117',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1107',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1108',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1110',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1194',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1109',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1165',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1112',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1128',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1127',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1121',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1122',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1123',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1124',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1125',
'CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1126',
'CAN-024-001-000-999-tmp003_CAN-024-001-000-999-tmp017',
'CAN-024-001-000-999-tmp003_CAN-024-001-000-999-tmp018');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* copy previous line */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1119', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1119', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot control id - hidden field */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1115', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1115', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot type - hidden field */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1116', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1116', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection id - hidden field */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1113', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1113', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* sample master id - hidden field */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1114', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1114', 0, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* barcode (for add form) */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1100', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1100', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* barcode (read only for edit form) */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1101', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (for add screen) */
('CAN-024-001-000-999-tmp003_CAN-024-001-000-999-0008', 'CAN-024-001-000-999-tmp003', 'CAN-024-001-000-999-0008', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot label (read-only) */
('CAN-024-001-000-999-tmp003_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-tmp003', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* product code */
-- ('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1118', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1118', 0, 2, 
-- '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
-- 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 
-- '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* type */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1102', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* status */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1103', 0, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* status reason */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1104', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1104', 0, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 4, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reserve to */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1259', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1259', 0, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 4, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* use */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1105', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1105', 0, 8, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot selection label */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1216', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1216', 0, 9, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (id to select storage in 'add', 'edit' form) */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1106', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1106', 0, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (selection label for 'index' and 'detail' form) */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1217', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1217', 0, 10, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage (code for 'index' and 'detail' form) */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1117', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1117', 0, 11, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* coord x */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1107', 0, 12, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	
/* coord y */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1108', 0, 14, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage temperature */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1110', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1110', 0, 16, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage temperature unit */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1194', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1194', 0, 17, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage date */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1109', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1109', 0, 15, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* aliquot sop */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1165', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1165', 0, 19, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* notes */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1112', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1112', 0, 20, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time msg */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1128', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1128', 1, 50, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time days */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1127', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1127', 1, 51, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time hours */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1121', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1121', 1, 52, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* collection to storage spent time minutes */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1122', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1122', 1, 53, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time msg */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1123', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1123', 1, 54, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time days */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1124', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1124', 1, 55, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time hours */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1125', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1125', 1, 56, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* reception to storage spent time minutes */
('CAN-024-001-000-999-tmp003_CAN-999-999-000-999-1126', 'CAN-024-001-000-999-tmp003', 'CAN-999-999-000-999-1126', 1, 57, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage solution */
('CAN-024-001-000-999-tmp003_CAN-024-001-000-999-tmp017', 'CAN-024-001-000-999-tmp003', 'CAN-024-001-000-999-tmp017', 1, 60, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* storage method */
('CAN-024-001-000-999-tmp003_CAN-024-001-000-999-tmp018', 'CAN-024-001-000-999-tmp003', 'CAN-024-001-000-999-tmp018', 1, 61, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- ALIQUOT : For cell culture tubes
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp019');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp019', 'AliquotDetail', 'tmp_storage_solution', 'tmp storage solution', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-024-001-000-999-0003_CAN-024-001-000-999-tmp019');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0003_CAN-024-001-000-999-tmp019', 'CAN-024-001-000-999-0003', 'CAN-024-001-000-999-tmp019', 1, 60, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp019');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp019', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'DMSO')),
('CAN-024-001-000-999-tmp019', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'serum')),
('CAN-024-001-000-999-tmp019', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'trizol')),
('CAN-024-001-000-999-tmp019', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'DMSO + serum')),
('CAN-024-001-000-999-tmp019', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'unknown')),
('CAN-024-001-000-999-tmp019', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'cell_storage_solution' AND `value` like 'cell culture medium'));

-- ---------------------------------------------------------------------
-- ALIQUOT : For dna rna tubes
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp021');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp021', 'AliquotDetail', 'tmp_storage_solution', 'tmp storage solution', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_formats`  
WHERE `id` IN ('CAN-999-999-000-999-1054_CAN-024-001-000-999-tmp021');

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-999-999-000-999-1054_CAN-024-001-000-999-tmp021', 'CAN-999-999-000-999-1054', 'CAN-024-001-000-999-tmp021', 1, 60, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('dna_rna_storage_solution');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'dna_rna_storage_solution', NULL , NULL , 'TE buffer', 'TE buffer', '1', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'dna_rna_storage_solution', NULL , NULL , 'H2O', 'H2O', '2', 'yes',  NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp021');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp021', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_rna_storage_solution' AND `value` like 'H2O')),
('CAN-024-001-000-999-tmp021', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_rna_storage_solution' AND `value` like 'TE buffer'));

-- ---------------------------------------------------------------------
-- CTRApp - inventory management - realiquoting/QC - Quebec Customization
-- ---------------------------------------------------------------------

/* Realiquoting */

DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-1069_CAN-024-001-000-999-0009';
INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
/* use_recorded_into_table */
('CAN-999-999-000-999-1069_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1069', 'CAN-024-001-000-999-0009', 0, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-1070_CAN-024-001-000-999-0009';
INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
/* TO DISPLAY AVAILABLE PARENT ALIQUOT DATA */
/* barcode */
('CAN-999-999-000-999-1070_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1070', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', '');

/* QC */

DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-1071_CAN-024-001-000-999-0009';
INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
/* TO DISPLAY AVAILABLE PARENT ALIQUOT DATA */
/* barcode */
('CAN-999-999-000-999-1071_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1071', 'CAN-024-001-000-999-0009', 0, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 1, 1, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- CTRApp - order 
-- ---------------------------------------------------------------------

-- Orders

DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0097', 'CAN-024-001-000-999-0098');
INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-0097', 'Order', 'type', 'type', '', 'select', '', 'NULL', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0098', 'Order', 'microarray_chip', '', 'chip', 'input', 'size=20', 'NULL', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `id` IN ('CAN-999-999-000-999-51_CAN-024-001-000-999-0097',
'CAN-999-999-000-999-51_CAN-024-001-000-999-0098');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-999-999-000-999-51_CAN-024-001-000-999-0097', 'CAN-999-999-000-999-51', 'CAN-024-001-000-999-0097', 1, 4, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-51_CAN-024-001-000-999-0098', 'CAN-999-999-000-999-51', 'CAN-024-001-000-999-0098', 1, 4, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `global_lookups` WHERE  `alias` IN ('qc_order_type');
INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_order_type', NULL , NULL , 'microarray', 'microarray', '0', 'yes',  NULL , NULL , NULL , NULL),
(NULL , 'qc_order_type', NULL , NULL , 'other', 'other', '0', 'yes',  NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups` WHERE `field_id` IN ('CAN-024-001-000-999-0097');
INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0097', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_order_type' AND `value` like 'microarray')),
('CAN-024-001-000-999-0097', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_order_type' AND `value` like 'other'));

-- Lines

DELETE FROM `form_formats` WHERE `id` IN (
'CAN-999-999-000-999-60_CAN-999-999-000-999-487',
'CAN-999-999-000-999-60_CAN-999-999-000-999-488',
'CAN-999-999-000-999-60_CAN-999-999-000-999-490',
'CAN-999-999-000-999-60_CAN-999-999-000-999-503',
'CAN-999-999-000-999-60_CAN-999-999-000-999-495',
'CAN-999-999-000-999-60_CAN-999-999-000-999-491');

-- Item

DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0099');
INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-0099', 'OrderItem', 'shipping_name', 'shipping name', '', 'input', 'size=30', 'NULL', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `id` IN ('CAN-999-999-000-999-61_CAN-024-001-000-999-0099',
'CAN-999-999-000-999-61_CAN-024-001-000-999-0009');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-999-999-000-999-61_CAN-024-001-000-999-0099', 'CAN-999-999-000-999-61', 'CAN-024-001-000-999-0099', 1, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-61_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-61', 'CAN-024-001-000-999-0009', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `form_fields` 
SET `type` = 'select',
`setting` = '' 
WHERE `form_fields`.`id`  = 'CAN-999-999-000-999-499' ;

DELETE FROM `form_fields_global_lookups`
WHERE `field_id`  IN ('CAN-999-999-000-999-499');
INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'inconnue')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'lise portelance')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'chantale auger')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jason madore')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jennifer kendall dupont')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'julie desgagnes')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'karine normandin')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'isabelle letourneau')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'josh levin')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'liliane meunier')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'manon de ladurantaye')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'aurore pierrard')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'magdalena zietarska')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'nathalie delvoye')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'patrick kibangou bondza')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'urszula krzemien')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'valerie forest')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique barres')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'labo externe')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'pathologie')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'christine abaji')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'Elsa ')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'emilio, johanne et phil')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'hafida lounis')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jessica godin ethier')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'kevin gu')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'louise champoux')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-andree forget')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-josee milot')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-line puiffe')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marise roy')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'matthew starek')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'mona alam')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'stephanie lepage')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique ouellet')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'yuan chang')),
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'autre'));

-- shipment

DELETE FROM `form_formats` WHERE `id` IN ('CAN-999-999-000-999-1068_CAN-024-001-000-999-0009');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-999-999-000-999-1068_CAN-024-001-000-999-0009', 'CAN-999-999-000-999-1068', 'CAN-024-001-000-999-0009', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `form_fields` 
SET `type` = 'select',
`setting` = '' 
WHERE `form_fields`.`id`  = 'CAN-999-999-000-999-514' ;

DELETE FROM `form_fields_global_lookups`
WHERE `field_id`  IN ('CAN-999-999-000-999-514');
INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'inconnue')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'lise portelance')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'chantale auger')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jason madore')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jennifer kendall dupont')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'julie desgagnes')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'karine normandin')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'isabelle letourneau')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'josh levin')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'liliane meunier')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'manon de ladurantaye')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'aurore pierrard')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'magdalena zietarska')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'nathalie delvoye')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'patrick kibangou bondza')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'urszula krzemien')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'valerie forest')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique barres')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'labo externe')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'pathologie')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'christine abaji')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'Elsa ')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'emilio, johanne et phil')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'hafida lounis')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jessica godin ethier')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'kevin gu')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'louise champoux')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-andree forget')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-josee milot')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-line puiffe')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marise roy')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'matthew starek')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'mona alam')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'stephanie lepage')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique ouellet')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'yuan chang')),
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'autre'));

-- ---------------------------------------------------------------------
-- CTRApp - administration
-- ---------------------------------------------------------------------

DELETE FROM `banks`;

INSERT INTO `banks` 
(`id`, `name`, `description`, `created`, `modified`) 
VALUES 
(1, 'Admin', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(2, 'Breast', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(3, 'Ovary', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(4, 'Prostate', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00');


DELETE FROM `groups`;

INSERT INTO `groups` 
(`id`, `bank_id`, `name`, `level`, `redirect`, `perm_type`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES 
(1, 1, 'System Admin', 200, '/menus', 'deny', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(2, 2, 'Technician', 200, '/menus', 'deny', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(3, 3, 'Technician', 200, '/menus', 'deny', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(4, 4, 'Technician', 200, '/menus', 'deny', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(5, 1, 'Admin', 200, '/menus', 'deny', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(6, 1, 'Migration', 200, '/menus', 'deny', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


DELETE FROM `groups_permissions`;

INSERT INTO `groups_permissions` (`group_id`, `permission_id`) 
VALUES 
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('administrate'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('clinicalannotation'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('customize'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('datamart'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('drug'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('errors'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('inventorymanagement'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('material'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('menus'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('order'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('pages'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('protocol'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbform'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbtools'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('sidebars'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('sop'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('storagelayout'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('study'))),
(1, (SELECT `id` FROM `permissions` WHERE `name` IN ('users')));

INSERT INTO `groups_permissions` 
(`group_id`, `permission_id`) 
VALUES 
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('administrate'))),
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('customize'))),
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('errors'))),
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('menus'))),
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('pages'))),
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbtools'))),
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('sidebars'))),
(5, (SELECT `id` FROM `permissions` WHERE `name` IN ('users')));

INSERT INTO `groups_permissions` 
(`group_id`, `permission_id`) 
VALUES 
-- (2, (SELECT `id` FROM `permissions` WHERE `name` IN ('administrate'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('clinicalannotation'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('customize'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('datamart'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('drug'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('errors'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('inventorymanagement'))),
-- (2, (SELECT `id` FROM `permissions` WHERE `name` IN ('material'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('menus'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('order'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('pages'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('protocol'))),
-- (2, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbform'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbtools'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('sidebars'))),
-- (2, (SELECT `id` FROM `permissions` WHERE `name` IN ('sop'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('storagelayout'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('study'))),
(2, (SELECT `id` FROM `permissions` WHERE `name` IN ('users')));

INSERT INTO `groups_permissions` 
(`group_id`, `permission_id`) 
VALUES 
-- (3, (SELECT `id` FROM `permissions` WHERE `name` IN ('administrate'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('clinicalannotation'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('customize'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('datamart'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('drug'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('errors'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('inventorymanagement'))),
-- (3, (SELECT `id` FROM `permissions` WHERE `name` IN ('material'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('menus'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('order'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('pages'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('protocol'))),
-- (3, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbform'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbtools'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('sidebars'))),
-- (3, (SELECT `id` FROM `permissions` WHERE `name` IN ('sop'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('storagelayout'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('study'))),
(3, (SELECT `id` FROM `permissions` WHERE `name` IN ('users')));

INSERT INTO `groups_permissions` 
(`group_id`, `permission_id`) 
VALUES 
-- (4, (SELECT `id` FROM `permissions` WHERE `name` IN ('administrate'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('clinicalannotation'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('customize'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('datamart'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('drug'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('errors'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('inventorymanagement'))),
-- (4, (SELECT `id` FROM `permissions` WHERE `name` IN ('material'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('menus'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('order'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('pages'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('protocol'))),
-- (4, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbform'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('rtbtools'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('sidebars'))),
-- (4, (SELECT `id` FROM `permissions` WHERE `name` IN ('sop'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('storagelayout'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('study'))),
(4, (SELECT `id` FROM `permissions` WHERE `name` IN ('users')));

DELETE FROM `users`;

INSERT INTO `users` 
(`id`, `username`, `first_name`, `last_name`, `passwd`, 
`email`, `department`, `job_title`, `institution`, `laboratory`, `help_visible`, `street`, `city`, `region`, `country`, `mail_code`, `phone_work`, `phone_home`, 
`lang`, `pagination`, `last_visit`, `group_id`, `active`, `created`, `modified`) 
VALUES 
(1, 'NicoFr', 'Nicolas', 'Luc', '0ad07cfe52905f3e71193d457c702193', 
'', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'fr', 20, '0000-00-00 00:00:00', 1, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(2, 'NicoEn', 'Nicolas', 'Luc', '0ad07cfe52905f3e71193d457c702193', 
'', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 1, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(3, 'ManonAdmin', 'Manon', 'Admin', '6f8872887ba08477d9301fb340212b81', 
'', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 5, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(9, 'Migration', 'Migration', 'Process', '0ad07cfe52905f3e71193d457c702193', 
'', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 6, 0, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),

(4, 'UrszulaK', 'Urszula', 'Krzemien', 'f344980578dbc368444ef46973503554', 
'urszula.krzemien@crchum.qc.ca', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 2, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),

(5, 'ManonL', 'Manon', 'De Ladurantaye', '6f8872887ba08477d9301fb340212b81', 
'madel13@yahoo.com', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 3, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(6, 'LiseP', 'Lise', 'Portelance', 'bc3a34dd14b4c4ef6a3ffdd83108f6f2', 
'liseportelance@yahoo.ca', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 3, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(10, 'JennK', 'Jennifer', 'Kendall-Dupont', '3b5aed19be2bf4c6c4fd43cb5dc157b3', 
'c', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 3, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),

(7, 'AuroreP', 'Aurore', 'Pierrard', '60b411bcf9d0f3ae111f84748c49f71d', 
'', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 4, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(8, 'ChantaleA', 'Chantale', 'Auger', '54793ab3a37ce1d4f7dffa151dda27b3', 
'chantaleauger12@yahoo.com', '', '', '', '', 'yes', '', '', '', '', '', '', '', 
'en', 20, '0000-00-00 00:00:00', 4, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00');

DELETE FROM `announcements`;

-- ---------------------------------------------------------------------
-- CTRApp - drug and protocol 
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- DRUG
--
-- ---------------------------------------------------------------------

-- 
-- Table - `form_fields`
-- 

-- Action: UPDATE
-- Comments: For drug

UPDATE `form_fields` 
SET `setting` = 'size=30'
WHERE `form_fields`.`id` IN 
('AAA-000-000-000-000-32');	/* generci name */

-- 
-- Table - `global_lookups`
-- 

-- Action: DELETE
-- Comments: For drug

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_drug_type');

-- Action: INSERT
-- Comments: For drug

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_drug_type', NULL , NULL , 'chemotherapy', 'chemotherapy', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_drug_type', NULL , NULL , 'drug', 'drug', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_drug_type', NULL , NULL , 'hormonotherapy', 'hormonotherapy', '3', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_drug_type', NULL , NULL , 'immunotherapy', 'immunotherapy', '4', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_drug_type', NULL , NULL , 'growth factor therapy', 'growth factor therapy', '5', 'yes', NULL , NULL , NULL , NULL);

-- 
-- Table - `form_fields_global_lookups`
-- 

-- Action: DELETE
-- Comments: For drug

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('AAA-000-000-000-000-60');

-- Action: INSERT
-- Comments: For drug

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('AAA-000-000-000-000-60', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_drug_type' AND `value` like 'chemotherapy')),
('AAA-000-000-000-000-60', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_drug_type' AND `value` like 'hormonotherapy')),
('AAA-000-000-000-000-60', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_drug_type' AND `value` like 'immunotherapy')),
('AAA-000-000-000-000-60', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_drug_type' AND `value` like 'growth factor therapy')),
('AAA-000-000-000-000-60', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_drug_type' AND `value` like 'drug'));

-- ---------------------------------------------------------------------
--
-- PROTOCOL
--
-- ---------------------------------------------------------------------

-- 
-- Table - `protocol_controls`
-- 

-- Action: DELETE
-- Comments: For protocol

DELETE FROM `protocol_controls`;

-- Action: INSERT
-- Comments: For protocol

INSERT INTO `protocol_controls` 
(`id`, `tumour_group`, `type`, 
`detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
(1 , 'all', 'chemotherapy', 
'pd_undetailled_protocols', 'pd_undetailled_protocols', 'pe_undetailled_protocols', 'pe_undetailled_protocols', 
'0000-00-00', '', '0000-00-00', '');

-- 
-- Table - `forms`
-- 

-- Action: DELETE
-- Comments: For protocol

DELETE FROM `forms`  
WHERE `alias` = 'pd_undetailled_protocols'
OR `id` IN ('CAN-024-001-000-999-0008');

DELETE FROM `forms`  
WHERE `alias` = 'pe_undetailled_protocols'
OR `id` IN ('CAN-024-001-000-999-0009');

-- Action: INSERT
-- Comments: For protocol

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0008', 'pd_undetailled_protocols', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0009', 'pe_undetailled_protocols', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_formats`
-- 

-- Action: DELETE
-- Comments: For identification

DELETE FROM `form_formats`  
WHERE `form_id` IN ('CAN-024-001-000-999-0008', 'CAN-024-001-000-999-0009');

DELETE FROM `form_formats`  
WHERE `id` IN (
'CAN-999-999-000-999-39_CAN-999-999-000-999-301', 
'CAN-999-999-000-999-39_CAN-999-999-000-999-303');

-- Action: INSERT
-- Comments: For identification

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, 
`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, 
`flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* name */
('CAN-024-001-000-999-0008_CAN-999-999-000-999-300', 'CAN-024-001-000-999-0008', 'CAN-999-999-000-999-300', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* code */
('CAN-024-001-000-999-0008_CAN-999-999-000-999-302', 'CAN-024-001-000-999-0008', 'CAN-999-999-000-999-302', 1, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* tumour_group */
('CAN-024-001-000-999-0008_CAN-999-999-000-999-304', 'CAN-024-001-000-999-0008', 'CAN-999-999-000-999-304', 1, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* type */
('CAN-024-001-000-999-0008_CAN-999-999-000-999-305', 'CAN-024-001-000-999-0008', 'CAN-999-999-000-999-305', 1, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* notes */
('CAN-024-001-000-999-0008_CAN-999-999-000-999-301', 'CAN-024-001-000-999-0008', 'CAN-999-999-000-999-301', 1, 99, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* drug */
('CAN-024-001-000-999-0009_CAN-999-999-000-999-311', 'CAN-024-001-000-999-0009', 'CAN-999-999-000-999-311', 1, 0, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
--
-- STUDY
--
-- ---------------------------------------------------------------------

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`use_link` like '/study/study_investigators/%';

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`use_link` like '/study/study_reviews/%';

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`use_link` like '/study/study_ethicsboards/%';

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`use_link` like '/study/study_fundings/%';

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`use_link` like '/study/study_results/%';

UPDATE `menus`
SET `use_link` = '/unknown/'
WHERE `menus`.`use_link` like '/study/study_related/%';

DELETE FROM `form_formats` WHERE `form_id` = 'CAN-999-999-000-999-52';

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, 
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* Study name */
('CAN-999-999-000-999-52_CAN-999-999-000-999-368', 'CAN-999-999-000-999-52', 'CAN-999-999-000-999-368', 1, 1, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- CTRApp - storage management 
-- ---------------------------------------------------------------------

-- ------------------------------------------------------------------------
-- alias = storage_aliquots_list
-- ------------------------------------------------------------------------

DELETE FROM `form_formats`
WHERE `id` IN ('CAN-999-999-000-999-1048_CAN-024-001-000-999-0008');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1048_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1048', 'CAN-024-001-000-999-0008', '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '1', '1', '0', '1', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ------------------------------------------------------------------------
-- alias = manage_storage_aliquots_without_position
-- ------------------------------------------------------------------------

DELETE FROM `form_formats`
WHERE `id` IN ('CAN-999-999-000-999-1052_CAN-024-001-000-999-0008');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-999-999-000-999-1052_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1052', 'CAN-024-001-000-999-0008', 0, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ------------------------------------------------------------------------
-- alias = std_1_dim_position_selection_for_aliquot
-- ------------------------------------------------------------------------

DELETE FROM `form_formats`
WHERE `id` IN ('CAN-999-999-000-999-1049_CAN-024-001-000-999-0008');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1049_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1049', 'CAN-024-001-000-999-0008', '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '1', '1', '0', '1', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ------------------------------------------------------------------------
-- alias = std_2_dim_position_selection_for_aliquot
-- ------------------------------------------------------------------------

DELETE FROM `form_formats`
WHERE `id` IN ('CAN-999-999-000-999-1050_CAN-024-001-000-999-0008');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1050_CAN-024-001-000-999-0008', 'CAN-999-999-000-999-1050', 'CAN-024-001-000-999-0008', '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '1', '1', '0', '1', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ---------------------------------------------------------------------
-- STORAGE CONTROL
-- ---------------------------------------------------------------------

DELETE FROM `storage_controls`
WHERE `id` IN ('100', '101', '102');

INSERT INTO `storage_controls` ( 
`id` , `storage_type`, `storage_type_code`,
`coord_x_title` , `coord_x_type` , `coord_x_size` , `coord_y_title` , `coord_y_type` , `coord_y_size` , 
`set_temperature`, `status` , `form_alias` , `form_alias_for_children_pos` , `detail_tablename`)
VALUES 
(100 , 'rack', 'RAC',
NULL, NULL, NULL, NULL, NULL, NULL,
'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', NULL, NULL),
(101 , 'box100', 'B100',
'position', 'integer', '100', NULL, NULL, NULL,
'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', NULL),
(102 , 'box27', 'B27',
'position', 'integer', '27', NULL, NULL, NULL,
'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', NULL);

DELETE FROM `global_lookups`
WHERE `alias` = 'storage_type' AND `value` IN ('rack', 'box100');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL, 'storage_type', NULL, NULL, 'rack', 'rack', '206', 'yes', NULL, NULL, NULL, NULL),
(NULL, 'storage_type', NULL, NULL, 'box100', 'box100', '153', 'yes', NULL, NULL, NULL, NULL),
(NULL, 'storage_type', NULL, NULL, 'box27', 'box27', '153', 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `lookup_id` IN (
SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` IN ('rack', 'box100'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1181', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` like 'rack')),
('CAN-999-999-000-999-1181', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` like 'box100')),
('CAN-999-999-000-999-1181', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` like 'box27'));

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: AFTER PROD
--
-- ------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- FIDES external clinic -------------------------------------------------------------------------

DELETE FROM `i18n`  
WHERE `id` = 'clinicalannotation_module_description';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('clinicalannotation_module_description', 'global', 'To describe...', '&Agrave; d&eacute;crire...');

DELETE FROM `i18n`  
WHERE `id` IN (
'2008-10-02', 
'2008-09-24', 
'2008-06-26', 
'2008-06-23', 
'2008-03-23', 
'2008-05-04', 
'2008-04-05',
'2008-03-26');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('2008-10-02', 'global', '2008-10-02', '2008-10-02'),
('2008-09-24', 'global', '2008-09-24', '2008-09-24'),
('2008-06-26', 'global', '2008-06-26', '2008-06-26'),
('2008-06-23', 'global', '2008-06-23', '2008-06-23'),
('2008-03-23', 'global', '2008-03-23', '2008-03-23'),
('2008-05-04', 'global', '2008-05-04', '2008-05-04'),
('2008-04-05', 'global', '2008-04-05', '2008-04-05'),
('2008-03-26', 'global', '2008-03-26', '2008-03-26');

DELETE FROM `i18n`  
WHERE `id` IN (
'stade figo');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('stade figo', 'global', 'Figo', 'Figo');

-- -----------------------------------------------------------------------------------------------------------------
-- Paritcipant Message - change due date to datetime ---------------------------------------------------------------

ALTER TABLE `participant_messages` 
CHANGE `due_date` `due_date` DATETIME default NULL;

UPDATE `form_formats` 
SET `default` = 'NULL', `flag_override_default` = '1'
WHERE `form_formats`.`id` = 'CAN-999-999-000-999-9_CAN-999-999-000-999-113';

UPDATE `form_formats` 
SET `default` = 'NULL', `flag_override_default` = '1'
WHERE `form_formats`.`id` = 'CAN-999-999-000-999-9_CAN-999-999-000-999-115';

UPDATE `form_fields` 
SET `type` = 'datetime' 
WHERE `form_fields`.`id` = 'CAN-999-999-000-999-115';

-- -----------------------------------------------------------------------------------------------------------------
-- Procure Code Barre - Management by the system -------------------------------------------------------------------

DELETE FROM `part_bank_nbr_counters` WHERE `bank_ident_title` = 'code-barre';

INSERT INTO `part_bank_nbr_counters` (`id`, `bank_ident_title`, `last_nbr`) VALUES 
(NULL, 'code-barre', '267');

-- -----------------------------------------------------------------------------------------------------------------
-- SARDO Morpho desciption -------------------------------------------------------------------

ALTER TABLE `diagnoses` 
ADD `sardo_morpho_desc` VARCHAR( 200 ) NULL AFTER `morphology`;

UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénocarcinome papillaire séreux' WHERE morphology ='8460/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome lobulaire' WHERE morphology ='8520/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénocarcinome séreux' WHERE morphology ='8441/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome papillaire intracanalaire avec invasion' WHERE morphology ='8503/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome � cellules claires' WHERE morphology ='8310/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome endométrioïde' WHERE morphology ='8380/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome papillaire séreux de surface' WHERE morphology ='8461/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome � cellules mixtes' WHERE morphology ='8323/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénocarcinome mucineux' WHERE morphology ='8470/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénome séreux' WHERE morphology ='8441/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénome mucineux' WHERE morphology ='8470/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome canalaire in situ, solide' WHERE morphology ='8230/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénome' WHERE morphology ='8440/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome métastatique' WHERE morphology ='8140/6';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome mucipare' WHERE morphology ='8481/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénome séreux, � la limite de la malignité' WHERE morphology ='8442/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénome papillaire séreux, � la limite de la malignité' WHERE morphology ='8460/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénocarcinome papillaire' WHERE morphology ='8450/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur kystique mucineuse � la limite de la malignité' WHERE morphology ='8472/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur papillaire séreuse de surface, � la limite de la malignité' WHERE morphology ='8463/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome canalaire infiltrant' WHERE morphology ='8500/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénofibrome mucineux � la limite de la malignité' WHERE morphology ='9015/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur kystique papillaire séreuse � la limite de la malignité' WHERE morphology ='8462/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome' WHERE morphology ='8140/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur bénigne' WHERE morphology ='8000/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome épidermoïde micro-invasif' WHERE morphology ='8076/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénofibrome séreux' WHERE morphology ='9014/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Léiomyome' WHERE morphology ='8890/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénofibrome séreux � la limite de la malignité' WHERE morphology ='9014/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur de Brenner' WHERE morphology ='9000/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome endométrioïde � la limite de la malignité' WHERE morphology ='8380/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome canalaire infiltrant et carcinome lobulaire' WHERE morphology ='8522/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Maladie de Bowen' WHERE morphology ='8081/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome mucineux' WHERE morphology ='8480/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome pseudo-sarcomateux' WHERE morphology ='8033/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénofibrome mucineux' WHERE morphology ='9015/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur maligne' WHERE morphology ='8000/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome in situ' WHERE morphology ='8140/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Tératome bénin' WHERE morphology ='9080/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénofibrome' WHERE morphology ='9013/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Liposarcome � cellules rondes' WHERE morphology ='8853/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur phyllode maligne' WHERE morphology ='9020/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur � cellules de Sertoli-Leydig, de différenciation intermédiaire' WHERE morphology ='8631/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome tubulaire' WHERE morphology ='8211/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome épidermoïde in situ' WHERE morphology ='8070/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Tératome malin' WHERE morphology ='9080/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome papillaire' WHERE morphology ='8050/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tératome' WHERE morphology ='9080/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome lobulaire in situ' WHERE morphology ='8520/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Fibrome' WHERE morphology ='8810/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinosarcome' WHERE morphology ='8980/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Syringofibroadénome' WHERE morphology ='8392/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Sarcome du stroma endométrial' WHERE morphology ='8930/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome de type endocervical' WHERE morphology ='8384/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Epithélioma malin' WHERE morphology ='8011/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome in situ' WHERE morphology ='8010/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome tubulaire' WHERE morphology ='8211/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome épidermoïde' WHERE morphology ='8070/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Papillome intracanalaire' WHERE morphology ='8503/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome basocellulaire' WHERE morphology ='8090/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome avec métaplasie malpighienne' WHERE morphology ='8570/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Papillome séreux de surface' WHERE morphology ='8461/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome épidermoïde � grandes cellules, non kératinisant' WHERE morphology ='8072/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome adénosquameux' WHERE morphology ='8560/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénome papillaire séreux' WHERE morphology ='8460/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénosarcome' WHERE morphology ='8933/3';

UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur carcinoïde atypique' WHERE morphology ='8249/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome neuro-endocrinien' WHERE morphology ='8246/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur métastatique' WHERE morphology ='8000/6';
UPDATE diagnoses SET sardo_morpho_desc = 'Pseudomyxome du péritoine' WHERE morphology ='8480/6';
UPDATE diagnoses SET sardo_morpho_desc = 'Léiomyome épithélioïde' WHERE morphology ='8891/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome mucineux' WHERE morphology ='8480/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome' WHERE morphology ='8140/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Kyste dermoïde' WHERE morphology ='9084/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur de la granulosa chez l''adulte' WHERE morphology ='8620/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Néoplasie épidermoïde intra-épithéliale de grade III' WHERE morphology ='8077/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Lipome' WHERE morphology ='8850/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur mixte mésodermique' WHERE morphology ='8951/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome métastatique' WHERE morphology ='8010/6';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome papillaire intracanalaire non infiltrant' WHERE morphology ='8503/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Polype adénomateux' WHERE morphology ='8210/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome métanéphrique' WHERE morphology ='8325/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome papillaire' WHERE morphology ='8260/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur des cordons sexuels et du stroma gonadique' WHERE morphology ='8590/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Tératome avec transformation maligne' WHERE morphology ='9084/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Lymphome malin lymphoplasmocytaire' WHERE morphology ='9671/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur mixte � cellules germinales' WHERE morphology ='9085/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Dysgerminome' WHERE morphology ='9060/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome mucineux, de type endocervical' WHERE morphology ='8482/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur de bénignité ou de malignité non assurée' WHERE morphology ='8000/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Hibernome' WHERE morphology ='8880/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome hépatoïde' WHERE morphology ='8576/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome bronchio-alvéolaire' WHERE morphology ='8250/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur carcinoïde' WHERE morphology ='8240/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Myo-épithéliome' WHERE morphology ='8982/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur mixte M�llerienne' WHERE morphology ='8950/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome transitionnel' WHERE morphology ='8120/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur de Brenner � la limite de la malignité' WHERE morphology ='9000/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinofibrome séreux' WHERE morphology ='9014/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Mésothéliome multikystique, bénin' WHERE morphology ='9055/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Angiomyolipome' WHERE morphology ='8860/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome lobulaire infiltrant avec carcinomes d''autres types' WHERE morphology ='8524/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome anaplasique' WHERE morphology ='8021/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Fibro-adénome' WHERE morphology ='9010/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome transitionnel papillaire' WHERE morphology ='8130/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Maladie de Paget et carcinome canalaire infiltrant du sein' WHERE morphology ='8541/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome � cellules en bague � chaton' WHERE morphology ='8490/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome en dents de scie' WHERE morphology ='8213/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome de type intestinal' WHERE morphology ='8144/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinomatose' WHERE morphology ='8010/9';
UPDATE diagnoses SET sardo_morpho_desc = 'Fibrome cellulaire' WHERE morphology ='8810/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur adénocarcinoïde' WHERE morphology ='8245/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénomyome' WHERE morphology ='8932/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome non � petites cellules' WHERE morphology ='8046/3';

UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome métastatique � cellules en bague � chaton' WHERE morphology ='8490/6';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur de Brenner maligne' WHERE morphology ='9000/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome indifférencié' WHERE morphology ='8020/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Sarcome endométrial stromal, de bas grade' WHERE morphology ='8931/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome basocellulaire infiltrant' WHERE morphology ='8092/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinoïde strumeux' WHERE morphology ='9091/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Sarcome stromal gastrointestinale' WHERE morphology ='8936/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Naevus jonctionel' WHERE morphology ='8740/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome canalaire infiltrant avec carcinomes d''autres types' WHERE morphology ='8523/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Lymphome malin' WHERE morphology ='9590/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Leucémie myéloïde chronique' WHERE morphology ='9863/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Goitre ovarien' WHERE morphology ='9090/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Sarcome' WHERE morphology ='8800/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Mésothéliome kystique' WHERE morphology ='9055/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Thécome' WHERE morphology ='8600/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur stromale' WHERE morphology ='8935/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Léiomyome bizarre' WHERE morphology ='8893/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur desmoplasique, � petites cellules rondes' WHERE morphology ='8806/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur maligne de la granulosa' WHERE morphology ='8620/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome épidermoïde métastatique' WHERE morphology ='8070/6';
UPDATE diagnoses SET sardo_morpho_desc = 'Hémangiosarcome' WHERE morphology ='9120/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome épidermoïde basaloïde' WHERE morphology ='8083/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome � cellules mixtes' WHERE morphology ='8323/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Mélanome in situ' WHERE morphology ='8720/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Mésonéphrome bénin' WHERE morphology ='9110/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome de type endocervical in situ' WHERE morphology ='8384/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome' WHERE morphology ='8010/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome intracanalaire non infiltrant' WHERE morphology ='8500/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome médullaire atypique' WHERE morphology ='8513/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Léiomyosarcome' WHERE morphology ='8890/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome cribriforme, in situ' WHERE morphology ='8201/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome sur polype adénomateux' WHERE morphology ='8210/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cholangiocarcinome' WHERE morphology ='8160/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome épidermoïde kératinisant' WHERE morphology ='8071/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome solide' WHERE morphology ='8230/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome neuroendocrinien � grandes cellules' WHERE morphology ='8013/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome médullaire' WHERE morphology ='8510/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome � petites cellules' WHERE morphology ='8041/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome canaliculaire infiltrant' WHERE morphology ='8521/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome intrakystique' WHERE morphology ='8504/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome cribriforme' WHERE morphology ='8201/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénocarcinome' WHERE morphology ='8440/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Lymphome folliculaire de grade 1' WHERE morphology ='9695/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Lymphome de Hodgkin, � cellularité mixte' WHERE morphology ='9652/3';

UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome canalaire infiltrant micropapillaire' WHERE morphology ='8507/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Mélanome � extension superficielle in situ' WHERE morphology ='8743/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome papillaire � variante folliculaire' WHERE morphology ='8340/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur des muscles lisses de malignité non-assurée' WHERE morphology ='8897/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénome mucineux � la limite de la malignité' WHERE morphology ='8472/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome intracanalaire avec carcinomes d''autres types in situ' WHERE morphology ='8523/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénocarcinome sur adénome villeux' WHERE morphology ='8261/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome transitionnel in situ' WHERE morphology ='8120/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur du sac vitellin' WHERE morphology ='9071/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur phyllode � la limite de la malignité' WHERE morphology ='9020/1';
UPDATE diagnoses SET sardo_morpho_desc = 'Tumeur maligne des cordons sexuels et du stroma gonadique' WHERE morphology ='8590/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Cystadénocarcinome mucineux, non invasif' WHERE morphology ='8470/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Myélome multiple' WHERE morphology ='9732/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Ostéosarcome sur maladie osseuse de Paget' WHERE morphology ='9184/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome transitionnel papillaire, non invasif' WHERE morphology ='8130/2';
UPDATE diagnoses SET sardo_morpho_desc = 'Hémangiome' WHERE morphology ='9120/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Lymphome folliculaire de grade 3' WHERE morphology ='9698/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Carcinome � cellules rénales' WHERE morphology ='8312/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Adénome villeux' WHERE morphology ='8261/0';
UPDATE diagnoses SET sardo_morpho_desc = 'Neurilemmome malin' WHERE morphology ='9560/3';
UPDATE diagnoses SET sardo_morpho_desc = 'Mélanome malin' WHERE morphology ='8720/3';

DELETE FROM `form_fields` WHERE `id` = 'CAN-024-001-000-999-0114';

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0114', 'Diagnosis', 'sardo_morpho_desc', '', 'morphology sardo description', 'input', 'size=60', '', '', 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-6_CAN-024-001-000-999-0114';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-999-999-000-999-6_CAN-024-001-000-999-0114', 'CAN-999-999-000-999-6', 'CAN-024-001-000-999-0114', 1, 7, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `form_formats` SET `display_order` = '6' 
WHERE `id` = 'CAN-999-999-000-999-6_CAN-999-999-000-999-324';

DELETE FROM `i18n`  
WHERE `id` IN (
'morphology sardo description');

INSERT INTO `i18n` 
(`id`, `page_id`, `en`, `fr`) 
VALUES 
('morphology sardo description', 'global', 'Desc', 'Desc');

-- -----------------------------------------------------------------------------------------------------------------
-- i18n NoLabo -------------------------------------------------------------------

UPDATE `i18n` 
SET `en` = '''No Labo'' of Breast Bank',
`fr` = '''No Labo'' de la banque Sein' 
WHERE `id` = 'breast bank no lab'
AND `page_id` = 'global';

UPDATE `i18n` 
SET `en` = '''No Labo'' of Old Bank',
`fr` = 'Ancien ''No Labo'' de banque' 
WHERE `id` = 'old bank no lab' 
AND `page_id` = 'global';

UPDATE `i18n` 
SET `en` = '''No Labo'' of Ovary Bank',
`fr` = '''No Labo'' de la banque Ovaire' 
WHERE `id` = 'ovary bank no lab' 
AND `page_id` = 'global';

UPDATE `i18n` 
SET `en` = '''No Labo'' of Prostate Bank',
`fr` = '''No Labo'' de la banque Prostate' 
WHERE `id` = 'prostate bank no lab' 
AND `page_id` = 'global';

UPDATE `i18n` 
SET `en` = 'Participant ''No Labo''',
`fr` = '''No Labo'' du participant' 
WHERE `id` = 'bank participant identifier' 
AND `page_id` = 'global';

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- FIDES external clinic -------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE `alias` = 'qc_site_list'
AND `value` = 'FIDES external clinic';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_site_list', NULL , NULL , 'FIDES external clinic', 'FIDES external clinic', '0', 'yes', NULL , NULL , NULL , NULL); 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-999-1003'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` like 'FIDES external clinic');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` like 'FIDES external clinic'));

DELETE FROM `i18n`
WHERE `id` IN ('FIDES external clinic');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('FIDES external clinic', 'global', 'FIDES External Clinic', 'Clinique externe FIDES');

-- -----------------------------------------------------------------------------------------------------------------
-- i18n ------------------------------------------------------------------------------------------------------------

DELETE FROM `i18n`  
WHERE `id` IN (
'Labo Sein',
'jennifer kendall dupont');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('Labo Sein', 'global', 'Labo Sein', 'Labo Sein'),
('jennifer kendall dupont', 'global', 'Jennifer Kendall Dupont', 'Jennifer Kendall Dupont');

-- -----------------------------------------------------------------------------------------------------------------
-- stored_by -------------------------------------------------------------------------

DELETE FROM `form_fields` WHERE `id` = 'CAN-024-001-000-999-0107';

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0107', 'AliquotMaster', 'stored_by', 'stored by', '', 
'select', '', '', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `field_id` = 'CAN-024-001-000-999-0107';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-999-999-000-999-1037_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1037', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1026_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1026', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1022_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1022', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1024_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1024', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1028_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1028', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1029_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1029', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1030_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1030', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1031_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1031', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1032_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1032', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1033_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1033', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1034_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1034', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1054_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1054', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1063_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1063', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1064_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1064', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1065_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1065', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-1057_CAN-024-001-000-999-0107', 'CAN-999-999-000-999-1057', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0003_CAN-024-001-000-999-0107', 'CAN-024-001-000-999-0003', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp002_CAN-024-001-000-999-0107', 'CAN-024-001-000-999-tmp002', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-tmp003_CAN-024-001-000-999-0107', 'CAN-024-001-000-999-tmp003', 'CAN-024-001-000-999-0107', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields_global_lookups`
WHERE `field_id` = 'CAN-024-001-000-999-0107';

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'inconnue')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'lise portelance')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'chantale auger')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jason madore')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jennifer kendall dupont')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'julie desgagnes')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'karine normandin')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'isabelle letourneau')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'josh levin')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'liliane meunier')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'manon de ladurantaye')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'aurore pierrard')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'magdalena zietarska')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'nathalie delvoye')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'patrick kibangou bondza')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'urszula krzemien')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'valerie forest')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique barres')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'labo externe')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'pathologie')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'christine abaji')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'Elsa ')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'emilio, johanne et phil')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'hafida lounis')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jessica godin ethier')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'kevin gu')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'louise champoux')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-andree forget')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-josee milot')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-line puiffe')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marise roy')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'matthew starek')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'mona alam')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'stephanie lepage')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique ouellet')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'yuan chang')),
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'autre'));

DELETE FROM `i18n`  
WHERE `id` IN (
'stored by');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('stored by', 'global', 'Stored By', 'Entrepos&eacute; par');


-- -----------------------------------------------------------------------------------------------------------------
-- OCT + Isopentane bloc -------------------------------------------------------------------------

DELETE FROM `form_fields_global_lookups`
WHERE `field_id` = 'CAN-999-999-000-999-1135'
AND `lookup_id` IN (
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'isopentane + OCT'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1135', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'isopentane + OCT'));

-- -----------------------------------------------------------------------------------------------------------------
-- supplier dept:  -------------------------------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE `alias` = 'qc_supplier_dept'
AND `value` = 'day surgery';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_supplier_dept', NULL , NULL , 'day surgery', 'day surgery', '6', 'yes', NULL , NULL , NULL , NULL); 

DELETE FROM `form_fields_global_lookups`
WHERE `field_id` = 'CAN-999-999-000-999-1032'
AND `lookup_id` IN (
(SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'day surgery'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1032', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_supplier_dept' AND `value` like 'day surgery'));

DELETE FROM `i18n`  
WHERE `id` IN (
'day surgery');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('day surgery', 'global', 'Day Surgery', 'Chirurgie d''un jour');

-- -----------------------------------------------------------------------------------------------------------------
-- change_aliquot_position_in_batch -------------------------------------------------------------------------

DELETE FROM `forms` WHERE `id` = 'CAN-024-001-000-999-0028';

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0028', 'change_aliquot_position_in_batch', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0110', 'CAN-024-001-000-999-0111',
'CAN-024-001-000-999-0112');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0110', 'FunctionManagement', 'additional_field_increment_coord_x', 'incremental coord x', '', 'checklist', '', '', '', 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0111', 'FunctionManagement', 'additional_field_increment_coord_y', 'incremental coord y', '', 'checklist', '', '', '', 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0112', 'FunctionManagement', 'copy_storage_only', 'copy storage only', '', 'checklist', '', '', '', 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields_global_lookups` 
WHERE `field_id` IN ('CAN-024-001-000-999-0110', 'CAN-024-001-000-999-0111',
'CAN-024-001-000-999-0112');

INSERT INTO `form_fields_global_lookups` ( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0110', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')), 
('CAN-024-001-000-999-0111', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')), 
('CAN-024-001-000-999-0112', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes'));

DELETE FROM `form_formats` WHERE `form_id` = 'CAN-024-001-000-999-0028';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* FunctionManagement.generated_field_copy_prev_line */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1119', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1119', 0, 8, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- /* AliquotMaster.label */
-- ('CAN-024-001-000-999-0028_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0028', 'CAN-024-001-000-999-0009', 0, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.barcode */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1101', 0, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.type */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1102', 0, 5, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.status */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1103', 0, 7, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.storage_selection_label */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1216', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1216', 0, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_master_id */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1106', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1106', 0, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1107', 0, 13, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.additional_field_increment_coord_x */
('CAN-024-001-000-999-0028_CAN-024-001-000-999-0110', 'CAN-024-001-000-999-0028', 'CAN-024-001-000-999-0110', 0, 14, '', 1, '', 1, 'incremental coord x', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1108', 0, 15, '', 0, '', 1, '-', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.additional_field_increment_coord_x */
('CAN-024-001-000-999-0028_CAN-024-001-000-999-0111', 'CAN-024-001-000-999-0028', 'CAN-024-001-000-999-0111', 0, 16, '', 1, '', 1, 'incremental coord y', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.additional_field_delete_of_storage */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1215 ', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1215 ', 0, 9, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.notes */
('CAN-024-001-000-999-0028_CAN-999-999-000-999-1112', 'CAN-024-001-000-999-0028', 'CAN-999-999-000-999-1112 ', 0, 18, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.copy_storage_only */
('CAN-024-001-000-999-0028_CAN-024-001-000-999-0112', 'CAN-024-001-000-999-0028', 'CAN-024-001-000-999-0112 ', 0, 9, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n`
WHERE `id` IN
('incremental coord x', 'incremental coord y', '-', 'copy storage only');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('-', 'global', '-', '-'),
('incremental coord x', 'global', 'Incr.', 'Incr.'),
('incremental coord y', 'global', 'Incr.', 'Incr.'),
('copy storage only', 'global', 'Copy Storage Only', 'Copier uniquement l''entreposage');

-- -----------------------------------------------------------------------------------------------------------------
-- specimen sequence validation: integer ou A, B ou C --------------------------------------------------------------

DELETE FROM `form_validations`  
WHERE `form_field_id` IN ('CAN-024-001-000-999-0003');

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-024-001-000-999-0003', '/(^[\\d]*$)|(^[ABCabc]$)/', 'sequence should be an integer or equal to character A,B or C', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` 
WHERE `id` LIKE 'sequence should be an integer%';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('sequence should be an integer or equal to character A,B or C', 'global', 'The sequence number should be a positive integer or equal to character A,B or C!', 'Le num&eacute;ro de s&eacute;quence doit &ecirc;tre un entier positif ou la lettre A,B ou C!');

-- -----------------------------------------------------------------------------------------------------------------
-- Aliquot Label Help ----------------------------------------------------------------------------------------------

UPDATE `form_fields` 
SET `language_help` = 'inv_aliquot_label_defintion' 
WHERE `form_fields`.`id` IN ('CAN-024-001-000-999-0008', 'CAN-024-001-000-999-0009',
'CAN-024-001-000-999-0010');

DELETE FROM `i18n` WHERE `id` = 'inv_aliquot_label_defintion';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('inv_aliquot_label_defintion', 
'global', 
'Readable caractere written on the aliquot.',
'Caract&egrave;res lisibles �crits sur l''aliquot.');

-- -----------------------------------------------------------------------------------------------------------------
-- no labo i18n ----------------------------------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` = 'no labo';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('no labo', 'global', 'No Labo', 'No Labo');

DELETE FROM `i18n`
WHERE `id` = 'bank participant identifier';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('bank participant identifier', 'global', 'Participant ''No Labo''', '''No Labo'' du participant');

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- QC type: Nanodrop -------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE `alias` = 'quality_control_type'
AND `value` = 'nanodrop';

INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
(NULL, 'quality_control_type', NULL, NULL, 'nanodrop', 'nanodrop', 5, 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-999-1167'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_type' AND `value` like 'nanodrop');

INSERT INTO `form_fields_global_lookups` (`field_id`, `lookup_id`) VALUES 
('CAN-999-999-000-999-1167', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_type' AND `value` like 'nanodrop'));

DELETE FROM `i18n`
WHERE `id` = 'nanodrop';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('nanodrop', 'global', 'Nanodrop', 'Nanodrop');

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- QC tool: Nanodrop -------------------------------------------------------------------------

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-999-1168'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_tool' AND `value` NOT IN ('bioanalyzer 1'));

DELETE FROM `global_lookups`  
WHERE `alias` = 'quality_control_tool'
AND value NOT IN ('bioanalyzer 1');

INSERT INTO `global_lookups` 
(`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES 
(NULL, 'quality_control_tool', NULL, NULL, 'nanodrop', 'nanodrop', 2, 'yes', NULL, NULL, NULL, NULL),
(NULL, 'quality_control_tool', NULL, NULL, 'beckman', 'beckman', 0, 'yes', NULL, NULL, NULL, NULL),
(NULL, 'quality_control_tool', NULL, NULL, 'pharmacia', 'pharmacia', 3, 'yes', NULL, NULL, NULL, NULL);

INSERT INTO `form_fields_global_lookups` (`field_id`, `lookup_id`) VALUES 
('CAN-999-999-000-999-1168', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_tool' AND `value` like 'nanodrop')),
('CAN-999-999-000-999-1168', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_tool' AND `value` like 'beckman')),
('CAN-999-999-000-999-1168', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_tool' AND `value` like 'pharmacia'));

DELETE FROM `i18n`
WHERE `id` = 'beckman';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('beckman', 'global', 'Beckman', 'Beckman');

DELETE FROM `i18n`
WHERE `id` = 'pharmacia';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('pharmacia', 'global', 'Pharmacia', 'Pharmacia');

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-999-1167'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_type' AND `value` like 'nanodrop');

DELETE FROM `global_lookups`  
WHERE `alias` = 'quality_control_type'
AND `value` = 'nanodrop';

DELETE FROM `i18n`
WHERE `id` = 'bioanalyzer 1';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('bioanalyzer 1', 'global', 'BioAnalyzer 1', 'BioAnalyzer 1');

-- -----------------------------------------------------------------------------------------------------------------
-- Add Guillaume Cardin -------------------------------------------------------------------------

DELETE FROM `i18n` WHERE `id` = 'guillaume cardin';

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('guillaume cardin', 'global', 'Guillaume Cardin', 'Guillaume Cardin');

DELETE FROM `global_lookups`  
WHERE  `alias` = 'qc_lab_people_list'
AND `value` LIKE 'guillaume cardin';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_lab_people_list', NULL , NULL , 'guillaume cardin', 'guillaume cardin', '4', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `lookup_id` = (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'guillaume cardin');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
/* Stored by */
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'guillaume cardin')),
/* Collection reception by */
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'guillaume cardin')),
/* Derivative creation by */
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'guillaume cardin')),
/* Order */
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'guillaume cardin')),
/* Shipment */
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'guillaume cardin'));

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.5
--
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.5.1
--
-- ------------------------------------------------------------------------------------------------

UPDATE `form_fields` 
SET `language_help` = 'collection_bank_participant_identifier_help' 
WHERE `form_fields`.`id` = 'CAN-024-001-000-999-0040';

DELETE FROM `i18n`
WHERE `id` IN ('collection_bank_participant_identifier_help');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('collection_bank_participant_identifier_help', 'global', 'NoLabo attached to the collection based on the collection bank and the existing ''NoLabos'' of the collection participant.', 'NoLabo attach&eacute; &agrave; la collection selon la banque de la collection et les ''NoLabos'' existant du participant de la collection.');

UPDATE `form_fields` 
SET `language_help` = 'participant_identifier_type_help' 
WHERE `form_fields`.`id` = 'CAN-999-999-000-999-34';

DELETE FROM `i18n`
WHERE `id` IN ('participant_identifier_type_help');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('participant_identifier_type_help', 'global', 'Type of the participant identifier.', 'Type de l''identifiant du participant.');

DELETE FROM `storage_controls`
WHERE `id` IN ('103');

INSERT INTO `storage_controls` ( 
`id` , `storage_type`, `storage_type_code`,
`coord_x_title` , `coord_x_type` , `coord_x_size` , 
`coord_y_title` , `coord_y_type` , `coord_y_size` , 
`set_temperature`, `status` , `form_alias` , `form_alias_for_children_pos` , `detail_tablename`)
VALUES 
(103, 'box49 1A-7G', 'B2D49', 
'column', 'integer', 7, 
'row', 'alphabetical', 7, 
'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_2_dim_position_selection', NULL);

DELETE FROM `global_lookups`
WHERE `alias` = 'storage_type' AND `value` IN ('box49 1A-7G');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL, 'storage_type', NULL, NULL, 'box49 1A-7G', 'box49 1A-7G', '153', 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `lookup_id` IN (
SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` IN ('box49 1A-7G'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1181', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` like 'box49 1A-7G'));

DELETE FROM `form_formats`
WHERE `form_id` = 'CAN-999-999-000-999-1'
AND field_id IN ('CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0117');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0116', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0116', 4, 20, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0118', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0118', 4, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0117', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0117', 4, 22, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.6.0
--
-- ------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------
-- Add Teodora Yaneva -------------------------------------------------------------------------

DELETE FROM `i18n` WHERE `id` = 'teodora yaneva';

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('teodora yaneva', 'global', 'Teodora Yaneva', 'Teodora Yaneva');

DELETE FROM `global_lookups`  
WHERE  `alias` = 'qc_lab_people_list'
AND `value` LIKE 'teodora yaneva';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_lab_people_list', NULL , NULL , 'teodora yaneva', 'teodora yaneva', '28', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `lookup_id` = (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'teodora yaneva');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
/* Stored by */
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'teodora yaneva')),
/* Collection reception by */
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'teodora yaneva')),
/* Derivative creation by */
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'teodora yaneva')),
/* Order */
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'teodora yaneva')),
/* Shipment */
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'teodora yaneva'));

-- -----------------------------------------------------------------------------------------------------------------
-- Change box49 1A-7G to box49 1-49 -------------------------------------------------------------------------

UPDATE aliquot_masters
SET storage_coord_x=NULL,
storage_coord_y=NULL
WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE storage_control_id = 103);

UPDATE storage_controls
SET storage_type = 'box49',
storage_type_code = 'B49',
coord_x_title = 'column', 
coord_x_type = 'integer', 
coord_x_size = 49, 
coord_y_title = NULL, 
coord_y_type = NULL, 
coord_y_size = NULL 
WHERE id IN ('103');

UPDATE storage_masters 
SET storage_type = 'box49'
WHERE storage_control_id = 103; 

DELETE FROM `global_lookups`
WHERE `alias` = 'storage_type' AND `value` IN ('box49 1A-7G','box49');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL, 'storage_type', NULL, NULL, 'box49', 'box49', '153', 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `lookup_id` IN (
SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` IN ('box49 1A-7G', 'box49'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1181', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'storage_type' AND `value` like 'box49'));

-- -----------------------------------------------------------------------------------------------------------------
-- Correct lab_type_laterality_match -------------------------------------------------------------------------

UPDATE sd_spe_tissues
set laterality = 'unknown'
WHERE laterality = 'unknwon';

UPDATE sd_spe_tissues
set labo_laterality = 'unknown'
WHERE labo_laterality = 'unknwon';

UPDATE sd_spe_tissues
set tissue_source = 'unknown'
WHERE tissue_source = 'inconnu';

UPDATE lab_type_laterality_match
set tissue_source_matching = 'unknown'
WHERE tissue_source_matching = 'inconnu';

UPDATE lab_type_laterality_match
set laterality_matching = 'unknown'
WHERE laterality_matching = 'unknwon';

-- -----------------------------------------------------------------------------------------------------------------
-- Add DMSO + FBS to tissue storage solution -------------------------------------------------------------------------

DELETE FROM `global_lookups`
WHERE `alias` = 'tissue_storage_solution' AND `value` IN ('DMSO + FBS');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL, 'tissue_storage_solution', NULL, NULL, 'DMSO + FBS', 'DMSO + FBS', '1', 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `lookup_id` IN (
SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` IN ('DMSO + FBS'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp017', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'tissue_storage_solution' AND `value` like 'DMSO + FBS'));

-- -----------------------------------------------------------------------------------------------------------------
-- add aliquot_status_reason = destroyed -------------------------------------------------------------------------

DELETE FROM `global_lookups`
WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'destroyed';

INSERT INTO `global_lookups` (`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(NULL, 'aliquot_status_reason', NULL, NULL, 'destroyed', 'destroyed', 2, 'yes', NULL, NULL, NULL, NULL);

DELETE FROM `form_fields_global_lookups` 
WHERE `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'destroyed');

INSERT INTO `form_fields_global_lookups` ( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1104', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'destroyed')),
('CAN-999-999-000-999-1152', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'aliquot_status_reason' AND `value` like 'destroyed'));

DELETE FROM `i18n`
WHERE `id` IN
('destroyed');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('destroyed', 'global', 'Destroyed', 'D&eacute;truit');

-- -----------------------------------------------------------------------------------------------------------------
-- change_aliquot_position_status_in_batch -------------------------------------------------------------------------

DELETE FROM `forms` WHERE `id` = 'CAN-024-001-000-999-0039';

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0039', 'change_aliquot_position_status_in_batch', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `form_id` = 'CAN-024-001-000-999-0039';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* FunctionManagement.generated_field_copy_prev_line */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1119', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1119', 0, 1, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.copy_storage_only */
('CAN-024-001-000-999-0039_CAN-024-001-000-999-0112', 'CAN-024-001-000-999-0039', 'CAN-024-001-000-999-0112 ', 0, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* SampleMaster.sample_label */
('CAN-024-001-000-999-0039_CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0039', 'CAN-024-001-000-999-0001', 0, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- /* AliquotMaster.label */
-- ('CAN-024-001-000-999-0039_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0039', 'CAN-024-001-000-999-0009', 0, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.barcode */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1101', 0, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.type */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1102', 0, 13, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.status */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1103', 0, 14, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.status_reason */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1152', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1152', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* FunctionManagement.additional_field_delete_of_storage */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1215', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1215 ', 0, 25, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.storage_selection_label */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1216', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1216', 0, 20, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_master_id */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1106', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1106', 0, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1107', 0, 22, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1108', 0, 24, '', 0, '', 1, '-', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.notes */
('CAN-024-001-000-999-0039_CAN-999-999-000-999-1112', 'CAN-024-001-000-999-0039', 'CAN-999-999-000-999-1112 ', 0, 27, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `form_fields`
SET `language_help` = 'copy_storage_only_help'
WHERE `id` = 'CAN-024-001-000-999-0112';	/* FunctionManagement.copy_storage_only */

UPDATE `form_fields`
SET `language_help` = 'additional_field_delete_of_storage_help'
WHERE `id` = 'CAN-999-999-000-999-1215';	/* FunctionManagement.additional_field_delete_of_storage */

DELETE FROM `i18n` WHERE `id` IN ('copy_storage_only_help', 'additional_field_delete_of_storage_help');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('copy_storage_only_help', 'global', 
'Will copy only storage data of the previous line (selection label, storage, position into storage, remove).', 
'Copier uniquement les donn&eacute;es d''entreposage de la ligne pr&eacute;c&eacute;dente (identifiant de s&eacute;lection, entreposage, position dans l''entreposage, enlever).');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('additional_field_delete_of_storage_help', 'global', 
'Will delete storage data (selection label, storage, position into storage).', 
'Supprimer les donn&eacute;es d''entreposage (identifiant de s&eacute;lection, entreposage, position dans l''entreposage).');

DELETE FROM `i18n` WHERE `id` IN ('check all', 'uncheck all');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('check all', 'global', 'Check All', 'S&eacute;lectionner tout'),
('uncheck all', 'global', 'Uncheck All', 'D&eacute;-s&eacute;lectionner tout');

DELETE FROM `i18n` WHERE `id` IN ('copy storage data of previous line');
DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0129');
DELETE FROM `form_fields_global_lookups` WHERE `field_id` IN ('CAN-024-001-000-999-0129');

-- -----------------------------------------------------------------------------------------------------------------
-- change realiquot_by form fields type to select -------------------------------------------------------------------------

UPDATE form_fields
set type = 'select',
setting = ''
where id =  'CAN-999-999-000-999-1266';

DELETE FROM `form_fields_global_lookups`
WHERE `field_id` = 'CAN-999-999-000-999-1266';

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'inconnue')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'lise portelance')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'chantale auger')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jason madore')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jennifer kendall dupont')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'julie desgagnes')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'karine normandin')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'isabelle letourneau')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'josh levin')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'liliane meunier')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'manon de ladurantaye')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'aurore pierrard')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'magdalena zietarska')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'nathalie delvoye')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'patrick kibangou bondza')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'urszula krzemien')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'valerie forest')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique barres')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'labo externe')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'pathologie')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'christine abaji')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'Elsa ')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'emilio, johanne et phil')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'hafida lounis')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'jessica godin ethier')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'kevin gu')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'louise champoux')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-andree forget')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-josee milot')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marie-line puiffe')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'marise roy')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'matthew starek')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'mona alam')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'stephanie lepage')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'veronique ouellet')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'yuan chang')),
('CAN-999-999-000-999-1266', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'autre'));

UPDATE realiquotings set realiquoted_by = 'manon de ladurantaye' WHERE realiquoted_by = 'Manon';
UPDATE realiquotings set realiquoted_by = 'yuan chang' WHERE realiquoted_by = 'Yuan';
UPDATE realiquotings set realiquoted_by = 'lise portelance' WHERE realiquoted_by = 'Lise Portelance';
UPDATE realiquotings set realiquoted_by = 'karine normandin' WHERE realiquoted_by = 'Karine';

-- -----------------------------------------------------------------------------------------------------------------
-- realiquot_in_batch_1_to_1 -------------------------------------------------------------------------

-- first step

DELETE FROM `forms` WHERE `id` = 'CAN-024-001-000-999-0038';

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0038', 'realiquote_in_batch_1_to_1_step1', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0127', 'CAN-024-001-000-999-0128',
'CAN-024-001-000-999-0129', 'CAN-024-001-000-999-0130', 'CAN-024-001-000-999-0131',
'CAN-024-001-000-999-0132', 'CAN-024-001-000-999-0133');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0127', 'FunctionManagement', 'child_aliquot_barcode', 'child aliquot barcode', '', 'input', 'size=30', 
'', 'child aliquot barcode help', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0128', 'FunctionManagement', 'child_aliquot_label', 'child aliquot label', '', 'input', 'size=30', 
'', 'child aliquot label help', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0129', 'FunctionManagement', 'additional_field_delete_of_storage', 'remove', '', 'select', '', 
'', 'additional_field_delete_of_storage_help', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- TODO: Unable to use form_fomats.flag_override_type to use existing form_field (CAN-999-999-000-999-1106, ...) as hidden
('CAN-024-001-000-999-0130', 'AliquotMaster', 'storage_master_id', '', '', 'hidden', '', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0131', 'AliquotMaster', 'storage_coord_x', '', '', 'hidden', '', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0132', 'AliquotMaster', 'storage_coord_y', '', '', 'hidden', '',  
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0133', 'SampleMaster', 'sample_code', 'sample code', '', 'hidden', '', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('child aliquot barcode', 'child aliquot label',
'child aliquot barcode help', 'child aliquot label help', 'barcode and aliquot label can not be modified',
'system is unable to realiquot different sample and aliquot types in batch!',
're-aliquote in Batch (1 to 1) - step 1', 're-aliquote in Batch (1 to 1) - step 2');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('system is unable to realiquot different sample and aliquot types in batch!', 
'global', 
'The system is unable to realiquote different sample and aliquot types in batch!', 
'L''application ne peut r&eacute;aliquoter des �chantillons et des aliquots de diff&eacute;rents types en batch!'),
('barcode and aliquot label can not be modified', 'global', 
'The barcodes and aliquot labels can not be modified at this step!', 
'Les barcodes et les labels d''aliquots ne peuvent plus &ecirc;tre modifi&eacute;s &agrave; ce niveau!'),

('re-aliquote in Batch (1 to 1) - step 2', 'global', 'Re-Aliquote In Batch (1 to 1) - Step 2', 'R&eacute;-aliquote aliquots en batch (1 &a&agrave; 1) - &Eacute;tape 2'),
('re-aliquote in Batch (1 to 1) - step 1', 'global', 'Re-Aliquote In Batch (1 to 1) - Step 1', 'R&eacute;-aliquote aliquots en batch (1 &a&agrave; 1) - &Eacute;tape 1'),

('child aliquot barcode', 'global', 'Created Aliquot Barcode', 'Barcode de l''aliquot cr&eacute;&eacute;'),
('child aliquot label', 'global', 'Created Aliquot Label', 'Label de l''aliquot cr&eacute;&eacute;'),
('child aliquot barcode help', 'global', 'Barcode of the new aliquot that will be created after the realquoting process.', 'Barcode du nouvel aliquot cr&eacute;&eacute; &agrave; la fin du processus de ''re-aliquotage''.'),
('child aliquot label help', 'global', 'Label of the new aliquot that will be created after the realquoting process.', 'Label du nouvel aliquot cr&eacute;&eacute; &agrave; la fin du processus de ''re-aliquotage''.');

DELETE FROM `form_fields_global_lookups` 
WHERE `field_id` IN ('CAN-024-001-000-999-0129');

INSERT INTO `form_fields_global_lookups` ( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0129', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0129', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

DELETE FROM `form_validations` 
WHERE `form_field_id` IN ('CAN-024-001-000-999-0129');

INSERT INTO `form_validations` 
( `id` , `form_field_id` , `expression` , `message` , `created` , `created_by` , `modified` , `modifed_by` )
VALUES 
(NULL , 'CAN-024-001-000-999-0129', '/.+/', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats` WHERE `form_id` = 'CAN-024-001-000-999-0038';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* AliquotMaster.collection_id (hidden) */ 
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1113', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1113', 0, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.sample_master_id (hidden) */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1114', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1114', 0, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_control_id (hidden) */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1115', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1115', 0, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_type (hidden) */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1116', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1116', 0, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.storage_master_id (hidden) */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0130', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0130', 0, 0, '', 0, '',0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x (hidden) */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0131', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0131', 0, 0, '', 1, '',1, '', 1, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y (hidden) */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0132', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0132', 0, 0, '', 1, '',1, '', 1, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* SampleMaster.sample_code (hidden) */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0133', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0133', 0, 0, '', 1, '',1, '', 1, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* FunctionManagement.generated_field_copy_prev_line */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1119', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1119', 0, 1, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* SampleMaster.sample_label */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0001', 0, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- /* AliquotMaster.label */
-- ('CAN-024-001-000-999-0038_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0009', 0, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.barcode */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1101', 0, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.type */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1102', 0, 13, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.realiquoted_datetime */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1130', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1130', 0, 14, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.realiquoted_datetime */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1131', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1131', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Realiquoting.realiquoted_by */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1266', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1266', 0, 20, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Realiquoting.realiquoted_datetime */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1267', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1267', 0, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.status */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1103', 0, 30, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.status_reason */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1152', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1152', 0, 31, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.additional_field_delete_of_storage */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0129', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0129 ', 0, 32, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotUse.used_volume */
('CAN-024-001-000-999-0038_CAN-999-999-000-999-1153', 'CAN-024-001-000-999-0038', 'CAN-999-999-000-999-1153 ', 0, 33, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* FunctionManagement.aliquot_label_to_create */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0128', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0128 ', 0, 40, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement.barcode_to_create */
('CAN-024-001-000-999-0038_CAN-024-001-000-999-0127', 'CAN-024-001-000-999-0038', 'CAN-024-001-000-999-0127 ', 0, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- -----------------------------------------------------------------------------------------------------------------
-- add procure life style field: completed -------------------------------------------------------------------------

DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0134');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0134', 'EventDetail', 'completed', 'completed', '', 'select', '', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields_global_lookups` 
WHERE `field_id` IN ('CAN-024-001-000-999-0134');

INSERT INTO `form_fields_global_lookups` ( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0134', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'yes')),
('CAN-024-001-000-999-0134', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'yesno' AND `value` like 'no'));

DELETE FROM `form_formats` WHERE `id` = 'CAN-024-001-000-999-0019_CAN-024-001-000-999-0134';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0019_CAN-024-001-000-999-0134', 'CAN-024-001-000-999-0019', 'CAN-024-001-000-999-0134', 1, 9, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- -----------------------------------------------------------------------------------------------------------------
-- add collection visit flag -------------------------------------------------------------------------

DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0135');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0135', 'Collection', 'visit_label', 'visit', '', 'select', '', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('procure_visit_label');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'procure_visit_label', NULL , NULL , 'V01', 'V01', '1', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'procure_visit_label', NULL , NULL , 'V02', 'V02', '2', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'procure_visit_label', NULL , NULL , 'V03', 'V03', '3', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'procure_visit_label', NULL , NULL , 'V04', 'V04', '4', 'yes', NULL , NULL , NULL , NULL), 
(NULL , 'procure_visit_label', NULL , NULL , 'V05', 'V05', '5', 'yes', NULL , NULL , NULL , NULL); 

DELETE FROM `form_fields_global_lookups` 
WHERE `field_id` IN ('CAN-024-001-000-999-0135');

INSERT INTO `form_fields_global_lookups` ( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0135', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'procure_visit_label' AND `value` like 'V01')),
('CAN-024-001-000-999-0135', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'procure_visit_label' AND `value` like 'V02')),
('CAN-024-001-000-999-0135', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'procure_visit_label' AND `value` like 'V03')),
('CAN-024-001-000-999-0135', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'procure_visit_label' AND `value` like 'V04')),
('CAN-024-001-000-999-0135', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'procure_visit_label' AND `value` like 'V05'));

DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-1000_CAN-024-001-000-999-0135';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* Collection.visit_label */ 
('CAN-999-999-000-999-1000_CAN-024-001-000-999-0135', 'CAN-999-999-000-999-1000', 'CAN-024-001-000-999-0135', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('visit', 'V01', 'V02', 'V03', 'V04', 'V05');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('V01', 'global', 'V01', 'V01'),
('V02', 'global', 'V02', 'V02'),
('V03', 'global', 'V03', 'V03'),
('V04', 'global', 'V04', 'V04'),
('V05', 'global', 'V05', 'V05'),
('visit', 'global', 'Visit', 'Visite');

DELETE FROM `form_formats` WHERE `id` = 'CAN-999-999-000-999-1001_CAN-024-001-000-999-0135';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* Collection.visit_label */ 
('CAN-999-999-000-999-1001_CAN-024-001-000-999-0135', 'CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0135', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- -----------------------------------------------------------------------------------------------------------------
-- move ed_lab_path_report_id to event_masters table ---------------------------------------------------------------

UPDATE form_fields
SET field = 'linked_path_report_id'
WHERE id = 'CAN-024-001-000-999-0057';

UPDATE form_fields
SET model = 'EventMaster',
field = 'linked_path_report_id'
WHERE id = 'CAN-024-001-000-999-0058';

-- -----------------------------------------------------------------------------------------------------------------
-- add storage position to aliquot_masters_for_search_result  form -------------------------------------------------

DELETE FROM `form_formats` WHERE `id` IN ('CAN-999-999-000-999-1021_CAN-999-999-000-999-1217', 
'CAN-999-999-000-999-1021_CAN-999-999-000-999-1117', 'CAN-999-999-000-999-1021_CAN-999-999-000-999-1107', 
'CAN-999-999-000-999-1021_CAN-999-999-000-999-1108');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
/* StorageMaster.selection_label */
('CAN-999-999-000-999-1021_CAN-999-999-000-999-1217', 'CAN-999-999-000-999-1021', 'CAN-999-999-000-999-1217', 0, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.code */
('CAN-999-999-000-999-1021_CAN-999-999-000-999-1117', 'CAN-999-999-000-999-1021', 'CAN-999-999-000-999-1117', 0, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-999-999-000-999-1021_CAN-999-999-000-999-1107', 'CAN-999-999-000-999-1021', 'CAN-999-999-000-999-1107', 0, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-999-999-000-999-1021_CAN-999-999-000-999-1108', 'CAN-999-999-000-999-1021', 'CAN-999-999-000-999-1108', 0, 13, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- -----------------------------------------------------------------------------------------------------------------
-- change gel csa to sst -------------------------------------------------

UPDATE `global_lookups`
SET `value` = 'gel SST',
language_choice = 'gel SST'
WHERE `alias` LIKE 'blood_type' AND `value` like 'gel CSA';

UPDATE `sd_spe_bloods`
SET `type` = 'gel SST'
WHERE `type` like 'gel CSA';

DELETE FROM `i18n`
WHERE `id` IN
('gel CSA', 'gel SST');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('gel SST', 'global', 'Gel SST', 'Gel SST');

-- SELECT CONCAT('UPDATE aliquot_masters SET aliquot_label = \'', aliquot_label, '\' WHERE id = ', id, ' AND  aliquot_label = \'', aliquot_label, '\';') FROM aliquot_masters WHERE aliquot_label LIKE '%gel CSA%';
-- mysql -u root -p ATiM < query.sql > updates_queries.sql                                                                             xt

-- SELECT CONCAT('UPDATE sample_masters SET sample_label = \'', sample_label, '\' WHERE id = ', id, ' AND  sample_label = \'', sample_label, '\';') FROM sample_masters WHERE sample_label LIKE '%gel CSA%';
-- mysql -u root -p ATiM < query.sql > updates_queries.sql   

-- -----------------------------------------------------------------------------------------------------------------
-- add position for parent, etc aliquot selection -------------------------------------------------

DELETE FROM `form_formats` WHERE `id` IN (
'CAN-999-999-000-999-1070_CAN-999-999-000-999-1217',
'CAN-999-999-000-999-1070_CAN-999-999-000-999-1107',
'CAN-999-999-000-999-1070_CAN-999-999-000-999-1108',

'CAN-999-999-000-999-1036_CAN-999-999-000-999-1217',
'CAN-999-999-000-999-1036_CAN-999-999-000-999-1107',
'CAN-999-999-000-999-1036_CAN-999-999-000-999-1108',

'CAN-999-999-000-999-1071_CAN-999-999-000-999-1217',
'CAN-999-999-000-999-1071_CAN-999-999-000-999-1107',
'CAN-999-999-000-999-1071_CAN-999-999-000-999-1108'
);

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
/* REALIQUOTED PARENT SELECTION */

/* StorageMaster.selection_label */
('CAN-999-999-000-999-1070_CAN-999-999-000-999-1217', 'CAN-999-999-000-999-1070', 'CAN-999-999-000-999-1217', 0, 5, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-999-999-000-999-1070_CAN-999-999-000-999-1107', 'CAN-999-999-000-999-1070', 'CAN-999-999-000-999-1107', 0, 6, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-999-999-000-999-1070_CAN-999-999-000-999-1108', 'CAN-999-999-000-999-1070', 'CAN-999-999-000-999-1108', 0, 7, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),

('CAN-999-999-000-999-1036_CAN-999-999-000-999-1217', 'CAN-999-999-000-999-1036', 'CAN-999-999-000-999-1217', 0, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-999-999-000-999-1036_CAN-999-999-000-999-1107', 'CAN-999-999-000-999-1036', 'CAN-999-999-000-999-1107', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-999-999-000-999-1036_CAN-999-999-000-999-1108', 'CAN-999-999-000-999-1036', 'CAN-999-999-000-999-1108', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),

('CAN-999-999-000-999-1071_CAN-999-999-000-999-1217', 'CAN-999-999-000-999-1071', 'CAN-999-999-000-999-1217', 0, 3, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-999-999-000-999-1071_CAN-999-999-000-999-1107', 'CAN-999-999-000-999-1071', 'CAN-999-999-000-999-1107', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-999-999-000-999-1071_CAN-999-999-000-999-1108', 'CAN-999-999-000-999-1071', 'CAN-999-999-000-999-1108', 0, 4, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', '');  

-- -----------------------------------------------------------------------------------------------------------------
-- temporary patch for issue 561 -------------------------------------------------

UPDATE `forms` 
SET `language_title` = ''
WHERE `id` = 'CAN-999-999-000-999-1024'
AND `alias` = 'ad_spec_tubes_incl_ml_vol';

-- -----------------------------------------------------------------------------------------------------------------
-- Add Task Status -------------------------------------------------

DELETE FROM `form_fields` WHERE `id` IN ('CAN-024-001-000-999-0136');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0136', 'ParticipantMessage', 'status', 'task status', '', 'select', '', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields_global_lookups` 
WHERE `field_id` IN ('CAN-024-001-000-999-0136');

INSERT INTO `form_fields_global_lookups` ( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0136', (SELECT MAX(`id`) FROM `global_lookups` WHERE `alias` LIKE 'status' AND `value` like 'pending')),
('CAN-024-001-000-999-0136', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'status' AND `value` like 'in process')),
('CAN-024-001-000-999-0136', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'status' AND `value` like 'completed'));

DELETE FROM `form_formats` WHERE `id` IN (
'CAN-999-999-000-999-9_CAN-024-001-000-999-0136'
);

INSERT INTO `form_formats` 
(`id`, `form_id`, `field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-999-999-000-999-9_CAN-024-001-000-999-0136', 'CAN-999-999-000-999-9', 'CAN-024-001-000-999-0136', 1, 2, 
'', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, '0000-00-00 00:00:00', '', 
'0000-00-00 00:00:00', '');

-- -----------------------------------------------------------------------------------------------------------------
-- Add Tissue Type Code CIS -------------------------------------------------

DELETE FROM `lab_type_laterality_match` 
WHERE `selected_type_code` = 'CIS';

INSERT INTO `lab_type_laterality_match` 
(`id`, `selected_type_code`, `selected_labo_laterality`, `sample_type_matching`, `tissue_source_matching`, `nature_matching`, `laterality_matching`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(NULL, 'CIS', '', 'tissue', 'breast', 'malignant', '', '0000-00-00 00:00:00', '', NULL, NULL),
(NULL, 'CIS', 'D', 'tissue', 'breast', 'malignant', 'right', '0000-00-00 00:00:00', '', NULL, NULL),
(NULL, 'CIS', 'G', 'tissue', 'breast', 'malignant', 'left', '0000-00-00 00:00:00', '', NULL, NULL);

DELETE FROM `global_lookups`  
WHERE  `alias` = 'labo_sample_type_code'
AND `value` = 'CIS';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'labo_sample_type_code', NULL , NULL , 'CIS', 'CIS type code', '4', 'yes', NULL , NULL , NULL , NULL); 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-024-001-000-999-0002'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'CIS');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'CIS'));

DELETE FROM `i18n`
WHERE `id` IN
('CIS type code');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('CIS type code', 'global', 'CIS', 'CIS');

-- -----------------------------------------------------------------------------------------------------------------
-- Update Realiquot In batch Form Title -------------------------------------------------

UPDATE `atim-local-dev`.`i18n` 
SET `en` = 'Re-Aliquote In Batch (1 to 1) - Step 1 - Parent Update',
`fr` = 'R&eacute;-aliquote aliquots en batch (1 &a&agrave; 1) - &Eacute;tape 1 - Mise &agrave; jour parent' 
WHERE `i18n`.`id` = 're-aliquote in Batch (1 to 1) - step 1' 
AND `i18n`.`page_id` = 'global';

UPDATE `atim-local-dev`.`i18n` 
SET `en` = 'Re-Aliquote In Batch (1 to 1) - Step 2 - Child Creation',
`fr` = 'R&eacute;-aliquote aliquots en batch (1 &a&agrave; 1) - &Eacute;tape 2 - Cr&eacute;ation nouveaux aliquots' 
WHERE `i18n`.`id` = 're-aliquote in Batch (1 to 1) - step 2' 
AND `i18n`.`page_id` = 'global';

-- ------------------------------------------------------------------------------
-- Allow 5-7 for cell passage number ---------

DELETE FROM `form_validations`
WHERE `form_field_id` IN
('CAN-999-999-000-999-1067', 'CAN-024-001-000-999-0012',
'CAN-024-001-000-999-0005');

INSERT INTO `form_validations` (`id`, `form_field_id`, `expression`, `message`, `created`, `created_by`, `modified`, `modifed_by`) VALUES
(NULL, 'CAN-999-999-000-999-1067', '/^(\\d*([\\-]\\d*)?)$/', 'cell passage number should be a positif integer or an interval', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL, 'CAN-024-001-000-999-0005', '/^(\\d*([\\-]\\d*)?)$/', 'cell passage number should be a positif integer or an interval', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL, 'CAN-024-001-000-999-0012', '/^(\\d*([\\-]\\d*)?)$/', 'cell passage number should be a positif integer or an interval', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n`
WHERE `id` IN
('cell passage number should be a positif integer or an interval');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('cell passage number should be a positif integer or an interval', 
'global', 
'Cell Passage number should be a positive integer or an interval (ex: ''3-6'')!', 
'Nombre de passages cellulaires doit &ecirc;tre un entier positif ou un intervalle (ex: ''3-6'')!');

-- ------------------------------------------------------------------------------
-- Allow to modify shipping name ---------

UPDATE `form_formats` 
SET `flag_edit_readonly` = '0' 
WHERE `id` = 'CAN-999-999-000-999-61_CAN-024-001-000-999-0099';

-- -----------------------------------------------------------------------------------------------------------------
-- Add RNA tube storage solution -------------------------------------------------

DELETE FROM `global_lookups`  
WHERE  `alias` = 'dna_rna_storage_solution'
AND `value` = 'br5 (paxgene kit)';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'dna_rna_storage_solution', NULL , NULL , 'br5 (paxgene kit)', 'br5 (paxgene kit)', '4', 'yes', NULL , NULL , NULL , NULL); 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-024-001-000-999-tmp021'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_rna_storage_solution' AND `value` like 'br5 (paxgene kit)');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp021', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'dna_rna_storage_solution' AND `value` like 'br5 (paxgene kit)'));

DELETE FROM `i18n`
WHERE `id` IN
('br5 (paxgene kit)');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('br5 (paxgene kit)', 'global', 'BR5 (Paxgene kit)', 'BR5 (kit ''Paxgene'')');

-- -----------------------------------------------------------------------------------------------------------------
-- Update missing i18n-------------------------------------------------

DELETE FROM `i18n`
WHERE `id` IN
('trizol and quiagen cleanup', 'trizol and scissors', 'trizol and homogenizer');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('trizol and quiagen cleanup', 'global', 'Trizol and quiagen cleanup', null),
('trizol and scissors', 'global', 'Trizol and scissors', null),
('trizol and homogenizer', 'global', 'Trizol and homogenizer', null);

-- -----------------------------------------------------------------------------------------------------------------
-- Add QC unit 230/280 -------------------------------------------------

DELETE FROM `global_lookups`  
WHERE  `alias` = 'quality_control_unit'
AND `value` = '230/280';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'quality_control_unit', NULL , NULL , '230/280', '230/280', '0', 'yes', NULL , NULL , NULL , NULL); 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-999-1171'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_unit' AND `value` like '230/280');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1171', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'quality_control_unit' AND `value` like '230/280'));

DELETE FROM `i18n`
WHERE `id` IN
('230/280');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('230/280', 'global', '230/280', '230/280');

-- -----------------------------------------------------------------------------------------------------------------
-- Add time to QC date -------------------------------------------------

UPDATE `form_fields` 
SET `type` = 'datetime' WHERE `id` = 'CAN-999-999-000-999-1272';

-- -----------------------------------------------------------------------------------------------------------------
-- Add Katia Caceres -------------------------------------------------------------------------

DELETE FROM `i18n` WHERE `id` = 'katia caceres';

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('katia caceres', 'global', 'Katia Caceres', 'Katia Caceres');

DELETE FROM `global_lookups`  
WHERE  `alias` = 'qc_lab_people_list'
AND `value` LIKE 'katia caceres';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_lab_people_list', NULL , NULL , 'katia caceres', 'katia caceres', '11', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`
WHERE `lookup_id` = (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'katia caceres');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
/* Stored by */
('CAN-024-001-000-999-0107', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'katia caceres')),
/* Collection reception by */
('CAN-999-999-000-999-1005', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'katia caceres')),
/* Derivative creation by */
('CAN-999-999-000-999-1061', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'katia caceres')),
/* Order */
('CAN-999-999-000-999-499', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'katia caceres')),
/* Shipment */
('CAN-999-999-000-999-514', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_lab_people_list' AND `value` like 'katia caceres'));

-- -----------------------------------------------------------------------------------------------------------------
-- Change all aliquot reserved to available -------------------------------------------------------------------------

UPDATE aliquot_masters SET status = 'available' WHERE status_reason LIKE 'reserved%';

-- -----------------------------------------------------------------------------------------------------------------
-- Add to batch set -------------------------------------------------------------------------

DELETE FROM `i18n`
WHERE `id` IN
('add to batchset', 'add aliquot to batchset', 'existing batchsets', 'queries to create new batchset');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('add to batchset', 'global', 'Add to BatchSet', 'Ajouter au ''BatchSet'''),
('add aliquot to batchset', 'global', 'Add Aliquots to BatchSet', 'Ajouter des Aliquots au ''BatchSet'''),
('existing batchsets', 'global', 'Existing batchsets', '''BatchSets'' existants'),
('queries to create new batchset', 'global', 'Queries to create new batchset', 'Requ&ecirc;tes pour cr&eacute;er un ''BatchSet''');

-- -----------------------------------------------------------------------------------------------------------------
-- Allow shipping name modification in batch -------------------------------------------------------------------------

UPDATE `form_formats` SET `flag_datagrid_readonly` = '0' 
WHERE `form_formats`.`id` = 'CAN-999-999-000-999-61_CAN-024-001-000-999-0099';

-- -----------------------------------------------------------------------------------------------------------------
-- Aliquot Display in storage module -------------------------------------------------------------------------

-- Add status
DELETE FROM `form_formats`
WHERE `id` = 'CAN-999-999-000-999-1048_CAN-999-999-000-999-1103';

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-999-999-000-999-1048_CAN-999-999-000-999-1103', 'CAN-999-999-000-999-1048', 'CAN-999-999-000-999-1103', 0, 6, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`
WHERE `id` IN ('CAN-999-999-000-999-1050_CAN-999-999-000-999-1103', 'CAN-999-999-000-999-1049_CAN-999-999-000-999-1103',
'CAN-999-999-000-999-1052_CAN-999-999-000-999-1103');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
-- std_2_dim_position_selection_for_aliquot
('CAN-999-999-000-999-1050_CAN-999-999-000-999-1103', 'CAN-999-999-000-999-1050', 'CAN-999-999-000-999-1103', 0, 6, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- std_1_dim_position_selection_for_aliquot
('CAN-999-999-000-999-1049_CAN-999-999-000-999-1103', 'CAN-999-999-000-999-1049', 'CAN-999-999-000-999-1103', 0, 6, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- manage_storage_aliquots_without_position
('CAN-999-999-000-999-1052_CAN-999-999-000-999-1103', 'CAN-999-999-000-999-1052', 'CAN-999-999-000-999-1103', 0, 6, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 1, 1, 0, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_formats`
WHERE `id` IN ('CAN-024-001-000-999-0003_CAN-999-999-000-999-1217');
INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CAN-024-001-000-999-0003_CAN-999-999-000-999-1217', 'CAN-024-001-000-999-0003', 'CAN-999-999-000-999-1217', 0, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- CHUS / CHUQ -------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE `alias` = 'qc_site_list'
AND `value` IN ('CHUS', 'CHUQ');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_site_list', NULL , NULL , 'CHUS', 'CHUS', '0', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'qc_site_list', NULL , NULL , 'CHUQ', 'CHUQ', '0', 'yes', NULL , NULL , NULL , NULL); 

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` = 'CAN-999-999-000-999-1003'
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` IN ('CHUS', 'CHUQ'));

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` like 'CHUS')),
('CAN-999-999-000-999-1003', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_site_list' AND `value` like 'CHUQ'));

DELETE FROM `i18n`
WHERE `id` IN ('CHUS', 'CHUQ');

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('CHUS', 'global', 'CHUS', 'CHUS'),
('CHUQ', 'global', 'CHUQ', 'CHUQ');

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- derivative_creation_site = other -------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE  `alias` IN ('qc_derivative_creation_site') AND `value` = 'other';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_derivative_creation_site', NULL , NULL , 'other', 'other', '14', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-999-999-000-999-1060')
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'other');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1060', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_derivative_creation_site' AND `value` like 'other'));

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- add consent version '2009-11-04' -------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_consent_form_version_date') AND `value` = '2009-11-04';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2009-11-04',	'2009-11-04', '9', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0023')
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2009-11-04');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2009-11-04'));

DELETE FROM `i18n`  
WHERE `id` IN ('2009-11-04');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('2009-11-04', 'global', '2009-11-04', '2009-11-04');

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- add consent type 'FRSQ - Network' -------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_consent_form_type')
AND `value` = 'FRSQ - Network';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_consent_form_type', NULL , NULL , 'FRSQ - Network', 'frsq - network', '0', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0022')
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_type' AND `value` like 'FRSQ - Network');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0022', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_type' AND `value` like 'FRSQ - Network'));

DELETE FROM `i18n`  
WHERE `id` IN ('frsq - network');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('frsq - network', 'global', 'FRSQ - Network', 'FRSQ - R&eacute;seau');


-- -----------------------------------------------------------------------------------------------------------------
-- add  'kidney bank no lab' -------------------------------------------------------------------------

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'kidney bank no lab', 'kidney bank no lab', '3', 'yes', NULL , NULL , NULL , NULL);

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'kidney bank no lab'));

INSERT INTO `part_bank_nbr_counters` 
( `id` , `bank_ident_title` , `last_nbr` )
VALUES 
(NULL, 'kidney bank no lab', '200000');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`)
VALUES 
('kidney bank no lab', 'global', '''No Labo'' of Kidney Bank', '''No Labo'' de la banque Rein');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_bank_list', NULL , NULL , 'kidney', 'kidney', '4', 'yes', NULL , NULL , NULL , NULL);

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1001', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'kidney')),
('CAN-999-999-000-999-1002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'kidney')),
('CAN-999-999-000-999-1223', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'kidney'));

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`)
VALUES 
('kidney', 'global', 'Kidney', 'Rein');

INSERT INTO `global_lookups` 
(`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
(NULL, 'qc_bank_identifier_for_bank_query', NULL, NULL, 'kidney bank no lab', 'kidney', 4, 'yes', 
NULL, NULL, NULL, NULL);


INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0108', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_identifier_for_bank_query' AND `value` like 'kidney bank no lab'));

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, 
`default`, `language_help`, 
`install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0142', 'KidneyBankIdentifiers', 'identifier_value', 'kidney bank no lab', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0142', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0142', 4, 23, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


-- -----------------------------------------------------------------------------------------------------------------
-- Add Tissue Type Code for head and neck bank -------------------------------------------------

INSERT INTO `lab_type_laterality_match` 
( `id` , `selected_type_code` , `selected_labo_laterality` , `sample_type_matching` , `tissue_source_matching` , `nature_matching`, `laterality_matching` )
VALUES 
-- Cavit� orale
(NULL , 'TCO', '', 'tissue', 'oral cavity', 'malignant', ''),
-- Oropharynx
(NULL , 'TOP', '', 'tissue', 'oropharynx', 'malignant', ''),
-- larynx
(NULL , 'TL', '', 'tissue', 'larynx', 'malignant', ''),
-- hypopharynx
(NULL , 'THP', '', 'tissue', 'hypopharynx', 'malignant', ''),
-- nasopharynx
(NULL , 'TNP', '', 'tissue', 'nasopharynx', 'malignant', '');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'labo_sample_type_code', NULL , NULL , 'TCO', 'TCO type code', '50', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'labo_sample_type_code', NULL , NULL , 'TOP', 'TOP type code', '51', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'labo_sample_type_code', NULL , NULL , 'TL', 'TL type code', '52', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'labo_sample_type_code', NULL , NULL , 'THP', 'THP type code', '53', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'labo_sample_type_code', NULL , NULL , 'TNP', 'TNP type code', '54', 'yes', NULL , NULL , NULL , NULL);

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'TCO')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'TOP')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'TL')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'THP')),
('CAN-024-001-000-999-0002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_sample_type_code' AND `value` like 'TNP'));

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('TCO type code', 'global', 'TCO', 'TCO'),
('TOP type code', 'global', 'TOP', 'TOP'),
('TL type code', 'global', 'TL', 'TL'),
('THP type code', 'global', 'THP', 'THP'),
('TNP type code', 'global', 'TNP', 'TNP');

INSERT INTO `global_lookups` 
(`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'tissue_source', NULL, NULL, 'oral cavity', 'oral cavity', 5, 'yes', NULL, NULL, NULL, NULL),
(null, 'tissue_source', NULL, NULL, 'oropharynx', 'oropharynx', 5, 'yes', NULL, NULL, NULL, NULL),
(null, 'tissue_source', NULL, NULL, 'larynx', 'larynx', 5, 'yes', NULL, NULL, NULL, NULL),
(null, 'tissue_source', NULL, NULL, 'hypopharynx', 'hypopharynx', 5, 'yes', NULL, NULL, NULL, NULL),
(null, 'tissue_source', NULL, NULL, 'nasopharynx', 'nasopharynx', 5, 'yes', NULL, NULL, NULL, NULL);

INSERT INTO `form_fields_global_lookups` (`field_id`, `lookup_id`)
VALUES
('CAN-999-999-000-999-1040', (SELECT id FROM `global_lookups` WHERE `value` = 'oral cavity' AND `alias` = 'tissue_source')),
('CAN-999-999-000-999-1040', (SELECT id FROM `global_lookups` WHERE `value` = 'oropharynx' AND `alias` = 'tissue_source')),
('CAN-999-999-000-999-1040', (SELECT id FROM `global_lookups` WHERE `value` = 'oropharynx' AND `alias` = 'tissue_source')),
('CAN-999-999-000-999-1040', (SELECT id FROM `global_lookups` WHERE `value` = 'hypopharynx' AND `alias` = 'tissue_source')),
('CAN-999-999-000-999-1040', (SELECT id FROM `global_lookups` WHERE `value` = 'nasopharynx' AND `alias` = 'tissue_source'));

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`)
VALUES 
('oral cavity', 'global', 'Oral Cavity', 'Cavit&eacute; orale'),
('oropharynx', 'global', 'Oropharynx', 'Oropharynx'),
('larynx', 'global', 'Larynx', 'Larynx'),
('hypopharynx', 'global', 'Hypopharynx', 'Hypopharynx'),
('nasopharynx', 'global', 'Nasopharynx', 'Nasopharynx');

-- -----------------------------------------------------------------------------------------------------------------
-- add  'head and neck bank no lab' -------------------------------------------------------------------------

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'head and neck bank no lab', 'head and neck bank no lab', '4', 'yes', NULL , NULL , NULL , NULL);

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'head and neck bank no lab'));

INSERT INTO `part_bank_nbr_counters` 
( `id` , `bank_ident_title` , `last_nbr` )
VALUES 
(NULL, 'head and neck bank no lab', '300000');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`)
VALUES 
('head and neck bank no lab', 'global', '''No Labo'' of Head & Neck Bank', '''No Labo'' de la banque T&ecirc;te & Cou');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_bank_list', NULL , NULL , 'head and neck', 'head and neck', '5', 'yes', NULL , NULL , NULL , NULL);

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-1001', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'head and neck')),
('CAN-999-999-000-999-1002', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'head and neck')),
('CAN-999-999-000-999-1223', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_list' AND `value` like 'head and neck'));

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`)
VALUES 
('head and neck', 'global', 'Head & Neck', 'T&ecirc;te & cou');

INSERT INTO `global_lookups` 
(`id`, `alias`, `section`, `subsection`, `value`, `language_choice`, `display_order`, `active`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
(NULL, 'qc_bank_identifier_for_bank_query', NULL, NULL, 'head and neck bank no lab', 'head and neck', 4, 'yes', 
NULL, NULL, NULL, NULL);


INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0108', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_bank_identifier_for_bank_query' AND `value` like 'head and neck bank no lab'));

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, 
`default`, `language_help`, 
`install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0143', 'HeadNeckBankIdentifiers', 'identifier_value', 'head and neck bank no lab', '', 'input', 'size=30', 
'', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-999-999-000-999-1_CAN-024-001-000-999-0143', 'CAN-999-999-000-999-1', 'CAN-024-001-000-999-0143', 4, 24, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- -----------------------------------------------------------------------------------------------------------------
-- global_lookups -- add consent version '2010-03-04' -------------------------------------------------------------------------

DELETE FROM `global_lookups`  
WHERE `alias` IN ('qc_consent_form_version_date') AND `value` = '2010-03-04';

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_consent_form_version_date', NULL , NULL , '2010-03-04',	'2010-03-04', '8', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0023')
AND `lookup_id` IN (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2010-03-04');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_consent_form_version_date' AND `value` like '2010-03-04'));

DELETE FROM `i18n`  
WHERE `id` IN ('2010-03-04');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('2010-03-04', 'global', '2010-03-04', '2010-03-04');

-- -----------------------------------------------------------------------------------------------------------------
-- Ascite cell tube -- add storage solution -------------------------------------------------------------------------

-- 
-- Table - `aliquot_controls`
-- 

DELETE FROM `aliquot_controls`
WHERE `id` = '1003';

INSERT INTO `aliquot_controls` ( `id` , `aliquot_type` , `status` , `form_alias` , `detail_tablename`,  `volume_unit`)
VALUES 
('1003', 'tube', 'active', 'ad_ascite_cell_tubes', 'ad_tubes', 'ml');

-- 
-- Table - `sample_aliquot_control_links`
-- 

UPDATE `sample_aliquot_control_links`
SET `aliquot_control_id` = '1003'
WHERE `aliquot_control_id` = '8' AND `sample_control_id` = '5';

-- 
-- Table - `forms`
-- 

DELETE FROM `forms`  
WHERE `alias` = 'ad_ascite_cell_tubes'
OR `id` IN ('CAN-024-001-000-999-tmp004');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) VALUES 
('CAN-024-001-000-999-tmp004', 'ad_ascite_cell_tubes', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields`
-- 

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp023');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`)
VALUES 
('CAN-024-001-000-999-tmp023', 'AliquotDetail', 'tmp_storage_solution', 'tmp storage solution', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields`  
WHERE `id` IN ('CAN-024-001-000-999-tmp024');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, 
`type`, `setting`, `default`, `language_help`, 
`created`, `created_by`, `modified`, `modified_by`)
VALUES 											 tmp_storage_method 
('CAN-024-001-000-999-tmp024', 'AliquotDetail', 'tmp_storage_method', 'tmp storage method', '', 
'select', '', '', '', 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- 
-- Table - `form_fields_global_lookups`
-- 

DELETE FROM `global_lookups`  
WHERE `alias` IN ('ascite_cell_storage_solution');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'ascite_cell_storage_solution', NULL , NULL , 'DMSO + FBS', 'DMSO + FBS', '1', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'ascite_cell_storage_solution', NULL , NULL , 'trizol', 'trizol', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'ascite_cell_storage_solution', NULL , NULL , 'none', 'none', '3', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp023');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'ascite_cell_storage_solution' AND `value` like 'trizol')),
('CAN-024-001-000-999-tmp023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'ascite_cell_storage_solution' AND `value` like 'DMSO + FBS')),
('CAN-024-001-000-999-tmp023', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'ascite_cell_storage_solution' AND `value` like 'none'));

DELETE FROM `global_lookups`  
WHERE `alias` IN ('ascite_cell_storage_method');

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'ascite_cell_storage_method', NULL , NULL , 'flash freeze', 'flash freeze', '2', 'yes', NULL , NULL , NULL , NULL),
(NULL , 'ascite_cell_storage_method', NULL , NULL , 'none', 'none', '3', 'yes', NULL , NULL , NULL , NULL);

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-tmp024');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-tmp024', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'ascite_cell_storage_method' AND `value` like 'flash freeze')),
('CAN-024-001-000-999-tmp024', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'ascite_cell_storage_method' AND `value` like 'none'));

-- 
-- Table - `form_formats`
-- 

DELETE FROM `form_formats` WHERE `form_id` = 'CAN-024-001-000-999-tmp004';

INSERT INTO `form_formats` VALUES 
('CAN-024-001-000-999-tmp004_CAN-024-001-000-999-0008','CAN-024-001-000-999-tmp004','CAN-024-001-000-999-0008',
0,2,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,0,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-024-001-000-999-0009','CAN-024-001-000-999-tmp004','CAN-024-001-000-999-0009',
0,2,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,1,1,0,1,0,1,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-024-001-000-999-0107','CAN-024-001-000-999-tmp004','CAN-024-001-000-999-0107',
0,15,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1100','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1100',
0,2,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,0,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1101','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1101',
0,2,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,1,1,1,1,0,1,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1102','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1102',
0,5,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,1,1,1,0,1,1,1,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1103','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1103',
0,6,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1104','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1104',
0,7,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1105','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1105',
0,8,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,0,1,0,1,0,1,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1106','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1106',
0,10,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1107','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1107',
0,12,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1108','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1108',
0,14,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1109','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1109',
0,15,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1110','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1110',
0,16,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,0,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1112','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1112',
0,20,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,0,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1113','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1113',
0,0,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1114','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1114',
0,0,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1115','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1115',
0,0,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1116','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1116',
0,0,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1117','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1117',
0,11,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,0,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1119','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1119',
0,1,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1120','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1120',
1,30,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1130','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1130',
1,40,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,0,1,0,1,0,1,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1131','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1131',
1,41,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,0,1,0,1,0,1,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1132','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1132',
1,42,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1133','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1133',
1,43,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,1,1,1,0,1,1,1,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1140','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1140',
1,50,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,0,1,0,1,0,1,0,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1141','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1141',
1,51,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,0,1,0,1,0,1,0,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1142','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1142',
1,52,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,0,1,0,1,0,1,0,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1143','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1143',
1,53,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,1,0,1,0,1,0,1,0,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00','');

INSERT INTO `form_formats` VALUES 
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1165','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1165',
0,19,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,0,0,0,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1194','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1194',
0,17,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,0,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1216','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1216',
0,9,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,0,0,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1217','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1217',
0,10,'',0,'',0,'',0,'',0,'',0,'',0,'',
0,0,0,0,0,0,0,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00',''),
('CAN-024-001-000-999-tmp004_CAN-999-999-000-999-1259','CAN-024-001-000-999-tmp004','CAN-999-999-000-999-1259',
0,7,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00','');

INSERT INTO `form_formats` VALUES 
('CAN-024-001-000-999-tmp004_CAN-024-001-000-999-tmp023','CAN-024-001-000-999-tmp004','CAN-024-001-000-999-tmp023',
1,44,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00','');

INSERT INTO `form_formats` VALUES 
('CAN-024-001-000-999-tmp004_CAN-024-001-000-999-tmp024','CAN-024-001-000-999-tmp004','CAN-024-001-000-999-tmp024',
1,45,'',0,'',0,'',0,'',0,'',0,'',0,'',
1,0,1,0,0,0,1,0,1,1,'0000-00-00 00:00:00','','0000-00-00 00:00:00','');

UPDATE aliquot_masters 
SET aliquot_control_id = '1003'
WHERE aliquot_control_id = '8' AND sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id = '5');

-- -----------------------------------------------------------------------------------------------------------------
-- Add participant patho identifier to misc identifiers -------------------------------------------------------------------------

INSERT INTO `global_lookups` 
( `id` , `alias` , `section` , `subsection` , `value` , `language_choice` , `display_order` , `active` ,
`created` , `created_by` , `modified` , `modified_by` )
VALUES 
(NULL , 'qc_misc_identifier_type', NULL , NULL , 'participant patho identifier', 'participant patho identifier', '10', 'yes', NULL , NULL , NULL , NULL);
INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-999-999-000-999-34', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'qc_misc_identifier_type' AND `value` like 'participant patho identifier'));

DELETE FROM `i18n`
WHERE `id` IN (
'participant patho identifier'
);

INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES 
('participant patho identifier', 'global', 'Patho Identifier', 'Identifiant de pathologie');
