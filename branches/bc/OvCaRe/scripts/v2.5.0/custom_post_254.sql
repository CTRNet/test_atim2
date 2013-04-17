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
CREATE TABLE IF NOT EXISTS `ovcare_ed_pathology_reports_revs` (	
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
INSERT INTO i18n (id,en) VALUES ('ovcare_apparent_pathological_stage_help', 'pX: Cannot be assessed<br><br>pI: Tumour limited to one or both ovaries<br> - Ia: Limited to one ovary; capsule intact. No tumour on ovarian surface. No malignant cells in ascites or peritoneal washings.<br> - Ib: Tumour limited to both ovaries; capsule intact. No tumour on ovarian surface. No malignant cells in ascites or peritoneal washings.<br> - Ic: Tumour limited to one or both ovaries with any of the following: capsule ruptured, tumour on ovarian surface, malignant cells in ascites or peritoneal washings.<br><br>pII: Tumour involves ovaries with pelvic extensions and/or implants.<br> - IIa: Extension and/or implants on uterus and/or tube(s). No malignant cells in ascites or peritoneal washings.<br> - IIb: Extension to other pelvic tissues. No malignant cells in ascites or peritoneal washings.<br> - IIc: Pelvic extension and/or implants (IIa or IIb) with malignant cells in ascites or peritoneal washings.<br><br>pIII:Tumour involves ovaries with microscopically confirmed peritoneal metastasis outside the pelvis (including liver capsule metastasis) and/or regional lymph node metastasis.');
UPDATE structure_fields SET model = 'EventDetail' WHERE tablename = 'ovcare_ed_pathology_reports';
UPDATE structure_formats SET `language_heading`='cytology' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='cytologic_specimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='histology' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_pathology_reports' AND `field`='histologic_specimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage') ,  `setting`='' WHERE model='EventDetail' AND tablename='ovcare_ed_pathology_reports' AND field='apparent_pathological_stage' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage') ,  `language_help`='ovcare_apparent_pathological_stage_help' WHERE model='EventDetail' AND tablename='ovcare_ed_pathology_reports' AND field='apparent_pathological_stage' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathological_stage');

UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE 
structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_lab_experimental_tests') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0')
AND `language_label`!='last update date';

INSERT INTO i18n (id,en) VALUES ('ovcare_event_masters_date_help', 'According to data:<br> - Report Date<br> - Inclusion Date<br> - Last Update Date');

ALTER TABLE ovcare_ed_pathology_reports	ADD COLUMN apparent_pathological_stage_precision varchar(50) default null AFTER apparent_pathological_stage;
ALTER TABLE ovcare_ed_pathology_reports_revs ADD COLUMN apparent_pathological_stage_precision varchar(50) default null AFTER apparent_pathological_stage;
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_apparent_pathological_stage_precision', "StructurePermissibleValuesCustom::getCustomDropdown('Pathological stage precision')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Pathological stage precision', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Pathological stage precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('capsule rupture','Capsule rupture', '', '1', @control_id),
('ovarian surface involvement','Ovarian surface involvement', '', '1', @control_id),
('malignant cells in ascites or peritoneal washings','Malignant cells in ascites or peritoneal washings', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_pathology_reports', 'apparent_pathological_stage_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_apparent_pathological_stage_precision') , '0', '', '', '', 'stage precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_pathology_reports'), (SELECT id FROM structure_fields WHERE `tablename`='ovcare_ed_pathology_reports' AND `field`='apparent_pathological_stage_precision'), '2', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('stage precision','Stage precision');

REPLACE INTO i18n (id,en) VALUES ('personal health number','PHN');

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'phn' AND tablename = 'ovcare_ed_pathology_reports');
DELETE FROM structure_fields WHERE field = 'phn' AND tablename = 'ovcare_ed_pathology_reports';
ALTER TABLE ovcare_ed_pathology_reports DROP COLUMN phn;
ALTER TABLE ovcare_ed_pathology_reports_revs DROP COLUMN phn;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `tablename`='ovcare_dxd_ovaries' AND `field` IN ('review_grade','review_comment','review_diagnosis'));
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `tablename`='ovcare_dxd_ovaries' AND `field` IN ('review_grade','review_comment','review_diagnosis'));
DELETE FROM structure_fields WHERE `tablename`='ovcare_dxd_ovaries' AND `field` IN ('review_grade','review_comment','review_diagnosis');
ALTER TABLE ovcare_dxd_ovaries DROP COLUMN review_grade, DROP COLUMN review_comment, DROP COLUMN review_diagnosis;
ALTER TABLE ovcare_dxd_ovaries_revs DROP COLUMN review_grade, DROP COLUMN review_comment, DROP COLUMN review_diagnosis;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `tablename`='txd_surgeries' AND `field`='ovcare_procedure_performed');
DELETE FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `tablename`='txd_surgeries' AND `field`='ovcare_procedure_performed');
DELETE FROM structure_fields WHERE `tablename`='txd_surgeries' AND `field`='ovcare_procedure_performed';
ALTER TABLE txd_surgeries DROP COLUMN ovcare_procedure_performed;
ALTER TABLE txd_surgeries_revs DROP COLUMN ovcare_procedure_performed;

