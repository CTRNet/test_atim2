
/*Table structure for table 'dxd_cap_report_distalexbileducts' */

DROP TABLE IF EXISTS `dxd_cap_report_distalexbileducts`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_distalexbileducts` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NULL DEFAULT 0,
-- specimen
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `right_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `left_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `junction_of_right_and_left_hepatic_ducts` tinyint(1) NULL DEFAULT 0,
  `common_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `cystic_duct` tinyint(1) NULL DEFAULT 0,
  `not_specified` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `pancreas` tinyint(1) NULL DEFAULT 0,
  `ampulla` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
-- procedure  
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- tumor site  
  `tumor_site_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `extrapancreatic` tinyint(1) NULL DEFAULT 0,
  `intrapancreatic` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other_specify` varchar(250) DEFAULT NULL,
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,    
-- tumor size in master  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters  
-- Microscopic Tumor Extension
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_the_bile_duct_histologically` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_beyond_the_wall_of_the_bile_duct` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_duodenum` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_pancreas` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_gallbladder` tinyint(1) NULL DEFAULT 0,     
  `tumor_invades_other_adjacent_structures` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_specify` varchar(250) DEFAULT NULL, 
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `specify_margin` varchar(250) DEFAULT NULL,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `proximal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `distal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin`  tinyint(1) NULL DEFAULT 0,
  `dysplasia_carcinoma_in_situ_present_at_bile_duct_margin` tinyint(1) NULL DEFAULT 0,  
 
  `proximal_margin` varchar(50) DEFAULT NULL, 
  
  `distal_margin` varchar(50) DEFAULT NULL,   
  `pancreatic_retroperitoneal_margin` varchar(50) DEFAULT NULL,   
  `bile_duct_margin` varchar(50) DEFAULT NULL,   
  `distal_pancreatic_margin` varchar(50) DEFAULT NULL,    
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1) DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `n_specify_margin` varchar(250) DEFAULT NULL,
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `choledochal_cyst` tinyint(1) NULL DEFAULT 0, 
  `dysplasia` tinyint(1) NULL DEFAULT 0, 
  `primary_sclerosing_cholangitis` tinyint(1) NULL DEFAULT 0, 
  `stones` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `primary_sclerosing_cholangitis_PSC`  tinyint(1) NULL DEFAULT 0,
  `inflammatory_bowel_disease` tinyint(1) NULL DEFAULT 0,
  `biliary_stones` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
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

ALTER TABLE `dxd_cap_report_distalexbileducts` ADD CONSTRAINT `FK_dxd_cap_report_distalexbileducts_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_distalexbileducts_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_distalexbileducts_revs`;

CREATE TABLE `dxd_cap_report_distalexbileducts_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NULL DEFAULT 0,
-- specimen
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `right_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `left_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `junction_of_right_and_left_hepatic_ducts` tinyint(1) NULL DEFAULT 0,
  `common_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `cystic_duct` tinyint(1) NULL DEFAULT 0,
  `not_specified` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `pancreas` tinyint(1) NULL DEFAULT 0,
  `ampulla` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
-- procedure  
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- tumor site  
  `tumor_site_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `extrapancreatic` tinyint(1) NULL DEFAULT 0,
  `intrapancreatic` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other_specify` varchar(250) DEFAULT NULL,
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,    
-- tumor size in master  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters  
-- Microscopic Tumor Extension
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_the_bile_duct_histologically` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_beyond_the_wall_of_the_bile_duct` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_duodenum` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_pancreas` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_gallbladder` tinyint(1) NULL DEFAULT 0,     
  `tumor_invades_other_adjacent_structures` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_specify` varchar(250) DEFAULT NULL, 
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `specify_margin` varchar(250) DEFAULT NULL,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `proximal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `distal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin`  tinyint(1) NULL DEFAULT 0,
  `dysplasia_carcinoma_in_situ_present_at_bile_duct_margin` tinyint(1) NULL DEFAULT 0,  
 
  `proximal_margin` varchar(50) DEFAULT NULL, 
  
  `distal_margin` varchar(50) DEFAULT NULL,   
  `pancreatic_retroperitoneal_margin` varchar(50) DEFAULT NULL,   
  `bile_duct_margin` varchar(50) DEFAULT NULL,   
  `distal_pancreatic_margin` varchar(50) DEFAULT NULL,    
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1) DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `n_specify_margin` varchar(250) DEFAULT NULL,
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `choledochal_cyst` tinyint(1) NULL DEFAULT 0, 
  `dysplasia` tinyint(1) NULL DEFAULT 0, 
  `primary_sclerosing_cholangitis` tinyint(1) NULL DEFAULT 0, 
  `stones` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `primary_sclerosing_cholangitis_PSC`  tinyint(1) NULL DEFAULT 0,
  `inflammatory_bowel_disease` tinyint(1) NULL DEFAULT 0,
  `biliary_stones` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
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
('cap report - distal ex bile ducts', 1, 'dx_cap_report_distalexbileducts', 'dxd_cap_report_distalexbileducts');

