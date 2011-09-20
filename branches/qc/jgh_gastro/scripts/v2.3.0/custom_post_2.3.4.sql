-- run post 2.3.4 install.

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma specimen'), 'Primary', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma specimen'), 'Metastasis', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor site'), 'Head and neck', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor site'), 'Trunk', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor site'), 'Upper extremities', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor site'), 'Lower extremities', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma histologic type'), 'Mucosal', '', '', 0, 1, now(), 1, now(), 1);

ALTER TABLE qc_gastro_dxd_cap_melanomas
 ADD COLUMN organ VARCHAR(50) NOT NULL DEFAULT '' AFTER pm_precision,
 ADD COLUMN other VARCHAR(50) NOT NULL DEFAULT '' AFTER organ,
 ADD COLUMN comments TEXT DEFAULT NULL AFTER other,
 ADD COLUMN ulceration VARCHAR(50) NOT NULL DEFAULT '' AFTER comments,
 ADD COLUMN chronic_sun_damages CHAR(1) NOT NULL DEFAULT '' AFTER ulceration,
 ADD COLUMN complete_or_segmental_regression CHAR(1) NOT NULL DEFAULT '' AFTER chronic_sun_damages,
 ADD COLUMN anatomical_level_clarks VARCHAR(200) NOT NULL DEFAULT '' AFTER complete_or_segmental_regression,
 ADD COLUMN depth_of_invasion_specify_mm FLOAT UNSIGNED DEFAULT NULL AFTER anatomical_level_clarks,
 ADD COLUMN depth_of_invasion_at_least_mm FLOAT UNSIGNED DEFAULT NULL AFTER depth_of_invasion_specify_mm,
 ADD COLUMN vascular_invasion_or_angiotopism VARCHAR(50) NOT NULL DEFAULT '' AFTER depth_of_invasion_at_least_mm,
 ADD COLUMN tumor_infiltrating_lymphocytes1 VARCHAR(50) NOT NULL DEFAULT '' AFTER vascular_invasion_or_angiotopism,
 ADD COLUMN tumor_infiltrating_lymphocytes2 VARCHAR(50) NOT NULL DEFAULT '' AFTER tumor_infiltrating_lymphocytes1,
 ADD COLUMN mitotic_index VARCHAR(200) NOT NULL DEFAULT '' AFTER tumor_infiltrating_lymphocytes2,
 ADD COLUMN mitotic_figures_per_smm FLOAT UNSIGNED DEFAULT NULL AFTER mitotic_index,
 ADD COLUMN cell_population VARCHAR(50) NOT NULL DEFAULT '' AFTER mitotic_figures_per_smm,
 ADD COLUMN lateral_margins VARCHAR(50) NOT NULL DEFAULT '' AFTER cell_population,
 ADD COLUMN deep_margins VARCHAR(50) NOT NULL DEFAULT '' AFTER lateral_margins,
 ADD COLUMN growth_phase VARCHAR(50) NOT NULL DEFAULT '' AFTER deep_margins,
 ADD COLUMN necrosis CHAR(1) NOT NULL DEFAULT '' AFTER growth_phase;
