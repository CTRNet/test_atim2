UPDATE sample_controls SET status='disabled' WHERE id IN(1, 4, 103, 104, 112, 113);
UPDATE parent_to_derivative_sample_controls SET status='disabled' WHERE id IN(3, 8, 9, 23, 24, 25, 118);
UPDATE sample_to_aliquot_controls SET status='disabled' WHERE id IN(23, 2, 3);

TRUNCATE misc_identifier_controls;
INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `autoincrement_name`, `display_order`, `misc_identifier_format`) VALUES
(NULL, 'biopsy', '', 'active', 'main_participant_id', 0, 'B %%key_increment%%'),
(NULL, 'metastasis', '', 'active', 'main_participant_id', 1, 'M %%key_increment%%'),
(NULL, 'normal', '', 'active', 'main_participant_id', 2, 'N %%key_increment%%'),
(NULL, 'tumor', '', 'active', 'main_participant_id', 3, 'T %%key_increment%%'),
(NULL, 'RAMQ', '', 'active', '', 4, ''),
(NULL, 'JGH #', '', 'active', '', 5, ''),
(NULL, 'Sardo #', '', 'active', '', 6, ''),
(NULL, 'Breast bank #', '', 'active', '', 7, '');

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
(NULL , @last_id, (SELECT id FROM structure_permissible_values WHERE value='normal' AND language_alias='normal'), '2', 'yes', ''),
(NULL , @last_id, @last_pv_id + 2, '4', 'yes', '');


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

INSERT INTO `structure_validations` (`id` ,`old_id` ,`structure_field_id` ,`structure_field_old_id` ,`rule` ,`flag_empty` ,`flag_required` ,`on_action` ,`language_message` ,`created` ,`created_by` ,`modified` ,`modified_by`)VALUES (NULL , 'qc-lady-00024', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00002'), 'qc-lady-00002', 'custom,/^([0-9]+)?$/', '1', '0', '', 'invalid value', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '' );


ALTER TABLE collections ADD COLUMN qc_lady_follow_up SMALLINT UNSIGNED DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN qc_lady_follow_up SMALLINT UNSIGNED DEFAULT NULL;


	
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
('test center', 'test center'),
('breast center', 'breast center');

SET @last_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains_permissible_values (`id` ,`structure_value_domain_id` ,`structure_permissible_value_id` ,`display_order` ,`active` ,`language_alias`) VALUES
(NULL, 175, (SELECT id FROM structure_permissible_values WHERE `value`='operating room' AND `language_alias`='operating room'), 4, 'yes', ''),
(NULL, 175, @last_id, 5, 'yes', ''),
(NULL, 175, @last_id + 1, 6, 'yes', '');


#taken delivery by
UPDATE structure_value_domains_permissible_values SET language_alias='' WHERE structure_value_domain_id=174;
UPDATE structure_permissible_values SET value='Adriana Aguilar', language_alias='Adriana Aguilar' WHERE id=770;
UPDATE structure_permissible_values SET value='Marguerite Buchanan', language_alias='Marguerite Buchanan' WHERE id=771;
UPDATE structure_permissible_values SET value='Zuanel Diaz', language_alias='Zuanel Diaz' WHERE id=772;

#checkbox for tissue from biopsy
ALTER TABLE `sd_spe_tissues` 
	ADD `qc_lady_from_biopsy` TINYINT UNSIGNED NOT NULL AFTER `deleted_date`,
	ADD `qc_lady_from_surgery` TINYINT UNSIGNED NOT NULL;
ALTER TABLE `sd_spe_tissues_revs` 
	ADD `qc_lady_from_biopsy` TINYINT UNSIGNED NOT NULL AFTER `deleted_date`,
	ADD `qc_lady_from_surgery` TINYINT UNSIGNED NOT NULL;
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'qc-lady-00003', 'Inventorymanagement', 'SampleDetail', '', 'qc_lady_from_biopsy', 'from biopsy', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @last_id = LAST_INSERT_ID();
UPDATE structure_formats SET display_order=display_order + 2 WHERE old_id='CAN-999-999-000-999-1008' AND display_column=1 AND display_order > 44;
INSERT INTO `structure_formats` (
`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CAN-999-999-000-999-1008_qc-lady-00003', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', @last_id, 'qc-lady-00003', '0', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


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
INSERT INTO `storage_masters` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(NULL, 'F6X5 - 1', 'freezer 6x5', 22, NULL, 39, 40, '#6 Revco', '#6', '#6', '', NULL, NULL, NULL, NULL, 'TRUE', -80.00, 'celsius', '', '2010-02-16 10:33:13', '1', '2010-02-16 10:33:14', '1', 0, NULL),
(NULL, 'F4X5 - 2', 'freezer 4x5', 24, NULL, 41, 42, '#85 VWR Symphony', '#85', '#85', '', NULL, NULL, NULL, NULL, 'TRUE', -80.00, 'celsius', '', '2010-02-16 10:52:05', '1', '2010-02-16 10:52:05', '1', 0, NULL),
(NULL, 'FV4X3 - 3', 'freezer vertical 4x3', 25, NULL, 43, 44, 'NVE Tech 3000', 'NVE3000', 'NVE3000', '', NULL, NULL, NULL, NULL, 'TRUE', -190.00, 'celsius', '', '2010-02-16 10:52:57', '1', '2010-02-16 10:52:57', '1', 0, NULL);

#disable unused storages
UPDATE structure_value_domains_permissible_values AS svdpv 
INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id
SET active='no' 
WHERE structure_value_domain_id='146' AND `value` NOT IN (SELECT storage_type FROM storage_controls WHERE status='active');
#create missing ones
INSERT INTO structure_permissible_values (`value`, language_alias) (SELECT storage_type, storage_type FROM storage_controls WHERE status='active' AND storage_type NOT IN(SELECT `value` FROM structure_permissible_values)); 
#activate them
INSERT INTO structure_value_domains_permissible_values(structure_value_domain_id, structure_permissible_value_id, active) (SELECT '146', id, 'yes' FROM structure_permissible_values WHERE id >= LAST_INSERT_ID());

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

#end double EDTA centrigugation


#coagulation time
ALTER TABLE `sd_der_serums` ADD `qc_lady_coagulation_time_sec` SMALLINT UNSIGNED NOT NULL AFTER `deleted_date`;
ALTER TABLE `sd_der_serums_revs` ADD `qc_lady_coagulation_time_sec` SMALLINT UNSIGNED NOT NULL AFTER `deleted_date`;
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'qc-lady-00010', 'Inventorymanagement', 'SampleDetail', '', 'qc_lady_coagulation_time_sec', 'coagulation time (sec)', '', 'input', '', '', NULL, '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('CAN-999-999-000-999-1015_qc-lady-00010', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1015'), 'CAN-999-999-000-999-1015', (SELECT id FROM structure_fields WHERE old_id = 'qc-lady-00010'), 'qc-lady-00010', '1', '100', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '', '', '', '');
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
	ADD	contact_for_additional_data tinyint unsigned NOT NULL DEFAULT 0,
	ADD	allow_questionnaire tinyint unsigned NOT NULL DEFAULT 0,
	ADD	inform_significant_discovery tinyint unsigned NOT NULL DEFAULT 0,
	ADD	research_other_disease tinyint unsigned NOT NULL DEFAULT 0,
	ADD	inform_discovery_on_other_disease tinyint unsigned NOT NULL DEFAULT 0,
	ADD `consent_type` VARCHAR( 50 ) NOT NULL;

ALTER TABLE consent_masters_revs
	ADD biological_material_use tinyint unsigned NOT NULL DEFAULT 0,
	ADD	use_of_blood tinyint unsigned NOT NULL DEFAULT 0,
	ADD	contact_for_additional_data tinyint unsigned NOT NULL DEFAULT 0,
	ADD	allow_questionnaire tinyint unsigned NOT NULL DEFAULT 0,
	ADD	inform_significant_discovery tinyint unsigned NOT NULL DEFAULT 0,
	ADD	research_other_disease tinyint unsigned NOT NULL DEFAULT 0,
	ADD	inform_discovery_on_other_disease tinyint unsigned NOT NULL DEFAULT 0,
	ADD `consent_type` VARCHAR( 50 ) NOT NULL;

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'qc-lady-00015', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'biological_material_use', 'biological material use', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00016', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'use_of_blood', 'use of blood', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00018', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'contact_for_additional_data', 'contact for additional data', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00019', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'allow_questionnaire', 'allow questionnaire', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00020', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'inform_significant_discovery', 'inform significant discovery', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00021', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'research_other_disease', 'research other disease', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open'), ('', 'qc-lady-00022', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'inform_discovery_on_other_disease', 'inform discovery on other disease', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open');

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

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00018', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00018'), 'qc-lady-00018', '2', '16', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='16', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00019', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00019'), 'qc-lady-00019', '2', '17', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='17', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00020', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00020'), 'qc-lady-00020', '2', '18', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='18', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00021', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00021'), 'qc-lady-00021', '2', '19', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='19', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00022', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00022'), 'qc-lady-00022', '2', '20', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '', '1', '', '1', '', '1', '1', '', '1') ON DUPLICATE KEY UPDATE display_column='2', display_order='20', language_heading='', `flag_override_label`=0, `language_label`='', `flag_override_tag`=0, `language_tag`='', `flag_override_help`=0, `language_help`='', `flag_override_type`=0, `type`='', `flag_override_setting`=0, `setting`='', `flag_override_default`=0, `default`='' ;

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'qc-lady-00024', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'qc_lady_from_surgery', 'from surgery', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'), '', 'open', 'open', 'open');
UPDATE structure_formats SET display_column='0', display_order='6', language_heading='', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-1008_CAN-999-999-000-999-1016' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008') AND structure_old_id='CAN-999-999-000-999-1008' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-1016') AND structure_field_old_id='CAN-999-999-000-999-1016';
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-1008_qc-lady-00024', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00024'), 'qc-lady-00024', '0', '50', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1') ;
UPDATE structure_formats SET display_column='0', display_order='46', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-1008_qc-lady-00024' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008') AND structure_old_id='CAN-999-999-000-999-1008' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00024') AND structure_field_old_id='qc-lady-00024';
UPDATE structure_formats SET display_column='0', display_order='47', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-1008_qc-lady-00006' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008') AND structure_old_id='CAN-999-999-000-999-1008' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00006') AND structure_field_old_id='qc-lady-00006';
UPDATE structure_formats SET display_column='0', display_order='1', language_heading='', `flag_add`='1', `flag_add_readonly`='1', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_override_label`='1', `language_label`='participant identifier', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='', `flag_override_default`='1', `default`=''  WHERE old_id='CAN-999-999-000-999-1000_CANM-00027' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1000') AND structure_old_id='CAN-999-999-000-999-1000' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CANM-00027') AND structure_field_old_id='CANM-00027';
UPDATE structure_formats SET display_column='1', display_order='102', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='follow up (months)', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='number', `flag_override_setting`='1', `setting`='', `flag_override_default`='1', `default`=''  WHERE old_id='CAN-999-999-000-999-1000_qc-lady-00002' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1000') AND structure_old_id='CAN-999-999-000-999-1000' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00002') AND structure_field_old_id='qc-lady-00002';
UPDATE structure_formats SET display_column='1', display_order='100', language_heading='', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-1001_qc-lady-00001' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1001') AND structure_old_id='CAN-999-999-000-999-1001' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00001') AND structure_field_old_id='qc-lady-00001';
UPDATE structure_formats SET display_column='1', display_order='101', language_heading='', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='follow up (months)', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='number', `flag_override_setting`='1', `setting`='', `flag_override_default`='1', `default`=''  WHERE old_id='CAN-999-999-000-999-1001_qc-lady-00002' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1001') AND structure_old_id='CAN-999-999-000-999-1001' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00002') AND structure_field_old_id='qc-lady-00002';
UPDATE structure_formats SET display_column='1', display_order='101', language_heading='', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='follow up (months)', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='number', `flag_override_setting`='1', `setting`='', `flag_override_default`='1', `default`=''  WHERE old_id='CANM-00025_qc-lady-00013' AND structure_id=(SELECT id FROM structures WHERE old_id='CANM-00025') AND structure_old_id='CANM-00025' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00013') AND structure_field_old_id='qc-lady-00013';