-- The table structures hold all forms in the application, Add the dxd_cap_report_ in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_distalexbileducts', '', '', '0', '0', '1', '1');

-- form builder
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'common_bile_duct', 'common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'right_hepatic_duct', 'right hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'left_hepatic_duct', 'left hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'junction_of_right_and_left_hepatic_ducts', 'junction of right and left hepatic ducts', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'common_hepatic_duct', 'common hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'cystic_duct', 'cystic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'stomach', 'stomach', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'duodenum', 'duodenum', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'pancreas', 'pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'ampulla', 'ampulla', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'procedure', 'procedure', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'procedure_specify', 'procedure specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_site_common_bile_duct', 'common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'extrapancreatic', '', 'extrapancreatic', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'intrapancreatic', '', 'intrapancreatic', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_site_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_site_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_site_not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_dbd', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'carcinoma_in_situ', 'carcinoma in situ', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_confined_to_the_bile_duct_histologically', 'tumor confined to the bile duct histologically', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_invades_beyond_the_wall_of_the_bile_duct', 'tumor invades beyond the wall of the bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_invades_the_duodenum', 'tumor invades the duodenum', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_invades_the_pancreas', 'tumor invades the pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_invades_the_gallbladder', 'tumor invades the gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_invades_other_adjacent_structures', 'tumor invades other adjacent structures', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'tumor_invades_specify', '', ' specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'margins_uninvolved_by_invasive_carcinoma', 'margins uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'distance_of_invasive_carcinoma_from_closest_margin_mm', 'distance of invasive carcinoma from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'margins_involved_by_invasive_carcinoma', 'margins involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'proximal_bile_duct_margin', 'proximal bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'distal_bile_duct_margin', 'distal bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'margin_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'margin_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin', 'dysplasia carcinoma in situ not identified at bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'dysplasia_carcinoma_in_situ_present_at_bile_duct_margin', 'dysplasia carcinoma in situ present at bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'proximal_margin', 'proximal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'distal_margin', 'distal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'pancreatic_retroperitoneal_margin', 'pancreatic retroperitoneal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'bile_duct_margin', 'bile duct margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'distal_pancreatic_margin', 'distal pancreatic margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'distance_of_invasive_carcinoma_from_closest_margin', 'distance of invasive carcinoma from closest margin', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'distance_unit', 'distance unit', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'n_specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'perineural_invasion', 'perineural invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_dbd', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_dbd', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'additional_path_none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'choledochal_cyst', 'choledochal cyst', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'dysplasia', 'dysplasia', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'primary_sclerosing_cholangitis', 'primary sclerosing cholangitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'stones', 'stones', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'additional_path_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'primary_sclerosing_cholangitis_PSC', 'primary sclerosing cholangitis PSC', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'inflammatory_bowel_disease', 'inflammatory bowel disease', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'biliary_stones', 'biliary stones', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'other_clinical_history', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_distalexbileducts', 'other_clinical_history_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_dbd', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='right_hepatic_duct' AND `language_label`='right hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='left_hepatic_duct' AND `language_label`='left hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='junction_of_right_and_left_hepatic_ducts' AND `language_label`='junction of right and left hepatic ducts' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='common_hepatic_duct' AND `language_label`='common hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='cystic_duct' AND `language_label`='cystic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='stomach' AND `language_label`='stomach' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='duodenum' AND `language_label`='duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='pancreas' AND `language_label`='pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='ampulla' AND `language_label`='ampulla' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_site_common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='extrapancreatic' AND `language_label`='' AND `language_tag`='extrapancreatic' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='intrapancreatic' AND `language_label`='' AND `language_tag`='intrapancreatic' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_site_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_site_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_site_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '24', '', '1', 'greatest dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '25', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '26', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' ), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_dbd' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='carcinoma_in_situ' AND `language_label`='carcinoma in situ' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_confined_to_the_bile_duct_histologically' AND `language_label`='tumor confined to the bile duct histologically' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_invades_beyond_the_wall_of_the_bile_duct' AND `language_label`='tumor invades beyond the wall of the bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_invades_the_duodenum' AND `language_label`='tumor invades the duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_invades_the_pancreas' AND `language_label`='tumor invades the pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_invades_the_gallbladder' AND `language_label`='tumor invades the gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_invades_other_adjacent_structures' AND `language_label`='tumor invades other adjacent structures' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='tumor_invades_specify' AND `language_label`='' AND `language_tag`=' specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='margins_uninvolved_by_invasive_carcinoma' AND `language_label`='margins uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_mm' AND `language_label`='distance of invasive carcinoma from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='margins_involved_by_invasive_carcinoma' AND `language_label`='margins involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='proximal_bile_duct_margin' AND `language_label`='proximal bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='distal_bile_duct_margin' AND `language_label`='distal bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='margin_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='margin_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin' AND `language_label`='dysplasia carcinoma in situ not identified at bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='dysplasia_carcinoma_in_situ_present_at_bile_duct_margin' AND `language_label`='dysplasia carcinoma in situ present at bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='proximal_margin' AND `language_label`='proximal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='distal_margin' AND `language_label`='distal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='pancreatic_retroperitoneal_margin' AND `language_label`='pancreatic retroperitoneal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='bile_duct_margin' AND `language_label`='bile duct margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='distal_pancreatic_margin' AND `language_label`='distal pancreatic margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='distance_of_invasive_carcinoma_from_closest_margin' AND `language_label`='distance of invasive carcinoma from closest margin' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='distance_unit' AND `language_label`='distance unit' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='n_specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' ), '2', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' ), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' ), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_dbd' AND `field`='path_tstage' AND `language_label`='path tstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_dbd' AND `field`='path_nstage' AND `language_label`='path nstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `structure_value_domain`  IS NULL  ), '2', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `structure_value_domain`  IS NULL  ), '2', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `structure_value_domain`  IS NULL  ), '2', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='additional_path_none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '69', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='choledochal_cyst' AND `language_label`='choledochal cyst' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='dysplasia' AND `language_label`='dysplasia' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='primary_sclerosing_cholangitis' AND `language_label`='primary sclerosing cholangitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='stones' AND `language_label`='stones' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='primary_sclerosing_cholangitis_PSC' AND `language_label`='primary sclerosing cholangitis PSC' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='inflammatory_bowel_disease' AND `language_label`='inflammatory bowel disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='biliary_stones' AND `language_label`='biliary stones' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '79', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '82', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_dbd' AND `field`='path_mstage' AND `language_label`='path mstage' ), '2', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');



