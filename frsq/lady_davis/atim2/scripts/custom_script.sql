UPDATE sample_controls SET status='disabled' WHERE id IN(1, 4, 103, 104, 112, 113);
UPDATE parent_to_derivative_sample_controls SET status='disabled' WHERE id IN(3, 8, 9, 23, 24, 25, 118);
UPDATE sample_to_aliquot_controls SET status='disabled' WHERE id IN(23, 2, 3);

TRUNCATE misc_identifier_controls;
INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `autoincrement_name`, `display_order`, `misc_identifier_format`) VALUES
(NULL, 'biopsy', '', 'active', 'main_participant_id', 0, 'B %%key_increment%%'),
(NULL, 'metastasis', '', 'active', 'main_participant_id', 1, 'M %%key_increment%%'),
(NULL, 'tumor', '', 'active', 'main_participant_id', 2, 'T %%key_increment%%'),
(NULL, 'RAMQ', '', 'active', '', 3, ''),
(NULL, 'JGH #', '', 'active', '', 4, ''),
(NULL, 'Sardo #', '', 'active', '', 5, ''),
(NULL, 'Breast bank #', '', 'active', '', 6, '');

TRUNCATE TABLE key_increments;

#TODO adjust starting value with their highest value
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('main_participant_id', 1000);

INSERT INTO `structure_permissible_values` (
`id` ,`value` ,`language_alias`) VALUES
(NULL , 'biopsy', 'biopsy'), 
(NULL , 'metastasis', 'metastasis'),
(NULL , 'tumor', 'tumor');

SET @last_pv_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains` (
`id` ,`domain_name` ,`override` ,`category`)
VALUES (
NULL , 'qc_lady_coll_type', 'open', ''
);

SET @last_id = LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values`  (
`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`)
VALUES 
(NULL , @last_id, @last_pv_id, '1', 'yes', ''),
(NULL , @last_id, @last_pv_id + 1, '2', 'yes', ''),
(NULL , @last_id, @last_pv_id + 2, '3', 'yes', '');


