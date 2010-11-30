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
ident.identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label AS acquisition_label, 
col.collection_site AS collection_site, 
col.visit_label AS visit_label, 
col.collection_datetime AS collection_datetime, 
col.collection_datetime_accuracy AS collection_datetime_accuracy, 
col.collection_property AS collection_property, 
col.collection_notes AS collection_notes, 
col.deleted AS deleted,
col.created AS created,

banks.name AS bank_name

FROM collections AS col
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
WHERE col.deleted != 1;

DROP VIEW IF EXISTS view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id AS initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id AS bank_id, 
col.sop_master_id AS sop_master_id, 
link.participant_id AS participant_id, 
link.diagnosis_master_id AS diagnosis_master_id, 
link.consent_master_id AS consent_master_id,

part.participant_identifier AS participant_identifier, 
ident.identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label AS acquisition_label, 
col.visit_label AS visit_label,

samp.initial_specimen_sample_type AS initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type AS sample_type,
samp.sample_code AS sample_code,
samp.sample_label AS sample_label,
samp.sample_category AS sample_category,
samp.deleted AS deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
WHERE samp.deleted != 1;

DROP VIEW IF EXISTS view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id AS bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id AS participant_id, 
link.diagnosis_master_id AS diagnosis_master_id, 
link.consent_master_id AS consent_master_id,

part.participant_identifier AS participant_identifier, 
ident.identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label AS acquisition_label, 
col.visit_label AS visit_label,

samp.initial_specimen_sample_type AS initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type AS sample_type,
samp.sample_label AS sample_label,

al.barcode AS barcode,
al.aliquot_label AS aliquot_label,
al.aliquot_type AS aliquot_type,
al.in_stock AS in_stock,

stor.code AS code,
stor.selection_label AS selection_label,
al.storage_coord_x AS storage_coord_x,
al.storage_coord_y AS storage_coord_y,

stor.temperature AS temperature,
stor.temp_unit AS temp_unit,

tubes.tmp_storage_solution AS storage_solution,
tubes.tmp_storage_method AS storage_method,

al.deleted AS deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
LEFT JOIN ad_tubes AS tubes ON tubes.aliquot_master_id=al.id
WHERE al.deleted != 1;

UPDATE users SET flag_active = '1';

UPDATE tx_controls SET flag_active = '0';
UPDATE protocol_controls SET flag_active = '0';

UPDATE users SET password = 'b23665e49d6bbc824143ba6c09490c781cb94370' WHERE username LIKE 'Liliane';

UPDATE users SET flag_active=true;

#a definir si on garde...
#
#DELETE FROM structure_formats WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND type='datetime' AND field='created' AND language_label='date created') AND structure_id=(SELECT id FROM structures WHERE alias='participants') LIMIT 1; # double participants created field
#
#-- PROCURE report
#INSERT INTO `datamart_reports` (`id`, `name`, `description`, `function`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
#(NULL, 'procure consents statistics', '', 'procure_consent_stat', '0000-00-00 00:00:00', '', NULL, '');
#
#INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
#('', '', '0', '', 'questionnaire', 'questionnaire', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'participant', 'participants', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'urine', 'urine', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'blood', 'blood', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'annual_followup', 'annual followup', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'contact_if_info_req', 'contact if info required', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'contact_if_discovery', 'contact if discovery', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'study_other_diseases', 'study other diseases', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'contact_if_disco_other_diseases', 'contact if discovery on other diseases', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'other_contacts_if_die', 'other contacts if deceased', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
#('', '', '0', '', 'denied', 'denied', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open');
#
#INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_nd_procure_consent_stats_report', '', '', '1', '1', '1', '1');
#INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='date_from' AND `language_label`='from' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='action' AND `language_label`='action' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'),
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='questionnaire' AND `language_label`='questionnaire' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='participant' AND `language_label`='participants' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='urine' AND `language_label`='urine' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='blood' AND `language_label`='blood' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='annual_followup' AND `language_label`='annual followup' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='contact_if_info_req' AND `language_label`='contact if info required' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='contact_if_discovery' AND `language_label`='contact if discovery' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='study_other_diseases' AND `language_label`='study other diseases' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='contact_if_disco_other_diseases' AND `language_label`='contact if discovery on other diseases' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='other_contacts_if_die' AND `language_label`='other contacts if deceased' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
#((SELECT id FROM structures WHERE alias='qc_nd_procure_consent_stats_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='denied' AND `language_label`='denied' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');
#





#check #16 : su script 0.... construire a bras les relation existante
#Ajouter sample type = LB pour Urszula et convertiser tous les PBMC qui devrait �tre des LB. (Leur aliquot label like 'LB-PBMC%')
#Supprimer aliquot dans boite quand ils n'existenet plus masi garder les donn�es dans l'hitorique
#Dans script #7 vérifier lingnes 3396 3409 3416
#Il faut créer les formulaires de recherches spécifiques (consentement FRSQ, PROCURE, etc.) pourle databrowser