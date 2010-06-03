-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0032');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0032', 'search_aliquot_from_diagnosis', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0032');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* 'Collection', 'bank_participant_identifier' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0040', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0040', 1, 1, '', 0, '', 0, '', 0, '', 0, '', 1, 'tool=csv', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'OvaryBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0116', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0116', 1, 101, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'BreastBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0118', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0118', 1, 102, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''), 
/* 'ProstateBankIdentifiers', 'identifier_value' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0117', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0117', 1, 103, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Collection', 'bank' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-1001', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-1001', 1, 21, '', 1, 'qc collection bank title', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* SampleMaster.sample_type */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-1018', 1, 22, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.aliquot_type */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-1102', 1, 23, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.label */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0009', 1, 24, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
 /* AliquotMaster.barcode */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-1101', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-1101', 1, 25, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* AliquotMaster.status */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-1103', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-1103', 1, 26, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Participant.first_name */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-1', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-1', 1, 98, '', 1, 'participant', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Participant.last_name */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-2', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-2', 1, 99, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Participant.date_of_birth */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-5 ', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-5 ', 1, 33, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Participant.date_of_death */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-22', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-22', 1, 34, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Participant.vital_status */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-21', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-21', 1, 34, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Participant.last_visit_date */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0076', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0076', 1, 36, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* 'Diagnosis', 'dx_date' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-71', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-71', 1, 41, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'icd_o_grade' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0032', 1, 42, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'grade' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0101', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0101', 1, 43, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'stade_figo' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0102', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0102', 1, 44, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'morphology' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-324', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-324', 1, 45, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'sardo_morpho_desc' */
