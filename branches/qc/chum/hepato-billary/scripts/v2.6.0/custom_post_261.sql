
-- ----------------------------------------------------------------------------------------------
-- Add event hospitalization & intensive care in batch
-- ----------------------------------------------------------------------------------------------

update event_controls set use_addgrid = 1 where detail_form_alias = 'qc_hb_ed_hospitalization';
update event_controls set use_addgrid = 1 where detail_form_alias = 'qc_hb_ed_intensive_care ';
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_hospitalization') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hospitalizations' AND `field`='hospitalization_end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_intensive_care') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_intensive_cares' AND `field`='intensive_care_end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("yes_no_conversion_diagnostic", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_conversion_diagnostic"), (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_conversion_diagnostic"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_conversion_diagnostic"), (SELECT id FROM structure_permissible_values WHERE value="conversion" AND language_alias="conversion"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("diagnostic", "diagnostic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_conversion_diagnostic"), (SELECT id FROM structure_permissible_values WHERE value="diagnostic" AND language_alias="diagnostic"), "", "1");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion_diagnostic')  WHERE model='TreatmentDetail' AND tablename='qc_hb_txd_surgery_livers' AND field='laparoscopy' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_conversion');
INSERT INTO i18n (id,en,fr) VALUES ('diagnostic','Diagnostic','Diagnostique');

-- Other treatment : remove other protocol


SELECT 'Other Treatment With Surgery Type: Will be moved to notes if exists. Nothing done if section above empty' AS MSG
UNION ALL
SELECT '---------------------------------------------------------------------------------' AS MSG;
SELECT p.participant_identifier, tm.id AS treatment_master_id, tc.disease_site, tc.tx_method, td.surgery_type
FROM participants p 
INNER JOIN treatment_masters tm ON tm.participant_id = p.id AND tm.deleted <> 1
INNER JOIN treatment_controls tc ON tc.id = tm.treatment_control_id
INNER JOIN qc_hb_txd_others td ON td.treatment_master_id = tm.id
WHERE tc.tx_method != 'surgery' AND td.surgery_type IS NOT NULL AND td.surgery_type != '';
SELECT '---------------------------------------------------------------------------------' AS MSG;
UPDATE treatment_masters tm, treatment_controls tc, qc_hb_txd_others td
SET tm.notes = td.surgery_type
WHERE tc.id = tm.treatment_control_id AND td.treatment_master_id = tm.id 
AND tc.tx_method != 'surgery' AND td.surgery_type IS NOT NULL AND td.surgery_type != '' AND tm.deleted <> 1;
UPDATE treatment_masters tm, treatment_controls tc, qc_hb_txd_others td
SET td.surgery_type = ''
WHERE tc.id = tm.treatment_control_id AND td.treatment_master_id = tm.id 
AND tc.tx_method != 'surgery' AND td.surgery_type IS NOT NULL AND td.surgery_type != '' AND tm.deleted <> 1;

ALTER TABLE qc_hb_txd_others CHANGE surgery_type type varchar(50) DEFAULT '';
ALTER TABLE qc_hb_txd_others_revs CHANGE surgery_type type varchar(50) DEFAULT '';
UPDATE structure_fields SET field='type' WHERE model='TreatmentDetail' AND tablename='qc_hb_txd_others' AND field='surgery_type';
UPDATE structures SET alias = 'qc_hb_txd_other_surgeries' WHERE alias = 'qc_hb_txd_others';
UPDATE treatment_controls SET detail_form_alias = 'qc_hb_txd_other_surgeries' WHERE disease_site = 'other' AND tx_method = 'surgery';

UPDATE treatment_controls SET detail_form_alias = 'qc_hb_txd_other_treatments', applied_protocol_control_id = null WHERE disease_site = 'other' AND tx_method = 'treatment';
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_hb_tx_other_treatments", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Treatment Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Other Treatment Types', 1, 50, 'clinical - treatment');
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT lower(pm.code), '1', @control_id, NOW(), NOW(), 1, 1 FROM protocol_controls pc INNER JOIN protocol_masters pm ON pm.protocol_control_id = pc.id WHERE type = 'other' AND deleted <> 1);
INSERT INTO structures(`alias`) VALUES ('qc_hb_txd_other_treatments');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_others', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_other_treatments') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_others' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_tx_other_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE treatment_masters tm, treatment_controls tc, qc_hb_txd_others td, protocol_masters pm
SET td.type = pm.code
WHERE tc.id = tm.treatment_control_id AND td.treatment_master_id = tm.id 
AND tc.tx_method = 'treatment' AND tm.deleted <> 1 AND pm.id = tm.protocol_master_id AND tm.protocol_master_id IS NOT NULL;
UPDATE treatment_masters tm, treatment_controls tc, qc_hb_txd_others td
SET tm.protocol_master_id = NULL
WHERE tc.id = tm.treatment_control_id AND td.treatment_master_id = tm.id 
AND tc.tx_method = 'treatment';