ALTER TABLE qc_gastro_dxd_cap_melanomas_revs
 ADD COLUMN organ VARCHAR(50) NOT NULL DEFAULT '' AFTER pm_precision,
 ADD COLUMN other VARCHAR(50) NOT NULL DEFAULT '' AFTER organ,
 ADD COLUMN comments TEXT DEFAULT NULL AFTER other,
 ADD COLUMN ulceration VARCHAR(50) NOT NULL DEFAULT '' AFTER comments,
 ADD COLUMN chronic_sun_damages CHAR(1) NOT NULL DEFAULT '' AFTER ulceration,
 ADD COLUMN complete_or_segmental_regression CHAR(1) NOT NULL DEFAULT '' AFTER chronic_sun_damages,
 ADD COLUMN anatomical_level_clarks VARCHAR(200) NOT NULL DEFAULT '' AFTER complete_or_segmental_regression,
 ADD COLUMN depth_of_invasion_specify_mm FLOAT UNSIGNED DEFAULT NULL AFTER anatomical_level_clarks,
 ADD COLUMN depth_of_invasion_at_least_mm FLOAT UNSIGNED DEFAULT NULL AFTER depth_of_invasion_specify_mm,
 ADD COLUMN vascular_invasion_or_angiotopism VARCHAR(50) NOT NULL DEFAULT '' AFTER depth_of_invasion_at_least_mm,
 ADD COLUMN tumor_infiltrating_lymphocytes1 VARCHAR(50) NOT NULL DEFAULT '' AFTER vascular_invasion_or_angiotopism,
 ADD COLUMN tumor_infiltrating_lymphocytes2 VARCHAR(50) NOT NULL DEFAULT '' AFTER tumor_infiltrating_lymphocytes1,
 ADD COLUMN mitotic_index VARCHAR(200) NOT NULL DEFAULT '' AFTER tumor_infiltrating_lymphocytes2,
 ADD COLUMN mitotic_figures_per_smm FLOAT UNSIGNED DEFAULT NULL AFTER mitotic_index,
 ADD COLUMN cell_population VARCHAR(50) NOT NULL DEFAULT '' AFTER mitotic_figures_per_smm,
 ADD COLUMN lateral_margins VARCHAR(50) NOT NULL DEFAULT '' AFTER cell_population,
 ADD COLUMN deep_margins VARCHAR(50) NOT NULL DEFAULT '' AFTER lateral_margins,
 ADD COLUMN growth_phase VARCHAR(50) NOT NULL DEFAULT '' AFTER deep_margins,
 ADD COLUMN necrosis CHAR(1) NOT NULL DEFAULT '' AFTER growth_phase;

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('cap melanoma organ', 1, 50),
('cap melanoma ulceration', 1, 50),
('cap melanoma anatomical level clark', 1, 200),
('cap melanoma vascular invasion or angiotropism', 1, 50),
('cap melanoma tumor-infilatrating lymphocytes1', 1, 50),
('cap melanoma tumor-infilatrating lymphocytes2', 1, 50),
('cap melanoma cell population', 1, 50),
('cap melanoma lateral margins', 1, 50),
('cap melanoma deep margins', 1, 50),
('cap melanoma growth phase', 1, 50);

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES
('qc_gastrop_cap_melanoma_organ', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma organ')"),
('qc_gastrop_cap_melanoma_ulceration', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma ulceration')"),
('qc_gastrop_cap_melanoma_anatomical_level_clark', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma anatomical level clark')"),
('qc_gastrop_cap_melanoma_vascular_invasion_or_angiotropism', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma vascular invasion or angiotropism')"),
('qc_gastrop_cap_melanoma_tumor-infilatrating_lymphocytes1', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma tumor-infilatrating lymphocytes1')"),
('qc_gastrop_cap_melanoma_tumor-infilatrating_lymphocytes2', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma tumor-infilatrating lymphocytes2')"),
('qc_gastrop_cap_melanoma_cell_population', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma cell population')"),
('qc_gastrop_cap_melanoma_lateral_margins', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma lateral margins')"),
('qc_gastrop_cap_melanoma_deep_margins', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma deep margins')"),
('qc_gastrop_cap_melanoma_growth_phase', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('cap melanoma growth phase')");

INSERT INTO structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by) VALUES
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Bone', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Brain', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Eye', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Liver', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Lung', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Lymph node', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Other', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Skin', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Unknown', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma organ'), 'Vulval', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma ulceration'), 'Present', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma ulceration'), 'Not identified', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma ulceration'), 'Undetermined', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma anatomical level clark'), 'Undetermined', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma anatomical level clark'), 'I (melanoma in situ)', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma anatomical level clark'), 'II (melanoma present in but does not fill and expand papillary dermis)', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma anatomical level clark'), 'III (melanoma fills and expands papillary dermis)', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma anatomical level clark'), 'IV (Melanoma invades reticular dermis)', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma anatomical level clark'), 'V (Melanoma invades subcutaneum)', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma vascular invasion or angiotropism'), 'Indeterminate', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma vascular invasion or angiotropism'), 'Not identified', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma vascular invasion or angiotropism'), 'Present', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes1'), 'Absent', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes1'), 'Low', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes1'), 'Moderate', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes1'), 'High', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes1'), 'Undetermined', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes2'), 'Focal', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes2'), 'Diffuse', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma tumor-infilatrating lymphocytes2'), 'Undetermined', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Amelanotic', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Epitheloid', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Mixed', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Nevoid', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Other', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Small cell', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Spindle', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma cell population'), 'Spitzoid', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma lateral margins'), 'Undetermined', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma lateral margins'), 'Not involved by melanoma', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma lateral margins'), 'Involved by melanoma', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma deep margins'), 'Undetermined', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma deep margins'), 'Not involved by melanoma', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma deep margins'), 'Involved by melanoma', '', '', 0, 1, now(), 1, now(), 1),

