-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0026');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0026', 'stored_aliquot_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0026');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* AliquotMaster.label */
('CAN-024-001-000-999-0026_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0026', 'CAN-024-001-000-999-0009', 0, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.barcode */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1101', 0, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Collection', 'bank_participant_identifier' */
('CAN-024-001-000-999-0026_CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0026', 'CAN-024-001-000-999-0040', 0, 1, '', 0, '', 0, '', 0, '', 0, '', 1, 'tool=csv', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Collection.bank */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1223', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1223', 0, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* SampleMaster.type */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1018', 0, 4, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.type */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1102', 0, 5, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.status */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1103', 0, 6, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.aliquot_volume */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1154', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1154', 0, 7, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_volume_unit */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1133', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1133', 0, 8, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* StorageMaster.storage_type */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1181', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1181', 0, 20, '', 1, 'storage entity type', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.short_label */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1197', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1197', 0, 21, '', 1, 'storage short label', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.selection_label */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1217', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1217', 0, 22, '', 1, 'storage selection label', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1107', 0, 31, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1108', 0, 32, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* StorageMaster.temperature */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1110', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1110', 0, 41, '', 0, '', 0, '', 0, '', 1, 'number', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.temperature_unit */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1194', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1194', 0, 42, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	  	
/* AliquotMaster.storage_datetime */
('CAN-024-001-000-999-0026_CAN-999-999-000-999-1109', 'CAN-024-001-000-999-0026', 'CAN-999-999-000-999-1109', 0, 52, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1601;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1601', '<b>QR.Col-AliqMast.1601</b>: <u>Search Stored Aliquots / Recherche d''aliquots entrepos&eacute;s</u><br>
List aliquots of a specific bank contained into a storage. (<I><FONT COLOR="#FF0000">Only stored aliquots will be searched!</FONT></I>) / Liste les aliquots d''une banque contenus dans un entreposage. (<I><FONT COLOR="#FF0000">Seules les aliquots entrepos&eacute;s seront recherch&eacute;s!</FONT></I>)<br>
<FONT COLOR="#347C17"><B><U>ALIQUOT</U></B> - <U>SAMPLE</U> - <U>COLLECTION</U> - <U>STORAGE</U> - <U>NOLABO<I>col</I></U> / <B><U>ALIQUOT</U></B> - <U>&Eacute;CHANTILLON</U> - <U>COLLECTION</U> - <U>ENTREPOSAGE</U> - <U>NOLABO<I>col</I></U></FONT>', 
'AliquotMaster', 
'stored_aliquot_search', 'stored_aliquot_search', 
'plugin storagelayout storage detail=>/storagelayout/storage_masters/detail/%%StorageMaster.id%%/|plugin inventorymanagement aliquot detail=>/inventorymanagement/aliquot_masters/detailAliquotFromId/', 
'SELECT AliquotMaster.id, AliquotMaster.barcode, AliquotMaster.aliquot_label, Collection.bank, Collection.bank_participant_identifier, SampleMaster.sample_type, AliquotMaster.aliquot_type, AliquotMaster.status, AliquotMaster.current_volume, AliquotMaster.aliquot_volume_unit, AliquotMaster.storage_datetime, StorageMaster.id, StorageMaster.short_label, StorageMaster.selection_label, StorageMaster.storage_type, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, StorageMaster.temperature, StorageMaster.temp_unit FROM collections AS Collection INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id INNER JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id WHERE Collection.bank = "@@Collection.bank@@" AND Collection.bank_participant_identifier IN (@@Collection.bank_participant_identifier@@) AND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" AND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@" AND AliquotMaster.status = "@@AliquotMaster.status@@" AND StorageMaster.storage_type = "@@StorageMaster.storage_type@@" AND StorageMaster.short_label = "@@StorageMaster.short_label@@" AND StorageMaster.selection_label LIKE "%@@StorageMaster.selection_label@@%" AND StorageMaster.temperature >= "@@StorageMaster.temperature_start@@" AND StorageMaster.temperature <= "@@StorageMaster.temperature_end@@" AND StorageMaster.temp_unit = "@@StorageMaster.temp_unit@@" AND AliquotMaster.storage_datetime >= "@@AliquotMaster.storage_datetime_start@@" AND AliquotMaster.storage_datetime <= "@@AliquotMaster.storage_datetime_end@@" ORDER BY Collection.bank_participant_identifier ASC, StorageMaster.selection_label, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('plugin storagelayout storage detail');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('plugin storagelayout storage detail', 'global', 'Storage Details', 'Donn&eacute;es de l''entreposage');

