/*Table structure for table 'dxd_cap_report_colons' */

DROP TABLE IF EXISTS `dxd_cap_report_colons`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_colons` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NULL DEFAULT 0,
-- tumor_site 
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,
-- specimen_integrity
  `intact` tinyint(1) NULL DEFAULT 0,
  `fragmental` tinyint(1) NULL DEFAULT 0,
-- polyp size
  `polyp_size_greatest_dimension` decimal (3,1)NULL DEFAULT NULL,
  `additional_dimension_a` decimal (3,1)NULL DEFAULT NULL,
  `additional_dimension_b` decimal (3,1)NULL DEFAULT NULL,
  `cannot_be_determined` tinyint(1) NULL DEFAULT 0,
-- polyp configuration
  `pedunculated_with_stalk` tinyint(1) NULL DEFAULT 0,
  `stalk_length_cm` decimal (3,1)NULL DEFAULT NULL,
  `sessile` tinyint(1) NULL DEFAULT 0,
--  size of invasive carcinoma in master  tumor size
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters  
-- Microscopic Tumor Extension
  `microscopic_tumor_extension` varchar(50) DEFAULT NULL, 
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,

  `not_applicable` tinyint(1) NULL DEFAULT 0, 
  `mm_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `mm_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `mm_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `mm_involved_by_adenoma` tinyint(1) NULL DEFAULT 0,
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,

  `type_of_polyp_in_which_invasive_carcinoma_arose` varchar(50) DEFAULT NULL,
--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `inflammatory_bowel_disease` tinyint(1) NULL DEFAULT 0, 
  `active` tinyint(1) NULL DEFAULT 0, 
  `quiescent` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
  `not_performed`  tinyint(1) NULL DEFAULT 0,

  `comments` varchar(250) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `dxd_cap_report_colons` ADD CONSTRAINT `FK_dxd_cap_report_colons_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_colons_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_colons_revs`;

CREATE TABLE `dxd_cap_report_colons_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NULL DEFAULT 0,
-- tumor_site 
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,
-- specimen_integrity
  `intact` tinyint(1) NULL DEFAULT 0,
  `fragmental` tinyint(1) NULL DEFAULT 0,
-- polyp size
  `polyp_size_greatest_dimension` decimal (3,1)NULL DEFAULT NULL,
  `additional_dimension_a` decimal (3,1)NULL DEFAULT NULL,
  `additional_dimension_b` decimal (3,1)NULL DEFAULT NULL,
  `cannot_be_determined` tinyint(1) NULL DEFAULT 0,
-- polyp configuration
  `pedunculated_with_stalk` tinyint(1) NULL DEFAULT 0,
  `stalk_length_cm` decimal (3,1)NULL DEFAULT NULL,
  `sessile` tinyint(1) NULL DEFAULT 0,
--  size of invasive carcinoma in master  tumor size
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters  
-- Microscopic Tumor Extension
  `microscopic_tumor_extension` varchar(50) DEFAULT NULL, 
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,

  `not_applicable` tinyint(1) NULL DEFAULT 0, 
  `mm_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `mm_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `mm_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `mm_involved_by_adenoma` tinyint(1) NULL DEFAULT 0,
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,

  `type_of_polyp_in_which_invasive_carcinoma_arose` varchar(50) DEFAULT NULL,
--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `inflammatory_bowel_disease` tinyint(1) NULL DEFAULT 0, 
  `active` tinyint(1) NULL DEFAULT 0, 
  `quiescent` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
  `not_performed`  tinyint(1) NULL DEFAULT 0,
  
  `comments` varchar(250) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- insert value in diagnosis_controls
insert into diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename)
values
('cap report - colon rectums', 1, 'dx_cap_report_colons', 'dxd_cap_report_colons');

-- The table structures hold all forms in the application, Add the dxd_cap_report_ in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_colons', '', '', '0', '0', '1', '1');

