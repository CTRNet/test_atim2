UPDATE structure_fields SET language_label = 'created (into the system)', language_help = 'help_created'
WHERE field = 'created' AND tablename IN ('view_collections', 'view_aliquots', 'aliquot_masters', 'aliquot_uses', 'participants');
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_override_label = '0', sfo.language_label = ''
WHERE sfi.field = 'created' AND sfi.tablename IN ('view_collections', 'view_aliquots', 'aliquot_masters', 'aliquot_uses', 'participants') 
AND str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('created (into the system)', 'Created (into the system)', 'Créé (dans le système)');	

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
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
WHERE samp.deleted != 1;

DROP VIEW IF EXISTS view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
col.qc_cusm_visit_label,
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type AS sample_type,
samp.sample_control_id AS sample_control_id,
al.barcode AS barcode,
al.aliquot_type AS aliquot_type,
al.aliquot_control_id AS aliquot_control_id,

al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created AS created,
al.deleted,

idents.identifier_value AS qc_cusm_prostate_bank_identifier 

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen on samp.initial_specimen_sample_id = specimen.id and specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

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
WHERE `domain_name` = 'tissue_source_list';

-- Blood --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('sd_spe_bloods')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('sd_spe_bloods')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'supplier_dept', 'reception_by', 'reception_datetime', 'blood_type')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_spe_urines --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('sd_spe_urines')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('sd_spe_urines')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'supplier_dept', 'reception_by', 'reception_datetime', 
'urine_aspect', 'qc_cusm_aspect_before_centrifugation', 'pellet_signs')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
	
-- sd_undetailed_derivatives --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('sd_undetailed_derivatives')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('sd_undetailed_derivatives')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'creation_datetime', 'creation_by', 'creation_site')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_der_plasmas --
-- sd_der_serums -- 

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('sd_der_plasmas', 'sd_der_serums')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('sd_der_plasmas', 'sd_der_serums')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'creation_datetime', 'creation_by', 'creation_site',
'hemolysis_signs')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- qc_cusm_sd_der_rnas -- 

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('qc_cusm_sd_der_rnas')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('qc_cusm_sd_der_rnas')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'creation_datetime', 'creation_by', 'creation_site')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1'
WHERE str.alias IN ('qc_cusm_sd_der_rnas')
AND sfi.field IN ('qc_cusm_micro_rna')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- qc_cusm_sd_der_centrifuged_urines -- 

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('qc_cusm_sd_der_centrifuged_urines')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('qc_cusm_sd_der_centrifuged_urines')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'creation_datetime', 'creation_by', 'creation_site',
'qc_cusm_pellet_color')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_spec_tiss_blocks --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0'
WHERE str.alias IN ('ad_spec_tiss_blocks')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'code', 'storage_datetime', 'temperature', 'temp_unit', 'study_summary_id', 'block_type', 
'qc_cusm_tissue_position_code', 'qc_cusm_tissue_section_code')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1'
WHERE str.alias IN ('ad_spec_tiss_blocks')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'storage_datetime', 'storage_coord_x', 'storage_coord_y', 'temperature', 'temp_unit', 'study_summary_id', 
'block_type', 'qc_cusm_tissue_position_code', 'qc_cusm_tissue_section_code')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_spec_tubes_incl_ml_vol --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('ad_spec_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0'
WHERE str.alias IN ('ad_spec_tubes_incl_ml_vol')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'code', 'storage_datetime', 'temperature', 'temp_unit', 'study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1'
WHERE str.alias IN ('ad_spec_tubes_incl_ml_vol')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'storage_datetime', 'storage_coord_x', 'storage_coord_y', 'temperature', 'temp_unit', 'study_summary_id', 
'current_volume', 'aliquot_volume_unit')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '0'
WHERE str.alias IN ('ad_spec_tubes_incl_ml_vol')
AND sfi.field IN ('aliquot_volume_unit')
AND sfo.display_order = '74'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	 

-- 	ad_spec_whatman_papers --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('ad_spec_whatman_papers')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0'
WHERE str.alias IN ('ad_spec_whatman_papers')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'code', 'storage_datetime', 'temperature', 'temp_unit', 'study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1'
WHERE str.alias IN ('ad_spec_whatman_papers')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'storage_datetime', 'storage_coord_x', 'storage_coord_y', 'temperature', 'temp_unit', 'study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	

-- sd_undetailed_derivatives --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('sd_undetailed_derivatives')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0', sfo.flag_index = '1'
WHERE str.alias IN ('sd_undetailed_derivatives')
AND sfi.field IN ('sample_code', 'qc_cusm_sample_label', 'supplier_dept', 'reception_by', 'reception_datetime')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_der_tubes_incl_ml_vol --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'code', 'storage_datetime', 'temperature', 'temp_unit', 'study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1'
WHERE str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'storage_datetime', 'storage_coord_x', 'storage_coord_y', 'temperature', 'temp_unit', 'study_summary_id', 
'current_volume', 'aliquot_volume_unit')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.field IN ('aliquot_volume_unit')
AND sfo.display_order = '74'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	 

-- ad_der_tubes_incl_ul_vol_and_conc --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_search_readonly = '0', sfo.flag_index = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ul_vol_and_conc')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_search_readonly = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ul_vol_and_conc')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'code', 'storage_datetime', 'temperature', 'temp_unit', 'study_summary_id',
'concentration', 'concentration_unit')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1'
WHERE str.alias IN ('ad_der_tubes_incl_ul_vol_and_conc')
AND sfi.field IN ('barcode', 'in_stock', 'in_stock_detail', 'in_stock_detail', 'selection_label', 
'storage_datetime', 'storage_coord_x', 'storage_coord_y', 'temperature', 'temp_unit', 'study_summary_id', 
'current_volume', 'aliquot_volume_unit', 'concentration', 'concentration_unit')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ul_vol_and_conc')
AND sfi.field IN ('aliquot_volume_unit')
AND sfo.display_order = '74'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	 

UPDATE i18n 
SET en = 'ATiM - Advanced Tissue Management - v.MUHC',
fr = 'ATiM - Application de gestion avancée des tissus - v.CUSM'
WHERE id = 'core_appname';

UPDATE structure_formats AS sfo, structure_fields AS sfi
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('acquisition_label') AND sfi.model IN ('Collection', 'ViewAliquot', 'ViewCollection', 'ViewSample')
AND sfi.id = sfo.structure_field_id;

UPDATE structure_fields 
SET type = 'select', 
setting = '', 
structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_cusm_histology_values'),
language_label = 'morphology (histology)'
WHERE field = 'morphology' AND tablename = 'diagnosis_masters';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('path_stage_summary') 
AND str.alias IN ('qc_cusm_dxd_procure')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE i18n 
SET en = 'PROCURE Nbr', fr = 'Numéro PROCURE' 
WHERE id = 'prostate_bank_participant_id';

UPDATE i18n 
SET en = 'Storage System Code', fr = 'Code systême entreposage' 
WHERE id = 'storage code';

UPDATE menus SET flag_active = '0' WHERE use_link = '/inventorymanagement/specimen_reviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%';

SET FOREIGN_KEY_CHECKS=0;

TRUNCATE `std_boxs`;
TRUNCATE `std_boxs_revs`;
TRUNCATE `std_cupboards`;
TRUNCATE `std_cupboards_revs`;
TRUNCATE `std_freezers`;
TRUNCATE `std_freezers_revs`;
TRUNCATE `std_fridges`;
TRUNCATE `std_fridges_revs`;
TRUNCATE `std_incubators`;
TRUNCATE `std_incubators_revs`;
TRUNCATE `std_nitro_locates`;
TRUNCATE `std_nitro_locates_revs`;
TRUNCATE `std_racks`;
TRUNCATE `std_racks_revs`;
TRUNCATE `std_rooms`;
TRUNCATE `std_rooms_revs`;
TRUNCATE `std_shelfs`;
TRUNCATE `std_shelfs_revs`;
TRUNCATE `std_tma_blocks`;
TRUNCATE `std_tma_blocks_revs`;
TRUNCATE `storage_coordinates`;
TRUNCATE `storage_coordinates_revs`;
TRUNCATE `storage_masters`;
TRUNCATE `storage_masters_revs`;