DROP TABLE qc_hb_pd_others;
DROP TABLE qc_hb_pd_others_revs;
DELETE FROM protocol_masters WHERE protocol_control_id = (SELECT id FROM protocol_controls WHERE type = 'other');
DELETE FROM protocol_controls WHERE type = 'other';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='pe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='pe_chemos' AND `field`='frequency' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE txe_chemos ADD COLUMN qc_hb_cycles varchar(20) DEFAULT NULL;
ALTER TABLE txe_chemos_revs ADD COLUMN qc_hb_cycles varchar(20) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'txe_chemos', 'qc_hb_cycles', 'input',  NULL , '0', 'size=10', '', '', 'cycles', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_chemos' AND `field`='qc_hb_cycles' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='cycles' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');

ALTER TABLE qc_hb_txd_surgery_livers
 ADD COLUMN liver_size_x int(3) DEFAULT NULL,
 ADD COLUMN liver_size_y int(3) DEFAULT NULL,
 ADD COLUMN liver_size_z int(3) DEFAULT NULL;
ALTER TABLE qc_hb_txd_surgery_livers_revs
 ADD COLUMN liver_size_x int(3) DEFAULT NULL,
 ADD COLUMN liver_size_y int(3) DEFAULT NULL,
 ADD COLUMN liver_size_z int(3) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_surgery_livers', 'liver_size_x', 'integer',  NULL , '0', 'size=3', '', '', 'liver size x', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_surgery_livers', 'liver_size_y', 'integer',  NULL , '0', 'size=3', '', '', '', '-'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_hb_txd_surgery_livers', 'liver_size_z', 'integer',  NULL , '0', 'size=3', '', '', '', '-');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='liver_size_x' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='liver size x' AND `language_tag`=''), '2', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='liver_size_y' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '2', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field`='liver_size_z' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '2', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO i18n (id,en) VALUES ('liver size x','Liver Size (cm x cm x cm)'),('cycles','Cycles');

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label)
VALUES 
('qc_hb_txe_chemotherapy_complications','qc_hb_txe_chemotherapy_complications','1','chemotherapy complications','chemotherapy complications');
INSERT INTO structures(`alias`) VALUES ('qc_hb_txe_chemotherapy_complications');
INSERT INTO structure_value_domains (domain_name,source) VALUES ('qc_hb_chemotherapy_complication_list',"StructurePermissibleValuesCustom::getCustomDropdown(\'Chemotherapy - Complication : Type\')");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qc_hb_txe_chemotherapy_complications', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_chemotherapy_complication_list') , '0', '', '', '', 'chemotherapy complication type', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qc_hb_txe_chemotherapy_complications', 'date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qc_hb_txe_chemotherapy_complications', 'notes', 'input',  NULL , '0', 'rows=3,cols=30', '', '', 'notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txe_chemotherapy_complications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_hb_txe_chemotherapy_complications' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_chemotherapy_complication_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemotherapy complication type' AND `language_tag`=''), '0', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_chemotherapy_complications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_hb_txe_chemotherapy_complications' AND `field`='date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_chemotherapy_complications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_hb_txe_chemotherapy_complications' AND `field`='notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Chemotherapy - Complication : Type', 1, 250, 'clinical - treatment');
CREATE TABLE qc_hb_txe_chemotherapy_complications (
  `type` varchar(250) DEFAULT NULL,
  `date` date DEFAULT NULL,
  notes text,
  treatment_extend_master_id int(11) NOT NULL,
  KEY FK_qc_hb_txe_chemotherapy_complications_treatment_extend_masters (treatment_extend_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE qc_hb_txe_chemotherapy_complications_revs (
  `type` varchar(250) DEFAULT NULL,
  `date` date DEFAULT NULL,
  notes text, 
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  treatment_extend_master_id int(11) NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
ALTER TABLE `qc_hb_txe_chemotherapy_complications`
  ADD CONSTRAINT FK_qc_hb_txe_chemotherapy_complications_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id);
INSERT INTO i18n (id,en) VALUES ('chemotherapy complications','Chemotherapy Complications'),('chemotherapy complication type','Chemotherapy Complication Type');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `tablename`='qc_hb_txe_chemotherapy_complications' AND `field`='type'), 'notEmpty');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txe_chemotherapy_complications');
UPDATE structure_formats SET `display_column`='2' WHERE `display_column`='1' AND structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications');
UPDATE structure_formats SET `display_column`='1' WHERE `display_column`='0' AND structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications');

