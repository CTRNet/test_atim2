UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;
UPDATE misc_identifiers mi INNER JOIN misc_identifiers_revs mi_r ON mi.id=mi_r.id SET mi_r.flag_unique=mi.flag_unique;

UPDATE consent_controls SET detail_form_alias = '' WHERE detail_form_alias = 'consent_masters';

DROP TABLE IF EXISTS view_aliquots;
DROP VIEW IF EXISTS view_aliquots;
DROP VIEW IF EXISTS view_aliquots_view;
CREATE VIEW view_aliquots_view AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
col.participant_id, 

part.participant_identifier, 
	ident.identifier_value AS frsq_number,

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

IF(al.storage_datetime IS NULL, NULL,
 IF(col.collection_datetime IS NULL, -1,
 IF(col.collection_datetime_accuracy != 'c' OR al.storage_datetime_accuracy != 'c', -2,
 IF(col.collection_datetime > al.storage_datetime, -3,
 TIMESTAMPDIFF(MINUTE, col.collection_datetime, al.storage_datetime))))) AS coll_to_stor_spent_time_msg,
IF(al.storage_datetime IS NULL, NULL,
 IF(specimen_details.reception_datetime IS NULL, -1,
 IF(specimen_details.reception_datetime_accuracy != 'c' OR al.storage_datetime_accuracy != 'c', -2,
 IF(specimen_details.reception_datetime > al.storage_datetime, -3,
 TIMESTAMPDIFF(MINUTE, specimen_details.reception_datetime, al.storage_datetime))))) AS rec_to_stor_spent_time_msg,
IF(al.storage_datetime IS NULL, NULL,
 IF(derivative_details.creation_datetime IS NULL, -1,
 IF(derivative_details.creation_datetime_accuracy != 'c' OR al.storage_datetime_accuracy != 'c', -2,
 IF(derivative_details.creation_datetime > al.storage_datetime, -3,
 TIMESTAMPDIFF(MINUTE, derivative_details.creation_datetime, al.storage_datetime))))) AS creat_to_stor_spent_time_msg,
 
IF(LENGTH(al.notes) > 0, "y", "n") AS has_notes


FROM aliquot_masters AS al
INNER JOIN aliquot_controls AS alc ON al.aliquot_control_id = alc.id
INNER JOIN sample_masters AS samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN sample_controls AS sampc ON samp.sample_control_id = sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id=parent_sampc.id
LEFT JOIN participants AS part ON col.participant_id = part.id AND part.deleted != 1
	LEFT JOIN misc_identifiers ident ON col.misc_identifier_id = ident.id and ident.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN specimen_details ON al.sample_master_id=specimen_details.sample_master_id
LEFT JOIN derivative_details ON al.sample_master_id=derivative_details.sample_master_id
WHERE al.deleted != 1;

CREATE TABLE view_aliquots (SELECT * FROM view_aliquots_view);
ALTER TABLE view_aliquots
 ADD PRIMARY KEY(aliquot_master_id),
 ADD KEY(sample_master_id),
 ADD KEY(collection_id),
 ADD KEY(bank_id),
 ADD KEY(storage_master_id),
 ADD KEY(participant_id),
 ADD KEY(participant_identifier),
 ADD KEY(acquisition_label),
 ADD KEY(initial_specimen_sample_type),
 ADD KEY(initial_specimen_sample_control_id),
 ADD KEY(parent_sample_type),
 ADD KEY(parent_sample_control_id),
 ADD KEY(barcode),
 	ADD KEY(frsq_number),
 ADD KEY(aliquot_label),
 ADD KEY(aliquot_type),
 ADD KEY(aliquot_control_id),
 ADD KEY(in_stock),
 ADD KEY(code),
 ADD KEY(selection_label),
 ADD KEY(temperature),
 ADD KEY(temp_unit),
 ADD KEY(created),
 ADD KEY(has_notes);

DROP TABLE IF EXISTS view_samples;
DROP VIEW IF EXISTS view_samples_view;
DROP VIEW IF EXISTS view_samples;
CREATE VIEW view_samples_view AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
col.participant_id, 

part.participant_identifier, 
	ident.identifier_value AS frsq_number,

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,
samp.sample_code,
sampc.sample_category,

IF(specimen_details.reception_datetime IS NULL, NULL,
 IF(col.collection_datetime IS NULL, -1,
 IF(col.collection_datetime_accuracy != 'c' OR specimen_details.reception_datetime_accuracy != 'c', -2,
 IF(col.collection_datetime > specimen_details.reception_datetime, -3,
 TIMESTAMPDIFF(MINUTE, col.collection_datetime, specimen_details.reception_datetime))))) AS coll_to_rec_spent_time_msg,
 
IF(derivative_details.creation_datetime IS NULL, NULL,
 IF(col.collection_datetime IS NULL, -1,
 IF(col.collection_datetime_accuracy != 'c' OR derivative_details.creation_datetime_accuracy != 'c', -2,
 IF(col.collection_datetime > derivative_details.creation_datetime, -3,
 TIMESTAMPDIFF(MINUTE, col.collection_datetime, derivative_details.creation_datetime))))) AS coll_to_creation_spent_time_msg 

