
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
SELECT 'WARNING: Added new treatment field [reatment Combination] and deleted Follow-up Medical Treatment Types = [radiotherapy + hormonotherapy].' AS '### MESSAGE ###'
UNION ALL
SELECT 'TODO: Review all treatments flagged as [radiotherapy + hormonotherapy] (see list below - nothing to do if empty) then modify data.' AS '### MESSAGE ###';
SELECT p.participant_identifier, tm.start_date, treatment_type, CONCAT('ClinicalAnnotation/TreatmentMasters/detail/', p.id, '/', tm.id) AS url
FROM participants p 
INNER JOIN treatment_masters tm ON tm.participant_id = p.id
INNER JOIN procure_txd_followup_worksheet_treatments td ON td.treatment_master_id = tm.id
WHERE tm.deleted <> 1 AND td.treatment_type = 'radiotherapy + hormonotherapy';

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
('patient withdrawn', 'Patient Withdrawn', 'Patient retiré'),
('please check the patient withdrawn checkbox if required','Please check the patient withdrawn checkbox if required','Veuillez cocher le champ Patient Retiré si requis');

-- missing i18n

INSERT INTO i18n (id,en,fr) VALUES ('nanodrop', 'Nanodrop', 'Nanodrop');

-- quality control & RNA quantity

SELECT 'WARNING: Current RNA concentration and quantity (RNA tube fields already existing) will be considered as BioAnalyzer data. The script will add new fields for Nanodrop values (concentration, quantity).' AS '### MESSAGE ###';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('nanodrop','Nanodrop','Nanodrop');
ALTER TABLE ad_tubes
	ADD COLUMN procure_concentration_nanodrop decimal(10,2),
	ADD COLUMN procure_concentration_unit_nanodrop varchar(20),
	ADD COLUMN procure_total_quantity_ug_nanodrop decimal(8,2);
ALTER TABLE ad_tubes_revs
	ADD COLUMN procure_concentration_nanodrop decimal(10,2),
	ADD COLUMN procure_concentration_unit_nanodrop varchar(20),
	ADD COLUMN procure_total_quantity_ug_nanodrop decimal(8,2);
UPDATE aliquot_controls SET detail_form_alias = 'ad_der_tubes_incl_ul_vol,procure_rna_concentration_and_quantity' WHERE aliquot_type = 'tube' AND sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'rna') AND flag_active = 1;
UPDATE structures SET alias = 'procure_rna_concentration_and_quantity' WHERE alias = 'procure_total_quantity_ug';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot concentration' AND `language_tag`=''), '1', '75', 'bioanalyzer', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '76', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'procure_concentration_nanodrop', 'float_positive',  NULL , '0', 'size=5', '', '', 'aliquot concentration', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'procure_concentration_unit_nanodrop', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit') , '0', '', '', '', '', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'procure_total_quantity_ug_nanodrop', 'float_positive',  NULL , '0', 'size=6', '', '', 'total quantity ug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_concentration_nanodrop' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot concentration' AND `language_tag`=''), '1', '80', 'nanodrop', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_concentration_unit_nanodrop' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '81', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_total_quantity_ug_nanodrop' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='total quantity ug' AND `language_tag`=''), '1', '82', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='77' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_total_quantity_ug' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ( 'concentration unit has to be completed',  'Concentration unit has to be completed', 'Les unités de concentration doivent être définies');
UPDATE structure_fields SET  `language_help`='procure_total_quantity_ug_help' WHERE model='AliquotDetail' AND tablename='ad_tubes' AND field='procure_total_quantity_ug' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='procure_total_quantity_ug_help' WHERE model='AliquotDetail' AND tablename='ad_tubes' AND field='procure_total_quantity_ug_nanodrop' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_total_quantity_ug' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_rna_concentration_and_quantity') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_total_quantity_ug_nanodrop' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('procure_total_quantity_ug_help','Initial Quantity: Quantity based on the initial volume','Quantité initiale: Quantité définie selon le volume initiale');

-- Rebuild aliquot_masters form

UPDATE structure_formats SET `language_heading`='',`display_column`='0', `display_order`='1300' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='1180' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

-- Removed tube lot number

