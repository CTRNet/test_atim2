-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0037');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0037', 'collected_sample_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

DELETE FROM `form_fields`
WHERE `id` IN ('CAN-024-001-000-999-0125', 'CAN-024-001-000-999-0126');

INSERT INTO `form_fields` (`id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help`, 
`install_location_id`, `install_disease_site_id`, `install_study_id`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES
('CAN-024-001-000-999-0125', 'Tissue', 'labo_laterality', '', '', 'select', '', '', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-024-001-000-999-0126', 'Blood', 'type', '', '', 'select', '', '', '', 
0, 0, 0, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `form_fields_global_lookups`  
WHERE `field_id` IN ('CAN-024-001-000-999-0125', 'CAN-024-001-000-999-0126');

INSERT INTO `form_fields_global_lookups` 
( `field_id` , `lookup_id`)
VALUES 
('CAN-024-001-000-999-0126', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'blood_type' AND `value` like 'unknown')),
('CAN-024-001-000-999-0126', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'blood_type' AND `value` like 'EDTA')),
('CAN-024-001-000-999-0126', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'blood_type' AND `value` like 'gel CSA')),
('CAN-024-001-000-999-0126', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'blood_type' AND `value` like 'heparine')),
('CAN-024-001-000-999-0126', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'blood_type' AND `value` like 'paxgene')),
('CAN-024-001-000-999-0126', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'blood_type' AND `value` like 'ZCSA')),

('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'unknown')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'D')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'EP')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'G')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'M')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'PT')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'TR')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'TRD')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'TRG')),
('CAN-024-001-000-999-0125', (SELECT `id` FROM `global_lookups` WHERE `alias` LIKE 'labo_tissue_laterality' AND `value` like 'UniLat NS'));

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0037');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* SampleMaster.sample_label */
('CAN-024-001-000-999-0037_CAN-024-001-000-999-0001', 'CAN-024-001-000-999-0037', 'CAN-024-001-000-999-0001', 1, 1, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* SampleMaster.sample_type */
('CAN-024-001-000-999-0037_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0037', 'CAN-999-999-000-999-1018', 1, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* SpecimenDetail.type_code */
('CAN-024-001-000-999-0037_CAN-024-001-000-999-0002', 'CAN-024-001-000-999-0037', 'CAN-024-001-000-999-0002', 1, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Tissue.labo_laterality */
('CAN-024-001-000-999-0037_CAN-024-001-000-999-0125', 'CAN-024-001-000-999-0037', 'CAN-024-001-000-999-0125', 1, 4, '', 1, 'precision', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Blood.type */
('CAN-024-001-000-999-0037_CAN-024-001-000-999-0126', 'CAN-024-001-000-999-0037', 'CAN-024-001-000-999-0126', 1, 5, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Collection', 'collection_datetime' */
('CAN-024-001-000-999-0037_CAN-999-999-000-999-1004', 'CAN-024-001-000-999-0037', 'CAN-999-999-000-999-1004', 1, 11, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'collection_site' */
('CAN-024-001-000-999-0037_CAN-999-999-000-999-1003', 'CAN-024-001-000-999-0037', 'CAN-999-999-000-999-1003', 1, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* SpecimenDetail.supplier_dept */
('CAN-024-001-000-999-0037_CAN-999-999-000-999-1032', 'CAN-024-001-000-999-0037', 'CAN-999-999-000-999-1032', 1, 13, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'bank' */
('CAN-024-001-000-999-0037_CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0037', 'CAN-999-999-000-999-1001', 1, 14, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'bank_participant_identifier' */
('CAN-024-001-000-999-0037_CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0037', 'CAN-024-001-000-999-0040', 1, 15, '', 0, '', 0, '', 0, '', 0, '', 1, 'tool=csv', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1300;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1300', '<b>QR.Col-SampMast.1300</b>: <u>Collected Samples / &Eacute;chantillons collect&eacute;s</u><br>
List collected samples received into a bank. / Liste les aliquots re&ccedil;us dans une banque.<br>
<FONT COLOR="#347C17"><B><U>SAMPLE</U></B> <U>COLLECTION</U> / <B><U>&Eacute;CHANTILLON</U></B> - <U>COLLECTION</U></FONT>',  
'SampleMaster', 
'collected_sample_search', 'collected_sample_search',
'plugin inventorymanagement sample detail=>/inventorymanagement/sample_masters/detailSampleFromId/', 
'SELECT DISTINCT SampleMaster.id,  SampleMaster.sample_label, Collection.bank_participant_identifier, Collection.bank, Collection.collection_site, Collection.collection_datetime, SampleMaster.sample_type, SpecimenDetail.supplier_dept, SpecimenDetail.type_code, Blood.type, Tissue.labo_laterality FROM collections AS Collection INNER JOIN sample_masters AS SampleMaster ON Collection.id = SampleMaster.collection_id AND SampleMaster.sample_category = "specimen" INNER JOIN specimen_details AS SpecimenDetail ON SampleMaster.id = SpecimenDetail.sample_master_id LEFT JOIN sd_spe_tissues AS Tissue ON SampleMaster.id = Tissue.sample_master_id LEFT JOIN sd_spe_bloods AS Blood ON SampleMaster.id = Blood.sample_master_id WHERE TRUE AND Collection.bank_participant_identifier IN (@@Collection.bank_participant_identifier@@) AND Collection.bank = "@@Collection.bank@@" AND Collection.collection_site = "@@Collection.collection_site@@" AND SpecimenDetail.supplier_dept = "@@SpecimenDetail.supplier_dept@@" AND ((Collection.collection_datetime >= "@@Collection.collection_datetime_start@@" AND Collection.collection_datetime <= "@@Collection.collection_datetime_end@@") OR (Collection.reception_datetime >= "@@Collection.collection_datetime_start@@" AND Collection.reception_datetime <= "@@Collection.collection_datetime_end@@")) ORDER BY Collection.collection_datetime, Collection.bank_participant_identifier, SampleMaster.sample_type;',
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('precision');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('precision', 'global', 'Precision', 'Pr&eacute;cision');