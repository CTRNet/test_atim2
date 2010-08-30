/*Table structure for table 'dxd_cap_report_intrahepbileducts' */

DROP TABLE IF EXISTS `dxd_cap_report_intrahepbileducts`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_intrahepbileducts` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
-- specimen
  `liver` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,  
-- procedure  
  `wedge_resection` tinyint(1) NULL DEFAULT 0,
  `partial_hepatectomy` tinyint(1) NULL DEFAULT 0,
  `major_hepatectomy_3_segments_or_more` tinyint(1) NULL DEFAULT 0,
  `minor_hepatectomy_less_than_3_segments` tinyint(1) NULL DEFAULT 0,
  `total_hepatectomy` tinyint(1) NULL DEFAULT 0,  
  `procedure_other` tinyint(1) NULL DEFAULT 0,
  `procedure_other_specify` varchar(250) DEFAULT NULL,
  `procedure_not_specified` tinyint(1) NULL DEFAULT 0, 
  
-- tumor size in master  
-- tumor focality
  `solitary` tinyint(1) NULL DEFAULT 0,
  `specify_location` varchar(250) DEFAULT NULL,
  `multiple` tinyint(1) NULL DEFAULT 0,
  `specify_locations` varchar(250) DEFAULT NULL,
  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters   tumor_grade and tumor_grade_specify
-- Tumor Growth Pattern
  `tumor_growth_pattern` varchar(50) DEFAULT NULL,
-- Microscopic Tumor Extension
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_the_intrahepatic_bile_ducts_histologically` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_hepatic_parenchyma` tinyint(1) NULL DEFAULT 0,    
  `tumor_involves_visceral_peritoneal_surface` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_adjacent_organs_other_than_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_extension_specify` varchar(250) DEFAULT NULL,  
-- Margins  
  `hp_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1)NULL DEFAULT 0.0,
  `hp_specify_margin` varchar(250) DEFAULT NULL,
  `involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  
  `bd_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `db_margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `dysplasia_carcinoma_in_situ_not_identified` tinyint(1) NULL DEFAULT 0, 
  `dysplasia_carcinoma_in_situ_present` tinyint(1) NULL DEFAULT 0, 
  `bd_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  
  `specify_margin` varchar(250) DEFAULT NULL, 
  `special_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `special_margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `special_margin_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,    

-- Lymph-Vascular Invasion  
  `lymph_vascular_major_vessel_invasion` varchar(50) DEFAULT NULL,
  `lymph_vascular_small_vessel_invasion` varchar(50) DEFAULT NULL,  
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `cirrhosis_severe_fibrosis` tinyint(1) NOT NULL DEFAULT 0,    
  `primary_sclerosing_cholangitis` tinyint(1) NOT NULL DEFAULT 0, 
  `biliary_stones` tinyint(1) NOT NULL DEFAULT 0, 
  `chronic_hepatitis` tinyint(1) NOT NULL DEFAULT 0, 
  `specify_type` varchar(250) DEFAULT NULL,  
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  `none_identified` tinyint(1) NOT NULL DEFAULT 0, 
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `cirrhosis`  tinyint(1) NOT NULL DEFAULT 0,
  `cli_primary_sclerosing_cholangitis` tinyint(1) NOT NULL DEFAULT 0,
  `inflammatory_bowel_disease` tinyint(1) NOT NULL DEFAULT 0,
  `hepatitis_c_infection` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NOT NULL DEFAULT 0,  
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `not_known` tinyint(1) NOT NULL DEFAULT 0,
  `comments` varchar(250) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `dxd_cap_report_intrahepbileducts` ADD CONSTRAINT `FK_dxd_cap_report_intrahepbileducts_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_intrahepbileducts_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_intrahepbileducts_revs`;