SELECT 'WARNING: Removed aliquot tube lot number' AS '### MESSAGE ###';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Remove cord blood and xenographt

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(203, 194, 193, 200);

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Nouveau champs
-- ------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE groups MODIFY deleted tinyint(3) unsigned NOT NULL DEFAULT '0';

-- Follow-up Methods

ALTER TABLE procure_ed_clinical_followup_worksheets ADD COLUMN method varchar(50) DEFAULT NULL;
ALTER TABLE procure_ed_clinical_followup_worksheets_revs ADD COLUMN method varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) VALUES ('procure_followup_clinical_methods', null);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ("visit", "visit"),("phone", "phone");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_clinical_methods"), 
(SELECT id FROM structure_permissible_values WHERE value="visit" AND language_alias="visit"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_clinical_methods"), 
(SELECT id FROM structure_permissible_values WHERE value="phone" AND language_alias="phone"), "", "1");
INSERT INTO i18n (id,en,fr) VALUES ('phone','Phone','Téléphone');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_methods') , '0', '', '', '', 'method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_methods')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Diagnosis & treatment report

UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_hormono' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_radio' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='25' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_psa_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='26' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_aps' AND `field`='total_ngml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='biopsy_pre_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_total_ng_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_free_ng_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_diagnostic_information_worksheets' AND `field`='aps_pre_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_pre_op_psa_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_aps' AND `field`='total_ngml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '28', 'prostatectomy', '', '1', 'date', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Change structure of follow-up

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='surgery_for_metastases' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='surgery_site' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Changed consent version to version nbr + language

