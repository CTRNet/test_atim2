-- --------------------------------------------------------------------------------------------------------------
-- follow-up ajouter :
--    - localization of recurrence : <liste>
--    - treatment of recurrence : <liste>
-- --------------------------------------------------------------------------------------------------------------

ALTER TABLE ed_all_clinical_followups
  ADD COLUMN qc_hb_recurrence_localization varchar(100) DEFAULT null,
  ADD COLUMN qc_hb_recurrence_treatment varchar(100) DEFAULT null;
ALTER TABLE ed_all_clinical_followups_revs
  ADD COLUMN qc_hb_recurrence_localization varchar(100) DEFAULT null,
  ADD COLUMN qc_hb_recurrence_treatment varchar(100) DEFAULT null;   
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_follow_up_recurrence_localization', "StructurePermissibleValuesCustom::getCustomDropdown('follow-up : recurrence localization')"),
('qc_nd_follow_up_treatment_localization', "StructurePermissibleValuesCustom::getCustomDropdown('follow-up : recurrence treatment')");
INSERT INTO structure_permissible_values_custom_controls (name, values_max_length, flag_active)
VALUES 
('follow-up : recurrence localization', '100', 1),
('follow-up : recurrence treatment', '100', 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_all_clinical_followups', 'qc_hb_recurrence_localization', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_follow_up_recurrence_localization') , '0', '', '', '', 'recurrence localization', ''),
('Clinicalannotation', 'EventDetail', 'ed_all_clinical_followups', 'qc_hb_recurrence_treatment', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_follow_up_treatment_localization') , '0', '', '', '', 'recurrence treatment', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='qc_hb_recurrence_localization'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='qc_hb_recurrence_treatment'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('recurrence localization','Recurrence Localization ','Récurrence - Localisation'),
('recurrence treatment','Recurrence Treatment','Récurrence - Traitement');

-- --------------------------------------------------------------------------------------------------------------
-- cap-report de métastases ajouter :
--    - K-ras : <liste : wild type - muted - NA
-- --------------------------------------------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_lab_report_liver_metastases ADD COLUMN k_ras varchar(50) DEFAULT null;
ALTER TABLE qc_hb_ed_lab_report_liver_metastases_revs ADD COLUMN k_ras varchar(50) DEFAULT null;
INSERT INTO structure_value_domains (domain_name) VALUES ('qc_nd_K_ras_values');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) 
VALUES
("wild type", "wild type"), ('muted','muted'), ('N/A','N/A');
INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_K_ras_values"), (SELECT id FROM structure_permissible_values WHERE value="wild type" AND language_alias="wild type"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_K_ras_values"), (SELECT id FROM structure_permissible_values WHERE value="muted" AND language_alias="muted"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_K_ras_values"), (SELECT id FROM structure_permissible_values WHERE value="N/A" AND language_alias="N/A"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'k_ras', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_K_ras_values') , '0', '', '', '', 'K-ras', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='k_ras'), 
'1', '42', 'genetic', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en) 
VALUES 
('genetic','Genetic'),
('K-ras','K-ras'),
('muted','Muted'),
("wild type", "Wild Type");

-- --------------------------------------------------------------------------------------------------------------
-- scan et IRM abdo ajouter :
--    - segment IV : nombre et taille
-- --------------------------------------------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
  ADD COLUMN `segment_4_number` smallint(5) unsigned DEFAULT NULL AFTER segment_3_size,
  ADD COLUMN `segment_4_size`  decimal(6, 2) DEFAULT NULL AFTER segment_4_number;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
  ADD COLUMN `segment_4_number` smallint(5) unsigned DEFAULT NULL AFTER segment_3_size,
  ADD COLUMN `segment_4_size` decimal(6, 2) DEFAULT NULL AFTER segment_4_number;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4_number', 'segment IV', 'number', 'integer_positive', '', '', NULL, '', '', '', ''),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'segment_4_size', '', 'size (cm)', 'float_positive', '', '', NULL, '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'segment_4_number' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE field = 'segment_4_size' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), 
'2', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('segment IV', 'Segment IV', 'Segment IV');

-- --------------------------------------------------------------------------------------------------------------
-- Life Style - ajouter pour alcool, tabac et drogues :
--    - Yes - No - Former
-- --------------------------------------------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles 
  MODIFY active_tobacco varchar(20) DEFAULT null,
  MODIFY active_alcohol varchar(20) DEFAULT null,
  MODIFY drugs varchar(20) DEFAULT null;
ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles_revs 
  MODIFY active_tobacco varchar(20) DEFAULT null,
  MODIFY active_alcohol varchar(20) DEFAULT null,
  MODIFY drugs varchar(20) DEFAULT null;
INSERT INTO structure_value_domains (domain_name) VALUES ('qc_nd_lifestyle_addiction_values');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) 
VALUES
("yes", "yes"), ('no','no'), ('former','former');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
 VALUES
 ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_lifestyle_addiction_values"), 
 (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1"),
 ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_lifestyle_addiction_values"), 
 (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1"),
 ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_lifestyle_addiction_values"), 
 (SELECT id FROM structure_permissible_values WHERE value="former" AND language_alias="former"), "3", "1"); 
UPDATE structure_fields SET type = 'select', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_lifestyle_addiction_values') WHERE tablename = 'qc_hb_ed_hepatobiliary_lifestyles' AND field IN ('active_tobacco','active_alcohol','drugs');
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_tobacco = 'yes' WHERE active_tobacco = 'y';
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_tobacco = 'no' WHERE active_tobacco = 'n';
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_alcohol = 'yes' WHERE active_alcohol = 'y';
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_alcohol = 'no' WHERE active_alcohol = 'n';  
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET drugs = 'yes' WHERE drugs = 'y';
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET drugs = 'no' WHERE drugs = 'n';  
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('former', 'Former', 'Ancien');
  
-- --------------------------------------------------------------------------------------------------------------
-- treatment-liver surgery et treatment pancreas-surgery ajouter :
--    - notes
-- --------------------------------------------------------------------------------------------------------------

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), (SELECT id FROM structure_fields WHERE field = 'notes' AND model = 'TreatmentMaster'), 
'2', '100', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), (SELECT id FROM structure_fields WHERE field = 'notes' AND model = 'TreatmentMaster'), 
'2', '100', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), (SELECT id FROM structure_fields WHERE field = 'notes' AND model = 'TreatmentMaster'), 
'1', '100', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemos'), (SELECT id FROM structure_fields WHERE field = 'notes' AND model = 'TreatmentMaster'), 
'1', '100', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

Nous avons trouvé des dysfonctionnements :
- Report of preoperative data : ne fonctionne pas, il n'y a rien qui s'affiche
- Report d'imagerie : manque des données de taille ou de nombre (on a parfois l'un mais pas l'autre) et surtout manque la possibilité d'avoir les examens en ordre chronologique pour pouvoir faire le suivi des lésions.


 






























DELETE FROM i18n WHERE id IN ('recurrence localization','recurrence treatment');












DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field` LIKe 'qc_hb_recurrence_%');
DELETE FROM structure_fields WHERE field IN ('qc_hb_recurrence_localization','qc_hb_recurrence_treatment');
-- DELETE FROM structure_permissible_values_custom_controls WHERE name like 'follow-up : %_localization%';
DELETE FROM structure_value_domains WHERE domain_name like '%qc_nd_follow_up_%_localization%';










