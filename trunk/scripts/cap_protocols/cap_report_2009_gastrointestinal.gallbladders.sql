/*Table structure for table 'dxd_cap_report_gallbladders' */

DROP TABLE IF EXISTS `dxd_cap_report_gallbladders`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_gallbladders` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11)  NULL DEFAULT 0,
-- specimen
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `liver` tinyint(1) NULL DEFAULT 0,
  `extrahepatic_bile_duct` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,  
-- procedure  
  `procedure` varchar(100) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL, 
-- tumor site  
  `fundus` tinyint(1) NULL DEFAULT 0,  
  `body` tinyint(1) NULL DEFAULT 0,  
  `neck` tinyint(1) NULL DEFAULT 0,  
  `cystic_duct` tinyint(1) NULL DEFAULT 0,  
  `free_peritoneal_side_of_gallbladder` tinyint(1) NULL DEFAULT 0,  
  `hepatic_side_of_gallbladder` tinyint(1) NULL DEFAULT 0,  
  `cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,  
  `tumor_site_other_specify` varchar(250) DEFAULT NULL, 
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0, 
  
-- tumor size in master  
  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  
-- histologic grade in masters   tumor_grade and tumor_grade_specify

-- Microscopic Tumor Extension
  `microscopic_tumor_extension` varchar(100) DEFAULT NULL, 
  `microscopic_tumor_extension_specify` varchar(250) DEFAULT NULL,  
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `specify_margin` varchar(250) DEFAULT NULL,
  `margin_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `specify_margins` varchar(250) DEFAULT NULL,  
  `cystic_duct_margin_uninvolved_by_intramucosal_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `cystic_duct_margin_involved_by_intramucosal_carcinoma` tinyint(1) NULL DEFAULT 0,    

-- Lymph-Vascular Invasion  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `none_identified` tinyint(1)  NULL DEFAULT 0,    
  `dysplasia_adenoma` tinyint(1)  NULL DEFAULT 0, 
  `cholelithiasis` tinyint(1)  NULL DEFAULT 0, 
  `chronic_cholecystitis` tinyint(1)  NULL DEFAULT 0, 
  `acute_cholecystitis` tinyint(1)  NULL DEFAULT 0, 
  `intestinal_metaplasia` tinyint(1)  NULL DEFAULT 0, 
  `diffuse_calcification_porcelain_gallbladder` tinyint(1)  NULL DEFAULT 0, 
  `additional_path_other` tinyint(1)  NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,   
  `not_performed` tinyint(1)  NULL DEFAULT 0,   
-- clinical history  
  `clin_cholelithiasis`  tinyint(1)  NULL DEFAULT 0,
  `primary_sclerosing_cholangitis` tinyint(1)  NULL DEFAULT 0,
  `other_clinical_history` tinyint(1)  NULL DEFAULT 0,  
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `comments` varchar(250) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11)  NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `dxd_cap_report_gallbladders` ADD CONSTRAINT `FK_dxd_cap_report_gallbladders_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_gallbladders_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_gallbladders_revs`;

CREATE TABLE `dxd_cap_report_gallbladders_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11)  NULL DEFAULT 0,
-- specimen
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `liver` tinyint(1) NULL DEFAULT 0,
  `extrahepatic_bile_duct` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,  
-- procedure  
  `procedure` varchar(100) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL, 
-- tumor site  
  `fundus` tinyint(1) NULL DEFAULT 0,  
  `body` tinyint(1) NULL DEFAULT 0,  
  `neck` tinyint(1) NULL DEFAULT 0,  
  `cystic_duct` tinyint(1) NULL DEFAULT 0,  
  `free_peritoneal_side_of_gallbladder` tinyint(1) NULL DEFAULT 0,  
  `hepatic_side_of_gallbladder` tinyint(1) NULL DEFAULT 0,  
  `cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,  
  `tumor_site_other_specify` varchar(250) DEFAULT NULL, 
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0, 
  
-- tumor size in master  
  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  
-- histologic grade in masters   tumor_grade and tumor_grade_specify