ALTER TABLE qc_hb_txe_chemotherapy_complications ADD COLUMN date_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE qc_hb_txe_chemotherapy_complications_revs ADD COLUMN date_accuracy CHAR(1) NOT NULL DEFAULT '';

UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE versions SET branch_build_number = '5706' WHERE version_number = 'v2.6.1';
UPDATE users SET flag_active = 0 WHERE username IN ('MichEn');

INSERT INTO i18n (id,en) 
VALUES 
('medical imaging bone scintigraphy','Bone Scintigraphy'),
('medical imaging cerebral MRI','Cerebral MRI'),
('medical imaging cerebral CT-scan', 'Cerebral CT-scan');
INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, detail_form_alias, detail_tablename, display_order, databrowser_label, flag_use_for_ccl, use_addgrid, use_detail_form_for_index) VALUES
('', 'imagery', 'medical imaging bone scintigraphy', 1, 'qc_hb_imaging_dateNSummary,qc_hb_other_localisations,qc_hb_imaging_result', 'qc_hb_ed_hepatobilary_medical_imagings', 0, 'imagery|medical imaging bone scintigraphy', 0, 0, 0),
('', 'imagery', 'medical imaging cerebral MRI', 1, 'qc_hb_imaging_dateNSummary,qc_hb_other_localisations,qc_hb_imaging_result', 'qc_hb_ed_hepatobilary_medical_imagings', 0, 'imagery|medical imaging cerebral MRI', 0, 0, 0),
('', 'imagery', 'medical imaging cerebral CT-scan', 1, 'qc_hb_imaging_dateNSummary,qc_hb_other_localisations,qc_hb_imaging_result', 'qc_hb_ed_hepatobilary_medical_imagings', 0, 'imagery|medical imaging cerebral CT-scan', 0, 0, 0);

ALTER TABLE qc_hb_ed_medical_imaging_record_summaries
	ADD COLUMN cerebral_ct_scan varchar(5) DEFAULT NULL,
	ADD COLUMN bone_scintigraphy varchar(5) DEFAULT NULL,
	ADD COLUMN cerebral_mri varchar(5) DEFAULT NULL;
ALTER TABLE qc_hb_ed_medical_imaging_record_summaries_revs
	ADD COLUMN cerebral_ct_scan varchar(5) DEFAULT NULL,
	ADD COLUMN bone_scintigraphy varchar(5) DEFAULT NULL,
	ADD COLUMN cerebral_mri varchar(5) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'qc_hb_ed_medical_imaging_record_summaries', 'cerebral_ct_scan', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'medical imaging cerebral CT-scan', ''),