ALTER TABLE consent_masters ADD COLUMN procure_language VARCHAR(40);
ALTER TABLE consent_masters_revs ADD COLUMN procure_language VARCHAR(40);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_language", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("english", "english");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_language"), (SELECT id FROM structure_permissible_values WHERE value="english" AND language_alias="english"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("french", "french");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_language"), (SELECT id FROM structure_permissible_values WHERE value="french" AND language_alias="french"), "2", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'procure_language', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_language') , '0', '', '', '', '', '-');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_language' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_language')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
REPLACE INTO i18n (id,en,fr) VALUES
('english','English','Anglais'),
('french','French','Français'); 
UPDATE consent_masters SET procure_language = form_version;
UPDATE consent_masters SET form_version = '';
UPDATE consent_masters_revs SET procure_language = form_version;
UPDATE consent_masters_revs SET form_version = '';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent Form Versions');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
SELECT procure_language AS '### MESSAGE ### Consent language not supported' FROM consent_masters WHERE procure_language IS NOT NULL AND procure_language NOT LIKE '' AND procure_language NOT IN ('english','french');

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Changed custom drop down list to system drop down list
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Changed procure_followup_clinical_recurrence_types [Procure followup clinical recurrence types] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup clinical recurrence types');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_clinical_recurrence_types");
SELECT value AS '### MESSAGE ### [Procure followup clinical recurrence types] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('local','distant','regional');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_followup_exam_types [Procure followup exam types] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup exam types');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_exam_types");
SELECT value AS '### MESSAGE ### [Procure followup exam types] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('CT-scan','MRI','PET-scan');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_followup_exam_results [Exam Results] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Exam Results');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_exam_results");
SELECT value AS '### MESSAGE ### [Exam Results] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('negative','positive','suspicious');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_questionnaire_delivery_site_and_method [questionnaire delivery site and method] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire delivery site and method');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_questionnaire_delivery_site_and_method");
SELECT value AS '### MESSAGE ### [questionnaire delivery site and method] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('during hospitalisation','e-mail','mail','pre-op clinic','urologist office');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_method_to_complete_questionnaire [method to complete questionnaire] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'method to complete questionnaire');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_method_to_complete_questionnaire");
SELECT value AS '### MESSAGE ### [method to complete questionnaire] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('alone','at home','in the hospital','online','phone','with a family member','with the biobank personnel');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_questionnaire_recovery_method [questionnaire recovery method] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire recovery method');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_questionnaire_recovery_method");
SELECT value AS '### MESSAGE ### [questionnaire recovery method] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('directly','e-mail','internal mail','mail');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_questionnaire_revision_method [questionnaire revision method] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire revision method');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_questionnaire_revision_method");
SELECT value AS '### MESSAGE ### [questionnaire revision method] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('phone','with the participant','directly','e-mail');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_questionnaire_version [questionnaire version] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire version');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_questionnaire_version");
SELECT value AS '### MESSAGE ### [questionnaire version] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('english','french');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_other_tumor_treatment_types [Other Tumor Treatment Types] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Tumor Treatment Types');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_other_tumor_treatment_types");
SELECT value AS '### MESSAGE ### [Other Tumor Treatment Types] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('chemotherapy','radiotherapy');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("experimental treatment", "experimental treatment");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="procure_other_tumor_treatment_types"), 
(SELECT id FROM structure_permissible_values WHERE value="surgery" AND language_alias="surgery"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_other_tumor_treatment_types"), 
(SELECT id FROM structure_permissible_values WHERE value="experimental treatment" AND language_alias="experimental treatment"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_other_tumor_treatment_types"), 
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "", "1");

-- Changed procure_other_tumor_sites [Other Tumor Sites] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Tumor Sites');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_other_tumor_sites");
SELECT value AS '### MESSAGE ### [Other Tumor Sites] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT LIKE '% - %';
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_blood_collection_sites [Blood collection sites] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood collection sites');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_blood_collection_sites");
SELECT value AS '### MESSAGE ### [Blood collection sites] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('after anesthesia','before anestesia','clinic','operating room');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_block_classification [Procure block classifications] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure block classifications');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_block_classification");
SELECT value AS '### MESSAGE ### [Procure block classifications] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('C','NC','NC+C','ND');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_prostatectomy_types [Procure prostatectomy types] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure prostatectomy types');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_prostatectomy_types");
SELECT value AS '### MESSAGE ### [Procure prostatectomy types] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('laparoscopy','open surgery','robot');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_prostatectomy_types [Procure slice origins] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure slice origins');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_prostatectomy_types");
SELECT value AS '### MESSAGE ### [Procure slice origins] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('LA','LP','RA','RP');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_chemotherapy_line [Chemotherapy Lines] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Chemotherapy Lines');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_chemotherapy_line");
SELECT value AS '### MESSAGE ### [Chemotherapy Lines] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('1','2','3','4');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Changed procure_followup_treatment_types [Procure followup medical treatment types] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure followup medical treatment types');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types");
SELECT value AS '### MESSAGE ### [Procure followup medical treatment types] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('antalgic radiotherapy','chemotherapy','experimental treatment','hormonotherapy','other treatment','prostatectomy','radiotherapy');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types"), (SELECT id FROM structure_permissible_values WHERE value="brachytherapy" AND language_alias="brachytherapy"), "", "1");
REPLACE INTO i18n (id,en,fr)
VALUES
("antalgic radiotherapy",'Antalgic Radiotherapy','Radiothérapie antalgique'),
("experimental treatment",'Experimental Treatment','Traitement expérimental'),
("other treatment",'Other Treatment','Autre traitement');
UPDATE procure_txd_followup_worksheet_treatments SET treatment_type = 'brachytherapy', radiotherpay_precision = '' WHERE radiotherpay_precision = 'brachy';
UPDATE procure_txd_followup_worksheet_treatments_revs SET treatment_type = 'brachytherapy', radiotherpay_precision = '' WHERE radiotherpay_precision = 'brachy';
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("aborted prostatectomy", "aborted prostatectomy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_followup_treatment_types"), (SELECT id FROM structure_permissible_values WHERE value="aborted prostatectomy" AND language_alias="aborted prostatectomy"), "", "1");
INSERT INTO i18n (id,en,fr) VALUES ("aborted prostatectomy", "Aborted Prostatectomy", 'Prostatectomie abandonnée');

-- Changed procure_radiotherpay_precision [Radiotherapy Precisions] custom list to system list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Precisions');
SET @domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_radiotherpay_precision");
SELECT value AS '### MESSAGE ### [Radiotherapy Precisions] values not in PROCURE list: to manage' FROM structure_permissible_values_customs WHERE control_id = @control_id AND value NOT IN ('adjuvant','brachy','curative','palliative','salvage');
UPDATE structure_value_domains SET `override`="open", `source`="" WHERE id = @domain_id;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
(SELECT value,value FROM structure_permissible_values_customs WHERE control_id = @control_id);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
(SELECT @domain_id, spv.id, "", "1" FROM structure_permissible_values spv INNER JOIN structure_permissible_values_customs spvc ON spv.value = spvc.value AND spv.language_alias = spvc.value WHERE spvc.control_id = @control_id);
INSERT IGNORE INTO i18n (id,en,fr)
(SELECT value,en,fr FROM structure_permissible_values_customs WHERE control_id = @control_id);
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;
REPLACE INTO i18n (id,en,fr)
VALUES
("salvage",'Salvage','Thérapie de sauvetage');
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="procure_radiotherpay_precision" AND spv.value="brachy" AND spv.language_alias="brachy";
DELETE FROM structure_permissible_values WHERE value="brachy" AND language_alias="brachy" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Field Update
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- Change radio precision field to treatment precision field