((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma growth phase'), 'Radial', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma growth phase'), 'Vertical', '', '', 0, 1, now(), 1, now(), 1),
((SELECT id FROM structure_permissible_values_custom_controls WHERE name='cap melanoma growth phase'), 'Indeterminate', '', '', 0, 1, now(), 1, now(), 1);

UPDATE structure_formats SET display_order=display_order+15 WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas') AND display_order > 25;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'organ', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_organ') , '0', '', '', '', 'organ', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'other', 'input',  NULL , '0', '', '', '', 'other', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'comments', 'textarea',  NULL , '0', '', '', '', 'comments', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'ulceration', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_ulceration') , '0', '', '', '', 'ulceration', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'chronic_sun_damages', 'yes_no',  NULL , '0', '', '', '', 'chronic sun damages', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'complete_or_segmental_regression', 'yes_no',  NULL , '0', '', '', '', 'complete or segmental regression', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'anatomical_level_clarks', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_anatomical_level_clark') , '0', '', '', '', 'anatomical level (Clark\'s)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'depth_of_invasion_specify_mm', 'float_positive',  NULL , '0', '', '', '', 'depth of invasion (Breslow\'s) specify (mm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'depth_of_invasion_at_least_mm', 'float_positive',  NULL , '0', '', '', '', 'depth of invasion (Breslow\'s) at least (mm)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'vascular_invasion_or_angiotopism', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_vascular_invasion_or_angiotropism') , '0', '', '', '', 'vascular invasion or angiotopism', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'tumor_infiltrating_lymphocytes1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_tumor-infilatrating_lymphocytes1') , '0', '', '', '', 'tumor infiltrating lymphocytes', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'tumor_infiltrating_lymphocytes2', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_tumor-infilatrating_lymphocytes2') , '0', '', '', '', '', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'mitotic_index', 'input',  NULL , '0', '', '', '', 'mitotic index', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'mitotic_figures_per_smm', 'float_positive',  NULL , '0', '', '', '', 'mitotic figures per mm²', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'cell_population', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_cell_population') , '0', '', '', '', 'cell population', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'lateral_margins', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_lateral_margins') , '0', '', '', '', 'lateral margins', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'deep_margins', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_deep_margins') , '0', '', '', '', 'deep margins', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'growth_phase', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_growth_phase') , '0', '', '', '', 'growth phase', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_gastro_dxd_cap_melanomas', 'necrosis', 'yes_no',  NULL , '0', '', '', '', 'necrosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='organ' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_organ')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='organ' AND `language_tag`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other' AND `language_tag`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='comments' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='comments' AND `language_tag`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='ulceration' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_ulceration')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ulceration' AND `language_tag`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='chronic_sun_damages' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chronic sun damages' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='complete_or_segmental_regression' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complete or segmental regression' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='anatomical_level_clarks' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_anatomical_level_clark')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='anatomical level (Clark\'s)' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='depth_of_invasion_specify_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='depth of invasion (Breslow\'s) specify (mm)' AND `language_tag`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='depth_of_invasion_at_least_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='depth of invasion (Breslow\'s) at least (mm)' AND `language_tag`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='vascular_invasion_or_angiotopism' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_vascular_invasion_or_angiotropism')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='vascular invasion or angiotopism' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='tumor_infiltrating_lymphocytes1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_tumor-infilatrating_lymphocytes1')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor infiltrating lymphocytes' AND `language_tag`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='tumor_infiltrating_lymphocytes2' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_tumor-infilatrating_lymphocytes2')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='mitotic_index' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mitotic index' AND `language_tag`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='mitotic_figures_per_smm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mitotic figures per mm²' AND `language_tag`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='cell_population' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_cell_population')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cell population' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='lateral_margins' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_lateral_margins')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lateral margins' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='deep_margins' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_deep_margins')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='deep margins' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='growth_phase' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastrop_cap_melanoma_growth_phase')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='growth phase' AND `language_tag`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_dxd_cap_melanomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_gastro_dxd_cap_melanomas' AND `field`='necrosis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='necrosis' AND `language_tag`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');

UPDATE structure_fields SET field = 'qc_gastro_bio_material' WHERE field = 'qc_gastro_access_med_file' AND language_label = 'biological material storage and use';

SELECT "
Users have to review all consents: 
Old values 'Access to medical file' and 'Biological material storage and use' were recorded
into the same field 'qc_gastro_access_med_file'!" AS TODO ;

ALTER TABLE qc_gastro_cd_consents
  MODIFY qc_gastro_access_med_file CHAR(1) NOT NULL DEFAULT '',
  MODIFY qc_gastro_bio_material CHAR(1) NOT NULL DEFAULT '',
  MODIFY qc_gastro_blood_col CHAR(1) NOT NULL DEFAULT '',
  MODIFY qc_gastro_saliva_col CHAR(1) NOT NULL DEFAULT '';

ALTER TABLE qc_gastro_cd_consents_revs
  MODIFY qc_gastro_access_med_file CHAR(1) NOT NULL DEFAULT '',
  MODIFY qc_gastro_bio_material CHAR(1) NOT NULL DEFAULT '',
  MODIFY qc_gastro_blood_col CHAR(1) NOT NULL DEFAULT '',
  MODIFY qc_gastro_saliva_col CHAR(1) NOT NULL DEFAULT '';
  
UPDATE qc_gastro_cd_consents SET qc_gastro_access_med_file = 'y' WHERE qc_gastro_access_med_file ='1';
UPDATE qc_gastro_cd_consents SET qc_gastro_bio_material = 'y' WHERE qc_gastro_bio_material ='1';
UPDATE qc_gastro_cd_consents SET qc_gastro_blood_col = 'y' WHERE qc_gastro_blood_col ='1';
UPDATE qc_gastro_cd_consents SET qc_gastro_saliva_col = 'y' WHERE qc_gastro_saliva_col ='1';

UPDATE qc_gastro_cd_consents SET qc_gastro_access_med_file = '' WHERE qc_gastro_access_med_file !='y';
UPDATE qc_gastro_cd_consents SET qc_gastro_bio_material = '' WHERE qc_gastro_bio_material !='y';
UPDATE qc_gastro_cd_consents SET qc_gastro_blood_col = '' WHERE qc_gastro_blood_col !='y';
UPDATE qc_gastro_cd_consents SET qc_gastro_saliva_col = '' WHERE qc_gastro_saliva_col !='y';

UPDATE qc_gastro_cd_consents_revs SET qc_gastro_access_med_file = 'y' WHERE qc_gastro_access_med_file ='1';
UPDATE qc_gastro_cd_consents_revs SET qc_gastro_bio_material = 'y' WHERE qc_gastro_bio_material ='1';
UPDATE qc_gastro_cd_consents_revs SET qc_gastro_blood_col = 'y' WHERE qc_gastro_blood_col ='1';
UPDATE qc_gastro_cd_consents_revs SET qc_gastro_saliva_col = 'y' WHERE qc_gastro_saliva_col ='1';

UPDATE qc_gastro_cd_consents_revs SET qc_gastro_access_med_file = '' WHERE qc_gastro_access_med_file !='y';
UPDATE qc_gastro_cd_consents_revs SET qc_gastro_bio_material = '' WHERE qc_gastro_bio_material !='y';
UPDATE qc_gastro_cd_consents_revs SET qc_gastro_blood_col = '' WHERE qc_gastro_blood_col !='y';
UPDATE qc_gastro_cd_consents_revs SET qc_gastro_saliva_col = '' WHERE qc_gastro_saliva_col !='y';

UPDATE structure_fields SET setting = null, type = 'yes_no' 
WHERE field in ('qc_gastro_access_med_file', 'qc_gastro_saliva_col', 'qc_gastro_blood_col', 'qc_gastro_bio_material') 
AND tablename = 'qc_gastro_cd_consents';

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_cd_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_gastro_cd_consents' AND `field`='qc_gastro_access_med_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_cd_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_gastro_cd_consents' AND `field`='qc_gastro_bio_material' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_cd_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_gastro_cd_consents' AND `field`='qc_gastro_blood_col' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_cd_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_gastro_cd_consents' AND `field`='qc_gastro_saliva_col' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Diag revision

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- DX: other

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='qc_gastro_tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='qc_gastro_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_tissue_precision') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_dx_other') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET structure_value_domain = NULL WHERE type = 'yes_no';

