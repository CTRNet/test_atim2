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

idents.identifier_value AS qc_cusm_prostate_bank_identifier 

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

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,
samp.sample_code,
samp.qc_cusm_sample_label,
samp.sample_category,
samp.deleted,

idents.identifier_value AS qc_cusm_prostate_bank_identifier 

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
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

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,

al.barcode,
al.aliquot_type,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

UPDATE structure_fields
SET structure_value_domain = (SELECT id FROM `structure_value_domains` WHERE domain_name LIKE 'yes_no_checkbox')
WHERE `field` = 'qc_cusm_on_ice';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_cusm_dxd_procure'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology'), 
'0', '20', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

UPDATE structure_permissible_values_customs SET en = 'Armen Aprikian', fr = 'Armen Aprikian' WHERE value = 'armen aprikian';
UPDATE structure_permissible_values_customs SET en = 'Chrysoula Makris', fr = 'Chrysoula Makris' WHERE value = 'chrysoula makris';
UPDATE structure_permissible_values_customs SET en = 'Eleonora Scarlata Villegas', fr = 'Eleonora Scarlata Villegas' WHERE value = 'eleonora scarlata villegas';
UPDATE structure_permissible_values_customs SET en = 'Jinsong Chen', fr = 'Jinsong Chen' WHERE value = 'jinsong chen';
UPDATE structure_permissible_values_customs SET en = 'Lucie Hamel', fr = 'Lucie Hamel' WHERE value = 'lucie hamel';
UPDATE structure_permissible_values_customs SET en = 'Other', fr = 'Autre' WHERE value = 'other';
UPDATE structure_permissible_values_customs SET en = 'Simone Chevalier', fr = 'Simone Chevalier' WHERE value = 'simone chevalier';

UPDATE structure_permissible_values_customs SET en = 'MUHC', fr = 'CUSM' WHERE value = 'muhc';
UPDATE structure_permissible_values_customs SET en = 'Urology Clinic', fr = 'clinique d''urologie' WHERE value = 'urology clinic';
UPDATE structure_permissible_values_customs SET en = 'Operating Room', fr = 'Salle d''opération' WHERE value = 'operating room';

INSERT INTO structure_permissible_values_custom_controls (name,flag_active) 
VALUES 
('consent versions', '1');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'consent versions');

INSERT INTO structure_permissible_values_customs(control_id, value, en, fr)
(SELECT @control_id, value.language_alias, i18n.en, i18n.fr
FROM structure_value_domains AS domain
INNER JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id = domain.id
INNER JOIN structure_permissible_values AS value ON link.structure_permissible_value_id = value.id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE domain.domain_name = 'qc_cusm_consent_version');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_cusm_consent_version');

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''consent versions'')' WHERE domain_name = 'qc_cusm_consent_version';

INSERT INTO structure_permissible_values_custom_controls (name,flag_active) 
VALUES 
('life style versions', '1');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'life style versions');

INSERT INTO structure_permissible_values_customs(control_id, value, en, fr)
(SELECT @control_id, value.language_alias, i18n.en, i18n.fr
FROM structure_value_domains AS domain
INNER JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id = domain.id
INNER JOIN structure_permissible_values AS value ON link.structure_permissible_value_id = value.id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE domain.domain_name = 'qc_cusm_lifestyle_form_version');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_cusm_lifestyle_form_version');

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''consent versions'')' WHERE domain_name = 'qc_cusm_lifestyle_form_version';

UPDATE structure_permissible_values_customs SET en = 'Pathology Laboratory ', fr = 'Laboratoire de pathologie' WHERE value = 'pathology laboratory ';
UPDATE structure_permissible_values_customs SET en = 'R1-103', fr = 'R1-103' WHERE value = 'r1-103';

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(7, 8);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(136);

insert ignore into i18n (id,en,fr) values ('pellet color', 'Pellet Color', 'Couleur du culot');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field NOT IN ('title', 'summary') 
AND str.alias = 'studysummaries'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE menus SET flag_active = '0' WHERE id IN ('tool_CAN_106', 'tool_CAN_105');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `field`='title' ), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_override_label = '1', sfo.language_label = 'sample code'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field  = 'sample_code';

UPDATE i18n SET en = 'Sample System Code', fr = 'Code systême échantillon' WHERE id = 'sample code';

UPDATE aliquot_review_controls SET flag_active = '0';
UPDATE protocol_controls SET flag_active = '0';
-- sop_controls
UPDATE specimen_review_controls SET flag_active = '0';
UPDATE tx_controls SET flag_active = '0';

SET @trt_id = (SELECT id FROM datamart_structures WHERE plugin = 'Clinicalannotation' AND model = 'TreatmentMaster' AND display_name = 'treatments');
SET @spec_rev_id = (SELECT id FROM datamart_structures WHERE plugin = 'Inventorymanagement' AND model = 'SpecimenReviewMaster' AND display_name = 'specimen review');

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (@trt_id, @spec_rev_id)
OR id2 IN (@trt_id, @spec_rev_id);

ALTER TABLE diagnosis_masters
  MODIFY `path_mstage` varchar(15) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs
  MODIFY `path_mstage` varchar(15) DEFAULT NULL;

RENAME TABLE qc_cusm_cd_undetailled TO qc_cusm_cd_undetailleds;
RENAME TABLE qc_cusm_cd_undetailled_revs TO qc_cusm_cd_undetailleds_revs;
UPDATE consent_controls SET detail_tablename = 'qc_cusm_cd_undetailleds' WHERE detail_tablename = 'qc_cusm_cd_undetailled';

RENAME TABLE qc_cusm_dxd_procure TO qc_cusm_dxd_procures;
RENAME TABLE qc_cusm_dxd_procure_revs TO qc_cusm_dxd_procures_revs;
UPDATE diagnosis_controls SET detail_tablename = 'qc_cusm_dxd_procures' WHERE detail_tablename = 'qc_cusm_dxd_procure';

RENAME TABLE qc_cusm_ed_procure_lifestyle TO qc_cusm_ed_procure_lifestyles;
RENAME TABLE qc_cusm_ed_procure_lifestyle_revs TO qc_cusm_ed_procure_lifestyles_revs;
UPDATE event_controls SET detail_tablename = 'qc_cusm_ed_procure_lifestyles' WHERE detail_tablename = 'qc_cusm_ed_procure_lifestyle';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index = '0'
WHERE str.alias = 'qc_cusm_dxd_procure'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index = '1'
WHERE sfi.field IN ('dx_date', 'morphology', 'primary_grade', 'secondary_grade', 'tertiary_grade', 'gleason_score', 
'path_tstage', 'path_nstage', 'path_mstage', 'path_stage_summary') 
AND str.alias = 'qc_cusm_dxd_procure'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