-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- validation distance_unit
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_distalexbileducts' AND `field`='distance_unit' AND `type`='select'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='common_bile_duct'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site_common_bile_duct'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='microscopic tumor extension'
where sfi.id=sfo.structure_field_id
and sfi.field='carcinoma_in_situ'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margins'
where sfi.id=sfo.structure_field_id
and sfi.field='cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pancreaticoduodenal resection specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='proximal_margin'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='if all margins uninvolved by invasive carcinoma:'
where sfi.id=sfo.structure_field_id
and sfi.field='distance_of_invasive_carcinoma_from_closest_margin'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='primary_sclerosing_cholangitis_psc'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_distalexbileducts'; 

-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_distalexbileducts'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');


-- dropdown list for select
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_cap_report_distalexbileducts' and field='distance_unit';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_distalexbileducts' and field='lymph_vascular_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_distalexbileducts' and field='perineural_invasion';

-- procedure_dxd_dbd
insert ignore into structure_permissible_values (value, language_alias) values
('pancreaticoduodenectomy','pancreaticoduodenectomy'),
('segmental resection of bile ducts(s)','segmental resection of bile ducts(s)'),
('choledochal cyst resection (Note B)','choledochal cyst resection (Note B)'),
('total hepatectomy','total hepatectomy');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_dbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='pancreaticoduodenectomy'), 1,1, 'pancreaticoduodenectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='segmental resection of bile ducts(s)'), 2,1, 'segmental resection of bile ducts(s)'),
((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='choledochal cyst resection (Note B)'), 3,1, 'choledochal cyst resection (Note B)'),
((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='other'), 5,1, 'other'),
((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='not specified'), 6,1, 'not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure_dxd_dbd')
where tablename='dxd_cap_report_distalexbileducts' and field='procedure';