-- Microscopic Tumor Extension
  `microscopic_tumor_extension` varchar(100) DEFAULT NULL, 
  `microscopic_tumor_extension_specify` varchar(250) DEFAULT NULL,  
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `specify_margin` varchar(250) DEFAULT NULL,
  `margin_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `specify_margins` varchar(250) DEFAULT NULL,  
  `cystic_duct_margin_uninvolved_by_intramucosal_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `cystic_duct_margin_involved_by_intramucosal_carcinoma` tinyint(1) NULL DEFAULT 0,    

-- Lymph-Vascular Invasion  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `none_identified` tinyint(1)  NULL DEFAULT 0,    
  `dysplasia_adenoma` tinyint(1)  NULL DEFAULT 0, 
  `cholelithiasis` tinyint(1)  NULL DEFAULT 0, 
  `chronic_cholecystitis` tinyint(1)  NULL DEFAULT 0, 
  `acute_cholecystitis` tinyint(1)  NULL DEFAULT 0, 
  `intestinal_metaplasia` tinyint(1)  NULL DEFAULT 0, 
  `diffuse_calcification_porcelain_gallbladder` tinyint(1)  NULL DEFAULT 0, 
  `additional_path_other` tinyint(1)  NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,   
  `not_performed` tinyint(1)  NULL DEFAULT 0,   
-- clinical history  
  `clin_cholelithiasis`  tinyint(1)  NULL DEFAULT 0,
  `primary_sclerosing_cholangitis` tinyint(1)  NULL DEFAULT 0,
  `other_clinical_history` tinyint(1)  NULL DEFAULT 0,  
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `comments` varchar(250) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11)  NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- insert value in diagnosis_controls
insert into diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename)
values
('cap report - gallbladders', 1, 'dx_cap_report_gallbladders', 'dxd_cap_report_gallbladders');

-- The table structures hold all forms in the application, Add the dxd_cap_report_ in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_gallbladders', '', '', '0', '0', '1', '1');

-- build forms
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'liver', 'liver', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'extrahepatic_bile_duct', 'extrahepatic bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'procedure', 'procedure', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'procedure_specify', 'procedure specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'fundus', 'fundus', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'body', 'body', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'neck', 'neck', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'cystic_duct', 'cystic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'free_peritoneal_side_of_gallbladder', 'free peritoneal side of gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'hepatic_side_of_gallbladder', 'hepatic side of gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'tumor_site_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'tumor_site_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'tumor_site_not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_gb', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_gb', 'path_tstage', 'path_tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_gb', 'path_nstage', 'path_nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_gb', 'path_mstage', 'path_mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'microscopic_tumor_extension', 'microscopic tumor extension', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'microscopic_tumor_extension_specify', 'microscopic tumor extension specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'margin_uninvolved_by_invasive_carcinoma', 'margin uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'distance_of_invasive_carcinoma_from_closest_margin_mm', 'distance of invasive carcinoma from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'margin_involved_by_invasive_carcinoma', 'margin involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'specify_margins', 'specify margins', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'cystic_duct_margin_uninvolved_by_intramucosal_carcinoma', 'cystic duct margin uninvolved by intramucosal carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'cystic_duct_margin_involved_by_intramucosal_carcinoma', 'cystic duct margin involved by intramucosal carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'perineural_invasion', 'perineural invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'dysplasia_adenoma', 'dysplasia adenoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'cholelithiasis', 'cholelithiasis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'chronic_cholecystitis', 'chronic cholecystitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'acute_cholecystitis', 'acute cholecystitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'intestinal_metaplasia', 'intestinal metaplasia', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'diffuse_calcification_porcelain_gallbladder', 'diffuse calcification porcelain gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'additional_path_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'not_performed', 'not performed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'clin_cholelithiasis', 'cholelithiasis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'primary_sclerosing_cholangitis', 'primary sclerosing cholangitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'other_clinical_history', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_gallbladders', 'other_clinical_history_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='liver' AND `language_label`='liver' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='extrahepatic_bile_duct' AND `language_label`='extrahepatic bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='fundus' AND `language_label`='fundus' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='body' AND `language_label`='body' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='neck' AND `language_label`='neck' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='cystic_duct' AND `language_label`='cystic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='free_peritoneal_side_of_gallbladder' AND `language_label`='free peritoneal side of gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='hepatic_side_of_gallbladder' AND `language_label`='hepatic side of gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='tumor_site_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='tumor_site_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='tumor_site_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '20', '', '1', 'greatest dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '21', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '22', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' ), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_gb' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade_specify' ), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='microscopic_tumor_extension' AND `language_label`='microscopic tumor extension' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='microscopic_tumor_extension_specify' AND `language_label`='microscopic tumor extension specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='margin_uninvolved_by_invasive_carcinoma' AND `language_label`='margin uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_mm' AND `language_label`='distance of invasive carcinoma from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='margin_involved_by_invasive_carcinoma' AND `language_label`='margin involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='specify_margins' AND `language_label`='specify margins' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='cystic_duct_margin_uninvolved_by_intramucosal_carcinoma' AND `language_label`='cystic duct margin uninvolved by intramucosal carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='cystic_duct_margin_involved_by_intramucosal_carcinoma' AND `language_label`='cystic duct margin involved by intramucosal carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' ), '2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' ), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' ), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_gb' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  ), '2', '43', '', '1', 'path tstage', '1', '', '0', '', '1', 'select', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_gb' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  ), '2', '44', '', '1', 'path nstage', '1', '', '0', '', '1', 'select', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `structure_value_domain`  IS NULL  ), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `structure_value_domain`  IS NULL  ), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_gb' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  ), '2', '47', '', '1', 'path mstage', '1', '', '0', '', '1', 'select', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `structure_value_domain`  IS NULL  ), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='dysplasia_adenoma' AND `language_label`='dysplasia adenoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='cholelithiasis' AND `language_label`='cholelithiasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='chronic_cholecystitis' AND `language_label`='chronic cholecystitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='acute_cholecystitis' AND `language_label`='acute cholecystitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='intestinal_metaplasia' AND `language_label`='intestinal metaplasia' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='diffuse_calcification_porcelain_gallbladder' AND `language_label`='diffuse calcification porcelain gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='not_performed' AND `language_label`='not performed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='clin_cholelithiasis' AND `language_label`='cholelithiasis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='primary_sclerosing_cholangitis' AND `language_label`='primary sclerosing cholangitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_gallbladders' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '64', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');





