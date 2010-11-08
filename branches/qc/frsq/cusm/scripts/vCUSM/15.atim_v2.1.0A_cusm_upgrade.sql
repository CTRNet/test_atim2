UPDATE structure_fields SET language_label = 'created (into the system)', language_help = 'help_created'
WHERE field = 'created' AND tablename IN ('view_collections', 'view_aliquots', 'aliquot_masters', 'aliquot_uses', 'participants');
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_override_label = '0', sfo.language_label = ''
WHERE sfi.field = 'created' AND sfi.tablename IN ('view_collections', 'view_aliquots', 'aliquot_masters', 'aliquot_uses', 'participants') 
AND str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- Update View --

DROP VIEW IF EXISTS view_collections;
CREATE VIEW view_collections AS 
SELECT 
col.id AS collection_id, 
col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id, 

part.participant_identifier, 

col.acquisition_label, 
col.qc_cusm_visit_label, 
col.collection_site, 
col.collection_datetime, 
col.collection_datetime_accuracy, 
col.collection_property, 
col.collection_notes, 
col.deleted,

banks.name AS bank_name,

idents.identifier_value AS qc_cusm_prostate_bank_identifier,
col.created AS created

FROM collections AS col
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
WHERE col.deleted != 1;

DROP VIEW IF EXISTS view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.qc_cusm_visit_label,
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id AS sample_control_id,
samp.sample_code,
samp.qc_cusm_sample_label,
samp.sample_category,
samp.deleted,

idents.identifier_value AS qc_cusm_prostate_bank_identifier 

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters specimen on samp.initial_specimen_sample_id = specimen.id and specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
WHERE samp.deleted != 1;








ici





-- SEARCH INDEX FORMS REVIEW --

-- Participant --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE sfi.field IN ('sex', 'vital_status') 
AND str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- Consents --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('qc_cusm_prostate_bank_consents', 'consent_masters')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE sfi.field IN ('form_version', 'consent_status', 'status_date', 'consent_signed_date') 
AND str.alias IN ('qc_cusm_prostate_bank_consents', 'consent_masters')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE sfi.field IN ('consent_control_id') 
AND str.alias IN ('consent_masters')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- Diagnosis --

UPDATE diagnosis_controls SET flag_active = '0' WHERE controls_type != 'prostate procure diagnosis';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('diagnosismasters', 'qc_cusm_dxd_procure')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('diagnosismasters', 'qc_cusm_dxd_procure')
AND sfi.field IN ('dx_date', 'morphology', 'primary_grade', 'secondary_grade', 'tertiary_grade', 'gleason_score', 'path_tstage', 
'path_nstage', 'path_mstage', 'path_stage_summary')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('diagnosismasters')
AND sfi.field IN ('diagnosis_control_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- Annotation --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('qc_cusm_ed_procure_lifestyle')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('qc_cusm_ed_procure_lifestyle')
AND sfi.field IN ('qc_cusm_lifestyle_form_version', 'completed', 'event_date')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- Fam Hist --

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE use_field = 'FamilyHistory.participant_id';

-- Tissue --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('sd_spe_tissues')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('sd_spe_tissues')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'supplier_dept', 'reception_by', 'reception_datetime', 'tissue_source')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE `structure_value_domains` SET `source` = 'Inventorymanagement.SampleDetail::getTissueSourcePermissibleValues' 
WHERE `domain_name ` = 'tissue_source_list';

-- ad_spec_tiss_blocks --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0'
WHERE str.alias IN ('ad_spec_tiss_blocks')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'code', 'storage_datetime', 'temperature', 'temp_unit', '	study_summary_id', 'block_type', 
'qc_cusm_tissue_position_code', 'qc_cusm_tissue_section_code')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1'
WHERE str.alias IN ('ad_spec_tiss_blocks')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'storage_datetime', 'storage_coord_x', 'storage_coord_y', 'temperature', 'temp_unit', '	study_summary_id', 
'block_type', 'qc_cusm_tissue_position_code', 'qc_cusm_tissue_section_code')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;


 	
 	
 	




	
 	


, 




-- ----------------------------------------------

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0'
WHERE str.alias IN ('xxx', 'xxx')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('xxx', 'xxx')
AND sfi.field IN ('xxx', 'xxx', 'xxx', 'xxx', 'xxx', 'xxx', 'xxx')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;