CREATE TABLE `dxd_cap_report_intrahepbileducts_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
-- specimen
  `liver` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,  
-- procedure  
  `wedge_resection` tinyint(1) NULL DEFAULT 0,
  `partial_hepatectomy` tinyint(1) NULL DEFAULT 0,
  `major_hepatectomy_3_segments_or_more` tinyint(1) NULL DEFAULT 0,
  `minor_hepatectomy_less_than_3_segments` tinyint(1) NULL DEFAULT 0,
  `total_hepatectomy` tinyint(1) NULL DEFAULT 0,  
  `procedure_other` tinyint(1) NULL DEFAULT 0,
  `procedure_other_specify` varchar(250) DEFAULT NULL,
  `procedure_not_specified` tinyint(1) NULL DEFAULT 0, 
  
-- tumor size in master  
-- tumor focality
  `solitary` tinyint(1) NULL DEFAULT 0,
  `specify_location` varchar(250) DEFAULT NULL,
  `multiple` tinyint(1) NULL DEFAULT 0,
  `specify_locations` varchar(250) DEFAULT NULL,
  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters   tumor_grade and tumor_grade_specify
-- Tumor Growth Pattern
  `tumor_growth_pattern` varchar(50) DEFAULT NULL,
-- Microscopic Tumor Extension
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_the_intrahepatic_bile_ducts_histologically` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_hepatic_parenchyma` tinyint(1) NULL DEFAULT 0,    
  `tumor_involves_visceral_peritoneal_surface` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_adjacent_organs_other_than_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_extension_specify` varchar(250) DEFAULT NULL,  
-- Margins  
  `hp_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1)NULL DEFAULT 0.0,
  `hp_specify_margin` varchar(250) DEFAULT NULL,
  `involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  
  `bd_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `db_margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `dysplasia_carcinoma_in_situ_not_identified` tinyint(1) NULL DEFAULT 0, 
  `dysplasia_carcinoma_in_situ_present` tinyint(1) NULL DEFAULT 0, 
  `bd_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  
  `specify_margin` varchar(250) DEFAULT NULL, 
  `special_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `special_margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `special_margin_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,    

-- Lymph-Vascular Invasion  
  `lymph_vascular_major_vessel_invasion` varchar(50) DEFAULT NULL,
  `lymph_vascular_small_vessel_invasion` varchar(50) DEFAULT NULL,  
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `cirrhosis_severe_fibrosis` tinyint(1) NOT NULL DEFAULT 0,    
  `primary_sclerosing_cholangitis` tinyint(1) NOT NULL DEFAULT 0, 
  `biliary_stones` tinyint(1) NOT NULL DEFAULT 0, 
  `chronic_hepatitis` tinyint(1) NOT NULL DEFAULT 0, 
  `specify_type` varchar(250) DEFAULT NULL,  
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  `none_identified` tinyint(1) NOT NULL DEFAULT 0, 
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `cirrhosis`  tinyint(1) NOT NULL DEFAULT 0,
  `cli_primary_sclerosing_cholangitis` tinyint(1) NOT NULL DEFAULT 0,
  `inflammatory_bowel_disease` tinyint(1) NOT NULL DEFAULT 0,
  `hepatitis_c_infection` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NOT NULL DEFAULT 0,  
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `not_known` tinyint(1) NOT NULL DEFAULT 0,
  `comments` varchar(250) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- insert value in diagnosis_controls
insert into diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename)
values
('cap report - intrahep bile ducts', 1, 'dx_cap_report_intrahepbileducts', 'dxd_cap_report_intrahepbileducts');