ALTER TABLE participants ADD COLUMN ovcare_neoadjuvant_chemotherapy char(1) DEFAULT '';
ALTER TABLE participants_revs ADD COLUMN ovcare_neoadjuvant_chemotherapy char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'ovcare_neoadjuvant_chemotherapy', 'yes_no',  NULL , '0', '', '', '', 'neoadjuvant chemotherapy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ovcare_neoadjuvant_chemotherapy' ), '3', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('neoadjuvant chemotherapy','Neoadjuvant chemotherapy given', '');

INSERT INTO structure_value_domains (domain_name) VALUES ("ovcare_tumor_site");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
('breast-breast', 'breast-breast'),
('central nervous system-brain', 'central nervous system-brain'),
('central nervous system-other central nervous system', 'central nervous system-other central nervous system'),
('central nervous system-spinal cord', 'central nervous system-spinal cord'),
('digestive-anal', 'digestive-anal'),
('digestive-appendix', 'digestive-appendix'),
('digestive-bile ducts', 'digestive-bile ducts'),
('digestive-colonic', 'digestive-colonic'),
('digestive-esophageal', 'digestive-esophageal'),
('digestive-gallbladder', 'digestive-gallbladder'),
('digestive-liver', 'digestive-liver'),
('digestive-other digestive', 'digestive-other digestive'),
('digestive-pancreas', 'digestive-pancreas'),
('digestive-rectal', 'digestive-rectal'),
('digestive-small intestine', 'digestive-small intestine'),
('digestive-stomach', 'digestive-stomach'),
('female genital-cervical', 'female genital-cervical'),
('female genital-endometrium', 'female genital-endometrium'),
('female genital-fallopian tube', 'female genital-fallopian tube'),
('female genital-gestational trophoblastic neoplasia', 'female genital-gestational trophoblastic neoplasia'),
('female genital-other female genital', 'female genital-other female genital'),
('female genital-ovary', 'female genital-ovary'),
('female genital-peritoneal pelvis abdomen', 'female genital-peritoneal pelvis abdomen'),
('female genital-uterine', 'female genital-uterine'),
('female genital-vagina', 'female genital-vagina'),
('female genital-vulva', 'female genital-vulva'),
('haematological-hodgkin''s disease', 'haematological-hodgkin''s disease'),
('haematological-leukemia', 'haematological-leukemia'),
('haematological-lymphoma', 'haematological-lymphoma'),
('haematological-non-hodgkin''s lymphomas', 'haematological-non-hodgkin''s lymphomas'),
('haematological-other haematological', 'haematological-other haematological'),
('head & neck-larynx', 'head & neck-larynx'),
('head & neck-lip and oral cavity', 'head & neck-lip and oral cavity'),
('head & neck-nasal cavity and sinuses', 'head & neck-nasal cavity and sinuses'),
('head & neck-other head & neck', 'head & neck-other head & neck'),
('head & neck-pharynx', 'head & neck-pharynx'),
('head & neck-salivary glands', 'head & neck-salivary glands'),
('head & neck-thyroid', 'head & neck-thyroid'),
('musculoskeletal sites-bone', 'musculoskeletal sites-bone'),
('musculoskeletal sites-other bone', 'musculoskeletal sites-other bone'),
('musculoskeletal sites-soft tissue sarcoma', 'musculoskeletal sites-soft tissue sarcoma'),
('ophthalmic-eye', 'ophthalmic-eye'),
('ophthalmic-other eye', 'ophthalmic-other eye'),
('other-gross metastatic disease', 'other-gross metastatic disease'),
('other-primary unknown', 'other-primary unknown'),
('skin-melanoma', 'skin-melanoma'),
('skin-non melanomas', 'skin-non melanomas'),
('skin-other skin', 'skin-other skin'),
('thoracic-lung', 'thoracic-lung'),
('thoracic-mesothelioma', 'thoracic-mesothelioma'),
('thoracic-other thoracic', 'thoracic-other thoracic'),
('urinary tract-bladder', 'urinary tract-bladder'),
('urinary tract-kidney', 'urinary tract-kidney'),
('urinary tract-other urinary tract', 'urinary tract-other urinary tract'),
('urinary tract-renal pelvis and ureter', 'urinary tract-renal pelvis and ureter'),
('urinary tract-urethra', 'urinary tract-urethra'),
('unknown', 'unknown');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='breast-breast' and language_alias='breast-breast'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='central nervous system-brain' and language_alias='central nervous system-brain'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='central nervous system-other central nervous system' and language_alias='central nervous system-other central nervous system'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='central nervous system-spinal cord' and language_alias='central nervous system-spinal cord'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-anal' and language_alias='digestive-anal'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-appendix' and language_alias='digestive-appendix'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-bile ducts' and language_alias='digestive-bile ducts'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-colonic' and language_alias='digestive-colonic'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-esophageal' and language_alias='digestive-esophageal'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-gallbladder' and language_alias='digestive-gallbladder'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-liver' and language_alias='digestive-liver'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-other digestive' and language_alias='digestive-other digestive'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-pancreas' and language_alias='digestive-pancreas'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-rectal' and language_alias='digestive-rectal'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-small intestine' and language_alias='digestive-small intestine'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='digestive-stomach' and language_alias='digestive-stomach'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-cervical' and language_alias='female genital-cervical'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-endometrium' and language_alias='female genital-endometrium'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-fallopian tube' and language_alias='female genital-fallopian tube'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-gestational trophoblastic neoplasia' and language_alias='female genital-gestational trophoblastic neoplasia'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-other female genital' and language_alias='female genital-other female genital'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-ovary' and language_alias='female genital-ovary'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-peritoneal pelvis abdomen' and language_alias='female genital-peritoneal pelvis abdomen'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-uterine' and language_alias='female genital-uterine'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-vagina' and language_alias='female genital-vagina'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='female genital-vulva' and language_alias='female genital-vulva'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='haematological-hodgkin''s disease' and language_alias='haematological-hodgkin''s disease'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='haematological-leukemia' and language_alias='haematological-leukemia'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='haematological-lymphoma' and language_alias='haematological-lymphoma'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='haematological-non-hodgkin''s lymphomas' and language_alias='haematological-non-hodgkin''s lymphomas'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='haematological-other haematological' and language_alias='haematological-other haematological'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='head & neck-larynx' and language_alias='head & neck-larynx'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='head & neck-lip and oral cavity' and language_alias='head & neck-lip and oral cavity'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='head & neck-nasal cavity and sinuses' and language_alias='head & neck-nasal cavity and sinuses'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='head & neck-other head & neck' and language_alias='head & neck-other head & neck'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='head & neck-pharynx' and language_alias='head & neck-pharynx'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='head & neck-salivary glands' and language_alias='head & neck-salivary glands'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='head & neck-thyroid' and language_alias='head & neck-thyroid'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='musculoskeletal sites-bone' and language_alias='musculoskeletal sites-bone'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='musculoskeletal sites-other bone' and language_alias='musculoskeletal sites-other bone'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='musculoskeletal sites-soft tissue sarcoma' and language_alias='musculoskeletal sites-soft tissue sarcoma'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='ophthalmic-eye' and language_alias='ophthalmic-eye'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='ophthalmic-other eye' and language_alias='ophthalmic-other eye'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='other-gross metastatic disease' and language_alias='other-gross metastatic disease'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='other-primary unknown' and language_alias='other-primary unknown'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='skin-melanoma' and language_alias='skin-melanoma'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='skin-non melanomas' and language_alias='skin-non melanomas'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='skin-other skin' and language_alias='skin-other skin'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='thoracic-lung' and language_alias='thoracic-lung'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='thoracic-mesothelioma' and language_alias='thoracic-mesothelioma'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='thoracic-other thoracic' and language_alias='thoracic-other thoracic'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='urinary tract-bladder' and language_alias='urinary tract-bladder'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='urinary tract-kidney' and language_alias='urinary tract-kidney'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='urinary tract-other urinary tract' and language_alias='urinary tract-other urinary tract'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='urinary tract-renal pelvis and ureter' and language_alias='urinary tract-renal pelvis and ureter'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='urinary tract-urethra' and language_alias='urinary tract-urethra'), "0", "1"),
((select id from structure_value_domains where domain_name="ovcare_tumor_site"), (select id from structure_permissible_values where value='unknown' and language_alias='unknown'), "0", "1");
ALTER TABLE dxd_secondaries ADD COLUMN ovcare_tumor_site VARCHAR(100) DEFAULT NULL;
ALTER TABLE dxd_secondaries_revs ADD COLUMN ovcare_tumor_site VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_secondaries', 'ovcare_tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='ovcare_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id, en) VALUES
('breast-breast', 'Breast-Breast'), 
('central nervous system-brain', 'Central Nervous System-Brain'), 
('central nervous system-other central nervous system', 'Central Nervous System-Other Central Nervous System'), 
('central nervous system-spinal cord', 'Central Nervous System-Spinal Cord'), 
('digestive-anal', 'Digestive-Anal'), 
('digestive-appendix', 'Digestive-Appendix'), 
('digestive-bile ducts', 'Digestive-Bile Ducts'), 
('digestive-colonic', 'Digestive-Colonic'), 
('digestive-esophageal', 'Digestive-Esophageal'), 
('digestive-gallbladder', 'Digestive-Gallbladder'), 
('digestive-liver', 'Digestive-Liver'), 
('digestive-other digestive', 'Digestive-Other Digestive'), 
('digestive-pancreas', 'Digestive-Pancreas'), 
('digestive-rectal', 'Digestive-Rectal'), 
('digestive-small intestine', 'Digestive-Small Intestine'), 
('digestive-stomach', 'Digestive-Stomach'), 
('female genital-cervical', 'Female Genital-Cervical'), 
('female genital-endometrium', 'Female Genital-Endometrium'), 
('female genital-fallopian tube', 'Female Genital-Fallopian Tube'), 
('female genital-gestational trophoblastic neoplasia', 'Female Genital-Gestational Trophoblastic Neoplasia'), 
('female genital-other female genital', 'Female Genital-Other Female Genital'), 
('female genital-ovary', 'Female Genital-Ovary'), 
('female genital-peritoneal pelvis abdomen', 'Female Genital-Peritoneal Pelvis Abdomen'), 
('female genital-uterine', 'Female Genital-Uterine'), 
('female genital-vagina', 'Female Genital-Vagina'), 
('female genital-vulva', 'Female Genital-Vulva'), 
('haematological-hodgkin''s disease', 'Haematological-Hodgkin''s Disease'), 
('haematological-leukemia', 'Haematological-Leukemia'), 
('haematological-lymphoma', 'Haematological-Lymphoma'), 
('haematological-non-hodgkin''s lymphomas', 'Haematological-Non-Hodgkin''s Lymphomas'), 
('haematological-other haematological', 'Haematological-Other Haematological'), 
('head & neck-larynx', 'Head & Neck-Larynx'), 
('head & neck-lip and oral cavity', 'Head & Neck-Lip and Oral Cavity'), 
('head & neck-nasal cavity and sinuses', 'Head & Neck-Nasal Cavity and Sinuses'), 
('head & neck-other head & neck', 'Head & Neck-Other Head & Neck'), 
('head & neck-pharynx', 'Head & Neck-Pharynx'), 
('head & neck-salivary glands', 'Head & Neck-Salivary Glands'), 
('head & neck-thyroid', 'Head & Neck-Thyroid'), 
('musculoskeletal sites-bone', 'Musculoskeletal Sites-Bone'), 
('musculoskeletal sites-other bone', 'Musculoskeletal Sites-Other Bone'), 
('musculoskeletal sites-soft tissue sarcoma', 'Musculoskeletal Sites-Soft Tissue Sarcoma'), 
('ophthalmic-eye', 'Ophthalmic-Eye'), 
('ophthalmic-other eye', 'Ophthalmic-Other Eye'), 
('other-gross metastatic disease', 'Other-Gross Metastatic Disease'), 
('other-primary unknown', 'Other-Primary Unknown'), 
('skin-melanoma', 'Skin-Melanoma'), 
('skin-non melanomas', 'Skin-Non Melanomas'), 
('skin-other skin', 'Skin-Other Skin'), 
('thoracic-lung', 'Thoracic-Lung'), 
('thoracic-mesothelioma', 'Thoracic-Mesothelioma'), 
('thoracic-other thoracic', 'Thoracic-Other Thoracic'), 
('urinary tract-bladder', 'Urinary Tract-Bladder'), 
('urinary tract-kidney', 'Urinary Tract-Kidney'), 
('urinary tract-other urinary tract', 'Urinary Tract-Other Urinary Tract'), 
('urinary tract-renal pelvis and ureter', 'Urinary Tract-Renal Pelvis and Ureter'), 
('urinary tract-urethra', 'Urinary Tract-Urethra');

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='initial_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='initial_recurrence_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='progression_free_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='survival and progression' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='initial_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('survival and progression','Survival and Progression');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_vital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM diagnosis_controls WHERE `category` = 'secondary' AND `controls_type` = 'ovcare';
ALTER TABLE diagnosis_masters 
	ADD COLUMN `ovcare_clinical_history` text,
	ADD COLUMN `ovcare_clinical_diagnosis` text,	
	ADD COLUMN `ovcare_tumor_site` varchar(100) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs
	ADD COLUMN `ovcare_clinical_history` text,
	ADD COLUMN `ovcare_clinical_diagnosis` text,	
	ADD COLUMN `ovcare_tumor_site` varchar(100) DEFAULT NULL;
