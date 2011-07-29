-- run after v2.2.2
INSERT INTO banks(`name`, `description`, `created_by`, `created`, `modified_by`, `modified`) VALUES
('OHRI-COEUR', '', 1, NOW(), 1, NOW()),
('CBCF-COEUR', '', 1, NOW(), 1, NOW()),
('OVCare', '', 1, NOW(), 1, NOW()),
('CHUQ-COEUR', '', 1, NOW(), 1, NOW());
INSERT INTO misc_identifier_controls (misc_identifier_name, misc_identifier_name_abbrev, flag_once_per_participant) VALUES
('OHRI-COEUR', 'OHRI-COEUR', 1),
('CBCF-COEUR', 'CBCF-COEUR', 1),
('OVCare', 'OVCare', 1),
('CHUQ-COEUR', 'CHUQ_COEUR', 1);

ALTER TABLE banks
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
ALTER TABLE banks_revs
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
 
UPDATE banks SET misc_identifier_control_id=id;

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_eoc_event_type"),  (SELECT id FROM structure_permissible_values WHERE value="radiotherapy" AND language_alias="radiotherapy"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("suboptimal", "suboptimal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_residual_disease"),  (SELECT id FROM structure_permissible_values WHERE value="suboptimal" AND language_alias="suboptimal"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("radiotherapy", "radiotherapy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_eoc_event_type"),  (SELECT id FROM structure_permissible_values WHERE value="radiotherapy" AND language_alias="radiotherapy"), "0", "1");

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("yes unknown", "yes unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_residual_disease"),  (SELECT id FROM structure_permissible_values WHERE value="yes unknown" AND language_alias="yes unknown"), "0", "1");

UPDATE structure_permissible_values SET value='Female Genital-Peritoneal Pelvis Abdomen', language_alias='Female Genital-Peritoneal Pelvis Abdomen' WHERE value='Female Genital-Peritoneal';
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Female Genital-Peritoneal", "Female Genital-Peritoneal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tumor_site"),  (SELECT id FROM structure_permissible_values WHERE value="Female Genital-Peritoneal" AND language_alias="Female Genital-Peritoneal"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("not applicable", "not applicable");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="not applicable" AND language_alias="not applicable"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("CA125", "CA125");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tumor_site"),  (SELECT id FROM structure_permissible_values WHERE value="CA125" AND language_alias="CA125"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("female genital-ovary", "female genital-ovary");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_presence_of_precursor_of_benign_lesions"),  (SELECT id FROM structure_permissible_values WHERE value="female genital-ovary" AND language_alias="female genital-ovary"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("serous", "serous");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_histopathology"),  (SELECT id FROM structure_permissible_values WHERE value="serous" AND language_alias="serous"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_histopathology_opc"),  (SELECT id FROM structure_permissible_values WHERE value="serous" AND language_alias="serous"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_histopathology_opc"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "0", "1");

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_brca_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_brca') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='demographics' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `language_heading`='genetics and family data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_family_history' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fam_hist') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_abrv' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_abrv_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE qc_tf_dxd_other_primary_cancers
 DROP COLUMN tumor_site;
ALTER TABLE qc_tf_dxd_other_primary_cancers_revs
 DROP COLUMN tumor_site;
ALTER TABLE diagnosis_masters
 ADD COLUMN qc_tf_tumor_site VARCHAR(50) DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 ADD COLUMN qc_tf_tumor_site VARCHAR(50) DEFAULT '';
 
