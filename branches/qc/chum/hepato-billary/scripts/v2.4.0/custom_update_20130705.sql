-- --------------------------------------------------------------------------------------------------------------
-- scan et IRM abdo ajouter :
--   - diameter : [mesure 1] [mesure2] [mesure3] 
--   - diameter 2 : [mesure 1] [mesure2] [mesure3] 
--   - diameter 3 : [mesure 1] [mesure2] [mesure3] 
--   - radiologic TACE response : [menu déroulant]
-- --------------------------------------------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
  ADD COLUMN diameter_first_measure_mm decimal(6, 2) DEFAULT NULL AFTER type,
  ADD COLUMN diameter_second_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter_first_measure_mm,
  ADD COLUMN diameter_third_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter_second_measure_mm,
  ADD COLUMN diameter2_first_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter_third_measure_mm,
  ADD COLUMN diameter2_second_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter2_first_measure_mm,
  ADD COLUMN diameter2_third_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter2_second_measure_mm,
  ADD COLUMN diameter3_first_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter2_third_measure_mm,
  ADD COLUMN diameter3_second_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter3_first_measure_mm,
  ADD COLUMN diameter3_third_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter3_second_measure_mm,
  ADD COLUMN radiologic_tace_response varchar(50) DEFAULT NULL AFTER diameter3_third_measure_mm;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
  ADD COLUMN diameter_first_measure_mm decimal(6, 2) DEFAULT NULL AFTER type,
  ADD COLUMN diameter_second_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter_first_measure_mm,
  ADD COLUMN diameter_third_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter_second_measure_mm,
  ADD COLUMN diameter2_first_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter_third_measure_mm,
  ADD COLUMN diameter2_second_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter2_first_measure_mm,
  ADD COLUMN diameter2_third_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter2_second_measure_mm,
  ADD COLUMN diameter3_first_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter2_third_measure_mm,
  ADD COLUMN diameter3_second_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter3_first_measure_mm,
  ADD COLUMN diameter3_third_measure_mm decimal(6, 2) DEFAULT NULL AFTER diameter3_second_measure_mm,
  ADD COLUMN radiologic_tace_response varchar(50) DEFAULT NULL AFTER diameter3_third_measure_mm;

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_ed_radiologic_tace_response', "StructurePermissibleValuesCustom::getCustomDropdown('medical imagings : radiologic TACE response')");
INSERT INTO structure_permissible_values_custom_controls (name, values_max_length, flag_active)
VALUES 
('medical imagings : radiologic TACE response', '50', 1);
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter_first_measure_mm', 'diameter (mm)', '1st measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter_second_measure_mm', '', '2nd measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter_third_measure_mm', '', '3rd measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter2_first_measure_mm', 'diameter 2 (mm)', '1st measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter2_second_measure_mm', '', '2nd measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter2_third_measure_mm', '', '3rd measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter3_first_measure_mm', 'diameter 3 (mm)', '1st measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter3_second_measure_mm', '', '2nd measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'diameter3_third_measure_mm', '', '3rd measure', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'radiologic_tace_response', 'radiologic tace response', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_ed_radiologic_tace_response'), '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter_first_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '222', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter_second_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '223', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter_third_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '224', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter2_first_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '225', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter2_second_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '226', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter2_third_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '227', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter3_first_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '228', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter3_second_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '229', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'diameter3_third_measure_mm' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '230', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'radiologic_tace_response' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '231', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en) 
VALUES
('diameter (mm)', 'Diameter (mm)'), 	
('1st measure', '1st Measure'),
('2nd measure', '2nd Measure'),
('3rd measure', '3rd Measure'), 
('diameter 2 (mm)','Diameter 2 (mm)'),
('diameter 3 (mm)','Diameter 3 (mm)'),
('radiologic tace response', 'Radiologic TACE Response');

