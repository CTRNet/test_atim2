UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET language_label = 'aliquot system code' WHERE model LIKE '%Aliquot%' AND field = 'barcode';

-- CONSENT

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'chuq_cd_consents');
DELETE FROM structures WHERE alias = 'chuq_cd_consents';

-- DIAGNOSIS

UPDATE consent_controls SET form_alias = 'consent_masters' WHERE form_alias = 'chuq_cd_consents';

UPDATE `diagnosis_controls` SET `form_alias` = 'diagnosismasters,dx_primary,chuq_dx_all_sites', `databrowser_label` = 'primary|chuq', `controls_type` = 'chuq' WHERE `controls_type` = 'chuq primary';

DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='chuq_dx_all_sites') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('dx_date', 'notes', 'icd10_code', 'topography', 'morphology'));

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');


INSERT IGNORE INTO i18n (id,en,fr) VALUES ('chuq', 'CHUQ', 'CHUQ');

-- ANNOTATION

UPDATE event_controls SET flag_active = 0 WHERE disease_site != 'chuq';
UPDATE `event_controls` SET `disease_site` = 'chuq', `databrowser_label` = 'lab|chuq|ca125' WHERE disease_site like 'CHUQ';

-- TREATMENT

UPDATE `tx_controls` SET `disease_site` = 'chuq', `databrowser_label` = CONCAT('chuq|',`databrowser_label`) WHERE disease_site like 'CHUQ';
UPDATE `tx_controls` SET applied_protocol_control_id = null WHERE disease_site like 'CHUQ';

UPDATE structure_formats SET `flag_override_tag`='1', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chuq_spent_time_unit') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUEs ('chuq ap precision','AP Precision','AP Précision');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='evaluated collection to reception spent time' AND `language_tag`=''), '1', '435', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chuq_spent_time_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unit'), '1', '436', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'sd_spe%') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field like 'chuq_evaluated_spent_time_from_coll%');
UPDATE structure_fields SET `language_tag`='' WHERE model='SpecimenDetail' AND tablename='' AND field='chuq_evaluated_spent_time_from_coll_unit';

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

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_label,
alc.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,

tiss.chuq_tissue_code

FROM aliquot_masters AS al
INNER JOIN aliquot_controls AS alc ON al.aliquot_control_id = alc.id
INNER JOIN sample_masters AS samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN sample_controls AS sampc ON samp.sample_control_id = sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id=parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = samp.initial_specimen_sample_id AND tiss.deleted != 1
WHERE al.deleted != 1;

DROP VIEW view_samples;
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

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,
samp.sample_code,
sampc.sample_category,

tiss.chuq_tissue_code

FROM sample_masters as samp
INNER JOIN sample_controls as sampc ON samp.sample_control_id=sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id = parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = samp.initial_specimen_sample_id AND tiss.deleted != 1
WHERE samp.deleted != 1;

-- drop eruthrocyte

ALTER TABLE sd_der_blood_cells
  DROP COLUMN `chuq_is_erythrocyte`;
ALTER TABLE sd_der_blood_cells_revs
   DROP COLUMN `chuq_is_erythrocyte`;

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='chuq_sd_der_blood_cells');
DELETE FROM structures WHERE alias='chuq_sd_der_blood_cells';
DELETE FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_blood_cells' AND `field`='chuq_is_erythrocyte' AND `type`='yes_no';
UPDATE sample_controls SET form_alias = 'sample_masters,sd_undetailed_derivatives,derivatives,' WHERE sample_type = 'blood cell';

-- add arlt

ALTER TABLE ad_tubes
  ADD COLUMN `chuq_blood_cell_stored_into_rlt` char(1) DEFAULT '' AFTER `chuq_blood_solution`;
ALTER TABLE ad_tubes_revs
  ADD COLUMN `chuq_blood_cell_stored_into_rlt` char(1) DEFAULT '' AFTER `chuq_blood_solution`;