ALTER TABLE ovcare_dxd_ovaries 
	DROP COLUMN clinical_history,
	DROP COLUMN clinical_diagnosis; 
ALTER TABLE ovcare_dxd_ovaries_revs 
	DROP COLUMN clinical_history,
	DROP COLUMN clinical_diagnosis; 
ALTER TABLE dxd_secondaries 
	DROP COLUMN ovcare_tumor_site; 
ALTER TABLE dxd_secondaries_revs 
	DROP COLUMN ovcare_tumor_site; 
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields 
WHERE tablename IN ('dxd_secondaries','ovcare_dxd_ovaries') AND field IN ('clinical_history','clinical_diagnosis','ovcare_tumor_site'));
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields 
WHERE tablename IN ('dxd_secondaries','ovcare_dxd_ovaries') AND field IN ('clinical_history','clinical_diagnosis','ovcare_tumor_site'));
DELETE FROM structure_fields WHERE tablename IN ('dxd_secondaries','ovcare_dxd_ovaries') AND field IN ('clinical_history','clinical_diagnosis','ovcare_tumor_site');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'ovcare_clinical_history', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'clinical history', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'ovcare_clinical_diagnosis', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'clinical diagnosis', ''),
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'ovcare_tumor_site', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND field='ovcare_tumor_site'), 'notEmpty');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical history' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical diagnosis' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical history' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical diagnosis' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='3', `display_order`='20', `language_heading`='summary' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='20', `language_heading`='summary' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE diagnosis_controls SET `controls_type` = 'ovary' WHERE `controls_type` = 'ovcare';
INSERT IGNORE INTO i18n (id,en) 
VALUES 
('ovary','Ovary'),
('updated automatically tumor site to appropriated value','Updated automatically tumor site to appropriated value');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('topography','icd10_code'));
ALTER TABLE ovcare_dxd_ovaries 
  CHANGE `stage` `tumor_grade` varchar(10) DEFAULT NULL,
  CHANGE `substage` `figo` varchar(10) DEFAULT NULL;