('ClinicalAnnotation', 'EventMaster', 'qc_hb_ed_medical_imaging_record_summaries', 'bone_scintigraphy', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'medical imaging bone scintigraphy', ''),
('ClinicalAnnotation', 'EventMaster', 'qc_hb_ed_medical_imaging_record_summaries', 'cerebral_mri', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'medical imaging cerebral MRI', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='cerebral_ct_scan' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='bone_scintigraphy' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='cerebral_mri' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_fields SET  `model`='EventDetail',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  WHERE model='EventMaster' AND tablename='qc_hb_ed_medical_imaging_record_summaries' AND field='cerebral_ct_scan' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `model`='EventDetail',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  WHERE model='EventMaster' AND tablename='qc_hb_ed_medical_imaging_record_summaries' AND field='bone_scintigraphy' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `model`='EventDetail',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  WHERE model='EventMaster' AND tablename='qc_hb_ed_medical_imaging_record_summaries' AND field='cerebral_mri' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_formats SET `display_order`='200' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='abdominal_ct_scan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='201' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='abdominal_mri' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='202' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='abdominal_ultrasound' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='203' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='bone_scintigraphy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='204' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='cerebral_ct_scan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='205' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='cerebral_mri' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='206' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='chest_ct_scan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='207' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='chest_x_ray' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='208' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='contrast_enema' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='209' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='contrast_enhanced_ultrasound' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='210' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='doppler_ultrasound' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='211' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='endoscopic_ultrasound' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='212' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='endoscopy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='213' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='ercp' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='214' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='hida_scan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='215' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='octreoscan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='216' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='pelvic_ct_scan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='217' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='pelvic_mri' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='218' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='tep_scan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='219' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='transhepatic_cholangiography' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='reviewed events' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='abdominal_ct_scan' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_medical_imaging_record_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_medical_imaging_record_summaries' AND `field`='abdominal_ultrasound' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

INSERT INTO i18n (id,en) 
VALUES 
('rubbia brandt','Rubbia Brandt'),
('blazer','Blazer');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'world_health_organization_classification', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='WHO_classification_pe') , '0', '', '', '', 'world health organization classification', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'mitotic_not_applicable', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', 'mitotic activity', 'not applicable', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'less_than_2_mitoses_10_high_power_fields', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'less than 2 mitoses/10 high power fields (HPF)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'greater than or equal to 2 mitoses/10 HPF to 10 mitoses/10 HPF', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'less_than_2_mitoses_specify_per_10_HPF', 'input',  NULL , '0', '', '', '', '', 'specify mitoses per 10 HPF'), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'greater_or_equal_to_2_mitoses_specify_per_10_HPF', 'input',  NULL , '0', '', '', '', '', 'specify mitoses per 10 HPF'), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'greater_than_10_mitoses_per_10_HPF', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'greater than 10 mitoses per 10 HPF', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'mitotic_cannot_be_determined', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'mitotic cannot be determined', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'less_or_equal_2percent_Ki67_positive_cells', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'less or equal 2% Ki67-positive cells', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', '3_to_20percent_Ki67_positive_cells', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '3%-20% Ki67-positive cells', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'great_than_20percent_Ki67_positive_cells', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'great than 20% Ki67-positive cells', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='world_health_organization_classification' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='WHO_classification_pe')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='world health organization classification' AND `language_tag`=''), '2', '42', 'WHO classification', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='mitotic_not_applicable' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='mitotic activity' AND `language_label`='not applicable' AND `language_tag`=''), '2', '54', 'mitotic activity', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='less_than_2_mitoses_10_high_power_fields' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='less than 2 mitoses/10 high power fields (HPF)' AND `language_tag`=''), '2', '55', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='greater than or equal to 2 mitoses/10 HPF to 10 mitoses/10 HPF' AND `language_tag`=''), '2', '57', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='less_than_2_mitoses_specify_per_10_HPF' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify mitoses per 10 HPF'), '2', '56', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='greater_or_equal_to_2_mitoses_specify_per_10_HPF' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify mitoses per 10 HPF'), '2', '58', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='greater_than_10_mitoses_per_10_HPF' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='greater than 10 mitoses per 10 HPF' AND `language_tag`=''), '2', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='mitotic_cannot_be_determined' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mitotic cannot be determined' AND `language_tag`=''), '2', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='less_or_equal_2percent_Ki67_positive_cells' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='less or equal 2% Ki67-positive cells' AND `language_tag`=''), '2', '61', 'Ki67 labeling index', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='3_to_20percent_Ki67_positive_cells' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='3%-20% Ki67-positive cells' AND `language_tag`=''), '2', '62', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='great_than_20percent_Ki67_positive_cells' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='great than 20% Ki67-positive cells' AND `language_tag`=''), '2', '63', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE qc_hb_ed_lab_report_liver_metastases
  ADD COLUMN `world_health_organization_classification` varchar(60) DEFAULT NULL,
  ADD COLUMN `mitotic_not_applicable` tinyint(1) DEFAULT '0',
  ADD COLUMN `less_than_2_mitoses_10_high_power_fields` tinyint(1) DEFAULT '0',
  ADD COLUMN `greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF` tinyint(1) DEFAULT '0',
  ADD COLUMN `less_than_2_mitoses_specify_per_10_HPF` varchar(10) DEFAULT NULL,
  ADD COLUMN `greater_or_equal_to_2_mitoses_specify_per_10_HPF` varchar(10) DEFAULT NULL,
  ADD COLUMN  `greater_than_10_mitoses_per_10_HPF` tinyint(1) DEFAULT '0',
  ADD COLUMN `mitotic_cannot_be_determined` tinyint(1) DEFAULT '0',
  ADD COLUMN `less_or_equal_2percent_Ki67_positive_cells` tinyint(1) DEFAULT '0',
  ADD COLUMN `3_to_20percent_Ki67_positive_cells` tinyint(1) DEFAULT '0',
  ADD COLUMN `great_than_20percent_Ki67_positive_cells` tinyint(1) DEFAULT '0';
