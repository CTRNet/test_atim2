
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- End of script custom_post267.sql
-- ----------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('finish date (if applicable)','Finish Date (if applicable)','Date de fin (si applicable)'),
('last completed drug treatment', 'Last Completed Drug/Medication (Defined as finished)', 'Derniere prise de médicament complétée (définie comme terminé)'),
('ongoing drug treatment', 'Ongoing Drug/Medication (Defined as unfinished)', 'Médicament en cours (défini comme non-terminé)');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_next_followup_finish_date', 'date',  NULL , '0', '', '', '', 'finish date (if applicable)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_next_followup_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_next_followup_finish_date'), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE versions SET branch_build_number = '6513' WHERE version_number = '2.6.7';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Create System User
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');

UPDATE users set username = 'system', first_name = '', flag_active = 0 WHERE username = 'manager';
UPDATE groups set name = 'system' WHERE name = 'manager';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Changed format of box Box27 1A-9C
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET @storage_control_id = (SELECT id FROM storage_controls WHERE storage_type LIKE 'Box27 1A-9C');
UPDATE storage_controls 
SET coord_x_title = 'column', coord_x_type = 'alphabetical', coord_x_size = '3', 
coord_y_title = 'row', coord_y_type = 'integer', coord_y_size = '9'
WHERE id = @storage_control_id;

ALTER TABLE aliquot_masters 
  ADD COLUMN tmp_old_storage_coord_x varchar(11),
  ADD COLUMN tmp_old_storage_coord_y varchar(11);
ALTER TABLE aliquot_masters_revs
  ADD COLUMN tmp_old_storage_coord_x varchar(11),
  ADD COLUMN tmp_old_storage_coord_y varchar(11); 
UPDATE aliquot_masters 
SET tmp_old_storage_coord_x = storage_coord_x, tmp_old_storage_coord_y = storage_coord_y
WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id); 
UPDATE aliquot_masters 
SET storage_coord_x = tmp_old_storage_coord_y, storage_coord_y = tmp_old_storage_coord_x
WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id); 
UPDATE aliquot_masters_revs 
SET tmp_old_storage_coord_x = storage_coord_x, tmp_old_storage_coord_y = storage_coord_y
WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id); 
UPDATE aliquot_masters_revs 
SET storage_coord_x = tmp_old_storage_coord_y, storage_coord_y = tmp_old_storage_coord_x
WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id); 
ALTER TABLE aliquot_masters 
  DROP COLUMN tmp_old_storage_coord_x,
  DROP COLUMN tmp_old_storage_coord_y;
ALTER TABLE aliquot_masters_revs
  DROP COLUMN tmp_old_storage_coord_x,
  DROP COLUMN tmp_old_storage_coord_y;

ALTER TABLE storage_masters 
  ADD COLUMN tmp_old_parent_storage_coord_x varchar(11),
  ADD COLUMN tmp_old_parent_storage_coord_y varchar(11);
ALTER TABLE storage_masters_revs
  ADD COLUMN tmp_old_parent_storage_coord_x varchar(11),
  ADD COLUMN tmp_old_parent_storage_coord_y varchar(11); 
UPDATE storage_masters 
SET tmp_old_parent_storage_coord_x = parent_storage_coord_x, tmp_old_parent_storage_coord_y = parent_storage_coord_y
WHERE parent_id IN (SELECT id FROM (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id) res); 
UPDATE storage_masters 
SET parent_storage_coord_x = tmp_old_parent_storage_coord_y, parent_storage_coord_y = tmp_old_parent_storage_coord_x
WHERE parent_id IN (SELECT id FROM (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id) res); 
UPDATE storage_masters_revs 
SET tmp_old_parent_storage_coord_x = parent_storage_coord_x, tmp_old_parent_storage_coord_y = parent_storage_coord_y
WHERE parent_id IN (SELECT id FROM (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id) res); 
UPDATE storage_masters_revs 
SET parent_storage_coord_x = tmp_old_parent_storage_coord_y, parent_storage_coord_y = tmp_old_parent_storage_coord_x
WHERE parent_id IN (SELECT id FROM (SELECT id FROM storage_masters WHERE storage_control_id = @storage_control_id) res); 
ALTER TABLE storage_masters 
  DROP COLUMN tmp_old_parent_storage_coord_x,
  DROP COLUMN tmp_old_parent_storage_coord_y;