SET @alq_id = (SELECT id from aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood cell') AND aliquot_type = 'tube');
UPDATE aliquot_controls SET form_alias = CONCAT(form_alias,',chuq_blood_cell_rlt') WHERE id = @alq_id;

INSERT INTO structures(`alias`) VALUES ('chuq_blood_cell_rlt');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'chuq_blood_cell_stored_into_rlt', 'yes_no',  NULL , '0', '', '', '', 'blood cells stored into rlt', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chuq_blood_cell_rlt'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='chuq_blood_cell_stored_into_rlt'), 
'1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('blood cells stored into rlt','Stored into RLT','Entreposé dans RLT');

ALTER TABLE participants
  MODIFY `participant_identifier` int(11) DEFAULT NULL;
ALTER TABLE participants_revs
  MODIFY `participant_identifier` int(11) DEFAULT NULL;  
  
UPDATE structure_formats
SET flag_override_type = 0, type='', flag_override_setting = 0, setting ='' 
WHERE structure_field_id IN (SELECT id FROM `structure_fields` WHERE field = 'participant_identifier');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `type`='input',  `setting`='size=20' WHERE model='Participant' AND tablename='participants' AND field='participant_identifier' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');

UPDATE diagnosis_controls SET flag_active = 0 WHERE id != 14 and category = 'primary';
UPDATE diagnosis_controls SET flag_compare_with_cap=0,form_alias = concat('diagnosismasters,dx_primary,',form_alias) WHERE id = 14;

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id IN (SELECT id from structures WHERE alias = 'dx_primary');
UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id IN (SELECT id from structures WHERE alias = 'view_diagnosis')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('icd10_code','topography'));

UPDATE structure_fields SET  `type`='integer_positive' WHERE model='Participant' AND tablename='participants' AND field='participant_identifier';
INSERT INTO i18n (id,en,fr) VALUES ('tumoral', 'Tumoral', 'Tumoral');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id'), 'notEmpty', '', 'value is required');

ALTER TABLE chuq_dx_all_sites DROP COLUMN deleted_date;
ALTER TABLE chuq_ed_labs DROP COLUMN deleted_date;

SET @id = (SELECT id FROM `datamart_structures` WHERE `model` LIKE 'SpecimenReviewMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = @id OR id2 = @id;
SET @id = (SELECT id FROM `datamart_structures` WHERE `model` LIKE 'TreatmentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = @id OR id2 = @id;


UPDATE structure_fields SET tablename = 'sd_spe_tissues' WHERE model = 'SampleDetail' AND field IN ('chuq_tissue_code','tissue_laterality', 'tissue_size', 'tissue_size_unit', 'tissue_weight', 'tissue_weight_unit','chuq_ap_tissue_precision');
UPDATE structure_fields SET tablename = 'sd_spe_bloods' WHERE model = 'SampleDetail' AND field = 'blood_type';
UPDATE structure_fields SET tablename = 'sd_der_cell_cultures' WHERE model = 'SampleDetail' AND field IN ('cell_passage_number','culture_status');

UPDATE structure_fields SET tablename = 'ad_tubes' WHERE model = 'ALiquotDetail' AND field IN ('cell_count','cell_count_unit','concentration','concentration_unit', 'cell_viability', 'chuq_blood_solution');
UPDATE structure_fields SET tablename = 'ad_blocks' WHERE model = 'ALiquotDetail' AND field IN ('block_type');


SELECT sc.sample_type, ac.aliquot_type,ac.form_alias FROM `aliquot_controls` as ac inner join sample_controls as sc
ON ac.sample_control_id = sc.id
WHERE (sc.sample_type like '%ascite%' OR sc.sample_type like '%peritoneal%'
OR sc.sample_type in ('blood', 'plasma', 'serum', 'blood cell', 'tissue', 'dna','rna', 'cell culture')) and ac.`flag_active` = 1

ALTER TABLE sd_spe_bloods
  ADD chuq_request_nbr varchar(100) DEFAULT NULL AFTER blood_type;
ALTER TABLE sd_spe_bloods_revs
  ADD chuq_request_nbr varchar(100) DEFAULT NULL AFTER blood_type;  

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_bloods', 'chuq_request_nbr', 'input',  NULL , '0', '', '', '', 'request nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='chuq_request_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='request nbr' AND `language_tag`=''), '1', '445', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES ('request nbr','Request #','Requête #');

UPDATE structure_fields SET  `type`='integer_positive', setting = 'size=20' WHERE model LIKE 'View%' AND field='participant_identifier';