-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='gallbladder'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='procedure'
where sfi.id=sfo.structure_field_id
and sfi.field='procedure'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='fundus'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margin'
where sfi.id=sfo.structure_field_id
and sfi.field='cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='clin_cholelithiasis'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_gallbladders'; 


-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_gallbladders'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');


-- dropdown list for select
-- invasion 
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_gallbladders' and field='lymph_vascular_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_gallbladders' and field='perineural_invasion';

-- procedure_dxd_gb
insert ignore into structure_permissible_values (value, language_alias) values
('simple cholecystectomy (laparoscopic or open)','simple cholecystectomy (laparoscopic or open)'),
('radical cholecystectomy (with liver resection and lymphadenectomy)','radical cholecystectomy (with liver resection and lymphadenectomy)'),
('not specified','not specified');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_gb', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure_dxd_gb'), (select id from structure_permissible_values where value='simple cholecystectomy (laparoscopic or open)' ), 1,1, 'simple cholecystectomy (laparoscopic or open)'),
((select id from structure_value_domains where domain_name='procedure_dxd_gb'), (select id from structure_permissible_values where value='radical cholecystectomy (with liver resection and lymphadenectomy)' ), 2,1, 'radical cholecystectomy (with liver resection and lymphadenectomy)'),
((select id from structure_value_domains where domain_name='procedure_dxd_gb'), (select id from structure_permissible_values where value='other ' ), 3,1, 'other '),
((select id from structure_value_domains where domain_name='procedure_dxd_gb'), (select id from structure_permissible_values where value='not specified' ), 4,1, 'not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure_dxd_gb')
where tablename='dxd_cap_report_gallbladders' and field='procedure';