UPDATE structures, structure_formats, structure_fields
SET structure_formats.flag_search = '1',
structure_formats.flag_index = '1',
structure_formats.flag_summary = '0'
WHERE structure_formats.structure_id = structures.id
AND structure_fields.id = structure_formats.structure_field_id
AND structures.alias LIKE 'dx_cap_report_%' 
AND structure_formats.flag_detail = '1'
AND structure_fields.field != 'notes';

UPDATE diagnosis_controls SET controls_type = 'cap report - lung (ld vers.)' WHERE form_alias = 'qc_gastro_dxd_cap_lungs';
UPDATE diagnosis_controls SET controls_type = 'cap report - melanoma (ld vers.)' WHERE form_alias = 'qc_gastro_dxd_cap_melanomas';
UPDATE diagnosis_controls SET controls_type = 'cap report - kidney (ld vers.)' WHERE form_alias = 'qc_gastro_dxd_cap_kidneys';
UPDATE diagnosis_controls SET controls_type = 'cap report - testis (ld vers.)' WHERE form_alias = 'qc_gastro_dxd_cap_testis';
UPDATE diagnosis_controls SET controls_type = 'cap report - urinary bladder (ld vers.)' WHERE form_alias = 'qc_gastro_dxd_cap_bladders';
UPDATE diagnosis_controls SET controls_type = 'cap report - prostate gland - needle biopsy (ld vers.)' WHERE form_alias = 'qc_gastro_dxd_cap_prostate_needles';
UPDATE diagnosis_controls SET controls_type = 'cap report - prostate gland - radical prostatectomy( ld vers.)' WHERE form_alias = 'qc_gastro_dxd_cap_prostate_radicals';

