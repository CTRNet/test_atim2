-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0040');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0040', 'search_aliquots_from_label', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

DELETE FROM `form_fields`
WHERE `id` IN ('CAN-024-001-000-999-0137', 'CAN-024-001-000-999-0138', 
'CAN-024-001-000-999-0139', 'CAN-024-001-000-999-0140');

INSERT INTO `form_fields` 
(`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, 
`language_help`, `install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0137', 'FunctionManagement', 'aliquot_label_sub_string_1', 'aliquot label', 'sub_string 1', 'input', 'size=10', 
'', 'aliquot_label_sub_string_1_help', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0138', 'FunctionManagement', 'aliquot_label_sub_string_2', '', 'sub_string 2', 'input', 'size=10', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0139', 'FunctionManagement', 'aliquot_label_sub_string_3', '', 'sub_string 3', 'input', 'size=10', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0140', 'FunctionManagement', 'aliquot_label_sub_string_4', '', 'sub_string 4', 'input', 'size=10', 
'', '', 0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0040');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* AliquotMaster.label */
('CAN-024-001-000-999-0040_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0009', 1, 1, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement_aliquot_label_sub_string_1 */
('CAN-024-001-000-999-0040_CAN-024-001-000-999-0137', 'CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0137', 1, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement_aliquot_label_sub_string_2 */
('CAN-024-001-000-999-0040_CAN-024-001-000-999-0138', 'CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0138', 1, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement_aliquot_label_sub_string_3 */
('CAN-024-001-000-999-0040_CAN-024-001-000-999-0139', 'CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0139', 1, 4, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* FunctionManagement_aliquot_label_sub_string_4 */
('CAN-024-001-000-999-0040_CAN-024-001-000-999-0140', 'CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0140', 1, 5, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Collection', 'bank_participant_identifier' */
('CAN-024-001-000-999-0040_CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0040', 1, 10, '', 0, '', 0, '', 0, '', 0, '', 1, 'tool=multiple', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Collection', 'bank' */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1001', 1, 21, '', 1, 'qc collection bank title', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* SampleMaster.sample_type */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1018', 1, 22, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_type */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1102', 1, 23, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.barcode */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1101', 1, 25, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* AliquotMaster.status */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1103', 1, 26, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.aliquot_volume */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1154', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1154', 1, 27, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_volume_unit */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1133', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1133', 1, 28, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* StorageMaster.selection_label */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1217', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1217', 1, 32, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.code */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1117', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1117', 1, 33, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1107', 1, 35, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-024-001-000-999-0040_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-0040', 'CAN-999-999-000-999-1108', 1, 37, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1600;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1600', '<b>QR.Col-AliqMast.1600</b>: <u> Search Aliquots From Label / Recherche d''aliquots bas&eacute;e sur les labels</u><br>
List aliquots having label containing one or many searched caracter(s)/word(s). / Liste des aliquots ayant un label contenant un ou plusieurs caract&egrave;re(s)/mots(s) recherch&eacute;s. <br>
<FONT COLOR="#347C17"><B><U>ALIQUOT</U></B> - <U>SAMPLE</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - STORAGE  / <B><U>ALIQUOT</U></B> - <U>&Eacute;CHANTILLON</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - ENTREPOSAGE</FONT>',  
'AliquotMaster', 
'search_aliquots_from_label', 'search_aliquots_from_label',
'plugin inventorymanagement aliquot detail=>/inventorymanagement/aliquot_masters/detailAliquotFromId/%%AliquotMaster.id%%/|plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT AliquotMaster.id, Collection.bank_participant_identifier, Collection.bank, SampleMaster.sample_type, AliquotMaster.aliquot_type, AliquotMaster.aliquot_label, AliquotMaster.barcode, AliquotMaster.status, StorageMaster.selection_label, StorageMaster.code, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, AliquotMaster.current_volume, AliquotMaster.aliquot_volume_unit FROM aliquot_masters AS AliquotMaster INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id LEFT JOIN storage_masters As StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id WHERE TRUE AND Collection.bank = "@@Collection.bank@@" AND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" 
AND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@" 
AND AliquotMaster.aliquot_label LIKE "%@@FunctionManagement.aliquot_label_sub_string_1@@%"
AND AliquotMaster.aliquot_label LIKE "%@@FunctionManagement.aliquot_label_sub_string_2@@%"
AND AliquotMaster.aliquot_label LIKE "%@@FunctionManagement.aliquot_label_sub_string_3@@%"
AND AliquotMaster.aliquot_label LIKE "%@@FunctionManagement.aliquot_label_sub_string_4@@%"
ORDER BY Collection.bank_participant_identifier, SampleMaster.sample_type, AliquotMaster.aliquot_type;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('sub_string 1', 'sub_string 2', 'sub_string 3', 
'sub_string 4', 'aliquot_label_sub_string_1_help');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('sub_string 1', 'global', '1:', '1:'),
('sub_string 2', 'global', '2:', '2:'),
('sub_string 3', 'global', '3:', '3:'),
('sub_string 4', 'global', '4:', '4:'),
('aliquot_label_sub_string_1_help', 'global', 'Enter from 1 to 4 character(s)/word(s) contained into the Aliquot Label!', 'Entrez de 1 &agrave; 4 caract&egrave;re(s)/mots(s) contenus dans le label de l''aliquot!');