ALTER TABLE ovcare_dxd_ovaries_revs 
  CHANGE `stage` `tumor_grade` varchar(10) DEFAULT NULL,
  CHANGE `substage` `figo` varchar(10) DEFAULT NULL;
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_stage"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "5", "1");
UPDATE structure_value_domains SET domain_name="ovcare_tumor_grade" WHERE domain_name="ovcare_stage";
UPDATE structure_value_domains SET domain_name="ovcare_figo" WHERE domain_name="ovcare_substage";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="A" AND spv.language_alias="A";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="B" AND spv.language_alias="B";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="C" AND spv.language_alias="C";
DELETE FROM structure_permissible_values WHERE value="A" AND language_alias="A";
DELETE FROM structure_permissible_values WHERE value="B" AND language_alias="B";
DELETE FROM structure_permissible_values WHERE value="C" AND language_alias="C";
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("Ia", "Ia"),
("Ib", "Ib"),
("Ic", "Ic"),
("IIa", "IIa"),
("IIb", "IIb"),
("IIc", "IIc"),
("IIIa", "IIIa"),
("IIIb", "IIIb"),
("IIIc", "IIIc");
SET @structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ovcare_figo");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="Ia" AND language_alias="Ia"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="Ib" AND language_alias="Ib"), "2", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="Ic" AND language_alias="Ic"), "3", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="IIa" AND language_alias="IIa"), "4", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="IIb" AND language_alias="IIb"), "5", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="IIc" AND language_alias="IIc"), "6", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="IIIa" AND language_alias="IIIa"), "7", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="IIIb" AND language_alias="IIIb"), "8", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="IIIc" AND language_alias="IIIc"), "9", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "10", "1");
UPDATE structure_fields SET `field` = 'figo', `language_label` = 'figo', `language_tag` = '' WHERE `field` = 'substage' AND tablename = 'ovcare_dxd_ovaries';
UPDATE structure_fields SET `field` = 'tumor_grade', `language_label` = 'tumor grade', `language_tag` = '' WHERE `field` = 'stage' AND tablename = 'ovcare_dxd_ovaries';
INSERT INTO i18n (id,en) VALUES ('tumor grade', 'Tumor grade'), ('figo','Figo'),("Ia", "Ia"),
("Ib", "Ib"),
("Ic", "Ic"),
("IIa", "IIa"),
("IIb", "IIb"),
("IIc", "IIc"),
("IIIa", "IIIa"),
("IIIb", "IIIb"),
("IIIc", "IIIc");
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='tumor_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') AND `flag_confidential`='0');
ALTER TABLE ovcare_dxd_ovaries DROP COLUMN tumor_grade;
ALTER TABLE ovcare_dxd_ovaries_revs DROP COLUMN tumor_grade;
UPDATE structure_fields SET `model`='DiagnosisMaster', field='tumour_grade', `tablename`='diagnosis_masters' WHERE model='DiagnosisDetail' AND tablename='ovcare_dxd_ovaries' AND field='tumor_grade' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '1', '5', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ovcare_laterality", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_laterality"), (SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_laterality"), (SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_laterality"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'ovcare_dxd_ovaries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_laterality') , '0', '', '', '', 'laterality', '');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-102' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `language_label`='laterality' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `language_help`='dx_laterality' AND `validation_control`='open' AND `value_domain_control`='extend' AND `field_control`='locked' AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE ovcare_dxd_ovaries 
  ADD COLUMN `laterality` varchar(10) DEFAULT NULL;