INSERT INTO `std_freezers` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, '2010-11-10 15:04:17', 1, '2010-11-10 15:04:18', 1, 0, NULL),
(2, 27, '2010-11-10 15:10:09', 1, '2010-11-10 15:10:10', 1, 0, NULL);

INSERT INTO `std_freezers_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, '2010-11-10 15:04:17', 1, '2010-11-10 15:04:17', 1, 1, '2010-11-10 15:04:17', 0, NULL),
(1, 1, '2010-11-10 15:04:17', 1, '2010-11-10 15:04:18', 1, 2, '2010-11-10 15:04:18', 0, NULL),
(2, 27, '2010-11-10 15:10:09', 1, '2010-11-10 15:10:09', 1, 3, '2010-11-10 15:10:10', 0, NULL),
(2, 27, '2010-11-10 15:10:09', 1, '2010-11-10 15:10:10', 1, 4, '2010-11-10 15:10:10', 0, NULL);

INSERT INTO `std_racks` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 7, '2010-11-10 15:05:57', 1, '2010-11-10 15:05:58', 1, 0, NULL),
(2, 8, '2010-11-10 15:06:02', 1, '2010-11-10 15:06:03', 1, 0, NULL),
(3, 9, '2010-11-10 15:06:10', 1, '2010-11-10 15:06:10', 1, 0, NULL),
(4, 10, '2010-11-10 15:06:15', 1, '2010-11-10 15:06:16', 1, 0, NULL),
(5, 11, '2010-11-10 15:06:49', 1, '2010-11-10 15:06:50', 1, 0, NULL),
(6, 12, '2010-11-10 15:06:54', 1, '2010-11-10 15:06:55', 1, 0, NULL),
(7, 13, '2010-11-10 15:07:01', 1, '2010-11-10 15:07:02', 1, 0, NULL),
(8, 14, '2010-11-10 15:07:06', 1, '2010-11-10 15:07:07', 1, 0, NULL),
(9, 15, '2010-11-10 15:07:28', 1, '2010-11-10 15:07:29', 1, 0, NULL),
(10, 16, '2010-11-10 15:07:33', 1, '2010-11-10 15:07:34', 1, 0, NULL),
(11, 17, '2010-11-10 15:07:39', 1, '2010-11-10 15:07:40', 1, 0, NULL),
(12, 18, '2010-11-10 15:07:44', 1, '2010-11-10 15:07:45', 1, 0, NULL),
(13, 19, '2010-11-10 15:08:01', 1, '2010-11-10 15:08:02', 1, 0, NULL),
(14, 20, '2010-11-10 15:08:07', 1, '2010-11-10 15:08:08', 1, 0, NULL),
(15, 21, '2010-11-10 15:08:13', 1, '2010-11-10 15:08:14', 1, 0, NULL),
(16, 22, '2010-11-10 15:08:19', 1, '2010-11-10 15:08:19', 1, 0, NULL),
(17, 23, '2010-11-10 15:08:34', 1, '2010-11-10 15:08:35', 1, 0, NULL),
(18, 24, '2010-11-10 15:08:41', 1, '2010-11-10 15:08:41', 1, 0, NULL),
(19, 25, '2010-11-10 15:08:49', 1, '2010-11-10 15:08:49', 1, 0, NULL),
(20, 26, '2010-11-10 15:08:55', 1, '2010-11-10 15:08:56', 1, 0, NULL),
(21, 33, '2010-11-10 15:12:40', 1, '2010-11-10 15:12:41', 1, 0, NULL),
(22, 34, '2010-11-10 15:12:45', 1, '2010-11-10 15:12:46', 1, 0, NULL),
(23, 35, '2010-11-10 15:12:54', 1, '2010-11-10 15:12:54', 1, 0, NULL),
(24, 36, '2010-11-10 15:13:01', 1, '2010-11-10 15:13:02', 1, 0, NULL),
(25, 37, '2010-11-10 15:13:16', 1, '2010-11-10 15:13:17', 1, 0, NULL),
(26, 38, '2010-11-10 15:13:23', 1, '2010-11-10 15:13:23', 1, 0, NULL),
(27, 39, '2010-11-10 15:13:29', 1, '2010-11-10 15:13:30', 1, 0, NULL),
(28, 40, '2010-11-10 15:13:35', 1, '2010-11-10 15:13:36', 1, 0, NULL),
(29, 41, '2010-11-10 15:13:57', 1, '2010-11-10 15:13:58', 1, 0, NULL),
(30, 42, '2010-11-10 15:14:03', 1, '2010-11-10 15:14:04', 1, 0, NULL),
(31, 43, '2010-11-10 15:14:10', 1, '2010-11-10 15:14:10', 1, 0, NULL),
(32, 44, '2010-11-10 15:14:16', 1, '2010-11-10 15:14:17', 1, 0, NULL),
(33, 45, '2010-11-10 15:14:41', 1, '2010-11-10 15:14:42', 1, 0, NULL),
(34, 46, '2010-11-10 15:14:47', 1, '2010-11-10 15:14:47', 1, 0, NULL),
(35, 47, '2010-11-10 15:14:54', 1, '2010-11-10 15:14:54', 1, 0, NULL),
(36, 48, '2010-11-10 15:14:59', 1, '2010-11-10 15:14:59', 1, 0, NULL),
(37, 49, '2010-11-10 15:15:23', 1, '2010-11-10 15:15:23', 1, 0, NULL),
(38, 50, '2010-11-10 15:15:31', 1, '2010-11-10 15:15:32', 1, 0, NULL),
(39, 51, '2010-11-10 15:15:38', 1, '2010-11-10 15:15:38', 1, 0, NULL),
(40, 52, '2010-11-10 15:15:43', 1, '2010-11-10 15:15:44', 1, 0, NULL);

INSERT INTO `std_racks_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 7, '2010-11-10 15:05:57', 1, '2010-11-10 15:05:57', 1, 1, '2010-11-10 15:05:57', 0, NULL),
(1, 7, '2010-11-10 15:05:57', 1, '2010-11-10 15:05:58', 1, 2, '2010-11-10 15:05:58', 0, NULL),
(2, 8, '2010-11-10 15:06:02', 1, '2010-11-10 15:06:02', 1, 3, '2010-11-10 15:06:02', 0, NULL),
(2, 8, '2010-11-10 15:06:02', 1, '2010-11-10 15:06:03', 1, 4, '2010-11-10 15:06:03', 0, NULL),
(3, 9, '2010-11-10 15:06:10', 1, '2010-11-10 15:06:10', 1, 5, '2010-11-10 15:06:10', 0, NULL),
(4, 10, '2010-11-10 15:06:15', 1, '2010-11-10 15:06:15', 1, 6, '2010-11-10 15:06:15', 0, NULL),
(4, 10, '2010-11-10 15:06:15', 1, '2010-11-10 15:06:16', 1, 7, '2010-11-10 15:06:16', 0, NULL),
(5, 11, '2010-11-10 15:06:49', 1, '2010-11-10 15:06:49', 1, 8, '2010-11-10 15:06:50', 0, NULL),
(5, 11, '2010-11-10 15:06:49', 1, '2010-11-10 15:06:50', 1, 9, '2010-11-10 15:06:50', 0, NULL),
(6, 12, '2010-11-10 15:06:54', 1, '2010-11-10 15:06:54', 1, 10, '2010-11-10 15:06:54', 0, NULL),
(6, 12, '2010-11-10 15:06:54', 1, '2010-11-10 15:06:55', 1, 11, '2010-11-10 15:06:55', 0, NULL),
(7, 13, '2010-11-10 15:07:01', 1, '2010-11-10 15:07:01', 1, 12, '2010-11-10 15:07:01', 0, NULL),
(7, 13, '2010-11-10 15:07:01', 1, '2010-11-10 15:07:02', 1, 13, '2010-11-10 15:07:02', 0, NULL),
(8, 14, '2010-11-10 15:07:06', 1, '2010-11-10 15:07:06', 1, 14, '2010-11-10 15:07:06', 0, NULL),
(8, 14, '2010-11-10 15:07:06', 1, '2010-11-10 15:07:07', 1, 15, '2010-11-10 15:07:07', 0, NULL),
(9, 15, '2010-11-10 15:07:28', 1, '2010-11-10 15:07:28', 1, 16, '2010-11-10 15:07:28', 0, NULL),
(9, 15, '2010-11-10 15:07:28', 1, '2010-11-10 15:07:29', 1, 17, '2010-11-10 15:07:29', 0, NULL),
(10, 16, '2010-11-10 15:07:33', 1, '2010-11-10 15:07:33', 1, 18, '2010-11-10 15:07:33', 0, NULL),
(10, 16, '2010-11-10 15:07:33', 1, '2010-11-10 15:07:34', 1, 19, '2010-11-10 15:07:34', 0, NULL),
(11, 17, '2010-11-10 15:07:39', 1, '2010-11-10 15:07:39', 1, 20, '2010-11-10 15:07:39', 0, NULL),
(11, 17, '2010-11-10 15:07:39', 1, '2010-11-10 15:07:40', 1, 21, '2010-11-10 15:07:40', 0, NULL),
(12, 18, '2010-11-10 15:07:44', 1, '2010-11-10 15:07:44', 1, 22, '2010-11-10 15:07:44', 0, NULL),
(12, 18, '2010-11-10 15:07:44', 1, '2010-11-10 15:07:45', 1, 23, '2010-11-10 15:07:45', 0, NULL),
(13, 19, '2010-11-10 15:08:01', 1, '2010-11-10 15:08:01', 1, 24, '2010-11-10 15:08:02', 0, NULL),
(13, 19, '2010-11-10 15:08:01', 1, '2010-11-10 15:08:02', 1, 25, '2010-11-10 15:08:02', 0, NULL),
(14, 20, '2010-11-10 15:08:07', 1, '2010-11-10 15:08:07', 1, 26, '2010-11-10 15:08:07', 0, NULL),
(14, 20, '2010-11-10 15:08:07', 1, '2010-11-10 15:08:08', 1, 27, '2010-11-10 15:08:08', 0, NULL),
(15, 21, '2010-11-10 15:08:13', 1, '2010-11-10 15:08:13', 1, 28, '2010-11-10 15:08:14', 0, NULL),
(15, 21, '2010-11-10 15:08:13', 1, '2010-11-10 15:08:14', 1, 29, '2010-11-10 15:08:14', 0, NULL),
(16, 22, '2010-11-10 15:08:19', 1, '2010-11-10 15:08:19', 1, 30, '2010-11-10 15:08:19', 0, NULL),
(17, 23, '2010-11-10 15:08:34', 1, '2010-11-10 15:08:34', 1, 31, '2010-11-10 15:08:34', 0, NULL),
(17, 23, '2010-11-10 15:08:34', 1, '2010-11-10 15:08:35', 1, 32, '2010-11-10 15:08:35', 0, NULL),
(18, 24, '2010-11-10 15:08:41', 1, '2010-11-10 15:08:41', 1, 33, '2010-11-10 15:08:41', 0, NULL),
(19, 25, '2010-11-10 15:08:49', 1, '2010-11-10 15:08:49', 1, 34, '2010-11-10 15:08:49', 0, NULL),
(20, 26, '2010-11-10 15:08:55', 1, '2010-11-10 15:08:55', 1, 35, '2010-11-10 15:08:55', 0, NULL),
(20, 26, '2010-11-10 15:08:55', 1, '2010-11-10 15:08:56', 1, 36, '2010-11-10 15:08:56', 0, NULL),
(21, 33, '2010-11-10 15:12:40', 1, '2010-11-10 15:12:40', 1, 37, '2010-11-10 15:12:40', 0, NULL),
(21, 33, '2010-11-10 15:12:40', 1, '2010-11-10 15:12:41', 1, 38, '2010-11-10 15:12:41', 0, NULL),
(22, 34, '2010-11-10 15:12:45', 1, '2010-11-10 15:12:45', 1, 39, '2010-11-10 15:12:45', 0, NULL),
(22, 34, '2010-11-10 15:12:45', 1, '2010-11-10 15:12:46', 1, 40, '2010-11-10 15:12:46', 0, NULL),
(23, 35, '2010-11-10 15:12:54', 1, '2010-11-10 15:12:54', 1, 41, '2010-11-10 15:12:54', 0, NULL),
(24, 36, '2010-11-10 15:13:01', 1, '2010-11-10 15:13:01', 1, 42, '2010-11-10 15:13:01', 0, NULL),
(24, 36, '2010-11-10 15:13:01', 1, '2010-11-10 15:13:02', 1, 43, '2010-11-10 15:13:02', 0, NULL),
(25, 37, '2010-11-10 15:13:16', 1, '2010-11-10 15:13:16', 1, 44, '2010-11-10 15:13:17', 0, NULL),
(25, 37, '2010-11-10 15:13:16', 1, '2010-11-10 15:13:17', 1, 45, '2010-11-10 15:13:17', 0, NULL),
(26, 38, '2010-11-10 15:13:23', 1, '2010-11-10 15:13:23', 1, 46, '2010-11-10 15:13:23', 0, NULL),
(27, 39, '2010-11-10 15:13:29', 1, '2010-11-10 15:13:29', 1, 47, '2010-11-10 15:13:29', 0, NULL),
(27, 39, '2010-11-10 15:13:29', 1, '2010-11-10 15:13:30', 1, 48, '2010-11-10 15:13:30', 0, NULL),
(28, 40, '2010-11-10 15:13:35', 1, '2010-11-10 15:13:35', 1, 49, '2010-11-10 15:13:35', 0, NULL),
(28, 40, '2010-11-10 15:13:35', 1, '2010-11-10 15:13:36', 1, 50, '2010-11-10 15:13:36', 0, NULL),
(29, 41, '2010-11-10 15:13:57', 1, '2010-11-10 15:13:57', 1, 51, '2010-11-10 15:13:57', 0, NULL),
(29, 41, '2010-11-10 15:13:57', 1, '2010-11-10 15:13:58', 1, 52, '2010-11-10 15:13:58', 0, NULL),
(30, 42, '2010-11-10 15:14:03', 1, '2010-11-10 15:14:03', 1, 53, '2010-11-10 15:14:03', 0, NULL),
(30, 42, '2010-11-10 15:14:03', 1, '2010-11-10 15:14:04', 1, 54, '2010-11-10 15:14:04', 0, NULL),
(31, 43, '2010-11-10 15:14:10', 1, '2010-11-10 15:14:10', 1, 55, '2010-11-10 15:14:10', 0, NULL),
(32, 44, '2010-11-10 15:14:16', 1, '2010-11-10 15:14:16', 1, 56, '2010-11-10 15:14:16', 0, NULL),
(32, 44, '2010-11-10 15:14:16', 1, '2010-11-10 15:14:17', 1, 57, '2010-11-10 15:14:17', 0, NULL),
(33, 45, '2010-11-10 15:14:41', 1, '2010-11-10 15:14:41', 1, 58, '2010-11-10 15:14:41', 0, NULL),
(33, 45, '2010-11-10 15:14:41', 1, '2010-11-10 15:14:42', 1, 59, '2010-11-10 15:14:42', 0, NULL),
(34, 46, '2010-11-10 15:14:47', 1, '2010-11-10 15:14:47', 1, 60, '2010-11-10 15:14:47', 0, NULL),
(35, 47, '2010-11-10 15:14:54', 1, '2010-11-10 15:14:54', 1, 61, '2010-11-10 15:14:54', 0, NULL),
(36, 48, '2010-11-10 15:14:59', 1, '2010-11-10 15:14:59', 1, 62, '2010-11-10 15:14:59', 0, NULL),
(37, 49, '2010-11-10 15:15:23', 1, '2010-11-10 15:15:23', 1, 63, '2010-11-10 15:15:23', 0, NULL),
(38, 50, '2010-11-10 15:15:31', 1, '2010-11-10 15:15:31', 1, 64, '2010-11-10 15:15:31', 0, NULL),
(38, 50, '2010-11-10 15:15:31', 1, '2010-11-10 15:15:32', 1, 65, '2010-11-10 15:15:32', 0, NULL),
(39, 51, '2010-11-10 15:15:38', 1, '2010-11-10 15:15:38', 1, 66, '2010-11-10 15:15:38', 0, NULL),
(40, 52, '2010-11-10 15:15:43', 1, '2010-11-10 15:15:43', 1, 67, '2010-11-10 15:15:43', 0, NULL),
(40, 52, '2010-11-10 15:15:43', 1, '2010-11-10 15:15:44', 1, 68, '2010-11-10 15:15:44', 0, NULL);