('CAN-024-001-000-999-0032_CAN-024-001-000-999-0114', 'CAN-024-001-000-999-0032', 'CAN-024-001-000-999-0114', 1, 46, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'icd10_id' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-72', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-72', 1, 47, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'laterality' */
('CAN-024-001-000-999-0032_CAN-999-999-000-002-11', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-002-11', 1, 48, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'clinical_tstage' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-83', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-83', 1, 49, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'clinical_nstage' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-84', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-84', 1, 50, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'clinical_mstage' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-85', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-85', 1, 51, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'clinical_stage_grouping' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-86', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-86', 1, 52, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'path_tstage' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-87', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-87', 1, 53, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'path_nstage' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-88', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-88', 1, 54, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'path_mstage' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-89', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-89', 1, 55, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),	  	
/* 'Diagnosis', 'path_stage_grouping' */
('CAN-024-001-000-999-0032_CAN-999-999-000-999-90', 'CAN-024-001-000-999-0032', 'CAN-999-999-000-999-90', 1, 56, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 1603;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('1603', '<b>QR.Col-AliqMast.1603</b>: <u>Aliquots Linked to Specific Diagnosis / Aliquots li&eacute;s &agrave; un diagnostique sp&eacute;cifique </u><br>
Search aliquots of a participants group linked to a specific diagnosis. (<I><FONT COLOR="#FF0000">Only aliquots linked to participant having at least one diagnosis will be studied!</FONT></I>) / Liste les aliquots d''un groupe de participants li&eacute;s &agrave; un diagnostique sp&eacute;cifique. (<I><FONT COLOR="#FF0000">Seuls les aliquots attach&eacute;s &agrave; des participants ayant au moins un diagnostique seront &eacute;tudi&eacute;s!</FONT></I>)<br>
<FONT COLOR="#347C17"><B><U>ALIQUOT</U></B> - <U>SAMPLE</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - <U>PARTICIPANT</U> - <U>DIAGNOSTIC</U> - NOLABO<I>par</I> / <B><U>ALIQUOT</U></B> - <U>&Eacute;CHANTILLON</U> - <U>COLLECTION</U> - <U>NOLABO<I>col</I></U> - <U>PARTICIPANT</U> - <U>DIAGNOSTIQUE</U> - NOLABO<I>par</I></FONT>',
'AliquotMaster', 
'search_aliquot_from_diagnosis', 'search_aliquot_from_diagnosis',
'plugin inventorymanagement aliquot detail=>/inventorymanagement/aliquot_masters/detailAliquotFromId/%%AliquotMaster.id%%/|plugin clinicalannotation participant profile=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'SELECT DISTINCT AliquotMaster.id, Participant.id, OvaryBankIdentifiers.identifier_value, BreastBankIdentifiers.identifier_value, ProstateBankIdentifiers.identifier_value, Collection.bank_participant_identifier, Collection.bank, SampleMaster.sample_type, AliquotMaster.aliquot_type, AliquotMaster.aliquot_label, AliquotMaster.barcode, AliquotMaster.status, AliquotMaster.storage_datetime, StorageMaster.selection_label, StorageMaster.code, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, AliquotMaster.current_volume, AliquotMaster.aliquot_volume_unit, Participant.first_name, Participant.last_name, Participant.date_of_birth, Participant.date_of_death, Participant.vital_status, Participant.last_visit_date, Diagnosis.dx_date, Diagnosis.icd_o_grade, Diagnosis.grade, Diagnosis.stade_figo, Diagnosis.morphology, Diagnosis.sardo_morpho_desc, Diagnosis.icd10_id, Diagnosis.laterality, Diagnosis.clinical_tstage, Diagnosis.clinical_nstage, Diagnosis.clinical_mstage, Diagnosis.clinical_stage_grouping, Diagnosis.path_tstage, Diagnosis.path_nstage, Diagnosis.path_mstage, Diagnosis.path_stage_grouping FROM aliquot_masters AS AliquotMaster INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id INNER JOIN clinical_collection_links AS Link ON Link.collection_id = Collection.id INNER JOIN participants AS Participant ON Participant.id = Link.participant_id INNER JOIN diagnoses AS Diagnosis ON Participant.id = Diagnosis.participant_id LEFT JOIN misc_identifiers AS OvaryBankIdentifiers ON Participant.id = OvaryBankIdentifiers.participant_id AND OvaryBankIdentifiers.name LIKE "ovary bank no lab" LEFT JOIN misc_identifiers AS BreastBankIdentifiers ON Participant.id = BreastBankIdentifiers.participant_id AND BreastBankIdentifiers.name LIKE "breast bank no lab" LEFT JOIN misc_identifiers AS ProstateBankIdentifiers ON Participant.id = ProstateBankIdentifiers.participant_id AND ProstateBankIdentifiers.name LIKE "prostate bank no lab" LEFT JOIN storage_masters As StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id WHERE TRUE AND Collection.bank_participant_identifier IN (@@Collection.bank_participant_identifier@@) AND Participant.vital_status = "@@Participant.vital_status@@" AND Collection.bank = "@@Collection.bank@@" AND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" AND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@" AND AliquotMaster.status = "@@AliquotMaster.status@@" AND Diagnosis.dx_date >= "@@Diagnosis.dx_date_start@@" AND Diagnosis.dx_date <= "@@Diagnosis.dx_date_end@@" AND Diagnosis.icd_o_grade = "@@Diagnosis.icd_o_grade@@" AND Diagnosis.grade = "@@Diagnosis.grade@@" AND Diagnosis.stade_figo = "@@Diagnosis.stade_figo@@" AND Diagnosis.morphology = "@@Diagnosis.morphology@@" AND Diagnosis.sardo_morpho_desc LIKE "%@@Diagnosis.sardo_morpho_desc@@%" AND Diagnosis.icd10_id = "@@Diagnosis.icd10_id@@" AND Diagnosis.laterality = "@@Diagnosis.laterality@@" AND Diagnosis.clinical_tstage = "@@Diagnosis.clinical_tstage@@" AND Diagnosis.clinical_nstage = "@@Diagnosis.clinical_nstage@@" AND Diagnosis.clinical_mstage = "@@Diagnosis.clinical_mstage@@" AND Diagnosis.clinical_stage_grouping = "@@Diagnosis.clinical_stage_grouping@@" AND Diagnosis.path_tstage = "@@Diagnosis.path_tstage@@" AND Diagnosis.path_nstage = "@@Diagnosis.path_nstage@@" AND Diagnosis.path_mstage = "@@Diagnosis.path_mstage@@" AND Diagnosis.path_stage_grouping = "@@Diagnosis.path_stage_grouping@@" ORDER BY Collection.bank_participant_identifier, SampleMaster.sample_type, AliquotMaster.aliquot_type;', 
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

