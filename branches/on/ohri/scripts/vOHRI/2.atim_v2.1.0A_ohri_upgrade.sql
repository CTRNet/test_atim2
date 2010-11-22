UPDATE i18n 
SET en = 'ATiM - Advanced Tissue Management - v.OHRI',
fr = 'ATiM - Application de gestion avancée des tissus - v.IRHO'
WHERE id = 'core_appname';

-- CLINICAL.ANNOTATION PROFILE --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('title','middle_name','race','secondary_cod_icd10_code','cod_confirmation_source') 
AND str.alias IN ('participants')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '1', sfo.flag_edit_readonly = '1',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '1', sfo.flag_search_readonly = '0',
sfo.flag_index = '1', sfo.flag_detail = '1',
language_heading = 'system data',
sfo.display_column = '3', sfo.display_order = '98'
WHERE sfi.field IN ('participant_identifier') 
AND str.alias IN ('participants')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='first_name' ), 'notEmpty', '0', '0', '', 'value is required'),
(null, (SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='last_name' ), 'notEmpty', '0', '0', '', 'value is required');

UPDATE i18n SET en = 'Participant System Code', fr = 'Code système participant' WHERE id = 'participant_identifier';

-- CLINICAL.ANNOTATION CONSENT --

UPDATE consent_controls SET flag_active = '0';

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'consent ohri ovary', 1, 'ohri_cd_ovaries', 'ohri_cd_ovaries', 0, 'consent ohri ovary');

CREATE TABLE IF NOT EXISTS `ohri_cd_ovaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ohri_cd_ovaries_revs` (
  `id` int(11) NOT NULL,
  `consent_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_cd_ovaries`
  ADD CONSTRAINT `ohri_cd_ovaries_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ohri_cd_ovaries', '', '', '1', '1', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='ohri_cd_ovaries'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `language_label`='consent status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `language_help`='help_consent_status'), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_cd_ovaries'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `language_label`='status date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='NULL' AND `structure_value_domain`  IS NULL  AND `language_help`='help_status_date'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_cd_ovaries'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `language_label`='consent signed date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_consent_signed_date'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_cd_ovaries'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `language_label`='reason denied or withdrawn' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=35,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_reason_denied'), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_cd_ovaries'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=35,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='help_notes'), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- CLINICAL.ANNOTATION DIAGNOSIS --

UPDATE diagnosis_controls SET flag_active = '0';

INSERT INTO `diagnosis_controls` 
(`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
(null, 'diagnosis ohri - ovary', 1, 'ohri_dx_ovaries', 'ohri_dx_ovaries', 0, 'diagnosis ohri - ovary'),
(null, 'diagnosis ohri - other', 1, 'ohri_dx_others', 'ohri_dx_others', 0, 'diagnosis ohri - other');

CREATE TABLE IF NOT EXISTS `ohri_dx_ovaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `histopathology` varchar(50) NOT NULL DEFAULT '',
  `figo` varchar(50) NOT NULL DEFAULT '',
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ohri_dx_ovaries_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `histopathology` varchar(50) NOT NULL DEFAULT '',
  `figo` varchar(50) NOT NULL DEFAULT '',
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_dx_ovaries`
  ADD CONSTRAINT `ohri_dx_ovaries_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ohri_dx_others` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `histopathology` varchar(50) NOT NULL DEFAULT '',
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ohri_dx_others_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `histopathology` varchar(50) NOT NULL DEFAULT '',
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_dx_others`
  ADD CONSTRAINT `ohri_dx_others_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

ALTER TABLE diagnosis_masters
	ADD `ohri_progression_free_interval_months` int(11) DEFAULT NULL AFTER `survival_time_months`,
	ADD `ohri_tumor_site` varchar(100) NOT NULL DEFAULT '' AFTER `dx_origin`;

ALTER TABLE diagnosis_masters_revs
	ADD `ohri_progression_free_interval_months` int(11) DEFAULT NULL AFTER `survival_time_months`,
	ADD `ohri_tumor_site` varchar(100) NOT NULL DEFAULT '' AFTER `dx_origin`;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("lmp", "lmp");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="dx_nature"), (SELECT id FROM structure_permissible_values WHERE value="lmp" AND language_alias="lmp"), "4", "1");