UPDATE structure_fields SET field = 'treatment_precision', language_help = '' WHERE field = 'radiotherpay_precision' AND tablename = 'procure_txd_followup_worksheet_treatments';
ALTER TABLE procure_txd_followup_worksheet_treatments CHANGE COLUMN radiotherpay_precision treatment_precision varchar(50) default null;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs CHANGE COLUMN radiotherpay_precision treatment_precision varchar(50) default null;
DELETE FROM i18n WHERE id = 'procure_help_radiotherpay_precision_help';
UPDATE structure_value_domains SET domain_name = 'procure_treatment_precision' WHERE domain_name = 'procure_radiotherpay_precision';

-- Move field of treatment form

UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='chemotherapy_line' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chemotherapy_line') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_combination' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_combination') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_precision') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_site') AND `flag_confidential`='0');

-- Treatment Combination 

UPDATE procure_txd_followup_worksheet_treatments SET treatment_combination = 'y' WHERE treatment_combination IS NOT NULL AND treatment_combination NOt LIKE '';
UPDATE procure_txd_followup_worksheet_treatments_revs SET treatment_combination = 'y' WHERE treatment_combination IS NOT NULL AND treatment_combination NOt LIKE '';
ALTER TABLE procure_txd_followup_worksheet_treatments MODIFY treatment_combination char(1) DEFAULT '';
ALTER TABLE procure_txd_followup_worksheet_treatments_revs MODIFY treatment_combination char(1) DEFAULT '';
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='TreatmentDetail' AND tablename='procure_txd_followup_worksheet_treatments' AND field='treatment_combination' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_combination');
DELETE FROM structure_value_domains WHERE domain_name="procure_treatment_combination";
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Combinations');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE id = @control_id;

-- Inactivate unused custom list

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name IN ('SOP Versions','Xenograft Implantation Sites','Xenograft Species');
SELECT name '### MESSAGE ### Check following custom lists are used and inactivate if not used' FROM structure_permissible_values_custom_controls WHERE flag_active = 1 AND name NOT IN ('Consent Form Versions','Exam Sites','Aliquot Use and Event Types','Questionnaire version date','Storage Types','Storage Coordinate Titles','Treatment site');

-- Add experimental drug

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type"), (SELECT id FROM structure_permissible_values WHERE value="experimental treatment" AND language_alias="experimental treatment"), "", "1");
REPLACE INTO i18n (id,en,fr)
VALUES 
('procure_help_treatment_drug', 'Experimental Treatment/Chemotherapy/Radiotherapy drug', 'Molécule ou médicament de chimiothérapie/radiothérapie/traitement expérimental');

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Data Integrity Controls (based on custom hook and custom model)
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- *** 1 - Clinical Annotation ***

-- Particiants

SELECT participant_identifier AS '### MESSAGE ### Wrong participant_identifier format to correct', id AS participant_id FROM participants WHERE deleted <> 1 AND participant_identifier NOT REGEXP'^PS[1-9]P0[0-9]+$';
SELECT id AS '### MESSAGE ### participant_id with withdrawn date or withdrawn reason but not flagged as withdrawn: To flag' 
FROM participants WHERE deleted <> 1 
AND ((procure_patient_withdrawn_date IS NOT NULL AND procure_patient_withdrawn_date NOT LIKE '') OR (procure_patient_withdrawn_reason IS NOT NULL AND procure_patient_withdrawn_reason NOT LIKE ''))
AND procure_patient_withdrawn <> 1;

-- Consent 

