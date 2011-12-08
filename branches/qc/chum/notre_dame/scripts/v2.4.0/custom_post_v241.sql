DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 
mic.misc_identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label, 
col.visit_label AS visit_label,

specimen_control.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp_control.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp_control.sample_type,
samp.sample_control_id,
samp.sample_label AS sample_label,

al.barcode,
al.aliquot_label AS aliquot_label,
al_control.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created

FROM aliquot_masters as al
INNER JOIN aliquot_controls AS al_control ON al.aliquot_control_id=al_control.id
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN sample_controls AS samp_control ON samp.sample_control_id=samp_control.id
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimen_control ON specimen.sample_control_id=specimen_control.id
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_samp_control ON parent_samp.sample_control_id=parent_samp_control.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
LEFT JOIN misc_identifier_controls AS mic ON ident.misc_identifier_control_id=mic.id
WHERE al.deleted != 1;

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('tmp_tube_storage_method' ,'tmp_tube_storage_solution'));
DELETE FROM structure_fields WHERE field IN ('tmp_tube_storage_method' ,'tmp_tube_storage_solution');

ALTER TABLE ad_blocks
 DROP COLUMN path_report_code;
ALTER TABLE ad_blocks_revs
 DROP COLUMN path_report_code;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'path_report_code');
DELETE FROM structure_fields WHERE field = 'path_report_code' ;

ALTER TABLE quality_ctrls
 ADD COLUMN qc_nd_is_irrelevant BOOLEAN NOT NULL DEFAULT false AFTER used_volume;
ALTER TABLE quality_ctrls_revs
 ADD COLUMN qc_nd_is_irrelevant BOOLEAN NOT NULL DEFAULT false AFTER used_volume;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'QualityCtrl', 'quality_ctrls', 'qc_nd_is_irrelevant', 'checkbox',  NULL , '0', '', '', '', 'is irrelevant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_nd_is_irrelevant' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='is irrelevant' AND `language_tag`=''), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

INSERT IGNORE INTO i18n (id, en, fr) VALUES
('is irrelevant', 'Is irrelevant', 'N''est pas pertinent'),
('immunofluorescence', 'Immunofluorescence', 'Immunofluorescence'),
("an old bank number is matched to the one used as search parameter", 
 "An old bank number is matched to the one used as search parameter.",
 "Un ancien numéro de banque correspond à celui utilisé comme paramètre de recherche."),
("this hospital identifier must start with capital letter %s and be followed by numbers",
 "This hospital identifier must start with capital letter %s and be followed by numbers.",
 "Cet identifiant d'hôpital doit commencer avec la lettre majuscule %s et être suivi par des chiffres."),
("researcher", "Researcher", "Chercheur"),
("the code format must be {year}-{###}", "The code format must be {year}-{###}.", "Le format du code doit être {année}-{###}.");

UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='1');
UPDATE structure_formats SET `display_order`='24' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='1');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='querytool_batch_set') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='BatchSet' AND `tablename`='datamart_batch_sets' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