ALTER TABLE storage_masters_revs
  DROP COLUMN tmp_old_parent_storage_coord_x,
  DROP COLUMN tmp_old_parent_storage_coord_y;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove > Annotation > Study menu
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Study%';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove some procure chuq field
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE participants 
  CHANGE  procure_chuq_last_contact_date `procure_chuq_deprecated_last_contact_date` date DEFAULT NULL,
  CHANGE  procure_chuq_last_contact_date_accuracy `procure_chuq_deprecated_last_contact_date_accuracy` char(1) NOT NULL DEFAULT '',
  CHANGE  procure_chuq_stop_followup `procure_chuq_deprecated_stop_followup` tinyint(1) DEFAULT NULL;
ALTER TABLE participants_revs
  CHANGE  procure_chuq_last_contact_date `procure_chuq_deprecated_last_contact_date` date DEFAULT NULL,
  CHANGE  procure_chuq_last_contact_date_accuracy `procure_chuq_deprecated_last_contact_date_accuracy` char(1) NOT NULL DEFAULT '',
  CHANGE  procure_chuq_stop_followup `procure_chuq_deprecated_stop_followup` tinyint(1) DEFAULT NULL; 
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_last_contact_date' AND `language_label`='last contact' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_stop_followup' AND `language_label`='stop followup' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_last_contact_date' AND `language_label`='last contact' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_stop_followup' AND `language_label`='stop followup' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_last_contact_date' AND `language_label`='last contact' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='procure_chuq_stop_followup' AND `language_label`='stop followup' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE procure_ed_other_tumor_diagnosis 
  CHANGE procure_chuq_icd10_code procure_chuq_deprecated_icd10_code varchar(10) DEFAULT NULL;
ALTER TABLE procure_ed_other_tumor_diagnosis_revs
  CHANGE procure_chuq_icd10_code procure_chuq_deprecated_icd10_code varchar(10) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_other_tumor_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_other_tumor_diagnosis' AND `field`='procure_chuq_icd10_code' AND `language_label`='disease code' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_dx_icd10_code_who' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_other_tumor_diagnosis' AND `field`='procure_chuq_icd10_code' AND `language_label`='disease code' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_dx_icd10_code_who' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_other_tumor_diagnosis' AND `field`='procure_chuq_icd10_code' AND `language_label`='disease code' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_dx_icd10_code_who' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE procure_ed_questionnaires
  CHANGE procure_chuq_complete_at_recovery procure_chuq_deprecated_complete_at_recovery char(1) DEFAULT '';
ALTER TABLE procure_ed_questionnaires_revs
  CHANGE procure_chuq_complete_at_recovery procure_chuq_deprecated_complete_at_recovery char(1) DEFAULT '';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_questionnaires') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_questionnaires' AND `field`='procure_chuq_complete_at_recovery' AND `language_label`='complete at recovery' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_questionnaires' AND `field`='procure_chuq_complete_at_recovery' AND `language_label`='complete at recovery' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='procure_ed_questionnaires' AND `field`='procure_chuq_complete_at_recovery' AND `language_label`='complete at recovery' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE procure_txd_treatments
  CHANGE procure_chuq_protocol procure_chuq_deprecated_protocol varchar(50) DEFAULT NULL,
  CHANGE procure_chuq_period procure_chuq_deprecated_period varchar(50) DEFAULT NULL,
  CHANGE procure_chuq_surgeon procure_chuq_deprecated_surgeon varchar(60) DEFAULT NULL,
  CHANGE procure_chuq_laparotomy procure_chuq_deprecated_laparotomy tinyint(1) DEFAULT NULL,
  CHANGE procure_chuq_laparoscopy procure_chuq_deprecated_laparoscopy tinyint(1) DEFAULT NULL;