ALTER TABLE ovcare_dxd_ovaries_revs 
  ADD COLUMN `laterality` varchar(10) DEFAULT NULL;
UPDATE structure_formats SET `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='initial_surgery_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='33' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='initial_recurrence_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries' AND `field`='progression_free_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(12, 19, 23, 136, 20, 21, 13, 14, 119, 15, 16, 24, 118, 7, 8, 9);
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE sd_spe_tissues ADD COLUMN ovcare_ischemia_time_mn int(6) DEFAULT null;
ALTER TABLE sd_spe_tissues_revs ADD COLUMN ovcare_ischemia_time_mn int(6) DEFAULT null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'ovcare_ischemia_time_mn', 'integer_positive',  NULL , '0', 'size=5', '', '', '', 'ischemia time mn');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ovcare_ischemia_time_mn' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ischemia time mn'), '1', '440', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET language_label = 'ischemia time mn', language_tag = '' WHERE field = 'ovcare_ischemia_time_mn';
INSERT INTO i18n (id,en) VALUES ('ischemia time mn','Ischemia time (mn)');
INSERT INTO structure_permissible_values (value, language_alias) VALUES("FFPE", "FFPE");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="block_type"), (SELECT id FROM structure_permissible_values WHERE value="FFPE" AND language_alias="FFPE"), "0", "1");






























-- - TFRI-COEUR FIELDS ----------------------------------------------------------------------------------------------------------------

ALTER TABLE participants ADD ovcare_brca_status VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE participants_revs ADD ovcare_brca_status VARCHAR(50) NOT NULL DEFAULT '';
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('BRCA mutation known but not identified', 'BRCA mutation known but not identified'),
('BRCA1 mutated', 'BRCA1 mutated'),
('BRCA2 mutated', 'BRCA2 mutated'),
('BRCA1/2 mutated', 'BRCA1/2 mutated'),
('wild type', 'wild type');
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ovcare_brca', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
(SELECT (SELECT id FROM structure_value_domains WHERE domain_name="ovcare_brca"),  id, "", "1" FROM structure_permissible_values WHERE
(value='wild type' AND language_alias='wild type') OR
(value='BRCA mutation known but not identified' AND language_alias='BRCA mutation known but not identified') OR
(value='BRCA1 mutated' AND language_alias='BRCA1 mutated') OR
(value='BRCA2 mutated' AND language_alias='BRCA2 mutated') OR
(value='BRCA1/2 mutated' AND language_alias='BRCA1/2 mutated') OR
(value='unknown' AND language_alias='unknown'));
INSERT INTO i18n (id,en) VALUES
('BRCA mutation known but not identified', 'BRCA mutation known but not identified'),
('BRCA1 mutated', 'BRCA1 mutated'),
('BRCA2 mutated', 'BRCA2 mutated'),
('BRCA1/2 mutated', 'BRCA1/2 mutated'),
("brca status", "BRCA status"),
('wild type', 'Wild type');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'ovcare_brca_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_brca') , '0', '', '', '', 'brca status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ovcare_brca_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_brca')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='brca status' AND `language_tag`=''), '3', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE txd_surgeries CHANGE `ovcare_macroscopic_residual` `ovcare_residual_disease` varchar(10) DEFAULT NULL;
ALTER TABLE txd_surgeries_revs CHANGE `ovcare_macroscopic_residual` `ovcare_residual_disease` varchar(10) DEFAULT NULL;
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("none","none"),
("1-2cm","1-2cm"),
("<1cm","<1cm"),
(">2cm",">2cm"),
("miliary","miliary"),
("suboptimal","suboptimal"),
("yes unknown","yes unknown"),
("unknown","unknown");
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ovcare_residual_disease', '', '', NULL);
SET @structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ovcare_residual_disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="1-2cm" AND language_alias="1-2cm"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="<1cm" AND language_alias="<1cm"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value=">2cm" AND language_alias=">2cm"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="miliary" AND language_alias="miliary"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="suboptimal" AND language_alias="suboptimal"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="yes unknown" AND language_alias="yes unknown"), "1", "1"),
( @structure_value_domain_id, (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");
UPDATE structure_fields SET `field` = 'ovcare_residual_disease', `type` = 'select', `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_residual_disease'), `language_label` = 'residual disease', `language_tag` = '' WHERE field = 'ovcare_macroscopic_residual';
INSERT IGNORE INTO i18n (id,en) VALUES
("none","None"),
("1-2cm","1-2cm"),
("<1cm","<1cm"),
(">2cm",">2cm"),
("miliary","Miliary"),
("suboptimal","Suboptimal"),
("yes unknown","Yes Unknown"),
("unknown","Unknown"),
('residual disease','Residual disease');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'ovcare', 'lab', 'ca125', 1, 'ovcare_ed_ca125s', 'ovcare_ed_ca125s', 0, 'ca125', 1);
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_ca125s');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_ca125s', 'ca125', 'float_positive', null, '0', 'size=3', '', '', 'ca125', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ca125s'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_ca125s' AND `field`='ca125'), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
CREATE TABLE IF NOT EXISTS `ovcare_ed_ca125s` (
  `ca125` decimal(8,2) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ovcare_ed_ca125s_revs` (
  `ca125` decimal(8,2) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `ovcare_ed_ca125s`
  ADD CONSTRAINT `ovcare_ed_ca125s_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_ca125s' AND `field`='ca125'), 'notEmpty');
INSERT INTO i18n (id,en) VALUES ('ca125','CA125 (u)');
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('ovcare_clin_CAN_3', 'clin_CAN_4', 0, 6, 'ca125', 'ca125', '/ClinicalAnnotation/EventMasters/listall/ca125/%%Participant.id%%', 'ClinicalAnnotation.EventMaster::summary', 1, 1);
UPDATE event_controls SET `event_group` = 'ca125' WHERE detail_form_alias = 'ovcare_ed_ca125s';