-- histologic_type_dbd
insert ignore into structure_permissible_values (value, language_alias) values
('adenocarcinoma (not otherwise characterized)','adenocarcinoma (not otherwise characterized)'),
('papillary adenocarcinoma','papillary adenocarcinoma'),
('mucinous adenocarcinoma','mucinous adenocarcinoma'),
('clear cell adenocarcinoma','clear cell adenocarcinoma'),
('signet-ring cell carcinoma','signet-ring cell carcinoma'),
('adenosquamous carcinoma','adenosquamous carcinoma'),
('squamous cell carcinoma','squamous cell carcinoma'),
('small cell carcinoma','small cell carcinoma'),
('large cell carcinoma','large cell carcinoma'),
('biliary cystadenocarcinoma','biliary cystadenocarcinoma'),
('carcinoma, type cannot be determined','carcinoma, type cannot be determined');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_dbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='adenocarcinoma (not otherwise characterized)'), 1,1, 'adenocarcinoma (not otherwise characterized)'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='papillary adenocarcinoma'), 2,1, 'papillary adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='mucinous adenocarcinoma'), 3,1, 'mucinous adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='clear cell adenocarcinoma'), 4,1, 'clear cell adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='signet-ring cell carcinoma'), 5,1, 'signet-ring cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='adenosquamous carcinoma'), 6,1, 'adenosquamous carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='squamous cell carcinoma'), 7,1, 'squamous cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='small cell carcinoma'), 8,1, 'small cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='large cell carcinoma'), 8,1, 'large cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='biliary cystadenocarcinoma'), 9,1, 'biliary cystadenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='other'), 10,1, 'other'),
((select id from structure_value_domains where domain_name='histologic_type_dbd'), (select id from structure_permissible_values where value='carcinoma, type cannot be determined'), 11,1, 'carcinoma, type cannot be determined');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_dbd')
where tablename='dxd_cap_report_distalexbileducts' and field='histologic_type';

-- histologic_grade_dbd
insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_dbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_dbd'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_dbd'), (select id from structure_permissible_values where value='gx'), 2,1,'gx: cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_dbd'), (select id from structure_permissible_values where value='g1'), 3,1, 'g1: well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_dbd'), (select id from structure_permissible_values where value='g2'), 4,1,'g2: moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_dbd'), (select id from structure_permissible_values where value='g3'), 5,1,'g3: poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_dbd'), (select id from structure_permissible_values where value='g4'), 6,1,'g4:undifferentiated');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_dbd')
where tablename='diagnosis_masters_dbd' and field='tumour_grade';


-- margin_cannot

insert ignore into structure_permissible_values (value, language_alias) values
('cannot be assessed','cannot be assessed'),
('uninvolved by invasive carcinoma','uninvolved by invasive carcinoma'),
('involved by invasive carcinoma','involved by invasive carcinoma');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('margin_cannot', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='margin_cannot'), (select id from structure_permissible_values where value='cannot be assessed' ), 1,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='margin_cannot'), (select id from structure_permissible_values where value='uninvolved by invasive carcinoma' ), 2,1, 'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='margin_cannot'), (select id from structure_permissible_values where value='involved by invasive carcinoma' ), 3,1, 'involved by invasive carcinoma');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_cannot')
where tablename='dxd_cap_report_distalexbileducts' and field='proximal_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_cannot')
where tablename='dxd_cap_report_distalexbileducts' and field='distal_margin';

-- margin_0_1
insert ignore into structure_permissible_values (value, language_alias) values
('not applicable','not applicable'),
('involved by invasive carcinoma (tumor present 0-1 mm from margin)','involved by invasive carcinoma (tumor present 0-1 mm from margin)');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('margin_0_1', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='margin_0_1'), (select id from structure_permissible_values where value='not applicable' ), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='margin_0_1'), (select id from structure_permissible_values where value='cannot be assessed' ), 2,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='margin_0_1'), (select id from structure_permissible_values where value='uninvolved by invasive carcinoma' ), 3,1, 'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='margin_0_1'), (select id from structure_permissible_values where value='involved by invasive carcinoma (tumor present 0-1 mm from margin)' ), 4,1, 'involved by invasive carcinoma (tumor present 0-1 mm from margin)');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_0_1')
where tablename='dxd_cap_report_distalexbileducts' and field='pancreatic_retroperitoneal_margin';