ALTER TABLE procure_txd_treatments_revs
  CHANGE procure_chuq_protocol procure_chuq_deprecated_protocol varchar(50) DEFAULT NULL,
  CHANGE procure_chuq_period procure_chuq_deprecated_period varchar(50) DEFAULT NULL,
  CHANGE procure_chuq_surgeon procure_chuq_deprecated_surgeon varchar(60) DEFAULT NULL,
  CHANGE procure_chuq_laparotomy procure_chuq_deprecated_laparotomy tinyint(1) DEFAULT NULL,
  CHANGE procure_chuq_laparoscopy procure_chuq_deprecated_laparoscopy tinyint(1) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_period' AND `language_label`='period' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_period') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_protocol' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_surgeon' AND `language_label`='surgeon' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_laparotomy' AND `language_label`='laparotomy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_laparoscopy' AND `language_label`='laparoscopy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_period' AND `language_label`='period' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_period') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_protocol' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_surgeon' AND `language_label`='surgeon' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_laparotomy' AND `language_label`='laparotomy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_laparoscopy' AND `language_label`='laparoscopy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_period' AND `language_label`='period' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_period') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_protocol' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_surgeon' AND `language_label`='surgeon' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_laparotomy' AND `language_label`='laparotomy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='procure_chuq_laparoscopy' AND `language_label`='laparoscopy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE procure_deprecated_table_txd_medication_drugs
  CHANGE procure_chuq_period procure_chuq_deprecated_period varchar(50) DEFAULT NULL,
  CHANGE procure_chuq_protocol procure_chuq_deprecated_protocol varchar(50) DEFAULT NULL;
ALTER TABLE procure_deprecated_table_txd_medication_drugs_revs
  CHANGE procure_chuq_period procure_chuq_deprecated_period varchar(50) DEFAULT NULL,
  CHANGE procure_chuq_protocol procure_chuq_deprecated_protocol varchar(50) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_medication_drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='procure_chuq_period' AND `language_label`='period' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_period') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_medication_drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='procure_chuq_protocol' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='procure_chuq_period' AND `language_label`='period' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_period') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='procure_chuq_protocol' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='procure_chuq_period' AND `language_label`='period' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_period') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_medication_drugs' AND `field`='procure_chuq_protocol' AND `language_label`='protocol' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE quality_ctrls
  CHANGE procure_chuq_visual_quality procure_chuq_deprecated_visual_quality varchar(50) DEFAULT NULL;
ALTER TABLE quality_ctrls_revs
  CHANGE procure_chuq_visual_quality procure_chuq_deprecated_visual_quality varchar(50) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_chuq_visual_quality' AND `language_label`='visual quality' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_chuq_visual_quality' AND `language_label`='visual quality' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_chuq_visual_quality' AND `language_label`='visual quality' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE sd_der_rnas 
  CHANGE procure_chuq_extraction_number procure_chuq_deprecated_extraction_number varchar(10) DEFAULT NULL,
  CHANGE procure_chuq_dnase_duration_mn procure_chuq_deprecated_dnase_duration_mn int(10) DEFAULT NULL;
ALTER TABLE sd_der_rnas_revs
  CHANGE procure_chuq_extraction_number procure_chuq_deprecated_extraction_number varchar(10) DEFAULT NULL,
  CHANGE procure_chuq_dnase_duration_mn procure_chuq_deprecated_dnase_duration_mn int(10) DEFAULT NULL;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_chuq_sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='procure_chuq_extraction_number' AND `language_label`='extraction number' AND `language_tag`='' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_chuq_sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='procure_chuq_dnase_duration_mn' AND `language_label`='dnase duration mn' AND `language_tag`='' AND `type`='integer' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='procure_chuq_extraction_number' AND `language_label`='extraction number' AND `language_tag`='' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='procure_chuq_dnase_duration_mn' AND `language_label`='dnase duration mn' AND `language_tag`='' AND `type`='integer' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='procure_chuq_extraction_number' AND `language_label`='extraction number' AND `language_tag`='' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='procure_chuq_dnase_duration_mn' AND `language_label`='dnase duration mn' AND `language_tag`='' AND `type`='integer' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

ALTER TABLE sd_der_urine_cents
  CHANGE procure_chuq_concentration_ratio procure_chuq_deprecated_concentration_ratio varchar(20) DEFAULT NULL,
  CHANGE procure_chuq_pellet procure_chuq_deprecated_pellet char(1) DEFAULT '';
ALTER TABLE sd_der_urine_cents_revs
  CHANGE procure_chuq_concentration_ratio procure_chuq_deprecated_concentration_ratio varchar(20) DEFAULT NULL,
  CHANGE procure_chuq_pellet procure_chuq_deprecated_pellet char(1) DEFAULT '';  
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_concentration_ratio' AND `language_label`='' AND `language_tag`='ratio' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_pellet' AND `language_label`='pellet' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_concentration_ratio' AND `language_label`='' AND `language_tag`='ratio' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_pellet' AND `language_label`='pellet' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_concentration_ratio' AND `language_label`='' AND `language_tag`='ratio' AND `type`='input' AND `setting`='size=6' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1') OR (
`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='procure_chuq_pellet' AND `language_label`='pellet' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6711' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;
