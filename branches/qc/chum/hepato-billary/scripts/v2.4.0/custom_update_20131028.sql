ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies
  ADD COLUMN fluid_amylase_u_lit decimal(10,2) DEFAULT NULL,
  ADD COLUMN fluid_lipase_u_lit decimal(10,2) DEFAULT NULL,
  ADD COLUMN fluid_bilirubin_umol_l decimal(10,2) DEFAULT NULL;
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies_revs
  ADD COLUMN fluid_amylase_u_lit decimal(10,2) DEFAULT NULL,
  ADD COLUMN fluid_lipase_u_lit decimal(10,2) DEFAULT NULL,
  ADD COLUMN fluid_bilirubin_umol_l decimal(10,2) DEFAULT NULL;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biologies', 'fluid_amylase_u_lit', 'amylase (u/l)', '', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biologies', 'fluid_lipase_u_lit', 'lipase (u/l)', '', 'float_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biologies', 'fluid_bilirubin_umol_l', 'bilirubin (umol/l)', '', 'float_positive', '', '', NULL, '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_lab_report_biology'), (SELECT id FROM structure_fields WHERE field = 'fluid_amylase_u_lit' AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biologies'), 
'2', '50', 'drain fluid', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_lab_report_biology'), (SELECT id FROM structure_fields WHERE field = 'fluid_lipase_u_lit' AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biologies'), 
'2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_lab_report_biology'), (SELECT id FROM structure_fields WHERE field = 'fluid_bilirubin_umol_l' AND tablename = 'qc_hb_ed_hepatobilary_lab_report_biologies'), 
'2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en) VALUES 
('amylase (u/l)','Amylase (u/L)'),
('lipase (u/l)','Lipase (u/L)'),
('bilirubin (umol/l)', 'Bilirubin (umol/L)'),
('drain fluid','Drain fluid');

INSERT INTO i18n (id,en,fr) VALUES ('event date', 'Annotation Date', 'Date d''annotation');
UPDATE structure_formats SET flag_override_label = '', language_label = '' WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'event_date');
UPDATE structure_fields SET language_label = 'event date' WHERE field = 'event_date';

ALTER TABLE ed_all_clinical_followups CHANGE COLUMN disease_status disease_status_precision varchar(50) DEFAULT NULL;
ALTER TABLE ed_all_clinical_followups CHANGE COLUMN vital_status disease_status varchar(50) DEFAULT NULL;
ALTER TABLE ed_all_clinical_followups_revs  CHANGE COLUMN disease_status disease_status_precision varchar(50) DEFAULT NULL;
ALTER TABLE ed_all_clinical_followups_revs CHANGE COLUMN vital_status disease_status varchar(50) DEFAULT NULL;
UPDATE structure_fields SET field = 'disease_status_precision', language_label = 'disease status precision' WHERE tablename = 'ed_all_clinical_followups' AND field = 'disease_status';
UPDATE structure_fields SET field = 'disease_status', language_label = 'disease status' WHERE tablename = 'ed_all_clinical_followups' AND field = 'vital_status';
INSERT IGNORE INTO i18n (id,en) VALUES 
('disease status precision','Disease Status Precision');
INSERT INTO structure_permissible_values (value, language_alias) VALUES ("alive with no evidence of disease", "alive with no evidence of disease");
DELETE FROM structure_value_domains_permissible_values
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="vital_status_code")
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value = 'alive' AND language_alias = 'alive');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="vital_status_code"), (SELECT id FROM structure_permissible_values WHERE value="alive with no evidence of disease" AND language_alias="alive with no evidence of disease"), "", "1");
UPDATE ed_all_clinical_followups SET disease_status = "alive with no evidence of disease" WHERE disease_status = "alive";
UPDATE ed_all_clinical_followups_revs SET disease_status = "alive with no evidence of disease" WHERE disease_status = "alive";
INSERT INTO i18n (id,en) VALUES ("alive with no evidence of disease", "Alive with no evidence of disease");