UPDATE structure_fields SET  `model`='DiagnosisMaster',  `field`='qc_tf_tumor_site',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_other_primary_cancers' AND field='tumor_site' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin') AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters
 ADD COLUMN qc_tf_progression_recurrence VARCHAR(50) DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 ADD COLUMN qc_tf_progression_recurrence VARCHAR(50) DEFAULT '';
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_progression_recurrence', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("primary", "primary");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_recurrence"),  (SELECT id FROM structure_permissible_values WHERE value="primary" AND language_alias="primary"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("metastasis", "metastasis");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_recurrence"),  (SELECT id FROM structure_permissible_values WHERE value="metastasis" AND language_alias="metastasis"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("ca125 progression", "ca125 progression");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_recurrence"),  (SELECT id FROM structure_permissible_values WHERE value="ca125 progression" AND language_alias="ca125 progression"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_recurrence"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "0", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_tf_progression_recurrence', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence') , '0', '', '', '', 'progression recurrence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progression recurrence' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progression recurrence' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

ALTER TABLE qc_tf_dxd_eocs
 DROP COLUMN date_of_progression_recurrence,
 DROP COLUMN date_of_progression_recurrence_accuracy,
 DROP COLUMN site_1_of_tumor_progression,
 DROP COLUMN site_2_of_tumor_progression,
 DROP COLUMN date_of_ca125_progression,
 DROP COLUMN date_of_ca125_progression_accu;
ALTER TABLE qc_tf_dxd_eocs_revs
 DROP COLUMN date_of_progression_recurrence,
 DROP COLUMN date_of_progression_recurrence_accuracy,
 DROP COLUMN site_1_of_tumor_progression,
 DROP COLUMN site_2_of_tumor_progression,
 DROP COLUMN date_of_ca125_progression,
 DROP COLUMN date_of_ca125_progression_accu;
 
ALTER TABLE qc_tf_dxd_other_primary_cancers
 DROP COLUMN date_of_progression_recurrence,
 DROP COLUMN date_of_progression_recurrence_accuracy,
 DROP COLUMN site_of_tumor_progression;
ALTER TABLE qc_tf_dxd_other_primary_cancers_revs
 DROP COLUMN date_of_progression_recurrence,
 DROP COLUMN date_of_progression_recurrence_accuracy,
 DROP COLUMN site_of_tumor_progression;
 
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='date_of_progression_recurrence' AND `language_label`='date of progression recurrence' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='date_of_progression_recurrence_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence' AND `language_label`='progression recurrence' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='site_of_tumor_progression' AND `language_label`='site of tumor progression' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_progression_recurrence' AND `language_label`='date of progession/recurrence' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_progression_recurrence_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='site_1_of_tumor_progression' AND `language_label`='site 1 of tumor progression (metastasis) if applicable' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='site_2_of_tumor_progression' AND `language_label`='site 2 of tumor progression (metastasis) if applicable' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_ca125_progression' AND `language_label`='date of ca125 progression' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_ca125_progression_accu' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '0', '', '1', 'primary number', '0', '', '1', '', '1', 'integer', '1', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '0', '', '1', 'primary number', '0', '', '1', '', '1', 'integer', '1', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

