
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