ALTER TABLE qc_hb_ed_lab_report_liver_metastases_revs
  ADD COLUMN `world_health_organization_classification` varchar(60) DEFAULT NULL,
  ADD COLUMN `mitotic_not_applicable` tinyint(1) DEFAULT '0',
  ADD COLUMN `less_than_2_mitoses_10_high_power_fields` tinyint(1) DEFAULT '0',
  ADD COLUMN `greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF` tinyint(1) DEFAULT '0',
  ADD COLUMN `less_than_2_mitoses_specify_per_10_HPF` varchar(10) DEFAULT NULL,
  ADD COLUMN `greater_or_equal_to_2_mitoses_specify_per_10_HPF` varchar(10) DEFAULT NULL,
  ADD COLUMN  `greater_than_10_mitoses_per_10_HPF` tinyint(1) DEFAULT '0',
  ADD COLUMN `mitotic_cannot_be_determined` tinyint(1) DEFAULT '0',
  ADD COLUMN `less_or_equal_2percent_Ki67_positive_cells` tinyint(1) DEFAULT '0',
  ADD COLUMN `3_to_20percent_Ki67_positive_cells` tinyint(1) DEFAULT '0',
  ADD COLUMN `great_than_20percent_Ki67_positive_cells` tinyint(1) DEFAULT '0';  

UPDATE structure_formats SET `display_column`='2', `display_order`='300' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('viability (%)', '', 'Viability (&#37;)', 'Viabilité (&#37;)'),
('in situ percentage', '', 'IS&#37;', 'IS&#37;'),
('invasive percentage', '', 'INV&#37;', 'INV&#37;'),
('necrosis inv percentage', '', 'Nec &#37; INV', 'Nec &#37; INV'),
('necrosis is percentage', '', 'Nec &#37; IS', 'Nec &#37; IS'),
('stroma percentage', '', 'STR&#37;', 'STR&#37;'),
('normal percentage', '', 'N&#37;', 'N&#37;'),
('3%-20% Ki67-positive cells', '', '3&#37;-20&#37; Ki67-Positive Cells', '3&#37;-20&#37; cellules Ki67 positives'),
('great than 20% Ki67-positive cells', '', '&gt;20&#37; Ki67-Positive Cells', '&gt;20&#37; cellules Ki67 positives'),
('less or equal 2% Ki67-positive cells', '', '&lt;=2&#37; Ki67-Positive Cells', '&lt;=2&#37; cellules Ki67 positives');