-- The table structures hold all forms in the application, Add the dxd_cap_report_ in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_intrahepbileducts', '', '', '0', '0', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'liver', 'liver', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'wedge_resection', 'wedge resection', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'partial_hepatectomy', 'partial hepatectomy', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'major_hepatectomy_3_segments_or_more', 'major hepatectomy 3 segments or more', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'minor_hepatectomy_less_than_3_segments', 'minor hepatectomy less than 3 segments', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'total_hepatectomy', 'total hepatectomy', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'procedure_other', 'procedure other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'procedure_other_specify', '', 'procedure other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'procedure_not_specified', 'procedure not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'solitary', 'solitary', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'specify_location', '', 'specify location', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'multiple', 'multiple', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'specify_locations', '', 'specify locations', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'tumor_growth_pattern', 'tumor growth pattern', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'no_evidence_of_primary_tumor', 'no evidence of primary tumor', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'tumor_confined_to_the_intrahepatic_bile_ducts_histologically', 'tumor confined to the intrahepatic bile ducts histologically', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'tumor_confined_to_hepatic_parenchyma', 'tumor confined to hepatic parenchyma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'tumor_involves_visceral_peritoneal_surface', 'tumor involves visceral peritoneal surface', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'tumor_directly_invades_gallbladder', 'tumor directly invades gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'tumor_directly_invades_adjacent_organs_other_than_gallbladder', 'tumor directly invades adjacent organs other than gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'tumor_extension_specify', 'tumor extension specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'hp_margin_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'uninvolved_by_invasive_carcinoma', 'uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'distance_of_invasive_carcinoma_from_closest_margin_mm', 'distance of invasive carcinoma from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'hp_specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'involved_by_invasive_carcinoma', 'involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'bd_margin_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'db_margin_uninvolved_by_invasive_carcinoma', 'uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'dysplasia_carcinoma_in_situ_not_identified', 'dysplasia carcinoma in situ not identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'dysplasia_carcinoma_in_situ_present', 'dysplasia carcinoma in situ present', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'bd_involved_by_invasive_carcinoma', 'involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'special_margin_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'special_margin_uninvolved_by_invasive_carcinoma', 'uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'special_margin_involved_by_invasive_carcinoma', 'involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'lymph_vascular_major_vessel_invasion', 'lymph vascular major vessel invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'lymph_vascular_small_vessel_invasion', 'lymph vascular small vessel invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'perineural_invasion', 'perineural invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_ibd', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_ibd', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_ibd', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'cirrhosis_severe_fibrosis', 'cirrhosis severe fibrosis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'primary_sclerosing_cholangitis', 'primary sclerosing cholangitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'biliary_stones', 'biliary stones', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'chronic_hepatitis', 'chronic hepatitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'additional_path_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'cirrhosis', 'cirrhosis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'inflammatory_bowel_disease', 'inflammatory bowel disease', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'hepatitis_c_infection', 'hepatitis c infection', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'not_known', 'not known', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_ibd', 'tumour_grade', 'tumour grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'specify_type', '', 'specify type', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'cli_primary_sclerosing_cholangitis', 'primary sclerosing cholangitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'other_clinical_history', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_intrahepbileducts', 'other_clinical_history_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='liver' AND `language_label`='liver' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='wedge_resection' AND `language_label`='wedge resection' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='partial_hepatectomy' AND `language_label`='partial hepatectomy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='major_hepatectomy_3_segments_or_more' AND `language_label`='major hepatectomy 3 segments or more' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='minor_hepatectomy_less_than_3_segments' AND `language_label`='minor hepatectomy less than 3 segments' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='total_hepatectomy' AND `language_label`='total hepatectomy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='procedure_other' AND `language_label`='procedure other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='procedure_other_specify' AND `language_label`='' AND `language_tag`='procedure other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='procedure_not_specified' AND `language_label`='procedure not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '16', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' ), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='solitary' AND `language_label`='solitary' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='specify_location' AND `language_label`='' AND `language_tag`='specify location' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='multiple' AND `language_label`='multiple' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='specify_locations' AND `language_label`='' AND `language_tag`='specify locations' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade_specify' AND `structure_value_domain`  IS NULL  ), '1', '26', '', '1', 'tumour grade specify', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='tumor_growth_pattern' AND `language_label`='tumor growth pattern' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='no_evidence_of_primary_tumor' AND `language_label`='no evidence of primary tumor' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='tumor_confined_to_the_intrahepatic_bile_ducts_histologically' AND `language_label`='tumor confined to the intrahepatic bile ducts histologically' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='tumor_confined_to_hepatic_parenchyma' AND `language_label`='tumor confined to hepatic parenchyma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='tumor_involves_visceral_peritoneal_surface' AND `language_label`='tumor involves visceral peritoneal surface' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='tumor_directly_invades_gallbladder' AND `language_label`='tumor directly invades gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='tumor_directly_invades_adjacent_organs_other_than_gallbladder' AND `language_label`='tumor directly invades adjacent organs other than gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='tumor_extension_specify' AND `language_label`='tumor extension specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='hp_margin_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='uninvolved_by_invasive_carcinoma' AND `language_label`='uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_mm' AND `language_label`='distance of invasive carcinoma from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='hp_specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='involved_by_invasive_carcinoma' AND `language_label`='involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='bd_margin_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='db_margin_uninvolved_by_invasive_carcinoma' AND `language_label`='uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='dysplasia_carcinoma_in_situ_not_identified' AND `language_label`='dysplasia carcinoma in situ not identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='dysplasia_carcinoma_in_situ_present' AND `language_label`='dysplasia carcinoma in situ present' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='bd_involved_by_invasive_carcinoma' AND `language_label`='involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='special_margin_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='special_margin_uninvolved_by_invasive_carcinoma' AND `language_label`='uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='special_margin_involved_by_invasive_carcinoma' AND `language_label`='involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='lymph_vascular_major_vessel_invasion' AND `language_label`='lymph vascular major vessel invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='lymph_vascular_small_vessel_invasion' AND `language_label`='lymph vascular small vessel invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' ), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' ), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' ), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_ibd' AND `field`='path_tstage' AND `language_label`='path tstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_ibd' AND `field`='path_nstage' AND `language_label`='path nstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `structure_value_domain`  IS NULL  ), '2', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `structure_value_domain`  IS NULL  ), '2', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_ibd' AND `field`='path_mstage' AND `language_label`='path mstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `structure_value_domain`  IS NULL  ), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='cirrhosis_severe_fibrosis' AND `language_label`='cirrhosis severe fibrosis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='primary_sclerosing_cholangitis' AND `language_label`='primary sclerosing cholangitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='biliary_stones' AND `language_label`='biliary stones' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='chronic_hepatitis' AND `language_label`='chronic hepatitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '69', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='cirrhosis' AND `language_label`='cirrhosis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='inflammatory_bowel_disease' AND `language_label`='inflammatory bowel disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='hepatitis_c_infection' AND `language_label`='hepatitis c infection' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='not_known' AND `language_label`='not known' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '78', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_ibd' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '17', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='specify_type' AND `language_label`='' AND `language_tag`='specify type' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='cli_primary_sclerosing_cholangitis' AND `language_label`='primary sclerosing cholangitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');




