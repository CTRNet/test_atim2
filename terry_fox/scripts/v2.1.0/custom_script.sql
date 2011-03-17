-- Terry fox customization script
-- Run after 2.1 install

-- global
DELETE FROM structure_value_domains_permissible_values WHERE structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values);
ALTER TABLE structure_value_domains_permissible_values MODIFY structure_permissible_value_id int(11) NOT NULL;
ALTER TABLE structure_value_domains_permissible_values ADD FOREIGN KEY (`structure_permissible_value_id`) REFERENCES `structure_permissible_values`(`id`);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_ct_scan_precision', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('positive', 'positive'),
('negative', 'negative');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ct_scan_precision"),  id, "", "1" FROM structure_permissible_values WHERE
(value='positive' AND language_alias='positive') OR
(value='negative' AND language_alias='negative') OR
(value='unknown' AND language_alias='unknown'));

--

-- participants --
ALTER TABLE participants
 ADD qc_tf_bank_id INT UNSIGNED NOT NULL,
 ADD qc_tf_suspected_date_of_death date,
 ADD qc_tf_sdod_accuracy VARCHAR(50) NOT NULL DEFAULT '',
 ADD qc_tf_family_history VARCHAR(50) NOT NULL DEFAULT '',
 ADD qc_tf_brca_status VARCHAR(50) NOT NULL DEFAULT '',
 ADD qc_tf_last_contact DATE DEFAULT NULL,
 ADD qc_tf_last_contact_acc VARCHAR(1) DEFAULT '';

ALTER TABLE participants_revs
 ADD qc_tf_bank_id INT UNSIGNED NOT NULL,
 ADD qc_tf_suspected_date_of_death date,
 ADD qc_tf_sdod_accuracy VARCHAR(50) NOT NULL DEFAULT '',
 ADD qc_tf_family_history VARCHAR(50) NOT NULL DEFAULT '',
 ADD qc_tf_brca_status VARCHAR(50) NOT NULL DEFAULT '',
 ADD qc_tf_last_contact DATE DEFAULT NULL,
 ADD qc_tf_last_contact_acc VARCHAR(1) DEFAULT '';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('no', 'no'),
('precursor of benign ovarian lesions', 'precursor of benign ovarian lesions'),
('ovarian cancer', 'ovarian cancer'),
('colon cancer', 'colon cancer'),
('breast cancer', 'breast cancer'),
('endometrial cancer', 'endometrial cancer'),
('ovarian and breast cancer', 'ovarian and breast cancer'),
('ovarian and colon cancer', 'ovarian and colon cancer'),
('ovarian and endometrial cancer', 'ovarian and endometrial cancer'),
('colon and breast cancer', 'colon and breast cancer'),
('colon and endometrial cancer', 'colon and endometrial cancer'),
('unknown', 'unknown'),
('precursor of benign ovarian lesions', 'precursor of benign ovarian lesions'),
('ovarian cancer', 'ovarian cancer'),
('colon cancer', 'colon cancer'),
('breast cancer', 'breast cancer'),
('endometrial cancer', 'endometrial cancer'),
('ovarian and breast cancer', 'ovarian and breast cancer'),
('ovarian and colon cancer', 'ovarian and colon cancer'),
('ovarian and endometrial cancer', 'ovarian and endometrial cancer'),
('colon and breast cancer', 'colon and breast cancer'),
('colon and endometrial cancer', 'colon and endometrial cancer'),
('wild type', 'wild type'),
('BRCA mutation known but not identified', 'BRCA mutation known but not identified'),
('BRCA1 mutated', 'BRCA1 mutated'),
('BRCA2 mutated', 'BRCA2 mutated'),
('BRCA1/2 mutated', 'BRCA1/2 mutated'),
('unknown ', 'unknown');



INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_fam_hist', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_fam_hist"),  id, "", "1" FROM structure_permissible_values WHERE 
(value='no' AND language_alias='no') OR
(value='precursor of benign ovarian lesions' AND language_alias='precursor of benign ovarian lesions') OR
(value='ovarian cancer' AND language_alias='ovarian cancer') OR
(value='colon cancer' AND language_alias='colon cancer') OR
(value='breast cancer' AND language_alias='breast cancer') OR
(value='endometrial cancer' AND language_alias='endometrial cancer') OR
(value='ovarian and breast cancer' AND language_alias='ovarian and breast cancer') OR
(value='ovarian and colon cancer' AND language_alias='ovarian and colon cancer') OR
(value='ovarian and endometrial cancer' AND language_alias='ovarian and endometrial cancer') OR
(value='colon and breast cancer' AND language_alias='colon and breast cancer') OR
(value='colon and endometrial cancer' AND language_alias='colon and endometrial cancer') OR
(value='unknown' AND language_alias='unknown'));
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_brca', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_brca"),  id, "", "1" FROM structure_permissible_values WHERE
(value='wild type' AND language_alias='wild type') OR
(value='BRCA mutation known but not identified' AND language_alias='BRCA mutation known but not identified') OR
(value='BRCA1 mutated' AND language_alias='BRCA1 mutated') OR
(value='BRCA2 mutated' AND language_alias='BRCA2 mutated') OR
(value='BRCA1/2 mutated' AND language_alias='BRCA1/2 mutated') OR
(value='unknown' AND language_alias='unknown'));

 
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'Participant', 'participants', 'qc_tf_suspected_date_of_death', 'suspected date of death', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'Participant', 'participants', 'qc_tf_sdod_accuracy', '', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'Participant', 'participants', 'qc_tf_bank_id', 'bank', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'Participant', 'participants', 'qc_tf_brca_status', 'brca status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_brca') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'Participant', 'participants', 'qc_tf_family_history', 'family history', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fam_hist') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_suspected_date_of_death' AND `language_label`='suspected date of death' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_sdod_accuracy' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '3', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_id' AND `language_label`='bank' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_brca_status' AND `language_label`='brca status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_brca')  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_family_history' AND `language_label`='family history' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fam_hist')  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');
UPDATE structure_fields SET  `language_label`='registered date of death' WHERE model='Participant' AND tablename='participants' AND field='date_of_death' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_datagrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='title' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='person title'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_datagrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='first_name' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_datagrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='middle_name' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_datagrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='last_name' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='race' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='sex' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_datagrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='marital_status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='language_preferred' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='cod_icd10_code' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='cod_confirmation_source' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='date_of_death' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='vital_status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='health_status'));
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='vital_status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='health_status'));
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='participant_identifier' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='cod_icd10_code' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='secondary_cod_icd10_code' AND type='autocomplete' AND structure_value_domain  IS NULL );
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_last_contact', 'last contact', '', 'date', '', '',  NULL , ''), 
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_last_contact_acc', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `language_label`='last contact' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact_acc' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


INSERT INTO structure_validations (structure_field_id, rule, flag_empty, flag_required, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_id' AND `language_label`='bank' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')), 'notEmpty', 0, 1, '', 'bank is required');