CREATE TABLE qc_tf_dxd_progression_and_recurrences(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 progression_time_in_month SMALLINT UNSIGNED DEFAULT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
 FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters`(`id`)
)Engine=InnoDb;
CREATE TABLE qc_tf_dxd_progression_and_recurrences_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 progression_time_in_month SMALLINT UNSIGNED DEFAULT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;

INSERT INTO diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('progression and recurrence', 1, 'qc_tf_dxd_progression_recurrence', 'qc_tf_dxd_progression_and_recurrences', 3, 'progression and recurrence');

ALTER TABLE diagnosis_masters
 MODIFY COLUMN path_stage_summary VARCHAR(50) DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 MODIFY COLUMN path_stage_summary VARCHAR(50) DEFAULT '';
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_tf_tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence')  AND `flag_confidential`='0'), '1', '3', '', '1', 'qc tf progression recurrence', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence') AND `flag_confidential`='0');

INSERT INTO i18n (id, en, fr) VALUES
('progression and recurrence', 'Progression and recurrence', 'Progression et récurrence'),
('metastasis', 'Metastasis', 'Métastase'),
('last contact', 'Last contact', 'Dernier contact'),
('demographics', 'Demographics', 'Démographie'),
('system data', 'System data', 'Données système'),
('awaiting reception', 'Awaiting reception', 'En attente de réception');

INSERT INTO structures(`alias`) VALUES ('qc_tf_dxd_progression_recurrence');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'primary number', '0', '', '1', '', '1', 'integer', '1', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progression recurrence' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '1', 'date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1');

DELETE FROM structure_formats WHERE structure_id IN(SELECT id FROM structures WHERE alias IN('qc_tf_event_eoc', 'qc_tf_ed_other_primary_cancer')); 
DELETE FROM structures WHERE alias IN('qc_tf_event_eoc', 'qc_tf_ed_other_primary_cancer');
DROP TABLE qc_tf_ed_eocs;
DELETE FROM structure_fields WHERE tablename='qc_tf_ed_eocs';
DROP TABLE qc_tf_ed_other_primary_cancers;
DELETE FROM structure_fields WHERE tablename='qc_tf_ed_other_primary_cancers';

CREATE TABLE qc_tf_ed_no_details(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL
)engine=InnoDb;
CREATE TABLE qc_tf_ed_no_details_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)engine=InnoDb;

CREATE TABLE qc_tf_ed_ca125s(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 precision_u FLOAT DEFAULT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL
)engine=InnoDb;
CREATE TABLE qc_tf_ed_ca125s_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 precision_u FLOAT DEFAULT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)engine=InnoDb;

CREATE TABLE qc_tf_ed_ct_scans(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 scan_precision VARCHAR(50) DEFAULT '', 
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL
)engine=InnoDb;
CREATE TABLE qc_tf_ed_ct_scans_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 scan_precision VARCHAR(50) DEFAULT '',
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)engine=InnoDb;

DELETE FROM event_controls WHERE id IN(35, 36);
INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('', 'lab', 'CA125', 1, 'qc_tf_ed_ca125s', 'qc_tf_ed_ca125', 0, 'CA125'),
('', 'clinical', 'ct scan', 1, 'qc_tf_ed_ct_scans', 'qc_tf_ed_ct_scans', 0, 'ct scan'),
('', 'clinical', 'biopsy', 1, 'qc_tf_ed_no_details', 'qc_tf_ed_no_details', 0, 'biopsy');

UPDATE tx_controls SET flag_active=1 WHERE id IN(1, 3, 10, 11);

INSERT INTO tx_controls (tx_method, disease_site, flag_active, detail_tablename, form_alias, extend_tablename, extend_form_alias, display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label) VALUES
('radiology', NULL, 1, 'qc_tf_tx_empty', 'treatmentmasters', NULL, NULL, 0, NULL, NULL, 'radiology');

ALTER TABLE event_masters
 ADD COLUMN event_date_accuracy CHAR(1) DEFAULT '' AFTER event_date;
ALTER TABLE event_masters_revs
 ADD COLUMN event_date_accuracy CHAR(1) DEFAULT '' AFTER event_date;
 
DROP TABLE qc_tf_tx_eocs;
DROP TABLE qc_tf_tx_eocs_revs;

UPDATE tx_controls SET detail_tablename='qc_tf_tx_empty', form_alias='treatmentmasters' WHERE id IN(5, 6, 7, 8, 10, 11);
UPDATE tx_controls SET extend_tablename=NULL, extend_form_alias=NULL WHERE id IN(6, 7, 8, 10, 11);

DELETE FROM tx_controls WHERE id IN(6,7,8);

ALTER TABLE txd_surgeries
 ADD COLUMN qc_tf_type VARCHAR(50) DEFAULT '' AFTER tx_master_id;
ALTER TABLE txd_surgeries_revs
 ADD COLUMN qc_tf_type VARCHAR(50) DEFAULT '' AFTER tx_master_id;
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_surgery_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_surgery_type"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("ovarectomy", "ovarectomy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_surgery_type"),  (SELECT id FROM structure_permissible_values WHERE value="ovarectomy" AND language_alias="ovarectomy"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("", "");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_surgery_type"),  (SELECT id FROM structure_permissible_values WHERE value="" AND language_alias=""), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("not applicable", "not applicable");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tumor_site"),  (SELECT id FROM structure_permissible_values WHERE value="not applicable" AND language_alias="not applicable"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("III", "III");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_stage"),  (SELECT id FROM structure_permissible_values WHERE value="III" AND language_alias="III"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("cyclophosphamide", "cyclophosphamide");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_eoc_event_drug"),  (SELECT id FROM structure_permissible_values WHERE value="cyclophosphamide" AND language_alias="cyclophosphamide"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("qc_tf_coeur_awaiting_reception", "awaiting reception");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_in_stock_detail"),  (SELECT id FROM structure_permissible_values WHERE value="qc_tf_coeur_awaiting_reception" AND language_alias="awaiting reception"), "0", "1");


-- ----------------------------------------------------------------------------------------------------------------------
-- NL revision 2011-07-26
-- ----------------------------------------------------------------------------------------------------------------------

-- NL rev: Profile

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1', `flag_addgrid`='0', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='current status' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');

INSERT into i18n (id,en) VALUES ('genetics and family data','Genetics and Family Data');

UPDATE structure_fields SET  `language_label`='last chart checked date' WHERE model='Participant' AND tablename='participants' AND field='last_chart_checked_date' AND `type`='date' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_suspected_date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_sdod_accuracy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact_acc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- NL rev: Diagnosis

UPDATE structure_formats SET `flag_override_label`='0', language_label = ''
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_tf_dx_eoc')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` IN ('dx_date','primary_number'));