FROM sample_masters as samp
INNER JOIN sample_controls as sampc ON samp.sample_control_id=sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN specimen_details ON specimen_details.sample_master_id=samp.id
LEFT JOIN derivative_details ON derivative_details.sample_master_id=samp.id
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id = parent_sampc.id
LEFT JOIN participants AS part ON col.participant_id = part.id AND part.deleted != 1
	LEFT JOIN misc_identifiers ident ON col.misc_identifier_id = ident.id and ident.deleted != 1
WHERE samp.deleted != 1;
 
CREATE TABLE view_samples (SELECT * FROM view_samples_view);
ALTER TABLE view_samples
 ADD PRIMARY KEY(sample_master_id),
 ADD KEY(parent_sample_id),
 ADD KEY(initial_specimen_sample_id),
 ADD KEY(collection_id),
 ADD KEY(bank_id),
 ADD KEY(sop_master_id),
 ADD KEY(participant_id),
 ADD KEY(participant_identifier),
 ADD KEY(acquisition_label),
 ADD KEY(initial_specimen_sample_type),
 ADD KEY(initial_specimen_sample_control_id),
 ADD KEY(parent_sample_type),
 ADD KEY(parent_sample_control_id),
 ADD KEY(sample_type),
 	ADD KEY(frsq_number),
 ADD KEY(sample_control_id),
 ADD KEY(sample_code),
 ADD KEY(sample_category),
 ADD KEY(coll_to_creation_spent_time_msg),
 ADD KEY(coll_to_rec_spent_time_msg);
  
DROP TABLE IF EXISTS view_collections;
DROP VIEW IF EXISTS view_collections;
DROP VIEW IF EXISTS view_collections_view;
CREATE VIEW `view_collections_view` AS 
select `col`.`id` AS `collection_id`,
`col`.`bank_id` AS `bank_id`,
`col`.`sop_master_id` AS `sop_master_id`,
`col`.`participant_id` AS `participant_id`,
`col`.`diagnosis_master_id` AS `diagnosis_master_id`,
`col`.`consent_master_id` AS `consent_master_id`,
`col`.`treatment_master_id` AS `treatment_master_id`,
`col`.`event_master_id` AS `event_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,
	ident.identifier_value AS frsq_number,
`col`.`acquisition_label` AS `acquisition_label`,
`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,
`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,
`col`.`collection_notes` AS `collection_notes`,
`banks`.`name` AS `bank_name`,
`col`.`created` AS `created` 
from `collections` `col` 
left join `participants` `part` on `col`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1 
left join `banks` on `col`.`bank_id` = `banks`.`id` and `banks`.`deleted` <> 1 
	LEFT JOIN misc_identifiers ident ON col.misc_identifier_id = ident.id and ident.deleted != 1
where `col`.`deleted` <> 1;

CREATE TABLE view_collections (SELECT * FROM view_collections_view);
ALTER TABLE view_collections
 ADD PRIMARY KEY(collection_id),
 ADD KEY(bank_id),
 ADD KEY(sop_master_id),
 ADD KEY(participant_id),
 	ADD KEY(frsq_number),
 ADD KEY(diagnosis_master_id),
 ADD KEY(consent_master_id),
 ADD KEY(treatment_master_id),
 ADD KEY(event_master_id),
 ADD KEY(participant_identifier),
 ADD KEY(acquisition_label),
 ADD KEY(collection_site),
 ADD KEY(collection_datetime),
 ADD KEY(collection_property),
 ADD KEY(created);
 
UPDATE structure_formats SET `display_order`='103' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
 
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @id = (SELECT id FROM misc_identifier_controls WHERE autoincrement_name = 'frsq_br');
SET @last_val = (SELECT MAX(CAST(Replace(identifier_value, 'BR', '') AS UNSIGNED)) AS val  FROM misc_identifiers WHERE misc_identifier_control_id = @id  LIMIT 0,5);
UPDATE key_increments SET key_value = (@last_val +1) WHERE key_name = 'frsq_br';

SET @id = (SELECT id FROM misc_identifier_controls WHERE autoincrement_name = 'frsq_ov');
SET @last_val = (SELECT MAX(CAST(Replace(identifier_value, 'OV', '') AS UNSIGNED)) AS val  FROM misc_identifiers WHERE misc_identifier_control_id = @id  LIMIT 0,5);
UPDATE key_increments SET key_value = (@last_val +1) WHERE key_name = 'frsq_ov';

SELECT 'Please confirm key_increments' AS MSG;
SELECT * FROM key_increments;

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='col_copy_binding_opt') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_frsq_nbr' AND `language_label`='copy #frsq (if it exists)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='1' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_frsq_nbr' AND `language_label`='copy #frsq (if it exists)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='1' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_frsq_nbr' AND `language_label`='copy #frsq (if it exists)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='1' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_permissible_values SET language_alias = 'all (participant, consent, diagnosis, treatment/annotation and #frsq)' WHERE language_alias = "all (participant, consent, diagnosis and treatment/annotation)";
INSERT INTO i18n (id,en,fr) VALUES ('all (participant, consent, diagnosis, treatment/annotation and #frsq)', 'All (Participant, Consent, Diagnosis, Treatment/Annotation and #FRSQ)','Tout (participant, Consentement, Diagnotic, Traitement/Annotation et #FRSQ)');

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''tissue source list'')' WHERE domain_name = 'tissue_source_list';

UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `tablename`='aliquot_masters',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='chus_time_limits_of_storage')  WHERE model='AliquotMaster' AND tablename='' AND field='chus_time_limit_of_storage' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_time_limits_of_storage');