SELECT procure_form_identification AS '### MESSAGE ### Duplicated procure_form_identification to correct' FROM (SELECT count(*) as nbr, procure_form_identification FROM consent_masters WHERE deleted <> 1 GROUP BY procure_form_identification) res WHERE res.nbr > 1;
SELECT procure_form_identification AS '### MESSAGE ### Wrong consent_masters.procure_form_identification format to correct',participant_id, id AS consent_master_id FROM consent_masters WHERE deleted <> 1 AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -CSF[0-9]+$' OR procure_form_identification IS NULL;

-- EventMaster

SELECT procure_form_identification AS '### MESSAGE ### Duplicated procure_form_identification to correct' FROM (
	SELECT count(*) as nbr, EventMaster.procure_form_identification FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id WHERE deleted <> 1 AND EventControl.event_type NOT IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event') GROUP BY EventMaster.procure_form_identification
) res WHERE res.nbr > 1;

SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure pathology report'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -PST[0-9]+$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure diagnostic information worksheet'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -FBP[0-9]+$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure questionnaire administration worksheet'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -QUE[0-9]+$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure follow-up worksheet'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -FSP[0-9]+$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event')
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ Vx -FSPx$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Follow-up Worksheet with no date to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet') AND (EventMaster.event_date IS NULL OR EventMaster.event_date LIKE '');

-- TreatmentMaster

SELECT procure_form_identification AS '### MESSAGE ### Duplicated procure_form_identification to correct' FROM (
	SELECT count(*) as nbr, TreatmentMaster.procure_form_identification FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id WHERE deleted <> 1 AND TreatmentControl.tx_method NOT IN ('procure follow-up worksheet - treatment','procure medication worksheet - drug','other tumor treatment') GROUP BY TreatmentMaster.procure_form_identification
) res WHERE res.nbr > 1;

SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet - drug'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ Vx -MEDx$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ Vx -FSPx$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -MED[0-9]+$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'other tumor treatment'
AND procure_form_identification NOT REGEXP'^PS[0-9]P0[0-9]+ Vx -FSPx$' OR procure_form_identification IS NULL;

SELECT procure_form_identification AS '### MESSAGE ### Medication Worksheet with no date to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet' AND (TreatmentMaster.start_date IS NULL OR TreatmentMaster.start_date LIKE '');

SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type and drug type mismatch. Please confirm and correct', TreatmentDetail.treatment_type, Drug.type, Drug.generic_name
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
INNER JOIN drugs Drug ON TreatmentDetail.drug_id = Drug.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type != Drug.type;

SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type different than radiotherapy but site information set. Please confirm and correct', TreatmentDetail.treatment_type, TreatmentDetail.treatment_site
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type NOT IN ('radiotherapy','antalgic radiotherapy','brachytherapy') AND TreatmentDetail.treatment_site IS NOT NULL AND TreatmentDetail.treatment_site NOT LIKE '';

SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type like prostatectomy and precision information set. Please confirm and correct', TreatmentDetail.treatment_type, TreatmentDetail.treatment_precision
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE '%prostatectomy%' AND TreatmentDetail.treatment_precision IS NOT NULL AND TreatmentDetail.treatment_precision NOT LIKE '';

SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type different than chemotherapy but line information set. Please confirm and correct', TreatmentDetail.treatment_type, TreatmentDetail.chemotherapy_line
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type NOT LIKE '%chemotherapy%' AND TreatmentDetail.chemotherapy_line IS NOT NULL AND TreatmentDetail.chemotherapy_line NOT LIKE '';

-- *** 2 - Inventory ***

SELECT '### MESSAGE ### Blood type undefined', collection_id, sample_master_id
FROM sample_masters SampleMaster
INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
INNER JOIN sd_spe_bloods SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
WHERE SampleMaster.deleted <> 1 AND SampleControl.sample_type = 'blood'  AND (blood_type = '' OR blood_type IS NULL);

SELECT barcode AS '### MESSAGE ### List of block with wrong [type] and [freezing method] link. To correct.', block_type, procure_freezing_type
FROM aliquot_masters
INNER JOIN ad_blocks ON id = aliquot_master_id
WHERE deleted <> 1 AND ((block_type = 'frozen' AND procure_freezing_type NOT IN ('ISO', 'ISO+OCT', '')) OR (block_type = 'paraffin' AND procure_freezing_type != ''));

