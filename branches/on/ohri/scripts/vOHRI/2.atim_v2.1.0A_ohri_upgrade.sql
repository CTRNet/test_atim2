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
	ADD `progression_free_interval_months` int(11) DEFAULT NULL AFTER `survival_time_months`;

ALTER TABLE diagnosis_masters_revs
	ADD `progression_free_interval_months` int(11) DEFAULT NULL AFTER `survival_time_months`;

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
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'progression_free_interval_months', 'progression free interval months', '', 'integer_positive', 'size=5', '',  NULL , '', 'open', 'open', 'open'),
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
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `language_label`='origin'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
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
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='progression_free_interval_months'), 
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
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ohri_dx_others'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `language_label`='origin'), 
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
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='progression_free_interval_months'), 
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

INSERT IGNORE INTO i18n (id,en,fr) VALUES
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
('lmp', 'LMP (Low Malignant Potential)', 'LMP (Borderline)');
