
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

- ds Chemotherapy : être capable de noter les complications comme pour la chirurgie (date, type, traitement etc.. )

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

UPDATE versions SET branch_build_number = '5706' WHERE version_number = 'v2.6.1';
UPDATE users SET flag_active = 0 WHERE username IN ('MichEn');