INSERT INTO structure_value_domains (domain_name) VALUES ('qc_hb_recurrence_status');
INSERT INTO structure_permissible_values (value, language_alias) VALUES ("systemic", "systemic"),('loco-regional','loco-regional');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_recurrence_status"), (SELECT id FROM structure_permissible_values WHERE value="systemic" AND language_alias="systemic"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_recurrence_status"), (SELECT id FROM structure_permissible_values WHERE value="loco-regional" AND language_alias="loco-regional"), "", "1");
UPDATE structure_fields SET type = 'select', setting = '', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_recurrence_status') WHERE field = 'recurrence_status' AND tablename = 'ed_all_clinical_followups';
INSERT INTO i18n (id,en) VALUES ("systemic", "Systemic"),('loco-regional','Loco-Regional');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'follow-up : recurrence localization');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('other', 'other', '', '1', @control_id, NOW(), NOW(), 1, 1);
ALTER TABLE ed_all_clinical_followups ADD COLUMN qc_hb_recurrence_localization_precision varchar(50) DEFAULT NULL;
ALTER TABLE ed_all_clinical_followups_revs ADD COLUMN qc_hb_recurrence_localization_precision varchar(50) DEFAULT NULL;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'ed_all_clinical_followups', 'qc_hb_recurrence_localization_precision', 'recurrence localization precision', '', 'input', 'size=10', '', NULL, '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE field = 'qc_hb_recurrence_localization_precision' AND tablename = 'ed_all_clinical_followups'), 
'1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET display_order = '6' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_hb_recurrence_treatment') AND structure_id = (SELECT id FROM structures WHERE alias='ed_all_clinical_followup');
UPDATE structure_formats SET display_order = '7' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'weight') AND structure_id = (SELECT id FROM structures WHERE alias='ed_all_clinical_followup');
INSERT IGNORE INTO i18n (id,en) VALUES ('recurrence localization precision','Recurrence Localization Precision');

-- -- -- -- --

-- qc_hb_ed_score_clips

ALTER TABLE qc_hb_ed_score_clips MODIFY COLUMN portal_thrombosis char(1) DEFAULT '';
ALTER TABLE qc_hb_ed_score_clips_revs MODIFY COLUMN portal_thrombosis char(1) DEFAULT '';
UPDATE qc_hb_ed_score_clips SET portal_thrombosis = 'y' WHERE portal_thrombosis = '1';
UPDATE qc_hb_ed_score_clips SET portal_thrombosis = 'n' WHERE portal_thrombosis = '0';
UPDATE qc_hb_ed_score_clips_revs SET portal_thrombosis = 'y' WHERE portal_thrombosis = '1';
UPDATE qc_hb_ed_score_clips_revs SET portal_thrombosis = 'n' WHERE portal_thrombosis = '0';
UPDATE structure_fields SET type='yes_no', structure_value_domain = null WHERE field = 'portal_thrombosis' AND tablename = 'qc_hb_ed_score_clips';

-- qc_hb_ed_score_fongs

ALTER TABLE qc_hb_ed_score_fongs 
  MODIFY COLUMN metastatic_lymph_nodes char(1) DEFAULT '',
  MODIFY COLUMN interval_under_year char(1) DEFAULT '',
  MODIFY COLUMN more_than_one_metastasis char(1) DEFAULT '',
  MODIFY COLUMN cea_greater_two_hundred char(1) DEFAULT '';
ALTER TABLE qc_hb_ed_score_fongs_revs 
  MODIFY COLUMN metastatic_lymph_nodes char(1) DEFAULT '',
  MODIFY COLUMN interval_under_year char(1) DEFAULT '',
  MODIFY COLUMN more_than_one_metastasis char(1) DEFAULT '',
  MODIFY COLUMN cea_greater_two_hundred char(1) DEFAULT '';
