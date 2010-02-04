-- Add any new SQL changes to this file which will then be merged with the master
-- upgrade scripts.

ALTER TABLE `ed_all_study_research` ADD `file_path` VARCHAR( 255 ) NOT NULL AFTER `event_master_id`  ;

INSERT INTO `structure_fields` (
`id` ,
`public_identifier` ,
`old_id` ,
`plugin` ,
`model` ,
`tablename` ,
`field` ,
`language_label` ,
`language_tag` ,
`type` ,
`setting` ,
`default` ,
`structure_value_domain` ,
`language_help` ,
`validation_control` ,
`value_domain_control` ,
`field_control` ,
`created` ,
`created_by` ,
`modified` ,
`modified_by`
)
VALUES (
NULL , '', 'CANM-00024', 'Clinicalannotation', 'EventDetail', '', 'file_name', 'Picture', '', 'file', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''
);

INSERT INTO `structure_formats` (
`id` ,
`old_id` ,
`structure_id` ,
`structure_old_id` ,
`structure_field_id` ,
`structure_field_old_id` ,
`display_column` ,
`display_order` ,
`language_heading` ,
`flag_override_label` ,
`language_label` ,
`flag_override_tag` ,
`language_tag` ,
`flag_override_help` ,
`language_help` ,
`flag_override_type` ,
`type` ,
`flag_override_setting` ,
`setting` ,
`flag_override_default` ,
`default` ,
`flag_add` ,
`flag_add_readonly` ,
`flag_edit` ,
`flag_edit_readonly` ,
`flag_search` ,
`flag_search_readonly` ,
`flag_datagrid` ,
`flag_datagrid_readonly` ,
`flag_index` ,
`flag_detail` ,
`created` ,
`created_by` ,
`modified` ,
`modified_by`
)
VALUES (
NULL , 'CAN-999-999-000-999-65_CANM-00024', '144', 'CAN-999-999-000-999-65', '908', 'CANM-00024', '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''
);

