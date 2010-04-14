-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0033');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0033', 'bank_participants_aliquots_prepostchimio', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0033');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* 'Participant', 'first_name' */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1', 1, 101, '', 1, 'participant', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Participant', 'last_name' */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-2', 1, 102, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0033_CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0033', 'CAN-024-001-000-999-0116', 1, 111, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0033_CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0033', 'CAN-024-001-000-999-0118', 1, 112, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0033_CAN-024-001-000-999-0117', 'CAN-024-001-000-999-0033', 'CAN-024-001-000-999-0117', 1, 113, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'TreatmentMaster', 'start_date' */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-278', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-278', 1, 105, '', 1, 'first chemotherapy start date', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	

/* 'Collection', 'bank_participant_identifier' */
('CAN-024-001-000-999-0033_CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0033', 'CAN-024-001-000-999-0040', 1, 20, '', 0, '', 0, '', 0, '', 0, '', 1, 'tool=csv', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'bank' */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1001', 1, 21, '', 1, 'qc collection bank title', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Collection', 'collection_datetime' */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1004', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1004', 1, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Collection', 'reception_datetime' */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1006', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1006', 1, 21, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	

/* SampleMaster.sample_type */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1018', 1, 22, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_type */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1102', 1, 23, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.label */
('CAN-024-001-000-999-0033_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0033', 'CAN-024-001-000-999-0009', 1, 24, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
 /* AliquotMaster.barcode */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1101', 1, 25, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* AliquotMaster.status */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1103', 1, 26, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.storage_datetime */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1109', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1109', 1, 31, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.selection_label */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1217', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1217', 1, 32, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* StorageMaster.code */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1117', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1117', 1, 33, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_x */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1107', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1107', 1, 35, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.storage_coord_y */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1108', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1108', 1, 37, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* AliquotMaster.aliquot_volume */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1154', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1154', 1, 40, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_volume_unit */
('CAN-024-001-000-999-0033_CAN-999-999-000-999-1133', 'CAN-024-001-000-999-0033', 'CAN-999-999-000-999-1133', 1, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1604;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1604', '<b>QR.Col-AliqMast.1604</b>: <u>Pre-chemotherapy Aliquots / Aliquots pr&eacute;-chimioth&eacute;rapie</u><br>
List aliquots of a participants group of specimens collected before first chemotherapy. (<I><FONT COLOR="#FF0000">Only participant linked to at least one chemotherapy will be studied! When collection and chemotherapy dates are the same, collection will be considered as pre-chemotherapy.</FONT></I>) / Liste les aliquots d''un ensemble de participants d''&eacute;chantillons collect&eacute;s avant la premi&egrave;re chimio. (<I><FONT COLOR="#FF0000">Seuls les participants ayant subit au moins une chimio-th&eacute;rapie seront &eacute;tudi&eacute;s! lorsque les dates de chimioth&eacute;rapie et de collection sont identiques, la collection sera consid&eacute;r&eacute;e comme pr&eacute;-chimioth&eacute;rapie.</FONT></I>)<br>
<FONT COLOR="#347C17"><U>ALIQUOT</U></B> - <U>SAMPLE</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - PARTICIPANT - TREATMENT - NOLABO<I>par</I> / <B><U>ALIQUOT</U></B> - <U>&Eacute;CHANTILLON</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - PARTICIPANT - TRAITEMENT - NOLABO<I>par</I></FONT>',  
'AliquotMaster', 
'bank_participants_aliquots_prepostchimio', 'bank_participants_aliquots_prepostchimio',
'plugin inventorymanagement aliquot detail=>/inventorymanagement/aliquot_masters/detailAliquotFromId/%%AliquotMaster.id%%/|plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT AliquotMaster.id, Participant.id, Participant.first_name, Participant.last_name, OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value, TreatmentMaster.start_date, Collection.bank_participant_identifier, Collection.bank, Collection.collection_datetime, Collection.reception_datetime, SampleMaster.sample_type, AliquotMaster.aliquot_type, AliquotMaster.aliquot_label, AliquotMaster.barcode, AliquotMaster.status, AliquotMaster.storage_datetime, StorageMaster.selection_label, StorageMaster.code, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, AliquotMaster.current_volume, AliquotMaster.aliquot_volume_unit FROM aliquot_masters AS AliquotMaster INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id INNER JOIN clinical_collection_links AS Link ON Link.collection_id = Collection.id INNER JOIN participants AS Participant ON Participant.id = Link.participant_id INNER JOIN (SELECT participant_id, CAST( MIN(start_date) AS DATE) AS start_date FROM tx_masters WHERE participant_id NOT IN (SELECT participant_id FROM tx_masters WHERE `group` LIKE "chemotherapy" AND (start_date IS NULL OR start_date LIKE "0000-00-00%" OR start_date LIKE "")) AND `group` LIKE "chemotherapy" GROUP BY participant_id) AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" LEFT JOIN storage_masters As StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id WHERE TRUE AND Collection.bank_participant_identifier IN (@@Collection.bank_participant_identifier@@) AND Collection.bank = "@@Collection.bank@@" AND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" AND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@" AND AliquotMaster.status = "@@AliquotMaster.status@@" AND ((Collection.collection_datetime IS NOT NULL AND date_format( Collection.collection_datetime , "%Y-%m-%d" ) NOT LIKE "0000-00-00" AND Collection.collection_datetime NOT LIKE "" AND CAST( Collection.collection_datetime AS DATE) <= TreatmentMaster.start_date) OR ((Collection.collection_datetime IS NULL OR date_format( Collection.collection_datetime , "%Y-%m-%d" ) LIKE "0000-00-00" OR Collection.collection_datetime LIKE "") AND (Collection.reception_datetime IS NOT NULL AND date_format( Collection.reception_datetime , "%Y-%m-%d" ) NOT LIKE "0000-00-00" AND Collection.reception_datetime NOT LIKE "" AND CAST( Collection.reception_datetime AS DATE) <= TreatmentMaster.start_date))) ORDER BY SampleMaster.sample_type, AliquotMaster.aliquot_type;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('identification type', 'identification value', 'first chemotherapy start date');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('identification type', 'global', 'Identification Type', 'Type d''identification'),
('identification value', 'global', 'Identification Value', 'Valeur de l''identification'),
('first chemotherapy start date', 'global', 'First Chemo Date', 'Date 1er chimio');