-- --------------------------------------------------------------------------------------------------------------
-- TACE complications 
--   - date : [Date]
--   - type (à la place de Toxicity) : [menu déroulant]
--   - treatment : [menu déroulant]
-- --------------------------------------------------------------------------------------------------------------

ALTER TABLE txd_chemos
	CHANGE qc_hb_toxicity qc_hb_toxicity_complication varchar(50) NOT NULL DEFAULT '';
ALTER TABLE txd_chemos_revs
	CHANGE qc_hb_toxicity qc_hb_toxicity_complication varchar(50) NOT NULL DEFAULT '';
UPDATE structure_fields SET field = 'qc_hb_toxicity_complication' WHERE field = 'qc_hb_toxicity';
UPDATE structure_formats
SET flag_override_label = '1', language_label = 'complication type'
WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations')
AND structure_field_id = (SELECT id FROM structure_fields WHERE field = 'qc_hb_toxicity_complication' AND model = 'TreatmentDetail');
INSERT IGNORE INTO i18n (id,en) 
VALUES
('complication type', 'Complication Type'), ('chemo-embolization','Chemo-Embolization');
	
ALTER TABLE txd_chemos
	ADD COLUMN qc_hb_toxicity_complication_date DATE DEFAULT NULL AFTER qc_hb_toxicity_complication,
	ADD COLUMN qc_hb_tace_complication_treatment VARCHAR(150) DEFAULT NULL AFTER qc_hb_toxicity_complication_date;	
ALTER TABLE txd_chemos_revs
	ADD COLUMN qc_hb_toxicity_complication_date DATE DEFAULT NULL AFTER qc_hb_toxicity_complication,
	ADD COLUMN qc_hb_tace_complication_treatment VARCHAR(150) DEFAULT NULL AFTER qc_hb_toxicity_complication_date;	
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_txd_tace_complications_treatment', "StructurePermissibleValuesCustom::getCustomDropdown('TACE : complication treatment')");
INSERT INTO structure_permissible_values_custom_controls (name, values_max_length, flag_active)
VALUES 
('TACE : complication treatment', '100', 1);
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'qc_hb_toxicity_complication_date', 'complication date', '', 'date', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'qc_hb_tace_complication_treatment', 'complication treatment', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_txd_tace_complications_treatment'), '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), (SELECT id FROM structure_fields WHERE field = 'qc_hb_toxicity_complication_date' AND tablename = 'txd_chemos'), 
'1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), (SELECT id FROM structure_fields WHERE field = 'qc_hb_tace_complication_treatment' AND tablename = 'txd_chemos'), 
'1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('complication date','Complication Date'),('complication treatment','Complication Treatment');
ALTER TABLE txd_chemos
	ADD COLUMN qc_hb_toxicity_complication_date_accuracy  char(1) NOT NULL DEFAULT '' AFTER qc_hb_toxicity_complication_date;
ALTER TABLE txd_chemos_revs
	ADD COLUMN qc_hb_toxicity_complication_date_accuracy  char(1) NOT NULL DEFAULT '' AFTER qc_hb_toxicity_complication_date;

-- --------------------------------------------------------------------------------------------------------------
-- surgery-pancreas :
--    - champs ARTERIAL RESECTION  et une liste avec YES/NO/NS  soit ajoutée au surgery-pancreas sous  PORTAL VEIN RESECTION 
-- --------------------------------------------------------------------------------------------------------------

ALTER TABLE qc_hb_txd_surgery_pancreas
   ADD COLUMN arterial_resection VARCHAR(3) NOT NULL DEFAULT '' AFTER portal_vein_resection;
ALTER TABLE qc_hb_txd_surgery_pancreas_revs
   ADD COLUMN arterial_resection VARCHAR(3) NOT NULL DEFAULT '' AFTER portal_vein_resection;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'TreatmentDetail', 'qc_hb_txd_surgery_pancreas', 'arterial_resection', 'arterial resection', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'yes_no_ns'), '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), (SELECT id FROM structure_fields WHERE field = 'arterial_resection' AND model = 'TreatmentDetail'), 
'2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en) 
VALUES
('arterial resection','Arterial Resection');