SELECT count(*) AS '### MESSAGE ### List of blocks with storage date time. To remove storage date.' 
FROM aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl 
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL;		
				
SELECT barcode AS '### MESSAGE ### List of aliquots with missing concentration unit.'
FROM aliquot_masters
INNER JOIN ad_tubes ON id = aliquot_master_id
WHERE deleted <> 1 AND concentration NOT LIKE '' AND concentration IS NOT NULL AND (concentration_unit IS NULL OR concentration_unit LIKE '');

SELECT count(*) AS '### MESSAGE ### Number of blood tubes defined as in stock. To correct if required.', blood_type
FROM sample_masters SampleMaster
INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
INNER JOIN sd_spe_bloods SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
WHERE AliquotMaster.deleted <> 1 AND SampleControl.sample_type = 'blood' AND AliquotControl.aliquot_type = 'tube'
AND blood_type != 'paxgene' AND in_stock != 'no'
GROUP BY blood_type;

-- *** 3 - Inventory Update ***

SELECT count(*) AS '### MESSAGE ### Number of procure_total_quantity_ug values updated. To validate (revs data not updated).', concentration_unit
FROM aliquot_masters, ad_tubes
WHERE deleted <> 1 AND id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND initial_volume NOT LIKE '' AND initial_volume IS NOT NULL 
AND concentration_unit IN ('ug/ul', 'ng/ul', 'pg/ul') GROUP BY concentration_unit;

UPDATE aliquot_masters, ad_tubes
SET procure_total_quantity_ug = (initial_volume*concentration/1000000)
WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND initial_volume NOT LIKE '' AND initial_volume IS NOT NULL 
AND concentration_unit = 'pg/ul';

UPDATE aliquot_masters, ad_tubes
SET procure_total_quantity_ug = (initial_volume*concentration/1000)
WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND initial_volume NOT LIKE '' AND initial_volume IS NOT NULL 
AND concentration_unit = 'ng/ul';

UPDATE aliquot_masters, ad_tubes
SET procure_total_quantity_ug = (initial_volume*concentration)
WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND initial_volume NOT LIKE '' AND initial_volume IS NOT NULL 
AND concentration_unit = 'ug/ul';

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- New Changes
-- ------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET name = 'Clinical Exam Sites' WHERE  name = 'Exam Sites';
UPDATE structure_permissible_values_custom_controls SET name = 'Radiotherapy Sites' WHERE  name = 'Treatment site';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Clinical Exam Sites\')" WHERE  source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Exam Sites\')";
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Radiotherapy Sites\')" WHERE  source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment site\')";

-- Other Diagnosis & Clinical Notes

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'clinical', 'procure follow-up worksheet - clinical note', 1, 'procure_ed_followup_worksheet_clinical_notes', 'procure_ed_followup_worksheet_clinical_notes', 0, 'procure follow-up worksheet - clinical note', 1, 1, 1),
(null, '', 'clinical', 'procure follow-up worksheet - other tumor dx', 1, 'procure_ed_followup_worksheet_other_tumor_diagnosis', 'procure_ed_followup_worksheet_other_tumor_diagnosis', 0, 'procure follow-up worksheet - other tumor dx', 1, 1, 1);
INSERT INTO structures(`alias`) VALUES ('procure_ed_followup_worksheet_other_tumor_diagnosis');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_followup_worksheet_other_tumor_diagnosis', 'tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_sites') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_other_tumor_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_other_tumor_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '70', 'comments', '0', '1', 'details', '0', '', '0', '', '0', '', '1', 'rows=3,cols=30', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_other_tumor_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_followup_worksheet_other_tumor_diagnosis' AND `field`='tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '40', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_other_tumor_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_followup_worksheet_other_tumor_diagnosis' AND `field`='tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_other_tumor_sites') AND `flag_confidential`='0');
UPDATE structure_fields SET language_label = 'tumor site' WHERE field = 'tumor_site' AND tablename = 'procure_ed_followup_worksheet_other_tumor_diagnosis';
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `tablename`='procure_ed_followup_worksheet_other_tumor_diagnosis' AND `field`='tumor_site'), 'notEmpty');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_other_tumor_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
CREATE TABLE IF NOT EXISTS `procure_ed_followup_worksheet_other_tumor_diagnosis` (
  `event_master_id` int(11) NOT NULL,
  `tumor_site` varchar(100) DEFAULT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `procure_ed_followup_worksheet_other_tumor_diagnosis_revs` (
  `event_master_id` int(11) NOT NULL,
  `tumor_site` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;
ALTER TABLE `procure_ed_followup_worksheet_other_tumor_diagnosis`
  ADD CONSTRAINT `procure_ed_followup_worksheet_other_tumor_diagnosis_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('procure_ed_followup_worksheet_clinical_notes');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_notes'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_notes'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '70', '', '0', '1', 'note', '0', '', '0', '', '0', '', '1', 'rows=3,cols=30', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
CREATE TABLE IF NOT EXISTS `procure_ed_followup_worksheet_clinical_notes` (
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `procure_ed_followup_worksheet_clinical_notes_revs` (
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;
ALTER TABLE `procure_ed_followup_worksheet_clinical_notes`
  ADD CONSTRAINT `procure_ed_followup_worksheet_clinical_notes_ibfk_2` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO i18n (id,en,fr)
VALUES 
('procure follow-up worksheet - other tumor dx','F1 - Follow-up Worksheet :: Other Tumor Diagnosis','F1 - Fiche de suivi du patient :: Autre diagnostic de tumeur'),
('procure follow-up worksheet - clinical note','F1 - Follow-up Worksheet :: Clinical Note','F1 - Fiche de suivi du patient :: Note clinique');

-- Rename other treatment tumor

SELECT 'Changed Other Tumor Treatment tablename, etc' AS '### MESSAGE ###';
UPDATE treatment_controls 
SET detail_tablename = 'procure_txd_followup_worksheet_other_tumor_treatments', detail_form_alias = 'procure_txd_followup_worksheet_other_tumor_treatments',
tx_method = 'procure follow-up worksheet - other tumor tx', databrowser_label = 'procure follow-up worksheet - other tumor tx'
WHERE detail_tablename = 'procure_txd_other_tumor_treatments';
INSERT INTO i18n (id,en,fr)
VALUES 
('procure follow-up worksheet - other tumor tx','F1 - Follow-up Worksheet :: Other Tumor Treatment','F1 - Fiche de suivi du patient :: Traitement autre tumeur');
UPDATE structures SET `alias` = 'procure_txd_followup_worksheet_other_tumor_treatments' WHERE `alias` = 'procure_txd_other_tumor_treatment';
UPDATE structure_fields SET `tablename` = 'procure_txd_followup_worksheet_other_tumor_treatments' WHERE `tablename` = 'procure_txd_other_tumor_treatments';
RENAME TABLE procure_txd_other_tumor_treatments TO procure_txd_followup_worksheet_other_tumor_treatments;
RENAME TABLE procure_txd_other_tumor_treatments_revs TO procure_txd_followup_worksheet_other_tumor_treatments_revs;

-- Unset flag_use_for_ccl

UPDATE event_controls SET flag_use_for_ccl = 0 WHERE flag_active = 1;
UPDATE treatment_controls SET flag_use_for_ccl = 0 WHERE flag_active = 1;

-- Rebuild follow-up detal form

INSERT INTO i18n (id,en,fr) 
VALUES 
("clincial data from %start% to %end%", "Clinical data from %start% to %end%", 'Données cliniques du %start% au %end%'),
("clincial data after %start%", "Clinical data after %start%", 'Données cliniques après le %start%'),
("clincial data before %end%", "Clinical data before %end%", 'Données cliniques avant le %end%'),
("unable to limit clincial data to a dates interval", "Unable to limit clinical data to a dates interval", "Impossible de limiter les données cliniques à un intervalle de dates");
INSERT INTO i18n (id,en,fr) 
VALUES 
('prostate diagnosis - clinical data', 'Prostate - Clinical Data', 'Prostate - Données cliniques'),
('other diagnoses - clinical data', 'Other Diagnoses - Clinical Data', 'Autres diagnostics - Données cliniques'),
('clinical notes', 'Clinical Notes', 'Notes cliniques');


INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('other tumor - diagnosis', 'Other Tumor - Diagnosis', 'Autre cancer - Diagnostic'),
('other tumor - treatment', 'Other Tumor - Treatment', 'Autre cancer - Traitement');

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='chronology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Version
-- ------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6137' WHERE version_number = '2.6.4';