INSERT INTO `structure_fields` (
`id` ,`public_identifier` ,`old_id` ,`plugin` ,`model` ,`tablename` ,`field` ,`language_label` ,`language_tag` ,`type` ,`setting` ,`default` ,`structure_value_domain` ,`language_help` ,`validation_control` ,`value_domain_control` ,`field_control` ,`created` ,`created_by` ,`modified` ,`modified_by`)
VALUES (NULL , '', 'qc-lady-00001', 'Inventorymanagement', 'Collection', '', 'qc_lady_type', 'type', '', 'select', '', '', @last_id , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (
`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1000_qc-lady-00001', '31', 'CAN-999-999-000-999-1000', @last_id, 'qc-lady-00001', '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

ALTER TABLE collections	ADD COLUMN qc_lady_type VARCHAR(10) DEFAULT '';
ALTER TABLE collections_revs ADD COLUMN qc_lady_type VARCHAR(10) DEFAULT '';
	
	
	
#--------------------------------------------------
INSERT INTO `structure_permissible_values` (
`id` ,`value` ,`language_alias`) VALUES
(NULL , '6 months', '6 months'), 
(NULL , '12 months', '12 months'),
(NULL , '18 months', '18 months'),
(NULL , '5 years', '5 years'),
(NULL , '6 years', '6 years');

SET @last_pv_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains` (
`id` ,`domain_name` ,`override` ,`category`)
VALUES (
NULL , 'qc_lady_coll_follow_up', 'open', ''
);

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values`  (
`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`)
VALUES
(NULL , @last_id, (SELECT id FROM structure_permissible_values WHERE value='surgery' AND language_alias='surgery'), '1', 'yes', ''), 
(NULL , @last_id, @last_pv_id, '1', 'yes', ''),
(NULL , @last_id, @last_pv_id + 1, '2', 'yes', ''),
(NULL , @last_id, @last_pv_id + 2, '3', 'yes', ''),
(NULL , @last_id, @last_pv_id + 3, '4', 'yes', ''),
(NULL , @last_id, @last_pv_id + 4, '5', 'yes', '');


INSERT INTO `structure_fields` (
`id` ,`public_identifier` ,`old_id` ,`plugin` ,`model` ,`tablename` ,`field` ,`language_label` ,`language_tag` ,`type` ,`setting` ,`default` ,`structure_value_domain` ,`language_help` ,`validation_control` ,`value_domain_control` ,`field_control` ,`created` ,`created_by` ,`modified` ,`modified_by`)
VALUES (NULL , '', 'qc-lady-00002', 'Inventorymanagement', 'Collection', '', 'qc_lady_follow_up', 'follow up', '', 'select', '', '', @last_id , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (
`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1000_qc-lady-00002', '31', 'CAN-999-999-000-999-1000', @last_id, 'qc-lady-00002', '1', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
#INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CANM-00025_qc-lady-00001', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00001'), 'qc-lady-00001', '1', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '', '', '', '');
#INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CANM-00025_qc-lady-00002', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00002'), 'qc-lady-00002', '1', '101', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '', '', '', '');


ALTER TABLE collections ADD COLUMN qc_lady_follow_up VARCHAR(10) DEFAULT '';
ALTER TABLE collections_revs ADD COLUMN qc_lady_follow_up VARCHAR(10) DEFAULT '';
	
UPDATE structure_value_domains_permissible_values SET active='no' WHERE structure_permissible_value_id IN(768, 769);
UPDATE structure_permissible_values SET value='JGH', language_alias='JGH' WHERE id=767;
UPDATE `structure_fields` SET `default` = 'JGH' WHERE `structure_fields`.`id` =155 LIMIT 1;

UPDATE structure_value_domains_permissible_values SET active='no' WHERE id IN(595, 596, 597, 598);
INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('CTAD', 'CTAD'),
('P100', 'P100');

SET @last_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains_permissible_values (`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`) VALUES
(NULL, 140, 619, 5, 'yes', ''),
(NULL, 140, @last_id, 6, 'yes', ''),
(NULL, 140, @last_id + 1, 7, 'yes', '');

#supplier department
UPDATE structure_value_domains_permissible_values SET language_alias='' WHERE id IN(937, 938, 939);
UPDATE structure_permissible_values SET value='CRU', language_alias='CRU' WHERE id=773;
UPDATE structure_permissible_values SET value='Patho', language_alias='Patho' WHERE id=774;
UPDATE structure_permissible_values SET value='oncology', language_alias='Oncology' WHERE id=775;
INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('test center', 'test center');

SET @last_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains_permissible_values (`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`) VALUES
(NULL, 175, (SELECT id FROM structure_permissible_values WHERE `value`='operating room' AND `language_alias`='operating room'), 4, 'yes', ''),
(NULL, 175, @last_id, 5, 'yes', '');


#taken delivery by
UPDATE structure_value_domains_permissible_values SET language_alias='' WHERE structure_value_domain_id=174;
UPDATE structure_value_domains_permissible_values SET active='no' WHERE id=936;
UPDATE structure_permissible_values SET value='Adriana Aguilar', language_alias='Adriana Aguilar' WHERE id=770;
UPDATE structure_permissible_values SET value='Marguerite Buchanan', language_alias='Marguerite Buchanan' WHERE id=771;

#checkbox for tissue from biopsy
ALTER TABLE `sd_spe_tissues` ADD `qc_lady_from_biopsy` TINYINT UNSIGNED NOT NULL AFTER `deleted_date`;
ALTER TABLE `sd_spe_tissues_revs` ADD `qc_lady_from_biopsy` TINYINT UNSIGNED NOT NULL AFTER `deleted_date`;
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'qc-lady-00003', 'Inventorymanagement', 'SampleDetail', '', 'qc_lady_from_biopsy', 'from biopsy', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @last_id = LAST_INSERT_ID();
UPDATE structure_formats SET display_order=display_order + 2 WHERE old_id='CAN-999-999-000-999-1008' AND display_column=1 AND display_order > 44;
INSERT INTO `structure_formats` (
`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CAN-999-999-000-999-1008_qc-lady-00003', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', @last_id, 'qc-lady-0003', '0', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `i18n` (
`id` , `page_id` , `en` , `fr`)
VALUES ('from biopsy', 'global', 'From biopsy', 'À partir d\'une biopsie');

#dna storage solution
INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('TE BUffer', 'TE Buffer');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains` (`id` ,`domain_name` ,`override` ,`category`)
VALUES (NULL , 'qc_lady_dna_storage_solution', 'open', '');

SET @s_v_d_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains_permissible_values (`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`) VALUES
(NULL, @s_v_d_id, @last_id, 1, 'yes', ''),
(NULL, @s_v_d_id, 37, 2, 'yes', '');#other

ALTER TABLE `sd_der_dnas` ADD `qc_lady_storage_solution` VARCHAR( 10 ) NOT NULL AFTER `deleted_date`;
ALTER TABLE `sd_der_dnas_revs` ADD `qc_lady_storage_solution` VARCHAR( 10 ) NOT NULL AFTER `deleted_date`; 

INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'qc-lady-00004', 'qc_lady_sd_der_dnas', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_formats (id,old_id,structure_id,structure_old_id,structure_field_id,structure_field_old_id,display_column,display_order,language_heading,flag_override_label,language_label,flag_override_tag,language_tag,flag_override_help,language_help,flag_override_type,type,flag_override_setting,setting,flag_override_default,`default`,flag_add,flag_add_readonly,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail,created,created_by,modified,modified_by)
(SELECT NULL,CONCAT('qc-lady-00004_', structure_field_old_id), @last_structure_id,'qc-lady-00004',structure_field_id,structure_field_old_id,display_column,display_order,language_heading,flag_override_label,language_label,flag_override_tag,language_tag,flag_override_help,language_help,flag_override_type,type,flag_override_setting,setting,flag_override_default, `default`,flag_add,flag_add_readonly,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail,created,created_by,modified,modified_by FROM structure_formats where structure_id=41);

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'qc-lady-00005', 'Inventorymanagement', 'AliquotDetail', '', 'qc_lady_storage_solution', 'storage solution', '', 'select', '', '', @s_v_d_id , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'qc-lady-00004_qc-lady-00005', @last_structure_id, 'qc-lady-00004', @last_id, 'qc-lady-00005', '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `sample_controls` SET `form_alias` = 'qc_lady_sd_der_dnas' WHERE `sample_controls`.`id` =12 LIMIT 1 ;

#storages
UPDATE storage_controls SET status='disabled' WHERE id NOT IN(10, 17);
INSERT INTO `storage_controls` (`id` ,`storage_type` ,`storage_type_code` ,`coord_x_title` ,`coord_x_type` ,`coord_x_size` ,`coord_y_title` ,`coord_y_type` ,`coord_y_size` , `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `set_temperature` ,`is_tma_block` ,`status` ,`form_alias` ,`form_alias_for_children_pos` ,`detail_tablename`) VALUES 
(NULL , 'box100 1-100', 'B1T100', 'position', 'integer', NULL , NULL , NULL , NULL , '10', '10', 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs'),
(NULL , 'freezer 6x5', 'F6X5', 'column', 'integer', '6', 'row', 'integer', '5', '0', '0', 0, 0, 'TRUE', 'FALSE', 'active', 'std_undetail_stg_with_tmp', 'std_2_dim_position_selection', 'std_freezers'),
(NULL , 'rack 4x4', 'R4X4', 'column', 'integer', '4', 'row', 'integer', '4', '0', '0', 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_2_dim_position_selection', 'std_racks'),
(NULL , 'freezer 4x5', 'F4X5', 'column', 'integer', '5', 'row', 'integer', '4', '0', '0', 0, 0, 'TRUE', 'FALSE', 'active', 'std_undetail_stg_with_tmp', 'std_2_dim_position_selection', 'std_freezers'),
(NULL , 'freezer vertical 4x3', '', 'column', 'integer', '4', 'row', 'integer', '3', '0', '0', 0, 0, 'TRUE', 'FALSE', 'active', 'std_undetail_stg_with_tmp', 'std_2_dim_position_selection', 'std_freezers'),
(NULL , 'rack 1-12', 'R1T12', 'position', 'integer', '12', NULL , NULL , NULL , '0', '0', 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_racks');
INSERT INTO `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES 
('freezer 6x5', 'global', 'Freezer 6x5', 'Congélateur 6x5'),
('rack 4x4', 'global', 'Rack 4x4', 'Étagère 4x4'),
('freezer 4x5', 'global', 'Freezer 4x5', 'Congélateur 4x5'),
('freezer vertical 4x3', 'global', 'Vertical freezer 4x3', 'Congélateur vertical 4x3'),
('rack 1-12', 'global', 'Rack 1-12', 'Étagère 1-12');
INSERT INTO `storage_masters` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(NULL, 'F6X5 - 1', 'freezer 6x5', 22, NULL, 39, 40, '#6 Revco', '#6', '#6', '', NULL, NULL, NULL, NULL, 'TRUE', -80.00, 'celsius', '', '2010-02-16 10:33:13', '1', '2010-02-16 10:33:14', '1', 0, NULL),
(NULL, 'F4X5 - 2', 'freezer 4x5', 24, NULL, 41, 42, '#85 VWR Symphony', '#85', '#85', '', NULL, NULL, NULL, NULL, 'TRUE', -80.00, 'celsius', '', '2010-02-16 10:52:05', '1', '2010-02-16 10:52:05', '1', 0, NULL),
(NULL, ' - 3', 'freezer vertical 4x3', 25, NULL, 43, 44, 'NVE Tech 3000', 'NVE3000', 'NVE3000', '', NULL, NULL, NULL, NULL, 'TRUE', -190.00, 'celsius', '', '2010-02-16 10:52:57', '1', '2010-02-16 10:52:57', '1', 0, NULL);


#tissue type
INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('TBR', 'TBR'),
('NBR', 'NBR');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains` (`id` ,`domain_name` ,`override` ,`category`)
VALUES (NULL , 'qc_lady_tissue_type', 'open', '');

SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains_permissible_values (`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`) VALUES
(NULL, @last_structure_id, @last_id, 1, 'yes', ''),
(NULL, @last_structure_id, @last_id + 1, 2, 'yes', '');

ALTER TABLE `sd_spe_tissues` ADD `qc_lady_tissue_type` CHAR(3) NOT NULL AFTER `deleted_date`;
ALTER TABLE `sd_spe_tissues_revs` ADD `qc_lady_tissue_type` CHAR(3) NOT NULL AFTER `deleted_date`;

INSERT INTO `structure_fields` (`id` ,`public_identifier` ,`old_id` ,`plugin` ,`model` ,`tablename` ,`field` ,`language_label` ,`language_tag` ,`type` ,`setting` ,`default` ,`structure_value_domain` ,`language_help` ,`validation_control` ,`value_domain_control` ,`field_control` ,`created` ,`created_by` ,`modified` ,`modified_by`)
VALUES (NULL , '', 'qc-lady-00006', 'Inventorymanagement', 'SampleDetail', '', 'qc_lady_tissue_type', 'tissue type', '', 'select', '', '', @last_structure_id , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1008_qc-lady-00006', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', @last_id, 'qc-lady-00006', '0', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

#end tissue type

#aliquot label
INSERT INTO `structure_fields` (`id` ,`public_identifier` ,`old_id` ,`plugin` ,`model` ,`tablename` ,`field` ,`language_label` ,`language_tag` ,`type` ,`setting` ,`default` ,`structure_value_domain` ,`language_help` ,`validation_control` ,`value_domain_control` ,`field_control` ,`created` ,`created_by` ,`modified` ,`modified_by`)
VALUES (NULL , '', 'qc-lady-00007', 'Inventorymanagement', 'AliquotMaster', '', 'qc_lady_label', 'label', '', 'input', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1022_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1022'), 'CAN-999-999-000-999-1022', @last_id, 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1028_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00007'), 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1057_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1057'), 'CAN-999-999-000-999-1057', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00007'), 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1029_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1029'), 'CAN-999-999-000-999-1029', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00007'), 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1065_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1065'), 'CAN-999-999-000-999-1065', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00007'), 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1054_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1054'), 'CAN-999-999-000-999-1054', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00007'), 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1032_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1032'), 'CAN-999-999-000-999-1032', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00007'), 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES (NULL , 'CAN-999-999-000-999-1024_qc-lady-00007', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1024'), 'CAN-999-999-000-999-1024', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00007'), 'qc-lady-00007', '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


#end aliquot label

#dna extraction method
ALTER TABLE `sd_der_dnas` ADD `qc_lady_extraction_method` VARCHAR( 20 ) NOT NULL;
ALTER TABLE `sd_der_dnas_revs` ADD `qc_lady_extraction_method` VARCHAR( 20 ) NOT NULL;
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_lady_dna_extraction_method', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('QUAIAMP Kit', 'QUAIAMP Kit');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_extraction_method'),  (SELECT id FROM structure_permissible_values WHERE value='QUAIAMP Kit' AND language_alias='QUAIAMP Kit'), '1', 'yes');
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'qc-lady-00008', 'Inventorymanagement', 'SampleDetail', '', 'qc_lady_extraction_method', 'extraction method', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_extraction_method'), '', '', '', '');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('qc-lady-00004_qc-lady-00008', (SELECT id FROM structures WHERE old_id = 'qc-lady-00004'), 'qc-lady-00004', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00008'), 'qc-lady-00008', '0', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '', '1', '', '0', '', '1', '', '0', '1', '', '', '', '');
#end dna extraction method

#double EDTA centrifugation (need new blood control)
ALTER TABLE `sd_der_plasmas` ADD `qc_lady_double_centrifugation` TINYINT UNSIGNED NOT NULL AFTER `deleted_date`;
ALTER TABLE `sd_der_plasmas_revs` ADD `qc_lady_double_centrifugation` TINYINT UNSIGNED NOT NULL AFTER `deleted_date`;
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'qc-lady-00009', 'Inventorymanagement', 'SampleDetail', '', 'qc_lady_double_centrifugation', 'double centrifugation', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1014_qc-lady-00009', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1014'), 'CAN-999-999-000-999-1014', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00009'), 'qc-lady-00009', '1', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '', '', '', '');

INSERT INTO `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES 
('double centrifugation', 'global', 'Double centrifugation', 'Centrifugation double');
#end double EDTA centrigugation


#coagulation time
ALTER TABLE `sd_der_serums` ADD `qc_lady_coagulation_time_sec` SMALLINT UNSIGNED NOT NULL AFTER `deleted_date`;
ALTER TABLE `sd_der_serums_revs` ADD `qc_lady_coagulation_time_sec` SMALLINT UNSIGNED NOT NULL AFTER `deleted_date`;
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'qc-lady-00010', 'Inventorymanagement', 'SampleDetail', '', 'qc_lady_coagulation_time_sec', 'coagulation time (sec)', '', 'input', '', '', NULL, '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1015_qc-lady-00010', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1015'), 'CAN-999-999-000-999-1015', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00010'), 'qc-lady-00010', '1', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '', '', '', '');
INSERT INTO `i18n` (`id` , `page_id` , `en` , `fr`)
VALUES ('coagulation time (sec)', 'global', 'Coagulation time (sec.)', 'Temps de coagulation (sec.)');

#end coagulation time

#tissue tube storage solution
ALTER TABLE `ad_tubes` ADD `qc_lady_storage_solution` VARCHAR( 10 ) NOT NULL AFTER `deleted_date`;
ALTER TABLE `ad_tubes_revs` ADD `qc_lady_storage_solution` VARCHAR( 10 ) NOT NULL AFTER `deleted_date`;
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('qc_lady_tissue_tube_storage_solution', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('RNA later', 'rna later');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_solution'),  (SELECT id FROM structure_permissible_values WHERE value='RNA later' AND language_alias='rna later'), '1', 'yes');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('OCT', 'OCT');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_solution'),  (SELECT id FROM structure_permissible_values WHERE value='OCT' AND language_alias='OCT'), '2', 'yes');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('flash freeze', 'flash freeze');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_solution'),  (SELECT id FROM structure_permissible_values WHERE value='flash freeze' AND language_alias='flash freeze'), '3', 'yes');

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'qc-lady-00011', 'Inventorymanagement', 'AliquotDetail', '', 'qc_lady_storage_solution', 'contains', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_solution'), '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1022_qc-lady-00011', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1022'), 'CAN-999-999-000-999-1022', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00011'), 'qc-lady-00011', '1', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '', '', '', '');

