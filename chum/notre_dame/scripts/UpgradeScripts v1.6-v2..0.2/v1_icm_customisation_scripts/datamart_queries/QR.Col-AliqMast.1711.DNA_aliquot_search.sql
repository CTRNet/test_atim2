-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0035');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0035', 'dna_aliquot_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0035');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* 'Collection', 'bank_participant_identifier' */
('CAN-024-001-000-999-0035_CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0035', 'CAN-024-001-000-999-0040', 1, 2, '', 0, '', 0, '', 0, '', 0, '', 1, 'tool=csv', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Specimen', 'sample_type' */
('CAN-024-001-000-999-0035_CAN-024-001-000-999-0123', 'CAN-024-001-000-999-0035', 'CAN-024-001-000-999-0123', 1, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'bank' */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1001', 1, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'collection_datetime' */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1004', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1004', 1, 13, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* SampleMaster.sample_type */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1018', 1, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* DerivativeDetail.creation_datetime */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1062', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1062', 1, 24, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ParentSample', 'sample_type' */
('CAN-024-001-000-999-0035_CAN-024-001-000-999-0124', 'CAN-024-001-000-999-0035', 'CAN-024-001-000-999-0124', 1, 23, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* SampleDetail.tmp_extraction_method */
('CAN-024-001-000-999-0035_CAN-024-001-000-999-tmp010', 'CAN-024-001-000-999-0035', 'CAN-024-001-000-999-tmp010', 1, 22, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.label */
('CAN-024-001-000-999-0035_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0035', 'CAN-024-001-000-999-0009', 1, 32, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
 /* AliquotMaster.barcode */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1101', 1, 33, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* AliquotMaster.aliquot_type */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1102', 1, 34, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.status */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1103', 1, 35, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.aliquot_volume */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1154', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1154', 1, 40, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_volume_unit */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1133', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1133', 1, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotDetail.concentration */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1241', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1241', 1, 42, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotDetail.concentration_unit */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1242', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1242', 1, 43, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotDetail.tmp_storage_solution */
('CAN-024-001-000-999-0035_CAN-024-001-000-999-tmp021', 'CAN-024-001-000-999-0035', 'CAN-024-001-000-999-tmp021', 1, 44, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.storage_datetime */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1109', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1109', 1, 61, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.selection_label */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1217', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1217', 1, 62, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.code */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1117', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1117', 1, 63, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1107', 1, 65, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-024-001-000-999-0035_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-0035', 'CAN-999-999-000-999-1108', 1, 67, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1711;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1711', '<b>QR.Col-AliqMast.1711</b>: <u>DNA Aliquots Search / Recherche d''aliquots d''ADN</u><br>
DNA tubes of a bank. / Tubes d''ADN d''une banque.<br>
<FONT COLOR="#347C17"><B><U>ALIQUOT (DNA)</U></B> - <U>SAMPLE</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - STORAGE / <B><U>ALIQUOT (ADN)</U></B> - <U>&Eacute;CHANTILLON</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - ENTREPOSAGE</FONT>',  
'AliquotMaster', 
'dna_aliquot_search', 'dna_aliquot_search',
'plugin inventorymanagement aliquot detail=>/inventorymanagement/aliquot_masters/detailAliquotFromId/%%AliquotMaster.id%%/', 
'SELECT DISTINCT AliquotMaster.id, Collection.bank, Collection.bank_participant_identifier, Collection.collection_datetime, Specimen.sample_type, ParentSample.sample_type, SampleMaster.sample_type, DerivativeDetail.creation_datetime, SampleDetail.tmp_extraction_method, AliquotMaster.aliquot_type, AliquotMaster.aliquot_label, AliquotMaster.barcode, AliquotMaster.status, AliquotMaster.storage_datetime, StorageMaster.selection_label, StorageMaster.code, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, AliquotMaster.current_volume, AliquotMaster.aliquot_volume_unit, AliquotDetail.concentration, AliquotDetail.concentration_unit, AliquotDetail.tmp_storage_solution FROM collections AS Collection INNER JOIN sample_masters AS SampleMaster ON Collection.id = SampleMaster.collection_id AND SampleMaster.sample_type = "dna" INNER JOIN sample_masters AS Specimen ON Specimen.id = SampleMaster.initial_specimen_sample_id INNER JOIN sample_masters AS ParentSample ON ParentSample.id = SampleMaster.parent_id INNER JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id INNER JOIN sd_der_dnas AS SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id INNER JOIN aliquot_masters AS AliquotMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND AliquotMaster.aliquot_type = "tube" INNER JOIN ad_tubes AS AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id WHERE TRUE AND Collection.bank = "@@Collection.bank@@" AND Collection.bank_participant_identifier IN (@@Collection.bank_participant_identifier@@) AND ((Collection.collection_datetime >= "@@Collection.collection_datetime_start@@" AND Collection.collection_datetime <= "@@Collection.collection_datetime_end@@") OR (Collection.reception_datetime >= "@@Collection.collection_datetime_start@@" AND Collection.reception_datetime <= "@@Collection.collection_datetime_end@@")) AND Specimen.sample_type = "@@Specimen.sample_type@@" AND ParentSample.sample_type = "@@ParentSample.sample_type@@" AND (DerivativeDetail.creation_datetime >= "@@DerivativeDetail.creation_datetime_start@@" AND DerivativeDetail.creation_datetime <= "@@DerivativeDetail.creation_datetime_end@@") AND SampleDetail.tmp_extraction_method = "@@SampleDetail.tmp_extraction_method@@" AND AliquotMaster.status = "@@AliquotMaster.status@@" AND AliquotDetail.tmp_storage_solution = "@@AliquotDetail.tmp_storage_solution@@" ORDER BY Collection.bank_participant_identifier, Collection.collection_datetime;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --



