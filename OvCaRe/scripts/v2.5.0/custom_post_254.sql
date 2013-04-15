UPDATE `versions` SET branch_build_number = 'xxx' WHERE version_number = '2.5.4';

UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE id = 'clin_CAN_4';

UPDATE consent_controls SET detail_form_alias = '' WHERE controls_type = 'ovcare';

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`) VALUES
(null, 'bcca number', 1, 0, '', NULL, 1, 1, 1, 0, '', '');
INSERT INTO i18n (id,en) VALUES ('bcca number','BCCA Number');

UPDATE treatment_controls SET extend_tablename = 'txe_chemos', extend_form_alias = 'txe_chemos' WHERE tx_method = 'chemotherapy' AND disease_site = 'ovcare';
UPDATE menus SET flag_active = 1 WHERE use_link like '/Drug/Drugs/%';

UPDATE treatment_controls SET extend_tablename = 'txe_surgeries', extend_form_alias = 'txe_surgeries' WHERE tx_method = 'surgery' AND disease_site = 'ovcare';
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_surgery_procedure_type', "StructurePermissibleValuesCustom::getCustomDropdown('Surgery type')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Surgery type', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgery type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('hysterectomy','Hysterectomy', '', '1', @control_id),
('l. oophorectomy','L. Oophorectomy', '', '1', @control_id),
('r. oophorectomy','R. Oophorectomy', '', '1', @control_id),
('l. salpingectomy','L. Salpingectomy', '', '1', @control_id),
('r. salpingectomy','R. Salpingectomy', '', '1', @control_id),
('omentectomy','Omentectomy', '', '1', @control_id),
('omental biopsy','Omental Biopsy', '', '1', @control_id),
('cul de sac biopsy','Cul de Sac Biopsy', '', '1', @control_id),
('paracentesis','Paracentesis', '', '1', @control_id),
('pelvic lymphadnectomy','Pelvic Lymphadnectomy', '', '1', @control_id),
('pelvic sidewall biopsy','Pelvic Sidewall Biopsy', '', '1', @control_id),
('Bladder peritoneum biopsy','Bladder Peritoneum Biopsy', '', '1', @control_id),
('para-aortic lymphadnectomy','Para-aortic Lymphadnectomy', '', '1', @control_id),
('hemicolectomy','Hemicolectomy', '', '1', @control_id),
('sigmoid colon','Sigmoid Colon', '', '1', @control_id),
('transverse colon','Transverse Colon', '', '1', @control_id),
('large bowel','Large Bowel', '', '1', @control_id),
('small bowel','Small Bowel', '', '1', @control_id),
('right colon','Right Colon', '', '1', @control_id),
('appendectomy','Appendectomy', '', '1', @control_id),
('liver resection','Liver Resection', '', '1', @control_id),
('vaginal biopsy','Vaginal Biopsy', '', '1', @control_id),
('core biopsy','Core Biopsy', '', '1', @control_id),
('uterine myomectomy','Uterine Myomectomy', '', '1', @control_id),
('miscellaneous debulking','Miscellaneous Debulking', '', '1', @control_id);
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_surgery_procedure_type') ,  `setting`='',  `language_help`='' WHERE model='TreatmentExtend' AND tablename='txe_surgeries' AND field='surgical_procedure' AND `type`='input' AND structure_value_domain  IS NULL ;
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE model='TreatmentExtend' AND tablename='txe_surgeries' AND field='surgical_procedure'), 'notEmpty');

UPDATE menus SET flag_active = '1' WHERE language_title = 'clin_study';
INSERT INTO study_summaries (`title`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Intratumoural Heterogenity', NOW(), NOW(), 1, 1),
('High Grade Endometrial', NOW(), NOW(), 1, 1),
('TFRI COEUR', NOW(), NOW(), 1, 1),
('TCGA', NOW(), NOW(), 1, 1),
('Tumour Bank TMA', NOW(), NOW(), 1, 1),
('Endometriosis', NOW(), NOW(), 1, 1),
('Ovarian Cancer Diagnosis', NOW(), NOW(), 1, 1),
('Precursor to Prevention (TICS)', NOW(), NOW(), 1, 1),
('Fimbrial Scraping for Culture', NOW(), NOW(), 1, 1),
('Xenograft', NOW(), NOW(), 1, 1),
('Cell Culture', NOW(), NOW(), 1, 1);
INSERT INTO study_summaries_revs (`id`, `title`, `modified_by`, `version_created`) 
(SELECT id, title, created_by, created FROM  study_summaries);

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'ovcare', 'study', 'study inclusion', 1, 'ovcare_ed_study_inclusions', 'ovcare_ed_study_inclusions', 0, 'study inclusion', 1);
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_study_inclusions');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_study_inclusions', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
CREATE TABLE IF NOT EXISTS `ovcare_ed_study_inclusions` (
  `study_summary_id` int(11) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ovcare_ed_study_inclusions_revs` (
  `study_summary_id` int(11) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `ovcare_ed_study_inclusions`
  ADD CONSTRAINT `ovcare_ed_study_inclusions_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id'), 'notEmpty');
INSERT INTO i18n (id,en) VALUES ('study inclusion','Study Inclusion ');

UPDATE event_controls SET databrowser_label = event_type WHERE flag_active = 1;
UPDATE treatment_controls SET databrowser_label = tx_method WHERE flag_active = 1;

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('ovcare_clin_CAN_4', 'clin_CAN_4', 0, 6, 'experimental tests', 'experimental tests', '/ClinicalAnnotation/EventMasters/listall/experimental_tests/%%Participant.id%%', 'ClinicalAnnotation.EventMaster::summary', 1, 1);
UPDATE event_controls SET `event_group` = 'experimental_tests' WHERE detail_form_alias = 'ovcare_ed_lab_experimental_tests';

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_override_help`='1', `language_help`='ovcare_event_masters_date_help', `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', flag_editgrid = '0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET language_label = 'date' WHERE tablename = 'event_masters' AND field = 'event_date';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_lab_experimental_tests'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '1', 'date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_lab_experimental_tests'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '1', 'inclusion date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('inclusion date','Inclusion Date');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'ovcare', 'lab', 'pathology report', 1, 'ovcare_ed_pathology_reports', 'ovcare_ed_pathology_reports', 0, 'pathology report', 1);
CREATE TABLE IF NOT EXISTS `ovcare_ed_pathology_reports` (	
	phn varchar(50) default null,
	pathologist_msc_nbr varchar(50) default null,
	report_type varchar(50) default null,
	date_of_procedure date default null,
	date_of_procedure_accuracy char(1) NOT NULL DEFAULT '',
	cytologic_specimen char(1) default '',
	cytologic_specimen_precision varchar(50) default null,
	cytopathology_nbr varchar(50) default null,
	cytopathology_source_hospital varchar(50) default null,
	histologic_specimen char(1) default '',
	histologic_specimen_precision varchar(50) default null,
	histopathology_nbr varchar(30) default null,
	histopathology_source_hospital varchar(50) default null,
	cytologic_specimen_result varchar(50) default null,
	cytologic_specimen_result_precision varchar(250) default null,
	histologic_specimen_classification varchar(50) default null,
	histologic_specimen_classification_precision varchar(250) default null,
	apparent_pathological_stage varchar(10) default null,
	event_master_id int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ovcare_ed_study_inclusions_revs` (	
	phn varchar(50) default null,
	pathologist_msc_nbr varchar(50) default null,
	report_type varchar(50) default null,
	date_of_procedure date default null,
	date_of_procedure_accuracy char(1) NOT NULL DEFAULT '',
	cytologic_specimen char(1) default '',
	cytologic_specimen_precision varchar(50) default null,
	cytopathology_nbr varchar(50) default null,
	cytopathology_source_hospital varchar(50) default null,
	histologic_specimen char(1) default '',
	histologic_specimen_precision varchar(50) default null,
	histopathology_nbr varchar(30) default null,
	histopathology_source_hospital varchar(50) default null,
	cytologic_specimen_result varchar(50) default null,
	cytologic_specimen_result_precision varchar(250) default null,
	histologic_specimen_classification varchar(50) default null,
	histologic_specimen_classification_precision varchar(250) default null,
	apparent_pathological_stage varchar(10) default null,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `ovcare_ed_pathology_reports`
  ADD CONSTRAINT `ovcare_ed_pathology_reports_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_pathology_reports');
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_patho_report_type', "StructurePermissibleValuesCustom::getCustomDropdown('Pathology report type')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Pathology report type', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Pathology report type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('primary report','Primary report', '', '1', @control_id),
('pathology review','Pathology Review', '', '1', @control_id);
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_cytologic_specimen', "StructurePermissibleValuesCustom::getCustomDropdown('Cytologic specimen')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Cytologic specimen', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Cytologic specimen');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('ascites','Ascites', '', '1', @control_id),
('peritoneal washings','Peritoneal washings', '', '1', @control_id),
('pleural fluid','Pleural fluid', '', '1', @control_id),
('FNA','FNA', '', '1', @control_id);
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_source_hospital', "StructurePermissibleValuesCustom::getCustomDropdown('Source hospital')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Source hospital', '1', '50');
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_histologic_specimen', "StructurePermissibleValuesCustom::getCustomDropdown('Histologic specimen')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Histologic specimen', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Histologic specimen');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('resection specimen with or without biopsy','Resection specimen with or without biopsy', '', '1', @control_id),
('biopsy only','Biopsy only', '', '1', @control_id);
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_cytologic_specimen_result', "StructurePermissibleValuesCustom::getCustomDropdown('Cytologic specimen result')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Cytologic specimen result', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Cytologic specimen result');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('negative','Negative', '', '1', @control_id),
('positive','Positive', '', '1', @control_id),
('suspicious','Suspicious', '', '1', @control_id),
('unknown','Unknown', '', '1', @control_id);
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_histologic_specimen_classification', "StructurePermissibleValuesCustom::getCustomDropdown('Histologic specimen classification')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Histologic specimen classification', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Histologic specimen classification');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('HGS','HGS', '', '1', @control_id),
('LGS','LGS', '', '1', @control_id),
('endometrioid','Endometrioid', '', '1', @control_id),
('mucinous','Mucinous', '', '1', @control_id),
('clear cell','Clear Cell', '', '1', @control_id),
('mixed','Mixed', '', '1', @control_id),
('carcinoma, NOS','Carcinoma, NOS', '', '1', @control_id),
('borderline','Borderline', '', '1', @control_id),
('probable metastasis','Probable metastasis', '', '1', @control_id),
('benign','Benign', '', '1', @control_id),
('indeterminate for malignancy','Indeterminate for malignancy', '', '1', @control_id),
('other','Other', '', '1', @control_id);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ovcare_pathological_stage", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES
("pX", "pX"),
('pIa','pIa'),
('pIb','pIb'),
('pIc','pIc'),
('pIIa','pIIa'),
('pIIb','pIIb'),
('pIIc','pIIc'),
('pIII','pIII');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pX" AND language_alias="pX"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pIa" AND language_alias="pIa"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pIb" AND language_alias="pIb"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pIc" AND language_alias="pIc"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pIIa" AND language_alias="pIIa"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pIIb" AND language_alias="pIIb"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pIIc" AND language_alias="pIIc"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_pathological_stage"), 
(SELECT id FROM structure_permissible_values WHERE value="pIII" AND language_alias="pIII"), "8", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'phn', 'input',  NULL , '0', 'size=10', '', '', 'phn', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'pathologist_msc_nbr', 'input',  NULL , '0', 'size=10', '', '', 'pathologist msc nbr', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'report_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_patho_report_type') , '0', '', '', '', 'report type', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'date_of_procedure', 'date',  NULL , '0', '', '', '', 'procedure date', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'cytologic_specimen', 'yes_no',  NULL , '0', '', '', '', 'cytologic specimen', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'cytologic_specimen_precision', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_cytologic_specimen') , '0', 'size=30', '', '', 'cytologic specimen precision', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'cytopathology_nbr', 'input',  NULL , '0', 'size=10', '', '', 'cytopathology nbr', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'cytopathology_source_hospital', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_source_hospital') , '0', '', '', '', 'source hospital (cyto)', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'histologic_specimen', 'yes_no',  NULL , '0', '', '', '', 'histologic specimen', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'histologic_specimen_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histologic_specimen') , '0', '', '', '', 'histologic specimen precision', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'histopathology_nbr', 'input',  NULL , '0', 'size=10', '', '', 'histopathology nbr', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'histopathology_source_hospital', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_source_hospital') , '0', '', '', '', 'source hospital (histopatho)', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'cytologic_specimen_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_cytologic_specimen_result') , '0', '', '', '', 'cytologic specimen result', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'cytologic_specimen_result_precision', 'input',  NULL , '0', 'size=30', '', '', 'cytologic specimen result precision', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'histologic_specimen_classification', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histologic_specimen_classification') , '0', '', '', '', 'histologic specimen classification', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'histologic_specimen_classification_precision', 'input',  NULL , '0', 'size=30', '', '', 'histologic specimen classification precision', ''), 
('ClinicalAnnotation', 'EventMaster', 'ovcare_ed_pathology_reports', 'apparent_pathological_stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage') , '0', 'size=30', '', '', 'apparent stage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '1', 'report date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='phn' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='phn' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='pathologist_msc_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='pathologist msc nbr' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='report_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_patho_report_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='report type' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='date_of_procedure' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='procedure date' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytologic_specimen' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cytologic specimen' AND `language_tag`=''), '2', '50', 'sample type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytologic_specimen_precision' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_cytologic_specimen')  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='cytologic specimen precision' AND `language_tag`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytopathology_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='cytopathology nbr' AND `language_tag`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytopathology_source_hospital' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_source_hospital')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='source hospital (cyto)' AND `language_tag`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histologic_specimen' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic specimen' AND `language_tag`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histologic_specimen_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histologic_specimen')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic specimen precision' AND `language_tag`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histopathology_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='histopathology nbr' AND `language_tag`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histopathology_source_hospital' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_source_hospital')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='source hospital (histopatho)' AND `language_tag`=''), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytologic_specimen_result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_cytologic_specimen_result')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cytologic specimen result' AND `language_tag`=''), '2', '70', 'histotype', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytologic_specimen_result_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='cytologic specimen result precision' AND `language_tag`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histologic_specimen_classification' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histologic_specimen_classification')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic specimen classification' AND `language_tag`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histologic_specimen_classification_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='histologic specimen classification precision' AND `language_tag`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='apparent_pathological_stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage')  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='apparent stage' AND `language_tag`=''), '2', '80', 'pathological stage', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES
('apparent stage', 'Apparent stage'),
('cytologic specimen', 'Cytologic specimen'),
('cytologic specimen result', 'Cytologic specimen result'),
('cytopathology nbr', 'Cytopathology #'),
('histologic specimen', 'histologic specimen'),
('histologic specimen classification', 'Histologic specimen classification'),
('histopathology nbr', 'Histopathology #'),
('histotype', 'Histotype'),
('pathologist msc nbr', 'Pathologist''s MSC #'),
('pathology report', 'Pathology report'),
('phn', 'PHN'),
('pIa', 'pIa '),
('pIb', 'pIb '),
('pIc', 'pIc '),
('pIIa', 'pIIa'),
('pIIb', 'pIIb'),
('pIIc', 'pIIc'),
('pIII', 'pIII'),
('procedure date', 'Procedure date'),
('pX', 'pX'),
('report type', 'Report type '),
('source hospital (cyto)', 'Source hospital (Cyto.)'),
('source hospital (histopatho)', 'Source hospital (Histo.)');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_cytologic_specimen') ,  `setting`='' WHERE model='EventMaster' AND tablename='ovcare_ed_pathology_reports' AND field='cytologic_specimen_precision' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_cytologic_specimen');
REPLACE INTO i18n (id,en) VALUES 
('cytologic specimen precision', 'Specimen type');
INSERT INTO i18n (id,en) VALUES 
('histologic specimen precision', 'Specimen type'),
('cytologic specimen result precision', 'Cytologic precision '),
('histologic specimen classification precision', 'Histologic precision');
INSERT INTO i18n (id,en) VALUES ('ovcare_apparent_pathological_stage_help',
'pX: Cannot be assessed<br>	
pI: Tumour limited to one or both ovaries<br>
 - Ia: Limited to one ovary; capsule intact. No tumour on ovarian surface. No malignant cells in ascites or peritoneal washings.<br>	
 - Ib: Tumour limited to both ovaries; capsule intact. No tumour on ovarian surface. No malignant cells in ascites or peritoneal washings.<br>
 - Ic: Tumour limited to one or both ovaries with any of the following: capsule ruptured, tumour on ovarian surface, malignant cells in ascites or peritoneal washings.<br>
pII: Tumour involves ovaries with pelvic extensions and/or implants.<br>
 - IIa: Extension and/or implants on uterus and/or tube(s). No malignant cells in ascites or peritoneal washings.<br>	
 - IIb: Extension to other pelvic tissues. No malignant cells in ascites or peritoneal washings.<br>	
 - IIc: Pelvic extension and/or implants (IIa or IIb) with malignant cells in ascites or peritoneal washings.<br>
pIII:Tumour involves ovaries with microscopically confirmed peritoneal metastasis outside the pelvis (including liver capsule metastasis) and/or regional lymph node metastasis.');
UPDATE structure_fields SET model = 'EventDetail' WHERE tablename = 'ovcare_ed_pathology_reports';
UPDATE structure_formats SET `language_heading`='cytology' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytologic_specimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='histology' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histologic_specimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage') ,  `setting`='' WHERE model='EventDetail' AND tablename='ovcare_ed_pathology_reports' AND field='apparent_pathological_stage' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage') ,  `language_help`='ovcare_apparent_pathological_stage_help' WHERE model='EventDetail' AND tablename='ovcare_ed_pathology_reports' AND field='apparent_pathological_stage' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage');









//TODO
Complete....
		If Ic selected: select all that apply:
		Capsule rupture
		Ovarian surface involvement
		Malignant cells in ascites or peritoneal washings
		
				If IIc selected: Select all that apply:
		Capsule rupture
		Ovarian surface involvement
		Malignant cells in ascites or peritoneal washings
Check help message
	ovcare_event_masters_date_help
	ovcare_apparent_pathological_stage_help
	
	