INSERT INTO `std_shelfs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-11-10 15:04:41', 1, '2010-11-10 15:04:42', 1, 0, NULL),
(2, 3, '2010-11-10 15:04:46', 1, '2010-11-10 15:04:47', 1, 0, NULL),
(3, 4, '2010-11-10 15:04:54', 1, '2010-11-10 15:04:55', 1, 0, NULL),
(4, 5, '2010-11-10 15:04:59', 1, '2010-11-10 15:04:59', 1, 0, NULL),
(5, 6, '2010-11-10 15:05:24', 1, '2010-11-10 15:05:25', 1, 0, NULL),
(6, 28, '2010-11-10 15:10:30', 1, '2010-11-10 15:10:31', 1, 0, NULL),
(7, 29, '2010-11-10 15:10:35', 1, '2010-11-10 15:10:36', 1, 0, NULL),
(8, 30, '2010-11-10 15:10:41', 1, '2010-11-10 15:10:42', 1, 0, NULL),
(9, 31, '2010-11-10 15:10:48', 1, '2010-11-10 15:10:48', 1, 0, NULL),
(10, 32, '2010-11-10 15:11:03', 1, '2010-11-10 15:12:04', 1, 0, NULL);

INSERT INTO `std_shelfs_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-11-10 15:04:41', 1, '2010-11-10 15:04:41', 1, 1, '2010-11-10 15:04:41', 0, NULL),
(1, 2, '2010-11-10 15:04:41', 1, '2010-11-10 15:04:42', 1, 2, '2010-11-10 15:04:42', 0, NULL),
(2, 3, '2010-11-10 15:04:46', 1, '2010-11-10 15:04:46', 1, 3, '2010-11-10 15:04:46', 0, NULL),
(2, 3, '2010-11-10 15:04:46', 1, '2010-11-10 15:04:47', 1, 4, '2010-11-10 15:04:47', 0, NULL),
(3, 4, '2010-11-10 15:04:54', 1, '2010-11-10 15:04:54', 1, 5, '2010-11-10 15:04:54', 0, NULL),
(3, 4, '2010-11-10 15:04:54', 1, '2010-11-10 15:04:55', 1, 6, '2010-11-10 15:04:55', 0, NULL),
(4, 5, '2010-11-10 15:04:59', 1, '2010-11-10 15:04:59', 1, 7, '2010-11-10 15:04:59', 0, NULL),
(5, 6, '2010-11-10 15:05:24', 1, '2010-11-10 15:05:24', 1, 8, '2010-11-10 15:05:24', 0, NULL),
(5, 6, '2010-11-10 15:05:24', 1, '2010-11-10 15:05:25', 1, 9, '2010-11-10 15:05:25', 0, NULL),
(6, 28, '2010-11-10 15:10:30', 1, '2010-11-10 15:10:30', 1, 10, '2010-11-10 15:10:30', 0, NULL),
(6, 28, '2010-11-10 15:10:30', 1, '2010-11-10 15:10:31', 1, 11, '2010-11-10 15:10:31', 0, NULL),
(7, 29, '2010-11-10 15:10:35', 1, '2010-11-10 15:10:35', 1, 12, '2010-11-10 15:10:35', 0, NULL),
(7, 29, '2010-11-10 15:10:35', 1, '2010-11-10 15:10:36', 1, 13, '2010-11-10 15:10:36', 0, NULL),
(8, 30, '2010-11-10 15:10:41', 1, '2010-11-10 15:10:41', 1, 14, '2010-11-10 15:10:41', 0, NULL),
(8, 30, '2010-11-10 15:10:41', 1, '2010-11-10 15:10:42', 1, 15, '2010-11-10 15:10:42', 0, NULL),
(9, 31, '2010-11-10 15:10:48', 1, '2010-11-10 15:10:48', 1, 16, '2010-11-10 15:10:48', 0, NULL),
(10, 32, '2010-11-10 15:11:03', 1, '2010-11-10 15:11:03', 1, 17, '2010-11-10 15:11:03', 0, NULL),
(10, 32, '2010-11-10 15:11:03', 1, '2010-11-10 15:11:04', 1, 18, '2010-11-10 15:11:04', 0, NULL),
(10, 32, '2010-11-10 15:11:03', 1, '2010-11-10 15:12:04', 1, 19, '2010-11-10 15:12:04', 0, NULL);