-- disable tissue suspension
UPDATE `parent_to_derivative_sample_controls` SET `status` = 'disabled' WHERE `parent_to_derivative_sample_controls`.`id` =102;

-- dx add receptor and sardo_number
ALTER TABLE diagnosis_masters
	ADD receptor VARCHAR(255) DEFAULT NULL,
	ADD sardo_number int unsigned DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs
	ADD receptor VARCHAR(255) DEFAULT NULL,
	ADD sardo_number int unsigned DEFAULT NULL;

-- add receptor and sardo number to tx forms
UPDATE structure_formats SET display_column='1', display_order='101', language_heading='', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='follow up (months)', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='number', `flag_override_setting`='1', `setting`='', `flag_override_default`='1', `default`=''  WHERE old_id='CANM-00025_qc-lady-00013' AND structure_id=(SELECT id FROM structures WHERE old_id='CANM-00025') AND structure_old_id='CANM-00025' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00013') AND structure_field_old_id='qc-lady-00013';
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'qc-lady-00026', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'receptor', 'receptor', '', 'input', '', '', NULL, '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CANM-00010_qc-lady-00026', (SELECT id FROM structures WHERE old_id='CANM-00010'), 'CANM-00010', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00026'), 'qc-lady-00026', '1', '11', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1') ;
UPDATE structure_formats SET display_column='1', display_order='11', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CANM-00010_qc-lady-00026' AND structure_id=(SELECT id FROM structures WHERE old_id='CANM-00010') AND structure_old_id='CANM-00010' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00026') AND structure_field_old_id='qc-lady-00026';

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-6_qc-lady-00026', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-6'), 'CAN-999-999-000-999-6', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00026'), 'qc-lady-00026', '1', '12', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'); 
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CANM-00001_qc-lady-00026', (SELECT id FROM structures WHERE old_id='CANM-00001'), 'CANM-00001', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00026'), 'qc-lady-00026', '1', '12', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'qc-lady-00029', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'sardo_number', 'sardo number', '', 'number', '', '', NULL, '', 'open', 'open', 'open');
UPDATE structure_formats SET display_column='1', display_order='12', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CANM-00001_qc-lady-00026' AND structure_id=(SELECT id FROM structures WHERE old_id='CANM-00001') AND structure_old_id='CANM-00001' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00026') AND structure_field_old_id='qc-lady-00026';
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CANM-00001_qc-lady-00029', (SELECT id FROM structures WHERE old_id='CANM-00001'), 'CANM-00001', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00029'), 'qc-lady-00029', '1', '12', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
UPDATE structure_formats SET display_column='2', display_order='100', language_heading='Sardo', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CANM-00001_qc-lady-00029' AND structure_id=(SELECT id FROM structures WHERE old_id='CANM-00001') AND structure_old_id='CANM-00001' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00029') AND structure_field_old_id='qc-lady-00029';
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-6_qc-lady-00029', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-6'), 'CAN-999-999-000-999-6', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00029'), 'qc-lady-00029', '2', '26', 'Sardo', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ;
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CANM-00010_qc-lady-00029', (SELECT id FROM structures WHERE old_id='CANM-00010'), 'CANM-00010', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00029'), 'qc-lady-00029', '2', '27', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1') ;