-- form builder
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'tumor_site_specify', 'tumor site specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'intact', 'intact', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'fragmental', 'fragmental', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'polyp_size_greatest_dimension', 'polyp size greatest dimension', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'additional_dimension_a', 'additional dimension', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'additional_dimension_b', '', 'x', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'pedunculated_with_stalk', 'pedunculated with stalk', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'stalk_length_cm', '', 'stalk length cm', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'sessile', 'sessile', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'microscopic_tumor_extension', 'microscopic tumor extension', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'uninvolved_by_invasive_carcinoma', 'uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'distance_of_invasive_carcinoma_from_closest_margin_mm', 'distance of invasive carcinoma from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'involved_by_invasive_carcinoma', 'involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'not_applicable', 'not applicable', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'mm_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'mm_uninvolved_by_invasive_carcinoma', 'uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'mm_involved_by_invasive_carcinoma', 'involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'mm_involved_by_adenoma', 'involved by adenoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'type_of_polyp_in_which_invasive_carcinoma_arose', 'type of polyp in which invasive carcinoma arose', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'additional_path_none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'inflammatory_bowel_disease', 'inflammatory bowel disease', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'active', '', 'active', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'quiescent', '', 'quiescent', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'additional_path_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'not_performed', 'not performed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colons', 'tumor_site', 'tumor site', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_c', 'tumour_grade', 'tumour grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='tumor_site_specify' AND `language_label`='tumor site specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='intact' AND `language_label`='intact' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='fragmental' AND `language_label`='fragmental' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='polyp_size_greatest_dimension' AND `language_label`='polyp size greatest dimension' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='additional_dimension_a' AND `language_label`='additional dimension' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='additional_dimension_b' AND `language_label`='' AND `language_tag`='x' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='pedunculated_with_stalk' AND `language_label`='pedunculated with stalk' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='stalk_length_cm' AND `language_label`='' AND `language_tag`='stalk length cm' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='sessile' AND `language_label`='sessile' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '14', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '15', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='microscopic_tumor_extension' AND `language_label`='microscopic tumor extension' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' ), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='uninvolved_by_invasive_carcinoma' AND `language_label`='uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_mm' AND `language_label`='distance of invasive carcinoma from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='involved_by_invasive_carcinoma' AND `language_label`='involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='not_applicable' AND `language_label`='not applicable' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='mm_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='mm_uninvolved_by_invasive_carcinoma' AND `language_label`='uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='mm_involved_by_invasive_carcinoma' AND `language_label`='involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='mm_involved_by_adenoma' AND `language_label`='involved by adenoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='type_of_polyp_in_which_invasive_carcinoma_arose' AND `language_label`='type of polyp in which invasive carcinoma arose' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='additional_path_none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='inflammatory_bowel_disease' AND `language_label`='inflammatory bowel disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='active' AND `language_label`='' AND `language_tag`='active' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='quiescent' AND `language_label`='' AND `language_tag`='quiescent' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='not_performed' AND `language_label`='not performed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '40', '', '0', '', '0', '', '1', '', '0', '', '2', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_colons' AND `field`='tumor_site' AND `language_label`='tumor site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_colons'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_c' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen integrity'
where sfi.id=sfo.structure_field_id
and sfi.field='intact'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='polyp size'
where sfi.id=sfo.structure_field_id
and sfi.field='polyp_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='polyp configuration'
where sfi.id=sfo.structure_field_id
and sfi.field='pedunculated_with_stalk'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 


update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='size of invasive carcinoma'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='deep margin'
where sfi.id=sfo.structure_field_id
and sfi.field='cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='mucosal/Lateral margin'
where sfi.id=sfo.structure_field_id
and sfi.field='not_applicable'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 


update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 


-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_colons'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');


-- dropdown list for select

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_colons' and field='lymph_vascular_invasion';

-- tumor_site_c
insert ignore into structure_permissible_values (value, language_alias) values
('cecum','cecum'),
('right (ascending) colon','right (ascending) colon'),
('hepatic flexure','hepatic flexure'),
('transverse colon','transverse colon'),
('splenic flexure','splenic flexure'),
('left (descending) colon','left (descending) colon'),
('sigmoid colon','sigmoid colon'),
('rectum','rectum');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('tumor_site_c', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='cecum' ), 1,1, 'cecum'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='right (ascending) colon' ), 2,1, 'right (ascending) colon'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='hepatic flexure' ), 3,1, 'hepatic flexure'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='transverse colon' ), 4,1, 'transverse colon'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='splenic flexure' ), 5,1, 'splenic flexure'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='left (descending) colon' ), 6,1, 'left (descending) colon'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='sigmoid colon' ), 7,1, 'sigmoid colon'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='rectum' ), 8,1, 'rectum'),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='other ' ), 9,1, 'other '),
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='not specified' ), 10,1, 'not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='tumor_site_c')
where tablename='dxd_cap_report_colons' and field='tumor_site';