UPDATE structure_formats SET `flag_add`='0',`flag_add_readonly`='0', `flag_edit`='0',`flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_recurrence') AND `flag_confidential`='0');

DELETE FROM structure_value_domains_permissible_values
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_presence_of_precursor_of_benign_lesions")
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="Female Genital-Ovary");

INSERT into i18n (id,en) VALUES 
('a new diagnoses group should be created for a primary diagnosis', 'A new diagnoses group should be created for a primary diagnosis!'),
('the diagnoses group can not be changed for a primary diagnosis', 'The diagnoses group can not be changed for a primary diagnosis!');

UPDATE structure_formats SET `flag_search`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='-2'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_recurrence');

UPDATE structure_formats SET `display_order`='-3'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number');

ALTER TABLE `diagnosis_masters` CHANGE `qc_tf_progression_recurrence` `qc_tf_dx_origin` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;
ALTER TABLE `diagnosis_masters_revs` CHANGE `qc_tf_progression_recurrence` `qc_tf_dx_origin` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_dx_origin', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("primary", "primary"),("progression", "progression");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_origin"),  (SELECT id FROM structure_permissible_values WHERE value="primary" AND language_alias="primary"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_origin"),  (SELECT id FROM structure_permissible_values WHERE value="progression" AND language_alias="progression"), "1", "1");

UPDATE structure_fields SET field = 'qc_tf_dx_origin', language_label = 'origin', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_origin")
WHERE field = 'qc_tf_progression_recurrence';

ALTER TABLE diagnosis_masters
 ADD COLUMN qc_tf_progression_detection_method VARCHAR(50) DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 ADD COLUMN qc_tf_progression_detection_method VARCHAR(50) DEFAULT '';

SET @value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_progression_recurrence');
UPDATE structure_value_domains SET domain_name = 'qc_tf_progression_detection_method' WHERE id = @value_domain_id;

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = @value_domain_id;
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("ca125", "ca125"),("site detection","site detection");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_progression_detection_method'),  (SELECT id FROM structure_permissible_values WHERE value="ca125" AND language_alias="ca125"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_progression_detection_method'),  (SELECT id FROM structure_permissible_values WHERE value="site detection" AND language_alias="site detection"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown","unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_progression_detection_method'),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("not applicable","not applicable");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_progression_detection_method'),  (SELECT id FROM structure_permissible_values WHERE value="not applicable" AND language_alias="not applicable"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_tf_progression_detection_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_detection_method') , '0', '', '', '', 'origin', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_detection_method'), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_detection_method'), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_fields SET language_label = 'detection method' WHERE field = 'qc_tf_progression_detection_method';

UPDATE structure_formats SET `display_order`='-1'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='diagnosis_control_id');

UPDATE structure_formats SET `display_order`='0'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_detection_method');

INSERT into i18n (id,en) VALUES ('detection method','Detection Method');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_origin') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

DELETE FROM structure_formats WHERE `structure_field_id`=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='qc_tf_tumor_site');
DELETE FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='qc_tf_tumor_site';
UPDATE structure_formats SET `display_order`='-6'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='primary_number');
UPDATE structure_formats SET `display_order`='-5'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='qc_tf_dx_origin');
UPDATE structure_formats SET `display_order`='-4'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='dx_date');
UPDATE structure_formats SET `display_order`='-4'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='dx_date_accuracy');
UPDATE structure_formats SET `display_order`='-3'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='diagnosis_control_id');
UPDATE structure_formats SET `display_order`='-2'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='qc_tf_tumor_site');
UPDATE structure_formats SET `display_order`='-1'
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='qc_tf_progression_detection_method');

UPDATE structure_value_domains_permissible_values SET display_order = 1 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="Ia" AND language_alias="Ia") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');
UPDATE structure_value_domains_permissible_values SET display_order = 2 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="Ib" AND language_alias="Ib") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');
UPDATE structure_value_domains_permissible_values SET display_order = 3 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="Ic" AND language_alias="Ic") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');

UPDATE structure_value_domains_permissible_values SET display_order = 4 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="IIa" AND language_alias="IIa") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');
UPDATE structure_value_domains_permissible_values SET display_order = 5 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="IIb" AND language_alias="IIb") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');
UPDATE structure_value_domains_permissible_values SET display_order = 6 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="IIc" AND language_alias="IIc") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');

UPDATE structure_value_domains_permissible_values SET display_order = 7 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="III" AND language_alias="III") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');
UPDATE structure_value_domains_permissible_values SET display_order = 8 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="IIIa" AND language_alias="IIIa") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');
UPDATE structure_value_domains_permissible_values SET display_order = 9
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="IIIb" AND language_alias="IIIb") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');
UPDATE structure_value_domains_permissible_values SET display_order = 10 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="IIIc" AND language_alias="IIIc") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');

UPDATE structure_value_domains_permissible_values SET display_order = 11 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="IV" AND language_alias="IV") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');

UPDATE structure_value_domains_permissible_values SET display_order = 12 
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_stage');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='qc_tf_tumor_site'), 'notEmpty', '', 'value is required', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='qc_tf_progression_detection_method'), 'notEmpty', '', 'value is required', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_value_domains_permissible_values
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="ca125" AND language_alias="ca125") AND structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_tumor_site');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_dx_origin'), '1', '-5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site'), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1', `flag_search`='0', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_origin') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_origin') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_origin') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_label`='0', language_label = ''
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` IN ('dx_date','primary_number'));

INSERT into i18n (id,en) VALUES 
('a progression should be related to an existing diagnoses group', 'A progression should be related to an existing diagnoses group!'),
('progression are currently linked to this primary','Progression are currently linked to this primary!'),
('progression','Progression');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name = 'qc_tf_tumor_site'),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "0", "1");

INSERT into i18n (id,en) VALUES ('ca125','CA125');

UPDATE menus SET flag_active = 0 WHERE parent_id = 'clin_CAN_4' AND id NOT IN ('clin_CAN_28' , 'clin_CAN_31');

UPDATE event_controls SET disease_site = 'EOC', databrowser_label = concat('EOC|',databrowser_label) WHERE form_alias LIKE 'qc_tf_ed_%';

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'other', 'clinical', 'radiology', 1, 'qc_tf_ed_no_details', 'qc_tf_ed_no_details', 0, 'other|radiology'),
(null, 'other', 'clinical', 'biopsy', 1, 'qc_tf_ed_no_details', 'qc_tf_ed_no_details', 0, 'other|biopsy');

DELETE FROM tx_controls WHERE detail_tablename LIKE 'qc_tf_tx_%';
UPDATE tx_controls SET flag_active = 0;

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'chemotherapy', 'EOC', 1, 'txd_chemos', 'qc_tf_tx_empty', 'txe_chemos', 'txe_chemos', 0, NULL, NULL, 'EOC|chemotherapy'),
(null, 'surgery', 'EOC', 1, 'txd_surgeries', 'qc_tf_tx_empty', NULL, NULL, 0, NULL, NULL, 'EOC|surgery'),

(null, 'surgery', 'other', 1, 'txd_surgeries', 'qc_tf_tx_empty', NULL, NULL, 0, NULL, NULL, 'other|surgery'),
(null, 'chemotherapy', 'other', 1, 'txd_chemos', 'qc_tf_tx_empty', 'txe_chemos', 'txe_chemos', 0, NULL, NULL, 'other|chemotherapy'),
(null, 'radiotherapy', 'other', 1, 'qc_tf_tx_empty', 'qc_tf_tx_empty', NULL, NULL, 0, NULL, NULL, 'other|radiotherapy'),
(null, 'hormonal therapy', 'other', 1, 'qc_tf_tx_empty', 'qc_tf_tx_empty', NULL, NULL, 0, NULL, NULL, 'other|hormonal therapy');

INSERT into i18n (id,en) VALUES ('radiotherapy','Radiotherapy');

INSERT INTO structures(`alias`) VALUES ('qc_tf_tx_empty');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_tx_empty'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_start_date' AND `language_label`='start date' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_tx_empty'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_tx_empty'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('qc_tf_ed_no_details');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_no_details'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_no_details'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_ca125s', 'precision_u', 'ca125 precision (u)', '', 'float_positive', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_ct_scans', 'scan_precision', 'ct scan precision', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ct_scan_precision') , '', 'open', 'open', 'open');

INSERT INTO structures(`alias`) VALUES ('qc_tf_ed_ct_scans');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_ct_scans'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_ct_scans'), (SELECT id FROM structure_fields WHERE `tablename`='qc_tf_ed_ct_scans' AND `field`='scan_precision'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_ct_scans'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('qc_tf_ed_ca125s');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_ca125s'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_ca125s'), (SELECT id FROM structure_fields WHERE `tablename`='qc_tf_ed_ca125s' AND `field`='precision_u'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_ca125s'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND `flag_confidential`='0');

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'ovarectomy', 'EOC', 1, 'txd_surgeries', 'qc_tf_tx_empty', NULL, NULL, 0, NULL, NULL, 'EOC|ovarectomy');

DELETE FROM i18n WHERE id in ('ovarectomy','hormonal therapy','ct scan');
INSERT into i18n (id,en) VALUES
('ovarectomy','Ovarectomy'),('hormonal therapy','Hormonal Therapy'),('ct scan','CT Scan');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ed_no_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

update event_controls SET event_type = 'ca125', databrowser_label = 'EOC|ca125' WHERE event_type = 'CA125';
update event_controls SET detail_tablename = 'qc_tf_ed_ca125s' WHERE detail_tablename = 'qc_tf_ed_ca125';

INSERT into i18n (id,en) VALUES ('ca125 precision (u)','CA125 (u)');

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/protocol/%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/material/%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/sop/%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/labbook/%';