-- histologic_type_gb
insert ignore into structure_permissible_values (value, language_alias) values
('adenocarcinoma','adenocarcinoma'),
('papillary adenocarcinoma','papillary adenocarcinoma'),
('adenocarcinoma, intestinal type','adenocarcinoma, intestinal type'),
('mucinous adenocarcinoma','mucinous adenocarcinoma'),
('signet-ring cell carcinoma','signet-ring cell carcinoma'),
('clear cell carcinoma','clear cell carcinoma'),
('squamous cell carcinoma','squamous cell carcinoma'),
('adenosquamous carcinoma','adenosquamous carcinoma'),
('small cell carcinoma','small cell carcinoma'),
('undifferentiated carcinoma','undifferentiated carcinoma'),
('carcinoma, not otherwise specified','carcinoma, not otherwise specified');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_gb', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='adenocarcinoma' ), 1,1, 'adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='papillary adenocarcinoma' ), 2,1, 'papillary adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='adenocarcinoma, intestinal type' ), 3,1, 'adenocarcinoma, intestinal type'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='mucinous adenocarcinoma' ), 4,1, 'mucinous adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='signet-ring cell carcinoma' ), 5,1, 'signet-ring cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='clear cell carcinoma' ), 6,1, 'clear cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='squamous cell carcinoma' ), 7,1, 'squamous cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='adenosquamous carcinoma' ), 8,1, 'adenosquamous carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='small cell carcinoma' ), 9,1, 'small cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='undifferentiated carcinoma' ), 10,1, 'undifferentiated carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='other' ), 11,1, 'other'),
((select id from structure_value_domains where domain_name='histologic_type_gb'), (select id from structure_permissible_values where value='carcinoma, not otherwise specified' ), 12,1, 'carcinoma, not otherwise specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_gb')
where tablename='dxd_cap_report_gallbladders' and field='histologic_type';

-- histologic_grade_gb

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_gb', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_gb'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_gb'), (select id from structure_permissible_values where value='gx' and language_alias='gx: cannot be assessed'), 2,1,'gx: cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_gb'), (select id from structure_permissible_values where value='g1' and language_alias='g1: well differentiated'), 3,1, 'g1: well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_gb'), (select id from structure_permissible_values where value='g2' and language_alias='g2: moderately differentiated'), 4,1,'g2: moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_gb'), (select id from structure_permissible_values where value='g3' and language_alias='g3: poorly differentiated'), 5,1,'g3: poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_gb'), (select id from structure_permissible_values where value='g4' and language_alias='g4: undifferentiated'), 6,1,'g4: undifferentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_gb'), (select id from structure_permissible_values where value='other'), 7,1, 'other');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_gb')
where tablename='diagnosis_masters_gb' and field='tumour_grade';


-- for general microscopic_tumor_extension_gb
insert ignore into structure_permissible_values (value, language_alias) values
('tumor invades lamina propria','tumor invades lamina propria'),
('tumor invades muscle layer','tumor invades muscle layer'),
('tumor invades perimuscular connective tissue; no extension beyond serosa or into liver','tumor invades perimuscular connective tissue; no extension beyond serosa or into liver'),
('tumor perforates serosa (visceral peritoneum)','tumor perforates serosa (visceral peritoneum)'),
('tumor directly invades the liver','tumor directly invades the liver'),
('tumor directly invades extrahepatic bile ducts','tumor directly invades extrahepatic bile ducts'),
('tumor directly invades other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, or omentum','tumor directly invades other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, or omentum');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('microscopic_tumor_extension_gb', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb'), (select id from structure_permissible_values where value='tumor invades lamina propria' ), 1,1, 'tumor invades lamina propria'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb'), (select id from structure_permissible_values where value='tumor invades muscle layer' ), 2,1, 'tumor invades muscle layer'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb'), (select id from structure_permissible_values where value='tumor invades perimuscular connective tissue; no extension beyond serosa or into liver' ), 3,1, 'tumor invades perimuscular connective tissue; no extension beyond serosa or into liver'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb'), (select id from structure_permissible_values where value='tumor perforates serosa (visceral peritoneum)' ), 4,1, 'tumor perforates serosa (visceral peritoneum)'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb'), (select id from structure_permissible_values where value='tumor directly invades the liver' ), 5,1, 'tumor directly invades the liver'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb'), (select id from structure_permissible_values where value='tumor directly invades extrahepatic bile ducts' ), 6,1, 'tumor directly invades extrahepatic bile ducts'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb'), (select id from structure_permissible_values where value='tumor directly invades other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, or omentum' ), 7,1, 'tumor directly invades other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, or omentum');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microscopic_tumor_extension_gb')
where tablename='dxd_cap_report_gallbladders' and field='microscopic_tumor_extension';


