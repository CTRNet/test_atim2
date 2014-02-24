-- ----------------------------------------------------------------------------------------------
-- Profile And MiscIdentifiers
-- ----------------------------------------------------------------------------------------------

UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;

-- ------------------------------------------------------------------------------------------------
-- Consent
-- ------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_column`='0', `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='-1', `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='-1', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents_2012_10') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-70' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `language_label`='consent status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `language_help`='help_consent_status' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents_2012_10') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-72' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `language_label`='status date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='NULL' AND `structure_value_domain` IS NULL  AND `language_help`='help_status_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents_2012_10') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-68' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `language_label`='consent signed date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_consent_signed_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents_2012_10') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-18' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_notes' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-70' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `language_label`='consent status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `language_help`='help_consent_status' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-72' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `language_label`='status date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='NULL' AND `structure_value_domain` IS NULL  AND `language_help`='help_status_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-68' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `language_label`='consent signed date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_consent_signed_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-18' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_notes' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name = 'Consent Form Versions';

INSERT INTO i18n (id,en) VALUES ('consent v2013-01-08','Consent v2013-01-08');

-- ------------------------------------------------------------------------------------------------
-- Treatment
-- ------------------------------------------------------------------------------------------------

SET @treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'qc_hb_txe_surgery_complications' AND detail_form_alias = 'qc_hb_txe_surgery_complications');
ALTER TABLE treatment_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;
INSERT INTO treatment_extend_masters (tmp_old_extend_id, treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted FROM qc_hb_txe_surgery_complications);
ALTER TABLE qc_hb_txe_surgery_complications ADD treatment_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY qc_hb_txe_surgery_complications_ibfk_1, DROP COLUMN treatment_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;
UPDATE treatment_extend_masters extend_master, qc_hb_txe_surgery_complications extend_detail SET extend_detail.treatment_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;
ALTER TABLE qc_hb_txe_surgery_complications_revs ADD COLUMN treatment_extend_master_id int(11) NOT NULL;
UPDATE qc_hb_txe_surgery_complications_revs extend_detail_revs, qc_hb_txe_surgery_complications extend_detail SET extend_detail_revs.treatment_extend_master_id = extend_detail.treatment_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;
ALTER TABLE qc_hb_txe_surgery_complications ADD CONSTRAINT FK_qc_hb_txe_surgery_complications_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id), DROP COLUMN id;
INSERT INTO treatment_extend_masters_revs (id, treatment_extend_control_id, treatment_master_id, modified_by, version_created) (SELECT treatment_extend_master_id, @treatment_extend_control_id, treatment_master_id, modified_by, version_created FROM qc_hb_txe_surgery_complications_revs ORDER BY version_id ASC);
ALTER TABLE treatment_extend_masters DROP COLUMN tmp_old_extend_id;
ALTER TABLE qc_hb_txe_surgery_complications_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN treatment_master_id;
UPDATE treatment_extend_masters SET deleted = 1 WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted = 1);
UPDATE treatment_extend_controls SET type = 'surgery complications', databrowser_label = 'surgery complications' WHERE detail_tablename = 'qc_hb_txe_surgery_complications';

DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

UPDATE menus SET use_link = '/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%' WHERE use_link LIKE '/clinicalannotation/treatment_masters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%';

INSERT INTO structure_permissible_values (value, language_alias) VALUES("partial", "partial");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_segment_resection"), (SELECT id FROM structure_permissible_values WHERE value="partial" AND language_alias="partial"), "0", "1");

REPLACE INTO i18n (id,en) VALUES ('chemo-embolization','Chemo-Embolization');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_other_protocols'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_other_protocols'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-47' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `language_label`='finish date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_finish_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
UPDATE treatment_controls SET detail_form_alias = 'qc_hb_txd_other_protocols' WHERE detail_form_alias = 'qc_hb_txd_others,qc_hb_txd_other_protocols';

-- SELECT tm.id, td.treatment_master_id, tm.treatment_control_id, protocol_master_id, finish_date, surgery_type
-- FROM treatment_masters tm
-- LEFT JOIN qc_hb_txd_others td ON tm.id = td.treatment_master_id
-- WHERE tm.deleted <> 1 AND tm.treatment_control_id IN (10,12,13);
-- SELECT tm.id, td.treatment_master_id, tm.treatment_control_id, protocol_master_id, start_date, finish_date, surgery_type
-- FROM treatment_masters tm
-- LEFT JOIN qc_hb_txd_others td ON tm.id = td.treatment_master_id
-- WHERE tm.deleted <> 1 AND tm.treatment_control_id IN (11);


UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_other_protocols') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='associated_surgery_1' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='associated_surgery_2' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='associated_surgery_3' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='local_treatment' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='type_of_local_treatment' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_type_of_local_treatment') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='other_organ_resection_1' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='other_organ_resection_2' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='other_organ_resection_3' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='operative_time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='laparoscopy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='operative_bleeding' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='transfusions' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='rbc_units' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='plasma_units' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='platelets_units' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='operative_pathological_report' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='drainage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='biological_glue' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='type_of_glue' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_type_of_glue') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='operative_ultrasound_ous' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='impact_of_ous' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_impact_of_ous') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='gastric_tube_duration_in_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='simultaneous_primary_resection' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' AND `field`='cell_saver_volume_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='associated_surgery_1' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='associated_surgery_2' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='associated_surgery_3' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_principal_surgery') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='local_treatment' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='type_of_local_treatment' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_type_of_local_treatment') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='other_organ_resection_1' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='other_organ_resection_2' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='other_organ_resection_3' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_other_organ_resection') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='operative_time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='laparoscopy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='operative_bleeding' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='transfusions' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='rbc_units' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='plasma_units' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='platelets_units' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='operative_pathological_report' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='pathological_report' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_pathological_report') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='drainage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='biological_glue' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='type_of_glue' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_surgery_type_of_glue') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='operative_ultrasound_ous' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_ns') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='impact_of_ous' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_impact_of_ous') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='survival_time_in_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='cell_saver_volume_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='resected_liver_weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='gastric_tube_duration_in_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='simultaneous_primary_resection' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- protocol

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE protocol_controls SET tumour_group = '' WHERE flag_active = 1;
UPDATE protocol_masters SET notes = CONCAT(notes, ' (', name, ')');
UPDATE protocol_masters SET name = '';
UPDATE protocol_masters_revs SET notes = CONCAT(notes, ' (', name, ')');
UPDATE protocol_masters_revs SET name = '';

SELECT 'Correct survival time if required (editing/saving record in atim)!' AS TODO
UNION ALL
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS TODO;
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_livers td ON td.treatment_master_id = tm.id
WHERE (p.last_news_date_accuracy IN ('y','m') OR tm.start_date_accuracy IN ('y','m')) AND td.survival_time_in_months IS NOT NULL
UNION ALL
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_livers td ON td.treatment_master_id = tm.id
WHERE (p.last_news_date IS NULL OR tm.start_date IS NULL ) AND td.survival_time_in_months IS NOT NULL
UNION ALL
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_livers td ON td.treatment_master_id = tm.id
WHERE (p.last_news_date IS NOT NULL AND tm.start_date IS NOT NULL ) AND td.survival_time_in_months IS NULL
UNION ALL
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_livers td ON td.treatment_master_id = tm.id
WHERE td.survival_time_in_months IS NOT NULL AND td.survival_time_in_months != (TIMESTAMPDIFF(MONTH, tm.start_date,  p.last_news_date))
UNION ALL
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.treatment_master_id = tm.id
WHERE (p.last_news_date_accuracy IN ('y','m') OR tm.start_date_accuracy IN ('y','m')) AND td.survival_time_in_months IS NOT NULL
UNION ALL
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.treatment_master_id = tm.id
WHERE (p.last_news_date IS NULL OR tm.start_date IS NULL ) AND td.survival_time_in_months IS NOT NULL
UNION ALL
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.treatment_master_id = tm.id
WHERE (p.last_news_date IS NOT NULL AND tm.start_date IS NOT NULL ) AND td.survival_time_in_months IS NULL
UNION ALL
SELECT p.id AS participant_id, tm.id AS treatment_master_id, p.last_news_date, p.last_news_date_accuracy, tm.start_date, tm.start_date_accuracy, td.survival_time_in_months
FROM participants p
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.treatment_master_id = tm.id
WHERE td.survival_time_in_months IS NOT NULL AND td.survival_time_in_months != (TIMESTAMPDIFF(MONTH, tm.start_date,  p.last_news_date));
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS 'END TODO'
UNION ALL
SELECT '' AS 'END TODO';

INSERT INTO i18n (id,en) VALUES ('surgery complications','Surgery Complications');

-- ------------------------------------------------------------------------------------------------
-- Event
-- ------------------------------------------------------------------------------------------------

UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/scores/%%Participant.id%%' WHERE use_link = '/clinicalannotation/event_masters/listall/scores/%%Participant.id%%';
UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/imagery/%%Participant.id%%' WHERE use_link = '/clinicalannotation/event_masters/listall/imagery/%%Participant.id%%';
UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/medical_history/%%Participant.id%%' WHERE use_link = '/clinicalannotation/event_masters/listall/medical_history/%%Participant.id%%';
UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/imageryReport/%%Participant.id%%/' WHERE use_link = '/clinicalannotation/event_masters/imageryReport/%%Participant.id%%/';
UPDATE event_controls SET disease_site = '' WHERE flag_active = 1;
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');

SELECT 'Correct bmi if required (editing/saving record in atim)!' AS TODO
UNION ALL
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS TODO;
SELECT weight, height, bmi, ((weight/(height*height)) * 10000) AS bmi_calculated 
FROM qc_hb_ed_hepatobiliary_clinical_presentations
WHERE (bmi IS NOT NULL AND (weight IS NULL OR height IS NULL)) 
OR (bmi != ROUND(((weight/(height*height)) * 10000),3));
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS 'END TODO'
UNION ALL
SELECT '' AS 'END TODO';

-- clinical.hospitalization & clinical.intensive care

UPDATE event_controls SET use_detail_form_for_index = '1' WHERE event_group = 'clinical' AND event_type IN ('hospitalization','intensive care');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_intensive_care') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_intensive_cares' AND `field`='intensive_care_duration_in_days' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_intensive_care') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en) VALUES ('hospitalization','Hospitalization');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_hospitalization') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hospitalizations' AND `field`='hospitalization_end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_hospitalization') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- clinical.follow_up

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='recurrence_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_recurrence_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='disease_status_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='qc_hb_recurrence_localization_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE event_controls SET use_detail_form_for_index = '1' WHERE event_group = 'clinical' AND event_type IN ('follow up');

-- lab

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='histologic_type_specify' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='necrosis_perc' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='necrosis_perc_list' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_viable_cells_perc') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumor_size_cannot_be_determined' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_greatest_dimension' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_additional_dimension_a' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_additional_dimension_b' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_cannot_be_determined' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='tumor_site_specify' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='distance_of_tumor_from_closest_surgical_resection_margin' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='distance_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='distance_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='specify_margin' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='adjacent_liver_parenchyma_specify' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='rubbia_brandt' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_rubbia_brandt_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='blazer' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_blazer_values') AND `flag_confidential`='0');

-- imaging

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('resected volume bigger than liver volume','Resected volume bigger than liver volume');
INSERT INTO i18n (id,en) VALUES ('tumoral volume bigger than liver volume','Tumoral volume bigger than liver volume');

SELECT 'Correct remnant_liver_volume if required (editing/saving record in atim)!' AS TODO
UNION ALL
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS TODO;
SELECT 
ed.event_master_id, 
ed.total_liver_volume, 
ed.resected_liver_volume, 
ed.tumoral_volume, 
ed.remnant_liver_volume,
(ed.total_liver_volume-ed.resected_liver_volume) AS remnant_liver_volume_calculated
FROM qc_hb_ed_hepatobilary_medical_imagings AS ed INNER JOIN event_masters AS em ON ed.event_master_id = em.id AND em.deleted <> 1
WHERE (total_liver_volume IS NOT NULL OR resected_liver_volume IS NOT NULL OR tumoral_volume IS NOT NULL OR remnant_liver_volume IS NOT NULL OR remnant_liver_percentage IS NOT NULL)
AND ((ed.remnant_liver_volume != (ed.total_liver_volume-ed.resected_liver_volume)) OR ((ed.total_liver_volume IS NULL OR ed.resected_liver_volume IS NULL) AND ed.remnant_liver_volume IS NOT NULL)); 
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS TODO
UNION ALL
SELECT '' AS TODO;

SELECT 'Correct remnant_liver_percentage if required (editing/saving record in atim)!' AS TODO
UNION ALL
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS TODO;
SELECT 
ed.event_master_id, 
ed.total_liver_volume, 
ed.resected_liver_volume, 
ed.tumoral_volume,
ed.remnant_liver_percentage,
ROUND((((ed.total_liver_volume-ed.resected_liver_volume)/(ed.total_liver_volume-ed.tumoral_volume))*100),4) AS remnant_liver_percentage_calculated
FROM qc_hb_ed_hepatobilary_medical_imagings AS ed INNER JOIN event_masters AS em ON ed.event_master_id = em.id AND em.deleted <> 1
WHERE
(total_liver_volume IS NOT NULL OR resected_liver_volume IS NOT NULL OR tumoral_volume IS NOT NULL OR remnant_liver_volume IS NOT NULL OR remnant_liver_percentage IS NOT NULL)
AND (
(ROUND(ed.remnant_liver_percentage,3) != ROUND((((ed.total_liver_volume-ed.resected_liver_volume)/(ed.total_liver_volume-ed.tumoral_volume))*100),3))
OR ((ed.total_liver_volume IS NULL OR ed.resected_liver_volume IS NULL) AND ed.remnant_liver_percentage IS NOT NULL)
); 
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS 'END TODO'
UNION ALL
SELECT '' AS 'END TODO';

-- Medical History

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_med_hist_record_summary') AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Score

INSERT INTO i18n (id,en) VALUES ('calculated value for field [%field%] is negative', 'Calculated value for field [%field%] is negative'),
('at least one pre operative data is linked to this annotation', 'At least one Pre-Operative data is linked to this annotation');
UPDATE event_controls SET use_detail_form_for_index = '1' WHERE event_group = 'scores';

SELECT 'Correct event_masters.deleted if required!' AS TODO
UNION ALL
SELECT '+-----------------+--------------------+-----------------------+----------------+----------------------+---------------------------------+' AS TODO;
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.lab_report_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.imagery_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.fong_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.meld_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.gretch_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.clip_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.barcelona_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_livers td ON td.okuda_score_id = em.id
WHERE em.deleted = 1

UNION ALL

SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.lab_report_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.imagery_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.fong_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.meld_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.gretch_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.clip_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.barcelona_score_id = em.id
WHERE em.deleted = 1
UNION ALL
SELECT em.participant_id, em.id AS event_master_id, td.treatment_master_id
FROM event_masters em
INNER JOIN qc_hb_txd_surgery_pancreas td ON td.okuda_score_id = em.id
WHERE em.deleted = 1;
SELECT '+----------------+-----------------+---------------------+' AS 'END TODO'
UNION ALL
SELECT '' AS 'END TODO';
		
-- ------------------------------------------------------------------------------------------------
-- structure_permissible_values_custom_controls
-- ------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery: Principal surgery' WHERE name = 'surgery: principal surgery';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery: Other organ resection' WHERE name = 'surgery: other organ resection';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery: Pathological report' WHERE name = 'surgery: pathological report';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery: Type of drain' WHERE name = 'surgery: type of drain';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery: Type of glue' WHERE name = 'surgery: type of glue';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgey - Liver detail : Liver appearance' WHERE name = 'surgey - liver detail : liver appearance';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgey - Liver detail : Type of vascular occlusion' WHERE name = 'surgey - liver detail : type of vascular occlusion';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgey - Liver pancreas : Pancreas appearance' WHERE name = 'surgey - liver pancreas : pancreas appearance';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgey - Liver pancreas : Anastomosis type' WHERE name = 'surgey - liver pancreas : anastomosis type';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery - Complication : Organ list' WHERE name = 'surgey - complication : organ list';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Chemotherapy : Reason of change' WHERE name = 'chemotherapy : reason of change';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Chemotherapy : Toxicity' WHERE name = 'chemotherapy : toxicity';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery - Complication: Treatment' WHERE name = 'surgery - complication: treatment';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery: Local treatment type' WHERE name = 'surgery: local treatment type';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery - Complication : Type' WHERE name = 'surgey - complication : type';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery : Surgeon list' WHERE name = 'surgey : surgeon list';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Doctor : Speciality list' WHERE name = 'doctor : speciality list';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Chemotherapy : Regimen list' WHERE name = 'chemotherapy : regimen list';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Hepatitis Treatment' WHERE name = 'hepatitis treatment';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Type of hepatitis' WHERE name = 'type of hepatitis';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Cirrhosis type' WHERE name = 'cirrhosis type';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'Surgery: Complication treatment' WHERE name = 'surgery: complication treatment';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis', name = 'Liver metastasis : Hitologic type' WHERE name = 'liver metastasis : hitologic type';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - diagnosis', name = 'Liver metastasis : Tumor site' WHERE name = 'liver metastasis : tumor site';
UPDATE structure_permissible_values_custom_controls SET category = 'inventory', name = 'GenHeMACS enzymatic milieu' WHERE name = 'genHeMACS enzymatic milieu';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Bile Ducts List' WHERE name = 'Bile Ducts List';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Follow-up : Recurrence localization' WHERE name = 'follow-up : recurrence localization';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Follow-up : Recurrence treatment' WHERE name = 'follow-up : recurrence treatment';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation', name = 'Medical imagings : Radiologic TACE response' WHERE name = 'medical imagings : radiologic TACE response';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - treatment', name = 'TACE : Complication treatment' WHERE name = 'TACE : complication treatment';

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery: Principal surgery')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: principal surgery')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery: Other organ resection')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: other organ resection')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery: Pathological report')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: pathological report')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery: Type of drain')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: type of drain')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery: Type of glue')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: type of glue')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgey - Liver detail : Liver appearance')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver detail : liver appearance')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgey - Liver detail : Type of vascular occlusion')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver detail : type of vascular occlusion')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgey - Liver pancreas : Pancreas appearance')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver pancreas : pancreas appearance')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgey - Liver pancreas : Anastomosis type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver pancreas : anastomosis type')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery - Complication : Organ list')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - complication : organ list')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Chemotherapy : Reason of change')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : reason of change')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Chemotherapy : Toxicity')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : toxicity')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery - Complication: Treatment')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery - complication: treatment')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery: Local treatment type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: local treatment type')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery - Complication : Type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - complication : type')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery : Surgeon list')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey : surgeon list')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Doctor : Speciality list')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('doctor : speciality list')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Chemotherapy : Regimen list')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : regimen list')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Hepatitis Treatment')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('hepatitis treatment')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Type of hepatitis')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('type of hepatitis')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Cirrhosis type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('cirrhosis type')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Surgery: Complication treatment')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: complication treatment')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Liver metastasis : Hitologic type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('liver metastasis : hitologic type')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Liver metastasis : Tumor site')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('liver metastasis : tumor site')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('GenHeMACS enzymatic milieu')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('genHeMACS enzymatic milieu')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Bile Ducts List')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('Bile Ducts List')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Follow-up : Recurrence localization')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('follow-up : recurrence localization')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Follow-up : Recurrence treatment')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('follow-up : recurrence treatment')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Medical imagings : Radiologic TACE response')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('medical imagings : radiologic TACE response')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('TACE : Complication treatment')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('TACE : complication treatment')";

-- ------------------------------------------------------------------------------------------------
-- Clinical Collection Link
-- ------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------
-- Inventory
-- ------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(181, 185);
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='aliquot code' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `tablename`='specimen_details' WHERE model='SpecimenDetail' AND field='qc_hb_sample_code';










-- ------------------------------------------------------------------------------------------------
-- Datamart
-- ------------------------------------------------------------------------------------------------

DELETE FROM datamart_structure_functions WHERE datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('ParticipantContact') AND display_name = 'contacts');
DELETE FROM datamart_browsing_controls WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ParticipantContact') AND display_name = 'contacts');
DELETE FROM datamart_browsing_controls WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ParticipantContact') AND display_name = 'contacts');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster', 'ALiquotReviewMaster')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster', 'ALiquotReviewMaster'));

-- ------------------------------------------------------------------------------------------------
-- Report
-- ------------------------------------------------------------------------------------------------











 



ajouter blood type a summary