-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='liver'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='procedure'
where sfi.id=sfo.structure_field_id
and sfi.field='wedge_resection'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor focality'
where sfi.id=sfo.structure_field_id
and sfi.field='solitary'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='microscopic tumor extension'
where sfi.id=sfo.structure_field_id
and sfi.field='cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='hepatic parenchymal margin'
where sfi.id=sfo.structure_field_id
and sfi.field='hp_margin_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='bile duct margin'
where sfi.id=sfo.structure_field_id
and sfi.field='bd_margin_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='other margin'
where sfi.id=sfo.structure_field_id
and sfi.field='specify_margin'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='lymph vascular invasion'
where sfi.id=sfo.structure_field_id
and sfi.field='lymph_vascular_major_vessel_invasion'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='cirrhosis_severe_fibrosis'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='cirrhosis'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_intrahepbileducts'; 


-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_intrahepbileducts'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');


-- dropdown list for select
-- invasion 
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_intrahepbileducts' and field='lymph_vascular_major_vessel_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_intrahepbileducts' and field='lymph_vascular_small_vessel_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_intrahepbileducts' and field='perineural_invasion';


-- histologic_type_ibd
insert ignore into structure_permissible_values (value, language_alias) values
('cholangiocarcinoma','cholangiocarcinoma'),
('combined hepatocellular and cholangiocarcinoma','combined hepatocellular and cholangiocarcinoma'),
('bile duct cystadenocarcinoma','bile duct cystadenocarcinoma');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_ibd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_ibd'), (select id from structure_permissible_values where value='cholangiocarcinoma'), 1,1, 'cholangiocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_ibd'), (select id from structure_permissible_values where value='combined hepatocellular and cholangiocarcinoma'), 2,1, 'combined hepatocellular and cholangiocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_ibd'), (select id from structure_permissible_values where value='bile duct cystadenocarcinoma'), 3,1, 'bile duct cystadenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_ibd'), (select id from structure_permissible_values where value='other'), 4,1, 'other');

select * from structure_fields
where tablename='dxd_cap_report_intrahepbileducts' and field='histologic_type';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_ibd')
where tablename='dxd_cap_report_intrahepbileducts' and field='histologic_type';

-- histologic_grade_ibd
insert ignore into structure_permissible_values (value, language_alias) values
('gx','gx: cannot be assessed'),
('gi','gi: well differentiated'),
('gii','gii: moderately differentiated'),
('giii','giii: poorly differentiated'),
('giv','giv: undifferentiated');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_ibd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_ibd'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_ibd'), (select id from structure_permissible_values where value='gx'), 2,1,'gx: cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_ibd'), (select id from structure_permissible_values where value='gi'), 3,1, 'gi: well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_ibd'), (select id from structure_permissible_values where value='gii'), 4,1,'gii: moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_ibd'), (select id from structure_permissible_values where value='giii'), 5,1,'giii: poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_ibd'), (select id from structure_permissible_values where value='giv'), 6,1,'giv: undifferentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_ibd'), (select id from structure_permissible_values where value='other'), 7,1,'other');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_ibd')
where tablename='diagnosis_masters_ibd' and field='tumour_grade';