-- margin_not_applicable
insert ignore into structure_permissible_values (value, language_alias) values
('not applicable','not applicable'),
('cannot be assessed','cannot be assessed'),
('margin uninvolved by invasive carcinoma','margin uninvolved by invasive carcinoma'),
('margin involved by invasive carcinoma','margin involved by invasive carcinoma');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('margin_not_applicable', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='margin_not_applicable'), (select id from structure_permissible_values where value='not applicable' ), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='margin_not_applicable'), (select id from structure_permissible_values where value='cannot be assessed' ), 2,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='margin_not_applicable'), (select id from structure_permissible_values where value='margin uninvolved by invasive carcinoma' ), 3,1, 'margin uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='margin_not_applicable'), (select id from structure_permissible_values where value='margin involved by invasive carcinoma' ), 4,1, 'margin involved by invasive carcinoma');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_not_applicable')
where tablename='dxd_cap_report_distalexbileducts' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_not_applicable')
where tablename='dxd_cap_report_distalexbileducts' and field='distal_pancreatic_margin';

-- primary tumor (pt) path_tstage_dbd
insert ignore into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0', 'pt0: no evidence of primary tumor'),
('ptis', 'ptis: carcinoma in situ'),
('pt1', 'pt1: tumor confined to the bile duct histologically'),
('pt2', 'pt2: tumor invades beyond the wall of the bile duct'),
('pt3', 'pt3: tumor invades the gallbladder, pancreas, duodenum, or other adjacent organs without involvement of the celiac axis or the superior mesenteric artery'),
('pt4', 'pt4: tumor involves the celiac axis or the superior mesenteric artery');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_dbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_dbd'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: cannot be assessed'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_dbd'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_dbd'), (select id from structure_permissible_values where value='ptis' and language_alias='ptis: carcinoma in situ'), 3,1, 'ptis: carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_dbd'), (select id from structure_permissible_values where value='pt1'  and language_alias='pt1: tumor confined to the bile duct histologically'), 4,1, 'pt1: tumor confined to the bile duct histologically'),
((select id from structure_value_domains where domain_name='path_tstage_dbd'), (select id from structure_permissible_values where value='pt2' and language_alias='pt2: tumor invades beyond the wall of the bile duct'), 5,1, 'pt2: tumor invades beyond the wall of the bile duct'),
((select id from structure_value_domains where domain_name='path_tstage_dbd'), (select id from structure_permissible_values where value='pt3' and language_alias='pt3: tumor invades the gallbladder, pancreas, duodenum, or other adjacent organs without involvement of the celiac axis or the superior mesenteric artery'), 7,1, 'pt3: tumor invades the gallbladder, pancreas, duodenum, or other adjacent organs without involvement of the celiac axis or the superior mesenteric artery'),
((select id from structure_value_domains where domain_name='path_tstage_dbd'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor involves the celiac axis or the superior mesenteric artery'), 8,1, 'pt4: tumor involves the celiac axis or the superior mesenteric artery');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_dbd')
where tablename='diagnosis_masters_dbd' and field='path_tstage';


-- regional lymph nodes (pn) path_nstage_dbd
insert ignore into structure_permissible_values (value, language_alias) values
('pnx', 'pnx: cannot be assessed'),
('pn0', 'pn0: no regional lymph node metastasis'),
('pn1', 'pn1: regional lymph node metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_dbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_dbd'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_dbd'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: no regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_dbd'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: regional lymph node metastasis'), 3,1, 'pn1: regional lymph node metastasis');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_dbd')
where tablename='diagnosis_masters_dbd' and field='path_nstage';


-- distant metastasis (pm) path_mstage_dbd
insert ignore into structure_permissible_values (value, language_alias) values
('pm1', 'pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_dbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_dbd'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_dbd'), (select id from structure_permissible_values where value='pm1'), 2,1, 'pm1: distant metastasis');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_dbd')
where tablename='diagnosis_masters_dbd' and field='path_mstage';