REPLACE INTO `i18n` (`id` , `page_id` , `en` , `fr`) VALUES
('biological material use', 'global', 'Biological material use?', 'Utilisation de matériel biologique?'),
('contact for additional data', 'global', 'Contact for additional data?', 'Contacter pour données aditionnelles?'),
('allow questionnaire', 'global', 'Allow questionaire?', 'Permettre le questionnaire?'),
('inform discovery on other disease', 'global', 'Inform discovery on other disease?', "Informer des découvertes sur d'autres maladies?"),
('received tissue weight', 'global', 'Received tissue weight', 'Poids tu tissu reçu'),
('from surgery', 'global', 'From surgery', "À partir d'une chirurgie"),
('from biopsy', 'global', 'From biopsy', 'À partir d\'une biopsie'),
('freezer 6x5', 'global', 'Freezer 6x5', 'Congélateur 6x5'),
('rack 4x4', 'global', 'Rack 4x4', 'Étagère 4x4'),
('freezer 4x5', 'global', 'Freezer 4x5', 'Congélateur 4x5'),
('freezer vertical 4x3', 'global', 'Vertical freezer 4x3', 'Congélateur vertical 4x3'),
('rack 1-12', 'global', 'Rack 1-12', 'Étagère 1-12'),
('double centrifugation', 'global', 'Double centrifugation', 'Centrifugation double'),
('coagulation time (sec)', 'global', 'Coagulation time (sec.)', 'Temps de coagulation (sec.)'),
('an identifier of this type already exists for the current participant.', 'global', 'An identifier of this type already exists for the current participant.', 'Un identifiant de ce type existe déjà pour ce participant.'),
('follow up (months)', 'global', 'Follow up (months)', 'Suivi (mois)'),
('metastasis', 'global', 'Metastasis', 'Métastases'),
('receptor', 'global', 'Receptor', 'Récepteur'),
('sardo number', 'global', 'Sardo number', 'Numéro sardo'),
('invalid value', '', 'Invalid value', 'Valeur incorrecte'),
('qc_lady_collection_participant_help', 'global', 'If this collection is linked to a participant that has an identifier of the same type as this collection, shows the identifier.', "Si la collection est liée à un participant ayant un identifiant du même type que cette collection, affiche l'identifiant.");

-- clean unused menus
UPDATE menus SET active='no' WHERE id IN('drug_CAN_96', 'drug_CAN_97', 'rtbf_CAN_01', 'rtbf_CAN_02', 'proto_CAN_37', 'proto_CAN_82', 'proto_CAN_83', 'mat_CAN_01', 'mat_CAN_02');

-- participant display JGH #
UPDATE structure_formats SET display_column='1', display_order='-1', language_heading='clin_demographics', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-1_CAN-999-999-000-999-26' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1') AND structure_old_id='CAN-999-999-000-999-1' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-26') AND structure_field_old_id='CAN-999-999-000-999-26';

-- participant identifier in collection details help bullet
UPDATE structure_formats SET display_column='0', display_order='1', language_heading='', `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='participant identifier', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='qc_lady_collection_participant_help', `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=30', `flag_override_default`='1', `default`=''  WHERE old_id='CANM-00025_CANM-00026' AND structure_id=(SELECT id FROM structures WHERE old_id='CANM-00025') AND structure_old_id='CANM-00025' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CANM-00026') AND structure_field_old_id='CANM-00026';

