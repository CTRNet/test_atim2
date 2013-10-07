ALTER TABLE qc_hb_txd_surgery_livers 
  ADD COLUMN cell_saver CHAR(1) DEFAULT '', 
  ADD COLUMN cell_saver_volume_ml decimal(6, 2) DEFAULT NULL;
ALTER TABLE qc_hb_txd_surgery_livers_revs
  ADD COLUMN cell_saver CHAR(1) DEFAULT '', 
  ADD COLUMN cell_saver_volume_ml decimal(6, 2) DEFAULT NULL;
ALTER TABLE qc_hb_txd_surgery_pancreas 
  ADD COLUMN cell_saver CHAR(1) DEFAULT '', 
  ADD COLUMN cell_saver_volume_ml decimal(6, 2) DEFAULT NULL;
ALTER TABLE qc_hb_txd_surgery_pancreas_revs
  ADD COLUMN cell_saver CHAR(1) DEFAULT '', 
  ADD COLUMN cell_saver_volume_ml decimal(6, 2) DEFAULT NULL;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'TreatmentDetail', 'qc_hb_txd_surgery_livers', 'cell_saver', 'cell_saver', '', 'yes_no', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'TreatmentDetail', 'qc_hb_txd_surgery_livers', 'cell_saver_volume_ml', '', 'vol (ml)', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'TreatmentDetail', 'qc_hb_txd_surgery_pancreas', 'cell_saver', 'cell_saver', '', 'yes_no', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'TreatmentDetail', 'qc_hb_txd_surgery_pancreas', 'cell_saver_volume_ml', '', 'vol (ml)', 'float_positive', '', '', NULL, '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), (SELECT id FROM structure_fields WHERE field = 'cell_saver' AND tablename = 'qc_hb_txd_surgery_pancreas'), 
'1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), (SELECT id FROM structure_fields WHERE field = 'cell_saver_volume_ml' AND tablename = 'qc_hb_txd_surgery_pancreas'), 
'1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), (SELECT id FROM structure_fields WHERE field = 'cell_saver' AND tablename = 'qc_hb_txd_surgery_livers'), 
'1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), (SELECT id FROM structure_fields WHERE field = 'cell_saver_volume_ml' AND tablename = 'qc_hb_txd_surgery_livers'), 
'1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('cell_saver','Cell Saver'),('vol (ml)','Vol (ml)');

UPDATE parent_to_derivative_sample_controls SET flag_active = 1 WHERE parent_sample_control_id IN (3,8) AND derivative_sample_control_id IN (12,13);
UPDATE aliquot_controls SET flag_active = 1 WHERE sample_control_id IN (12,13);
