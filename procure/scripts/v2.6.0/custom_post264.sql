
-- Add treatment in batch / listall in index view

UPDATE treatment_controls SET use_addgrid = '1' WHERE tx_method IN ('procure medication worksheet - drug', 'procure follow-up worksheet - treatment', 'other tumor treatment');
UPDATE treatment_controls SET use_detail_form_for_index = '1' WHERE flag_active = 1;

-- Disable function to launch 'elements number per participant' report from diagnosis

UPDATE datamart_structure_functions SET flag_active = '0' WHERE label = 'elements number per participant' AND datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');

-- Add help on treatment fields

UPDATE structure_fields SET `language_help`='procure_help_treatment_drug' WHERE model='TreatmentDetail' AND tablename='procure_txd_followup_worksheet_treatments' AND field='drug_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_drug_list');
UPDATE structure_fields SET `language_help`='procure_help_treatment_site' WHERE model='TreatmentDetail' AND tablename='procure_txd_followup_worksheet_treatments' AND field='treatment_site' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_site');
UPDATE structure_fields SET `language_help`='procure_help_radiotherpay_precision_help' WHERE model='TreatmentDetail' AND tablename='procure_txd_followup_worksheet_treatments' AND field='radiotherpay_precision' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_radiotherpay_precision');
INSERT INTO i18n (id,en,fr)
VALUES 
('procure_help_treatment_drug', 'Chemotherapy/Radiotherapy drug', 'Molécule ou médicament de chimiothérapie/radiothérapie'),
('procure_help_treatment_site', 'Radiotherapy site', 'Site de radiothérapie'),
('procure_help_radiotherpay_precision_help', 'Radiotherapy precision', 'Précision de radiothérapie');

-- Add new fields to treatment form: Treatment Combination + chemotherapy line 

UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='radiotherpay_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_radiotherpay_precision') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='drug_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_drug_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='dosage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure followup medical treatment types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value = 'radiotherapy + hormonotherapy';
SELECT 'Deleted Follow-up Medical Treatment Types = [radiotherapy + hormonotherapy]. Please review existing treatment' AS 'TODO';

ALTER TABLE procure_txd_followup_worksheet_treatments
  ADD COLUMN treatment_combination varchar(50) default null,
  ADD COLUMN chemotherapy_line varchar(3) default null;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs
  ADD COLUMN treatment_combination varchar(50) default null,
  ADD COLUMN chemotherapy_line varchar(3) default null; 
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_treatment_combination", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Combinations\')"),
("procure_chemotherapy_line", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Chemotherapy Lines\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Treatment Combinations', 1, 50, 'clinical - treatment'),
('Chemotherapy Lines', 1, 3, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Combinations');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('chemotherapy + radiotherapy' ,'Chemotherapy + Radiotherapy', 'Chimiothérapie + Radiothérapie', '1', @control_id),
('hormonotherapy + radiotherapy' ,'Hormonotherapy + Radiotherapy', 'Hormonothérapie + Radiothérapie', '1', @control_id);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Chemotherapy Lines');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('1' ,'', '', '1', @control_id),
('2' ,'', '', '1', @control_id),
('3' ,'', '', '1', @control_id),
('4' ,'', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'procure_txd_followup_worksheet_treatments', 'treatment_combination', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_combination') , '0', '', '', '', 'treatment combination', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'procure_txd_followup_worksheet_treatments', 'chemotherapy_line', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_chemotherapy_line') , '0', '', '', 'procure_help_chemotherapy_line', 'line', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_combination' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_combination')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment combination' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='chemotherapy_line' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chemotherapy_line')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='procure_help_chemotherapy_line' AND `language_label`='line' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr)
VALUES
('treatment combination','Treatments Combination','Combinaison de traitements'),
('procure_help_chemotherapy_line','Chemotherapy Line','Ligne de chimiothérapie');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_combination' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_combination') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='chemotherapy_line' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chemotherapy_line') AND `flag_confidential`='0');
UPDATE structure_fields SET  `model`='TreatmentDetail' WHERE model='TreatmentMaster' AND tablename='procure_txd_followup_worksheet_treatments';
INSERT INTO i18n (id,en,fr)
VALUES
('the selected combination can not be associated to the selected treatment type', 'The selected combination can not be associated to the selected treatment type' ,'La combinaison sélectionnée ne peut pas être définie pour le type du traitement sélectionné'),
('no line has to be associated to the selected treatment type', 'No line has to be associated to the selected treatment type','Aucun ligne ne doit être définie pour le type du traitement sélectionné');

-- Added 'Refusing Treatments' field

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'refusing_treatments', 'yes_no', (SELECT id FROM structure_value_domains WHERE domain_name='procure_chemotherapy_line') , '0', '', '', '', 'refusing treatments', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='refusing_treatments' AND `type`='yes_no' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chemotherapy_line')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='refusing treatments' AND `language_tag`=''), '2', '40', 'other', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE procure_ed_clinical_followup_worksheets ADD COLUMN refusing_treatments CHAR(1) DEFAULT '';
ALTER TABLE procure_ed_clinical_followup_worksheets_revs ADD COLUMN refusing_treatments CHAR(1) DEFAULT '';
INSERT INTO i18n (id,en,fr)
VALUES ('refusing treatments', 'Refusing Treatments', 'Refus des traitements');
UPDATE structure_fields SET  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='procure_ed_clinical_followup_worksheets' AND field='refusing_treatments' AND `type`='yes_no' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chemotherapy_line');

-- Withdrawn information

ALTER TABLE participants 
  ADD COLUMN procure_patient_withdrawn tinyint(1) DEFAULT '0',
  ADD COLUMN procure_patient_withdrawn_date date DEFAULT NULL,
  ADD COLUMN procure_patient_withdrawn_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN procure_patient_withdrawn_reason text;
ALTER TABLE participants_revs
  ADD COLUMN procure_patient_withdrawn tinyint(1) DEFAULT '0',
  ADD COLUMN procure_patient_withdrawn_date date DEFAULT NULL,
  ADD COLUMN procure_patient_withdrawn_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN procure_patient_withdrawn_reason text; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_patient_withdrawn', 'checkbox',  NULL , '0', '', '', '', 'withdrawn', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'procure_patient_withdrawn_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'procure_patient_withdrawn_reason', 'input',  NULL , '0', 'rows=2,cols=30', '', '', 'details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_patient_withdrawn' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='withdrawn' AND `language_tag`=''), '3', '40', 'patient withdrawn', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_patient_withdrawn_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '3', '41', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_patient_withdrawn_reason' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='details' AND `language_tag`=''), '3', '42', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient withdrawn', 'Patient Withdrawn', 'patient retiré'),
('please check the patient withdrawn checkbox if required','Please check the patient withdrawn checkbox if required','Veuillez cocher le champ Patient Retiré si requis');

-- missing i18n

INSERT INTO i18n (id,en,fr) VALUES ('nanodrop', 'Nanodrop', 'Nanodrop');











-- version

UPDATE versions SET branch_build_number = '5981' WHERE version_number = '2.6.4';
