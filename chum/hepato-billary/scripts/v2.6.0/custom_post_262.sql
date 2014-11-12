
REPLACE INTO i18n (id,en,fr) 
VALUES 
('necrosis percentage','Necrosis &#37;','Nécrose &#37;'),
('necrosis percentage list','Necrosis &#37; (List)','Nécrose &#37; (liste)'),
('viability percentage','Viability &#37;','&#37; de viabilit');

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0  WHERE label = 'print barcodes';

UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET `type`='input', `setting`='size=10,class=range file' WHERE `field`='participant_identifier';
INSERT INTO structure_validations (structure_field_id,rule,language_message) VALUES ((SELECT id FROM structure_fields WHERE `field`='participant_identifier' AND `model`='Participant'), 'custom,/^[0-9]+$/', 'participant identifier should be a positive integer');
INSERT INTO i18n (id,en,fr) VALUES ('participant identifier should be a positive integer','Bank Nbr should be a positive integer','No Banque doit être un entier positif');

-- --------------------------------------------------------------------------------------------------------
-- VERSION
-- --------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '5714' WHERE version_number = '2.6.2';

-- 20140806 --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_tx_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings ADD COLUMN radiologic_rf_response varchar(50) DEFAULT NULL AFTER radiologic_tace_response;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs ADD COLUMN radiologic_rf_response varchar(50) DEFAULT NULL AFTER radiologic_tace_response;
UPDATE structure_value_domains SET domain_name = 'qc_nd_ed_radiologic_rf_tace_response', source = "StructurePermissibleValuesCustom::getCustomDropdown('Medical imagings : Radiologic TACE/RF response')" WHERE domain_name = 'qc_nd_ed_radiologic_tace_response';
UPDATE structure_permissible_values_custom_controls SET name = 'Medical imagings : Radiologic TACE/RF response' WHERE name = 'Medical imagings : Radiologic TACE response';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'radiologic_rf_response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ed_radiologic_rf_tace_response') , '0', '', '', '', 'radiologic rf response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_segment'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='radiologic_rf_response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_ed_radiologic_rf_tace_response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiologic rf response' AND `language_tag`=''), '2', '232', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('radiologic rf response','Radiologic RF Response');

UPDATE versions SET branch_build_number = '5844' WHERE version_number = '2.6.2';

-- 20141023 --------------------------------------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
  ADD COLUMN metastatic_lymph_nodes_number smallint(5) unsigned default null,
  ADD COLUMN metastatic_lymph_nodes_size decimal(6,2) default null;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
  ADD COLUMN metastatic_lymph_nodes_number smallint(5) unsigned default null,
  ADD COLUMN metastatic_lymph_nodes_size decimal(6,2) default null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'metastatic_lymph_nodes_number', 'integer_positive',  NULL , '0', 'size=5', '', '', '', 'number'), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'metastatic_lymph_nodes_size', 'float_positive',  NULL , '0', 'size=5', '', '', '', 'size (cm)');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_pancreas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='metastatic_lymph_nodes_number' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='number'), '2', '107', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_pancreas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='metastatic_lymph_nodes_size' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='size (cm)'), '2', '107', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='tumors',  `language_tag`='number' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='pancreas_number' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='',  `language_tag`='size (cm)' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='pancreas_size' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en) VALUES ('tumors', 'Tumors');
  
UPDATE versions SET branch_build_number = '5925' WHERE version_number = '2.6.2';

-- 20141112 --------------------------------------------------------------------------------------------------------

ALTER TABLE ed_cap_report_gallbladders MODIFY distance_of_invasive_carcinoma_from_closest_margin_mm decimal(5,1) DEFAULT NULL;
ALTER TABLE ed_cap_report_gallbladders_Revs MODIFY distance_of_invasive_carcinoma_from_closest_margin_mm decimal(5,1) DEFAULT NULL;
 
UPDATE versions SET branch_build_number = '5935' WHERE version_number = '2.6.2';





  