UPDATE diagnosis_controls SET databrowser_label = controls_type WHERE form_alias LIKE 'qc_gastro_dxd_cap_%';

INSERT INTO i18n (id,en) VALUES 
('cap report - lung (ld vers.)', 'CAP Report - Lung (ld vers.)'),
('cap report - melanoma (ld vers.)', 'CAP Report - Melanoma (ld vers.)'),
('cap report - kidney (ld vers.)', 'CAP Report - Kidney (ld vers.)'),
('cap report - testis (ld vers.)', 'CAP Report - Testis (ld vers.)'),
('cap report - urinary bladder (ld vers.)', 'CAP Report - Urinary bladder (ld vers.)'),
('cap report - prostate gland - needle biopsy (ld vers.)', 'CAP Report - Needle biopsy (ld vers.)'),
('cap report - prostate gland - radical prostatectomy( ld vers.)', 'CAP Report - Radical prostatectomy( ld vers.)');

UPDATE structures, structure_formats, structure_fields
SET structure_formats.flag_search = '1',
structure_formats.flag_index = '1',
structure_formats.flag_summary = '0'
WHERE structure_formats.structure_id = structures.id
AND structure_fields.id = structure_formats.structure_field_id
AND structures.alias LIKE 'c_gastro_dxd_cap_%' 
AND structure_formats.flag_detail = '1'
AND structure_fields.field != 'notes';