-- primary tumor (pt) path_tstage_gb
insert ignore into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0', 'pt0: no evidence of primary tumor'),
('ptis', 'ptis: carcinoma in situ'),
('pt1', 'pt1: tumor invades lamina propria or muscular layer'),
('pt1a', 'pt1a: tumor invades lamina propria'),
('pt1b', 'pt1b: tumor invades muscular layer'),
('pt2', 'pt2: tumor invades perimuscular connective tissue; no extension beyond serosa or into liver'),
('pt3', 'pt3: tumor perforates serosa (visceral peritoneum) and/or directly invades the liver and/or one other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, omentum, or extrahepatic bile ducts'),
('pt4', 'pt4: tumor invades main portal vein or hepatic artery or invades 2 or more extrahepatic organs or structures');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_gb', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: cannot be assessed'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='ptis' and language_alias='ptis: carcinoma in situ'), 3,1, 'ptis: carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='pt1'  and language_alias='pt1: tumor invades lamina propria or muscular layer'), 4,1, 'pt1: tumor invades lamina propria or muscular layer'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='pt1a' and language_alias='pt1a: tumor invades lamina propria'), 5,1, 'pt1a: tumor invades lamina propria'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='pt1b' and language_alias='pt1b: tumor invades muscular layer'), 6,1, 'pt1b: tumor invades muscular layer'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='pt2' and language_alias='pt2: tumor invades perimuscular connective tissue; no extension beyond serosa or into liver'), 7,1, 'pt2: tumor invades perimuscular connective tissue; no extension beyond serosa or into liver'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='pt3' and language_alias='pt3: tumor perforates serosa (visceral peritoneum) and/or directly invades the liver and/or one other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, omentum, or extrahepatic bile ducts'), 8,1, 'pt3: tumor perforates serosa (visceral peritoneum) and/or directly invades the liver and/or one other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, omentum, or extrahepatic bile ducts'),
((select id from structure_value_domains where domain_name='path_tstage_gb'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor invades main portal vein or hepatic artery or invades 2 or more extrahepatic organs or structures'), 9,1, 'pt4: tumor invades main portal vein or hepatic artery or invades 2 or more extrahepatic organs or structures');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_gb')
where tablename='diagnosis_masters_gb' and field='path_tstage';



-- regional lymph nodes (pn) path_nstage_gb
insert ignore into structure_permissible_values (value, language_alias) values
('pnx', 'pnx: cannot be assessed'),
('pn0', 'pn0: no regional lymph node metastasis'),
('pn1', 'pn1: metastases to nodes along the cystic duct, common bile duct, hepatic artery, and/or portal vein'),
('pn2', 'pn2: metastases to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_gb', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_gb'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_gb'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: no regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_gb'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: metastases to nodes along the cystic duct, common bile duct, hepatic artery, and/or portal vein'), 3,1, 'pn1: metastases to nodes along the cystic duct, common bile duct, hepatic artery, and/or portal vein'),
((select id from structure_value_domains where domain_name='path_nstage_gb'), (select id from structure_permissible_values where value='pn2' and language_alias='pn2: metastases to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes'), 4,1, 'pn2: metastases to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_gb')
where tablename='diagnosis_masters_gb' and field='path_nstage';


-- distant metastasis (pm) path_mstage_gb
insert ignore into structure_permissible_values (value, language_alias) values
('pm1', 'pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_gb', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_gb'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_gb'), (select id from structure_permissible_values where value='pm1'), 2,1, 'pm1: distant metastasis');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_gb')
where tablename='diagnosis_masters_gb' and field='path_mstage';

-- insert into i18n
INSERT IGNORE INTO i18n (id, en, fr)
select value, value, '' from structure_permissible_values 
where value  not in (select id from i18n);

INSERT IGNORE INTO i18n (id, en, fr)
select language_alias, language_alias, '' from structure_permissible_values 
where language_alias not in (select id from i18n);
