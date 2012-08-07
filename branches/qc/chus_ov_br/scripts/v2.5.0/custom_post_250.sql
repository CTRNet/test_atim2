UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;
UPDATE misc_identifiers mi INNER JOIN misc_identifiers_revs mi_r ON mi.id=mi_r.id SET mi_r.flag_unique=mi.flag_unique;

UPDATE consent_controls SET detail_form_alias = '' WHERE detail_form_alias = 'consent_masters';

DROP TABLE IF EXISTS view_aliquots;
DROP VIEW IF EXISTS view_aliquots;

DROP TABLE IF EXISTS view_samples;
DROP VIEW IF EXISTS view_samples;
 
DROP TABLE IF EXISTS view_collections;
DROP VIEW IF EXISTS view_collections;

DROP TABLE IF EXISTS view_storage_masters;
DROP VIEW IF EXISTS view_storage_masters;

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

ALTER TABLE chus_dxd_breasts_revs 
	MODIFY diagnosis_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_dxd_ovaries_revs 
	MODIFY diagnosis_master_id INT NOT NULL,
	DROP COLUMN id;
		
ALTER TABLE chus_ed_clinical_ctscans_revs 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id;
	
ALTER TABLE chus_ed_clinical_followups_revs 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_ed_lab_breast_ca153_tests_revs 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_ed_lab_breast_immunos_revs 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_ed_lab_ovary_ca125_tests_revs 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_ed_lab_ovary_immunos_revs 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id;
	
ALTER TABLE chus_ed_past_histories_revs 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_txd_breast_surgeries_revs 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id;
	
ALTER TABLE chus_txd_chemos_revs 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_txd_radiations_revs 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id;
	
ALTER TABLE chus_txd_ovary_surgeries_revs 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id;
	
ALTER TABLE chus_txd_hormonos_revs 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id;

ALTER TABLE chus_dxd_breasts 
	MODIFY diagnosis_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE chus_dxd_ovaries 
	MODIFY diagnosis_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;
		
ALTER TABLE chus_ed_clinical_ctscans 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;
	
ALTER TABLE chus_ed_clinical_followups 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE chus_ed_lab_breast_ca153_tests 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE chus_ed_lab_breast_immunos 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE chus_ed_lab_ovary_ca125_tests 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE chus_ed_lab_ovary_immunos 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;
	
ALTER TABLE chus_ed_past_histories 
	MODIFY event_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE chus_txd_breast_surgeries 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;
	
ALTER TABLE chus_txd_chemos 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE chus_txd_radiations 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;
	
ALTER TABLE chus_txd_ovary_surgeries 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;
	
ALTER TABLE chus_txd_hormonos 
	MODIFY treatment_master_id INT NOT NULL,
	DROP COLUMN id, 
	DROP COLUMN deleted;

ALTER TABLE `storage_masters` 
	MODIFY `short_label` varchar(25) DEFAULT NULL,
	MODIFY `selection_label` varchar(100) DEFAULT '';
ALTER TABLE `storage_masters_revs` 
	MODIFY `short_label` varchar(25) DEFAULT NULL,
	MODIFY `selection_label` varchar(100) DEFAULT '';