-- histologic_type_c
insert ignore into structure_permissible_values (value, language_alias) values
('adenocarcinoma','adenocarcinoma'),
('mucinous adenocarcinoma','mucinous adenocarcinoma'),
('signet-ring cell carcinoma','signet-ring cell carcinoma'),
('small cell carcinoma','small cell carcinoma'),
('squamous cell carcinoma','squamous cell carcinoma'),
('adenosquamous carcinoma','adenosquamous carcinoma'),
('medullary carcinoma','medullary carcinoma'),
('undifferentiated carcinoma','undifferentiated carcinoma'),
('carcinoma, type cannot be determined','carcinoma, type cannot be determined');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_c', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='adenocarcinoma'), 1,1, 'adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='mucinous adenocarcinoma'), 2,1, 'mucinous adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='signet-ring cell carcinoma'), 3,1, 'signet-ring cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='squamous cell carcinoma'), 5,1, 'squamous cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='small cell carcinoma'), 4,1, 'small cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='adenosquamous carcinoma'), 7,1, 'adenosquamous carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='medullary carcinoma'), 8,1, 'medullary carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='undifferentiated carcinoma'), 9,1, 'undifferentiated carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='other'), 10,1, 'other'),
((select id from structure_value_domains where domain_name='histologic_type_c'), (select id from structure_permissible_values where value='carcinoma, type cannot be determined'), 11,1, 'carcinoma, type cannot be determined');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_c')
where tablename='dxd_cap_report_colons' and field='histologic_type';

-- histologic_grade_c
insert ignore into structure_permissible_values (value, language_alias) values
('not applicable','not applicable'),
('cannot be determined','cannot be determined'),
('low-grade (well-differentiated to moderately differentiated)','low-grade (well-differentiated to moderately differentiated)'),
('high-grade (poorly differentiated to undifferentiated)','high-grade (poorly differentiated to undifferentiated)');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_c', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='cannot be determined'), 2,1,'cannot be determined'),
((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='low-grade (well-differentiated to moderately differentiated)'), 3,1, 'low-grade (well-differentiated to moderately differentiated)'),
((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='high-grade (poorly differentiated to undifferentiated)'), 4,1,'high-grade (poorly differentiated to undifferentiated)');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_c')
where tablename='diagnosis_masters_c' and field='tumour_grade';


-- microscopic_tumor_extension_c

insert ignore into structure_permissible_values (value, language_alias) values
('cannot be determined','cannot be determined'),
('lamina propria','lamina propria'),
('muscularis mucosae','muscularis mucosae'),
('submucosa','submucosa'),
('muscularis propria','muscularis propria');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('microscopic_tumor_extension_c', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='microscopic_tumor_extension_c'), (select id from structure_permissible_values where value='cannot be determined' ), 1,1, 'cannot be determined'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_c'), (select id from structure_permissible_values where value='lamina propria' ), 2,1, 'lamina propria'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_c'), (select id from structure_permissible_values where value='muscularis mucosae' ), 3,1, 'muscularis mucosae'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_c'), (select id from structure_permissible_values where value='submucosa' ), 4,1, 'submucosa'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_c'), (select id from structure_permissible_values where value='muscularis propria' ), 5,1, 'muscularis propria');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microscopic_tumor_extension_c')
where tablename='dxd_cap_report_colons' and field='microscopic_tumor_extension';

-- type_of_polyp_in_which_invasive_carcinoma_arose
insert ignore into structure_permissible_values (value, language_alias) values
('tubular adenoma','tubular adenoma'),
('villous adenoma','villous adenoma'),
('tubulovillous adenoma','tubulovillous adenoma'),
('traditional serrated adenoma','traditional serrated adenoma'),
('sessile serrated adenoma','sessile serrated adenoma'),
('hamartomatous polyp','hamartomatous polyp'),
('indeterminate','indeterminate');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('type_of_polyp_in_which_invasive_carcinoma_arose', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose'), (select id from structure_permissible_values where value='tubular adenoma' ), 1,1, 'tubular adenoma'),
((select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose'), (select id from structure_permissible_values where value='villous adenoma' ), 2,1, 'villous adenoma'),
((select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose'), (select id from structure_permissible_values where value='tubulovillous adenoma' ), 3,1, 'tubulovillous adenoma'),
((select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose'), (select id from structure_permissible_values where value='traditional serrated adenoma' ), 4,1, 'traditional serrated adenoma'),
((select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose'), (select id from structure_permissible_values where value='sessile serrated adenoma' ), 5,1, 'sessile serrated adenoma'),
((select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose'), (select id from structure_permissible_values where value='hamartomatous polyp' ), 6,1, 'hamartomatous polyp'),
((select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose'), (select id from structure_permissible_values where value='indeterminate' ), 7,1, 'indeterminate');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='type_of_polyp_in_which_invasive_carcinoma_arose')
where tablename='dxd_cap_report_colons' and field='type_of_polyp_in_which_invasive_carcinoma_arose';