-- consent type
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`) VALUES ('consent_form_type', '', '');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('all', 'all');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='consent_form_type'),  (SELECT id FROM structure_permissible_values WHERE value='all' AND language_alias='all'), '0', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('biopsy', 'biopsy');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='consent_form_type'),  (SELECT id FROM structure_permissible_values WHERE value='biopsy' AND language_alias='biopsy'), '1', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('blood', 'blood');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='consent_form_type'),  (SELECT id FROM structure_permissible_values WHERE value='blood' AND language_alias='blood'), '2', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('metastasis', 'metastasis');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='consent_form_type'),  (SELECT id FROM structure_permissible_values WHERE value='metastasis' AND language_alias='metastasis'), '3', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('surgery', 'surgery');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='consent_form_type'),  (SELECT id FROM structure_permissible_values WHERE value='surgery' AND language_alias='surgery'), '4', 'yes');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('other', 'other');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='consent_form_type'),  (SELECT id FROM structure_permissible_values WHERE value='other' AND language_alias='other'), '5', 'yes');
INSERT INTO `structure_fields` (`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES('', 'qc-lady-00028', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'consent_type', 'consent type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='consent_form_type'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CAN-999-999-000-999-12_qc-lady-00028', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12'), 'CAN-999-999-000-999-12', (SELECT id FROM structure_fields WHERE old_id='qc-lady-00028'), 'qc-lady-00030', '1', '6', '', 1, 'consent type', 1, '', 1, '', 1, 'select', 1, '', 1, '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1') ;

-- cleanup
UPDATE structure_formats SET display_column='2', display_order='4', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-046-003-000-002-29' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-002-29') AND structure_field_old_id='CAN-046-003-000-002-29';
UPDATE structure_formats SET display_column='1', display_order='5', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-046-003-000-999-1' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-1') AND structure_field_old_id='CAN-046-003-000-999-1';
UPDATE structure_formats SET display_column='2', display_order='2', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-046-003-000-999-5' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-5') AND structure_field_old_id='CAN-046-003-000-999-5';
UPDATE structure_formats SET display_column='2', display_order='1', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-046-003-000-999-6' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-6') AND structure_field_old_id='CAN-046-003-000-999-6';
UPDATE structure_formats SET display_column='2', display_order='3', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-046-003-000-999-7' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-046-003-000-999-7') AND structure_field_old_id='CAN-046-003-000-999-7';
UPDATE structure_formats SET display_column='1', display_order='6', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-123' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-123') AND structure_field_old_id='CAN-123';
UPDATE structure_formats SET display_column='1', display_order='10', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-124' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-124') AND structure_field_old_id='CAN-124';
UPDATE structure_formats SET display_column='1', display_order='3', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-763' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-763') AND structure_field_old_id='CAN-763';
UPDATE structure_formats SET display_column='1', display_order='6', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-999-999-000-999-53' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-53') AND structure_field_old_id='CAN-999-999-000-999-53';
UPDATE structure_formats SET display_column='1', display_order='12', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-999-999-000-999-56' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-56') AND structure_field_old_id='CAN-999-999-000-999-56';
UPDATE structure_formats SET display_column='1', display_order='4', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-999-999-000-999-57' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-57') AND structure_field_old_id='CAN-999-999-000-999-57';
UPDATE structure_formats SET display_column='1', display_order='2', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-804' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-804') AND structure_field_old_id='CAN-804';
UPDATE structure_formats SET display_column='1', display_order='7', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-999-999-000-999-61' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-61') AND structure_field_old_id='CAN-999-999-000-999-61';
UPDATE structure_formats SET display_column='1', display_order='9', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-807' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-807') AND structure_field_old_id='CAN-807';
UPDATE structure_formats SET display_column='1', display_order='11', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-808' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-808') AND structure_field_old_id='CAN-808';
UPDATE structure_formats SET display_column='1', display_order='50', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-999-999-000-999-65' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-65') AND structure_field_old_id='CAN-999-999-000-999-65';
UPDATE structure_formats SET display_column='1', display_order='8', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='0', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_CAN-999-999-000-999-66' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-66') AND structure_field_old_id='CAN-999-999-000-999-66';
UPDATE structure_formats SET display_column='2', display_order='13', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00015' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00015') AND structure_field_old_id='qc-lady-00015';
UPDATE structure_formats SET display_column='2', display_order='14', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00016' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00016') AND structure_field_old_id='qc-lady-00016';
UPDATE structure_formats SET display_column='2', display_order='15', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00017' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00017') AND structure_field_old_id='qc-lady-00017';
UPDATE structure_formats SET display_column='2', display_order='16', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00018' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00018') AND structure_field_old_id='qc-lady-00018';
UPDATE structure_formats SET display_column='2', display_order='17', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00019' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00019') AND structure_field_old_id='qc-lady-00019';
UPDATE structure_formats SET display_column='2', display_order='18', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00020' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00020') AND structure_field_old_id='qc-lady-00020';
UPDATE structure_formats SET display_column='2', display_order='19', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00021' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00021') AND structure_field_old_id='qc-lady-00021';
UPDATE structure_formats SET display_column='2', display_order='20', language_heading='', `flag_add`='1', `flag_add_readonly`='', `flag_edit`='1', `flag_edit_readonly`='', `flag_search`='1', `flag_search_readonly`='', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_index`='', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-12_qc-lady-00022' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-12') AND structure_old_id='CAN-999-999-000-999-12' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00022') AND structure_field_old_id='qc-lady-00022';




-- acos
TRUNCATE TABLE acos;
INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(1, NULL, NULL, NULL, 'controllers', 1, 930),
(2, 1, NULL, NULL, 'Administrate', 2, 111),
(3, 2, NULL, NULL, 'Announcements', 3, 14),
(4, 3, NULL, NULL, 'add', 4, 5),
(5, 3, NULL, NULL, 'index', 6, 7),
(6, 3, NULL, NULL, 'detail', 8, 9),
(7, 3, NULL, NULL, 'edit', 10, 11),
(8, 3, NULL, NULL, 'delete', 12, 13),
(9, 2, NULL, NULL, 'Banks', 15, 26),
(10, 9, NULL, NULL, 'add', 16, 17),
(11, 9, NULL, NULL, 'index', 18, 19),
(12, 9, NULL, NULL, 'detail', 20, 21),
(13, 9, NULL, NULL, 'edit', 22, 23),
(14, 9, NULL, NULL, 'delete', 24, 25),
(15, 2, NULL, NULL, 'Groups', 27, 38),
(16, 15, NULL, NULL, 'index', 28, 29),
(17, 15, NULL, NULL, 'detail', 30, 31),
(18, 15, NULL, NULL, 'add', 32, 33),
(19, 15, NULL, NULL, 'edit', 34, 35),
(20, 15, NULL, NULL, 'delete', 36, 37),
(21, 2, NULL, NULL, 'Menus', 39, 48),
(22, 21, NULL, NULL, 'index', 40, 41),
(23, 21, NULL, NULL, 'detail', 42, 43),
(24, 21, NULL, NULL, 'edit', 44, 45),
(25, 21, NULL, NULL, 'add', 46, 47),
(26, 2, NULL, NULL, 'Passwords', 49, 52),
(27, 26, NULL, NULL, 'index', 50, 51),
(28, 2, NULL, NULL, 'Permissions', 53, 66),
(29, 28, NULL, NULL, 'index', 54, 55),
(30, 28, NULL, NULL, 'regenerate', 56, 57),
(31, 28, NULL, NULL, 'update', 58, 59),
(32, 28, NULL, NULL, 'updatePermission', 60, 61),
(33, 28, NULL, NULL, 'tree', 62, 63),
(34, 28, NULL, NULL, 'addPermissionStateToThreadedData', 64, 65),
(35, 2, NULL, NULL, 'Preferences', 67, 72),
(36, 35, NULL, NULL, 'index', 68, 69),
(37, 35, NULL, NULL, 'edit', 70, 71),
(38, 2, NULL, NULL, 'StructureFormats', 73, 82),
(39, 38, NULL, NULL, 'listall', 74, 75),
(40, 38, NULL, NULL, 'detail', 76, 77),
(41, 38, NULL, NULL, 'edit', 78, 79),
(42, 38, NULL, NULL, 'add', 80, 81),
(43, 2, NULL, NULL, 'Structures', 83, 92),
(44, 43, NULL, NULL, 'index', 84, 85),
(45, 43, NULL, NULL, 'detail', 86, 87),
(46, 43, NULL, NULL, 'edit', 88, 89),
(47, 43, NULL, NULL, 'add', 90, 91),
(48, 2, NULL, NULL, 'UserLogs', 93, 96),
(49, 48, NULL, NULL, 'index', 94, 95),
(50, 2, NULL, NULL, 'Users', 97, 106),
(51, 50, NULL, NULL, 'listall', 98, 99),
(52, 50, NULL, NULL, 'detail', 100, 101),
(53, 50, NULL, NULL, 'add', 102, 103),
(54, 50, NULL, NULL, 'edit', 104, 105),
(55, 2, NULL, NULL, 'Versions', 107, 110),
(56, 55, NULL, NULL, 'detail', 108, 109),
(57, 1, NULL, NULL, 'App', 112, 153),
(58, 57, NULL, NULL, 'Groups', 113, 124),
(59, 58, NULL, NULL, 'index', 114, 115),
(60, 58, NULL, NULL, 'view', 116, 117),
(61, 58, NULL, NULL, 'add', 118, 119),
(62, 58, NULL, NULL, 'edit', 120, 121),
(63, 58, NULL, NULL, 'delete', 122, 123),
(64, 57, NULL, NULL, 'Menus', 125, 130),
(65, 64, NULL, NULL, 'index', 126, 127),
(66, 64, NULL, NULL, 'update', 128, 129),
(67, 57, NULL, NULL, 'Pages', 131, 134),
(68, 67, NULL, NULL, 'display', 132, 133),
(69, 57, NULL, NULL, 'Posts', 135, 146),
(70, 69, NULL, NULL, 'index', 136, 137),
(71, 69, NULL, NULL, 'view', 138, 139),
(72, 69, NULL, NULL, 'add', 140, 141),
(73, 69, NULL, NULL, 'edit', 142, 143),
(74, 69, NULL, NULL, 'delete', 144, 145),
(75, 57, NULL, NULL, 'Users', 147, 152),
(76, 75, NULL, NULL, 'login', 148, 149),
(77, 75, NULL, NULL, 'logout', 150, 151),
(78, 1, NULL, NULL, 'Clinicalannotation', 154, 333),
(79, 78, NULL, NULL, 'ClinicalCollectionLinks', 155, 168),
(80, 79, NULL, NULL, 'listall', 156, 157),
(81, 79, NULL, NULL, 'detail', 158, 159),
(82, 79, NULL, NULL, 'add', 160, 161),
(83, 79, NULL, NULL, 'edit', 162, 163),
(84, 79, NULL, NULL, 'delete', 164, 165),
(85, 79, NULL, NULL, 'allowClinicalCollectionLinkDeletion', 166, 167),
(86, 78, NULL, NULL, 'ConsentMasters', 169, 182),
(87, 86, NULL, NULL, 'listall', 170, 171),
(88, 86, NULL, NULL, 'detail', 172, 173),
(89, 86, NULL, NULL, 'add', 174, 175),
(90, 86, NULL, NULL, 'edit', 176, 177),
(91, 86, NULL, NULL, 'delete', 178, 179),
(92, 86, NULL, NULL, 'allowConsentDeletion', 180, 181),
(93, 78, NULL, NULL, 'DiagnosisMasters', 183, 198),
(94, 93, NULL, NULL, 'listall', 184, 185),
(95, 93, NULL, NULL, 'detail', 186, 187),
(96, 93, NULL, NULL, 'add', 188, 189),
(97, 93, NULL, NULL, 'edit', 190, 191),
(98, 93, NULL, NULL, 'delete', 192, 193),
(99, 93, NULL, NULL, 'allowDiagnosisDeletion', 194, 195),
(100, 93, NULL, NULL, 'buildAndSetExistingDx', 196, 197),
(101, 78, NULL, NULL, 'EventMasters', 199, 212),
(102, 101, NULL, NULL, 'listall', 200, 201),
(103, 101, NULL, NULL, 'detail', 202, 203),
(104, 101, NULL, NULL, 'add', 204, 205),
(105, 101, NULL, NULL, 'edit', 206, 207),
(106, 101, NULL, NULL, 'delete', 208, 209),
(107, 101, NULL, NULL, 'allowEventDeletion', 210, 211),
(108, 78, NULL, NULL, 'FamilyHistories', 213, 226),
(109, 108, NULL, NULL, 'listall', 214, 215),
(110, 108, NULL, NULL, 'detail', 216, 217),
(111, 108, NULL, NULL, 'add', 218, 219),
(112, 108, NULL, NULL, 'edit', 220, 221),
(113, 108, NULL, NULL, 'delete', 222, 223),
(114, 108, NULL, NULL, 'allowFamilyHistoryDeletion', 224, 225),
(115, 78, NULL, NULL, 'MiscIdentifiers', 227, 244),
(116, 115, NULL, NULL, 'index', 228, 229),
(117, 115, NULL, NULL, 'search', 230, 231),
(118, 115, NULL, NULL, 'listall', 232, 233),
(119, 115, NULL, NULL, 'detail', 234, 235),
(120, 115, NULL, NULL, 'add', 236, 237),
(121, 115, NULL, NULL, 'edit', 238, 239),
(122, 115, NULL, NULL, 'delete', 240, 241),
(123, 115, NULL, NULL, 'allowMiscIdentifierDeletion', 242, 243),
(124, 78, NULL, NULL, 'ParticipantContacts', 245, 258),
(125, 124, NULL, NULL, 'listall', 246, 247),
(126, 124, NULL, NULL, 'detail', 248, 249),
(127, 124, NULL, NULL, 'add', 250, 251),
(128, 124, NULL, NULL, 'edit', 252, 253),
(129, 124, NULL, NULL, 'delete', 254, 255),
(130, 124, NULL, NULL, 'allowParticipantContactDeletion', 256, 257),
(131, 78, NULL, NULL, 'ParticipantMessages', 259, 272),
(132, 131, NULL, NULL, 'listall', 260, 261),
(133, 131, NULL, NULL, 'detail', 262, 263),
(134, 131, NULL, NULL, 'add', 264, 265),
(135, 131, NULL, NULL, 'edit', 266, 267),
(136, 131, NULL, NULL, 'delete', 268, 269),
(137, 131, NULL, NULL, 'allowParticipantMessageDeletion', 270, 271),
(138, 78, NULL, NULL, 'Participants', 273, 290),
(139, 138, NULL, NULL, 'index', 274, 275),
(140, 138, NULL, NULL, 'search', 276, 277),
(141, 138, NULL, NULL, 'profile', 278, 279),
(142, 138, NULL, NULL, 'add', 280, 281),
(143, 138, NULL, NULL, 'edit', 282, 283),
(144, 138, NULL, NULL, 'delete', 284, 285),
(145, 138, NULL, NULL, 'allowParticipantDeletion', 286, 287),
(146, 138, NULL, NULL, 'chronology', 288, 289),
(147, 78, NULL, NULL, 'ProductMasters', 291, 294),
(148, 147, NULL, NULL, 'productsTreeView', 292, 293),
(149, 78, NULL, NULL, 'ReproductiveHistories', 295, 308),
(150, 149, NULL, NULL, 'listall', 296, 297),
(151, 149, NULL, NULL, 'detail', 298, 299),
(152, 149, NULL, NULL, 'add', 300, 301),
(153, 149, NULL, NULL, 'edit', 302, 303),
(154, 149, NULL, NULL, 'delete', 304, 305),
(155, 149, NULL, NULL, 'allowReproductiveHistoryDeletion', 306, 307),
(156, 78, NULL, NULL, 'TreatmentExtends', 309, 320),
(157, 156, NULL, NULL, 'listall', 310, 311),
(158, 156, NULL, NULL, 'detail', 312, 313),
(159, 156, NULL, NULL, 'add', 314, 315),
(160, 156, NULL, NULL, 'edit', 316, 317),
(161, 156, NULL, NULL, 'delete', 318, 319),
(162, 78, NULL, NULL, 'TreatmentMasters', 321, 332),
(163, 162, NULL, NULL, 'listall', 322, 323),
(164, 162, NULL, NULL, 'detail', 324, 325),
(165, 162, NULL, NULL, 'edit', 326, 327),
(166, 162, NULL, NULL, 'add', 328, 329),
(167, 162, NULL, NULL, 'delete', 330, 331),
(168, 1, NULL, NULL, 'Codingicd10', 334, 341),
(169, 168, NULL, NULL, 'CodingIcd10s', 335, 340),
(170, 169, NULL, NULL, 'tool', 336, 337),
(171, 169, NULL, NULL, 'autoComplete', 338, 339),
(172, 1, NULL, NULL, 'Customize', 342, 365),
(173, 172, NULL, NULL, 'Announcements', 343, 348),
(174, 173, NULL, NULL, 'index', 344, 345),
(175, 173, NULL, NULL, 'detail', 346, 347),
(176, 172, NULL, NULL, 'Passwords', 349, 352),
(177, 176, NULL, NULL, 'index', 350, 351),
(178, 172, NULL, NULL, 'Preferences', 353, 358),
(179, 178, NULL, NULL, 'index', 354, 355),
(180, 178, NULL, NULL, 'edit', 356, 357),
(181, 172, NULL, NULL, 'Profiles', 359, 364),
(182, 181, NULL, NULL, 'index', 360, 361),
(183, 181, NULL, NULL, 'edit', 362, 363),
(184, 1, NULL, NULL, 'Datamart', 366, 415),
(185, 184, NULL, NULL, 'AdhocSaved', 367, 380),
(186, 185, NULL, NULL, 'index', 368, 369),
(187, 185, NULL, NULL, 'add', 370, 371),
(188, 185, NULL, NULL, 'search', 372, 373),
(189, 185, NULL, NULL, 'results', 374, 375),
(190, 185, NULL, NULL, 'edit', 376, 377),
(191, 185, NULL, NULL, 'delete', 378, 379),
(192, 184, NULL, NULL, 'Adhocs', 381, 396),
(193, 192, NULL, NULL, 'index', 382, 383),
(194, 192, NULL, NULL, 'favourite', 384, 385),
(195, 192, NULL, NULL, 'unfavourite', 386, 387),
(196, 192, NULL, NULL, 'search', 388, 389),
(197, 192, NULL, NULL, 'results', 390, 391),
(198, 192, NULL, NULL, 'process', 392, 393),
(199, 192, NULL, NULL, 'csv', 394, 395),
(200, 184, NULL, NULL, 'BatchSets', 397, 414),
(201, 200, NULL, NULL, 'index', 398, 399),
(202, 200, NULL, NULL, 'listall', 400, 401),
(203, 200, NULL, NULL, 'add', 402, 403),
(204, 200, NULL, NULL, 'edit', 404, 405),
(205, 200, NULL, NULL, 'delete', 406, 407),
(206, 200, NULL, NULL, 'process', 408, 409),
(207, 200, NULL, NULL, 'remove', 410, 411),
(208, 200, NULL, NULL, 'csv', 412, 413),
(209, 1, NULL, NULL, 'Drug', 416, 433),
(210, 209, NULL, NULL, 'Drugs', 417, 432),
(211, 210, NULL, NULL, 'index', 418, 419),
(212, 210, NULL, NULL, 'search', 420, 421),
(213, 210, NULL, NULL, 'listall', 422, 423),
(214, 210, NULL, NULL, 'add', 424, 425),
(215, 210, NULL, NULL, 'edit', 426, 427),
(216, 210, NULL, NULL, 'detail', 428, 429),
(217, 210, NULL, NULL, 'delete', 430, 431),
(218, 1, NULL, NULL, 'Inventorymanagement', 434, 559),
(219, 218, NULL, NULL, 'AliquotMasters', 435, 490),
(220, 219, NULL, NULL, 'index', 436, 437),
(221, 219, NULL, NULL, 'search', 438, 439),
(222, 219, NULL, NULL, 'listAll', 440, 441),
(223, 219, NULL, NULL, 'add', 442, 443),
(224, 219, NULL, NULL, 'detail', 444, 445),
(225, 219, NULL, NULL, 'edit', 446, 447),
(226, 219, NULL, NULL, 'removeAliquotFromStorage', 448, 449),
(227, 219, NULL, NULL, 'delete', 450, 451),
(228, 219, NULL, NULL, 'addAliquotUse', 452, 453),
(229, 219, NULL, NULL, 'editAliquotUse', 454, 455),
(230, 219, NULL, NULL, 'deleteAliquotUse', 456, 457),
(231, 219, NULL, NULL, 'addSourceAliquots', 458, 459),
(232, 219, NULL, NULL, 'listAllSourceAliquots', 460, 461),
(233, 219, NULL, NULL, 'defineRealiquotedChildren', 462, 463),
(234, 219, NULL, NULL, 'listAllRealiquotedParents', 464, 465),
(235, 219, NULL, NULL, 'getStudiesList', 466, 467),
(236, 219, NULL, NULL, 'getSampleBlocksList', 468, 469),
(237, 219, NULL, NULL, 'getSampleGelMatricesList', 470, 471),
(238, 219, NULL, NULL, 'getDefaultAliquotStorageDate', 472, 473),
(239, 219, NULL, NULL, 'isDuplicatedAliquotBarcode', 474, 475),
(240, 219, NULL, NULL, 'formatAliquotFieldDecimalData', 476, 477),
(241, 219, NULL, NULL, 'validateAliquotStorageData', 478, 479),
(242, 219, NULL, NULL, 'allowAliquotDeletion', 480, 481),
(243, 219, NULL, NULL, 'getDefaultRealiquotingDate', 482, 483),
(244, 219, NULL, NULL, 'formatPreselectedStoragesForDisplay', 484, 485),
(245, 219, NULL, NULL, 'formatBlocksForDisplay', 486, 487),
(246, 219, NULL, NULL, 'formatGelMatricesForDisplay', 488, 489),
(247, 218, NULL, NULL, 'Collections', 491, 506),
(248, 247, NULL, NULL, 'index', 492, 493),
(249, 247, NULL, NULL, 'search', 494, 495),
(250, 247, NULL, NULL, 'detail', 496, 497),
(251, 247, NULL, NULL, 'add', 498, 499),
(252, 247, NULL, NULL, 'edit', 500, 501),
(253, 247, NULL, NULL, 'delete', 502, 503),
(254, 247, NULL, NULL, 'allowCollectionDeletion', 504, 505),
(255, 218, NULL, NULL, 'PathCollectionReviews', 507, 508),
(256, 218, NULL, NULL, 'QualityCtrls', 509, 528),
(257, 256, NULL, NULL, 'listAll', 510, 511),
(258, 256, NULL, NULL, 'add', 512, 513),
(259, 256, NULL, NULL, 'detail', 514, 515),
(260, 256, NULL, NULL, 'edit', 516, 517),
(261, 256, NULL, NULL, 'if', 518, 519),
(262, 256, NULL, NULL, 'delete', 520, 521),
(263, 256, NULL, NULL, 'addTestedAliquots', 522, 523),
(264, 256, NULL, NULL, 'allowQcDeletion', 524, 525),
(265, 256, NULL, NULL, 'createQcCode', 526, 527),
(266, 218, NULL, NULL, 'ReviewMasters', 529, 530),
(267, 218, NULL, NULL, 'SampleMasters', 531, 558),
(268, 267, NULL, NULL, 'index', 532, 533),
(269, 267, NULL, NULL, 'search', 534, 535),
(270, 267, NULL, NULL, 'contentTreeView', 536, 537),
(271, 267, NULL, NULL, 'listAll', 538, 539),
(272, 267, NULL, NULL, 'detail', 540, 541),
(273, 267, NULL, NULL, 'add', 542, 543),
(274, 267, NULL, NULL, 'edit', 544, 545),
(275, 267, NULL, NULL, 'delete', 546, 547),
(276, 267, NULL, NULL, 'createSampleCode', 548, 549),
(277, 267, NULL, NULL, 'allowSampleDeletion', 550, 551),
(278, 267, NULL, NULL, 'getTissueSourceList', 552, 553),
(279, 267, NULL, NULL, 'formatSampleFieldDecimalData', 554, 555),
(280, 267, NULL, NULL, 'formatParentSampleDataForDisplay', 556, 557),
(281, 1, NULL, NULL, 'Material', 560, 577),
(282, 281, NULL, NULL, 'Materials', 561, 576),
(283, 282, NULL, NULL, 'index', 562, 563),
(284, 282, NULL, NULL, 'search', 564, 565),
(285, 282, NULL, NULL, 'listall', 566, 567),
(286, 282, NULL, NULL, 'add', 568, 569),
(287, 282, NULL, NULL, 'edit', 570, 571),
(288, 282, NULL, NULL, 'detail', 572, 573),
(289, 282, NULL, NULL, 'delete', 574, 575),
(290, 1, NULL, NULL, 'Order', 578, 649),
(291, 290, NULL, NULL, 'OrderItems', 579, 592),
(292, 291, NULL, NULL, 'listall', 580, 581),
(293, 291, NULL, NULL, 'add', 582, 583),
(294, 291, NULL, NULL, 'addAliquotsInBatch', 584, 585),
(295, 291, NULL, NULL, 'edit', 586, 587),
(296, 291, NULL, NULL, 'delete', 588, 589),
(297, 291, NULL, NULL, 'allowOrderItemDeletion', 590, 591),
(298, 290, NULL, NULL, 'OrderLines', 593, 608),
(299, 298, NULL, NULL, 'listall', 594, 595),
(300, 298, NULL, NULL, 'add', 596, 597),
(301, 298, NULL, NULL, 'edit', 598, 599),
(302, 298, NULL, NULL, 'detail', 600, 601),
(303, 298, NULL, NULL, 'delete', 602, 603),
(304, 298, NULL, NULL, 'generateSampleAliquotControlList', 604, 605),
(305, 298, NULL, NULL, 'allowOrderLineDeletion', 606, 607),
(306, 290, NULL, NULL, 'Orders', 609, 626),
(307, 306, NULL, NULL, 'index', 610, 611),
(308, 306, NULL, NULL, 'search', 612, 613),
(309, 306, NULL, NULL, 'add', 614, 615),
(310, 306, NULL, NULL, 'detail', 616, 617),
(311, 306, NULL, NULL, 'edit', 618, 619),
(312, 306, NULL, NULL, 'delete', 620, 621),
(313, 306, NULL, NULL, 'getStudiesList', 622, 623),
(314, 306, NULL, NULL, 'allowOrderDeletion', 624, 625),
(315, 290, NULL, NULL, 'Shipments', 627, 648),
(316, 315, NULL, NULL, 'listall', 628, 629),
(317, 315, NULL, NULL, 'add', 630, 631),
(318, 315, NULL, NULL, 'edit', 632, 633),
(319, 315, NULL, NULL, 'if', 634, 635),
(320, 315, NULL, NULL, 'detail', 636, 637),
(321, 315, NULL, NULL, 'delete', 638, 639),
(322, 315, NULL, NULL, 'addToShipment', 640, 641),
(323, 315, NULL, NULL, 'deleteFromShipment', 642, 643),
(324, 315, NULL, NULL, 'allowShipmentDeletion', 644, 645),
(325, 315, NULL, NULL, 'allowItemRemoveFromShipment', 646, 647),
(326, 1, NULL, NULL, 'Protocol', 650, 679),
(327, 326, NULL, NULL, 'ProtocolExtends', 651, 662),
(328, 327, NULL, NULL, 'listall', 652, 653),
(329, 327, NULL, NULL, 'detail', 654, 655),
(330, 327, NULL, NULL, 'add', 656, 657),
(331, 327, NULL, NULL, 'edit', 658, 659),
(332, 327, NULL, NULL, 'delete', 660, 661),
(333, 326, NULL, NULL, 'ProtocolMasters', 663, 678),
(334, 333, NULL, NULL, 'index', 664, 665),
(335, 333, NULL, NULL, 'search', 666, 667),
(336, 333, NULL, NULL, 'listall', 668, 669),
(337, 333, NULL, NULL, 'add', 670, 671),
(338, 333, NULL, NULL, 'detail', 672, 673),
(339, 333, NULL, NULL, 'edit', 674, 675),
(340, 333, NULL, NULL, 'delete', 676, 677),
(341, 1, NULL, NULL, 'Provider', 680, 697),
(342, 341, NULL, NULL, 'Providers', 681, 696),
(343, 342, NULL, NULL, 'index', 682, 683),
(344, 342, NULL, NULL, 'search', 684, 685),
(345, 342, NULL, NULL, 'listall', 686, 687),
(346, 342, NULL, NULL, 'add', 688, 689),
(347, 342, NULL, NULL, 'detail', 690, 691),
(348, 342, NULL, NULL, 'edit', 692, 693),
(349, 342, NULL, NULL, 'delete', 694, 695),
(350, 1, NULL, NULL, 'Rtbform', 698, 713),
(351, 350, NULL, NULL, 'Rtbforms', 699, 712),
(352, 351, NULL, NULL, 'index', 700, 701),
(353, 351, NULL, NULL, 'search', 702, 703),
(354, 351, NULL, NULL, 'profile', 704, 705),
(355, 351, NULL, NULL, 'add', 706, 707),
(356, 351, NULL, NULL, 'edit', 708, 709),
(357, 351, NULL, NULL, 'delete', 710, 711),
(358, 1, NULL, NULL, 'Sop', 714, 739),
(359, 358, NULL, NULL, 'SopExtends', 715, 726),
(360, 359, NULL, NULL, 'listall', 716, 717),
(361, 359, NULL, NULL, 'detail', 718, 719),
(362, 359, NULL, NULL, 'add', 720, 721),
(363, 359, NULL, NULL, 'edit', 722, 723),
(364, 359, NULL, NULL, 'delete', 724, 725),
(365, 358, NULL, NULL, 'SopMasters', 727, 738),
(366, 365, NULL, NULL, 'listall', 728, 729),
(367, 365, NULL, NULL, 'add', 730, 731),
(368, 365, NULL, NULL, 'detail', 732, 733),
(369, 365, NULL, NULL, 'edit', 734, 735),
(370, 365, NULL, NULL, 'delete', 736, 737),
(371, 1, NULL, NULL, 'Storagelayout', 740, 815),
(372, 371, NULL, NULL, 'StorageCoordinates', 741, 754),
(373, 372, NULL, NULL, 'listAll', 742, 743),
(374, 372, NULL, NULL, 'add', 744, 745),
(375, 372, NULL, NULL, 'delete', 746, 747),
(376, 372, NULL, NULL, 'allowStorageCoordinateDeletion', 748, 749),
(377, 372, NULL, NULL, 'isDuplicatedValue', 750, 751),
(378, 372, NULL, NULL, 'isDuplicatedOrder', 752, 753),
(379, 371, NULL, NULL, 'StorageMasters', 755, 796),
(380, 379, NULL, NULL, 'index', 756, 757),
(381, 379, NULL, NULL, 'search', 758, 759),
(382, 379, NULL, NULL, 'detail', 760, 761),
(383, 379, NULL, NULL, 'add', 762, 763),
(384, 379, NULL, NULL, 'edit', 764, 765),
(385, 379, NULL, NULL, 'editStoragePosition', 766, 767),
(386, 379, NULL, NULL, 'delete', 768, 769),
(387, 379, NULL, NULL, 'contentTreeView', 770, 771),
(388, 379, NULL, NULL, 'completeStorageContent', 772, 773),
(389, 379, NULL, NULL, 'storageLayout', 774, 775),
(390, 379, NULL, NULL, 'setStorageCoordinateValues', 776, 777),
(391, 379, NULL, NULL, 'allowStorageDeletion', 778, 779),
(392, 379, NULL, NULL, 'getStorageSelectionLabel', 780, 781),
(393, 379, NULL, NULL, 'updateChildrenStorageSelectionLabel', 782, 783),
(394, 379, NULL, NULL, 'createSelectionLabel', 784, 785),
(395, 379, NULL, NULL, 'IsDuplicatedStorageBarCode', 786, 787),
(396, 379, NULL, NULL, 'createStorageCode', 788, 789),
(397, 379, NULL, NULL, 'updateChildrenSurroundingTemperature', 790, 791),
(398, 379, NULL, NULL, 'updateAndSaveDataArray', 792, 793),
(399, 379, NULL, NULL, 'buildChildrenArray', 794, 795),
(400, 371, NULL, NULL, 'TmaSlides', 797, 814),
(401, 400, NULL, NULL, 'listAll', 798, 799),
(402, 400, NULL, NULL, 'add', 800, 801),
(403, 400, NULL, NULL, 'detail', 802, 803),
(404, 400, NULL, NULL, 'edit', 804, 805),
(405, 400, NULL, NULL, 'delete', 806, 807),
(406, 400, NULL, NULL, 'isDuplicatedTmaSlideBarcode', 808, 809),
(407, 400, NULL, NULL, 'allowTMASlideDeletion', 810, 811),
(408, 400, NULL, NULL, 'formatPreselectedStoragesForDisplay', 812, 813),
(409, 1, NULL, NULL, 'Study', 816, 929),
(410, 409, NULL, NULL, 'StudyContacts', 817, 830),
(411, 410, NULL, NULL, 'listall', 818, 819),
(412, 410, NULL, NULL, 'detail', 820, 821),
(413, 410, NULL, NULL, 'add', 822, 823),
(414, 410, NULL, NULL, 'edit', 824, 825),
(415, 410, NULL, NULL, 'delete', 826, 827),
(416, 410, NULL, NULL, 'allowStudyContactDeletion', 828, 829),
(417, 409, NULL, NULL, 'StudyEthicsBoards', 831, 844),
(418, 417, NULL, NULL, 'listall', 832, 833),
(419, 417, NULL, NULL, 'detail', 834, 835),
(420, 417, NULL, NULL, 'add', 836, 837),
(421, 417, NULL, NULL, 'edit', 838, 839),
(422, 417, NULL, NULL, 'delete', 840, 841),
(423, 417, NULL, NULL, 'allowStudyEthicsBoardDeletion', 842, 843),
(424, 409, NULL, NULL, 'StudyFundings', 845, 858),
(425, 424, NULL, NULL, 'listall', 846, 847),
(426, 424, NULL, NULL, 'detail', 848, 849),
(427, 424, NULL, NULL, 'add', 850, 851),
(428, 424, NULL, NULL, 'edit', 852, 853),
(429, 424, NULL, NULL, 'delete', 854, 855),
(430, 424, NULL, NULL, 'allowStudyFundingDeletion', 856, 857),
(431, 409, NULL, NULL, 'StudyInvestigators', 859, 872),
(432, 431, NULL, NULL, 'listall', 860, 861),
(433, 431, NULL, NULL, 'detail', 862, 863),
(434, 431, NULL, NULL, 'add', 864, 865),
(435, 431, NULL, NULL, 'edit', 866, 867),
(436, 431, NULL, NULL, 'delete', 868, 869),
(437, 431, NULL, NULL, 'allowStudyInvestigatorDeletion', 870, 871),
(438, 409, NULL, NULL, 'StudyRelated', 873, 886),
(439, 438, NULL, NULL, 'listall', 874, 875),
(440, 438, NULL, NULL, 'detail', 876, 877),
(441, 438, NULL, NULL, 'add', 878, 879),
(442, 438, NULL, NULL, 'edit', 880, 881),
(443, 438, NULL, NULL, 'delete', 882, 883),
(444, 438, NULL, NULL, 'allowStudyRelatedDeletion', 884, 885),
(445, 409, NULL, NULL, 'StudyResults', 887, 900),
(446, 445, NULL, NULL, 'listall', 888, 889),
(447, 445, NULL, NULL, 'detail', 890, 891),
(448, 445, NULL, NULL, 'add', 892, 893),
(449, 445, NULL, NULL, 'edit', 894, 895),
(450, 445, NULL, NULL, 'delete', 896, 897),
(451, 445, NULL, NULL, 'allowStudyResultDeletion', 898, 899),
(452, 409, NULL, NULL, 'StudyReviews', 901, 914),
(453, 452, NULL, NULL, 'listall', 902, 903),
(454, 452, NULL, NULL, 'detail', 904, 905),
(455, 452, NULL, NULL, 'add', 906, 907),
(456, 452, NULL, NULL, 'edit', 908, 909),
(457, 452, NULL, NULL, 'delete', 910, 911),
(458, 452, NULL, NULL, 'allowStudyReviewDeletion', 912, 913),
(459, 409, NULL, NULL, 'StudySummaries', 915, 928),
(460, 459, NULL, NULL, 'listall', 916, 917),
(461, 459, NULL, NULL, 'detail', 918, 919),
(462, 459, NULL, NULL, 'add', 920, 921),
(463, 459, NULL, NULL, 'edit', 922, 923),
(464, 459, NULL, NULL, 'delete', 924, 925),
(465, 459, NULL, NULL, 'allowStudySummaryDeletion', 926, 927);