UPDATE structure_fields SET  `language_label`='date of last contact' WHERE model='Participant' AND tablename='participants' AND field='last_chart_checked_date' AND `type`='date' AND structure_value_domain  IS NULL ;


-- end of participants --

-- dx --
UPDATE `diagnosis_controls` SET flag_active=0;
INSERT INTO `diagnosis_controls` (`controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
 ('EOC', 1, 'qc_tf_dx_eoc', 'qc_tf_dxd_eocs', 1),
 ('other primary cancer', 1, 'qc_tf_dxd_other_primary_cancer', 'qc_tf_dxd_other_primary_cancers', 2);  

CREATE TABLE qc_tf_dxd_eocs(
 `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `diagnosis_master_id` INTEGER NOT NULL,
 `presence_of_precursor_of_benign_lesions` VARCHAR(50) NOT NULL DEFAULT '',
 `fallopian_tube_lesion` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `tumor_grade` TINYINT UNSIGNED DEFAULT NULL,
 `figo` VARCHAR(50) NOT NULL DEFAULT '',
 `residual_disease` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_ca125_progression` DATE DEFAULT NULL,
 `date_of_ca125_progression_accu` VARCHAR(1) DEFAULT '',
 `ca125_progression_time_in_months` FLOAT UNSIGNED,
 `site_1_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `site_2_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `progression_time_in_months` FLOAT UNSIGNED,
 `follow_up_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `survival_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `progression_status` VARCHAR(50) NOT NULL DEFAULT '',
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters`(`id`)
)Engine=InnoDb;
CREATE TABLE qc_tf_dxd_eocs_revs(
 `id` INTEGER UNSIGNED NOT NULL,
 `diagnosis_master_id` INTEGER NOT NULL,
 `presence_of_precursor_of_benign_lesions` VARCHAR(50) NOT NULL DEFAULT '',
 `fallopian_tube_lesion` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `tumor_grade` TINYINT UNSIGNED DEFAULT NULL,
 `figo` VARCHAR(50) NOT NULL DEFAULT '',
 `residual_disease` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `site_1_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `site_2_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `progression_time_in_months` FLOAT UNSIGNED,
 `follow_up_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `survival_from_ovarectomy_in_months` FLOAT UNSIGNED,
 `progression_status` VARCHAR(50) NOT NULL DEFAULT '',
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

CREATE TABLE `qc_tf_dxd_other_primary_cancers`(
 `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `diagnosis_master_id` INTEGER NOT NULL,
 `tumor_site` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `site_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `survival_in_months` FLOAT UNSIGNED,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters`(`id`)
)Engine=InnoDb;

CREATE TABLE `qc_tf_dxd_other_primary_cancers_revs`(
 `id` INTEGER UNSIGNED NOT NULL,
 `diagnosis_master_id` INTEGER NOT NULL,
 `tumor_site` VARCHAR(50) NOT NULL DEFAULT '',
 `laterality` VARCHAR(50) NOT NULL DEFAULT '',
 `histopathology` VARCHAR(50) NOT NULL DEFAULT '',
 `date_of_progression_recurrence` DATE,
 `date_of_progression_recurrence_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `site_of_tumor_progression` VARCHAR(50) NOT NULL DEFAULT '',
 `survival_in_months` FLOAT UNSIGNED,
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

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_tumor_site', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Digestive-Anal', 'Digestive-Anal'),
('Digestive-Appendix', 'Digestive-Appendix'),
('Digestive-Bile Ducts', 'Digestive-Bile Ducts'),
('Digestive-Colonic', 'Digestive-Colonic'),
('Digestive-Esophageal', 'Digestive-Esophageal'),
('Digestive-Gallbladder', 'Digestive-Gallbladder'),
('Digestive-Liver', 'Digestive-Liver'),
('Digestive-Pancreas', 'Digestive-Pancreas'),
('Digestive-Rectal', 'Digestive-Rectal'),
('Digestive-Small Intestine', 'Digestive-Small Intestine'),
('Digestive-Stomach', 'Digestive-Stomach'),
('Digestive-Other Digestive', 'Digestive-Other Digestive'),
('Thoracic-Lung', 'Thoracic-Lung'),
('Thoracic-Mesothelioma', 'Thoracic-Mesothelioma'),
('Thoracic-Other Thoracic', 'Thoracic-Other Thoracic'),
('Ophthalmic-Eye', 'Ophthalmic-Eye'),
('Ophthalmic-Other Eye', 'Ophthalmic-Other Eye'),
('Breast-Breast', 'Breast-Breast'),
('Female Genital-Cervical', 'Female Genital-Cervical'),
('Female Genital-Endometrium', 'Female Genital-Endometrium'),
('Female Genital-Fallopian Tube', 'Female Genital-Fallopian Tube'),
('Female Genital-Gestational Trophoblastic Neoplasia', 'Female Genital-Gestational Trophoblastic Neoplasia'),
('Female Genital-Ovary', 'Female Genital-Ovary'),
('Female Genital-Peritoneal', 'Female Genital-Peritoneal'),
('Female Genital-Uterine', 'Female Genital-Uterine'),
('Female Genital-Vulva', 'Female Genital-Vulva'),
('Female Genital-Vagina', 'Female Genital-Vagina'),
('Female Genital-Other Female Genital', 'Female Genital-Other Female Genital'),
('Head & Neck-Larynx', 'Head & Neck-Larynx'),
('Head & Neck-Nasal Cavity and Sinuses', 'Head & Neck-Nasal Cavity and Sinuses'),
('Head & Neck-Lip and Oral Cavity', 'Head & Neck-Lip and Oral Cavity'),
('Head & Neck-Pharynx', 'Head & Neck-Pharynx'),
('Head & Neck-Thyroid', 'Head & Neck-Thyroid'),
('Head & Neck-Salivary Glands', 'Head & Neck-Salivary Glands'),
('Head & Neck-Other Head & Neck', 'Head & Neck-Other Head & Neck'),
('Haematological-Leukemia', 'Haematological-Leukemia'),
('Haematological-Lymphoma', 'Haematological-Lymphoma'),
("Haematological-Hodgkin's Disease", "Haematological-Hodgkin's Disease"),
("Haematological-Non-Hodgkin's Lymphomas", "Haematological-Non-Hodgkin's Lymphomas"),
('Haematological-Other Haematological', 'Haematological-Other Haematological'),
('Skin-Melanoma', 'Skin-Melanoma'),
('Skin-Non Melanomas', 'Skin-Non Melanomas'),
('Skin-Other Skin', 'Skin-Other Skin'),
('Urinary Tract-Bladder', 'Urinary Tract-Bladder'),
('Urinary Tract-Renal Pelvis and Ureter', 'Urinary Tract-Renal Pelvis and Ureter'),
('Urinary Tract-Kidney', 'Urinary Tract-Kidney'),
('Urinary Tract-Urethra', 'Urinary Tract-Urethra'),
('Urinary Tract-Other Urinary Tract', 'Urinary Tract-Other Urinary Tract'),
('Central Nervous System-Brain', 'Central Nervous System-Brain'),
('Central Nervous System-Spinal Cord', 'Central Nervous System-Spinal Cord'),
('Central Nervous System-Other Central Nervous System', 'Central Nervous System-Other Central Nervous System'),
('Musculoskeletal Sites-Soft Tissue Sarcoma', 'Musculoskeletal Sites-Soft Tissue Sarcoma'),
('Musculoskeletal Sites-Bone', 'Musculoskeletal Sites-Bone'),
('Musculoskeletal Sites-Other Bone', 'Musculoskeletal Sites-Other Bone'),
('Other-Primary Unknown', 'Other-Primary Unknown'),
('Other-Gross Metastatic Disease', 'Other-Gross Metastatic Disease');
INSERT IGNORE INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_tumor_site"),  id, "", "1" FROM structure_permissible_values WHERE
(value='Digestive-Anal' AND language_alias='Digestive-Anal') OR
(value='Digestive-Appendix' AND language_alias='Digestive-Appendix') OR
(value='Digestive-Bile Ducts' AND language_alias='Digestive-Bile Ducts') OR
(value='Digestive-Colonic' AND language_alias='Digestive-Colonic') OR
(value='Digestive-Esophageal' AND language_alias='Digestive-Esophageal') OR
(value='Digestive-Gallbladder' AND language_alias='Digestive-Gallbladder') OR
(value='Digestive-Liver' AND language_alias='Digestive-Liver') OR
(value='Digestive-Pancreas' AND language_alias='Digestive-Pancreas') OR
(value='Digestive-Rectal' AND language_alias='Digestive-Rectal') OR
(value='Digestive-Small Intestine' AND language_alias='Digestive-Small Intestine') OR
(value='Digestive-Stomach' AND language_alias='Digestive-Stomach') OR
(value='Digestive-Other Digestive' AND language_alias='Digestive-Other Digestive') OR
(value='Thoracic-Lung' AND language_alias='Thoracic-Lung') OR
(value='Thoracic-Mesothelioma' AND language_alias='Thoracic-Mesothelioma') OR
(value='Thoracic-Other Thoracic' AND language_alias='Thoracic-Other Thoracic') OR
(value='Ophthalmic-Eye' AND language_alias='Ophthalmic-Eye') OR
(value='Ophthalmic-Other Eye' AND language_alias='Ophthalmic-Other Eye') OR
(value='Breast-Breast' AND language_alias='Breast-Breast') OR
(value='Female Genital-Cervical' AND language_alias='Female Genital-Cervical') OR
(value='Female Genital-Endometrium' AND language_alias='Female Genital-Endometrium') OR
(value='Female Genital-Fallopian Tube' AND language_alias='Female Genital-Fallopian Tube') OR
(value='Female Genital-Gestational Trophoblastic Neoplasia' AND language_alias='Female Genital-Gestational Trophoblastic Neoplasia') OR
(value='Female Genital-Ovary' AND language_alias='Female Genital-Ovary') OR
(value='Female Genital-Peritoneal' AND language_alias='Female Genital-Peritoneal') OR
(value='Female Genital-Uterine' AND language_alias='Female Genital-Uterine') OR
(value='Female Genital-Vulva' AND language_alias='Female Genital-Vulva') OR
(value='Female Genital-Vagina' AND language_alias='Female Genital-Vagina') OR
(value='Female Genital-Other Female Genital' AND language_alias='Female Genital-Other Female Genital') OR
(value='Head & Neck-Larynx' AND language_alias='Head & Neck-Larynx') OR
(value='Head & Neck-Nasal Cavity and Sinuses' AND language_alias='Head & Neck-Nasal Cavity and Sinuses') OR
(value='Head & Neck-Lip and Oral Cavity' AND language_alias='Head & Neck-Lip and Oral Cavity') OR
(value='Head & Neck-Pharynx' AND language_alias='Head & Neck-Pharynx') OR
(value='Head & Neck-Thyroid' AND language_alias='Head & Neck-Thyroid') OR
(value='Head & Neck-Salivary Glands' AND language_alias='Head & Neck-Salivary Glands') OR
(value='Head & Neck-Other Head & Neck' AND language_alias='Head & Neck-Other Head & Neck') OR
(value='Haematological-Leukemia' AND language_alias='Haematological-Leukemia') OR
(value='Haematological-Lymphoma' AND language_alias='Haematological-Lymphoma') OR
(value="Haematological-Hodgkin's Disease" AND language_alias="Haematological-Hodgkin's Disease") OR
(value="Haematological-Non-Hodgkin's Lymphomas" AND language_alias="Haematological-Non-Hodgkin's Lymphomas") OR
(value='Haematological-Other Haematological' AND language_alias='Haematological-Other Haematological') OR
(value='Skin-Melanoma' AND language_alias='Skin-Melanoma') OR
(value='Skin-Non Melanomas' AND language_alias='Skin-Non Melanomas') OR
(value='Skin-Other Skin' AND language_alias='Skin-Other Skin') OR
(value='Urinary Tract-Bladder' AND language_alias='Urinary Tract-Bladder') OR
(value='Urinary Tract-Renal Pelvis and Ureter' AND language_alias='Urinary Tract-Renal Pelvis and Ureter') OR
(value='Urinary Tract-Kidney' AND language_alias='Urinary Tract-Kidney') OR
(value='Urinary Tract-Urethra' AND language_alias='Urinary Tract-Urethra') OR
(value='Urinary Tract-Other Urinary Tract' AND language_alias='Urinary Tract-Other Urinary Tract') OR
(value='Central Nervous System-Brain' AND language_alias='Central Nervous System-Brain') OR
(value='Central Nervous System-Spinal Cord' AND language_alias='Central Nervous System-Spinal Cord') OR
(value='Central Nervous System-Other Central Nervous System' AND language_alias='Central Nervous System-Other Central Nervous System') OR
(value='Musculoskeletal Sites-Soft Tissue Sarcoma' AND language_alias='Musculoskeletal Sites-Soft Tissue Sarcoma') OR
(value='Musculoskeletal Sites-Bone' AND language_alias='Musculoskeletal Sites-Bone') OR
(value='Musculoskeletal Sites-Other Bone' AND language_alias='Musculoskeletal Sites-Other Bone') OR
(value='Other-Primary Unknown' AND language_alias='Other-Primary Unknown') OR
(value='Other-Gross Metastatic Disease' AND language_alias='Other-Gross Metastatic Disease'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_histopathology_opc', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('unknown', 'unknown'),
('non applicable', 'non applicable'),
('high grade serous', 'high grade serous'),
('low grade serous', 'low grade serous'),
('mucinous', 'mucinous'),
('endometrioid', 'endometrioid'),
('clear cells', 'clear cells');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_histopathology_opc"),  id, "", "1" FROM structure_permissible_values WHERE
(value='unknown' AND language_alias='unknown') OR
(value='non applicable' AND language_alias='non applicable') OR
(value='high grade serous' AND language_alias='high grade serous') OR
(value='low grade serous' AND language_alias='low grade serous') OR
(value='mucinous' AND language_alias='mucinous') OR
(value='endometrioid' AND language_alias='endometrioid') OR
(value='clear cells' AND language_alias='clear cells'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('0_to_3', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
(0, 0),
(1, 1),
(2, 2),
(3, 3);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="0_to_3"),  id, "", "1" FROM structure_permissible_values WHERE
(value='0' AND language_alias='0') OR
(value='1' AND language_alias='1') OR
(value='2' AND language_alias='2') OR
(value='3' AND language_alias='3'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_stage', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Ia', 'Ia'),
('Ib', 'Ib'),
('Ic', 'Ic'),
('IIa', 'IIa'),
('IIb', 'IIb'),
('IIc', 'IIc'),
('IIIa', 'IIIa'),
('IIIb', 'IIIb'),
('IIIc', 'IIIc'),
('IV', 'IV'),
('unknown', 'unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_stage"),  id, "", "1" FROM structure_permissible_values WHERE
(value='Ia' AND language_alias='Ia') OR
(value='Ib' AND language_alias='Ib') OR
(value='Ic' AND language_alias='Ic') OR
(value='IIa' AND language_alias='IIa') OR
(value='IIb' AND language_alias='IIb') OR
(value='IIc' AND language_alias='IIc') OR
(value='IIIa' AND language_alias='IIIa') OR
(value='IIIb' AND language_alias='IIIb') OR
(value='IIIc' AND language_alias='IIIc') OR
(value='IV' AND language_alias='IV') OR
(value='unknown' AND language_alias='unknown'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_presence_of_precursor_of_benign_lesions', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('no', 'no'),
('unknown', 'unknown'),
('ovarian cysts', 'ovarian cysts'),
('endometriosis', 'endometriosis'),
('endosalpingiosis', 'endosalpingiosis'),
('benign  or borderline tumours', 'benign  or borderline tumours');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_presence_of_precursor_of_benign_lesions"),  id, "", "1" FROM structure_permissible_values WHERE
(value='no' AND language_alias='no') OR
(value='unknown' AND language_alias='unknown') OR
(value='ovarian cysts' AND language_alias='ovarian cysts') OR
(value='endometriosis' AND language_alias='endometriosis') OR
(value='endosalpingiosis' AND language_alias='endosalpingiosis') OR
(value='benign  or borderline tumours' AND language_alias='benign  or borderline tumours'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_fallopian_tube_lesion', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('no', 'no'),
('yes', 'yes'),
('unknown', 'unknown'),
('salpingitis', 'salpingitis'),
('benign tumors', 'benign tumors'),
('malignant tumors', 'malignant tumors');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_fallopian_tube_lesion"),  id, "", "1" FROM structure_permissible_values WHERE
(value='no' AND language_alias='no') OR
(value='yes' AND language_alias='yes') OR
(value='unknown' AND language_alias='unknown') OR
(value='salpingitis' AND language_alias='salpingitis') OR
(value='benign tumors' AND language_alias='benign tumors') OR
(value='malignant tumors' AND language_alias='malignant tumors'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_histopathology', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('high grade serous', 'high grade serous'),
('low grade serous', 'low grade serous'),
('mucinous', 'mucinous'),
('clear cells', 'clear cells'),
('endometrioid', 'endometrioid'),
('mixed', 'mixed'),
('undifferentiated', 'undifferentiated');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_histopathology"),  id, "", "1" FROM structure_permissible_values WHERE
(value='high grade serous' AND language_alias='high grade serous') OR
(value='low grade serous' AND language_alias='low grade serous') OR
(value='mucinous' AND language_alias='mucinous') OR
(value='clear cells' AND language_alias='clear cells') OR
(value='endometrioid' AND language_alias='endometrioid') OR
(value='mixed' AND language_alias='mixed') OR
(value='undifferentiated' AND language_alias='undifferentiated'));


INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_figo', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Ia', 'Ia'),
('Ib', 'Ib'),
('Ic', 'Ic'),
('IIa', 'IIa'),
('IIb', 'IIb'),
('IIc', 'IIc'),
('IIIa', 'IIIa'),
('IIIb', 'IIIb'),
('IIIc', 'IIIc'),
('IV', 'IV');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_figo"),  id, "", "1" FROM structure_permissible_values WHERE
(value='Ia' AND language_alias='Ia') OR
(value='Ib' AND language_alias='Ib') OR
(value='Ic' AND language_alias='Ic') OR
(value='IIa' AND language_alias='IIa') OR
(value='IIb' AND language_alias='IIb') OR
(value='IIc' AND language_alias='IIc') OR
(value='IIIa' AND language_alias='IIIa') OR
(value='IIIb' AND language_alias='IIIb') OR
(value='IIIc' AND language_alias='IIIc') OR
(value='IV' AND language_alias='IV'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_residual_disease', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('none', 'none'),
('miliary', 'miliary'),
('<1cm', '<1cm'),
('1-2cm', '1-2cm'),
('>2cm', '>2cm'),
('unknown', 'unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_residual_disease"),  id, "", "1" FROM structure_permissible_values WHERE
(value='none' AND language_alias='none') OR
(value='miliary' AND language_alias='miliary') OR
(value='<1cm' AND language_alias='<1cm') OR
(value='1-2cm' AND language_alias='1-2cm') OR
(value='>2cm' AND language_alias='>2cm') OR
(value='unknown' AND language_alias='unknown'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_laterality', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('bilateral', 'bilateral');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_laterality"),  id, "", "1" FROM structure_permissible_values WHERE
(value='left' AND language_alias='left') OR
(value='right' AND language_alias='right') OR
(value='bilateral' AND language_alias='bilateral') OR
(value='unknown' AND language_alias='unknown'));


INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_tf_dx_eoc', '', '', '1', '1', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'fallopian_tube_lesion', 'fallopian tube lesion', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fallopian_tube_lesion') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'presence_of_precursor_of_benign_lesions', 'presence of precursor of benign lesions', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_presence_of_precursor_of_benign_lesions') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'age_at_dx', 'age at diagnosis', '', 'integer', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'laterality', 'laterality', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'histopathology', 'histopathology', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'tumour grade', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='0_to_3') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'figo', 'figo', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_figo') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'residual_disease', 'residual disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_residual_disease') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'date_of_progression_recurrence', 'date of progession/recurrence', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'date_of_progression_recurrence_accuracy', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'site_1_of_tumor_progression', 'site 1 of tumor progression (metastasis) if applicable', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'site_2_of_tumor_progression', 'site 2 of tumor progression (metastasis) if applicable', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'survival_from_ovarectomy_in_months', 'survival from ovarectomy (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'progression_time_in_months', 'progression time (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'follow_up_from_ovarectomy_in_months', 'follow up from ovarectomy (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'date of diagnosis', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  ), '1', '2', '', '0', '', '1', 'accuracy', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='fallopian_tube_lesion' AND `language_label`='fallopian tube lesion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fallopian_tube_lesion')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='presence_of_precursor_of_benign_lesions' AND `language_label`='presence of precursor of benign lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_presence_of_precursor_of_benign_lesions')  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `language_label`='age at diagnosis' AND `language_tag`='' AND `type`='integer' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='laterality' AND `language_label`='laterality' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology')  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='0_to_3')  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_figo')  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='residual_disease' AND `language_label`='residual disease' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_residual_disease')  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_progression_recurrence' AND `language_label`='date of progession/recurrence' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_progression_recurrence_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='site_1_of_tumor_progression' AND `language_label`='site 1 of tumor progression (metastasis) if applicable' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='site_2_of_tumor_progression' AND `language_label`='site 2 of tumor progression (metastasis) if applicable' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='survival_from_ovarectomy_in_months' AND `language_label`='survival from ovarectomy (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='progression_time_in_months' AND `language_label`='progression time (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='follow_up_from_ovarectomy_in_months' AND `language_label`='follow up from ovarectomy (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_laterality')  WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_eocs' AND field='laterality' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='laterality'); 

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_tf_dxd_other_primary_cancer', '', '', '1', '1', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'age_at_dx', 'age at dx', '', 'integer', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'tumor_site', 'tumor site', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'laterality', 'laterality', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'histopathology', 'histopathology', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology_opc') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_stage_summary', 'stage', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_stage') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'date_of_progression_recurrence', 'date of progression recurrence', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'date_of_progression_recurrence_accuracy', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'site_of_tumor_progression', 'site of tumor progression', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_other_primary_cancers', 'survival_in_months', 'survival (months)', '', 'float_positive', 'size=3', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'diagnosis date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  ), '1', '2', '', '0', '', '1', 'accuracy', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `language_label`='age at dx' AND `language_tag`='' AND `type`='integer' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='tumor_site' AND `language_label`='tumor site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='laterality' AND `language_label`='laterality' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_histopathology_opc')  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='0_to_3')  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `language_label`='stage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_stage')  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='date_of_progression_recurrence' AND `language_label`='date of progression recurrence' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='date_of_progression_recurrence_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='site_of_tumor_progression' AND `language_label`='site of tumor progression' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_other_primary_cancers' AND `field`='survival_in_months' AND `language_label`='survival (months)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');



-- end of dx --

-- tx (not used anymore, delete ?) --

CREATE TABLE qc_tf_tx_eocs(
 `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `tx_master_id` INT NOT NULL,
 `ca125_precision` VARCHAR(50) NOT NULL DEFAULT '',
 `ct_scan_precision` VARCHAR(50) NOT NULL DEFAULT '',
 FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters`(`id`),
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `created_by` int(10) unsigned NOT NULL,
 `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `modified_by` int(10) unsigned NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `deleted_date` datetime DEFAULT NULL
)Engine=InnoDb;
CREATE TABLE qc_tf_tx_eocs_revs(
 `id` INT UNSIGNED NOT NULL,
 `tx_master_id` INT NOT NULL,
 `ca125_precision` VARCHAR(50) NOT NULL DEFAULT '',
 `ct_scan_precision` VARCHAR(50) NOT NULL DEFAULT '',
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
CREATE TABLE qc_tf_tx_empty(
 `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `tx_master_id` INT NOT NULL,
 FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters`(`id`),
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `created_by` int(10) unsigned NOT NULL,
 `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `modified_by` int(10) unsigned NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `deleted_date` datetime DEFAULT NULL
)Engine=InnoDb;
CREATE TABLE qc_tf_tx_empty_revs(
 `id` INT UNSIGNED NOT NULL,
 `tx_master_id` INT NOT NULL,
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


INSERT INTO drugs (`generic_name`, `trade_name`, `type`) VALUES
('cisplatinum', 'cisplatinum', 'chemotherapy'),
('carboplatinum', 'carboplatinum', 'chemotherapy'),
('oxaliplatinum', 'oxaliplatinum', 'chemotherapy'),
('paclitaxel', 'paclitaxel', 'chemotherapy'),
('topotecan', 'topotecan', 'chemotherapy'),
('ectoposide', 'ectoposide', 'chemotherapy'),
('tamoxifen', 'tamoxifen', 'chemotherapy'),
('doxetaxel', 'doxetaxel', 'chemotherapy'),
('doxorubicin', 'doxorubicin', 'chemotherapy'),
('other', 'other', 'chemotherapy');
INSERT INTO drugs_revs (`generic_name`, `trade_name`, `type`) VALUES
('cisplatinum', 'cisplatinum', 'chemotherapy'),
('carboplatinum', 'carboplatinum', 'chemotherapy'),
('oxaliplatinum', 'oxaliplatinum', 'chemotherapy'),
('paclitaxel', 'paclitaxel', 'chemotherapy'),
('topotecan', 'topotecan', 'chemotherapy'),
('ectoposide', 'ectoposide', 'chemotherapy'),
('tamoxifen', 'tamoxifen', 'chemotherapy'),
('doxetaxel', 'doxetaxel', 'chemotherapy'),
('doxorubicin', 'doxorubicin', 'chemotherapy'),
('other', 'other', 'chemotherapy');

UPDATE tx_controls SET flag_active=0;
INSERT INTO tx_controls (`tx_method`, `flag_active`, `detail_tablename`, `form_alias`, `applied_protocol_control_id`, `extended_data_import_process`, `extend_tablename`, `extend_form_alias`) VALUES
('chemotherapy', 1, 'qc_tf_tx_eocs', 'qc_tf_tx_eocs', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos'),
('surgery(ovarectomy)', 1, 'qc_tf_tx_eocs', 'qc_tf_tx_eocs', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos'),
('surgery(other)', 1, 'qc_tf_tx_eocs', 'qc_tf_tx_eocs', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos'),
('surgery', 1, '', 'treatmentmasters', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos'),
('primary cancer chimiotherapy', 1, 'qc_tf_tx_empty', 'treatmentmasters', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos'),
('radiotherapy', 1, 'qc_tf_tx_empty', 'treatmentmasters', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos'),
('hormonal therapy', 1, 'qc_tf_tx_empty', 'treatmentmasters', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos'),
('other', 1, 'qc_tf_tx_empty', 'treatmentmasters', 1, 'importDrugFromChemoProtocol', 'txe_chemos', 'txe_chemos');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_tf_tx_eocs', '', '', '1', '1', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'TreatmentDetail', 'qc_tf_tx_eocs', 'ca125_precision', 'ca125 precision', '', 'float_positive', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', 'qc_tf_tx_eocs', 'ct_scan_precision', 'ct scan precision', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ct_scan_precision') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_tx_eocs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `language_label`='start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_tx_eocs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  ), '1', '2', '', '0', '', '1', 'accuracy', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_tx_eocs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_tx_eocs' AND `field`='ca125_precision' AND `language_label`='ca125 precision' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_tx_eocs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_tx_eocs' AND `field`='ct_scan_precision' AND `language_label`='ct scan precision' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ct_scan_precision')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

UPDATE structure_fields SET  `language_label`='type',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list')  WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='disease_site' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='tx_method' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list'));
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='disease_site' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list'));
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='start_date' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='start_date_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));

-- end of tx --

-- event --

CREATE TABLE qc_tf_ed_eocs(
 `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `event_master_id` INT NOT NULL,
 `date_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `event_date_end` date DEFAULT NULL,
 `event_date_end_accuracy` VARCHAR(5) NOT NULL DEFAULT '',
 `drug1` VARCHAR(50) NOT NULL DEFAULT '',
 `drug2` VARCHAR(50) NOT NULL DEFAULT '',
 `drug3` VARCHAR(50) NOT NULL DEFAULT '',
 `drug4` VARCHAR(50) NOT NULL DEFAULT '',
 `m_event_type` VARCHAR(50) NOT NULL DEFAULT '',
 `ca125_precision` VARCHAR(50) NOT NULL DEFAULT '',
 `ct_scan_precision` VARCHAR(50) NOT NULL DEFAULT '',
 FOREIGN KEY (`event_master_id`) REFERENCES `event_masters`(`id`),
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `created_by` int(10) unsigned NOT NULL,
 `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `modified_by` int(10) unsigned NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `deleted_date` datetime DEFAULT NULL
)Engine=InnoDb;
CREATE TABLE qc_tf_ed_eocs_revs(
 `id` INT UNSIGNED NOT NULL,
 `event_master_id` INT NOT NULL,
 `date_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `event_date_end` date DEFAULT NULL,
 `event_date_end_accuracy` VARCHAR(5) NOT NULL DEFAULT '',
 `drug1` VARCHAR(50) NOT NULL DEFAULT '',
 `drug2` VARCHAR(50) NOT NULL DEFAULT '',
 `drug3` VARCHAR(50) NOT NULL DEFAULT '',
 `drug4` VARCHAR(50) NOT NULL DEFAULT '',
 `m_event_type` VARCHAR(50) NOT NULL DEFAULT '',
 `ca125_precision` VARCHAR(50) NOT NULL DEFAULT '',
 `ct_scan_precision` VARCHAR(50) NOT NULL DEFAULT '',
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
CREATE TABLE qc_tf_ed_other_primary_cancers(
 `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `event_master_id` INT NOT NULL,
 `date_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `end_date` DATE DEFAULT NULL,
 `end_date_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `drug1` VARCHAR(50) NOT NULL DEFAULT '',
 `drug2` VARCHAR(50) NOT NULL DEFAULT '',
 `drug3` VARCHAR(50) NOT NULL DEFAULT '',
 `drug4` VARCHAR(50) NOT NULL DEFAULT '',
 `m_event_type` VARCHAR(50) NOT NULL DEFAULT '',
 FOREIGN KEY (`event_master_id`) REFERENCES `event_masters`(`id`),
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `created_by` int(10) unsigned NOT NULL,
 `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `modified_by` int(10) unsigned NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `deleted_date` datetime DEFAULT NULL
)Engine=InnoDb;
CREATE TABLE qc_tf_ed_other_primary_cancers_revs(
 `id` INT UNSIGNED NOT NULL,
 `event_master_id` INT NOT NULL,
 `date_accuracy` VARCHAR(50) NOT NULL DEFAULT '',
 `drug1` VARCHAR(50) NOT NULL DEFAULT '',
 `drug2` VARCHAR(50) NOT NULL DEFAULT '',
 `drug3` VARCHAR(50) NOT NULL DEFAULT '',
 `drug4` VARCHAR(50) NOT NULL DEFAULT '',
 `m_event_type` VARCHAR(50) NOT NULL DEFAULT '',
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

UPDATE event_controls SET flag_active=0;
INSERT INTO event_controls (`event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`) VALUES
('clinical', 'eoc', 1, 'qc_tf_event_eoc', 'qc_tf_ed_eocs'),
('clinical', 'other primary cancer', 1, 'qc_tf_ed_other_primary_cancer', 'qc_tf_ed_other_primary_cancers');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_eoc_event_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('biopsy', "biopsy"),
("surgery (ovarectomy)", "surgery (ovarectomy)"),
("surgery (other)", "surgery (other)"),
("chimiotherapy", "chimiotherapy"),
("ca125", "ca125"),
("ct scan", "ct scan");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_eoc_event_type"),  id, "", "1" FROM structure_permissible_values WHERE
(value='biopsy' AND language_alias='biopsy') OR
(value='surgery (ovarectomy)' AND language_alias='surgery (ovarectomy)') OR
(value='surgery (other)' AND language_alias='surgery (other)') OR
(value='chimiotherapy' AND language_alias='chimiotherapy') OR
(value='ca125' AND language_alias='ca125') OR
(value='ct scan' AND language_alias='ct scan'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_other_primary_cancer_event_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('biopsy', 'biopsy'),
('surgery', 'surgery'),
('chimiotherapy', 'chimiotherapy'),
('radiology', 'radiology'),
('radiotherapy', 'radiotherapy'),
('hormonal therapy', 'hormonal therapy'),
('other', 'other');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_other_primary_cancer_event_type"),  id, "", "1" FROM structure_permissible_values WHERE
(value='biopsy' AND language_alias='biopsy') OR
(value='surgery' AND language_alias='surgery') OR
(value='chimiotherapy' AND language_alias='chimiotherapy') OR
(value='radiology' AND language_alias='radiology') OR
(value='radiotherapy' AND language_alias='radiotherapy') OR
(value='hormonal therapy' AND language_alias='hormonal therapy') OR
(value='other' AND language_alias='other'));


INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_eoc_event_drug', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('cisplatinum', 'cisplatinum'),
('carboplatinum', 'carboplatinum'),
('oxaliplatinum', 'oxaliplatinum'),
('paclitaxel', 'paclitaxel'),
('topotecan', 'topotecan'),
('etoposide', 'etoposide'),
('tamoxifen', 'tamoxifen'),
('doxetaxel', 'doxetaxel'),
('doxorubicin', 'doxorubicin'),
('gemcitabine', 'gemcitabine'),
('vinorelbine', 'vinorelbine'),
('procytox', 'procytox'),
('unknown', 'unknown'),
('other', 'other');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_eoc_event_drug"),  id, "", "1" FROM structure_permissible_values WHERE
(value='cisplatinum' AND language_alias='cisplatinum') OR
(value='carboplatinum' AND language_alias='carboplatinum') OR
(value='oxaliplatinum' AND language_alias='oxaliplatinum') OR
(value='paclitaxel' AND language_alias='paclitaxel') OR
(value='topotecan' AND language_alias='topotecan') OR
(value='etoposide' AND language_alias='etoposide') OR
(value='tamoxifen' AND language_alias='tamoxifen') OR
(value='doxetaxel' AND language_alias='doxetaxel') OR
(value='doxorubicin' AND language_alias='doxorubicin') OR
(value='gemcitabine' AND language_alias='gemcitabine') OR
(value='vinorelbine' AND language_alias='vinorelbine') OR
(value='procytox' AND language_alias='procytox') OR
(value='unknown' AND language_alias='unknown') OR
(value='other' AND language_alias='other'));

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_other_primary_cancer_event_drug', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('other', 'other'),
('cisplatinum', 'cisplatinum'),
('carboplatinum', 'carboplatinum'),
('oxaliplatin', 'oxaliplatin'),
('paclitaxel', 'paclitaxel'),
('topotecan', 'topotecan'),
('ectoposide', 'ectoposide'),
('tamoxifen', 'tamoxifen'),
('doxetaxel', 'doxetaxel'),
('doxorubicin', 'doxorubicin');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_other_primary_cancer_event_drug"),  id, "", "1" FROM structure_permissible_values WHERE
(value='other' AND language_alias='other') OR
(value='cisplatinum' AND language_alias='cisplatinum') OR
(value='carboplatinum' AND language_alias='carboplatinum') OR
(value='oxaliplatin' AND language_alias='oxaliplatin') OR
(value='paclitaxel' AND language_alias='paclitaxel') OR
(value='topotecan' AND language_alias='topotecan') OR
(value='ectoposide' AND language_alias='ectoposide') OR
(value='tamoxifen' AND language_alias='tamoxifen') OR
(value='doxetaxel' AND language_alias='doxetaxel') OR
(value='doxorubicin' AND language_alias='doxorubicin'));

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_tf_event_eoc', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventMaster', 'event_masters', 'event_type', 'event', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventMaster', 'qc_tf_ed_eocs', 'm_event_type', 'event type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_type') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'date_accuracy', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'event_date_end', 'date of event (end)', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'event_date_end_accuracy', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'ca125_precision', 'ca125 precision (u)', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'ct_scan_precision', 'ct scan precision', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ct_scan_precision') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'drug1', 'drug 1', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'drug2', 'drug 2', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'drug3', 'drug 3', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_eocs', 'drug4', 'drug 4', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='event' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='qc_tf_ed_eocs' AND `field`='m_event_type' AND `language_label`='event type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_type')  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  ), '1', '3', '', '1', 'date of event (beginning)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='date_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='event_date_end' AND `language_label`='date of event (end)' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='event_date_end_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='ca125_precision' AND `language_label`='ca125 precision (u)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='ct_scan_precision' AND `language_label`='ct scan precision' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ct_scan_precision')  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='drug1' AND `language_label`='drug 1' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug')  AND `language_help`=''), '2', '9', 'Chimiotherapy Precision', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='drug2' AND `language_label`='drug 2' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug')  AND `language_help`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='drug3' AND `language_label`='drug 3' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug')  AND `language_help`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_event_eoc'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_eocs' AND `field`='drug4' AND `language_label`='drug 4' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_drug')  AND `language_help`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_tf_ed_other_primary_cancer', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_other_primary_cancers', 'date_accuracy', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_other_primary_cancers', 'm_event_type', 'event type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_type') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_other_primary_cancers', 'drug2', 'drug 2', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_other_primary_cancers', 'drug3', 'drug 3', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_other_primary_cancers', 'drug4', 'drug 4', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_tf_ed_other_primary_cancers', 'drug1', 'drug 1', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='event' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  ), '1', '2', '', '1', 'date of event', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_other_primary_cancers' AND `field`='date_accuracy' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_other_primary_cancers' AND `field`='m_event_type' AND `language_label`='event type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_type')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_other_primary_cancers' AND `field`='drug2' AND `language_label`='drug 2' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug')  AND `language_help`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_other_primary_cancers' AND `field`='drug3' AND `language_label`='drug 3' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug')  AND `language_help`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_other_primary_cancers' AND `field`='drug4' AND `language_label`='drug 4' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug')  AND `language_help`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_other_primary_cancer'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_other_primary_cancers' AND `field`='drug1' AND `language_label`='drug 1' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_other_primary_cancer_event_drug')  AND `language_help`=''), '2', '5', 'Chimiotherapy Precision', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');


-- end of event --

REPLACE INTO i18n (`id`, `en`, `fr`) VALUES
#("primary cancer chimiotherapy", "Primary cancer chemotherapy", "Chimiothérapie du cancer primaire?"),
#("radiotherapy", "Radiotherapy", ""),
#("surgery(ovarectomy)", "Surgery (ovarectomy)", "Chirurgie (ovarectomie?)"),
#("EOC", "EOC", "EOC"),
#("fallopian tube lesion", "Fallopian tube lesion", "Lésion du tube ?"), 
#("figo", "figo", "figo")
("registered date of death", "Registered date of death", "Date de la mort enregistrée"),
("suspected date of death", "Suspected date of death", "Date de la mort estimée"),
("biopsy", "Biopsy", "Biopsie"),
("event date", "Event date", "Date de l'événement"),
("ca125 precision", "CA125 precision", "CA125 précision"),
("ct scan precision", "CT scan precision", "CT scan précision"),
("hormonal therapy", "hormonal therapy", "Thérapie hormonale"),
("surgery(other)", "Surgery (other)", "Chirurgie (autre)"),
("brca status", "BRCA status", "BRCA status"),
("other primary cancer", "Other primary cancer", "Autre cancer primaire"),
("survival (months)", "Survival (months)", "Survie (mois)"),
("diagnosis date", "Diagnosis date", "Date du diagnostic"),
("tumor site", "Tumor site", "Site tumoral"),
("hitopathology", "Histopathology", "Histopathologie?"),
("stage", "Stage", "Stade"),
("date of progression recurrence", "Date of progression/recurrence", "Date de progression/Récurrence"),
("site of tumor progression", "Site of tumor progression", "Site de progression tumorale"),
("presence of precursor of benign lesions", "Presence of precursor of benign lesions", "Présence de lésions bénignes précurseures"),
("age at diagnosis", "Age at diagnosis", "Âge au diagnostic"),
("residual disease", "Residual disease", "Maladie résiduelle"),
("site of tumor progression (metastasis) if applicable", "Site of tumor progression (metastasis) if applicable", "Site de la progression tumorale (métastase) si applicable"),
("date of last contact", "Date of last contact", "Date du dernier contact");


-- collections add
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='collection_site' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='collection_property' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='collection_notes' AND type='textarea' AND structure_value_domain  IS NULL );
-- collections view
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection' AND tablename='' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list'));
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection' AND tablename='' AND field='collection_notes' AND type='textarea' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection' AND tablename='' AND field='collection_property' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property'));
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewCollection' AND tablename='' AND field='collection_site' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site'));

-- spe tissue
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_flash_frozen_volume_unit', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('gr', 'gr'),
('mm³', 'mm³');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_flash_frozen_volume_unit"),  id, "", "1" FROM structure_permissible_values WHERE
(value='gr' AND language_alias='gr') OR
(value='mm³' AND language_alias='mm³'));

INSERT INTO structure_permissible_values_custom_controls (name, flag_active) VALUES
("tissue source", 1);
SET @last_id=LAST_INSERT_ID();
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) VALUES
(@last_id, 'ovary', 'Ovary', 'Ovaire'),
(@last_id, 'peritoneum', 'Peritoneum', 'Péritoine');
UPDATE structure_value_domains SET source="StructurePermissibleValuesCustom::getCustomDropdown('tissue source')" WHERE domain_name='tissue_source_list';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='is_problematic' AND type='radio' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='supplier_dept' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='pathology_reception_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='tissue_size' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_datetime_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Generated' AND tablename='' AND field='coll_to_rec_spent_time_msg' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='tissue_size_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='tissue_weight' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='tissue_weight_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit'));

-- tissue tube
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ad_spec_tubes_vol', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'initial_volume', 'initial volume', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_volume_unit', '', 'unit', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_flash_frozen_volume_unit') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `language_label`='barcode' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `language_label`='aliquot type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `language_help`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `language_label`='aliquot in stock' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `language_help`='aliquot_in_stock_help'), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `language_label`='aliquot in stock detail' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  AND `language_help`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_use_counter' AND `language_label`='use' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_master_id' AND `language_label`='storage code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `language_label`='position into storage' AND `language_tag`='' AND `type`='input' AND `setting`='size=4' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=4' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `language_label`='initial storage date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `language_label`='storage temperature' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code' AND `language_label`='storage code' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `language_label`='lot number' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='rec_to_stor_spent_time_msg' AND `language_label`='reception to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_stor_spent_time_msg' AND `language_label`='collection to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `language_label`='aliquot sop' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list')  AND `language_help`=''), '0', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `language_help`=''), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `language_label`='storage' AND `language_tag`='storage selection label' AND `type`='autocomplete' AND `setting`='url=/storagelayout/storage_masters/autocompleteLabel' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `language_label`='storage' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='stor_selection_label_defintion'), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `language_help`=''), '0', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `language_label`='copy control' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `language_label`='initial volume' AND `language_tag`='' AND `type`='float' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='unit' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_flash_frozen_volume_unit')  AND `language_help`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT INTO `aliquot_controls` (`id` ,`aliquot_type` ,`aliquot_type_precision` ,`form_alias` ,`detail_tablename` ,`volume_unit` ,`comment` ,`display_order` ,`databrowser_label`) VALUES 
(NULL , 'tube', 'specimen tube with volume', 'ad_spec_tubes_vol', 'ad_tubes', NULL , NULL , '0', 'tube');
SET @last_id=LAST_INSERT_ID();
UPDATE sample_to_aliquot_controls SET aliquot_control_id=@last_id WHERE sample_control_id=(SELECT id FROM sample_controls WHERE sample_type='tissue') AND aliquot_control_id=1; 


-- spe ascite

UPDATE structure_formats SET `flag_override_default`='1', `default`='ml', `flag_add`='1', `flag_add_readonly`='1', `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='1', `flag_search_readonly`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='collected_volume_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='supplier_dept' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_datetime_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='is_problematic' AND type='radio' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sample_code' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`=0 WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='collected_volume' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`=0 WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='collected_volume_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit'));
UPDATE structure_formats SET `flag_override_default`='1', `default`='ml', `flag_add`='1', `flag_add_readonly`='1', `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='1', `flag_datagrid`='1', `flag_datagrid_readonly`='1', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='collected_volume_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit'));
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_ascites') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Generated' AND tablename='' AND field='coll_to_rec_spent_time_msg' AND type='input' AND structure_value_domain  IS NULL );

-- blocks
UPDATE structure_value_domains_permissible_values SET flag_active=false WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='frozen');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_volume_unit', '', 'unit', 'input', '', 'mm³',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  ), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='unit' AND `type`='input' AND `setting`='' AND `default`='mm³' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
UPDATE structure_fields SET  `setting`='size=3',  `default`='mm³' WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='aliquot_volume_unit' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='initial_volume' AND type='float' AND structure_value_domain  IS NULL );




-- spe blood
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='is_problematic' AND type='radio' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='supplier_dept' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='collected_volume_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='collected_tube_nbr' AND type='integer_positive' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SpecimenDetail' AND tablename='' AND field='reception_datetime_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Generated' AND tablename='' AND field='coll_to_rec_spent_time_msg' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleDetail' AND tablename='' AND field='blood_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type'));

-- undetailed derivatives (dna)
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='is_problematic' AND type='radio' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DerivativeDetail' AND tablename='' AND field='creation_site' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DerivativeDetail' AND tablename='' AND field='creation_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DerivativeDetail' AND tablename='' AND field='creation_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Generated' AND tablename='' AND field='coll_to_creation_spent_time_msg' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DerivativeDetail' AND tablename='' AND field='creation_datetime_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));



-- disable menus --
UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_9';
UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_24';
UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_10';
UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_68';
UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_26';
UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_25';

-- inventory --
UPDATE parent_to_derivative_sample_controls SET flag_active = 0 WHERE parent_sample_control_id = 1;
UPDATE sample_to_aliquot_controls SET flag_active = 0 WHERE sample_control_id = 1;
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(1, 25, 3, 4, 142, 143, 141, 144, 7, 130, 101, 102, 140, 118, 8, 9);
UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(41, 8);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(7, 8, 6, 5, 4);

DELETE FROM banks;
ALTER TABLE banks AUTO_INCREMENT=1;

INSERT INTO banks(`name`, `description`, `created_by`, `created`, `modified_by`, `modified`) VALUES
('CHUM-COEUR', '', 1, NOW(), 1, NOW()),
('CHUS-COEUR', '', 1, NOW(), 1, NOW()),
('TTR-COEUR', '', 1, NOW(), 1, NOW()),
('McGill-COEUR', '', 1, NOW(), 1, NOW());

ALTER TABLE ad_blocks
 ADD COLUMN qc_tf_flash_frozen_volume VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN qc_tf_flash_frozen_volume_unit ENUM('', 'gr', 'mm3') NOT NULL DEFAULT '';
 
INSERT INTO misc_identifier_controls (misc_identifier_name, misc_identifier_name_abbrev, flag_once_per_participant) VALUES
('CHUM-COEUR', 'CHUM-COEUR', 1),
('CHUS-COEUR', 'CHUS-COEUR', 1),
('TTR-COEUR', 'TTR-COEUR', 1),
('McGill-COEUR', 'McGill-COEUR', 1);

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_24');


