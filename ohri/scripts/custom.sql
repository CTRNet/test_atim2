-- Run post 2.3.2.
DROP TABLE IF EXISTS view_collections;
DROP VIEW IF EXISTS view_collections;
CREATE VIEW view_collections AS 
SELECT 
col.id AS collection_id,
col.bank_id AS bank_id,
col.sop_master_id AS sop_master_id,
link.participant_id AS participant_id,
link.diagnosis_master_id AS diagnosis_master_id,
link.consent_master_id AS consent_master_id,

part.participant_identifier AS participant_identifier,

col.acquisition_label AS acquisition_label,

col.collection_site AS collection_site,
col.collection_datetime AS collection_datetime,
col.collection_datetime_accuracy AS collection_datetime_accuracy,
col.collection_property AS collection_property,
col.collection_notes AS collection_notes,
col.deleted AS deleted,
banks.name AS bank_name,

idents.identifier_value AS ohri_bank_participant_id,
col.created AS created 

FROM collections col 
LEFT JOIN clinical_collection_links link on col.id = link.collection_id and link.deleted != 1
LEFT JOIN participants part on link.participant_id = part.id and part.deleted != 1
LEFT JOIN banks on col.bank_id = banks.id and banks.deleted != 1 
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1
LEFT JOIN misc_identifier_controls AS idents_controls ON idents.misc_identifier_control_id=idents_controls.id
WHERE col.deleted != 1 AND idents_controls.misc_identifier_name='ohri_bank_participant_id';






DROP TABLE IF EXISTS view_samples;
DROP VIEW IF EXISTS view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
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
samp.sample_category,
samp.deleted,

idents.identifier_value AS ohri_bank_participant_id 

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1
LEFT JOIN misc_identifier_controls AS idents_controls ON idents.misc_identifier_control_id=idents_controls.id
WHERE samp.deleted != 1 AND idents_controls.misc_identifier_name='ohri_bank_participant_id';