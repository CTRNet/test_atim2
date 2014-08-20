UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Order/Orders/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model = 'OrderItem');
UPDATE datamart_structure_functions fct SET fct.flag_active = 0 WHERE fct.label IN ('add to order');

UPDATE treatment_extend_controls SET type = 'other transplanted organ', databrowser_label = 'other transplanted organ' WHERE detail_tablename = 'chum_transplant_txe_transplants';

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("serum", "serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "", "1");

INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='blood_type' ), 'notEmpty');

-- 2014-08-20 ------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE participants ADD COLUMN chum_transplant_cause_of_death VARCHAR(250) DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN chum_transplant_cause_of_death VARCHAR(250) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chum_transplant_cause_of_death', 'input',  NULL , '0', '', '', '', 'cause of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_cause_of_death' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cause of death' AND `language_tag`=''), '3', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `setting`='size=40' WHERE model='Participant' AND tablename='participants' AND field='chum_transplant_cause_of_death' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='chum_transplant_cd_mains') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='revision_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) 
VALUES
('date/start date','Date','Date'),
('treatment', 'Transplant', 'Transplantation'),
('treatments', 'Transplants', 'Transplantations'),
('treatment precision', 'Transplant Precisions', 'Précisions de transplantations'),
('annotation', 'Biopsy', 'Biopsie');
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Study%';
UPDATE event_controls SET flag_active = 0 WHERE event_type != 'biopsy';
UPDATE menus SET language_title = 'details' WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/Clinical/%' AND language_description = 'clinical';

ALTER TABLE chum_transplant_txd_transplants 
  CHANGE serum_pre_transplant serum_pre_serum_bank CHAR(1) DEFAULT '',
  ADD COLUMN serum_pre_serum_bank_date DATE default null,
  ADD COLUMN serum_pre_data_bank CHAR(1) DEFAULT '';
ALTER TABLE chum_transplant_txd_transplants_revs 
  CHANGE serum_pre_transplant serum_pre_serum_bank CHAR(1) DEFAULT '',
  ADD COLUMN serum_pre_serum_bank_date DATE default null,
  ADD COLUMN serum_pre_data_bank CHAR(1) DEFAULT '';
UPDATE structure_fields SET field='serum_pre_serum_bank', `language_label`='serum pre serum bank ' WHERE model='TreatmentDetail' AND tablename='chum_transplant_txd_transplants' AND field='serum_pre_transplant';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'chum_transplant_txd_transplants', 'serum_pre_serum_bank_date', 'date',  NULL , '0', '', '', '', '', 'date'), 
('ClinicalAnnotation', 'TreatmentDetail', 'chum_transplant_txd_transplants', 'serum_pre_data_bank', 'yes_no',  NULL , '0', '', '', '', 'serum pre data bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='serum_pre_serum_bank_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='date'), '1', '16', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='serum_pre_data_bank' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='serum pre data bank' AND `language_tag`=''), '1', '17', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id, en, fr) VALUES 
('serum pre data bank', 'Serum Pre-Data Bank', 'Sérum pré-banque de donnnées'),
('serum pre serum bank ', 'Serum Pre-Serum Bank', 'Sérum pré-Sérothèque');

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('freezer',  'box', 'box100 1-100');

UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE versions SET branch_build_number = '5852' WHERE version_number = '2.6.3';
