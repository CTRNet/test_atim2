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
('progression an recurrence', 1, 'qc_tf_dxd_progression_recurrence', 'qc_tf_dxd_progression_and_recurrences', 3, 'progression an recurrence');

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
('progression an recurrence', 'Progression and recurrence', 'Progression et récurrence'),
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

