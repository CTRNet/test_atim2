-- run after upgrade to 2.4.0
UPDATE participant_messages SET expiry_date=NULL WHERE expiry_date='0000-00-00';
UPDATE participant_messages SET date_requested=NULL WHERE date_requested='0000-00-00';
UPDATE participant_messages SET due_date=NULL WHERE due_date='0000-00-00 00:00:00';

UPDATE menus SET use_link='/clinicalannotation/misc_identifiers/search/' WHERE id='clin_CAN_1';

UPDATE collections SET collection_datetime=NULL WHERE collection_datetime='0000-00-00 00:00:00';

ALTER TABLE participants
 CHANGE lvd_date_accuracy last_visit_date_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
 CHANGE lvd_date_accuracy last_visit_date_accuracy CHAR(1) NOT NULL DEFAULT '';
 
REPLACE INTO i18n (id, en, fr) VALUES
("banking activity", "Banking activity", "Activité de mise en banque"),
("generic", "Generic", "Générique"),
("no aliquot", "No aliquot", "Pas d'aliquot"),
("no data for [%s.%s]", "No data for [%s.%s]", "Pas de données pour [%s.%s]");

ALTER TABLE cd_icm_generics
 MODIFY created DATETIME NOT NULL;
ALTER TABLE cd_icm_generics_revs
 MODIFY created DATETIME NOT NULL;
ALTER TABLE lab_type_laterality_match
 MODIFY created DATETIME NOT NULL;
ALTER TABLE qc_nd_ed_all_procure_lifestyles
 MODIFY created DATETIME NOT NULL,
 MODIFY modified DATETIME NOT NULL;
ALTER TABLE qc_nd_ed_all_procure_lifestyles_revs
 MODIFY created DATETIME NOT NULL,
 MODIFY modified DATETIME NOT NULL;
ALTER TABLE sd_der_of_cells
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_der_of_cells_revs
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_der_of_sups
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_der_of_sups_revs
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_spe_other_fluids
 MODIFY created DATETIME NOT NULL;
ALTER TABLE sd_spe_other_fluids_revs
 MODIFY created DATETIME NOT NULL;
 
TRUNCATE missing_translations;

DROP VIEW view_samples;
CREATE VIEW `view_samples` AS select `samp`.`id` AS `sample_master_id`,`samp`.`parent_id` 
 AS `parent_sample_id`,`samp`.`initial_specimen_sample_id` AS `initial_specimen_sample_id`,`samp`.`collection_id` 
 AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,`link`.`participant_id` 
 AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` 
 AS `consent_master_id`,`part`.`participant_identifier` AS `participant_identifier`,`mic`.`misc_identifier_name` 
 AS `identifier_name`,`ident`.`identifier_value` AS `identifier_value`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`visit_label` 
 AS `visit_label`,`specimen_control`.`sample_type` AS `initial_specimen_sample_type`,`specimen`.`sample_control_id` 
 AS `initial_specimen_sample_control_id`,`parent_samp_control`.`sample_type` AS `parent_sample_type`,`parent_samp`.`sample_control_id` 
 AS `parent_sample_control_id`,`samp_control`.`sample_type` AS `sample_type`,`samp`.`sample_control_id` AS `sample_control_id`,`samp`.`sample_code` 
 AS `sample_code`,`samp`.`sample_label` AS `sample_label`,`samp_control`.`sample_category` AS `sample_category`
FROM (((((((`sample_masters` `samp`
 INNER JOIN sample_controls AS samp_control ON samp.sample_control_id=samp_control.id 
 INNER JOIN `collections` `col` on(((`col`.`id` = `samp`.`collection_id`) and (`col`.`deleted` <> 1)))) 
 LEFT JOIN `sample_masters` `specimen` on(((`samp`.`initial_specimen_sample_id` = `specimen`.`id`) and (`specimen`.`deleted` <> 1))))
 LEFT JOIN `sample_controls` `specimen_control` ON (specimen.sample_control_id=specimen_control.id) 
 LEFT JOIN `sample_masters` `parent_samp` on(((`samp`.`parent_id` = `parent_samp`.`id`) and (`parent_samp`.`deleted` <> 1)))) 
 LEFT JOIN `sample_controls` `parent_samp_control` ON (parent_samp.sample_control_id=parent_samp_control.id) 
 LEFT JOIN `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
 LEFT JOIN `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) 
 LEFT JOIN `banks` on(((`col`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) 
 LEFT JOIN `misc_identifiers` `ident` on(((`ident`.`misc_identifier_control_id` = `banks`.`misc_identifier_control_id`) and (`ident`.`participant_id` = `part`.`id`) and (`ident`.`deleted` <> 1)))
 LEFT JOIN misc_identifier_controls AS mic ON ident.misc_identifier_control_id=mic.id)
WHERE (`samp`.`deleted` <> 1);

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

tubes.tmp_storage_solution AS tmp_tube_storage_solution,
tubes.tmp_storage_method AS tmp_tube_storage_method,

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
LEFT JOIN ad_tubes AS tubes ON tubes.aliquot_master_id=al.id
WHERE al.deleted != 1;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_blood_cell_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_cell_culture_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_cell_culture_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_ascite_cell_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_ascite_cell_block') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_language' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_consent_language') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='invitation_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='0', `type`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='biological_material_use' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='0', `type`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_urine' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='0', `type`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_blood' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_followup' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_followup_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_questionnaire' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='stop_questionnaire_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='contact_for_additional_data' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_discovery_on_other_disease' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='inform_significant_discovery' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


ALTER TABLE sample_controls
  ADD COLUMN qc_nd_sample_type_code VARCHAR(50) NOT NULL DEFAULT '' AFTER 	sample_category;

UPDATE sample_controls SET qc_nd_sample_type_code = 'A' WHERE sample_type = 'ascite';
UPDATE sample_controls SET qc_nd_sample_type_code = 'B' WHERE sample_type = 'blood';
UPDATE sample_controls SET qc_nd_sample_type_code = 'T' WHERE sample_type = 'tissue';
UPDATE sample_controls SET qc_nd_sample_type_code = 'U' WHERE sample_type = 'urine';
UPDATE sample_controls SET qc_nd_sample_type_code = 'ASC-C' WHERE sample_type = 'ascite cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'ASC-S' WHERE sample_type = 'ascite supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'BLD-C' WHERE sample_type = 'blood cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PBMC' WHERE sample_type = 'pbmc';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PLS' WHERE sample_type = 'plasma';
UPDATE sample_controls SET qc_nd_sample_type_code = 'SER' WHERE sample_type = 'serum';
UPDATE sample_controls SET qc_nd_sample_type_code = 'C-CULT' WHERE sample_type = 'cell culture';
UPDATE sample_controls SET qc_nd_sample_type_code = 'DNA' WHERE sample_type = 'dna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'RNA' WHERE sample_type = 'rna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CONC-U' WHERE sample_type = 'concentrated urine';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CENT-U' WHERE sample_type = 'centrifuged urine';
UPDATE sample_controls SET qc_nd_sample_type_code = 'AMP-RNA' WHERE sample_type = 'amplified rna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'LB' WHERE sample_type = 'b cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'cDNA' WHERE sample_type = 'cdna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'T-LYS' WHERE sample_type = 'tissue lysate';
UPDATE sample_controls SET qc_nd_sample_type_code = 'T-SUSP' WHERE sample_type = 'tissue suspension';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PW' WHERE sample_type = 'peritoneal wash';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CF' WHERE sample_type = 'cystic fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'OF' WHERE sample_type = 'other fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PW-C' WHERE sample_type = 'peritoneal wash cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PW-S' WHERE sample_type = 'peritoneal wash supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CF-C' WHERE sample_type = 'cystic fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CF-S' WHERE sample_type = 'cystic fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'OF-C' WHERE sample_type = 'other fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'OF-S' WHERE sample_type = 'other fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PC-F' WHERE sample_type = 'pericardial fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PL-F' WHERE sample_type = 'pleural fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PC-C' WHERE sample_type = 'pericardial fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PC-S' WHERE sample_type = 'pericardial fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PL-C' WHERE sample_type = 'pleural fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PL-S' WHERE sample_type = 'pleural fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'C-LYSATE' WHERE sample_type = 'cell lysate';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PROT' WHERE sample_type = 'protein';
UPDATE sample_controls SET qc_nd_sample_type_code = 'BM' WHERE sample_type = 'bone marrow';
UPDATE sample_controls SET qc_nd_sample_type_code = 'BM-SUSP' WHERE sample_type = 'bone marrow suspension';
UPDATE sample_controls SET qc_nd_sample_type_code = 'No-BC' WHERE sample_type = 'no-b cell';

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

UPDATE participants SET participant_identifier = id;
UPDATE participants_revs SET participant_identifier = id;

UPDATE structure_formats SET `display_order`='16', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');

DELETE FROM structure_formats
WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'sd_%')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sample_code' AND model = 'SampleMaster');

UPDATE aliquot_masters SET barcode = id;
UPDATE aliquot_masters_revs SET barcode = id;

REPLACE INTO i18n (id,en,fr) VALUES ('aliquot barcode', 'Aliquot System Code', 'Aliquot - Code système');

UPDATE structure_fields SET  `type`='yes_no' WHERE model='AliquotDetail' AND tablename='ad_tubes' AND field='mycoplasma_free' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
ALTER TABLE ad_tubes
 MODIFY mycoplasma_free CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE ad_tubes_revs
 MODIFY mycoplasma_free CHAR(1) NOT NULL DEFAULT '';
UPDATE ad_tubes SET mycoplasma_free='y' WHERE mycoplasma_free='1';
UPDATE ad_tubes SET mycoplasma_free='n' WHERE mycoplasma_free='0';
UPDATE ad_tubes_revs SET mycoplasma_free='y' WHERE mycoplasma_free='1';
UPDATE ad_tubes_revs SET mycoplasma_free='n' WHERE mycoplasma_free='0';


-- Section above already executed on prod 2011-11-03
-- -------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='33', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='used aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Section above already executed on prod 2011-11-03
-- -------------------------------------------------------------------------------------------------------

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
('immunofluorescence', 'Immunofluorescence', 'Immunofluorescence');