UPDATE qc_hb_ed_score_fongs SET metastatic_lymph_nodes = 'y' WHERE metastatic_lymph_nodes = '1';
UPDATE qc_hb_ed_score_fongs SET metastatic_lymph_nodes = 'n' WHERE metastatic_lymph_nodes = '0';
UPDATE qc_hb_ed_score_fongs SET interval_under_year = 'y' WHERE interval_under_year = '1';
UPDATE qc_hb_ed_score_fongs SET interval_under_year = 'n' WHERE interval_under_year = '0';
UPDATE qc_hb_ed_score_fongs SET more_than_one_metastasis = 'y' WHERE more_than_one_metastasis = '1';
UPDATE qc_hb_ed_score_fongs SET more_than_one_metastasis = 'n' WHERE more_than_one_metastasis = '0';
UPDATE qc_hb_ed_score_fongs SET metastasis_greater_five_cm = 'y' WHERE metastasis_greater_five_cm = '1';
UPDATE qc_hb_ed_score_fongs SET metastasis_greater_five_cm = 'n' WHERE metastasis_greater_five_cm = '0';
UPDATE qc_hb_ed_score_fongs SET cea_greater_two_hundred = 'y' WHERE cea_greater_two_hundred = '1';
UPDATE qc_hb_ed_score_fongs SET cea_greater_two_hundred = 'n' WHERE cea_greater_two_hundred = '0';
UPDATE qc_hb_ed_score_fongs_revs SET metastatic_lymph_nodes = 'y' WHERE metastatic_lymph_nodes = '1';
UPDATE qc_hb_ed_score_fongs_revs SET metastatic_lymph_nodes = 'n' WHERE metastatic_lymph_nodes = '0';
UPDATE qc_hb_ed_score_fongs_revs SET interval_under_year = 'y' WHERE interval_under_year = '1';
UPDATE qc_hb_ed_score_fongs_revs SET interval_under_year = 'n' WHERE interval_under_year = '0';
UPDATE qc_hb_ed_score_fongs_revs SET more_than_one_metastasis = 'y' WHERE more_than_one_metastasis = '1';
UPDATE qc_hb_ed_score_fongs_revs SET more_than_one_metastasis = 'n' WHERE more_than_one_metastasis = '0';
UPDATE qc_hb_ed_score_fongs_revs SET metastasis_greater_five_cm = 'y' WHERE metastasis_greater_five_cm = '1';
UPDATE qc_hb_ed_score_fongs_revs SET metastasis_greater_five_cm = 'n' WHERE metastasis_greater_five_cm = '0';
UPDATE qc_hb_ed_score_fongs_revs SET cea_greater_two_hundred = 'y' WHERE cea_greater_two_hundred = '1';
UPDATE qc_hb_ed_score_fongs_revs SET cea_greater_two_hundred = 'n' WHERE cea_greater_two_hundred = '0';
UPDATE structure_fields SET type='yes_no', structure_value_domain = null WHERE field IN ('metastatic_lymph_nodes', 'interval_under_year', 'more_than_one_metastasis', 'metastasis_greater_five_cm', 'cea_greater_two_hundred') AND tablename = 'qc_hb_ed_score_fongs';

-- qc_hb_ed_score_gretchs

ALTER TABLE qc_hb_ed_score_gretchs MODIFY COLUMN portal_thrombosis char(1) DEFAULT '';
ALTER TABLE qc_hb_ed_score_gretchs_revs MODIFY COLUMN portal_thrombosis char(1) DEFAULT '';
UPDATE qc_hb_ed_score_gretchs SET portal_thrombosis = 'y' WHERE portal_thrombosis = '1';
UPDATE qc_hb_ed_score_gretchs SET portal_thrombosis = 'n' WHERE portal_thrombosis = '0';
UPDATE qc_hb_ed_score_gretchs_revs SET portal_thrombosis = 'y' WHERE portal_thrombosis = '1';
UPDATE qc_hb_ed_score_gretchs_revs SET portal_thrombosis = 'n' WHERE portal_thrombosis = '0';
UPDATE structure_fields SET type='yes_no', structure_value_domain = null WHERE field IN ('portal_thrombosis') AND tablename = 'qc_hb_ed_score_gretchs';

-- qc_hb_ed_score_melds

ALTER TABLE qc_hb_ed_score_melds MODIFY COLUMN dialysis char(1) DEFAULT '';
ALTER TABLE qc_hb_ed_score_melds_revs MODIFY COLUMN dialysis char(1) DEFAULT '';
UPDATE qc_hb_ed_score_melds SET dialysis = 'y' WHERE dialysis = '1';
UPDATE qc_hb_ed_score_melds SET dialysis = 'n' WHERE dialysis = '0';
UPDATE qc_hb_ed_score_melds_revs SET dialysis = 'y' WHERE dialysis = '1';
UPDATE qc_hb_ed_score_melds_revs SET dialysis = 'n' WHERE dialysis = '0';
UPDATE structure_fields SET type='yes_no', structure_value_domain = null WHERE field IN ('dialysis') AND tablename = 'qc_hb_ed_score_melds';

-- qc_hb_ed_score_okudas

ALTER TABLE qc_hb_ed_score_okudas MODIFY COLUMN ascite char(1) DEFAULT '';
ALTER TABLE qc_hb_ed_score_okudas MODIFY COLUMN ascite char(1) DEFAULT '';
UPDATE qc_hb_ed_score_okudas SET ascite = 'y' WHERE ascite = '1';
UPDATE qc_hb_ed_score_okudas SET ascite = 'n' WHERE ascite = '0';
UPDATE qc_hb_ed_score_okudas_revs SET ascite = 'y' WHERE ascite = '1';
UPDATE qc_hb_ed_score_okudas_revs SET ascite = 'n' WHERE ascite = '0';
UPDATE structure_fields SET type='yes_no', structure_value_domain = null WHERE field IN ('ascite') AND tablename = 'qc_hb_ed_score_okudas';
