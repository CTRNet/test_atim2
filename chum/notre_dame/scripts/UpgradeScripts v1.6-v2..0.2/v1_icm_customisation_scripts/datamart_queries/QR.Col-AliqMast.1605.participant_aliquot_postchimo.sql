-- FORMS --

-- FORM FIELDS --

-- FORM FORMATS --

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1605;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1605', '<b>QR.Col-AliqMast.1605</b>: <u>Post-chemotherapy Aliquots / Aliquots post-chimioth&eacute;rapie</u><br>
List aliquots of a participants group of specimens collected after first chemotherapy. (<I><FONT COLOR="#FF0000">Only participant linked to at least one chemotherapy will be studied!</FONT></I>) / Liste les aliquots d''&eacute;chantillons collect&eacute;s avant la premi&egrave;re chimio pour un ensemble de participants. (<I><FONT COLOR="#FF0000">Seuls les participants ayant subit au moins une chimio-th&eacute;rapie seront &eacute;tudi&eacute;s! </FONT></I>)<br>
<FONT COLOR="#347C17"><U>ALIQUOT</U></B> - <U>SAMPLE</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - PARTICIPANT - TREATMENT - NOLABO<I>par</I> / <B><U>ALIQUOT</U></B> - <U>&Eacute;CHANTILLON</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - PARTICIPANT - TRAITEMENT - NOLABO<I>par</I></FONT>',  
'AliquotMaster', 
'bank_participants_aliquots_prepostchimio', 'bank_participants_aliquots_prepostchimio',
'plugin inventorymanagement aliquot detail=>/inventorymanagement/aliquot_masters/detailAliquotFromId/%%AliquotMaster.id%%/|plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT AliquotMaster.id, Participant.id, Participant.first_name, Participant.last_name, OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value, TreatmentMaster.start_date, Collection.bank_participant_identifier, Collection.bank, Collection.collection_datetime, Collection.reception_datetime, SampleMaster.sample_type, AliquotMaster.aliquot_type, AliquotMaster.aliquot_label, AliquotMaster.barcode, AliquotMaster.status, AliquotMaster.storage_datetime, StorageMaster.selection_label, StorageMaster.code, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, AliquotMaster.current_volume, AliquotMaster.aliquot_volume_unit FROM aliquot_masters AS AliquotMaster INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id INNER JOIN clinical_collection_links AS Link ON Link.collection_id = Collection.id INNER JOIN participants AS Participant ON Participant.id = Link.participant_id INNER JOIN (SELECT participant_id, CAST( MIN(start_date) AS DATE) AS start_date FROM tx_masters WHERE participant_id NOT IN (SELECT participant_id FROM tx_masters WHERE `group` LIKE "chemotherapy" AND (start_date IS NULL OR start_date LIKE "0000-00-00%" OR start_date LIKE "")) AND `group` LIKE "chemotherapy" GROUP BY participant_id) AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" LEFT JOIN storage_masters As StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id WHERE TRUE AND Collection.bank_participant_identifier IN (@@Collection.bank_participant_identifier@@) AND Collection.bank = "@@Collection.bank@@" AND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" AND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@" AND AliquotMaster.status = "@@AliquotMaster.status@@" AND ((Collection.collection_datetime IS NOT NULL AND date_format( Collection.collection_datetime , "%Y-%m-%d" ) NOT LIKE "0000-00-00" AND Collection.collection_datetime NOT LIKE "" AND CAST( Collection.collection_datetime AS DATE) > TreatmentMaster.start_date) OR ((Collection.collection_datetime IS NULL OR date_format( Collection.collection_datetime , "%Y-%m-%d" ) LIKE "0000-00-00" OR Collection.collection_datetime LIKE "") AND (Collection.reception_datetime IS NOT NULL AND date_format( Collection.reception_datetime , "%Y-%m-%d" ) NOT LIKE "0000-00-00" AND Collection.reception_datetime NOT LIKE "" AND CAST( Collection.reception_datetime AS DATE) > TreatmentMaster.start_date))) ORDER BY SampleMaster.sample_type, AliquotMaster.aliquot_type;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --
