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