INSERT INTO `storage_masters` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `label_precision`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'FRE - 1', 'freezer', 6, NULL, 1, 52, NULL, 'fr1', '', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2010-11-10 15:04:17', 1, '2010-11-10 15:04:18', 1, 0, NULL),
(2, 'SH - 2', 'shelf', 14, 1, 2, 11, NULL, '1', '', 'fr1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:41', 1, '2010-11-10 15:04:41', 1, 0, NULL),
(3, 'SH - 3', 'shelf', 14, 1, 12, 21, NULL, '2', '', 'fr1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:46', 1, '2010-11-10 15:04:47', 1, 0, NULL),
(4, 'SH - 4', 'shelf', 14, 1, 22, 31, NULL, '3', '', 'fr1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:54', 1, '2010-11-10 15:04:55', 1, 0, NULL),
(5, 'SH - 5', 'shelf', 14, 1, 32, 41, NULL, '4', '', 'fr1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:58', 1, '2010-11-10 15:04:59', 1, 0, NULL),
(6, 'SH - 6', 'shelf', 14, 1, 42, 51, NULL, '5', '', 'fr1-5', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:05:24', 1, '2010-11-10 15:05:24', 1, 0, NULL),
(7, 'R - 7', 'rack 4x4', 21, 6, 43, 44, NULL, '1', '', 'fr1-5-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:05:57', 1, '2010-11-10 15:05:58', 1, 0, NULL),
(8, 'R - 8', 'rack 4x4', 21, 6, 45, 46, NULL, '2', '', 'fr1-5-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:02', 1, '2010-11-10 15:06:03', 1, 0, NULL),
(9, 'R - 9', 'rack 4x4', 21, 6, 47, 48, NULL, '3', '', 'fr1-5-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:09', 1, '2010-11-10 15:06:10', 1, 0, NULL),
(10, 'R - 10', 'rack 4x4', 21, 6, 49, 50, NULL, '4', '', 'fr1-5-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:15', 1, '2010-11-10 15:06:16', 1, 0, NULL),
(11, 'R - 11', 'rack 4x4', 21, 2, 3, 4, NULL, '1', '', 'fr1-1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:49', 1, '2010-11-10 15:06:50', 1, 0, NULL),
(12, 'R - 12', 'rack 4x4', 21, 2, 5, 6, NULL, '2', '', 'fr1-1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:54', 1, '2010-11-10 15:06:54', 1, 0, NULL),
(13, 'R - 13', 'rack 4x4', 21, 2, 7, 8, NULL, '3', '', 'fr1-1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:01', 1, '2010-11-10 15:07:02', 1, 0, NULL),
(14, 'R - 14', 'rack 4x4', 21, 2, 9, 10, NULL, '4', '', 'fr1-1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:06', 1, '2010-11-10 15:07:06', 1, 0, NULL),
(15, 'R - 15', 'rack 4x4', 21, 3, 13, 14, NULL, '1', '', 'fr1-2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:28', 1, '2010-11-10 15:07:29', 1, 0, NULL),
(16, 'R - 16', 'rack 4x4', 21, 3, 15, 16, NULL, '2', '', 'fr1-2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:33', 1, '2010-11-10 15:07:34', 1, 0, NULL),
(17, 'R - 17', 'rack 4x4', 21, 3, 17, 18, NULL, '3', '', 'fr1-2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:39', 1, '2010-11-10 15:07:40', 1, 0, NULL),
(18, 'R - 18', 'rack 4x4', 21, 3, 19, 20, NULL, '4', '', 'fr1-2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:44', 1, '2010-11-10 15:07:45', 1, 0, NULL),
(19, 'R - 19', 'rack 4x4', 21, 4, 23, 24, NULL, '1', '', 'fr1-3-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:01', 1, '2010-11-10 15:08:02', 1, 0, NULL),
(20, 'R - 20', 'rack 4x4', 21, 4, 25, 26, NULL, '2', '', 'fr1-3-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:07', 1, '2010-11-10 15:08:08', 1, 0, NULL),
(21, 'R - 21', 'rack 4x4', 21, 4, 27, 28, NULL, '3', '', 'fr1-3-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:13', 1, '2010-11-10 15:08:14', 1, 0, NULL),
(22, 'R - 22', 'rack 4x4', 21, 4, 29, 30, NULL, '4', '', 'fr1-3-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:19', 1, '2010-11-10 15:08:19', 1, 0, NULL),
(23, 'R - 23', 'rack 4x4', 21, 5, 33, 34, NULL, '1', '', 'fr1-4-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:34', 1, '2010-11-10 15:08:35', 1, 0, NULL),
(24, 'R - 24', 'rack 4x4', 21, 5, 35, 36, NULL, '2', '', 'fr1-4-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:40', 1, '2010-11-10 15:08:41', 1, 0, NULL),
(25, 'R - 25', 'rack 4x4', 21, 5, 37, 38, NULL, '3', '', 'fr1-4-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:49', 1, '2010-11-10 15:08:49', 1, 0, NULL),
(26, 'R - 26', 'rack 4x4', 21, 5, 39, 40, NULL, '4', '', 'fr1-4-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:55', 1, '2010-11-10 15:08:55', 1, 0, NULL),
(27, 'FRE - 27', 'freezer', 6, NULL, 53, 104, NULL, 'fr2', '', 'fr2', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2010-11-10 15:10:09', 1, '2010-11-10 15:10:10', 1, 0, NULL),
(28, 'SH - 28', 'shelf', 14, 27, 54, 63, NULL, '1', '', 'fr2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:30', 1, '2010-11-10 15:10:31', 1, 0, NULL),
(29, 'SH - 29', 'shelf', 14, 27, 64, 73, NULL, '2', '', 'fr2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:35', 1, '2010-11-10 15:10:36', 1, 0, NULL),
(30, 'SH - 30', 'shelf', 14, 27, 74, 83, NULL, '3', '', 'fr2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:41', 1, '2010-11-10 15:10:42', 1, 0, NULL),
(31, 'SH - 31', 'shelf', 14, 27, 84, 93, NULL, '4', '', 'fr2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:48', 1, '2010-11-10 15:10:48', 1, 0, NULL),
(32, 'SH - 32', 'shelf', 14, 27, 94, 103, NULL, '5', '', 'fr2-5', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:11:03', 1, '2010-11-10 15:12:04', 1, 0, NULL),
(33, 'R - 33', 'rack 4x4', 21, 28, 55, 56, NULL, '1', '', 'fr2-1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:40', 1, '2010-11-10 15:12:41', 1, 0, NULL),
(34, 'R - 34', 'rack 4x4', 21, 28, 57, 58, NULL, '2', '', 'fr2-1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:45', 1, '2010-11-10 15:12:46', 1, 0, NULL),
(35, 'R - 35', 'rack 4x4', 21, 28, 59, 60, NULL, '3', '', 'fr2-1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:53', 1, '2010-11-10 15:12:54', 1, 0, NULL),
(36, 'R - 36', 'rack 4x4', 21, 28, 61, 62, NULL, '4', '', 'fr2-1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:01', 1, '2010-11-10 15:13:02', 1, 0, NULL),
(37, 'R - 37', 'rack 4x4', 21, 29, 65, 66, NULL, '1', '', 'fr2-2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:16', 1, '2010-11-10 15:13:17', 1, 0, NULL),
(38, 'R - 38', 'rack 4x4', 21, 29, 67, 68, NULL, '2', '', 'fr2-2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:22', 1, '2010-11-10 15:13:23', 1, 0, NULL),
(39, 'R - 39', 'rack 4x4', 21, 29, 69, 70, NULL, '3', '', 'fr2-2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:29', 1, '2010-11-10 15:13:30', 1, 0, NULL),
(40, 'R - 40', 'rack 4x4', 21, 29, 71, 72, NULL, '4', '', 'fr2-2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:35', 1, '2010-11-10 15:13:36', 1, 0, NULL),
(41, 'R - 41', 'rack 4x4', 21, 30, 75, 76, NULL, '1', '', 'fr2-3-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:57', 1, '2010-11-10 15:13:58', 1, 0, NULL),
(42, 'R - 42', 'rack 4x4', 21, 30, 77, 78, NULL, '2', '', 'fr2-3-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:03', 1, '2010-11-10 15:14:03', 1, 0, NULL),
(43, 'R - 43', 'rack 4x4', 21, 30, 79, 80, NULL, '3', '', 'fr2-3-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:10', 1, '2010-11-10 15:14:10', 1, 0, NULL),
(44, 'R - 44', 'rack 4x4', 21, 30, 81, 82, NULL, '4', '', 'fr2-3-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:16', 1, '2010-11-10 15:14:17', 1, 0, NULL),
(45, 'R - 45', 'rack 4x4', 21, 31, 85, 86, NULL, '1', '', 'fr2-4-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:41', 1, '2010-11-10 15:14:42', 1, 0, NULL),
(46, 'R - 46', 'rack 4x4', 21, 31, 87, 88, NULL, '2', '', 'fr2-4-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:46', 1, '2010-11-10 15:14:47', 1, 0, NULL),
(47, 'R - 47', 'rack 4x4', 21, 31, 89, 90, NULL, '3', '', 'fr2-4-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:53', 1, '2010-11-10 15:14:54', 1, 0, NULL),
(48, 'R - 48', 'rack 4x4', 21, 31, 91, 92, NULL, '4', '', 'fr2-4-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:59', 1, '2010-11-10 15:14:59', 1, 0, NULL),
(49, 'R - 49', 'rack 4x4', 21, 32, 95, 96, NULL, '1', '', 'fr2-5-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:23', 1, '2010-11-10 15:15:23', 1, 0, NULL),
(50, 'R - 50', 'rack 4x4', 21, 32, 97, 98, NULL, '2', '', 'fr2-5-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:31', 1, '2010-11-10 15:15:32', 1, 0, NULL),
(51, 'R - 51', 'rack 4x4', 21, 32, 99, 100, NULL, '3', '', 'fr2-5-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:38', 1, '2010-11-10 15:15:38', 1, 0, NULL),
(52, 'R - 52', 'rack 4x4', 21, 32, 101, 102, NULL, '4', '', 'fr2-5-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:43', 1, '2010-11-10 15:15:44', 1, 0, NULL);

INSERT INTO `storage_masters_revs` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `label_precision`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '', 'freezer', 6, NULL, 1, 2, NULL, 'fr1', '', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2010-11-10 15:04:17', 1, '2010-11-10 15:04:17', 1, 1, '2010-11-10 15:04:17', 0, NULL),
(1, 'FRE - 1', 'freezer', 6, NULL, 1, 2, NULL, 'fr1', '', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2010-11-10 15:04:17', 1, '2010-11-10 15:04:18', 1, 2, '2010-11-10 15:04:18', 0, NULL),
(2, '', 'shelf', 14, 1, 0, 0, NULL, '1', '', 'fr1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:41', 1, '2010-11-10 15:04:41', 1, 3, '2010-11-10 15:04:41', 0, NULL),
(2, 'SH - 2', 'shelf', 14, 1, 2, 3, NULL, '1', '', 'fr1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:41', 1, '2010-11-10 15:04:41', 1, 4, '2010-11-10 15:04:42', 0, NULL),
(3, '', 'shelf', 14, 1, 0, 0, NULL, '2', '', 'fr1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:46', 1, '2010-11-10 15:04:46', 1, 5, '2010-11-10 15:04:46', 0, NULL),
(3, 'SH - 3', 'shelf', 14, 1, 4, 5, NULL, '2', '', 'fr1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:46', 1, '2010-11-10 15:04:47', 1, 6, '2010-11-10 15:04:47', 0, NULL),
(4, '', 'shelf', 14, 1, 0, 0, NULL, '3', '', 'fr1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:54', 1, '2010-11-10 15:04:54', 1, 7, '2010-11-10 15:04:54', 0, NULL),
(4, 'SH - 4', 'shelf', 14, 1, 6, 7, NULL, '3', '', 'fr1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:54', 1, '2010-11-10 15:04:55', 1, 8, '2010-11-10 15:04:55', 0, NULL),
(5, '', 'shelf', 14, 1, 0, 0, NULL, '4', '', 'fr1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:58', 1, '2010-11-10 15:04:58', 1, 9, '2010-11-10 15:04:59', 0, NULL),
(5, 'SH - 5', 'shelf', 14, 1, 8, 9, NULL, '4', '', 'fr1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:04:58', 1, '2010-11-10 15:04:59', 1, 10, '2010-11-10 15:04:59', 0, NULL),
(6, '', 'shelf', 14, 1, 0, 0, NULL, '5', '', 'fr1-5', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:05:24', 1, '2010-11-10 15:05:24', 1, 11, '2010-11-10 15:05:24', 0, NULL),
(6, 'SH - 6', 'shelf', 14, 1, 10, 11, NULL, '5', '', 'fr1-5', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:05:24', 1, '2010-11-10 15:05:24', 1, 12, '2010-11-10 15:05:25', 0, NULL),
(7, '', 'rack 4x4', 21, 6, 0, 0, NULL, '1', '', 'fr1-5-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:05:57', 1, '2010-11-10 15:05:57', 1, 13, '2010-11-10 15:05:57', 0, NULL),
(7, 'R - 7', 'rack 4x4', 21, 6, 11, 12, NULL, '1', '', 'fr1-5-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:05:57', 1, '2010-11-10 15:05:58', 1, 14, '2010-11-10 15:05:58', 0, NULL),
(8, '', 'rack 4x4', 21, 6, 0, 0, NULL, '2', '', 'fr1-5-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:02', 1, '2010-11-10 15:06:02', 1, 15, '2010-11-10 15:06:02', 0, NULL),
(8, 'R - 8', 'rack 4x4', 21, 6, 13, 14, NULL, '2', '', 'fr1-5-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:02', 1, '2010-11-10 15:06:03', 1, 16, '2010-11-10 15:06:03', 0, NULL),
(9, '', 'rack 4x4', 21, 6, 0, 0, NULL, '3', '', 'fr1-5-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:09', 1, '2010-11-10 15:06:09', 1, 17, '2010-11-10 15:06:10', 0, NULL),
(9, 'R - 9', 'rack 4x4', 21, 6, 15, 16, NULL, '3', '', 'fr1-5-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:09', 1, '2010-11-10 15:06:10', 1, 18, '2010-11-10 15:06:10', 0, NULL),
(10, '', 'rack 4x4', 21, 6, 0, 0, NULL, '4', '', 'fr1-5-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:15', 1, '2010-11-10 15:06:15', 1, 19, '2010-11-10 15:06:15', 0, NULL),
(10, 'R - 10', 'rack 4x4', 21, 6, 17, 18, NULL, '4', '', 'fr1-5-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:15', 1, '2010-11-10 15:06:16', 1, 20, '2010-11-10 15:06:16', 0, NULL),
(11, '', 'rack 4x4', 21, 2, 0, 0, NULL, '1', '', 'fr1-1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:49', 1, '2010-11-10 15:06:49', 1, 21, '2010-11-10 15:06:50', 0, NULL),
(11, 'R - 11', 'rack 4x4', 21, 2, 3, 4, NULL, '1', '', 'fr1-1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:49', 1, '2010-11-10 15:06:50', 1, 22, '2010-11-10 15:06:50', 0, NULL),
(12, '', 'rack 4x4', 21, 2, 0, 0, NULL, '2', '', 'fr1-1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:54', 1, '2010-11-10 15:06:54', 1, 23, '2010-11-10 15:06:54', 0, NULL),
(12, 'R - 12', 'rack 4x4', 21, 2, 5, 6, NULL, '2', '', 'fr1-1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:06:54', 1, '2010-11-10 15:06:54', 1, 24, '2010-11-10 15:06:55', 0, NULL),
(13, '', 'rack 4x4', 21, 2, 0, 0, NULL, '3', '', 'fr1-1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:01', 1, '2010-11-10 15:07:01', 1, 25, '2010-11-10 15:07:01', 0, NULL),
(13, 'R - 13', 'rack 4x4', 21, 2, 7, 8, NULL, '3', '', 'fr1-1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:01', 1, '2010-11-10 15:07:02', 1, 26, '2010-11-10 15:07:02', 0, NULL),
(14, '', 'rack 4x4', 21, 2, 0, 0, NULL, '4', '', 'fr1-1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:06', 1, '2010-11-10 15:07:06', 1, 27, '2010-11-10 15:07:06', 0, NULL),
(14, 'R - 14', 'rack 4x4', 21, 2, 9, 10, NULL, '4', '', 'fr1-1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:06', 1, '2010-11-10 15:07:06', 1, 28, '2010-11-10 15:07:07', 0, NULL),
(15, '', 'rack 4x4', 21, 3, 0, 0, NULL, '1', '', 'fr1-2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:28', 1, '2010-11-10 15:07:28', 1, 29, '2010-11-10 15:07:28', 0, NULL),
(15, 'R - 15', 'rack 4x4', 21, 3, 13, 14, NULL, '1', '', 'fr1-2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:28', 1, '2010-11-10 15:07:29', 1, 30, '2010-11-10 15:07:29', 0, NULL),
(16, '', 'rack 4x4', 21, 3, 0, 0, NULL, '2', '', 'fr1-2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:33', 1, '2010-11-10 15:07:33', 1, 31, '2010-11-10 15:07:33', 0, NULL),
(16, 'R - 16', 'rack 4x4', 21, 3, 15, 16, NULL, '2', '', 'fr1-2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:33', 1, '2010-11-10 15:07:34', 1, 32, '2010-11-10 15:07:34', 0, NULL),
(17, '', 'rack 4x4', 21, 3, 0, 0, NULL, '3', '', 'fr1-2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:39', 1, '2010-11-10 15:07:39', 1, 33, '2010-11-10 15:07:39', 0, NULL),
(17, 'R - 17', 'rack 4x4', 21, 3, 17, 18, NULL, '3', '', 'fr1-2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:39', 1, '2010-11-10 15:07:40', 1, 34, '2010-11-10 15:07:40', 0, NULL),
(18, '', 'rack 4x4', 21, 3, 0, 0, NULL, '4', '', 'fr1-2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:44', 1, '2010-11-10 15:07:44', 1, 35, '2010-11-10 15:07:45', 0, NULL),
(18, 'R - 18', 'rack 4x4', 21, 3, 19, 20, NULL, '4', '', 'fr1-2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:07:44', 1, '2010-11-10 15:07:45', 1, 36, '2010-11-10 15:07:45', 0, NULL),
(19, '', 'rack 4x4', 21, 4, 0, 0, NULL, '1', '', 'fr1-3-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:01', 1, '2010-11-10 15:08:01', 1, 37, '2010-11-10 15:08:02', 0, NULL),
(19, 'R - 19', 'rack 4x4', 21, 4, 23, 24, NULL, '1', '', 'fr1-3-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:01', 1, '2010-11-10 15:08:02', 1, 38, '2010-11-10 15:08:02', 0, NULL),
(20, '', 'rack 4x4', 21, 4, 0, 0, NULL, '2', '', 'fr1-3-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:07', 1, '2010-11-10 15:08:07', 1, 39, '2010-11-10 15:08:07', 0, NULL),
(20, 'R - 20', 'rack 4x4', 21, 4, 25, 26, NULL, '2', '', 'fr1-3-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:07', 1, '2010-11-10 15:08:08', 1, 40, '2010-11-10 15:08:08', 0, NULL),
(21, '', 'rack 4x4', 21, 4, 0, 0, NULL, '3', '', 'fr1-3-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:13', 1, '2010-11-10 15:08:13', 1, 41, '2010-11-10 15:08:14', 0, NULL),
(21, 'R - 21', 'rack 4x4', 21, 4, 27, 28, NULL, '3', '', 'fr1-3-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:13', 1, '2010-11-10 15:08:14', 1, 42, '2010-11-10 15:08:14', 0, NULL),
(22, '', 'rack 4x4', 21, 4, 0, 0, NULL, '4', '', 'fr1-3-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:19', 1, '2010-11-10 15:08:19', 1, 43, '2010-11-10 15:08:19', 0, NULL),
(22, 'R - 22', 'rack 4x4', 21, 4, 29, 30, NULL, '4', '', 'fr1-3-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:19', 1, '2010-11-10 15:08:19', 1, 44, '2010-11-10 15:08:19', 0, NULL),
(23, '', 'rack 4x4', 21, 5, 0, 0, NULL, '1', '', 'fr1-4-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:34', 1, '2010-11-10 15:08:34', 1, 45, '2010-11-10 15:08:34', 0, NULL),
(23, 'R - 23', 'rack 4x4', 21, 5, 33, 34, NULL, '1', '', 'fr1-4-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:34', 1, '2010-11-10 15:08:35', 1, 46, '2010-11-10 15:08:35', 0, NULL),
(24, '', 'rack 4x4', 21, 5, 0, 0, NULL, '2', '', 'fr1-4-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:40', 1, '2010-11-10 15:08:40', 1, 47, '2010-11-10 15:08:41', 0, NULL),
(24, 'R - 24', 'rack 4x4', 21, 5, 35, 36, NULL, '2', '', 'fr1-4-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:40', 1, '2010-11-10 15:08:41', 1, 48, '2010-11-10 15:08:41', 0, NULL),
(25, '', 'rack 4x4', 21, 5, 0, 0, NULL, '3', '', 'fr1-4-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:49', 1, '2010-11-10 15:08:49', 1, 49, '2010-11-10 15:08:49', 0, NULL),
(25, 'R - 25', 'rack 4x4', 21, 5, 37, 38, NULL, '3', '', 'fr1-4-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:49', 1, '2010-11-10 15:08:49', 1, 50, '2010-11-10 15:08:50', 0, NULL),
(26, '', 'rack 4x4', 21, 5, 0, 0, NULL, '4', '', 'fr1-4-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:55', 1, '2010-11-10 15:08:55', 1, 51, '2010-11-10 15:08:55', 0, NULL),
(26, 'R - 26', 'rack 4x4', 21, 5, 39, 40, NULL, '4', '', 'fr1-4-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:08:55', 1, '2010-11-10 15:08:55', 1, 52, '2010-11-10 15:08:56', 0, NULL),
(27, '', 'freezer', 6, NULL, 53, 54, NULL, 'fr2', '', 'fr2', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2010-11-10 15:10:09', 1, '2010-11-10 15:10:09', 1, 53, '2010-11-10 15:10:10', 0, NULL),
(27, 'FRE - 27', 'freezer', 6, NULL, 53, 54, NULL, 'fr2', '', 'fr2', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2010-11-10 15:10:09', 1, '2010-11-10 15:10:10', 1, 54, '2010-11-10 15:10:10', 0, NULL),
(28, '', 'shelf', 14, 27, 0, 0, NULL, '1', '', 'fr2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:30', 1, '2010-11-10 15:10:30', 1, 55, '2010-11-10 15:10:30', 0, NULL),
(28, 'SH - 28', 'shelf', 14, 27, 54, 55, NULL, '1', '', 'fr2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:30', 1, '2010-11-10 15:10:31', 1, 56, '2010-11-10 15:10:31', 0, NULL),
(29, '', 'shelf', 14, 27, 0, 0, NULL, '2', '', 'fr2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:35', 1, '2010-11-10 15:10:35', 1, 57, '2010-11-10 15:10:36', 0, NULL),
(29, 'SH - 29', 'shelf', 14, 27, 56, 57, NULL, '2', '', 'fr2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:35', 1, '2010-11-10 15:10:36', 1, 58, '2010-11-10 15:10:36', 0, NULL),
(30, '', 'shelf', 14, 27, 0, 0, NULL, '3', '', 'fr2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:41', 1, '2010-11-10 15:10:41', 1, 59, '2010-11-10 15:10:41', 0, NULL),
(30, 'SH - 30', 'shelf', 14, 27, 58, 59, NULL, '3', '', 'fr2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:41', 1, '2010-11-10 15:10:42', 1, 60, '2010-11-10 15:10:42', 0, NULL),
(31, '', 'shelf', 14, 27, 0, 0, NULL, '4', '', 'fr2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:48', 1, '2010-11-10 15:10:48', 1, 61, '2010-11-10 15:10:48', 0, NULL),
(31, 'SH - 31', 'shelf', 14, 27, 60, 61, NULL, '4', '', 'fr2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:10:48', 1, '2010-11-10 15:10:48', 1, 62, '2010-11-10 15:10:48', 0, NULL),
(32, '', 'shelf', 14, 28, 0, 0, NULL, '5', '', 'fr2-1-5', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:11:03', 1, '2010-11-10 15:11:03', 1, 63, '2010-11-10 15:11:03', 0, NULL),
(32, 'SH - 32', 'shelf', 14, 28, 55, 56, NULL, '5', '', 'fr2-1-5', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:11:03', 1, '2010-11-10 15:11:04', 1, 64, '2010-11-10 15:11:04', 0, NULL),
(32, 'SH - 32', 'shelf', 14, 27, 55, 56, NULL, '5', '', 'fr2-5', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:11:03', 1, '2010-11-10 15:12:04', 1, 65, '2010-11-10 15:12:04', 0, NULL),
(33, '', 'rack 4x4', 21, 28, 0, 0, NULL, '1', '', 'fr2-1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:40', 1, '2010-11-10 15:12:40', 1, 66, '2010-11-10 15:12:40', 0, NULL),
(33, 'R - 33', 'rack 4x4', 21, 28, 55, 56, NULL, '1', '', 'fr2-1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:40', 1, '2010-11-10 15:12:41', 1, 67, '2010-11-10 15:12:41', 0, NULL),
(34, '', 'rack 4x4', 21, 28, 0, 0, NULL, '2', '', 'fr2-1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:45', 1, '2010-11-10 15:12:45', 1, 68, '2010-11-10 15:12:45', 0, NULL),
(34, 'R - 34', 'rack 4x4', 21, 28, 57, 58, NULL, '2', '', 'fr2-1-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:45', 1, '2010-11-10 15:12:46', 1, 69, '2010-11-10 15:12:46', 0, NULL),
(35, '', 'rack 4x4', 21, 28, 0, 0, NULL, '3', '', 'fr2-1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:53', 1, '2010-11-10 15:12:53', 1, 70, '2010-11-10 15:12:54', 0, NULL),
(35, 'R - 35', 'rack 4x4', 21, 28, 59, 60, NULL, '3', '', 'fr2-1-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:12:53', 1, '2010-11-10 15:12:54', 1, 71, '2010-11-10 15:12:54', 0, NULL),
(36, '', 'rack 4x4', 21, 28, 0, 0, NULL, '4', '', 'fr2-1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:01', 1, '2010-11-10 15:13:01', 1, 72, '2010-11-10 15:13:01', 0, NULL),
(36, 'R - 36', 'rack 4x4', 21, 28, 61, 62, NULL, '4', '', 'fr2-1-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:01', 1, '2010-11-10 15:13:02', 1, 73, '2010-11-10 15:13:02', 0, NULL),
(37, '', 'rack 4x4', 21, 29, 0, 0, NULL, '1', '', 'fr2-2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:16', 1, '2010-11-10 15:13:16', 1, 74, '2010-11-10 15:13:17', 0, NULL),
(37, 'R - 37', 'rack 4x4', 21, 29, 65, 66, NULL, '1', '', 'fr2-2-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:16', 1, '2010-11-10 15:13:17', 1, 75, '2010-11-10 15:13:17', 0, NULL),
(38, '', 'rack 4x4', 21, 29, 0, 0, NULL, '2', '', 'fr2-2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:22', 1, '2010-11-10 15:13:22', 1, 76, '2010-11-10 15:13:23', 0, NULL),
(38, 'R - 38', 'rack 4x4', 21, 29, 67, 68, NULL, '2', '', 'fr2-2-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:22', 1, '2010-11-10 15:13:23', 1, 77, '2010-11-10 15:13:23', 0, NULL),
(39, '', 'rack 4x4', 21, 29, 0, 0, NULL, '3', '', 'fr2-2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:29', 1, '2010-11-10 15:13:29', 1, 78, '2010-11-10 15:13:29', 0, NULL),
(39, 'R - 39', 'rack 4x4', 21, 29, 69, 70, NULL, '3', '', 'fr2-2-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:29', 1, '2010-11-10 15:13:30', 1, 79, '2010-11-10 15:13:30', 0, NULL),
(40, '', 'rack 4x4', 21, 29, 0, 0, NULL, '4', '', 'fr2-2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:35', 1, '2010-11-10 15:13:35', 1, 80, '2010-11-10 15:13:36', 0, NULL),
(40, 'R - 40', 'rack 4x4', 21, 29, 71, 72, NULL, '4', '', 'fr2-2-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:35', 1, '2010-11-10 15:13:36', 1, 81, '2010-11-10 15:13:36', 0, NULL),
(41, '', 'rack 4x4', 21, 30, 0, 0, NULL, '1', '', 'fr2-3-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:57', 1, '2010-11-10 15:13:57', 1, 82, '2010-11-10 15:13:57', 0, NULL),
(41, 'R - 41', 'rack 4x4', 21, 30, 75, 76, NULL, '1', '', 'fr2-3-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:13:57', 1, '2010-11-10 15:13:58', 1, 83, '2010-11-10 15:13:58', 0, NULL),
(42, '', 'rack 4x4', 21, 30, 0, 0, NULL, '2', '', 'fr2-3-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:03', 1, '2010-11-10 15:14:03', 1, 84, '2010-11-10 15:14:03', 0, NULL),
(42, 'R - 42', 'rack 4x4', 21, 30, 77, 78, NULL, '2', '', 'fr2-3-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:03', 1, '2010-11-10 15:14:03', 1, 85, '2010-11-10 15:14:04', 0, NULL),
(43, '', 'rack 4x4', 21, 30, 0, 0, NULL, '3', '', 'fr2-3-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:10', 1, '2010-11-10 15:14:10', 1, 86, '2010-11-10 15:14:10', 0, NULL),
(43, 'R - 43', 'rack 4x4', 21, 30, 79, 80, NULL, '3', '', 'fr2-3-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:10', 1, '2010-11-10 15:14:10', 1, 87, '2010-11-10 15:14:10', 0, NULL),
(44, '', 'rack 4x4', 21, 30, 0, 0, NULL, '4', '', 'fr2-3-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:16', 1, '2010-11-10 15:14:16', 1, 88, '2010-11-10 15:14:16', 0, NULL),
(44, 'R - 44', 'rack 4x4', 21, 30, 81, 82, NULL, '4', '', 'fr2-3-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:16', 1, '2010-11-10 15:14:17', 1, 89, '2010-11-10 15:14:17', 0, NULL),
(45, '', 'rack 4x4', 21, 31, 0, 0, NULL, '1', '', 'fr2-4-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:41', 1, '2010-11-10 15:14:41', 1, 90, '2010-11-10 15:14:41', 0, NULL),
(45, 'R - 45', 'rack 4x4', 21, 31, 85, 86, NULL, '1', '', 'fr2-4-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:41', 1, '2010-11-10 15:14:42', 1, 91, '2010-11-10 15:14:42', 0, NULL),
(46, '', 'rack 4x4', 21, 31, 0, 0, NULL, '2', '', 'fr2-4-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:46', 1, '2010-11-10 15:14:46', 1, 92, '2010-11-10 15:14:47', 0, NULL),
(46, 'R - 46', 'rack 4x4', 21, 31, 87, 88, NULL, '2', '', 'fr2-4-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:46', 1, '2010-11-10 15:14:47', 1, 93, '2010-11-10 15:14:47', 0, NULL),
(47, '', 'rack 4x4', 21, 31, 0, 0, NULL, '3', '', 'fr2-4-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:53', 1, '2010-11-10 15:14:53', 1, 94, '2010-11-10 15:14:54', 0, NULL),
(47, 'R - 47', 'rack 4x4', 21, 31, 89, 90, NULL, '3', '', 'fr2-4-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:53', 1, '2010-11-10 15:14:54', 1, 95, '2010-11-10 15:14:54', 0, NULL),
(48, '', 'rack 4x4', 21, 31, 0, 0, NULL, '4', '', 'fr2-4-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:59', 1, '2010-11-10 15:14:59', 1, 96, '2010-11-10 15:14:59', 0, NULL),
(48, 'R - 48', 'rack 4x4', 21, 31, 91, 92, NULL, '4', '', 'fr2-4-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:14:59', 1, '2010-11-10 15:14:59', 1, 97, '2010-11-10 15:15:00', 0, NULL),
(49, '', 'rack 4x4', 21, 32, 0, 0, NULL, '1', '', 'fr2-5-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:23', 1, '2010-11-10 15:15:23', 1, 98, '2010-11-10 15:15:23', 0, NULL),
(49, 'R - 49', 'rack 4x4', 21, 32, 95, 96, NULL, '1', '', 'fr2-5-1', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:23', 1, '2010-11-10 15:15:23', 1, 99, '2010-11-10 15:15:23', 0, NULL),
(50, '', 'rack 4x4', 21, 32, 0, 0, NULL, '2', '', 'fr2-5-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:31', 1, '2010-11-10 15:15:31', 1, 100, '2010-11-10 15:15:32', 0, NULL),
(50, 'R - 50', 'rack 4x4', 21, 32, 97, 98, NULL, '2', '', 'fr2-5-2', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:31', 1, '2010-11-10 15:15:32', 1, 101, '2010-11-10 15:15:32', 0, NULL),
(51, '', 'rack 4x4', 21, 32, 0, 0, NULL, '3', '', 'fr2-5-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:38', 1, '2010-11-10 15:15:38', 1, 102, '2010-11-10 15:15:38', 0, NULL),
(51, 'R - 51', 'rack 4x4', 21, 32, 99, 100, NULL, '3', '', 'fr2-5-3', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:38', 1, '2010-11-10 15:15:38', 1, 103, '2010-11-10 15:15:39', 0, NULL),
(52, '', 'rack 4x4', 21, 32, 0, 0, NULL, '4', '', 'fr2-5-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:43', 1, '2010-11-10 15:15:43', 1, 104, '2010-11-10 15:15:43', 0, NULL),
(52, 'R - 52', 'rack 4x4', 21, 32, 101, 102, NULL, '4', '', 'fr2-5-4', '', NULL, NULL, NULL, NULL, 'FALSE', '-80.00', 'celsius', '', '2010-11-10 15:15:43', 1, '2010-11-10 15:15:44', 1, 105, '2010-11-10 15:15:44', 0, NULL);

SET FOREIGN_KEY_CHECKS=1;

DELETE FROM structure_validations
WHERE structure_field_id = (SELECT id FROM structure_fields
WHERE field = 'morphology' AND tablename = 'diagnosis_masters');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.language_heading = 'collection'
WHERE sfi.field IN ('bank_id') 
AND str.alias IN ('clinicalcollectionlinks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;