INSERT INTO structures(`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc-lady-00014', 'ad_der_tubes_qc_lady_dnas', '', '', '', '', '', '');
INSERT IGNORE INTO structure_formats (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) (SELECT CONCAT('qc-lady-00014_', `structure_field_old_id`), (SELECT id FROM structures WHERE old_id='qc-lady-00014'), 'qc-lady-00014', `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail` FROM structure_formats WHERE structure_old_id='CAN-999-999-000-999-1054');
#there is double field, insert it
INSERT INTO structure_formats (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) (SELECT CONCAT('qc-lady-00014_', `structure_field_old_id`, '_902'), (SELECT id FROM structures WHERE old_id='qc-lady-00014'), 'qc-lady-00014', `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail` FROM structure_formats WHERE old_id='CAN-999-999-000-999-1054_CAN-999-999-000-999-1131_902');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('qc-lady-00014_qc-lady-00005', (SELECT id FROM structures WHERE old_id = 'qc-lady-00014'), 'qc-lady-00014', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00005'), 'qc-lady-00005', '1', '99', '', '', '', '', '', '', '', '', 'select', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '', '', '', '');
INSERT INTO `aliquot_controls` (`id` ,`aliquot_type` ,`status` ,`form_alias` ,`detail_tablename` ,`volume_unit` ,`comment` ,`display_order`) VALUES (NULL , 'tube', 'active', 'ad_der_tubes_qc_lady_dnas', 'ad_tubes', 'ml', 'derivative tube specifid to dna', '0');
SET @last_id = LAST_INSERT_ID();
UPDATE sample_to_aliquot_controls SET aliquot_control_id=@last_id WHERE sample_control_id=12 AND aliquot_control_id=11;
#end tissue tube contains

INSERT INTO `i18n` (`id` , `page_id` , `en` , `fr`) VALUES
('an identifier of this type already exists for the current participant.', 'global', 'An identifier of this type already exists for the current participant.', 'Un identifiant de ce type existe d�j� pour ce participant.'),
('metastatis', 'global', 'Metastasis', 'Métastases');

#default bank
UPDATE structure_fields SET `default`='1' WHERE old_id='CAN-999-999-000-999-1223';
UPDATE `banks` SET `name` =  'breast', `description` = '' WHERE `banks`.`id` =1 LIMIT 1 ;
INSERT INTO `structure_validations` (`id` , `old_id` , `structure_field_id` , `structure_field_old_id` , `rule` , `flag_empty` , `flag_required` , `on_action` , `language_message` , `created` , `created_by` , `modified` , `modified_by`) VALUES 
(NULL , 'qc-lady-00011', (SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

#redefine collection view
DROP VIEW view_collections;
CREATE VIEW view_collections AS 
SELECT collection_id, bank_id, sop_master_id, ccl.participant_id, diagnosis_master_id, consent_master_id, acquisition_label, collection_site, collection_datetime, collection_datetime_accuracy, collection_property, collection_notes, collections.deleted, 
collections.deleted_date,identifier_value AS participant_identifier, banks.name AS bank_name,sops.title AS sop_title, sops.code AS sop_code, sops.version AS sop_version, sop_group,
sops.type, qc_lady_type, qc_lady_follow_up 
FROM collections
LEFT JOIN clinical_collection_links AS ccl ON collections.id=ccl.collection_id AND ccl.deleted != 1
LEFT JOIN participants ON ccl.participant_id=participants.id AND participants.deleted != 1
LEFT JOIN banks ON collections.bank_id=banks.id AND banks.deleted != 1
LEFT JOIN sop_masters AS sops ON collections.sop_master_id=sops.id AND sops.deleted != 1
LEFT JOIN misc_identifiers AS mi ON mi.participant_id = participants.id AND LOWER(SUBSTRING(mi.identifier_value, 1, 1))= LOWER(SUBSTRING(collections.qc_lady_type, 1, 1));

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'qc-lady-00012', 'Inventorymanagement', 'ViewCollection', '', 'qc_lady_type', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_type'), '', 'open', 'open', 'open');
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'qc-lady-00013', 'Inventorymanagement', 'ViewCollection', '', 'qc_lady_follow_up', 'follow up', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_follow_up'), '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CANM-00025_qc-lady-00012', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00012'), 'qc-lady-00012', '1', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '', '', '', '');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CANM-00025_qc-lady-00013', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00013'), 'qc-lady-00013', '1', '101', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '', '', '', '');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1001_qc-lady-00002', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00002'), 'qc-lady-00002', '1', '101', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '', '', '', '');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1001_qc-lady-00001', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00001'), 'qc-lady-00001', '1', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '', '', '', '');

#remove invalid block types
UPDATE structure_value_domains_permissible_values SET active='no' WHERE id IN(8, 10);
UPDATE structure_fields SET `default`='paraffin' WHERE old_id='CAN-999-999-000-999-1135';

#change application header
REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('core_appname', 'global', 'ATiM.v2 - L.D.', 'ATiM.v2 - L.D.'),
('CTRApp', 'global', 'ATiM.v2 - L.D.', 'ATiM.v2 - L.D.');

ALTER TABLE consent_masters
	ADD biological_material_use tinyint unsigned NOT NULL DEFAULT 0,
	ADD	use_of_blood tinyint unsigned NOT NULL DEFAULT 0,
	ADD	use_of_urine tinyint unsigned NOT NULL DEFAULT 0,
	ADD	contact_for_additional_data tinyint unsigned NOT NULL DEFAULT 0,
	ADD	allow_questionnaire tinyint unsigned NOT NULL DEFAULT 0,
	ADD	inform_significant_discovery tinyint unsigned NOT NULL DEFAULT 0,
	ADD	research_other_disease tinyint unsigned NOT NULL DEFAULT 0,
	ADD	inform_discovery_on_other_disease tinyint unsigned NOT NULL DEFAULT 0;

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'qc-lady-00015', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'biological_material_use', 'biological material use', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00016', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'use_of_blood', 'use of blood', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00017', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'use_of_urine', 'use of urine', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00018', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'contact_for_additional_data', 'contact for additional data', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00019', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'allow_questionnaire', 'allow questionnaire', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00020', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'inform_significant_discovery', 'inform significant discovery', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00021', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'research_other_disease', 'research other disease', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00022', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'inform_discovery_on_other_disease', 'inform discovery on other disease', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open');

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-046-003-000-002-29', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-002-29'), 'CAN-046-003-000-002-29', '2', '4', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='2', display_order='4', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-046-003-000-999-1', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-1'), 'CAN-046-003-000-999-1', '1', '5', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='5', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-046-003-000-999-5', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-5'), 'CAN-046-003-000-999-5', '2', '2', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='2', display_order='2', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-046-003-000-999-6', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-6'), 'CAN-046-003-000-999-6', '2', '1', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='2', display_order='1', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-046-003-000-999-7', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-7'), 'CAN-046-003-000-999-7', '2', '3', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='2', display_order='3', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-123', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-123'), 'CAN-123', '1', '6', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='6', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-124', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-124'), 'CAN-124', '1', '10', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='10', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-763', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-763'), 'CAN-763', '1', '3', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='3', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-999-999-000-999-53', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-53'), 'CAN-999-999-000-999-53', '1', '6', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='6', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-999-999-000-999-56', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-56'), 'CAN-999-999-000-999-56', '1', '12', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='12', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-999-999-000-999-57', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-57'), 'CAN-999-999-000-999-57', '1', '4', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='4', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-804', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-804'), 'CAN-804', '1', '2', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='2', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-999-999-000-999-61', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-61'), 'CAN-999-999-000-999-61', '1', '7', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='7', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-807', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-807'), 'CAN-807', '1', '9', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='9', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-808', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-808'), 'CAN-808', '1', '11', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='11', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-999-999-000-999-65', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-65'), 'CAN-999-999-000-999-65', '1', '50', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='50', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_CAN-999-999-000-999-66', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-66'), 'CAN-999-999-000-999-66', '1', '8', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0') ON DUPLICATE KEY UPDATE display_column='1', display_order='8', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00015', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00015'), 'qc-lady-00015', '2', '13', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='13', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00016', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00016'), 'qc-lady-00016', '2', '14', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='14', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00017', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00017'), 'qc-lady-00017', '2', '15', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='15', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00018', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00018'), 'qc-lady-00018', '2', '16', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='16', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00019', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00019'), 'qc-lady-00019', '2', '17', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='17', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00020', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00020'), 'qc-lady-00020', '2', '18', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='18', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00021', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00021'), 'qc-lady-00021', '2', '19', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='19', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00022', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00022'), 'qc-lady-00022', '2', '20', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='20', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;


REPLACE INTO `i18n` (`id` , `page_id` , `en` , `fr`) VALUES
('biological material use', 'global', 'Biological material use?', 'Utilisation de matériel biologique?'),
('contact for additional data', 'global', 'Contact for additional data?', 'Contacter pour données aditionnelles?'),
('allow questionnaire', 'global', 'Allow questionaire?', 'Permettre le questionnaire?'),
('inform discovery on other disease', 'global', 'Inform discovery on other disease?', "Informer des découvertes sur d'autres maladies?");