-- tumour_growth_pattern
insert ignore into structure_permissible_values (value, language_alias) values
('mass-forming','mass-forming'),
('periductal infiltrating','periductal infiltrating'),
('mixed mass-forming and periductal infiltrating','mixed mass-forming and periductal infiltrating'),
('cannot be determined','cannot be determined'),
('insert ignore into structure_permissible_values (value, language_alias) values','insert ignore into structure_permissible_values (value, language_alias) values');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('tumor_growth_pattern', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='tumor_growth_pattern'), (select id from structure_permissible_values where value='mass-forming'), 1,1, 'mass-forming'),
((select id from structure_value_domains where domain_name='tumor_growth_pattern'), (select id from structure_permissible_values where value='periductal infiltrating'), 2,1, 'periductal infiltrating'),
((select id from structure_value_domains where domain_name='tumor_growth_pattern'), (select id from structure_permissible_values where value='mixed mass-forming and periductal infiltrating'), 3,1, 'mixed mass-forming and periductal infiltrating'),
((select id from structure_value_domains where domain_name='tumor_growth_pattern'), (select id from structure_permissible_values where value='cannot be determined'), 4,1, 'cannot be determined'),
((select id from structure_value_domains where domain_name='tumor_growth_pattern'), (select id from structure_permissible_values where value='insert ignore into structure_permissible_values (value, language_alias) values' ), 5,1, 'insert ignore into structure_permissible_values (value, language_alias) values');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='tumor_growth_pattern')
where tablename='dxd_cap_report_intrahepbileducts' and field='tumor_growth_pattern';

-- primary tumor (pt) path_tstage_ibd
insert ignore into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0', 'pt0: no evidence of primary tumor'),
('ptis', 'ptis: carcinoma in situ (intraductal tumor)'),
('pt1', 'pt1: solitary tumor without vascular invasion'),
('pt2a', 'pt2a: solitary tumor with vascular invasion'),
('pt2b', 'pt2b: multiple tumors, with or without vascular invasion'),
('pt3', 'pt3: tumor perforating the visceral peritoneum or involving the local extrahepatic structures by direct invasion'),
('pt4', 'pt4: tumor with periductal invasion');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_ibd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: cannot be assessed'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='ptis' and language_alias='ptis: carcinoma in situ (intraductal tumor)'), 3,1, 'ptis: carcinoma in situ (intraductal tumor)'),
((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='pt1'  and language_alias='pt1: solitary tumor without vascular invasion'), 4,1, 'pt1: solitary tumor without vascular invasion'),
((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='pt2a' and language_alias='pt2a: solitary tumor with vascular invasion'), 5,1, 'pt2a: solitary tumor with vascular invasion'),
((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='pt2b' and language_alias='pt2b: tumor invades adjacent hepatic parenchyma'), 6,1, 'pt2b: tumor invades adjacent hepatic parenchyma'),
((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='pt3' and language_alias='pt3: tumor perforating the visceral peritoneum or involving the local extrahepatic structures by direct invasion'), 7,1, 'pt3: tumor perforating the visceral peritoneum or involving the local extrahepatic structures by direct invasion'),
((select id from structure_value_domains where domain_name='path_tstage_ibd'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor with periductal invasion'), 8,1, 'pt4: tumor with periductal invasion');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_ibd')
where tablename='diagnosis_masters_ibd' and field='path_tstage';


-- regional lymph nodes (pn) path_nstage_ibd
insert ignore into structure_permissible_values (value, language_alias) values
('pnx', 'pnx: cannot be assessed'),
('pn0', 'pn0: no regional lymph node metastasis'),
('pn1', 'pn1: regional lymph node metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_ibd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_ibd'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_ibd'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: no regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_ibd'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: regional lymph node metastasis'), 3,1, 'pn1: regional lymph node metastasis');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_ibd')
where tablename='diagnosis_masters_ibd' and field='path_nstage';


-- distant metastasis (pm) path_mstage_ibd
insert ignore into structure_permissible_values (value, language_alias) values
('pm1', 'pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_ibd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_ibd'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_ibd'), (select id from structure_permissible_values where value='pm1'), 2,1, 'pm1: distant metastasis');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_ibd')
where tablename='diagnosis_masters_ibd' and field='path_mstage';