UPDATE structure_value_domains_permissible_values 
SET flag_active = '0'
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="dx_method")
AND structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values WHERE (value="surgical" AND language_alias="surgical") OR (value="cytology" AND language_alias="cytology"));
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("biopsy", "biopsy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="dx_method"), (SELECT id FROM structure_permissible_values WHERE value="biopsy" AND language_alias="biopsy"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_tumour_grade', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("0", "0"),("1", "1"),("2", "2"),("3", "3");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_grade"),  (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_grade"),  (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_grade"),  (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_grade"),  (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "4", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_tumour_histopathology', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("high grade serous", "high grade serous"),
("low grade serous", "low grade serous"),
("mucinous", "mucinous"),
("clear cells", "clear cells"),
("endometrioid", "endometrioid"),
("mixed", "mixed"),
("undifferentiated", "undifferentiated");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_histopathology"),  
(SELECT id FROM structure_permissible_values WHERE value="high grade serous" AND language_alias="high grade serous"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_histopathology"),  
(SELECT id FROM structure_permissible_values WHERE value="low grade serous" AND language_alias="low grade serous"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_histopathology"),  
(SELECT id FROM structure_permissible_values WHERE value="mucinous" AND language_alias="mucinous"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_histopathology"),  
(SELECT id FROM structure_permissible_values WHERE value="clear cells" AND language_alias="clear cells"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_histopathology"),  
(SELECT id FROM structure_permissible_values WHERE value="endometrioid" AND language_alias="endometrioid"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_histopathology"),  
(SELECT id FROM structure_permissible_values WHERE value="mixed" AND language_alias="mixed"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_histopathology"),  
(SELECT id FROM structure_permissible_values WHERE value="undifferentiated" AND language_alias="undifferentiated"), "7", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("Ia", "Ia"),
("Ib", "Ib"),
("Ic", "Ic"),
("IIa", "IIa"),
("IIb", "IIb"),
("IIc", "IIc"),
("IIIa", "IIIa"),
("IIIb", "IIIb"),
("IIIc", "IIIc"),
("IV", "IV");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_tumour_stage', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="Ia" AND language_alias="Ia"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="Ib" AND language_alias="Ib"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="Ic" AND language_alias="Ic"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="IIa" AND language_alias="IIa"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="IIb" AND language_alias="IIb"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="IIc" AND language_alias="IIc"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="IIIa" AND language_alias="IIIa"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="IIIb" AND language_alias="IIIb"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="IIIc" AND language_alias="IIIc"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="IV" AND language_alias="IV"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "10", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("bilateral", "bilateral");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="laterality"),  
(SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "0", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('digestive-anal','digestive-anal'),
('digestive-appendix','digestive-appendix'),
('digestive-bile ducts','digestive-bile ducts'),
('digestive-colonic','digestive-colonic'),
('digestive-esophageal','digestive-esophageal'),
('digestive-gallbladder','digestive-gallbladder'),
('digestive-liver','digestive-liver'),
('digestive-pancreas','digestive-pancreas'),
('digestive-rectal','digestive-rectal'),
('digestive-small intestine','digestive-small intestine'),
('digestive-stomach','digestive-stomach'),
('digestive-other digestive','digestive-other digestive'),
('thoracic-lung','thoracic-lung'),
('thoracic-mesothelioma','thoracic-mesothelioma'),
('thoracic-other thoracic','thoracic-other thoracic'),
('ophthalmic-eye','ophthalmic-eye'),
('ophthalmic-other eye','ophthalmic-other eye'),
('breast-breast','breast-breast'),
('female genital-cervical','female genital-cervical'),
('female genital-endometrium','female genital-endometrium'),
('female genital-fallopian tube','female genital-fallopian tube'),
('female genital-gestational trophoblastic neoplasia','female genital-gestational trophoblastic neoplasia'),
('female genital-ovary','female genital-ovary'),
('female genital-peritoneal','female genital-peritoneal'),
('female genital-uterine','female genital-uterine'),
('female genital-vulva','female genital-vulva'),
('female genital-vagina','female genital-vagina'),
('female genital-other female genital','female genital-other female genital'),
('head & neck-larynx','head & neck-larynx'),
('head & neck-nasal cavity and sinuses','head & neck-nasal cavity and sinuses'),
('head & neck-lip and oral cavity','head & neck-lip and oral cavity'),
('head & neck-pharynx','head & neck-pharynx'),
('head & neck-thyroid','head & neck-thyroid'),
('head & neck-salivary glands','head & neck-salivary glands'),
('head & neck-other head & neck','head & neck-other head & neck'),
('haematological-leukemia','haematological-leukemia'),
('haematological-lymphoma','haematological-lymphoma'),
('haematological-hodgkin''s disease','haematological-hodgkin''s disease'),
('haematological-non-hodgkin''s lymphomas','haematological-non-hodgkin''s lymphomas'),
('haematological-other haematological','haematological-other haematological'),
('skin-melanoma','skin-melanoma'),
('skin-non melanomas','skin-non melanomas'),
('skin-other skin','skin-other skin'),
('urinary tract-bladder','urinary tract-bladder'),
('urinary tract-renal pelvis and ureter','urinary tract-renal pelvis and ureter'),
('urinary tract-kidney','urinary tract-kidney'),
('urinary tract-urethra','urinary tract-urethra'),
('urinary tract-other urinary tract','urinary tract-other urinary tract'),
('central nervous system-brain','central nervous system-brain'),
('central nervous system-spinal cord','central nervous system-spinal cord'),
('central nervous system-other central nervous system','central nervous system-other central nervous system'),
('musculoskeletal sites-soft tissue sarcoma','musculoskeletal sites-soft tissue sarcoma'),
('musculoskeletal sites-bone','musculoskeletal sites-bone'),
('musculoskeletal sites-other bone','musculoskeletal sites-other bone'),
('other-primary unknown','other-primary unknown'),
('other-gross metastatic disease','other-gross metastatic disease');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_tumour_site', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-anal" AND language_alias="digestive-anal"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-appendix" AND language_alias="digestive-appendix"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-bile ducts" AND language_alias="digestive-bile ducts"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-colonic" AND language_alias="digestive-colonic"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-esophageal" AND language_alias="digestive-esophageal"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-gallbladder" AND language_alias="digestive-gallbladder"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-liver" AND language_alias="digestive-liver"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-pancreas" AND language_alias="digestive-pancreas"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-rectal" AND language_alias="digestive-rectal"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-small intestine" AND language_alias="digestive-small intestine"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-stomach" AND language_alias="digestive-stomach"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-other digestive" AND language_alias="digestive-other digestive"), "12", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-lung" AND language_alias="thoracic-lung"), "13", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-mesothelioma" AND language_alias="thoracic-mesothelioma"), "14", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-other thoracic" AND language_alias="thoracic-other thoracic"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-eye" AND language_alias="ophthalmic-eye"), "16", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-other eye" AND language_alias="ophthalmic-other eye"), "17", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="breast-breast" AND language_alias="breast-breast"), "18", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-cervical" AND language_alias="female genital-cervical"), "19", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-endometrium" AND language_alias="female genital-endometrium"), "20", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-fallopian tube" AND language_alias="female genital-fallopian tube"), "21", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-gestational trophoblastic neoplasia" AND language_alias="female genital-gestational trophoblastic neoplasia"), "22", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-ovary" AND language_alias="female genital-ovary"), "23", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-peritoneal" AND language_alias="female genital-peritoneal"), "24", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-uterine" AND language_alias="female genital-uterine"), "25", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vulva" AND language_alias="female genital-vulva"), "26", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vagina" AND language_alias="female genital-vagina"), "27", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-other female genital" AND language_alias="female genital-other female genital"), "28", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-larynx" AND language_alias="head & neck-larynx"), "29", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-nasal cavity and sinuses" AND language_alias="head & neck-nasal cavity and sinuses"), "30", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-lip and oral cavity" AND language_alias="head & neck-lip and oral cavity"), "31", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-pharynx" AND language_alias="head & neck-pharynx"), "32", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-thyroid" AND language_alias="head & neck-thyroid"), "33", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-salivary glands" AND language_alias="head & neck-salivary glands"), "34", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-other head & neck" AND language_alias="head & neck-other head & neck"), "35", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-leukemia" AND language_alias="haematological-leukemia"), "36", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-lymphoma" AND language_alias="haematological-lymphoma"), "37", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-hodgkin's disease" AND language_alias="haematological-hodgkin's disease"), "38", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-non-hodgkin's lymphomas" AND language_alias="haematological-non-hodgkin's lymphomas"), "39", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-other haematological" AND language_alias="haematological-other haematological"), "40", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-melanoma" AND language_alias="skin-melanoma"), "41", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-non melanomas" AND language_alias="skin-non melanomas"), "42", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-other skin" AND language_alias="skin-other skin"), "43", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-bladder" AND language_alias="urinary tract-bladder"), "44", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-renal pelvis and ureter" AND language_alias="urinary tract-renal pelvis and ureter"), "45", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-kidney" AND language_alias="urinary tract-kidney"), "46", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-urethra" AND language_alias="urinary tract-urethra"), "47", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-other urinary tract" AND language_alias="urinary tract-other urinary tract"), "48", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-brain" AND language_alias="central nervous system-brain"), "49", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-spinal cord" AND language_alias="central nervous system-spinal cord"), "50", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-other central nervous system" AND language_alias="central nervous system-other central nervous system"), "51", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-soft tissue sarcoma" AND language_alias="musculoskeletal sites-soft tissue sarcoma"), "52", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-bone" AND language_alias="musculoskeletal sites-bone"), "53", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-other bone" AND language_alias="musculoskeletal sites-other bone"), "54", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-primary unknown" AND language_alias="other-primary unknown"), "55", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-gross metastatic disease" AND language_alias="other-gross metastatic disease"), "56", "1");

UPDATE structure_fields SET `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_tumour_grade')
WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade'
AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade');

UPDATE structure_fields 
SET `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_tumour_stage'),
`type`='select', 
`setting`=''
WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` IN ('clinical_stage_summary' , 'path_stage_summary' );

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', '', 'ohri_tumor_site', 'tumor site', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tumour_site') , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'ohri_progression_free_interval_months', 'progression free interval months', '', 'integer_positive', 'size=5', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', '', 'histopathology', 'histopathology', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tumour_histopathology') , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', '', 'figo', 'figo', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tumour_stage') , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', 'ohri_dx_ovaries', 'laterality', 'laterality', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', 'ohri_dx_others', 'laterality', 'laterality', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '', 'open', 'open', 'open');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('ohri_dx_ovaries', '', '', '1', '1', '0', '1'),
('ohri_dx_others', '', '', '1', '1', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' ), 
'1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `language_label`='origin'), 
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='ohri_tumor_site'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `language_label`='dx_date' ), 
'1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy'), 
'1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx'), 
'1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),  
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_accuracy'), 
'1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),  
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature'), 
'1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method'), 
'1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade'), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='histopathology'), 
'1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months'), 
'1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ohri_progression_free_interval_months'), 
'1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes'), 
'1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography'), 
'2', '20', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology'), 
'2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='figo'), 
'2', '25', 'staging', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ohri_dx_ovaries' AND field='laterality'), 
'2', '26', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' ), 
'1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `language_label`='origin'), 
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='ohri_tumor_site'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `language_label`='dx_date' ), 
'1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy'), 
'1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx'), 
'1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),  
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_accuracy'), 
'1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),  
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature'), 
'1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method'), 
'1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade'), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='histopathology'), 
'1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months'), 
'1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ohri_progression_free_interval_months'), 
'1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes'), 
'1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography'), 
'2', '20', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology'), 
'2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary'), 
'2', '22', 'staging', '1', 'clinical stage', '1', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary'), 
'2', '25', '', '1', 'pathologic stage', '1', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ohri_dx_others' AND field='laterality'), 
'2', '26', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('biopsy','Biopsy','Biopsie'),
('clear cells','Clear Cells','Cellules claires'),
('diagnosis ohri - other','Diagnosis OHRI - Other','Diagnostic IRHO - Autre'),
('diagnosis ohri - ovary','Diagnosis OHRI - Ovary','Diagnostic IRHO - Ovaire'),
('endometrioid','Endometrioid','Endométrioïde'),
('high grade serous','High Grade Serous','Haut grade séreux'),
('histopathology','Histopathology','Histopathologie'),
('low grade serous','Low Grade Serous','Faible grade séreux'),
('mixed','Mixed','Mixte'),
('undifferentiated','Undifferentiated','Indifférencié'),
('system data', 'System Data', 'Données système'),
('consent ohri ovary', 'Consent OHRI - Ovary', 'Consentement IRHO - Ovaire'),
('figo', 'FIGO', 'FIGO'),
('progression free interval months', 'Progression Free Interval in Months', ''),
('lmp', 'LMP (Low Malignant Potential)', 'LMP (Borderline)'),
('pathologic stage', 'Pathologic Stage', 'Stade pathologique'),
('digestive-anal','Digestive - Anal',''),
('digestive-appendix','Digestive - Appendix',''),
('digestive-bile ducts','Digestive - Bile Ducts',''),
('digestive-colonic','Digestive - Colonic',''),
('digestive-esophageal','Digestive - Esophageal',''),
('digestive-gallbladder','Digestive - Gallbladder',''),
('digestive-liver','Digestive - Liver',''),
('digestive-pancreas','Digestive - Pancreas',''),
('digestive-rectal','Digestive - Rectal',''),
('digestive-small intestine','Digestive - Small Intestine',''),
('digestive-stomach','Digestive - Stomach',''),
('digestive-other digestive','Digestive - Other Digestive',''),
('thoracic-lung','Thoracic - Lung',''),
('thoracic-mesothelioma','Thoracic - Mesothelioma',''),
('thoracic-other thoracic','Thoracic - Other Thoracic',''),
('ophthalmic-eye','Ophthalmic - Eye',''),
('ophthalmic-other eye','Ophthalmic - Other Eye',''),
('breast-breast','Breast - Breast',''),
('female genital-cervical','Female Genital - Cervical',''),
('female genital-endometrium','Female Genital - Endometrium',''),
('female genital-fallopian tube','Female Genital - Fallopian Tube',''),
('female genital-gestational trophoblastic neoplasia','Female Genital - Gestational Trophoblastic Neoplasia',''),
('female genital-ovary','Female Genital - Ovary',''),
('female genital-peritoneal','Female Genital - Peritoneal',''),
('female genital-uterine','Female Genital - Uterine',''),
('female genital-vulva','Female Genital - Vulva',''),
('female genital-vagina','Female Genital - Vagina',''),
('female genital-other female genital','Female Genital - Other Female Genital',''),
('head & neck-larynx','Head & Neck - Larynx',''),
('head & neck-nasal cavity and sinuses','Head & Neck - Nasal Cavity and Sinuses',''),
('head & neck-lip and oral cavity','Head & Neck - Lip and Oral Cavity',''),
('head & neck-pharynx','Head & Neck - Pharynx',''),
('head & neck-thyroid','Head & Neck - Thyroid',''),
('head & neck-salivary glands','Head & Neck - Salivary Glands',''),
('head & neck-other head & neck','Head & Neck - Other Head & Neck',''),
('haematological-leukemia','Haematological - Leukemia',''),
('haematological-lymphoma','Haematological - Lymphoma',''),
('haematological-hodgkin''s disease','Haematological - Hodgkin''s Disease',''),
('haematological-non-hodgkin''s lymphomas','Haematological - Non-Hodgkin''s Lymphomas',''),
('haematological-other haematological','Haematological-Other Haematological',''),
('skin-melanoma','Skin - Melanoma',''),
('skin-non melanomas','Skin - Non Melanomas',''),
('skin-other skin','Skin - Other Skin',''),
('urinary tract-bladder','Urinary Tract - Bladder',''),
('urinary tract-renal pelvis and ureter','Urinary Tract - Renal Pelvis and Ureter',''),
('urinary tract-kidney','Urinary Tract - Kidney',''),
('urinary tract-urethra','Urinary Tract - Urethra',''),
('urinary tract-other urinary tract','Urinary Tract - Other Urinary Tract',''),
('central nervous system-brain','Central Nervous System - Brain',''),
('central nervous system-spinal cord','Central Nervous System - Spinal Cord',''),
('central nervous system-other central nervous system','Central Nervous System - Other Central Nervous System',''),
('musculoskeletal sites-soft tissue sarcoma','Musculoskeletal Sites - Soft Tissue Sarcoma',''),
('musculoskeletal sites-bone','Musculoskeletal Sites - Bone',''),
('musculoskeletal sites-other bone','Musculoskeletal Sites - Other Bone',''),
('other-primary unknown','Other - Primary Unknown',''),
('other-gross metastatic disease','Other - Gross Metastatic Disease','');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index = '1'
WHERE sfi.field IN ('date_of_birth', 'vital_status') 
AND str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_override_label  = '1',
sfo.language_label  = 'participant code'
WHERE sfi.field = 'participant_identifier' 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 		

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES ('participant code', 'Participant System Code', 'Code systême participant');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index = '0'
WHERE str.alias = 'consent_masters'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index = '1'
WHERE sfi.field IN ('consent_status', 'consent_signed_date', 'consent_control_id') 
AND str.alias = 'consent_masters'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index = '0'
WHERE str.alias = 'diagnosismasters'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index = '1'
WHERE sfi.field IN ('diagnosis_control_id', 'primary_number', 'age_at_dx', 'dx_nature', 'tumour_grade') 
AND str.alias = 'diagnosismasters'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='ohri_tumor_site'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='diagnosismasters'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='histopathology'), 
'1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

-- Event : follow up --

UPDATE event_controls SET flag_active = '0';

CREATE TABLE IF NOT EXISTS `ohri_ed_clinical_followups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `recurrence_status` varchar(50) DEFAULT NULL,
  `disease_status` varchar(50) DEFAULT NULL,
  
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_ed_clinical_followups`
  ADD CONSTRAINT `ohri_ed_clinical_followups_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ohri_ed_clinical_followups_revs` (
  `id` int(11) NOT NULL,
  
  `recurrence_status` varchar(50) DEFAULT NULL,
  `disease_status` varchar(50) DEFAULT NULL,
  
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ohri', 'clinical', 'follow up', 1, 'ohri_ed_clinical_followups', 'ohri_ed_clinical_followups', 0, 'clinical|ohri|follow up');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('ohri_ed_clinical_followups', '', '', '1', '1', '0', '1');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_clinical_followups', 'recurrence_status', 'recurrence status', '', 'input', 'size=15', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_clinical_followups', 'disease_status', 'disease status', '', 'input', 'size=15', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `language_label`='event_form_type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `language_help`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `language_help`=''), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `language_label`='summary' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_followups' AND `field`='recurrence_status' AND `language_label`='recurrence status' AND `language_tag`='' AND `type`='input' AND `setting`='size=15' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_followups' AND `field`='disease_status' AND `language_label`='disease status' AND `language_tag`='' AND `type`='input' AND `setting`='size=15' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'2', '2', 'data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

-- Event : lab --

CREATE TABLE IF NOT EXISTS `ohri_ed_lab_pathologies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `path_number` varchar(50) DEFAULT NULL,
  `report_type` varchar(50) DEFAULT NULL,
  `ihc` varchar(10) DEFAULT NULL,
  `er` varchar(10) DEFAULT NULL,
  `pr` varchar(10) DEFAULT NULL,
  `wt1` varchar(10) DEFAULT NULL,
  `p53` varchar(10) DEFAULT NULL,
  `bcat` varchar(10) DEFAULT NULL,
  `her2` varchar(10) DEFAULT NULL,
  `cytology` varchar(10) DEFAULT NULL,
    
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_ed_lab_pathologies`
  ADD CONSTRAINT `ohri_ed_lab_pathologies_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ohri_ed_lab_pathologies_revs` (
  `id` int(11) NOT NULL,
  
  `path_number` varchar(50) DEFAULT NULL,
  `report_type` varchar(50) DEFAULT NULL,
  `ihc` varchar(10) DEFAULT NULL,
  `er` varchar(10) DEFAULT NULL,
  `pr` varchar(10) DEFAULT NULL,
  `wt1` varchar(10) DEFAULT NULL,
  `p53` varchar(10) DEFAULT NULL,
  `bcat` varchar(10) DEFAULT NULL,
  `her2` varchar(10) DEFAULT NULL,
  `cytology` varchar(10) DEFAULT NULL,
    
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ohri', 'lab', 'pathology', 1, 'ohri_ed_lab_pathologies', 'ohri_ed_lab_pathologies', 0, 'lab|ohri|pathology');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_test_result', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_test_result"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_test_result"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("FNA", "FNA"),
("core biopsy", "core biopsy"),
("cytology", "cytology");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_path_report_type', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_path_report_type"),  
(SELECT id FROM structure_permissible_values WHERE value="FNA" AND language_alias="FNA"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_path_report_type"),  
(SELECT id FROM structure_permissible_values WHERE value="core biopsy" AND language_alias="core biopsy"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_path_report_type"),  
(SELECT id FROM structure_permissible_values WHERE value="cytology" AND language_alias="cytology"), "3", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("atypical", "atypical");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_cytology_result', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_cytology_result"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_cytology_result"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_cytology_result"),  
(SELECT id FROM structure_permissible_values WHERE value="atypical" AND language_alias="atypical"), "3", "1");

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'path_number', 'path report number', '', 'input', 'size=15', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'report_type', 'path report type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_path_report_type'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'ihc', 'ihc', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_test_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'er', 'er', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_test_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'pr', 'pr', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_test_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'wt1', 'wt1', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_test_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'p53', 'p53', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_test_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'bcat', 'bcat', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_test_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'her2', 'her2', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_test_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_lab_pathologies', 'cytology', 'cytology', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_cytology_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('ohri_ed_lab_pathologies', '', '', '1', '1', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `language_label`='event_form_type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `language_help`=''), 
'1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `language_help`=''), 
'1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `language_label`='summary' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='path_number'), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='report_type'), 
'1', '11', '', '1', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='ihc'), 
'2', '20', 'data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='er'), 
'2', '21', '', '1', '', '1', 'er', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='pr'), 
'2', '22', '', '1', '', '1', 'pr', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='wt1'), 
'2', '23', '', '1', '', '1', 'wt1', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='p53'), 
'2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='bcat'), 
'2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='her2'), 
'2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_pathologies' AND `field`='cytology'), 
'2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'); 

-- Event : presentation --

CREATE TABLE IF NOT EXISTS `ohri_ed_clinical_presentations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `brca` varchar(50) DEFAULT NULL,
  `platinum` varchar(50) DEFAULT NULL,
    
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_ed_clinical_presentations`
  ADD CONSTRAINT `ohri_ed_clinical_presentations_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ohri_ed_clinical_presentations_revs` (
  `id` int(11) NOT NULL,
  
  `brca` varchar(50) DEFAULT NULL,
  `platinum` varchar(50) DEFAULT NULL,
    
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ohri', 'clinical', 'presentation', 1, 'ohri_ed_clinical_presentations', 'ohri_ed_clinical_presentations', 0, 'clinical|ohri|presentation');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("wild type", "wild type"),
("BRCA mutation known but not identified", "BRCA mutation known but not identified"),
("BRCA1 mutated", "BRCA1 mutated"),
("BRCA2 mutated", "BRCA2 mutated"),
("BRCA1/2 mutated", "BRCA1/2 mutated");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_brca_result', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_brca_result"),  
(SELECT id FROM structure_permissible_values WHERE value="wild type" AND language_alias="wild type"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_brca_result"),  
(SELECT id FROM structure_permissible_values WHERE value="BRCA mutation known but not identified" AND language_alias="BRCA mutation known but not identified"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_brca_result"),  
(SELECT id FROM structure_permissible_values WHERE value="BRCA1 mutated" AND language_alias="BRCA1 mutated"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_brca_result"),  
(SELECT id FROM structure_permissible_values WHERE value="BRCA2 mutated" AND language_alias="BRCA2 mutated"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_brca_result"),  
(SELECT id FROM structure_permissible_values WHERE value="BRCA1/2 mutated" AND language_alias="BRCA1/2 mutated"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_brca_result"),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "6", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("resistant", "resistant"),
("sensitive", "sensitive");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_platinum_result', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_platinum_result"),  
(SELECT id FROM structure_permissible_values WHERE value="resistant" AND language_alias="resistant"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_platinum_result"),  
(SELECT id FROM structure_permissible_values WHERE value="sensitive" AND language_alias="sensitive"), "2", "1");

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_clinical_presentations', 'brca', 'brca', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_brca_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_clinical_presentations', 'platinum', 'platinum', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_platinum_result'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('ohri_ed_clinical_presentations', '', '', '1', '1', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_presentations'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `language_label`='event_form_type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `language_help`=''), 
'1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_presentations'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `language_help`=''), 
'1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_presentations'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_presentations'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `language_label`='summary' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='ohri_ed_clinical_presentations'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_presentations' AND `field`='brca'), 
'2', '20', 'data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_presentations'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_presentations' AND `field`='platinum'), 
'2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

-- Event : ctscan --

CREATE TABLE IF NOT EXISTS `ohri_ed_clinical_ctscans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `response` varchar(50) DEFAULT NULL,
    
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_ed_clinical_ctscans`
  ADD CONSTRAINT `ohri_ed_clinical_ctscans_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ohri_ed_clinical_ctscans_revs` (
  `id` int(11) NOT NULL,
  
  `response` varchar(50) DEFAULT NULL,
    
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ohri', 'clinical', 'ctscan', 1, 'ohri_ed_clinical_ctscans', 'ohri_ed_clinical_ctscans', 0, 'clinical|ohri|ctscan');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'ohri_ed_clinical_ctscans', 'response', 'response', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='response'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('ohri_ed_clinical_ctscans', '', '', '1', '1', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `language_label`='event_form_type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `language_help`=''), 
'1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `language_help`=''), 
'1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `language_label`='summary' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_ctscans' AND `field`='response'), 
'2', '21', 'data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'), 'notEmpty', '0', '0', '', 'value is required');

UPDATE menus SET flag_active = '0'
WHERE use_link LIKE '/clinicalannotation/event_masters/%' AND language_title IN ('screening', 'lifestyle', 'adverse events', 'clin_study', 'protocol');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('ohri', 'OHRI', 'IRHO'),
('ctscan', 'CT-Scan', ''),
('brca', 'BRCA', ''),
('platinum', 'Pplatinum', ''),
('wild type', 'Wild Type', ''),
('BRCA mutation known but not identified', 'BRCA mutation known but not identified', ''),
('BRCA1 mutated', 'BRCA1 mutated', ''),
('BRCA2 mutated', 'BRCA2 mutated', ''),
('BRCA1/2 mutated', 'BRCA1/2 mutated', ''),
('wt1', 'WT1', ''),
('p53', 'P53', ''),
('bcat', 'BCAT', ''),
("resistant", "Resistant", ''),
("sensitive", "Sensitive", ''),
('core biopsy', 'Core Biopsy', ''),
('path report number', 'Path Report Number', ''),
('a presentation can only be created once per participant', 'A presentation can only be created once per participant!', 'Un présentation ne peut être créée qu''une fois pour un participant!');

-- treatment --

UPDATE `tx_controls` SET flag_active = '0';

CREATE TABLE IF NOT EXISTS `ohri_txd_surgeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `residual_disease` varchar(50) DEFAULT NULL,
  
  `tx_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ohri_txd_surgeries`
  ADD CONSTRAINT `FK_ohri_txd_surgeries_tx_masters` FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);
  
CREATE TABLE IF NOT EXISTS `ohri_txd_surgeries_revs` (
  `id` int(11) NOT NULL,
  
  `residual_disease` varchar(50) DEFAULT NULL,
  
  `tx_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'surgery', 'ohri', 1, 'ohri_txd_surgeries', 'ohri_txd_surgeries', NULL, NULL, 0, 2, NULL, 'ohri|surgery ');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("> 2cm", "> 2cm"),
("1-2cm", "1-2cm"),
("< 1cm", "< 1cm"),
("none visible", "none visible"),
("undefined", "undefined");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_residual_disease', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_residual_disease"),  
(SELECT id FROM structure_permissible_values WHERE value="> 2cm" AND language_alias="> 2cm"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_residual_disease"),  
(SELECT id FROM structure_permissible_values WHERE value="1-2cm" AND language_alias="1-2cm"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_residual_disease"),  
(SELECT id FROM structure_permissible_values WHERE value="< 1cm" AND language_alias="< 1cm"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_residual_disease"),  
(SELECT id FROM structure_permissible_values WHERE value="none visible" AND language_alias="none visible"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_residual_disease"),  
(SELECT id FROM structure_permissible_values WHERE value="undefined" AND language_alias="undefined"), "5", "1");

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'TreatmentDetail', 'ohri_txd_surgeries', 'residual_disease', 'residual disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_residual_disease'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ohri_txd_surgeries', '', '', '1', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_txd_surgeries'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method'), 
'1', '1', 'clin_treatment', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ohri_txd_surgeries'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date'), 
'1', '2', '', '1', 'date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_txd_surgeries'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date_accuracy'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_txd_surgeries'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_intent'), 
'1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_txd_surgeries'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ohri_txd_surgeries' AND `field`='residual_disease'), 
'1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_txd_surgeries'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes'), 
'1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'radiation', 'ohri', 1, 'txd_radiations', 'txd_radiations', NULL, NULL, 0, NULL, NULL, 'ohri|radiation');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('protocol_master_id','information_source','facility','target_site_icdo') 
AND str.alias IN ('txd_radiations')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.display_order = '7'
WHERE sfi.field IN ('tx_intent') 
AND str.alias IN ('txd_radiations')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.language_heading = ''
WHERE sfi.field IN ('rad_completed') 
AND str.alias IN ('txd_radiations')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE tx_controls SET applied_protocol_control_id = NULL;
DELETE FROM protocol_controls;

INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(null, 'ohri', 'chemotherapy', 'pd_chemos', 'pd_chemos', 'pe_chemos', 'pe_chemos', NULL, 0, NULL, 0, 1);

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('arm','name') 
AND str.alias IN ('protocolmasters','pd_chemos')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'chemotherapy', 'ohri', 1, 'txd_chemos', 'txd_chemos', 'txe_chemos', 'txe_chemos', 0, (SELECT id FROM protocol_controls WHERE tumour_group = 'ohri'), 'importDrugFromChemoProtocol', 'ohri|chemotherapy');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('target_site_icdo','facility','information_source','num_cycles', 'length_cycles', 'completed_cycles') 
AND str.alias IN ('txd_chemos')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.display_order = '7'
WHERE sfi.field IN ('tx_intent') 
AND str.alias IN ('txd_chemos')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.language_heading = ''
WHERE sfi.field IN ('chemo_completed') 
AND str.alias IN ('txd_chemos')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('residual disease', 'Residual Disease', ''),
('none visible', 'None Visible', ''),
('undefined', 'Undefined', '');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date'), 'notEmpty', '0', '0', '', 'value is required');

-- familyhistories --

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('previous_primary_code', 'previous_primary_code_system') 
AND str.alias IN ('FamilyHistory')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("breast", "breast"),
("ovary", "ovary"),
("other", "other");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_fam_hist_disease_site', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_fam_hist_disease_site"),  
(SELECT id FROM structure_permissible_values WHERE value="breast" AND language_alias="breast"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_fam_hist_disease_site"),  
(SELECT id FROM structure_permissible_values WHERE value="ovary" AND language_alias="ovary"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_fam_hist_disease_site"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "3", "1");

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'Clinicalannotation', 'FamilyHistory', 'family_histories', 'ohri_disease_site', 'disease site', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_fam_hist_disease_site'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), 
(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `field`='ohri_disease_site'), 
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'); 

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('disease site', 'Disease Site','');

ALTER TABLE family_histories
	ADD `ohri_disease_site` varchar(50) DEFAULT NULL AFTER `age_at_dx_accuracy`;
ALTER TABLE family_histories_revs
	ADD `ohri_disease_site` varchar(50) DEFAULT NULL AFTER `age_at_dx_accuracy`;

-- identifier --

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`) VALUES
(null, 'ohri_hospital_card', '', 1, 1, '', '', 0),
(null, 'ohri_bank_participant_id', '', 1, 3, 'ohri_bank_participant_id', 'OHRI-%%key_increment%%', 1);

INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('ohri_bank_participant_id', 679);

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('misc_identifier_name_abbrev', 'identifier_abrv') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('effective_date', 'expiry_date') 
AND str.alias IN ('miscidentifiers', 'incrementedmiscidentifiers')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('ohri_hospital_card', 'Hospital Card', ''),
('ohri_bank_participant_id', 'Bank Number', '');

-- Storage --

UPDATE storage_controls SET flag_active = '0'
WHERE storage_type NOT IN ('freezer', 'box81', 'shelf', 'rack16');

INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `form_alias_for_children_pos`, `detail_tablename`, `databrowser_label`) VALUES
(null, 'box50', 'B50', 'position', 'integer', 50, NULL, NULL, NULL, 10, 5, 0, 0, 1, 'FALSE', 'FALSE', 1, 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs', 'box81');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('box50', 'Box50 1-5', 'Boîte50 1-50');

-- inventory --

- ajouter ligne suivante au trunk

INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES ((SELECT id FROM sample_controls WHERE sample_type = 'cell culture'),(SELECT id FROM sample_controls WHERE sample_type = 'protein'),0);

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(152);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131, 23, 136, 13, 14, 138, 142, 143, 141, 144, 7, 130, 8, 9, 101, 102, 140, 11, 10);
UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(23, 18, 54, 19, 41);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(8);

UPDATE banks SET name = 'OHRI - Ovary Bank', description = '' WHERE id = '1';

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id'), 'notEmpty', '0', '0', '', 'value is required');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('acquisition_label') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_override_label  = '1',
sfo.language_label  = 'participant code'
WHERE sfi.field = 'field1' 
AND str.alias IN ('collections')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 	

TRUNCATE structure_permissible_values_customs;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('sop_master_id') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Inventorymanagement', 'ViewCollection', '', 'ohri_bank_participant_id', 'ohri_bank_participant_id', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewSample', '', 'ohri_bank_participant_id', 'ohri_bank_participant_id', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'ohri_bank_participant_id', 'ohri_bank_participant_id', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `field`='ohri_bank_participant_id'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='ohri_bank_participant_id'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `field`='ohri_bank_participant_id'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

DROP VIEW IF EXISTS view_collections;
CREATE VIEW view_collections AS 
SELECT 
col.id AS collection_id,
col.bank_id AS bank_id,
col.sop_master_id AS sop_master_id,
link.participant_id AS participant_id,
link.diagnosis_master_id AS diagnosis_master_id,
link.consent_master_id AS consent_master_id,

part.participant_identifier AS participant_identifier,

col.acquisition_label AS acquisition_label,

col.collection_site AS collection_site,
col.collection_datetime AS collection_datetime,
col.collection_datetime_accuracy AS collection_datetime_accuracy,
col.collection_property AS collection_property,
col.collection_notes AS collection_notes,
col.deleted AS deleted,
banks.name AS bank_name,

idents.identifier_value AS ohri_bank_participant_id,
col.created AS created 

from collections col 
left join clinical_collection_links link on col.id = link.collection_id and link.deleted != 1
left join participants part on link.participant_id = part.id and part.deleted != 1
left join banks on col.bank_id = banks.id and banks.deleted != 1 
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'ohri_bank_participant_id'
where col.deleted != 1;

DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id AS sample_control_id,
samp.sample_code,
samp.sample_category,
samp.deleted,

idents.identifier_value AS ohri_bank_participant_id 

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'ohri_bank_participant_id'
WHERE samp.deleted != 1;

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted,

idents.identifier_value AS qc_cusm_prostate_bank_identifier

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'ohri_bank_participant_id'
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('lot_number')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

ALTER TABLE ad_tubes
	ADD `ohri_storage_method` varchar(100) DEFAULT NULL AFTER `cell_count_unit`,
	ADD `ohri_storage_solution` varchar(100) NOT NULL DEFAULT '' AFTER `ohri_storage_method`;
	
ALTER TABLE ad_tubes_revs
	ADD `ohri_storage_method` varchar(100) DEFAULT NULL AFTER `cell_count_unit`,
	ADD `ohri_storage_solution` varchar(100) NOT NULL DEFAULT '' AFTER `ohri_storage_method`;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_storage_method', '', '', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("flash frozen", "flash frozen");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_storage_method"),  (SELECT id FROM structure_permissible_values WHERE value="flash frozen" AND language_alias="flash frozen"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_storage_solution', '', '', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("dmso", "dmso");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_storage_solution"),  
(SELECT id FROM structure_permissible_values WHERE value="dmso" AND language_alias="dmso"), "1", "1");

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ohri_ad_der_ascite_cells', '', '', '1', '1', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'ohri_storage_method', 'ohri storage method', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_storage_method') , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'ohri_storage_solution', 'ohri storage solution', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_storage_solution') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `language_help`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`='generated_parent_sample_sample_type_help'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `language_label`='aliquot type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `language_help`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `language_label`='barcode' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `language_label`='aliquot in stock' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `language_help`='aliquot_in_stock_help'), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `language_label`='aliquot in stock detail' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  AND `language_help`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='aliquot_use_counter' AND `language_label`='use' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `language_label`='storage' AND `language_tag`='storage selection label' AND `type`='autocomplete' AND `setting`='url=/storagelayout/storage_masters/autocompleteLabel' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `language_label`='storage' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`='stor_selection_label_defintion'), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_master_id' AND `language_label`='storage code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code'), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `language_label`='position into storage' AND `language_tag`='' AND `type`='input' AND `setting`='size=4' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'), 

((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=4' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `language_label`='initial storage date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `language_label`='storage temperature' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `language_help`=''), '0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `language_label`='aliquot sop' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list')  AND `language_help`=''), '0', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `language_label`='study' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `language_help`=''), '0', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='creat_to_stor_spent_time_msg' AND `language_label`='creation to storage spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `language_label`='lot number' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `language_label`='current volume' AND `language_tag`='' AND `type`='float' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `language_help`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `language_label`='initial volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `language_help`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `language_label`='copy control' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='ohri_storage_method' AND `language_label`='ohri storage method' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_storage_method')  AND `language_help`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_ad_der_ascite_cells'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='ohri_storage_solution' AND `language_label`='ohri storage solution' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_storage_solution')  AND `language_help`=''), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT INTO `aliquot_controls` (`id`, `aliquot_type`, `aliquot_type_precision`, `form_alias`, `detail_tablename`, `volume_unit`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, 'tube', 'asctie cells tube', 'ohri_ad_der_ascite_cells', 'ad_tubes', 'ml', 'Asctie Cells Tube', 0, 'tube');

INSERT INTO sample_to_aliquot_controls (sample_control_id,aliquot_control_id,flag_active)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'ascite cell'),(SELECT id FROM aliquot_controls WHERE form_alias = 'ohri_ad_der_ascite_cells'),1);

SET @samp_to_al_id = (SELECT id FROM sample_to_aliquot_controls WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'ascite cell') AND aliquot_control_id = (SELECT id FROM aliquot_controls WHERE form_alias = 'ohri_ad_der_ascite_cells'));

INSERT INTO realiquoting_controls (	parent_sample_to_aliquot_control_id,child_sample_to_aliquot_control_id,flag_active)
VALUES
(@samp_to_al_id,@samp_to_al_id,1);

UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(10);

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('dmso', 'DMSO', 'DMSO'),
('flash frozen', 'Flash Frozen', ''),
('ohri storage method', 'Storage Method', ''),
('ohri storage solution', 'Storage Solution', ''),
('ovary', 'Ovary', 'Ovaire'),
('omenteum', 'Omenteum', ''),
('peritoneal nodule', 'Peritoneal Nodule', '');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('pathology_reception_datetime')
AND str.alias = 'sd_spe_tissues'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

ALTER TABLE sd_spe_tissues
	ADD `ohri_tissue_nature` varchar(100) DEFAULT NULL AFTER `tissue_nature`;
	
ALTER TABLE sd_spe_tissues_revs
	ADD `ohri_tissue_nature` varchar(100) DEFAULT NULL AFTER `tissue_nature`;
	
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_tissue_nature', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("normal", "normal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_nature"),  (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="normal"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("tumoral", "tumoral");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_nature"),  (SELECT id FROM structure_permissible_values WHERE value="tumoral" AND language_alias="tumoral"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("benign", "benign");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_nature"),  (SELECT id FROM structure_permissible_values WHERE value="benign" AND language_alias="benign"), "3", "1");

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'ohri_tissue_nature', 'tissue nature', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tissue_nature') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ohri_tissue_nature'),
'1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

INSERT IGNORE INTO i18n (id,en)
VALUES ('tumoral','Tumoral'), ('tissue nature', 'Nature');

ALTER TABLE sd_spe_tissues
	ADD `ohri_tissue_review_status` varchar(20) DEFAULT NULL AFTER `tissue_weight_unit`,
	ADD `ohri_p53` varchar(20) DEFAULT NULL AFTER `ohri_tissue_review_status`,
	ADD `ohri_wt1` varchar(20) DEFAULT NULL AFTER `ohri_p53`;
	
ALTER TABLE sd_spe_tissues_revs
	ADD `ohri_tissue_review_status` varchar(20) DEFAULT NULL AFTER `tissue_weight_unit`,
	ADD `ohri_p53` varchar(20) DEFAULT NULL AFTER `ohri_tissue_review_status`,
	ADD `ohri_wt1` varchar(20) DEFAULT NULL AFTER `ohri_p53`;
		
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('ohri_tissue_review_status', '', '', NULL),
('ohri_tissue_review_result', '', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("negative", "negative"),
("positive", "positive"),
("agree", "agree"),
("disagree", "disagree");

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_review_status"),  
(SELECT id FROM structure_permissible_values WHERE value="agree" AND language_alias="agree"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_review_status"),  
(SELECT id FROM structure_permissible_values WHERE value="disagree" AND language_alias="disagree"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_review_result"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_review_result"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1");

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'ohri_tissue_review_status', 'tissue review status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tissue_review_status') , '', 'open', 'open', 'open'),
('', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'ohri_p53', 'p53', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tissue_review_result') , '', 'open', 'open', 'open'),
('', 'Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'ohri_wt1', 'wt1', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tissue_review_result') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ohri_tissue_review_status'),
'1', '60', 'tissue review', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ohri_p53'),
'1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ohri_wt1'),
'1', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT IGNORE INTO i18n (id,en)
VALUES ('agree','Agree'), ('disagree', 'Disagree'), ('tissue review', 'Tissue Review'),('tissue review status', 'Status');
	
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('patho_dpt_block_code')
AND str.alias = 'ad_spec_tiss_blocks'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_value_domains_permissible_values
SET flag_active = '0'
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="block_type")
AND structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values WHERE value="paraffin" AND language_alias="paraffin");

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='ohri_storage_method'), 
'1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('ohri_tissue_slide_ihc', '', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("p53", "p53"),
("wt1", "wt1");

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_slide_ihc"),  
(SELECT id FROM structure_permissible_values WHERE value="p53" AND language_alias="p53"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tissue_slide_ihc"),  
(SELECT id FROM structure_permissible_values WHERE value="wt1" AND language_alias="wt1"), "2", "1");

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotDetail', '', 'immunochemistry', 'immunochemistry code', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tissue_slide_ihc') , '', 'open', 'open', 'open');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ohri_tissue_slide_ihc') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotDetail' AND tablename='' AND field='immunochemistry' AND type='input' AND structure_value_domain  IS NULL );

UPDATE specimen_review_controls SET flag_active = '0';

UPDATE menus SET flag_active = '0'
WHERE `use_link` LIKE '/study/%' AND `use_link` NOT LIKE '/study/study_summaries%';

UPDATE menus SET flag_active = '0'
WHERE `use_link` LIKE '/sop/%';

UPDATE menus SET flag_active = '0'
WHERE `use_link` LIKE '/material/%';

UPDATE menus SET flag_active = '0'
WHERE `use_link` LIKE '/rtbform/%';


UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = sfo.flag_search
WHERE str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '0', sfo.flag_search = '0'
WHERE str.alias = 'treatmentmasters'
AND sfi.field NOT IN ('disease_site', 'tx_method', 'tx_intent', 'start_date')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field NOT IN ('family_domain','relation','ohri_disease_site','primary_icd10_code','age_at_dx','age_at_dx_accuracy')
AND str.alias = 'familyhistories'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index = '1', sfo.flag_search = '1'
WHERE str.alias = 'sd_spe_tissues'
AND sfi.field IN ('ohri_wt1', 'ohri_tissue_review_status', 'ohri_p53')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;







